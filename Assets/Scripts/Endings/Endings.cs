using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class Endings : MonoBehaviour
{
    //used for the fade to black
    public CanvasGroup canvasGroup;
    public Text message;

    public float timer;

    private void OnTriggerStay(Collider other)
    {
        //if the power is on and the player enters the main building
        if (Keycards.isPoweredOn() && other.tag == "Player") {
            Debug.Log("SHould be triggering");
            canvasGroup.enabled = true;
        }
    }
    private void Update()
    {
        if (canvasGroup.isActiveAndEnabled) {
            canvasGroup.alpha += .01f * Time.deltaTime;
            message.text = "Intercepted";
            message.enabled = true;
            timer += 1 * Time.deltaTime;
        }
        if (timer >= 15.0f) {
            Application.LoadLevel("NewMainMenu");
        }
    }
}
