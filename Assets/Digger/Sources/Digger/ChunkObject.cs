using UnityEngine;
using UnityEngine.Rendering;
#if UNITY_EDITOR
using UnityEditor;

#endif

namespace Digger
{
    public class ChunkObject : MonoBehaviour
    {
        [SerializeField] private MeshRenderer meshRenderer;
        [SerializeField] private MeshFilter filter;
        [SerializeField] private MeshCollider meshCollider;
        [SerializeField] private bool hasCollider;
        [SerializeField] private bool isStatic;
#if !UNITY_2019_3_OR_NEWER
        [SerializeField] private BoxCollider holeCollider;
#endif

        public Mesh Mesh => filter.sharedMesh;

        internal static ChunkObject Create(int lod,
            Vector3i chunkPosition,
            ChunkLODGroup chunkLodGroup,
            bool hasCollider,
            DiggerSystem digger,
            Terrain terrain,
            Material[] materials,
            int layer)
        {
            Utils.Profiler.BeginSample("ChunkObject.Create");
            var go = new GameObject(GetName(chunkPosition));
            go.layer = layer;
            go.hideFlags = digger.ShowDebug ? HideFlags.None : HideFlags.HideInHierarchy | HideFlags.HideInInspector;

            go.transform.parent = chunkLodGroup.transform;
            go.transform.localPosition = Vector3.zero;
            go.transform.localRotation = Quaternion.identity;
            go.transform.localScale = Vector3.one;

            var chunkObject = go.AddComponent<ChunkObject>();
            chunkObject.enabled = false;
            chunkObject.hasCollider = hasCollider;
            chunkObject.meshRenderer = go.AddComponent<MeshRenderer>();
            chunkObject.meshRenderer.lightmapScaleOffset = digger.Terrain.lightmapScaleOffset;
            chunkObject.meshRenderer.realtimeLightmapScaleOffset = digger.Terrain.realtimeLightmapScaleOffset;
            chunkObject.meshRenderer.sharedMaterials = materials ?? new Material[0];
            SetupMeshRenderer(digger.Terrain, chunkObject.meshRenderer);

            go.GetComponent<Renderer>().shadowCastingMode = ShadowCastingMode.On;
            go.GetComponent<Renderer>().receiveShadows = true;
            chunkObject.filter = go.AddComponent<MeshFilter>();
            chunkObject.meshRenderer.enabled = false;

            if (hasCollider) {
                chunkObject.meshCollider = go.AddComponent<MeshCollider>();

#if !UNITY_2019_3_OR_NEWER
                var goCollider = new GameObject("ChunkTrigger");
                goCollider.transform.parent = go.transform;
                goCollider.layer = layer;
                goCollider.transform.localPosition = Vector3.zero;
                var colliderHole = goCollider.AddComponent<TerrainColliderHoleComponent>();
                colliderHole.Digger = digger;
                colliderHole.TerrainCollider = terrain.GetComponent<TerrainCollider>();

                chunkObject.holeCollider = goCollider.AddComponent<BoxCollider>();
                chunkObject.holeCollider.isTrigger = true;
                chunkObject.holeCollider.enabled = false;
#endif
            }

            chunkObject.UpdateStaticEditorFlags(lod, digger.EnableOcclusionCulling);
            
            Utils.Profiler.EndSample();
            return chunkObject;
        }

        public void UpdateStaticEditorFlags(int lod, bool enableOcclusionCulling)
        {
#if UNITY_EDITOR

                isStatic = true;
                var flags = StaticEditorFlags.ReflectionProbeStatic |
                            StaticEditorFlags.OffMeshLinkGeneration;

                if (lod == 1) {
                    flags |= StaticEditorFlags.NavigationStatic;
                }

                if (enableOcclusionCulling) {
                    flags |= StaticEditorFlags.OccludeeStatic |
                             StaticEditorFlags.OccluderStatic;
                }

                GameObjectUtility.SetStaticEditorFlags(gameObject, flags);

#endif
        }

        private static void SetupMeshRenderer(Terrain terrain, MeshRenderer meshRenderer)
        {
#if UNITY_EDITOR
            var terrainSerializedObject = new SerializedObject(terrain);
            var serializedObject = new SerializedObject(meshRenderer);
            var terrainLightmapParameters = terrainSerializedObject.FindProperty("m_LightmapParameters");
            var lightmapParameters = serializedObject.FindProperty("m_LightmapParameters");
            lightmapParameters.objectReferenceValue = terrainLightmapParameters.objectReferenceValue;
            serializedObject.ApplyModifiedPropertiesWithoutUndo();
#endif
        }

        public static string GetName(Vector3i chunkPosition)
        {
            return $"ChunkObject_{chunkPosition.x}_{chunkPosition.y}_{chunkPosition.z}";
        }

        public bool PostBuild(Mesh visualMesh, Mesh collisionMesh, ChunkTriggerBounds bounds)
        {
            Utils.Profiler.BeginSample("[Dig] Chunk.PostBuild");
            if (filter.sharedMesh && !isStatic) {
                if (Application.isEditor && !Application.isPlaying) {
                    DestroyImmediate(filter.sharedMesh);
                }
                else {
                    Destroy(filter.sharedMesh);
                }
            }

            var hasVisualMesh = false;
            if (!ReferenceEquals(visualMesh, null) && visualMesh.vertexCount > 0) {
                filter.sharedMesh = visualMesh;
                meshRenderer.enabled = true;
                hasVisualMesh = true;
            }
            else {
                filter.sharedMesh = null;
                meshRenderer.enabled = false;
            }

            if (hasCollider) {
#if !UNITY_2019_3_OR_NEWER
                if (!bounds.IsVirgin) {
                    var b = bounds.ToBounds();
                    holeCollider.center = b.center;
                    holeCollider.size = b.size + Vector3.one * 2;
                    holeCollider.enabled = true;
                }
                else {
                    holeCollider.enabled = false;
                }
#endif

                if (meshCollider.sharedMesh) {
                    if (Application.isEditor && !Application.isPlaying) {
                        DestroyImmediate(meshCollider.sharedMesh);
                    }
                    else {
                        Destroy(meshCollider.sharedMesh);
                    }
                }

                if (!ReferenceEquals(collisionMesh, null) && collisionMesh.vertexCount > 0) {
                    if (!Application.isEditor) {
                        meshCollider.cookingOptions = MeshColliderCookingOptions.EnableMeshCleaning;
                    }

                    meshCollider.sharedMesh = collisionMesh;
                    meshCollider.enabled = true;
                }
                else {
                    meshCollider.sharedMesh = null;
                    meshCollider.enabled = false;
                }
            }

            Utils.Profiler.EndSample();
            return hasVisualMesh;
        }
    }
}