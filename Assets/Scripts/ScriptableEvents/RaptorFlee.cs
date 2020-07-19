using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//used for the scripted event for when the raptors first see the player
//and they run from the player
public class RaptorFlee : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        //if the ai collides with the player
        if (other.tag == "Player") {
            //run away from the player into the forest

        }
    }

}
