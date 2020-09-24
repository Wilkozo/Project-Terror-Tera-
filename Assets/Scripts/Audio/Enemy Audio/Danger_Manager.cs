using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using UnityEngine.Audio;

public class Danger_Manager : MonoBehaviour
{
    // list of audio sources 
    public static List<Danger_Audio> TrackList = new List<Danger_Audio>();

    //
    private static float ClipLength;

    // Fading Variables
    private static bool fadingIn;
    private static bool fadingOut;
    // to call static functions
    public static Danger_Manager instance;

    private void Awake()
    {
        // sets var to this script
        instance = this;
    }


    //
    static public void AddSongs(int numOfClips, GameObject g_Object)
    {
        //
        if (numOfClips != 0)
        {
            for (int i = 0; i < numOfClips; i++)
            {
                Danger_Audio aClip = new Danger_Audio
                { Track_ID = 1, audioSource = g_Object.AddComponent<AudioSource>() };
                TrackList.Add(aClip);
            }
        }
    }

    //
    static public void ClipSettings(int aClip, AudioMixer aMix, string aGroup, float aVolume, bool loop = false)
    {
        //
        TrackList[aClip].audioSource.outputAudioMixerGroup = aMix.FindMatchingGroups(aGroup)[0];
        TrackList[aClip].Track_Volume = aVolume;
        TrackList[aClip].loop = loop;
    }

    //
    static public void PlayMusic(int cID, AudioClip a_Clip = null, List<AudioClip> acList = null, int min = -2, int max = -2)
    {
        // Looping the Played Clip or not looping it...
        if (a_Clip != null && acList == null && TrackList[cID].audioSource.isPlaying == false)
        {
            TrackList[cID].audioSource.PlayOneShot(a_Clip, TrackList[cID].Track_Volume);

            if (TrackList[cID].loop)
            {
                ClipLength = a_Clip.length;
                // loop
                LoopCaller(cID, ClipLength, a_Clip, null, min, max);
            }
        }

        if (a_Clip == null && acList != null && TrackList[cID].audioSource.isPlaying == false)
        {
            int index = Random.Range(min, max);

            if (index == -1)
            {
                // no sound
                Debug.Log("no Sound -1 true");
            }
            else
            {
                TrackList[cID].audioSource.PlayOneShot(acList[index], TrackList[cID].Track_Volume);
                ClipLength = acList[index].length;
            }
            if (TrackList[cID].loop)
            {
                // loop
                LoopCaller(cID, ClipLength, a_Clip, acList, min, max);
            }
        }
    }

    // Calling Scripts
    public static void FadeInCaller(int track, float speed, float maxVolume)
    {
        // calls the fade in Coroutine via this script
        instance.StartCoroutine(FadeIn(track, speed, maxVolume));
    }

    public static void FadeOutCaller(int track, float speed)
    {
        // calls the fade Out Coroutine via this script
        instance.StartCoroutine(FadeOut(track, speed));
    }

    public static void LoopCaller(int track, float cLength, AudioClip a_Clip, List<AudioClip> acList, int min, int max)
    {
        instance.StartCoroutine(Loop(track, cLength, a_Clip, acList, min, max));
    }

    public static void ChangeTrackCaller(int track, float speed, AudioClip a_Clip = null, List<AudioClip> acList = null, int min = -2, int max = -2)
    {
        instance.StartCoroutine(ChangeTrack(track, speed, a_Clip, acList, min, max));
    }

    // Coroutines....
    static IEnumerator FadeIn(int track, float speed, float maxVolume)
    {
        Debug.Log("Fading In Track: " + track);
        fadingIn = true;
        fadingOut = false;

        TrackList[track].audioSource.volume = 0;
        float aVolume = TrackList[track].audioSource.volume;

        while(TrackList[track].audioSource.volume < maxVolume && fadingIn)
        {
            aVolume += speed;
            TrackList[track].audioSource.volume = aVolume;
            yield return new WaitForSeconds(0.1f);
        }
    }
    

    //
    // Issue With Fade Out atm...
    //
    static IEnumerator FadeOut (int track, float speed)
    {
        //Debug.Log("Fading Out Track: " + track);
        fadingIn = false;
        fadingOut = true;

        float aVolume = TrackList[track].audioSource.volume;

        while (TrackList[track].audioSource.volume >= speed && fadingOut)
        {
            aVolume -= speed;
            TrackList[track].audioSource.volume = aVolume;
            yield return new WaitForSeconds(0.1f);
        }
    }
    //
    //

    static IEnumerator Loop(int track, float cLength, AudioClip a_Clip = null, List<AudioClip> acList = null, int min = -2, int max = -2)
    {
        //Debug.Log("Looping Track:" + track);
        yield return new WaitForSeconds(Mathf.Round(ClipLength));

        PlayMusic(track, a_Clip, acList, min, max);
    }

    static IEnumerator ChangeTrack(int cID, float speed, AudioClip a_Clip = null, List<AudioClip> acList = null, int min = -2, int max = -2)
    {
        // Debugging
        //Debug.Log("Track is Changing to Track:" + cID);
        FadeOutCaller(cID, speed);
        while (TrackList[cID].audioSource.volume >= speed)
        { yield return new WaitForSeconds(0.01f); }

        TrackList[cID].audioSource.Stop();

        if(a_Clip != null)
        {
            // Looping the Played Clip or not looping it...
            if (a_Clip != null)
            {

                TrackList[cID].audioSource.PlayOneShot(a_Clip, TrackList[cID].Track_Volume);

                    ClipLength = a_Clip.length;
                    // loop
                    FadeInCaller(cID, speed, TrackList[cID].Track_Volume);

                    LoopCaller(cID, ClipLength, a_Clip, null, min, max);
                
            }

            if (acList != null)
            {
                int index = Random.Range(min, max);

                if (index == -1)
                {
                    // no sound
                    Debug.Log("no Sound -1 true");
                }
                else
                {
                    TrackList[cID].audioSource.PlayOneShot(acList[index], TrackList[cID].Track_Volume);
                    ClipLength = acList[index].length;


                    FadeInCaller(cID, speed, TrackList[cID].Track_Volume);
                    // loop
                    LoopCaller(cID, ClipLength, a_Clip, acList, min, max);
                }
            }
        }
    }
}
