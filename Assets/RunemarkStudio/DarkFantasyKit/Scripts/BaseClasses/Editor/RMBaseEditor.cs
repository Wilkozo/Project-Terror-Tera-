using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace Runemark.Common
{
    [CustomEditor(typeof(RMBase), true)]
    public class RMBaseEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            var pt = target as RMBase;
            EditorGUIExtension.DrawInspectorTitle(pt.Title, pt.Description);
            base.OnInspectorGUI();
        }

    }
}

