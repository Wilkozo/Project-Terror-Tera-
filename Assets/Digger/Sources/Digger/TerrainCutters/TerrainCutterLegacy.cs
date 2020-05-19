using System.IO;
using System.Text;
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;

#endif

namespace Digger.TerrainCutters
{
    public class TerrainCutterLegacy : TerrainCutter
    {
        private const int LargeFileBufferSize = 32768;

        [SerializeField] private DiggerSystem digger;
        [SerializeField] private Texture2D transparencyMap;
        [SerializeField] private Texture2D transparencyMapBackup;

        private int[][,] detailMaps;
        private static readonly int TransparencyMapProperty = Shader.PropertyToID("_TerrainHolesTexture");

        public override void OnEnterPlayMode()
        {
#if UNITY_EDITOR
            transparencyMapBackup = new Texture2D(transparencyMap.width, transparencyMap.height)
                {filterMode = FilterMode.Point};
            transparencyMapBackup.SetPixels(transparencyMap.GetPixels());
            transparencyMapBackup.Apply();
            var transparencyMapPath = digger.GetTransparencyMapBackupPath();
            transparencyMapBackup = EditorUtils.CreateOrReplaceAsset(transparencyMapBackup, transparencyMapPath);
#endif
        }

        public override void OnExitPlayMode()
        {
#if UNITY_EDITOR
            var transparencyMapPath = digger.GetTransparencyMapBackupPath();
            transparencyMapBackup = AssetDatabase.LoadAssetAtPath<Texture2D>(transparencyMapPath);
            if (transparencyMapBackup) {
                transparencyMap.SetPixels(transparencyMapBackup.GetPixels());
                Apply(true);
            }
#endif
        }

        public static TerrainCutterLegacy CreateInstance(Terrain terrain, DiggerSystem digger)
        {
            var cutter = digger.gameObject.AddComponent<TerrainCutterLegacy>();
            cutter.digger = digger;

#if UNITY_EDITOR
            var transparencyMapPath = digger.GetTransparencyMapPath();
            cutter.transparencyMap = AssetDatabase.LoadAssetAtPath<Texture2D>(transparencyMapPath);
#endif
            if (cutter.transparencyMap == null)
                cutter.transparencyMap = cutter.CreateNewTransparencyMap();

            cutter.Refresh();
            cutter.Apply(true);
            return cutter;
        }

        private Texture2D CreateNewTransparencyMap()
        {
            var terrainData = digger.Terrain.terrainData;
            var texture = new Texture2D(terrainData.alphamapResolution,
                                        terrainData.alphamapResolution) {filterMode = FilterMode.Point};

            // Init all pixels to Color.white
            var colors = new Color[texture.width * texture.height];
            for (var i = 0; i < colors.Length; ++i) {
                colors[i] = Color.white;
            }

            texture.SetPixels(colors);
            texture.Apply();

            return texture;
        }

        public override void Refresh()
        {
            if (!transparencyMap)
                transparencyMap = CreateNewTransparencyMap();
            if (transparencyMap.filterMode != FilterMode.Point)
                transparencyMap.filterMode = FilterMode.Point;
            GrabDetailMaps();
        }

        private void GrabDetailMaps()
        {
            var tData = digger.Terrain.terrainData;
            detailMaps = new int[tData.detailPrototypes.Length][,];
            for (var layer = 0; layer < detailMaps.Length; ++layer) {
                detailMaps[layer] = tData.GetDetailLayer(0, 0, tData.detailWidth, tData.detailHeight, layer);
            }
        }

        private void CutDetailMaps(TerrainData tData, int x, int z)
        {
            if (detailMaps == null)
                GrabDetailMaps();

            var width = Mathf.Max(tData.detailWidth / tData.alphamapWidth, 1);
            var height = Mathf.Max(tData.detailHeight / tData.alphamapHeight, 1);
            foreach (var detailMap in detailMaps) {
                for (var w = 0; w < width; ++w) {
                    for (var h = 0; h < height; ++h) {
                        if (x + w >= 0 && x + w < tData.detailWidth && z + h >= 0 && z + h < tData.detailHeight) {
                            detailMap[x + w, z + h] = 0;
                        }
                    }
                }
            }
        }

