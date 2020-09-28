using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Intro : MonoBehaviour
{
    //timer to swap camera
    public float timer = 20.0f;
    //get the main player camera
    public GameObject fpsCamera;
    public GameObject cutscene1Cam;
    // Update is called once per frame
    void Update()
    {
        timer -= 1 * Time.deltaTime;
        if (timer <= 0) {
            fpsCamera.SetActive(true);
            cutscene1Cam.SetActive(false);
            Destroy(this.gameObject);
        }
    }
}
