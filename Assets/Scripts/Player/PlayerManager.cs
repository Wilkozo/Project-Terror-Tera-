using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerManager : MonoBehaviour
{

    //get a reference to the map
    public GameObject map;
    public bool mapEnabled = false;

    // Start is called before the first frame update
    void Start()
    {
        //find the map
        map = GameObject.FindGameObjectWithTag("Map");
        //set the map to false
        map.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {

        //enable/disable map
        if (Input.GetKeyDown(KeyCode.M)) {
            Debug.Log(mapEnabled);
            map.SetActive(!mapEnabled);
            mapEnabled = !mapEnabled;
        }
    }
}
