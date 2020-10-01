using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class Endings : MonoBehaviour
{
    //used for the fade to black
    public CanvasGroup canvasGroup;
    public Text message;
    public bool triggered;

    public float timer;

    private void OnTriggerEnter(Collider other)
    {
        //if the power is on and the player enters the main building
        if (Keycards.isPoweredOn() && other.tag == "Player") {
            Debug.Log("Should be triggering");
            triggered = true;
        }
    }
    private void Update()
    {
        if (triggered) {
            canvasGroup.alpha += 0.5f * Time.deltaTime;
            message.CrossFadeAlpha(1, 5.0f, true);
            message.text = "INTERCEPTED";
            message.CrossFadeAlpha(0, 10.0f, true);
            timer += 1 * Time.deltaTime;
        }
        if (timer >= 7.5f) {
            Application.LoadLevel("NewMainMenu");
        }
    }
}
