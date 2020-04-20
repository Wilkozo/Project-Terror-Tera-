using UnityEngine.Audio;
using UnityEngine;

[System.Serializable]
public class Sound
{
    public string name;

    public AudioClip Clip;

    [Range(0.0f, 1f)]
    public float vol;
    [Range(.1f, 3f)]
    public float pit;
    public bool loop;

    [HideInInspector]
    public AudioSource source;
}

