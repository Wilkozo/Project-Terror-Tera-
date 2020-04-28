using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
#if __MICROSPLAT_DIGGER__
using JBooth.MicroSplat;

#endif

namespace Digger
{
    [CustomEditor(typeof(DiggerSystem))]
    public class DiggerSystemEditor : Editor
    {
        private const int TxtCountPerPass = 4;
        private const int MaxPassCount = 4;

        private DiggerSystem diggerSystem;
        private static readonly int TerrainWidthInvProperty = Shader.PropertyToID("_TerrainWidthInv");
        private static readonly int TerrainHeightInvProperty = Shader.PropertyToID("_TerrainHeightInv");
        private const string SplatPrefixProperty = "_Splat";
        private const string NormalPrefixProperty = "_Normal";
        private const string MaskPrefixProperty = "_Mask";

        public void OnEnable()
        {
            diggerSystem = (DiggerSystem) target;
            Init(diggerSystem, false);
        }

        public override void OnInspectorGUI()
        {
            EditorGUILayout.HelpBox($"Digger data for this terrain can be found in {diggerSystem.BasePathData}",
                                    MessageType.Info);
            EditorGUILayout.HelpBox($"Raw voxel data can be found in {diggerSystem.BasePathData}/.internal",
                                    MessageType.Info);
            EditorGUILayout.HelpBox("DO NOT CHANGE / RENAME / MOVE this folder.", MessageType.Warning);
            EditorGUILayout.HelpBox("Don\'t forget to backup this folder as well when you backup your project.",
                                    MessageType.Warning);

            EditorGUILayout.LabelField("Use Digger Master to start digging.");

            var showDebug = EditorGUILayout.Toggle("Show debug data", diggerSystem.ShowDebug);
            if (showDebug != diggerSystem.ShowDebug) {
                diggerSystem.ShowDebug = showDebug;
                foreach (Transform child in diggerSystem.transform) {
                    child.gameObject.hideFlags =
                        showDebug ? HideFlags.None : HideFlags.HideInHierarchy | HideFlags.HideInInspector;
                }

                EditorApplication.DirtyHierarchyWindowSorting();
                EditorApplication.RepaintHierarchyWindow();
            }

            if (showDebug) {
                EditorGUILayout.LabelField($"GUID: {diggerSystem.Guid}");
                EditorGUILayout.LabelField($"Undo/redo stack version: {diggerSystem.Version}");

                DrawDefaultInspector();
            }
        }

        public static void Init(DiggerSystem diggerSystem, bool forceRefresh)
        {
            if (!forceRefresh && diggerSystem.IsInitialized)
                return;

            diggerSystem.PreInit(true);

            if (diggerSystem.Materials == null || forceRefresh)
                SetupMaterial(diggerSystem, forceRefresh);

            diggerSystem.Init(forceRefresh ? LoadType.Minimal_and_LoadVoxels_and_SyncVoxelsWithTerrain_and_RebuildMeshes : LoadType.Minimal);
            if (forceRefresh) {
                diggerSystem.PersistDiggerVersion();
                diggerSystem.PersistAndRecordUndo(true, false);
            }
        }

        private static void SetupMaterial(DiggerSystem diggerSystem, bool forceRefresh)
        {
            Utils.Profiler.BeginSample("[Dig] SetupMaterial");

            if (EditorUtils.CTSExists(diggerSystem.Terrain)) {
                diggerSystem.MaterialType = TerrainMaterialType.CTS;
                Debug.Log("Setting up Digger with CTS shaders");
                SetupCTSMaterial(diggerSystem);
            } else if (EditorUtils.MicroSplatExists(diggerSystem.Terrain)) {
                diggerSystem.MaterialType = TerrainMaterialType.MicroSplat;
                Debug.Log("Setting up Digger with MicroSplat shaders");
                SetupMicroSplatMaterials(diggerSystem);
            } else if (IsBuiltInURP()) {
                diggerSystem.MaterialType = TerrainMaterialType.URP;
                Debug.Log("Setting up Digger with URP shaders");
                SetupURPMaterials(diggerSystem, forceRefresh);
            } else if (IsBuiltInLWRP()) {
                diggerSystem.MaterialType = TerrainMaterialType.LWRP;
                Debug.Log("Setting up Digger with LWRP shaders");
                SetupLWRPMaterials(diggerSystem, forceRefresh);
            } else if (IsBuiltInHDRP()) {
                diggerSystem.MaterialType = TerrainMaterialType.HDRP;
                Debug.Log("Setting up Digger with HDRP shaders");
                SetupHDRPMaterials(diggerSystem, forceRefresh);
            } else {
                diggerSystem.MaterialType = TerrainMaterialType.Standard;
                Debug.Log("Setting up Digger with standard shaders");
                SetupDefaultMaterials(diggerSystem, forceRefresh);
            }

            Utils.Profiler.EndSample();
        }

