using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class playerHealth : MonoBehaviour
{

    public Image playerHealthImage;
    public Image bloodOverlay;
    public float health = 100;

    public CanvasGroup canGroup;

    public bool loseHealth;

    private void Start()
    {
        canGroup.alpha = 0;
    }

    private void Update()
    {
        health = playerHealthImage.fillAmount;

        if (health <= 0) {
            //what to do when a player dies 
        }
        if (loseHealth)
        {
            playerHealthImage.fillAmount -= 0.1f * Time.deltaTime;
            //increase the opacity of the blood overlay
            canGroup.alpha += 0.15f *Time.deltaTime;

            //bloodOverlay.
            //bloodOverlay.fillAmount += 0.1f * Time.deltaTime;

            //var tempColor = bloodOverlay.color;
            //tempColor.a += 0.1f;
            //bloodOverlay.color = tempColor;
        }
        else {
            playerHealthImage.fillAmount += 0.01f * Time.deltaTime;
            canGroup.alpha -= 0.01f * Time.deltaTime;
            //bloodOverlay.CrossFadeAlpha(0.1f, 2.0f, true);
            //bloodOverlay.fillAmount -= 0.1f * Time.deltaTime;
            //var tempColor = bloodOverlay.color;
            //tempColor.a -= 0.1f;
            //bloodOverlay.color = tempColor;
        }

    }

    public void LoseHealth() {

        loseHealth = true;

    }

    public void dontLoseHealth() {
        loseHealth = false;
    }

}
