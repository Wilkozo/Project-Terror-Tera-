// Protecc the build from errors...
#if UNITY_EDITOR
using UnityEngine;
using UnityEditor;
using System;

[Serializable]
public class AudioWindow : EditorWindow
{
    string TitleString;
    string TimeString;
    // Old Method
    //Texture2D m_Logo;
    Texture2D m_Logo;

    float TrackVolume;

    // Creates the Editor Window...
    [MenuItem("Window/Audio-Plugin")]
    // Old Method
    //Texture2D m_Logo;

    // Creates the Editor Window...
    private void OnEnable()
    {
        m_Logo = (Texture2D)AssetDatabase.LoadAssetAtPath("Assets/AudioPlugin/Example.jpg", typeof(Texture2D));
    }

    // Show Window Function...
    public static void ShowWindow()
    {
        //EditorWindow.GetWindow<AudioWindow>("Audio-Plugin");
    }

    // For updating Titles and times...
    private void Update()
    {
        
       TitleString =  FindObjectOfType<Audio_Plugin>().DisplayTrackTitle();
       TimeString = FindObjectOfType<Audio_Plugin>().DisplayTrackTime();
        TrackVolume = FindObjectOfType<Audio_Plugin>().DisplayTrackVolume();
    }


    //
    private void OnGUI()
    {
        GUILayout.Label(m_Logo);
        // Title
        GUILayout.Label("Audio Options", EditorStyles.boldLabel);

        // Window Code
        //GUILayout.Label("Example Label", EditorStyles.boldLabel);

        // Editing Fields and properties
        //TitleString = EditorGUILayout.TextField("Name", TitleString);

        // SPACE
        GUILayout.Label(" ", EditorStyles.boldLabel);
        GUILayout.Label("Track Details", EditorStyles.boldLabel);
        GUILayout.Label(" ", EditorStyles.boldLabel);
        // Prints the Title of the Track
        GUILayout.Label("Track Title: " +TitleString, EditorStyles.boldLabel);
        GUILayout.Label(" ", EditorStyles.boldLabel);
        GUILayout.Label("Track Time: " + TimeString, EditorStyles.boldLabel);
        GUILayout.Label(" ", EditorStyles.boldLabel);
        GUILayout.Label("                                            Track Volume", EditorStyles.boldLabel);
        GUILayout.Label("                                                        " + TrackVolume.ToString(), EditorStyles.boldLabel);
        GUILayout.Label(" ", EditorStyles.boldLabel);
        GUILayout.HorizontalSlider(TrackVolume, 0, 1);
        GUILayout.Label(" ", EditorStyles.boldLabel);

        // Example Button
        //if (GUILayout.Button("Press Me!"))
        //{   Debug.Log("Button Was Pressed");   }

        // Stop Track Button
        if (GUILayout.Button("Play Track"))
        {
            FindObjectOfType<Audio_Plugin>().PlayTrack();
        }

        // Stop Track Button
        if (GUILayout.Button("Stop Track"))
        {
            FindObjectOfType<Audio_Plugin>().StopTrack();
        }

        // Next Track Button
        if (GUILayout.Button("Next Track"))
        {
            FindObjectOfType<Audio_Plugin>().NextTrack();
        }

        // Last Track Button
        if (GUILayout.Button("Last Track"))
        {
            FindObjectOfType<Audio_Plugin>().LastTrack();
        }

        // Mute Button
        if (GUILayout.Button("Mute Track"))
        {
            FindObjectOfType<Audio_Plugin>().MuteSong();
        }

        // SFX Button
        if (GUILayout.Button("Play SFX Layer 02"))
        {
            FindObjectOfType<AudioManager>().Play("SFX");
        }

    }




}
#endif