        public void Cut(CutEntry cutEntry, bool cutDetails)
        {
            if (cutEntry.RemoveDetailsOnly == 0)
                transparencyMap.SetPixel(cutEntry.X, cutEntry.Z, Color.clear);

            if (cutDetails) {
                var tData = digger.Terrain.terrainData;
                var detailMapPos = TerrainUtils.AlphamapPositionToDetailMapPosition(tData, cutEntry.X, cutEntry.Z);
                CutDetailMaps(tData, detailMapPos.y, detailMapPos.x);
            }
        }

        public void UnCut(int x, int z)
        {
            transparencyMap.SetPixel(x, z, Color.white);
        }

        protected override void ApplyInternal(bool persist)
        {
            Utils.Profiler.BeginSample("[Dig] Cutter.Apply");
            if (transparencyMap.filterMode != FilterMode.Point)
                transparencyMap.filterMode = FilterMode.Point;
            transparencyMap.Apply();

            if (detailMaps != null) {
                var tData = digger.Terrain.terrainData;
                for (var layer = 0; layer < detailMaps.Length; ++layer) {
                    tData.SetDetailLayer(0, 0, layer, detailMaps[layer]);
                }
            }

#if UNITY_EDITOR
            if (persist)
                Persist();

            switch (digger.MaterialType) {
                case TerrainMaterialType.MicroSplat:
                    SetMicroSplatAlphaHoleTexture(digger.Terrain, transparencyMap);
                    break;
                case TerrainMaterialType.CTS:
                    SetCTSCutoutMask(digger.Terrain, transparencyMap);
                    break;
                default:
                    digger.Terrain.materialTemplate.SetTexture(TransparencyMapProperty, transparencyMap);
                    break;
            }

#endif
            Utils.Profiler.EndSample();
        }

        public override void LoadFrom(string path)
        {
            if (!transparencyMap)
                transparencyMap = CreateNewTransparencyMap();

            using (Stream stream =
                new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.Read, LargeFileBufferSize)) {
                using (var reader = new BinaryReader(stream, Encoding.Default)) {
                    var count = reader.ReadInt32();
                    var raw = reader.ReadBytes(count);
                    transparencyMap.LoadRawTextureData(raw);
                }
            }

            if (detailMaps == null)
                GrabDetailMaps();

            for (var layer = 0; layer < detailMaps.Length; ++layer) {
                var detailLayer = detailMaps[layer];
                var detPath = $"{path}_det{layer}";
                if (!File.Exists(detPath))
                    continue;

                using (Stream stream = new FileStream(detPath, FileMode.Open, FileAccess.Read, FileShare.Read,
                                                      LargeFileBufferSize)) {
                    using (var reader = new BinaryReader(stream, Encoding.Default)) {
                        for (var x = 0; x < detailLayer.GetLength(0); x += 1) {
                            for (var y = 0; y < detailLayer.GetLength(1); y += 1) {
                                detailLayer[x, y] = reader.ReadInt32();
                            }
                        }
                    }
                }
            }

            var treesPath = $"{path}_trees";
            if (File.Exists(treesPath)) {
                var treeInstances = digger.Terrain.terrainData.treeInstances;
                using (Stream stream = new FileStream(treesPath, FileMode.Open, FileAccess.Read, FileShare.Read)) {
                    using (var reader = new BinaryReader(stream, Encoding.Default)) {
                        for (var index = 0; index < treeInstances.Length; index++) {
                            var treeInstance = treeInstances[index];
                            treeInstance.widthScale = reader.ReadSingle();
                            treeInstance.heightScale = reader.ReadSingle();
                            treeInstances[index] = treeInstance;
                        }
                    }
                }

                digger.Terrain.terrainData.treeInstances = treeInstances;
            }

            Apply(true);
        }

