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

    public Sprite mapSec2;
    public Sprite mapSec3;
    public Sprite mapSec4;
    public Sprite mapSec5;

    [SerializeField] Endings gameEndings;

    bool mapAquired;

    void Start()
    {

        //find the map
        map = GameObject.FindGameObjectWithTag("Map");
        //set the map to false
        map.SetActive(false);

        //get the camera
        cam = GetComponent<Camera>();

    }

    void Update()
    {

        if (Input.GetKey(KeyCode.P)) {
            Keycards.setPoweredOn();
        }
        if (Input.GetKey(KeyCode.R)) {
            Keycards.setRadioedIn();
        }
        if (Input.GetKey(KeyCode.N)) {
            Keycards.collectedNecklace();
        }

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
            if (hit.transform.name == "Skull") {
                if (this.GetComponentInChildren<SkullThrow>().pickup()) {
                    Destroy(hit.transform.gameObject);
                }
                
            }

            if (hit.transform.name == "Necklace") {
                Keycards.collectedNecklace();
                Destroy(hit.transform.gameObject);
            }

            if (hit.transform.name == "BlueKeycard") {
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

            //if the player interacts with the boat when the power is on
            if (hit.transform.name == "Boat" && Keycards.haveRadioedIn()) {
                //what to do when the player has the necklace
                if (Keycards.hasNecklace())
                {
                    gameEndings.goodEndingBoat();
                }
                //what to do when the player does not have the necklace
                else {
                    gameEndings.badEndingBoat();
                }
            }            

            #region "Keycards"
            if (hit.transform.tag == "GreenKeycard") {
                Keycards.setKeycardLevel(1);
                // Green Key card - Sound
                Destroy(hit.transform.gameObject);
            }
            if (hit.transform.tag == "BlueKeycard")
            {
                Keycards.setKeycardLevel(2);
                // Blue Key card - Sound
                Destroy(hit.transform.gameObject);
            }
            if (hit.transform.tag == "RedKeycard")
            {
                Keycards.setKeycardLevel(3);
                // Red Key card - Sound
                Destroy(hit.transform.gameObject);
            }
            if (hit.transform.tag == "Door") {
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
                // SFX MAP COLLECTED 01
                Destroy(GameObject.Find("Map"));  
            }
            if (hit.transform.name == "Sec2Map") {
                map.GetComponent<Image>().sprite = mapSec2;
                // SFX MAP COLLECTED 02

                Destroy(hit.transform.gameObject);
            }
            if (hit.transform.name == "Sec3Map")
            {
                map.GetComponent<Image>().sprite = mapSec3;
                // SFX MAP COLLECTED 03

                Destroy(hit.transform.gameObject);
            }
            if (hit.transform.name == "Sec4Map")
            {
                map.GetComponent<Image>().sprite = mapSec4;
                // SFX MAP COLLECTED 04

                Destroy(hit.transform.gameObject);
            }
            if (hit.transform.name == "Sec5Map")
            {
                map.GetComponent<Image>().sprite = mapSec5;
                // SFX MAP COLLECTED 05

                Destroy(hit.transform.gameObject);
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

