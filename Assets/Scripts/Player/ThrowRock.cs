using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ThrowRock : MonoBehaviour
{

    public float rockSpeed = 10;
    public Rigidbody rock;
    
    // Update is called once per frame
    void Update()
    {
        //user pushes e
        if (Input.GetKeyDown(KeyCode.E))
        {
            //finds all of the rocks
            GameObject[] temp = GameObject.FindGameObjectsWithTag("Rock");
            //if there are less than one rock
            if (temp.Length < 1)
            {
                //create a rock and give it some velocity
                Rigidbody rockClone = (Rigidbody)Instantiate(rock, transform.position, transform.rotation);
                rockClone.velocity = transform.forward * rockSpeed;
            }
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        
    }
}
