﻿using UnityEngine;
using UnityEditor;
using Mtree;
using System;
using System.IO;

namespace Mtree
{

    [CanEditMultipleObjects]
    [CustomEditor(typeof(MtreeComponent))]
    public class MtreeEditor : Editor
    {
        MtreeComponent tree;
        private static string[] lodOptions = { "0", "1", "2", "3" };
        private static string[] tabNames = { "Functions", "Quality", "Save as prefab" };
        private int rectHeightMultiplier;

        private void OnEnable()
        {
            tree = (MtreeComponent)target;
#if UNITY_2018_3_OR_NEWER
            if (PrefabUtility.GetPrefabInstanceHandle(target) != null) // Prefabs with MtreeComponents should not be made as it tempers with the TreeFunctionAsset objects. Thus prefabs are deleted
            {
                DeletePefab();
                return;
            }
#else
            if (PrefabUtility.GetPrefabObject(target) != null) // Prefabs with MtreeComponents should not be made as it tempers with the TreeFunctionAsset objects. Thus prefabs are deleted
            {
                DeletePefab();
                return;
            }
#endif
            if (tree.tree == null && tree.MtreeVersion == Mtree.MtreeVariables.MtreeVersion)
            {
                UpdateTree();
            }
            rectHeightMultiplier = TreeFunction.height + TreeFunction.margin;
            Undo.undoRedoPerformed += tree.UndoCallBack;
        }

        private void DeletePefab()
        {
#if UNITY_2018_3_OR_NEWER
            string prefabPath = AssetDatabase.GetAssetPath(PrefabUtility.GetPrefabInstanceHandle(target));
            AssetDatabase.DeleteAsset(prefabPath);
#else
            string prefabPath = AssetDatabase.GetAssetPath(PrefabUtility.GetPrefabObject(target));
            AssetDatabase.DeleteAsset(prefabPath);
#endif
        }

        public override void OnInspectorGUI()
        {
            if (IsMultiSelection()) // Editor to display when multiple trees are selected
            {
                DisplayMultiObjectsEditting();
                return; // Not drawing the rest when multpile trees are selected
            }

            if (tree.MtreeVersion != Mtree.MtreeVariables.MtreeVersion) // If component in out of date
            {
                EditorGUILayout.HelpBox("Warning, this tree was made with a previous version of Mtree, you need to upgrade the tree. Upgrading it may result in unwanted changes.", MessageType.Warning);
                if (GUILayout.Button("Upgrade tree"))
                {
                    serializedObject.FindProperty("MtreeVersion").stringValue = MtreeVariables.MtreeVersion;
                    serializedObject.ApplyModifiedPropertiesWithoutUndo();
                    foreach (TreeFunction tf in tree.treeFunctions)
                    {
                        tf.RevertOutOfBoundValues();
                    }
                    tree.ConvertDeprecatedTreeFunctions();
                }
                return;
            }

            DisplayLodSelection();

            SerializedProperty tabIndexProperty = serializedObject.FindProperty("tabIndex");
            tabIndexProperty.intValue = GUILayout.Toolbar(tabIndexProperty.intValue, tabNames);
            serializedObject.ApplyModifiedProperties();

            switch (tabIndexProperty.intValue)
            {
                case 0:
                    DisplayTemplates();
                    DisplayFunctionsTab();
                    break;
                case 1:
                    DisplayQualityTab();
                    break;
                case 2:
                    DisplaySaveTab();
                    break;
            }


            EditorGUILayout.LabelField("polycount: " + tree.polycount.ToString(), EditorStyles.boldLabel);

        }

        private void DisplayTemplates()
        {
            EditorGUIUtility.labelWidth = 60;
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);


            EditorGUILayout.BeginHorizontal();
            
            EditorGUILayout.PropertyField(serializedObject.FindProperty("template"),new GUIContent("Template"), true);
            serializedObject.ApplyModifiedProperties();
            string SaveButton = "Save Template"; if (tree.template != null) SaveButton = "Override"; else SaveButton = "Save";