        private static bool IsBuiltInLWRP()
        {
#if UNITY_2019_3_OR_NEWER
            return GraphicsSettings.currentRenderPipeline != null && GraphicsSettings.currentRenderPipeline.defaultTerrainMaterial.shader.name == "Lightweight Render Pipeline/Terrain/Lit";
#elif UNITY_2019_1_OR_NEWER
            return GraphicsSettings.renderPipelineAsset != null && GraphicsSettings.renderPipelineAsset.defaultTerrainMaterial.shader.name == "Lightweight Render Pipeline/Terrain/Lit";
#else
            return GraphicsSettings.renderPipelineAsset != null &&
                   GraphicsSettings.renderPipelineAsset.GetDefaultTerrainMaterial().shader.name ==
                   "Lightweight Render Pipeline/Terrain/Lit";
#endif
        }

        private static bool IsBuiltInURP()
        {
#if UNITY_2019_3_OR_NEWER
            return GraphicsSettings.currentRenderPipeline != null && GraphicsSettings.currentRenderPipeline.defaultTerrainMaterial.shader.name == "Universal Render Pipeline/Terrain/Lit";
#elif UNITY_2019_1_OR_NEWER
            return GraphicsSettings.renderPipelineAsset != null && GraphicsSettings.renderPipelineAsset.defaultTerrainMaterial.shader.name == "Universal Render Pipeline/Terrain/Lit";
#else
            return GraphicsSettings.renderPipelineAsset != null &&
                   GraphicsSettings.renderPipelineAsset.GetDefaultTerrainMaterial().shader.name ==
                   "Universal Render Pipeline/Terrain/Lit";
#endif
        }

        private static bool IsBuiltInHDRP()
        {
#if UNITY_2019_3_OR_NEWER
            return GraphicsSettings.currentRenderPipeline != null && GraphicsSettings.currentRenderPipeline.defaultTerrainMaterial.shader.name == "HDRP/TerrainLit";
#elif UNITY_2019_1_OR_NEWER
            return GraphicsSettings.renderPipelineAsset != null && GraphicsSettings.renderPipelineAsset.defaultTerrainMaterial.shader.name == "HDRP/TerrainLit";
#else
            return GraphicsSettings.renderPipelineAsset != null &&
                   GraphicsSettings.renderPipelineAsset.GetDefaultTerrainMaterial().shader.name == "HDRP/TerrainLit";
#endif
        }


        #region STANDARD

        private static void SetupStandardTerrainMaterial(DiggerSystem diggerSystem, bool forceRefresh)
        {
            if (forceRefresh || !diggerSystem.Terrain.materialTemplate ||
                diggerSystem.Terrain.materialTemplate.shader.name != "Nature/Terrain/Digger/Cuttable-Triplanar") {
#if !UNITY_2019_2_OR_NEWER
                diggerSystem.Terrain.materialType = Terrain.MaterialType.Custom;
#endif
                var terrainMaterial = new Material(Shader.Find("Nature/Terrain/Digger/Cuttable-Triplanar"));
                terrainMaterial = EditorUtils.CreateOrReplaceAsset(terrainMaterial,
                                                                   Path.Combine(diggerSystem.BasePathData, "terrainMaterial.mat"));
                terrainMaterial.SetFloat(TerrainWidthInvProperty, 1f / diggerSystem.Terrain.terrainData.size.x);
                terrainMaterial.SetFloat(TerrainHeightInvProperty, 1f / diggerSystem.Terrain.terrainData.size.z);
                diggerSystem.Terrain.materialTemplate = terrainMaterial;
            }

            if (diggerSystem.Terrain.materialTemplate.shader.name != "Nature/Terrain/Digger/Cuttable-Triplanar")
                Debug.LogWarning("Looks like terrain material doesn't match cave meshes material.");
        }

