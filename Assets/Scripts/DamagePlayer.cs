using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DamagePlayer : MonoBehaviour
{
    public AudioSource source;
    public AudioClip clip;

    private void OnTriggerStay(Collider other)
    {
        if (other.tag == "Player") {
            other.GetComponent<playerHealth>().health -= 0.5f * Time.deltaTime;
        }
    }

    private void Update()
    {
        float random = Random.Range(0, 1000);

        if (random >= 999 && !source.isPlaying)
        {
            source.PlayOneShot(clip);
        }
    }

}
