﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class PlayerInteract : MonoBehaviour
{
    //public Text switchesText;

    //camera reference
    Camera cam;

    //get a reference to the map
    public GameObject map;
    public bool mapEnabled = false;

    bool mapAquired;

    //the amount of levers that the player has interacted with
    [SerializeField] int amountOfLeversPulled;

    void Start()
    {


        //find the map
        map = GameObject.FindGameObjectWithTag("Map");
        //set the map to false
        map.SetActive(false);

        //switchesText.text = "Switches Pushed: 0 : 4";
        //get the camera
        cam = GetComponent<Camera>();

    }


    void Update()
    {

        //enable/disable map
        if (Input.GetKeyDown(KeyCode.M) && mapAquired)
        {
            Debug.Log(mapEnabled);
            map.SetActive(!mapEnabled);
            mapEnabled = !mapEnabled;
        }

        //TEMP STUFF DELETE LATER
        if (Input.GetKeyDown(KeyCode.R)) {
            Time.timeScale = 1;
            Application.LoadLevel(Application.loadedLevel);  
        }
        if (Input.GetKeyDown(KeyCode.Escape)) {
            Application.Quit();
        }
        //END OF TEMP STUFF

        //check to see if the player pushes the left mouse 
        if (Input.GetMouseButtonDown(0)) {
            //call check for interact
            checkForInteract();
        }
    }

    //used to check to see if the player can pickup an item or activate something else

    //TODO: make this return the name of the object that was hit to a script if it asks
    public string checkForInteract() {

        //sends a raycast from the camera
        Ray ray = cam.ViewportPointToRay(new Vector3(0.5F, 0.5F, 0));
        //the raycast hit
        RaycastHit hit;


        //checks to see if the raycast hits anything within 50 units
        if (Physics.Raycast(ray, out hit, 50.0f))
        {
            print("I'm looking at " + hit.transform.name);
            //if the object that is hit is an interactive then call the correct interactive
            if (hit.transform.tag == "Lever") {
                amountOfLeversPulled++;
                //destroy the lever that has been pulled
                Destroy(hit.transform.gameObject);

                //DELTE LATER
                //switchesText.text = "Switches Pushed: " + amountOfLeversPulled.ToString() + " : 4 ";
                //just some debug stuff DELETE LATER
                Debug.Log("Pulled the lever Kronk");
            }
            if (hit.transform.tag == "Document") {
                //sends a message to run a function from another script
                hit.transform.SendMessage("ReadMessage");
            }

            if (hit.transform.name == "Map") {
                mapAquired = true;
                Destroy(GameObject.Find("Map"));
                
            }
            if (hit.transform.name == "PowerOn")
            {
                GameObject.FindGameObjectWithTag("Power").SendMessage("onPowerUp");
            }

            //if the player hits the gate button
            if (hit.transform.name == "ButtonToLowerGate") {
                // if the player has the map then they can open the main gate
                if (mapAquired)
                {
                    Destroy(GameObject.Find("Gate1"));
                }
            }
        }

        //if it doesn't then don't worry, the player is looking at nothing
        else
        {
            print("I'm looking at nothing!");
        }

        //used for puzzles that involve pushing buttons with specific names
        return hit.transform.name;
    }

}

