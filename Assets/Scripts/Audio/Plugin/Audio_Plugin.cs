// Protecc the build from errors...
//#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

using UnityEditor;
using System;

[Serializable]
// Binds the Audio Source to the Component...
[RequireComponent(typeof(AudioSource))]
public class Audio_Plugin : MonoBehaviour
{

    // Required Variables...
    public AudioClip[] SoundTracks; // Sounds
    private int CurrentSong;
    private AudioSource Source;

    public GameObject Player;
    public GameObject Raptor;

    public float SafeDistance = 100;
    public float CautionDistance = 50;

    private bool SafeZone = true;
    private bool CautionZone = false;
    private bool ChaseZone = false;

    // Variables For Displaying Track Data...

    // Text Variables.
    public String TrackTitle;
    public String TrackTime;

    // Time Variables
    private int TrackLength;
    private int CurrentTime;
    private int Minutes;
    private int Seconds;

    //
    float VolumeA;
    float VolumeB;
    float Timer = 6.0f;
    float T;
    float FadeTime = 1.0f;


    int _WaitPeriod;

    void Update()
    {
        

        
    }

    // Volume Variable
    public float TrackVolume;
    // Protecc the build from errors...
#if UNITY_EDITOR
    public AudioWindow Editwindow;

    private void Awake()
    {
        Editwindow = (AudioWindow)EditorWindow.GetWindow(typeof(AudioWindow));
    }

    private void OnGUI()
    {
        if (Editwindow == null)
        {
            Editwindow = (AudioWindow)EditorWindow.GetWindow(typeof(AudioWindow));
        }
    }
#endif

    // Start is called before the first frame update.
    void Start()
    {
        _WaitPeriod = UnityEngine.Random.Range(5, 15);
        // Binds the Source to the component.
        Source = GetComponent<AudioSource>();
        // This plays the music.
        PlayTrack();
    }


    ///*float*/ void Fade(/*float a, float b, float amount*/)
    /*{
        Timer += Time.deltaTime;

        T = Timer / FadeTime;

        VolumeA = Mathf.Lerp(1.0f, 0.0f, T);
        VolumeB= Mathf.Lerp(0.0f, 1.0f, T);
        /*
        if (a < b)
        {
            a += b;
            if (a > b)
                return b;
        }
        else
        {
            a -= amount;
            if (a < b)
                return b;
        }
        return a;
        */
    //}

    // Wait's for the track to end before starting the next track.
    IEnumerator WaitForTrackEnd()
    {
        while (Source.isPlaying)
        {
            // Gets the current time of the song.
            CurrentTime = (int)Source.time;
            // Fade In Audio.
            /*if (Source.time < TrackLength)
            {
                while (Source.volume == 0)
                {
                    Update();
                    FadingOut = false;
                    FadingIn = true;
                    //Source.volume = Fade(0.0f, 1.0f, 6.0f);
                }
            }
            */

            // Fade Out Audio. on 6 seconds

            /*if (Source.time > TrackLength - 6)
            {
                while (Source.volume != 0)
                {
                    Update();
                    FadingIn = false;
                    FadingOut = true;
                    //Source.volume = Fade(1.0f, 0.0f, 6.0f);
                }
            }
            */
            // Shows the Current time.
            DisplayTrackTime();
            yield return 0;
        }
        StartCoroutine(TrackIntermission());
    }

    IEnumerator TrackIntermission()
    {
        _WaitPeriod = UnityEngine.Random.Range(5, 15);
        Debug.Log("Waiting for: " + _WaitPeriod + "Seconds");
        yield return new WaitForSecondsRealtime(_WaitPeriod);
        //Debug.Log("Finished Coroutine at timestamp : " + Time.time);
        NextTrack();


    }

