using System.IO;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEngine;

namespace Digger
{
    public static class ScriptConverter
    {
        [MenuItem("Assets/Digger/Convert Raycasts")]
        private static void ConvertPhysicsRaycast()
        {
            var script = (MonoScript) Selection.activeObject;
            var content = script.text;
            var path = AssetDatabase.GetAssetPath(script);
            AssetDatabase.MoveAsset(path, $"{path}_backup");

            content = Regex.Replace(content, @"(^|[^a-zA-Z0-9])Physics\.Raycast", m => m.Groups[1].Value + "DiggerPhysics.Raycast");

            File.WriteAllText(Path.Combine(Application.dataPath, "..", path), content);
            AssetDatabase.Refresh();
        }

        [MenuItem("Assets/Digger/Convert Raycasts", true)]
        private static bool ConvertPhysicsRaycastValidation()
        {
            return Selection.activeObject != null && Selection.activeObject.GetType() == typeof(MonoScript) && Selection.activeObject.name != "DiggerPhysics";
        }
    }
}