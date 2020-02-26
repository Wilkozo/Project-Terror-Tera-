using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PowerOn : MonoBehaviour
{

    public GameObject[] lights;
    public bool poweredOn = false;

    // Start is called before the first frame update
    void Start()
    {
        lights = GameObject.FindGameObjectsWithTag("Lights");
        foreach (GameObject light in lights)
        {
            light.SetActive(false);
        }
    }

    public void onPowerUp() {
        foreach (GameObject tempLight in lights) {
            Debug.Log("Got here");
            tempLight.SetActive(true);
            poweredOn = true;
        }
    }
}