        private static void SetupDefaultMaterials(DiggerSystem diggerSystem, bool forceRefresh)
        {
            SetupStandardTerrainMaterial(diggerSystem, forceRefresh);

            var tData = diggerSystem.Terrain.terrainData;
            var passCount = GetPassCount(tData);

            if (diggerSystem.Materials == null || diggerSystem.Materials.Length != passCount) {
                diggerSystem.Materials = new Material[passCount];
            }

            var textures = new List<Texture2D>();
            for (var pass = 0; pass < passCount; ++pass) {
                SetupDefaultMaterial(pass, diggerSystem, textures);
            }

            diggerSystem.TerrainTextures = textures.ToArray();
        }

        private static void SetupDefaultMaterial(int pass, DiggerSystem diggerSystem, List<Texture2D> textures)
        {
            var material = diggerSystem.Materials[pass];
            var expectedShaderName = $"Digger/Standard/Mesh-Pass{pass}";
            if (!material || material.shader.name != expectedShaderName) {
                material = new Material(Shader.Find(expectedShaderName));
            }

            var tData = diggerSystem.Terrain.terrainData;
            var offset = pass * TxtCountPerPass;
            for (var i = 0; i + offset < tData.terrainLayers.Length && i < TxtCountPerPass; i++) {
                var terrainLayer = tData.terrainLayers[i + offset];
                if (terrainLayer == null || terrainLayer.diffuseTexture == null)
                    continue;

                material.SetFloat($"_tiles{i}x", 1.0f / terrainLayer.tileSize.x);
                material.SetFloat($"_tiles{i}y", 1.0f / terrainLayer.tileSize.y);
                material.SetFloat($"_offset{i}x", terrainLayer.tileOffset.x);
                material.SetFloat($"_offset{i}y", terrainLayer.tileOffset.y);
                material.SetFloat($"_normalScale{i}", terrainLayer.normalScale);
                material.SetFloat($"_Metallic{i}", terrainLayer.metallic);
                material.SetFloat($"_Smoothness{i}", terrainLayer.smoothness);
                material.SetTexture(SplatPrefixProperty + i, terrainLayer.diffuseTexture);
                material.SetTexture(NormalPrefixProperty + i, terrainLayer.normalMapTexture);
                textures.Add(terrainLayer.diffuseTexture);
            }

            var matPath = Path.Combine(diggerSystem.BasePathData, $"meshMaterialPass{pass}.mat");
            material = EditorUtils.CreateOrReplaceAsset(material, matPath);
            AssetDatabase.ImportAsset(matPath, ImportAssetOptions.ForceUpdate);
            diggerSystem.Materials[pass] = material;
        }

        #endregion


        #region LWRP

        private static void SetupLWRPTerrainMaterial(DiggerSystem diggerSystem, bool forceRefresh)
        {
            if (forceRefresh || !diggerSystem.Terrain.materialTemplate ||
                diggerSystem.Terrain.materialTemplate.shader.name != "Digger/LWRP/Terrain/Lit") {
#if !UNITY_2019_2_OR_NEWER
                diggerSystem.Terrain.materialType = Terrain.MaterialType.Custom;
#endif
                var terrainMaterial = new Material(Shader.Find("Digger/LWRP/Terrain/Lit"));
                terrainMaterial = EditorUtils.CreateOrReplaceAsset(terrainMaterial,
                                                                   Path.Combine(diggerSystem.BasePathData, "terrainMaterial.mat"));
                terrainMaterial.SetFloat(TerrainWidthInvProperty, 1f / diggerSystem.Terrain.terrainData.size.x);
                terrainMaterial.SetFloat(TerrainHeightInvProperty, 1f / diggerSystem.Terrain.terrainData.size.z);
                diggerSystem.Terrain.materialTemplate = terrainMaterial;
            }

            if (diggerSystem.Terrain.materialTemplate.shader.name != "Digger/LWRP/Terrain/Lit")
                Debug.LogWarning("Looks like terrain material doesn't match cave meshes material.");
        }

