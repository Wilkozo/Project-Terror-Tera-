using UnityEditor;
using UnityEngine;

namespace Runemark.Common
{   
    public static partial class EditorGUIExtension
    {
        #region InspectorTitle
        static string _logoPath = "Editor/RMLogo";
        static Color _backgroundColor = new Color(0.1f, 0.1f, 0.15f, 1.00f);
        static Color _fontColor = new Color(0.85f, 0.85f, 0.85f, 1.00f);
        
        public static void DrawInspectorTitle(string title, string description = "")
        {
            GUIStyle titleboxStyle = new GUIStyle(GUI.skin.box);
            titleboxStyle.padding = new RectOffset(3, 3, 3, 3);

            var text = new RectangleTexture();
            text.Resolution = 2;
            text.FillColor = _backgroundColor;
            text.BorderColor = _backgroundColor;
            Texture2D texture = text.Generate();
            titleboxStyle.normal.background = texture;
            
            EditorGUILayout.BeginHorizontal(titleboxStyle);

            if (_inspectorTitleSize == Vector2.zero)
            {
                float w = DialogueSystemIcon.normal.background.width;
                float h = DialogueSystemIcon.normal.background.height;

                _inspectorTitleSize.y = 30f;
                _inspectorTitleSize.x = (_inspectorTitleSize.y / h) * w;
            }

            EditorGUILayout.LabelField("", DialogueSystemIcon, GUILayout.Width(_inspectorTitleSize.x), GUILayout.Height(_inspectorTitleSize.y));

            GUILayout.Space(5);

            GUIContent label = new GUIContent(title);
            var size = TitleStyle.CalcSize(label);
            EditorGUILayout.LabelField(label, TitleStyle, GUILayout.Width(size.x));

            GUILayout.FlexibleSpace();

            EditorGUILayout.EndHorizontal();
            if (description != "")
            {
                Color lGUIColor = GUI.color;
                GUI.color = _backgroundColor.gamma;
                EditorGUILayout.HelpBox(description, MessageType.None);
                GUI.color = lGUIColor;

            }


            EditorGUILayout.Space();
        }
        
        static Vector2 _inspectorTitleSize = Vector2.zero;

        static GUIStyle _titleStyle = null;
        static GUIStyle TitleStyle
        {
            get
            {
                if (_titleStyle == null)
                {
                    Font lFont = (Font)Resources.GetBuiltinResource(typeof(Font), "Arial.ttf");
                    if (lFont == null) { lFont = EditorStyles.standardFont; }

                    _titleStyle = new GUIStyle(GUI.skin.label);
                    _titleStyle.font = lFont;
                    _titleStyle.fontSize = 14;
                    _titleStyle.fontStyle = FontStyle.Bold;
                    _titleStyle.normal.textColor = _fontColor;
                    _titleStyle.fixedHeight = 30f;
                    _titleStyle.alignment = TextAnchor.MiddleLeft;
                    _titleStyle.padding = new RectOffset(0, 0, 0, 0);
                }

                return _titleStyle;
            }
        }

        static GUIStyle _dialogueSystemIcon = null;
        static GUIStyle DialogueSystemIcon
        {
            get
            {
                if (_dialogueSystemIcon == null)
                {
                    Texture2D lTexture = Resources.Load<Texture2D>(_logoPath);

                    _dialogueSystemIcon = new GUIStyle(GUI.skin.box);
                    if(lTexture != null) _dialogueSystemIcon.normal.background = lTexture;
                    _dialogueSystemIcon.padding = new RectOffset(0, 0, 0, 0);
                    _dialogueSystemIcon.margin = new RectOffset(0, 0, 0, 0);
                }

                return _dialogueSystemIcon;
            }
        }
        #endregion
    }
}