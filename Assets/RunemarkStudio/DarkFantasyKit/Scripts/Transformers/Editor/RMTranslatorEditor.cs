using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace Runemark.Common
{
    [CustomEditor(typeof(RMTranslator), true)]
    public class RMTranslatorEditor : RMTransformerEditor
    {
        void OnSceneGUI()
        {
            var t = target as RMTranslator;
            
            var start = t.transform.TransformPoint(t.Start);
            var end = t.transform.TransformPoint(t.End);

            using (var cc = new EditorGUI.ChangeCheckScope())
            {
                start = Handles.PositionHandle(start, Quaternion.AngleAxis(180, t.transform.up) * t.transform.rotation);
                Handles.Label(start, "Start", "button");
                Handles.Label(end, "End", "button");
                end = Handles.PositionHandle(end, t.transform.rotation);
                if (cc.changed)
                {
                    Undo.RecordObject(t, "Move Handles");
                    t.Start = t.transform.InverseTransformPoint(start);
                    t.End = t.transform.InverseTransformPoint(end);
                    t.DoTransform(t.PreviewPosition);
                }
            }
            Handles.color = Color.yellow;
            Handles.DrawDottedLine(start, end, 5);
            Handles.Label(Vector3.Lerp(start, end, 0.5f), "Distance:" + (end - start).magnitude);
        }
    }
}