        private static void SetupLWRPMaterials(DiggerSystem diggerSystem, bool forceRefresh)
        {
            SetupLWRPTerrainMaterial(diggerSystem, forceRefresh);

            var tData = diggerSystem.Terrain.terrainData;
            var passCount = GetPassCount(tData);

            if (diggerSystem.Materials == null || diggerSystem.Materials.Length != passCount) {
                diggerSystem.Materials = new Material[passCount];
            }

            var textures = new List<Texture2D>();
            for (var pass = 0; pass < passCount; ++pass) {
                SetupLWRPMaterial(pass, diggerSystem, textures);
            }

            diggerSystem.TerrainTextures = textures.ToArray();
        }

        private static void SetupLWRPMaterial(int pass, DiggerSystem diggerSystem, List<Texture2D> textures)
        {
            var material = diggerSystem.Materials[pass];
            var expectedShaderName = $"Digger/LWRP/Mesh-Pass{pass}";
            if (!material || material.shader.name != expectedShaderName) {
                material = new Material(Shader.Find(expectedShaderName));
            }

            var tData = diggerSystem.Terrain.terrainData;
            var offset = pass * TxtCountPerPass;
            for (var i = 0; i + offset < tData.terrainLayers.Length && i < TxtCountPerPass; i++) {
                var terrainLayer = tData.terrainLayers[i + offset];
                if (terrainLayer == null || terrainLayer.diffuseTexture == null)
                    continue;

                material.SetFloat($"_tiles{i}x", 1.0f / terrainLayer.tileSize.x);
                material.SetFloat($"_tiles{i}y", 1.0f / terrainLayer.tileSize.y);
                material.SetFloat($"_offset{i}x", terrainLayer.tileOffset.x);
                material.SetFloat($"_offset{i}y", terrainLayer.tileOffset.y);
                material.SetFloat($"_normalScale{i}", terrainLayer.normalScale);
                material.SetFloat($"_Metallic{i}", terrainLayer.metallic);
                material.SetFloat($"_Smoothness{i}", terrainLayer.smoothness);
                material.SetTexture(SplatPrefixProperty + i, terrainLayer.diffuseTexture);
                material.SetTexture(NormalPrefixProperty + i, terrainLayer.normalMapTexture);
                textures.Add(terrainLayer.diffuseTexture);
            }

            var matPath = Path.Combine(diggerSystem.BasePathData, $"meshMaterialPass{pass}.mat");
            material = EditorUtils.CreateOrReplaceAsset(material, matPath);
            AssetDatabase.ImportAsset(matPath, ImportAssetOptions.ForceUpdate);
            diggerSystem.Materials[pass] = material;
        }

        #endregion


        #region URP

        private static void SetupURPTerrainMaterial(DiggerSystem diggerSystem, bool forceRefresh)
        {
            if (forceRefresh || !diggerSystem.Terrain.materialTemplate ||
                diggerSystem.Terrain.materialTemplate.shader.name != "Digger/URP/Terrain/Lit") {
                var terrainMaterial = new Material(Shader.Find("Digger/URP/Terrain/Lit"));
                terrainMaterial = EditorUtils.CreateOrReplaceAsset(terrainMaterial,
                                                                   Path.Combine(diggerSystem.BasePathData, "terrainMaterial.mat"));
                terrainMaterial.SetFloat(TerrainWidthInvProperty, 1f / diggerSystem.Terrain.terrainData.size.x);
                terrainMaterial.SetFloat(TerrainHeightInvProperty, 1f / diggerSystem.Terrain.terrainData.size.z);
                diggerSystem.Terrain.materialTemplate = terrainMaterial;
            }

            if (diggerSystem.Terrain.materialTemplate.shader.name != "Digger/URP/Terrain/Lit")
                Debug.LogWarning("Looks like terrain material doesn't match cave meshes material.");
        }

