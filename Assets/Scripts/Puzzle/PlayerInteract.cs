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
        if (Input.GetKeyDown(KeyCode.M) && mapAquired)
        {
            map.SetActive(!mapEnabled);
            mapEnabled = !mapEnabled;
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
            //if the player hits a document make it readible
            if (hit.transform.tag == "Document") {
                //sends a message to run a function from another script
                hit.transform.SendMessage("ReadMessage");
            }
            //the player hits the audio log
            if (hit.transform.tag == "AudioLog") {
                hit.transform.GetComponent<AudioLog>().Collected();
            }

            if (hit.transform.name == "ManorDocuments") {
                //enable the dinosaurs
                hit.transform.GetComponent<EnableDinosaurs>().OnCollectDocuments();
                //destroy the hit game object
                Destroy(hit.transform.gameObject);
            }

            if (hit.transform.name == "Shotgun") {
                this.GetComponentInChildren<Gun>().gotShotgun = true;
                Destroy(hit.transform.gameObject);
            }

            if (hit.transform.name == "radioTower") {
                hit.transform.GetComponent<RadioTower>().OnRadioInteract();
            }

            if (hit.transform.name == "Boat" && Keycards.haveRadioedIn()) {
                Application.LoadLevel("NewMainMenu");
            }

            #region "Keycards"
            if (hit.transform.tag == "GreenKeycard") {
                Keycards.setKeycardLevel(1);
                Destroy(hit.transform.gameObject);
            }
            if (hit.transform.tag == "BlueKeycard")
            {
                Keycards.setKeycardLevel(2);
                Destroy(hit.transform.gameObject);
            }
            if (hit.transform.tag == "RedKeycard")
            {
                Keycards.setKeycardLevel(3);
                Destroy(hit.transform.gameObject);
            }
            if (hit.transform.name == "Door") {
                hit.transform.GetComponent<Doors>().OpenDoor();
            }
            #endregion

            #region "Button Puzzle"
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
            #endregion

            //if the player hits something with the name map
            //give the player the map 
            if (hit.transform.name == "Map") {
                mapAquired = true;
                Destroy(GameObject.Find("Map"));  
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

