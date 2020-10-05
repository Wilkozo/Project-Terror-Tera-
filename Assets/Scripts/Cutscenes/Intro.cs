using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Intro : MonoBehaviour
{
    //used to fade to black
    public CanvasGroup fadeToBlack;
    public bool fadeBack;
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
            fadeToBlack.alpha += 0.75f *Time.deltaTime;
            if (fadeToBlack.alpha >= 0.9f) {
                fadeBack = true;
            }
           
        }
        if (fadeBack) {
            timer = 2;
            fadeToBlack.alpha -= 0.25f * Time.deltaTime;
             fpsCamera.SetActive(true);
             cutscene1Cam.SetActive(false);
            if (fadeToBlack.alpha <= 0.1f)
            {
                Destroy(this.gameObject);
            }
        }
    }
}
