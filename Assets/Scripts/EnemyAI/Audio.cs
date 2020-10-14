using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Audio : MonoBehaviour
{
    public AudioSource raptorSource;
    public AudioClip cautionAudio;
    public AudioClip chaseAudio;
    
    public void audioChanger(string audioClipToChangeTo) {
        if (audioClipToChangeTo == "Chase" && !raptorSource.isPlaying) {
            raptorSource.clip = chaseAudio;
            raptorSource.Play();
        }
        if (audioClipToChangeTo == "Caution" && !raptorSource.isPlaying) {        
            raptorSource.clip = cautionAudio;
            raptorSource.Play();
        }
    }
}