        private static void SetupURPMaterials(DiggerSystem diggerSystem, bool forceRefresh)
        {
            SetupURPTerrainMaterial(diggerSystem, forceRefresh);

            var tData = diggerSystem.Terrain.terrainData;
            var passCount = GetPassCount(tData);

            if (diggerSystem.Materials == null || diggerSystem.Materials.Length != passCount) {
                diggerSystem.Materials = new Material[passCount];
            }

            var textures = new List<Texture2D>();
            for (var pass = 0; pass < passCount; ++pass) {
                SetupURPMaterial(pass, diggerSystem, textures);
            }

            diggerSystem.TerrainTextures = textures.ToArray();
        }

        private static void SetupURPMaterial(int pass, DiggerSystem diggerSystem, List<Texture2D> textures)
        {
            var material = diggerSystem.Materials[pass];
            var expectedShaderName = $"Digger/URP/Mesh-Pass{pass}";
            if (!material || material.shader.name != expectedShaderName) {
                material = new Material(Shader.Find(expectedShaderName));
            }

            var tData = diggerSystem.Terrain.terrainData;
            var offset = pass * TxtCountPerPass;
            for (var i = 0; i + offset < tData.terrainLayers.Length && i < TxtCountPerPass; i++) {
                var terrainLayer = tData.terrainLayers[i + offset];
                if (terrainLayer == null || terrainLayer.diffuseTexture == null)
                    continue;

                material.SetFloat($"_tiles{i}x", 1.0f / terrainLayer.tileSize.x);
                material.SetFloat($"_tiles{i}y", 1.0f / terrainLayer.tileSize.y);
                material.SetFloat($"_offset{i}x", terrainLayer.tileOffset.x);
                material.SetFloat($"_offset{i}y", terrainLayer.tileOffset.y);
                material.SetFloat($"_normalScale{i}", terrainLayer.normalScale);
                material.SetFloat($"_Metallic{i}", terrainLayer.metallic);
                material.SetFloat($"_Smoothness{i}", terrainLayer.smoothness);
                material.SetTexture(SplatPrefixProperty + i, terrainLayer.diffuseTexture);
                material.SetTexture(NormalPrefixProperty + i, terrainLayer.normalMapTexture);
                textures.Add(terrainLayer.diffuseTexture);
            }

            var matPath = Path.Combine(diggerSystem.BasePathData, $"meshMaterialPass{pass}.mat");
            material = EditorUtils.CreateOrReplaceAsset(material, matPath);
            AssetDatabase.ImportAsset(matPath, ImportAssetOptions.ForceUpdate);
            diggerSystem.Materials[pass] = material;
        }

        #endregion


        #region HDRP

        private static void SetupHDRPTerrainMaterial(DiggerSystem diggerSystem, bool forceRefresh)
        {
            if (forceRefresh || !diggerSystem.Terrain.materialTemplate ||
                diggerSystem.Terrain.materialTemplate.shader.name != "Digger/HDRP/Terrain/Lit") {
                var terrainMaterial = new Material(Shader.Find("Digger/HDRP/Terrain/Lit"));
                terrainMaterial = EditorUtils.CreateOrReplaceAsset(terrainMaterial,
                                                                   Path.Combine(diggerSystem.BasePathData, "terrainMaterial.mat"));
                terrainMaterial.SetFloat(TerrainWidthInvProperty, 1f / diggerSystem.Terrain.terrainData.size.x);
                terrainMaterial.SetFloat(TerrainHeightInvProperty, 1f / diggerSystem.Terrain.terrainData.size.z);
                diggerSystem.Terrain.materialTemplate = terrainMaterial;
            }

            if (diggerSystem.Terrain.materialTemplate.shader.name != "Digger/HDRP/Terrain/Lit")
                Debug.LogWarning("Looks like terrain material doesn't match cave meshes material.");
        }

        private static void SetupHDRPMaterials(DiggerSystem diggerSystem, bool forceRefresh)
        {
            SetupHDRPTerrainMaterial(diggerSystem, forceRefresh);

            if (diggerSystem.Materials == null || diggerSystem.Materials.Length != 1) {
                diggerSystem.Materials = new Material[1];
            }

            var textures = new List<Texture2D>();
            SetupHDRPMaterial(diggerSystem, textures);

            diggerSystem.TerrainTextures = textures.ToArray();
        }