            EditorGUI.BeginDisabledGroup(tree.template == null);
            if (GUILayout.Button("Load Template"))
            {
                serializedObject.FindProperty("selectedFunctionIndex").intValue = 0;
                serializedObject.FindProperty("template").objectReferenceValue = tree.template;
                serializedObject.ApplyModifiedProperties();
                
                tree.FromTemplate();
                UpdateTree();
                
            }
            EditorGUI.EndDisabledGroup();
            if(GUILayout.Button(SaveButton + " Template"))
            {
                if(SaveButton == "Override")
                {
                    string templatePath = AssetDatabase.GetAssetPath(tree.template);
                    AssetDatabase.DeleteAsset(templatePath);
                    tree.template = TreeTemplate.CreateFromFunctions(tree.treeFunctionsAssets, templatePath);

                    serializedObject.FindProperty("template").objectReferenceValue = tree.template;
                    serializedObject.ApplyModifiedProperties();
                }
                if (SaveButton == "Save")
                {
                    string templatePath = EditorUtility.SaveFilePanelInProject("Save Template", tree.name + ".asset", "asset", "");
                    if (templatePath.Length > 0)
                    {
                        tree.template = TreeTemplate.CreateFromFunctions(tree.treeFunctionsAssets, templatePath);
                        serializedObject.FindProperty("template").objectReferenceValue = tree.template;
                        serializedObject.ApplyModifiedPropertiesWithoutUndo();
                    }
                }
            }
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.EndVertical();

        }

        private void DisplayLodSelection()
        {
            EditorGUI.BeginChangeCheck();
            SerializedProperty lodIndexProp = serializedObject.FindProperty("LodIndex");
            lodIndexProp.intValue = EditorGUILayout.Popup("LOD", lodIndexProp.intValue, lodOptions);
            if (EditorGUI.EndChangeCheck())
            {
                serializedObject.ApplyModifiedProperties();
                UpdateTree();
            }
        }

        private void DisplayQualityTab()
        {
            EditorGUI.BeginChangeCheck();
            tree.LODs[tree.LodIndex].DrawProperties();
            if (EditorGUI.EndChangeCheck())
                UpdateTree();
        }
        #if UNITY_2018_3_OR_NEWER
        
        private void SetupLegacyMode()
        {
            if (Utils.GetCurrentPipeline() == "hdrp")
            {
                tree.isHDRP = true;
                tree.hdrpAsset = UnityEngine.Rendering.GraphicsSettings.renderPipelineAsset;
                UnityEngine.Rendering.GraphicsSettings.renderPipelineAsset = null;
            }
        }
        private void SetupHDRPMode(){
            if(tree.isHDRP){
                UnityEngine.Rendering.GraphicsSettings.renderPipelineAsset = tree.hdrpAsset;
                tree.isHDRP = false;
            }
        }
        private void SetupLegacyMaterials(GameObject t){
            if(tree.isHDRP)
            {
                foreach(Material m in t.GetComponent<MeshRenderer>().sharedMaterials){
                    if(m.shader.name == "Mtree/SRP/Leaves HDRP")
                        m.shader = Shader.Find("Mtree/Leaves");
                    if(m.shader.name == "Mtree/SRP/Bark HDRP")
                        m.shader = Shader.Find("Mtree/Bark");
                }
            }
        }
        private void SetupHDRPMaterials(GameObject t){
            if(tree.isHDRP){

                foreach(Material m in t.GetComponent<MeshRenderer>().sharedMaterials){
                    if(m.shader.name == "Mtree/Leaves")
                        m.shader = Shader.Find("Mtree/SRP/Leaves HDRP");
                    if(m.shader.name == "Mtree/Bark")
                        m.shader = Shader.Find("Mtree/SRP/Bark HDRP");
                }
            }
        }
#endif


