using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using UnityEngine.Audio;

public class Danger_Manager : MonoBehaviour
{
    static public void PlayMusic(GameObject g_Object, AudioClip a_Clip)
    {
        g_Object.GetComponent<AudioSource>().PlayOneShot(a_Clip);
    }


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
