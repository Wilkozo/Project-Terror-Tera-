using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rock : MonoBehaviour
{

    public float speed;

    public Rigidbody rb;

    public float timer;
    public float maxTimer;

    private void Update()
    {
        timer++;
        if (timer > maxTimer) {
            //destroy the rock
            Destroy(this.gameObject);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        //if the rock collides with the ground
        if (other.tag == "Ground")
        {
            //send out an overlap sphere
            Collider[] hits = Physics.OverlapSphere(transform.position, 35.0f);
            int i = 0;

            //for each thing it hits
            while (i < hits.Length)
            {
                //send a message to anything that it hits, gets the ai to move to the rock collision point
                hits[i].SendMessage("HeardSomethingRock", SendMessageOptions.DontRequireReceiver);
                //increment the value of i
                i++;
            }
        }
    }

}
