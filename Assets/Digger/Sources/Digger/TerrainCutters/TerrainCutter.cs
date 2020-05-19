using UnityEngine;

namespace Digger.TerrainCutters
{
    public abstract class TerrainCutter : MonoBehaviour
    {
        public static TerrainCutter Create(Terrain terrain, DiggerSystem digger)
        {
#if UNITY_2019_3_OR_NEWER
            return TerrainCutter20193.CreateInstance(digger);
#else
            return TerrainCutterLegacy.CreateInstance(terrain, digger);
#endif
        }

        public static bool IsGoodVersion(TerrainCutter cutter)
        {
#if UNITY_2019_3_OR_NEWER
            return cutter is TerrainCutter20193;
#else
            return cutter is TerrainCutterLegacy;
#endif
        }

        private bool mustApply;
        private bool mustPersist;

        public void Apply(bool persist)
        {
            if (Application.isEditor && !Application.isPlaying) {
                ApplyInternal(persist);
            } else {
                mustApply = true;
                mustPersist = persist;
            }
        }

        private void Update()
        {
            if (mustApply) {
                ApplyInternal(mustPersist);
                mustApply = false;
                mustPersist = false;
            }
        }

        public abstract void Refresh();
        protected abstract void ApplyInternal(bool persist);
        public abstract void LoadFrom(string path);
        public abstract void SaveTo(string path);
        public abstract void Clear();
        public abstract void OnEnterPlayMode();
        public abstract void OnExitPlayMode();
    }
}