using UnityEditor;

[CustomEditor(typeof(README))]
public class READMEEditor : Editor
{
    public override void OnInspectorGUI()
    {
        var myTarget = (README) target;
        EditorGUILayout.HelpBox(myTarget.Text, MessageType.Info);
    }
}