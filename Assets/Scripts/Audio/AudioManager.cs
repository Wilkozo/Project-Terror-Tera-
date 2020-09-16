using UnityEngine.Audio;
using System;
using UnityEngine;
using Random = UnityEngine.Random;
using UnityEngine.SceneManagement;
using System.Collections;


public class AudioManager : MonoBehaviour
{

    private bool WorldMusicActive = false;
    public Sound[] Sounds;
    public static AudioManager instance;
    private AudioSource CurrentTrack;
    private AudioSource source;

    private void Start()
    {
        // Get the sound
        source = GetComponent<AudioSource>();
        // Play Music
        float RandNum = UnityEngine.Random.Range(0, 100);
        if (RandNum <= 74)
        {

        }
        else if (RandNum > 75)
        {

        }
        
    }

    // Used for initialization
    void Awake()
    {
        
        if (instance == null)
        {
            instance = this;
        }        
        else
        {
            Destroy(gameObject);
            return;
        }

        // Initialise the sounds...
        foreach (Sound i in Sounds)
        {
            i.source = gameObject.AddComponent<AudioSource>();
            i.source.clip = i.Clip;

            i.source.volume = i.vol;
            i.source.pitch = i.pit;
            i.source.loop = i.loop;
        }
        if (WorldMusicActive == false)
        {

            //Destroy(gameObject);
        }
    }

    public void Play(string name)
    {
        Sound i = Array.Find(Sounds, Sound => Sound.name == name);
        if (i == null) // failsafe for if the sound isn't working 
        {              //(sends meessage to see if it is null)
            Debug.LogWarning("Sound / SFX" + name + " Missing!");
            return;
        }
        
        i.source.Play();
    }

    public void Stop(string name)
    {
        Sound i = Array.Find(Sounds, Sound => Sound.name == name);
        Debug.Log("Tracking lost, stopping audio");
        if (i.source.isPlaying)
        {
            for (int j = 0; j < 1000; j++)
            {
                i.source.volume -= (float)0.1;
                if (i.source.volume == 0)
                {
                    i.source.Stop();
                }
            }
        }
    }

}

