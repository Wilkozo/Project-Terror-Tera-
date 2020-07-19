using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//used for the scripted event for when the raptors first see the player
//and they run from the player
public class RaptorFlee : MonoBehaviour
{
    //get the WaypointNavigator script
    [SerializeField] WaypointNavigator navigator;
    public Waypoint newWaypoint;

    private void Start()
    {
        navigator.enabled = true;
    }

    private void OnTriggerEnter(Collider other)
    {
        //if the ai collides with the player
        if (other.tag == "Player") {
            //run away from the player into the forest
            //set it so the raptors will follow through a path
            navigator.currentWaypoint = newWaypoint;
            //if there is no next waypoint
            if (navigator.currentWaypoint == null) {
                //Destroy the raptor
                Destroy(this.gameObject);
            }

        }
    }

}