            private void DisplaySaveTab()
        {
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.PropertyField(serializedObject.FindProperty("saveTreeFolder"), new GUIContent("Save folder"));
            if (GUILayout.Button("Find folder"))
            {
                string path = EditorUtility.OpenFolderPanel("save tree location", "Assets", "Assets");
                path = "Assets" + path.Substring(Application.dataPath.Length);
                serializedObject.FindProperty("saveTreeFolder").stringValue = path;
                AssetDatabase.Refresh();
            }
            

            EditorGUILayout.EndHorizontal();
            tree.gameObject.name = EditorGUILayout.TextField("name", tree.gameObject.name);
            EditorGUILayout.Space();
            serializedObject.FindProperty("BillboardBrighntess").floatValue = EditorGUILayout.Slider("Billboard Brightness",serializedObject.FindProperty("BillboardBrighntess").floatValue, 0, 3);
            serializedObject.ApplyModifiedProperties();
            if (GUILayout.Button("Save as Prefab")){
#if UNITY_2018_3_OR_NEWER
                SetupLegacyMode();
                SetupLegacyMaterials(tree.gameObject);
                tree.SaveAsPrefab(false,tree.isHDRP);
                SetupHDRPMaterials(tree.gameObject);
                SetupHDRPMode();
#else
                tree.SaveAsPrefab(false,false);
#endif          
                }
            EditorGUILayout.EndVertical();
        }

        private void DisplayMultiObjectsEditting()
        {
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);
            EditorGUILayout.BeginHorizontal();
            string saveTreeFolder = EditorGUILayout.TextField("Save Folder", tree.saveTreeFolder);
            if (GUILayout.Button("Find folder"))
            {
                string path = EditorUtility.OpenFolderPanel("save tree location", "Assets", "Assets");
                if (path.Length > 0)
                {
                    path = "Assets" + path.Substring(Application.dataPath.Length);
                    saveTreeFolder = path;
                    foreach (MtreeComponent t in Array.ConvertAll(targets, item => (MtreeComponent)item))
                    {
                        SerializedObject obj = new SerializedObject(t);
                        obj.FindProperty("saveTreeFolder").stringValue = saveTreeFolder;
                        obj.ApplyModifiedProperties();
                    }
                    AssetDatabase.Refresh();
                }
            }
            EditorGUILayout.EndHorizontal();



