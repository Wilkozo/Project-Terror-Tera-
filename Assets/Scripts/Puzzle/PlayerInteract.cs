using System.Collections;
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
    public bool mapEnabled = true;

    bool mapAquired;

    public GameObject boat;

    [SerializeField] PlayerManager playerManager;
    [SerializeField] PowerOn power;

    //the amount of levers that the player has interacted with
    [SerializeField] int amountOfLeversPulled;

    void Start()
    {
        boat.SetActive(false);

        //find the map
        FindObjectOfType<AudioManager>().Play("BGM01");
        map = GameObject.FindGameObjectWithTag("Map");
        //set the map to false
        map.SetActive(false);

        //get the camera
        cam = GetComponent<Camera>();

    }


    void Update()
    {

        //enable/disable map
        if (Input.GetKeyDown(KeyCode.M))
        {
            Debug.Log("Enable the map?????");
            map.SetActive(!mapEnabled);
            mapEnabled = !mapEnabled;
        }

        if (Input.GetKeyDown(KeyCode.Escape)) {
            //load into a pause menu
        }

        //check to see if the player pushes the left mouse 
        if (Input.GetKeyDown(KeyCode.E)) {
            //call check for interact
            checkForInteract();
        }
    }

    //used to check to see if the player can pickup an item or activate something else
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
            if (hit.transform.name == "Radio" && power.poweredOn) {
                FindObjectOfType<AudioManager>().Play("");
                boat.SetActive(true);
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

