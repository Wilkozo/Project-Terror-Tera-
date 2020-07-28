using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Respawn : MonoBehaviour
{
    //lets the player know they have activated a checkpoint
    public Text message;
    //where to reset the player
    public Transform checkpointPosition;
    //player
    public Transform player;

    private void Start()
    {
        //finding the player
        player = GameObject.FindGameObjectWithTag("Player").transform;
    }


    //when the player collides with the respawn box
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player") {
            //change the position of the checkpoint respawn
            checkpointPosition = this.gameObject.transform;
            //lets the player know that they have reached a checkpoint
            message.CrossFadeAlpha(1, 0, true);
            message.text = "This seems like a safe place";
            message.CrossFadeAlpha(0, 10.0f, true);
        }
    }

    //when the player dies call this
    public void onPlayerDeath() {
        //set the player to the current checkpoint position
        player = checkpointPosition;
    }

}
