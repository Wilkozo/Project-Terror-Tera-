using System.Collections;
using System.Collections.Generic;
using UnityEngine;


//used as a base class for ai to wander
public class BasicWander : MonoBehaviour
{

    Vector3 rand;

    public float zPos1;
    public float zPos2;
    public float xPos1;
    public float xPos2;

    public float speed = 5;
    bool goToWaypoint = true;

    void Update()
    {
        if (goToWaypoint == true) {
            moveBetweenWaypoints();
        }
    }

    void moveBetweenWaypoints() {

        //should stop it from looping through the random position setting
        goToWaypoint = false;

        //get a random value in the form of a vec3
        rand = new Vector3(Random.Range(xPos1, xPos2), 0, Random.Range(zPos1, zPos2));

        //run this loop while the position has not been reached
        while (goToWaypoint != true)
        {
            //TODO:: Setup an interrupt state
            float step = speed * Time.deltaTime; // calculate distance to move
            transform.position = Vector3.MoveTowards(transform.position, rand, step);


            if (this.transform.position.x >= rand.x && this.transform.position.z >= rand.z) {
                goToWaypoint = true;
            }
        }
    }
}
