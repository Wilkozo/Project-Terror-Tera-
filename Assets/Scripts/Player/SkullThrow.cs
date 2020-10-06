using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SkullThrow : MonoBehaviour
{
    //whether the player has a skull or not
    public bool hasSkull;

    public float skullSpeed = 10;
    public Rigidbody skull;

    public GameObject skullModel;

    //how much munitions the player has
    public int skullCount;
    float delay;

    private void Start()
    {
        skullModel.SetActive(false);
    }

    //what to do when the player picks up ammo
    public bool pickup()
    {
        if (skullCount == 0) {
            //make it so they have a skull to throw
            skullCount = 1;
            hasSkull = true;
            //make it so the player has a skull model enabled
            skullModel.SetActive(true);
            return true;
        }
        return false;
    }

    // Update is called once per frame
    void Update()
    {
        //gives a delay so the player cannot spam fire the gun
        delay += Time.deltaTime;
        //what to do if the player has the shotgun equipped
        if (hasSkull)
        {
                //if the player pushes the left mouse button and has ammo
                if (Input.GetMouseButtonDown(0) && skullCount > 0 && delay >= 1)
            {
                hasSkull = false;
                //alert the dinosaur
                audioSenderGun(40.0f);
                    Rigidbody slugRoundClone = (Rigidbody)Instantiate(skull, transform.position, transform.rotation);
                    slugRoundClone.velocity = transform.forward * skullSpeed;
                    delay = 0;
                    //reduce skull count by one
                    skullCount -= 1;
         
                }
            }
        }

    private void audioSenderGun(float radius)
    {

        Collider[] hits = Physics.OverlapSphere(transform.position, radius);
        int i = 0;

        while (i < hits.Length)
        {
            hits[i].SendMessage("HeardSomethingPlayer", SendMessageOptions.DontRequireReceiver);
            i++;
        }
    }
}