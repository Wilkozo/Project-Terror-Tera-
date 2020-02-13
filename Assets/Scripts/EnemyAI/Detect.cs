using System.Collections;
using System.Collections.Generic;
using UnityEngine;


//used to detect audio and visual sources
public class Detect : MonoBehaviour
{


    [SerializeField] BasicWander wander;
    //used to hold the player
    public Transform player;

    //how fast the ai will travel
    public float speed;


    void Update()
    {
     
        //raycast hiting object
        RaycastHit objectHit;

        //gets the target position to move to
        Vector3 targetDir = player.position - transform.position;
        //gets the angle between the player and this transform
        float angle = Vector3.Angle(targetDir, transform.forward);

        //if the angle is less than 45 and the player is not more than 10 units away
        if (angle < 45 && targetDir.x < 10 && targetDir.z < 10)
        {
            //look at the player
            transform.LookAt(player.transform);
        }

        //get the forward vector3
        Vector3 fwd = transform.TransformDirection(Vector3.forward);
        //draw a ray from the enemy
        Debug.DrawRay(transform.position, fwd * 10, Color.green);
        //if it hits something then proceed
        if (Physics.Raycast(transform.position, fwd, out objectHit, 10.0f))
        {
            //if it hit the player then move towards the player
            if (objectHit.transform.tag == "Player")
            {
                //what to do when it sees the player
                SeenPlayer();
            }
            else {
                wander.playerNotSeen = true;
            }
        }

    }

    //what to do when the ai has seen the player
    void SeenPlayer() {

        wander.playerNotSeen = false;
        float step = speed * Time.deltaTime; // calculate distance to move
        transform.LookAt(player.position);
        transform.position = Vector3.MoveTowards(transform.position, player.position, step);

    }

    //what to do when the ai has heard the player
    //TODO:
    void HeardPlayer() { 
    
    
    }


}
