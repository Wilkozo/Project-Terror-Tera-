using System.Collections;
using System.Collections.Generic;
using UnityEngine;


//used to detect audio and visual sources
public class Detect : MonoBehaviour
{

    //used to hold the player
    public Transform player;


    void Update()
    {
        RaycastHit objectHit;

        Vector3 targetDir = player.position - transform.position;
        float angle = Vector3.Angle(targetDir, transform.forward);

        if (angle < 45 && targetDir.x < 10 && targetDir.z < 10)
        {
            transform.LookAt(player.transform);
        }

        Vector3 fwd = transform.TransformDirection(Vector3.forward);
        Debug.DrawRay(transform.position, fwd * 10, Color.green);
        if (Physics.Raycast(transform.position, fwd, out objectHit, 10.0f))
        {
            //do something if hit object ie
            if (objectHit.transform.tag == "Player")
            {
                SeenPlayer();
            }
        }

        ////draws a line from the front of the enemy
        //Vector3 forward = transform.TransformDirection(Vector3.forward) * hit.distance;
        //Debug.DrawRay(transform.position, forward, Color.green);

        //Vector3 targetDir = player.position - transform.position;
        //float angle = Vector3.Angle(targetDir, transform.forward);

        //if (angle < 60.0f && hit.distance < 2.5f)
        //{
        //    SeenPlayer();
        //}
        //else {
        //    float step = 1 * Time.deltaTime; // calculate distance to move
        //    transform.position = Vector3.MoveTowards(transform.position, Vector3.zero, step);
        //}
    }


    //what to do when the ai has seen the player
    void SeenPlayer() {
      
        float step = 1 * Time.deltaTime; // calculate distance to move
        transform.LookAt(player.position);
        transform.position = Vector3.MoveTowards(transform.position, player.position, step);

    }

    //what to do when the ai has heard the player
    void HeardPlayer() { 
    
    
    }


}
