using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//basic audio effect for when the player hits a trigger box
public class RaptorSFXBridge : MonoBehaviour
{
    //audio source
    public AudioSource audioSource;
    //audio clip to be played
    public AudioClip audioClip;
    
    private void OnTriggerEnter(Collider other)
    {
        //if the player collides with the trigger box
        if (other.tag == "Player" && !audioSource.isPlaying) {
            //play the audio source once
            audioSource.PlayOneShot(audioClip);
            //wait for 2 seconds before destroying the trigger box
            StartCoroutine(wait());
    
        }
    }

    IEnumerator wait() {
        yield return new WaitForSeconds(2);
        //destroy this trigger box
        Destroy(this.gameObject);
    }
}

