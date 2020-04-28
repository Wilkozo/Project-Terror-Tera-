using System;
using Digger.TerrainCutters;
using Unity.Burst;
using Unity.Collections;
using Unity.Jobs;
using Unity.Mathematics;
using UnityEngine;

namespace Digger
{
    [BurstCompile(CompileSynchronously = true, FloatMode = FloatMode.Fast)]
    public struct VoxelModificationJob : IJobParallelFor
    {
        public int SizeVox;
        public int SizeVox2;
        public int SizeOfMesh;
        public BrushType Brush;
        public ActionType Action;
        public float3 HeightmapScale;
        public float3 Center;
        public float ConeHeight;
        public bool UpsideDown;
        public float Radius;
        public float RadiusWithMargin;
        public float Intensity;
        public bool IsTargetIntensity;
        public int ChunkAltitude;
        public uint TextureIndex;
        public int2 CutSize;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<float> Heights;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<float> VerticalNormals;

        public NativeArray<Voxel> Voxels;

#if UNITY_2019_3_OR_NEWER
        [WriteOnly] [NativeDisableParallelForRestriction] public NativeArray<int> Holes;
#else
        public float2 TerrainRelativePositionToHolePosition;
        public float3 WorldPosition;
        [WriteOnly] public NativeCollections.NativeQueue<CutEntry>.Concurrent ToCut;
        [WriteOnly] public NativeCollections.NativeQueue<float3>.Concurrent ToTriggerBounds;
#endif

        private double coneAngle;
        private float upsideDownSign;

        public void PostConstruct()
        {
            if (ConeHeight > 0.1f)
                coneAngle = Math.Atan((double) Radius / ConeHeight);
            upsideDownSign = UpsideDown ? -1f : 1f;
        }

        public void Execute(int index)
        {
            var xi = index / SizeVox2;
            var yi = (index - xi * SizeVox2) / SizeVox;
            var zi = index - xi * SizeVox2 - yi * SizeVox;

            var p = new float3((xi - 1) * HeightmapScale.x, (yi - 1), (zi - 1) * HeightmapScale.z);
            var terrainHeight = Heights[xi * SizeVox + zi];
            var terrainHeightValue = p.y + ChunkAltitude - terrainHeight;

            float2 distances;
            switch (Brush) {
                case BrushType.Sphere:
                    distances = ComputeSphereDistances(p);
                    break;
                case BrushType.HalfSphere:
                    distances = ComputeHalfSphereDistances(p);
                    break;
                case BrushType.RoundedCube:
                    distances = ComputeCubeDistances(p);
                    break;
                case BrushType.Stalagmite:
                    distances = ComputeConeDistances(p);
                    break;
                default:
                    return; // never happens
            }

            Voxel voxel;
            switch (Action) {
                case ActionType.Add:
                case ActionType.Dig:
                    var intensityWeight = Math.Max(1f, Math.Abs(terrainHeightValue) * 0.75f);
                    voxel = ApplyDigAdd(index, Action == ActionType.Dig, distances, intensityWeight);
                    break;
                case ActionType.Paint:
                    voxel = ApplyPaint(index, distances.x);
                    break;
                case ActionType.Reset:
                    voxel = ApplyResetBrush(index, xi, zi, p);
                    break;
                default:
                    return; // never happens
            }


            if (voxel.Alteration != 0) {
                if (voxel.IsAlteredFarSurface) {
                    var terrainNrm = VerticalNormals[xi * SizeVox + zi];
                    if (Math.Abs(terrainHeightValue) <= 1f / Math.Max(terrainNrm, 0.001f) + 0.5f) {
                        voxel.Alteration = Voxel.NearAboveSurface;
                    }
                }

                if (voxel.Value > terrainHeightValue) {
                    switch (voxel.Alteration) {
                        case Voxel.FarAboveSurface:
                            voxel.Alteration = Voxel.FarBelowSurface;
                            break;
                        case Voxel.NearAboveSurface:
                            voxel.Alteration = Voxel.NearBelowSurface;
                            break;
                    }
                }
                else {
                    switch (voxel.Alteration) {
                        case Voxel.FarBelowSurface:
                            voxel.Alteration = Voxel.FarAboveSurface;
                            break;
                        case Voxel.NearBelowSurface:
                            voxel.Alteration = Voxel.NearAboveSurface;
                            break;
                    }
                }
            }

            if (voxel.IsAlteredNearBelowSurface || voxel.IsAlteredNearAboveSurface) {
#if UNITY_2019_3_OR_NEWER
                if (Action != ActionType.Reset) {
                    for (var z = -CutSize.y; z < CutSize.y; ++z) {
                        var pz = zi - 1 + z;
                        if (pz >= 0 && pz < SizeOfMesh) {
                            for (var x = -CutSize.x; x < CutSize.x; ++x) {
                                var px = xi - 1 + x;
                                if (px >= 0 && px < SizeOfMesh) {
                                    NativeCollections.Utils.IncrementAt(Holes, pz * SizeOfMesh + px);
                                }
                            }
                        }
                    }
                }
#else
                var pos = new float3((xi - 1) * HeightmapScale.x, (yi - 1), (zi - 1) * HeightmapScale.z);
                ToTriggerBounds.Enqueue(pos);
                var wpos = pos + WorldPosition;
                var pCut = new int3((int) (wpos.x * TerrainRelativePositionToHolePosition.x), (int) wpos.y,
                    (int) (wpos.z * TerrainRelativePositionToHolePosition.y));
                for (var x = -CutSize.x; x < CutSize.x; ++x) {
                    for (var z = -CutSize.y; z < CutSize.y; ++z) {
                        ToCut.Enqueue(new CutEntry(
                            pCut.x + x,
                            pCut.z + z,
                            voxel.IsAlteredNearAboveSurface
                        ));
                    }
                }
#endif
            }


            Voxels[index] = voxel;
        }

