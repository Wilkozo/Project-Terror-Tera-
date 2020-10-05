using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class Endings : MonoBehaviour
{
    //used for the fade to black
    public CanvasGroup canvasGroup;
    public Text message;
    public CanvasGroup bloodOverlay;
    bool fadeBack;
    public GameObject fpsCamera;
    public GameObject cutscene1Cam;
    public CanvasGroup fadeToBlack;
    public bool triggeredIntercepted;
    public bool triggeredBadEnding;
    public bool triggeredGoodEnding;

    public float timer;

    private void OnTriggerEnter(Collider other)
    {
        //if the power is on and the player enters the main building
        if (Keycards.isPoweredOn() && other.tag == "Player") {
            Debug.Log("Should be triggering");
            triggeredIntercepted = true;
        }
    }
    private void Update()
    {
        //intercepted ending
        if (triggeredIntercepted)
        {
            timer -= 1 * Time.deltaTime;
            if (timer <= 0)
            {
                fadeToBlack.alpha += 0.75f * Time.deltaTime;
                if (fadeToBlack.alpha >= 0.9f)
                {
                    fadeBack = true;
                }

            }
            if (fadeBack)
            {
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
        if (triggeredBadEnding) {
            bloodOverlay.alpha += 0.5f * Time.deltaTime;
            canvasGroup.alpha += 0.5f * Time.deltaTime;
            message.CrossFadeAlpha(1, 5.0f, true);
            message.text = "YOU WERE KILLED" + "\n" + "GAME OVER";
            message.CrossFadeAlpha(0, 10.0f, true);
            timer += 1 * Time.deltaTime;
        }
        if (triggeredGoodEnding) {
            canvasGroup.alpha += 0.5f * Time.deltaTime;
            message.CrossFadeAlpha(1, 5.0f, true);
            message.text = "YOU ESCAPED ALIVE" + "\n" + "GAME OVER";
            message.CrossFadeAlpha(0, 10.0f, true);
            timer += 1.0f * Time.deltaTime;
        }

        if (timer >= 7.5f) {
            Application.LoadLevel("NewMainMenu");
        }
    }

    public void goodEndingBoat() {
        triggeredGoodEnding = true;
    }

    public void badEndingBoat() {
        triggeredBadEnding = true;
    }
}
