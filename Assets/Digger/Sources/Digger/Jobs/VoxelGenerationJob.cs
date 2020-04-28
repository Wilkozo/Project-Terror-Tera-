using Unity.Burst;
using Unity.Collections;
using Unity.Jobs;

namespace Digger
{
    [BurstCompile(CompileSynchronously = true, FloatMode = FloatMode.Fast)]
    public struct VoxelGenerationJob : IJobParallelFor
    {
        public int ChunkAltitude;
        public int SizeVox;
        public int SizeVox2;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<float> Heights;

        [WriteOnly] public NativeArray<Voxel> Voxels;

        public void Execute(int index)
        {
            // voxels[x * Size * Size + y * Size + z]
            var xi = index / SizeVox2;
            var yi = (index - xi * SizeVox2) / SizeVox;
            var zi = index - xi * SizeVox2 - yi * SizeVox;
            var y = yi - 1;
            var height = Heights[xi * SizeVox + zi];
            var voxel = new Voxel(y + ChunkAltitude - height);
            Voxels[index] = voxel;
        }
    }
}