        private float2 ComputeSphereDistances(float3 p)
        {
            var vec = p - Center;
            var distance = (float) Math.Sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z);
            var flatDistance = (float) Math.Sqrt(vec.x * vec.x + vec.z * vec.z);
            return new float2(Radius - distance, RadiusWithMargin - flatDistance);
        }

        private float2 ComputeHalfSphereDistances(float3 p)
        {
            var vec = p - Center;
            var distance = (float) Math.Sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z);
            var flatDistance = (float) Math.Sqrt(vec.x * vec.x + vec.z * vec.z);
            return new float2(Math.Min(Radius - distance, vec.y), RadiusWithMargin - flatDistance);
        }

        private float2 ComputeCubeDistances(float3 p)
        {
            var vec = p - Center;
            var flatDistance = Math.Min(RadiusWithMargin - Math.Abs(vec.x), RadiusWithMargin - Math.Abs(vec.z));
            return new float2(
                Math.Min(Math.Min(Radius - Math.Abs(vec.x), Radius - Math.Abs(vec.y)), Radius - Math.Abs(vec.z)),
                flatDistance);
        }

        private float2 ComputeConeDistances(float3 p)
        {
            var coneVertex = Center + new float3(0, upsideDownSign * ConeHeight * 0.95f, 0);
            var vec = p - coneVertex;
            var distance = (float) Math.Sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z);
            var flatDistance = (float) Math.Sqrt(vec.x * vec.x + vec.z * vec.z);
            var pointAngle = Math.Asin((double) flatDistance / distance);
            var d = -distance * Math.Sin(Math.Abs(pointAngle - coneAngle)) * Math.Sign(pointAngle - coneAngle);
            return new float2(
                Math.Min(Math.Min((float) d, ConeHeight + upsideDownSign * vec.y), -upsideDownSign * vec.y),
                RadiusWithMargin - flatDistance);
        }

        private Voxel ApplyDigAdd(int index, bool dig, float2 distances, float intensityWeight)
        {
            var voxel = Voxels[index];
            var currentValF = voxel.Value;

            if (dig) {
                voxel.Value = Math.Max(currentValF, currentValF + Intensity * intensityWeight * distances.x);
            }
            else {
                voxel.Value = Math.Min(currentValF, currentValF - Intensity * intensityWeight * distances.x);
            }

            if (distances.x >= 0) {
                voxel.Alteration = Voxel.FarAboveSurface;
                voxel.AddTexture(TextureIndex, 1f);
            }
            else if (distances.y > 0 && voxel.Alteration == Voxel.Unaltered) {
                voxel.Alteration = Voxel.OnSurface;
            }

            return voxel;
        }

        private Voxel ApplyPaint(int index, float distance)
        {
            var voxel = Voxels[index];

            if (distance >= 0) {
                if (IsTargetIntensity) {
                    if (TextureIndex < 28) {
                        voxel.SetTexture(TextureIndex, Intensity);
                    }
                    else if (TextureIndex == 28) {
                        voxel.NormalizedWetnessWeight = Intensity;
                    }
                    else if (TextureIndex == 29) {
                        voxel.NormalizedPuddlesWeight = Intensity;
                    }
                    else if (TextureIndex == 30) {
                        voxel.NormalizedStreamsWeight = Intensity;
                    }
                    else if (TextureIndex == 31) {
                        voxel.NormalizedLavaWeight = Intensity;
                    }
                }
                else {
                    if (TextureIndex < 28) {
                        voxel.AddTexture(TextureIndex, Intensity);
                    }
                    else if (TextureIndex == 28) {
                        voxel.NormalizedWetnessWeight += Intensity;
                    }
                    else if (TextureIndex == 29) {
                        voxel.NormalizedPuddlesWeight += Intensity;
                    }
                    else if (TextureIndex == 30) {
                        voxel.NormalizedStreamsWeight += Intensity;
                    }
                    else if (TextureIndex == 31) {
                        voxel.NormalizedLavaWeight += Intensity;
                    }
                }
            }

            return voxel;
        }

        private Voxel ApplyResetBrush(int index, int xi, int zi, float3 p)
        {
            var vec = p - Center;
            var flatDistance = (float) Math.Sqrt(vec.x * vec.x + vec.z * vec.z);
            if (flatDistance <= RadiusWithMargin) {
                var height = Heights[xi * SizeVox + zi];
                var voxel = Voxels[index];
                if (voxel.Alteration == Voxel.Unaltered || flatDistance < Radius) {
                    voxel.Alteration = Voxel.Unaltered;
#if UNITY_2019_3_OR_NEWER
                    var px = xi - 1;
                    var pz = zi - 1;
                    if (px >= 0 && px < SizeOfMesh && pz >= 0 && pz < SizeOfMesh) {
                        NativeCollections.Utils.IncrementAt(Holes, pz * SizeOfMesh + px);
                    }
#endif
                }
                else {
                    voxel.Alteration = Voxel.OnSurface;
                }

                voxel.Value = p.y + ChunkAltitude - height;
                return voxel;
            }

            return Voxels[index];
        }
    }
}