    /* Move To New Script...
     * 
     * 
     * 
    static IEnumerator FadeIn(int CurTrack, float Speed, float MaxVolume)
    {
        FadingIn = true;
        FadingOut = false;

        //CurTrack = CurrentSong;


        yield return new WaitForSeconds(0.1f);
    }

    static IEnumerator OutIn(int CurTrack, float speed)
    {
        FadingIn = false;
        FadingOut = true;

        //CurTrack = CurrentSong;
        yield return new WaitForSeconds(0.1f);
    }
    */

    // Play Song/Music Function.
    public void PlayTrack()
    {
        // Do nothing If it's already playing.
        if (Source.isPlaying)
        {
            while (Source.volume < 1)
            {
                Update();
                //FadingOut = false;
                //FadingIn = true;
                //Source.volume = Fade(0, 1, 5);
            }
            return; }
        // Changes the current song.
        CurrentSong--;
        //
        if (CurrentSong <= 0)
        { CurrentSong = SoundTracks.Length - 1; }

        StartCoroutine(WaitForTrackEnd());
    }

    public void StopTrack()
    {
        while (Source.volume != 0)
        {
            Update();
            //FadingIn = false;
            //FadingOut = true;
            //Source.volume = Fade(1, 0, 5);
        }
        Source.Stop();
        // Stops The Wait for music to end overiding the wait
        StopCoroutine(WaitForTrackEnd());

    }

    // Function for playing the
    // Following Sound/Song
    public void NextTrack()
    {
       
        // Stops the Current Song...
        Source.Stop();
        CurrentSong++;
        // If the current song has gone out of bounds.
        if (CurrentSong > SoundTracks.Length - 1)
        { CurrentSong = 0; }
        // Binds the Source to the SoundTrack...
        Source.clip = SoundTracks[CurrentSong];
        Source.Play(); // Plays the Sound/Music
        //--------------------------------- |
        // Shows the Track Title Here V
        DisplayTrackTitle();
        StartCoroutine(WaitForTrackEnd());
    }

    // Function for playing the
    // Previous Sound/Song
    public void LastTrack()
    {
        // Stops the Current Song...
        // [-(Work On A Fade Out/ In Function)-]
        Source.Stop();
        CurrentSong--;
        // If the current song has gone out of bounds.
        if (CurrentSong < 0)
        {
            // Sets Song Back By One...
            CurrentSong = SoundTracks.Length - 1;
        }
        // Binds the Source to the SoundTrack...
        Source.clip = SoundTracks[CurrentSong];
        Source.Play(); // Plays the Sound/Music

        //--------------------------------- |
        // Shows the Track Title Here V
        DisplayTrackTitle();

        StartCoroutine(WaitForTrackEnd());
    }

    // Mutes the Song...
    public void MuteSong()
    {
        // Changes the bool to what it currently isn't
        // (Mute -> Unmute | Not Muted - > Muted)
        Source.mute = !Source.mute;
    }

    // Shows the Track Title
    public string DisplayTrackTitle()
    {
        if (Source != null)
        {
            if (Source.isPlaying)
            {
                TrackTitle = Source.clip.name;
                // Sets Track Length to equal the clip length
                // Also type casted so the miliseconds aren't included.
                TrackLength = (int)Source.clip.length;
            }
            else
            {
                TrackTitle = "No Track Playing!";
            }
            // Returns Title
            return TrackTitle;
        }
        return null;
    }

    // Shows the Track Time
    public string DisplayTrackTime()
    {
        if (Source == null)
        {
            return "0:00";
        }
        else
        {
            if (Source.isPlaying)
            {
                // Gets the seconds from the current time. (60 seconds)
                Seconds = CurrentTime % 60;
                // Gets the Minutes from the current time. (60 minutes)
                Minutes = CurrentTime / 60 % 60;

                TrackTime = Minutes.ToString() + ": " + Seconds.ToString("D2") + " / " + ((TrackLength / 60) % 60) + ":" + (TrackLength % 60).ToString("D2");

                return TrackTime;
            }

            return "0:00";
        }

    }

    // Shows the Track Volume
    public float DisplayTrackVolume()
    {
        TrackVolume = Source.volume;
        return TrackVolume;
    }
}

//#endif