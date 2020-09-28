using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioLog : MonoBehaviour
{

    public AudioClip clip;
    public AudioSource source;

    //what to do when the player has collected the casette
    public void Collected() {
        StartCoroutine(example());
    }

    //play the clip and destroy itself when it is finished
    IEnumerator example()
    {
        source.PlayOneShot(clip);
        this.GetComponentInChildren<MeshRenderer>().enabled = false;
        yield return new WaitWhile(() => source.isPlaying);
        Destroy(this.gameObject);
    }



}

