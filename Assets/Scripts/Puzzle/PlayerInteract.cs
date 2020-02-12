using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInteract : MonoBehaviour
{

    //camera reference
    Camera cam;

    //the amount of levers that the player has interacted with
    [SerializeField] int amountOfLeversPulled;

    void Start()
    {
        //get the camera
        cam = GetComponent<Camera>();
    }


    void Update()
    {
        //check to see if the player pushes the left mouse 
        if (Input.GetMouseButtonDown(0)) {
            //call check for interact
            checkForInteract();
        }

        if (amountOfLeversPulled >= 4) { 
            //TODO: put through an event that leads to the end of the game
        }
    }

    //used to check to see if the player can pickup an item or activate something else
    void checkForInteract() {

        //sends a raycast from the camera
        Ray ray = cam.ViewportPointToRay(new Vector3(0.5F, 0.5F, 0));
        //the raycast hit
        RaycastHit hit;


        //checks to see if the raycast hits anything within 50 units
        if (Physics.Raycast(ray, out hit, 50.0f))
        {
            print("I'm looking at " + hit.transform.name);
            //if the object that is hit is an interactive then call the correct interactive
            if (hit.transform.tag == "Interactive") {
                amountOfLeversPulled++;
                //destroy the lever that has been pulled
                Destroy(hit.transform.gameObject);
                //just some debug stuff DELETE LATER
                Debug.Log("Pulled the lever Kronk");
            }
        }

        //if it doesn't then don't worry
        else
        {
            print("I'm looking at nothing!");
        }
    }

}

