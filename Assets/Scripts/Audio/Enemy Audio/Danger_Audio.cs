using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using UnityEditor;
using System;

[Serializable]
public class Danger_Audio : MonoBehaviour
{
    //
    public int Track_ID;
    public AudioSource audioSource;
    public float Track_Volume;
    public bool loop;

    // Player & Raptor GameObject vars
    // Raptors will need to become a list
    // To account for the number of enemies
    public GameObject Player;
    public GameObject Raptor;
    public GameObject T_Rex;

    //
    public float SafeDistance = 100;
    public float CautionDistance = 50;

    //
    public List<AudioClip> Stealth;
    public List<AudioClip> Caution;
    public List<AudioClip> Danger;

    //
    private bool StealthZone = true;
    private bool CautionZone = false;
    private bool ChaseZone = false;

    // Start is called before the first frame update
    void Start()
    {
        // Saves some Memory
        FindObjectOfType<Audio_Plugin>().pInDanger = false;
    }

    // Update is called once per frame
    void Update()
    {
        //      //      //
        //  Raptors     //
        //      //      //
        // While Safe
        // if outside the caution zone and danger zone
        if (Vector3.Distance(Raptor.transform.position, Player.transform.position) > SafeDistance && !StealthZone)
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
            //Danger_Manager.PlayMusic(gameObject, Stealth[0]);
            //
            //FindObjectOfType<AudioManager>().Play("Safe");
        }

        // While Sneaking
        // if outside safe zone but also outside Chase zone
        if (Vector3.Distance(Raptor.transform.position, Player.transform.position) <= SafeDistance && Vector3.Distance(Raptor.transform.position, Player.transform.position) > CautionDistance && !CautionZone)
        {
            Debug.Log("Take Caution. (Raptor)");
            StealthZone = false;
            CautionZone = true;
            ChaseZone = false;

            // Sets a global bool to mute ambient playlist...
            FindObjectOfType<Audio_Plugin>().pInDanger = true;

            // Fade to Sneaking / Tension MUSIC
            Danger_Manager.PlayMusic(gameObject, Caution[0]);
            

            //
            //FindObjectOfType<AudioManager>().Play("Caution");
        }

        // While Chasing
        // While very close to the Raptor
        if (Vector3.Distance(Raptor.transform.position, Player.transform.position) <= CautionDistance && !ChaseZone)
        {
            Debug.Log("Run! (Raptor)");
            StealthZone = false;
            CautionZone = false;
            ChaseZone = true;

            // Sets a global bool to mute ambient playlist...
            FindObjectOfType<Audio_Plugin>().pInDanger = true;

            // Fade to Danger / Chase MUSIC
            Danger_Manager.PlayMusic(gameObject, Danger[0]);
            
            
            //
            //FindObjectOfType<AudioManager>().Play("Chase");
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






    }
}
