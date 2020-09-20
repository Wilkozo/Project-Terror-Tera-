using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Danger_Audio : MonoBehaviour
{
    //
    public int Track_ID;
    public AudioSource audioSource;
    public float Track_Volume;
    public bool loop;

    //
    public GameObject Player;
    public GameObject Raptor;

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
        
    }

    // Update is called once per frame
    void Update()
    {
        // While Safe
        // if outside the caution zone and danger zone
        if (Vector3.Distance(Raptor.transform.position, Player.transform.position) > SafeDistance && !StealthZone)
        {
            Debug.Log("Safe");
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
        if (Vector3.Distance(Raptor.transform.position, Player.transform.position) <= SafeDistance && Vector3.Distance(Raptor.transform.position, Player.transform.position) > CautionDistance && !CautionZone)
        {
            Debug.Log("Take Caution.");
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
        if (Vector3.Distance(Raptor.transform.position, Player.transform.position) <= CautionDistance && !ChaseZone)
        {
            Debug.Log("Run!");
            StealthZone = false;
            CautionZone = false;
            ChaseZone = true;
            // Fade to Danger / Chase MUSIC
            Danger_Manager.PlayMusic(gameObject, Danger[0]);
            //
            //FindObjectOfType<AudioManager>().Play("Chase");
        }
    }
}
