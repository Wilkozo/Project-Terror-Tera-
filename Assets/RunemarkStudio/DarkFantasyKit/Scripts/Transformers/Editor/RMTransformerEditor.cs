using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace Runemark.Common
{
    [CustomEditor(typeof(RMTransformer), true)]
    public class RMTransformerEditor : Editor
    {
        private void OnEnable()
        {
            var pt = target as RMTransformer;
            pt.CatchPosition();
        }

        public override void OnInspectorGUI()
        {
            var pt = target as RMTransformer;
            EditorGUIExtension.DrawInspectorTitle(pt.Title, pt.Description);

            using (var cc = new EditorGUI.ChangeCheckScope())
            {
                base.OnInspectorGUI();
                if (cc.changed)
                {
                    
                    pt.DoTransform(pt.PreviewPosition);
                }
            }
        }

    }
}
