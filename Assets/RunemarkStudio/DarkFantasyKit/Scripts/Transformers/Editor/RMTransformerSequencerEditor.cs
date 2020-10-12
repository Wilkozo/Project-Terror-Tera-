using UnityEditor;
using UnityEditorInternal;
using UnityEngine;

namespace Runemark.Common
{
    [CustomEditor(typeof(RMTransformerSequencer), true)]
    public class RMTransformerSequencerEditor : Editor
    {
        ReorderableList _list;

        void OnEnable()
        {            
            var property = serializedObject.FindProperty("List");
            _list = new ReorderableList(serializedObject, property, true, true, true, true);

            _list.drawHeaderCallback = rect => {
                EditorGUI.LabelField(rect, "Sequence", EditorStyles.boldLabel);
            };

            _list.drawElementCallback =
                (Rect rect, int index, bool isActive, bool isFocused) => {
                    var element = _list.serializedProperty.GetArrayElementAtIndex(index);
                    EditorGUI.PropertyField(new Rect(rect.x, rect.y, rect.width, EditorGUIUtility.singleLineHeight), element, GUIContent.none);

                    //EditorGUI.ObjectField(new Rect(rect.x, rect.y, rect.width, EditorGUIUtility.singleLineHeight), element, GUIContent.none);
                };
        }

        public override void OnInspectorGUI()
        {
            EditorGUIExtension.DrawInspectorTitle("Sequencer",
                "This component iterates through the functions in the list below and activates them one by one.\n" +
                "Only activates the next one if the previous one is finished.");


            serializedObject.Update();
            var inverseProperty = serializedObject.FindProperty("InverseRepeate");
            EditorGUILayout.PropertyField(inverseProperty);
            _list.DoLayoutList();
            serializedObject.ApplyModifiedProperties();
        }

    }
}
