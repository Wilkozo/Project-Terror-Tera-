using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using UnityEditor;
using System;
using UnityEngine.Audio;

[Serializable]
public class Danger_Audio : MonoBehaviour
{
    // 
    public int Track_ID;
    public AudioSource audioSource;
    public float Track_Volume;
    public bool loop;

    // audio mixer var
    public AudioMixer mixA;


    // Player & Raptor GameObject vars
    // Raptors will need to become a list
    // To account for the number of enemies
    public GameObject Player;

    public List<GameObject> Raptor = new List<GameObject>();
    //public GameObject Raptor;
    public GameObject T_Rex;

    // distance from enemy variables
    public float SafeDistance = 100;
    public float CautionDistance = 50;

    // audio clip list variables
    public List<AudioClip> Stealth;
    public List<AudioClip> Caution;
    public List<AudioClip> Danger;

    //
    private bool StealthZone = true;
    private bool CautionZone = false;
    private bool ChaseZone = false;
    // Danger music is playing
    public bool dmIsPlaying = false;

    // Start is called before the first frame update
    void Start()
    {
        // Saves some Memory
        FindObjectOfType<Audio_Plugin>().pInDanger = false;
        audioSource = Player.GetComponent<AudioSource>();
        //
        Danger_Manager.AddSongs(3, gameObject);
        // Plays Chase music in audio mixer group with 0.5 vol looping true...
        Danger_Manager.ClipSettings(0, mixA, "Stealth", 0.0f, true);
        Danger_Manager.ClipSettings(1, mixA, "Caution", 0.75f, true);
        Danger_Manager.ClipSettings(2, mixA, "Chase", 0.75f, true);

        Danger_Manager.ClipSettings(0, mixA, "Stealth", 0.5f, true);
        Danger_Manager.PlayMusic(0, Stealth[0]);
        //Danger_Manager.FadeInCaller(0, 0.01f, Danger_Manager.TrackList[0].Track_Volume);

        
        
        //Danger_Manager.PlayMusic(0, Caution[0]);
    }

    // Update is called once per frame
    void Update()
    {
        //      //      //
        //  Raptors     //
        //      //      //
        // While Safe
        // if outside the caution zone and danger zone

        for (int i = 0; i < Raptor.Count; i++)
        {

            if (Vector3.Distance(Raptor[i].transform.position, Player.transform.position) > SafeDistance && !StealthZone)
            {
                if (CautionZone)
                {
                    Debug.Log("Player Not in Danger...");
                    // Sets a global bool to mute ambient playlist...
                    FindObjectOfType<Audio_Plugin>().pInDanger = false;
                }
                Debug.Log("Safe (Raptor)");
                StealthZone = true;
                CautionZone = false;
                ChaseZone = false;


                // Fade to SAFE / STANDARD MUSIC
                Danger_Manager.ClipSettings(1, mixA, "Caution", 0.5f, true);
                Danger_Manager.ChangeTrackCaller(0, 0.5f, Stealth[0]);

                //Danger_Manager.PlayMusic(gameObject, Stealth[0]);
                //
                //FindObjectOfType<AudioManager>().Play("Safe");
            }

            // While Sneaking
            // if outside safe zone but also outside Chase zone
            if (Vector3.Distance(Raptor[i].transform.position, Player.transform.position) <= SafeDistance && Vector3.Distance(Raptor[i].transform.position, Player.transform.position) > CautionDistance && !CautionZone)
            {
                Debug.Log("Take Caution. (Raptor)");
                StealthZone = false;
                CautionZone = true;
                ChaseZone = false;

                Debug.Log("Player is in Danger...");
                // Sets a global bool to mute ambient playlist...
                FindObjectOfType<Audio_Plugin>().pInDanger = true;

                // Fade to Sneaking / Tension MUSIC


                //Danger_Manager.ClipSettings(2, mixA, "Chase", 0.5f, true);
                Danger_Manager.ChangeTrackCaller(1, 0.5f, Caution[0]);

                //if (!audioSource.isPlaying)

                //Danger_Manager.PlayMusic(gameObject, Caution[0]);



                //
                //FindObjectOfType<AudioManager>().Play("Caution");
            }

            // While Chasing
            // While very close to the Raptor
            if (Vector3.Distance(Raptor[i].transform.position, Player.transform.position) <= CautionDistance && !ChaseZone)
            {
                Debug.Log("Run! (Raptor)");
                StealthZone = false;
                CautionZone = false;
                ChaseZone = true;

                Debug.Log("Player in Danger...");
                // Sets a global bool to mute ambient playlist...
                FindObjectOfType<Audio_Plugin>().pInDanger = true;


                // Fade to Danger / Chase MUSIC
                Danger_Manager.FadeOutCaller(0, 0.5f);
                Danger_Manager.FadeOutCaller(1, 0.5f);

                Danger_Manager.ChangeTrackCaller(2, 0.5f, Danger[0]);

                //if (!audioSource.isPlaying && audioSource.name != "Danger")

                //Danger_Manager.PlayMusic(gameObject, Danger[0]);




                //
                //FindObjectOfType<AudioManager>().Play("Chase");
            }

        }

        /*
        //      //      //
        //    T-Rex     //
        //      //      //
        // Currently Plays both Tracks
        
        // While Safe
        // if outside the caution zone and danger zone
        if (Vector3.Distance(T_Rex.transform.position, Player.transform.position) > SafeDistance && !StealthZone)
        {
            Debug.Log("Keep it in Sight! (Rex)");
            StealthZone = true;
            CautionZone = false;
            ChaseZone = false;
            // Fade to SAFE / STANDARD MUSIC
            Danger_Manager.PlayMusic(gameObject, Stealth[0]);
            //
            //FindObjectOfType<AudioManager>().Play("Safe");
        }

        // While Sneaking
        // if outside safe zone but also outside Chase zone
        if (Vector3.Distance(T_Rex.transform.position, Player.transform.position) <= SafeDistance && Vector3.Distance(T_Rex.transform.position, Player.transform.position) > CautionDistance && !CautionZone)
        {
            Debug.Log("Hide! (Rex)");
            StealthZone = false;
            CautionZone = true;
            ChaseZone = false;
            // Fade to Sneaking / Tension MUSIC
            Danger_Manager.PlayMusic(gameObject, Caution[0]);
            //
            //FindObjectOfType<AudioManager>().Play("Caution");
        }

        // While Chasing
        // While very close to the Raptor
        if (Vector3.Distance(T_Rex.transform.position, Player.transform.position) <= CautionDistance && !ChaseZone)
        {
            Debug.Log("Run! (Rex)");
            StealthZone = false;
            CautionZone = false;
            ChaseZone = true;
            // Fade to Danger / Chase MUSIC
            Danger_Manager.PlayMusic(gameObject, Danger[0]);
            //
            //FindObjectOfType<AudioManager>().Play("Chase");
        }

        */

        if (FindObjectOfType<Audio_Plugin>().pInDanger == false)
        {
            Danger_Manager.FadeOutCaller(0, 0.01f);
            Danger_Manager.FadeOutCaller(1, 0.01f);
            Danger_Manager.FadeOutCaller(2, 0.01f);
        }




    }
}