            if (GUILayout.Button("Save all as Prefabs"))
            {
                saveTreeFolder = tree.saveTreeFolder;
                foreach (MtreeComponent t in Array.ConvertAll(targets, item => (MtreeComponent)item))
                {
                    t.SaveAsPrefab(groupedSave: true);
                }
                UnityEngine.Object obj = AssetDatabase.LoadAssetAtPath(saveTreeFolder, typeof(UnityEngine.Object));
                // Select the object in the project folder
                Selection.activeObject = obj;
                // Also flash the folder yellow to highlight it
                EditorGUIUtility.PingObject(obj);
            }
            EditorGUILayout.EndVertical();
        }

        private void DisplayFunctionsTab()
        {
            EditorGUIUtility.labelWidth = 135;
            int functionCount = tree.treeFunctionsAssets.Count; // Used in multiple for loops
    
            EditorGUI.BeginDisabledGroup(tree.treeFunctionsAssets[tree.selectedFunctionIndex].name == "Leaves");
            if (GUILayout.Button("Add function"))
            {
                GenericMenu addFunctionMenu = new GenericMenu();
                addFunctionMenu.AddItem(new GUIContent("Add branch"), false, tree.AddBranchFunction);
                addFunctionMenu.AddItem(new GUIContent("Add Leafs"), false, tree.AddLeafFunction);
                addFunctionMenu.AddItem(new GUIContent("Split"), false, tree.AddSplitFunction);
                addFunctionMenu.AddItem(new GUIContent("Grow"), false, tree.AddGrowFunction);
                addFunctionMenu.ShowAsContext();
            }
            EditorGUI.EndDisabledGroup();

            int rectHeight = functionCount * rectHeightMultiplier; // get the height of the drawing window inside inspector
            Rect rect = GUILayoutUtility.GetRect(10, 1000, rectHeight, rectHeight); // Create drawing window
            Event e = Event.current; // Get current event

            int heighIndex = 0;
            tree.treeFunctionsAssets[0].UpdateRectRec(ref heighIndex, 0);

            if (e.type == EventType.MouseDown && e.button == 0) // If mouse button is pressed, get button pressed and act accordingly
            {
                for (int i = 0; i < functionCount; i++)
                {
                    TreeFunctionAsset tf = tree.treeFunctionsAssets[i];


                    if (tf.rect.Contains(e.mousePosition - rect.position))
                    {
                        if (tf.deleteRect.Contains(e.mousePosition - rect.position))
                        {
                            tree.RemoveFunction(tf);
                            UpdateTree();
                        }
                        else
                        {
                            serializedObject.FindProperty("selectedFunctionIndex").intValue = i;
                            serializedObject.ApplyModifiedProperties();
                        }
                        GUIUtility.ExitGUI();
                        break;
                    }
                }
            }
            if(e.type == EventType.MouseDown && e.button == 1){
                for(int i = 0; i<functionCount;i++){
                    TreeFunctionAsset tf = tree.treeFunctionsAssets[i];
                    if(tf.rect.Contains(e.mousePosition - rect.position)){
                            var menu = new GenericMenu();
                            if(!tf.name.Contains("Trunk"))
                                menu.AddItem(new GUIContent("Copy Tree Function"),false,SaveTF);
                            else
                                menu.AddDisabledItem(new GUIContent("Copy Tree Function"));

                                
                            if(tree.savedFunction != null && tree.treeFunctionsAssets[tree.selectedFunctionIndex].name != "Leaves")
                                menu.AddItem(new GUIContent("Paste Tree Function"),false,InsertTF);
                            else
                                menu.AddDisabledItem(new GUIContent("Paste Tree Function"));

                            menu.ShowAsContext();
                            e.Use();
                        
                    }
                }
            }
            GUI.BeginClip(rect);

            for (int i = 0; i < tree.treeFunctionsAssets.Count; i++)
                tree.treeFunctionsAssets[i].DrawFunction(i == tree.selectedFunctionIndex, i>0);

            GUI.EndClip();

            EditorGUI.BeginChangeCheck();
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            if (GUILayout.Button("Randomize tree"))
            {
                tree.RandomizeTree();
            }

            TreeFunctionAsset selectedFunction = tree.treeFunctionsAssets[tree.selectedFunctionIndex];
            selectedFunction.DrawProperties();

            EditorGUILayout.EndVertical();
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);
            var gs = new GUIStyle();
            gs.richText = true;
            EditorGUILayout.LabelField("<b>Vertex Color Adjustment</b> <i>(Baked Wind Settings)</i>",gs);
            EditorGUILayout.Slider(serializedObject.FindProperty("VColBarkModifier"),0.1f,5,new GUIContent("Stem Multiplier"));
            EditorGUILayout.Slider(serializedObject.FindProperty("VColLeafModifier"),0.1f,5,new GUIContent("Leaf Multiplier"));
            serializedObject.ApplyModifiedProperties();
            EditorGUILayout.EndVertical();
            if (EditorGUI.EndChangeCheck())
                UpdateTree();
        }
        
        void SaveTF(){
            tree.savedFunction = tree.treeFunctionsAssets[tree.selectedFunctionIndex];
        }
        void InsertTF(){
            var tf = Instantiate(tree.savedFunction);
            tf.parent = tree.treeFunctionsAssets[tree.selectedFunctionIndex];
            tf.Init(tree.treeFunctionsAssets[tree.selectedFunctionIndex],true);
            tree.treeFunctionsAssets.Add(tf);
            UpdateTree();
        }

        private void UpdateTree()
        {
            tree.GenerateTree();
        }

        private bool IsMultiSelection()
        {
            return targets.Length > 1;
        }
    }


}