        private static void SetupHDRPMaterial(DiggerSystem diggerSystem, List<Texture2D> textures)
        {
            var material = new Material(Shader.Find("Digger/HDRP/Mesh/Lit"));


            var tData = diggerSystem.Terrain.terrainData;
            if (tData.terrainLayers.Length > 4) {
                material.EnableKeyword("_TERRAIN_8_LAYERS");
            }

            var enableMaskMap = false;

            for (var i = 0; i < tData.terrainLayers.Length && i < 8; i++) {
                var terrainLayer = tData.terrainLayers[i];
                if (terrainLayer == null || terrainLayer.diffuseTexture == null)
                    continue;

                if (terrainLayer.maskMapTexture) {
                    enableMaskMap = true;
                }

                material.SetFloat($"_NormalScale{i}", terrainLayer.normalScale);
                material.SetVector($"_MaskMapRemapOffset{i}", Vector4.zero);
                material.SetVector($"_MaskMapRemapScale{i}", Vector4.one);
                material.SetVector($"_DiffuseRemapScale{i}", Vector4.one);
                material.SetFloat($"_LayerHasMask{i}", terrainLayer.maskMapTexture ? 1f : 0f);
                material.SetFloat($"_Metallic{i}", terrainLayer.metallic);
                material.SetFloat($"_Smoothness{i}", terrainLayer.smoothness);
                material.SetTexture(SplatPrefixProperty + i, terrainLayer.diffuseTexture);
                material.SetTexture(NormalPrefixProperty + i, terrainLayer.normalMapTexture);
                material.SetTexture(MaskPrefixProperty + i, terrainLayer.maskMapTexture);
                material.SetTextureScale(SplatPrefixProperty + i,
                                         new Vector2(1f / terrainLayer.tileSize.x, 1f / terrainLayer.tileSize.y));
                material.SetTextureOffset(SplatPrefixProperty + i, terrainLayer.tileOffset);
                textures.Add(terrainLayer.diffuseTexture);
            }

            if (enableMaskMap) {
                material.EnableKeyword("_MASKMAP");
            }

            var matPath = Path.Combine(diggerSystem.BasePathData, $"meshMaterialPass.mat");
            material = EditorUtils.CreateOrReplaceAsset(material, matPath);
            AssetDatabase.ImportAsset(matPath, ImportAssetOptions.ForceUpdate);
            diggerSystem.Materials[0] = material;
        }

        #endregion

        #region MicroSplat

        private static void SetupMicroSplatMaterials(DiggerSystem diggerSystem)
        {
            if (diggerSystem.Materials == null || diggerSystem.Materials.Length != 1) {
                diggerSystem.Materials = new Material[1];
            }

            var textures = new List<Texture2D>();
            var tData = diggerSystem.Terrain.terrainData;

            for (var i = 0; i < tData.terrainLayers.Length && i < 28; i++) {
                var terrainLayer = tData.terrainLayers[i];
                if (terrainLayer == null || terrainLayer.diffuseTexture == null)
                    continue;

                textures.Add(terrainLayer.diffuseTexture);
            }

            diggerSystem.TerrainTextures = textures.ToArray();
#if __MICROSPLAT_DIGGER__
            CheckMicroSplatTerrainFeatures(diggerSystem);
            SetupMicroSplatMaterial(diggerSystem);
            SetupMicroSplatMaterialSyncEventHandler(diggerSystem);
#endif // __MICROSPLAT_DIGGER__
        }

#if __MICROSPLAT_DIGGER__
        private static void CheckMicroSplatTerrainFeatures(DiggerSystem diggerSystem)
        {
            var microSplat = diggerSystem.Terrain.GetComponent<MicroSplatTerrain>();
            if (!microSplat) {
                Debug.LogError($"Could not find MicroSplatTerrain on terrain {diggerSystem.Terrain.name}");
                return;
            }
            
#if !UNITY_2019_3_OR_NEWER
#if __MICROSPLAT_ALPHAHOLE__ 
            if (!microSplat.keywordSO.IsKeywordEnabled("_ALPHAHOLETEXTURE")) {
                microSplat.keywordSO.EnableKeyword("_ALPHAHOLETEXTURE");
            }
#else
            Debug.LogError("MicroSplat Digger integration requires the MicroSplat AlphaHole module unless you use Unity 2019.3+");
#endif
#endif

#if __MICROSPLAT_TRIPLANAR__
            if (!microSplat.keywordSO.IsKeywordEnabled("_TRIPLANAR")) {
                microSplat.keywordSO.EnableKeyword("_TRIPLANAR");
            }

            if (microSplat.keywordSO.IsKeywordEnabled("_TRIPLANARLOCALSPACE")) {
                microSplat.keywordSO.DisableKeyword("_TRIPLANARLOCALSPACE");
            }
#else
            Debug.LogError("MicroSplat Digger integration requires the MicroSplat Triplanar module.");
#endif
        }

