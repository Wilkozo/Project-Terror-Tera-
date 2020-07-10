using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class PlayerInteract : MonoBehaviour
{

    //camera reference
    Camera cam;

    //get a reference to the map
    public GameObject map;
    public bool mapEnabled = true;

    bool mapAquired;

    [SerializeField] PlayerManager playerManager;
    [SerializeField] PowerOn power;

    //the amount of levers that the player has interacted with
    [SerializeField] int amountOfLeversPulled;

    void Start()
    {

        //find the map
        //FindObjectOfType<AudioManager>().Play("BGM01");
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

            #region "Keycards"
            if (hit.transform.tag == "GreenKeycard") {
                Keycards.setKeycardLevel(1);
                Destroy(hit.transform.gameObject);
            }
            if (hit.transform.tag == "RedKeycard")
            {
                Keycards.setKeycardLevel(2);
                Destroy(hit.transform.gameObject);
            }
            if (hit.transform.tag == "BlueKeycard")
            {
                Keycards.setKeycardLevel(3);
                Destroy(hit.transform.gameObject);
            }
            if (hit.transform.name == "Door") {
                hit.transform.GetComponent<Doors>().OpenDoor();
            }
            #endregion

            if (hit.transform.name == "ButtonOne") {
                hit.transform.GetComponentInParent<PowerOn>().buttonPushOne();
            }
            if (hit.transform.name == "ButtonThree")
            {
                hit.transform.GetComponentInParent<PowerOn>().buttonPushThree();
            }
            if (hit.transform.name == "ButtonTwo")
            {
                hit.transform.GetComponentInParent<PowerOn>().buttonPushTwo();
            }
            if (hit.transform.name == "ButtonReset")
            {
                hit.transform.GetComponentInParent<PowerOn>().resetPuzzle();
            }


            if (hit.transform.name == "Map") {
                mapAquired = true;
                Destroy(GameObject.Find("Map"));  
            }
            if (hit.transform.name == "PowerOn")
            {
                GameObject.FindGameObjectWithTag("Power").SendMessage("onPowerUp");
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