        public override void SaveTo(string path)
        {
            if (!transparencyMap)
                return;

            Utils.Profiler.BeginSample("Save transparency map");
            Utils.Profiler.BeginSample("GetRawTextureData");
            var raw = transparencyMap.GetRawTextureData();
            Utils.Profiler.EndSample();
            using (var stream = new FileStream(path, FileMode.Create, FileAccess.Write, FileShare.None,
                                               LargeFileBufferSize)) {
                using (var writer = new BinaryWriter(stream, Encoding.Default)) {
                    writer.Write(raw.Length);
                    writer.Write(raw);
                }
            }

            Utils.Profiler.EndSample();

            Utils.Profiler.BeginSample("Save details map");
            for (var layer = 0; layer < detailMaps.Length; ++layer) {
                var detailLayer = detailMaps[layer];
                var detPath = $"{path}_det{layer}";
                using (var stream = new FileStream(detPath, FileMode.Create, FileAccess.Write, FileShare.None,
                                                   LargeFileBufferSize)) {
                    using (var writer = new BinaryWriter(stream, Encoding.Default)) {
                        for (var x = 0; x < detailLayer.GetLength(0); x += 1) {
                            for (var y = 0; y < detailLayer.GetLength(1); y += 1) {
                                writer.Write(detailLayer[x, y]);
                            }
                        }
                    }
                }
            }

            Utils.Profiler.EndSample();

#if !UNITY_EDITOR
            var treeInstances = digger.Terrain.terrainData.treeInstances;
            var treesPath = $"{path}_trees";
            using (var stream = new FileStream(treesPath, FileMode.Create, FileAccess.Write, FileShare.None)) {
                using (var writer = new BinaryWriter(stream, Encoding.Default)) {
                    foreach (var treeInstance in treeInstances) {
                        writer.Write(treeInstance.widthScale);
                        writer.Write(treeInstance.heightScale);
                    }
                }
            }
#endif
        }

        public override void Clear()
        {
#if UNITY_EDITOR
            Utils.Profiler.BeginSample("[Dig] Cutter.Clear");
            AssetDatabase.DeleteAsset(digger.GetTransparencyMapPath());
            transparencyMap = null;
            Utils.Profiler.EndSample();
#endif
        }

        private void Persist()
        {
#if UNITY_EDITOR
            Utils.Profiler.BeginSample("[Dig] Cutter.Persist");
            var transparencyMapPath = digger.GetTransparencyMapPath();
            transparencyMap = EditorUtils.CreateOrReplaceAsset(transparencyMap, transparencyMapPath);
            Utils.Profiler.EndSample();
#endif
        }


        #region CTS

        private void SetCTSCutoutMask(Terrain terrain, Texture2D cutoutMask)
        {
#if (UNITY_EDITOR && CTS_PRESENT)
            var cts = terrain.GetComponent<CTS.CompleteTerrainShader>();
            if (!cts) {
                Debug.LogError($"Could not find CompleteTerrainShader on terrain {terrain.name}");
                return;
            }

            var wasCutout = cts.UseCutout;
            cts.UseCutout = true;
            cts.CutoutMask = cutoutMask;
            if (!wasCutout) {
                cts.CutoutHeight = -1;
            }

            cts.ApplyMaterialAndUpdateShader();
#endif
        }

        #endregion

        #region MicroSplat

        private void SetMicroSplatAlphaHoleTexture(Terrain terrain, Texture2D alphaHoleTexture)
        {
#if (__MICROSPLAT_DIGGER__ && __MICROSPLAT_ALPHAHOLE__)
            var microSplat = terrain.GetComponent<MicroSplatTerrain>();
            if (!microSplat) {
                Debug.LogError($"Could not find MicroSplatTerrain on terrain {terrain.name}");
                return;
            }

            if (microSplat.clipMap != alphaHoleTexture) {
                Debug.Log("Syncing MicroSplat AlphaHole texture.");
                microSplat.clipMap = alphaHoleTexture;
                microSplat.Sync();
            }
#endif
        }

        #endregion
    }
}