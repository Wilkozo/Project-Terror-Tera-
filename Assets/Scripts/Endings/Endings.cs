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
        if (triggeredIntercepted) {
            canvasGroup.alpha += 0.5f * Time.deltaTime;
            message.CrossFadeAlpha(1, 5.0f, true);
            message.text = "INTERCEPTED" + "\n" + "GAME OVER";
            message.CrossFadeAlpha(0, 10.0f, true);
            timer += 1 * Time.deltaTime;
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