        private static void SetupMicroSplatMaterial(DiggerSystem diggerSystem)
        {
            var microSplat = diggerSystem.Terrain.GetComponent<MicroSplatTerrain>();
            if (!microSplat) {
                Debug.LogError($"Could not find MicroSplatTerrain on terrain {diggerSystem.Terrain.name}");
                return;
            }

            var microSplatShader = MicroSplatUtilities.GetDiggerShader(microSplat);
            if (microSplatShader == null) {
                Debug.LogError($"Could not find MicroSplat Digger shader");
                return;
            }

            var material = new Material(microSplatShader);
            material.CopyPropertiesFromMaterial(microSplat.matInstance);
            
            var matPath = Path.Combine(diggerSystem.BasePathData, $"diggerMicroSplat.mat");
            material = EditorUtils.CreateOrReplaceAsset(material, matPath);
            AssetDatabase.ImportAsset(matPath, ImportAssetOptions.ForceUpdate);
            diggerSystem.Materials[0] = material;
        }

        private static void SetupMicroSplatMaterialSyncEventHandler(DiggerSystem diggerSystem)
        {
            var msSync = diggerSystem.gameObject.GetComponent<MicroSplatSync>();
            if (!msSync) {
                diggerSystem.gameObject.AddComponent<MicroSplatSync>();
            } else {
                msSync.OnDisable();
                msSync.OnEnable();
            }
        }
#endif // __MICROSPLAT_DIGGER__

        #endregion

        #region CTS

        private static void SetupCTSMaterial(DiggerSystem diggerSystem)
        {
            if (!diggerSystem.Terrain.materialTemplate) {
                Debug.LogError("Could not setup CTS material for Digger because terrain.materialTemplate is null.");
                return;
            }

            if (diggerSystem.Materials == null || diggerSystem.Materials.Length != 1) {
                diggerSystem.Materials = new Material[1];
            }

            if (diggerSystem.Terrain.materialTemplate.shader.name.StartsWith("CTS/CTS Terrain Shader Basic")) {
                SetupCTSBasicMaterial(diggerSystem);
            } else if (diggerSystem.Terrain.materialTemplate.shader.name.StartsWith(
                "CTS/CTS Terrain Shader Advanced Tess")) {
                SetupCTSAdvancedTessMaterial(diggerSystem);
            } else if (diggerSystem.Terrain.materialTemplate.shader.name.StartsWith("CTS/CTS Terrain Shader Advanced")) {
                SetupCTSAdvancedMaterial(diggerSystem);
            } else {
                Debug.LogError(
                    $"Could not setup CTS material for Digger because terrain shader was not a known CTS shader. Was {diggerSystem.Terrain.materialTemplate.shader.name}");
            }
        }

