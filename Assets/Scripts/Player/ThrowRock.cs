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
        if (Input.GetKeyDown(KeyCode.E))
        {
            GameObject[] temp = GameObject.FindGameObjectsWithTag("Rock");
            if (temp.Length < 1)
            {
                Rigidbody bulletClone = (Rigidbody)Instantiate(rock, transform.position, transform.rotation);
                bulletClone.velocity = transform.forward * rockSpeed;
            }
        }
    }

}
