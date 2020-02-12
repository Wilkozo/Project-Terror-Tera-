using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlickeringLights : MonoBehaviour
{

    int timer;
    Light light;

    // Start is called before the first frame update
    void Start()
    {
        //gets the light component
        light = GetComponent<Light>();
    }


    //randomly turns lights on or off
    void FixedUpdate()
    {

        timer = Random.Range(0, 100000);

        if (timer > 99000)
        {
            light.enabled = false;
        }
        if (timer < 99000) {
            light.enabled = true;
        }

    }
}