        private static void SetupCTSBasicMaterial(DiggerSystem diggerSystem)
        {
            if (!diggerSystem.Materials[0] ||
                diggerSystem.Materials[0].shader.name != "CTS/CTS Terrain Shader Basic Mesh") {
                diggerSystem.Materials[0] = new Material(Shader.Find("CTS/CTS Terrain Shader Basic Mesh"));
            }

            if (!diggerSystem.Terrain.materialTemplate ||
                !diggerSystem.Terrain.materialTemplate.shader.name.StartsWith("CTS/CTS Terrain Shader Basic")) {
                Debug.LogWarning($"Looks like terrain material doesn\'t match cave meshes material. " +
                                 $"Expected \'CTS/CTS Terrain Shader Basic CutOut\', was {diggerSystem.Terrain.materialTemplate.shader.name}. " +
                                 $"Please fix this by assigning the right material to the terrain.");
                return;
            }

            diggerSystem.Materials[0].CopyPropertiesFromMaterial(diggerSystem.Terrain.materialTemplate);

            var matPath = Path.Combine(diggerSystem.BasePathData, "meshMaterial.mat");
            diggerSystem.Materials[0] = EditorUtils.CreateOrReplaceAsset(diggerSystem.Materials[0], matPath);
            AssetDatabase.ImportAsset(matPath, ImportAssetOptions.ForceUpdate);
        }

        private static void SetupCTSAdvancedMaterial(DiggerSystem diggerSystem)
        {
            if (!diggerSystem.Materials[0] ||
                diggerSystem.Materials[0].shader.name != "CTS/CTS Terrain Shader Advanced Mesh") {
                diggerSystem.Materials[0] = new Material(Shader.Find("CTS/CTS Terrain Shader Advanced Mesh"));
            }

            if (!diggerSystem.Terrain.materialTemplate ||
                !diggerSystem.Terrain.materialTemplate.shader.name.StartsWith("CTS/CTS Terrain Shader Advanced")) {
                Debug.LogWarning($"Looks like terrain material doesn\'t match cave meshes material. " +
                                 $"Expected \'CTS/CTS Terrain Shader Advanced CutOut\', was {diggerSystem.Terrain.materialTemplate.shader.name}. " +
                                 $"Please fix this by assigning the right material to the terrain.");
                return;
            }

            diggerSystem.Materials[0].CopyPropertiesFromMaterial(diggerSystem.Terrain.materialTemplate);

            var matPath = Path.Combine(diggerSystem.BasePathData, "meshMaterial.mat");
            diggerSystem.Materials[0] = EditorUtils.CreateOrReplaceAsset(diggerSystem.Materials[0], matPath);
            AssetDatabase.ImportAsset(matPath, ImportAssetOptions.ForceUpdate);
        }

        private static void SetupCTSAdvancedTessMaterial(DiggerSystem diggerSystem)
        {
            if (!diggerSystem.Materials[0] ||
                diggerSystem.Materials[0].shader.name != "CTS/CTS Terrain Shader Advanced Tess Mesh") {
                diggerSystem.Materials[0] = new Material(Shader.Find("CTS/CTS Terrain Shader Advanced Tess Mesh"));
            }

            if (!diggerSystem.Terrain.materialTemplate ||
                !diggerSystem.Terrain.materialTemplate.shader.name.StartsWith("CTS/CTS Terrain Shader Advanced Tess")) {
                Debug.LogWarning($"Looks like terrain material doesn\'t match cave meshes material. " +
                                 $"Expected \'CTS/CTS Terrain Shader Advanced Tess CutOut\', was {diggerSystem.Terrain.materialTemplate.shader.name}. " +
                                 $"Please fix this by assigning the right material to the terrain.");
                return;
            }

            diggerSystem.Materials[0].CopyPropertiesFromMaterial(diggerSystem.Terrain.materialTemplate);

            var matPath = Path.Combine(diggerSystem.BasePathData, "meshMaterial.mat");
            diggerSystem.Materials[0] = EditorUtils.CreateOrReplaceAsset(diggerSystem.Materials[0], matPath);
            AssetDatabase.ImportAsset(matPath, ImportAssetOptions.ForceUpdate);
        }

        #endregion


        private static int GetPassCount(TerrainData tData)
        {
            var passCount = tData.terrainLayers.Length / TxtCountPerPass;
            if (tData.terrainLayers.Length % TxtCountPerPass != 0) {
                passCount++;
            }

            return Mathf.Min(passCount, MaxPassCount);
        }
    }
}