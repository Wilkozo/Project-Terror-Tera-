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
       // health = 100;
    }

    private void Update()
    {
        health = playerHealthImage.fillAmount;

        if (health <= 0) {
            //what to do when a player dies 
            Application.LoadLevel("GameOver");
        }
        //if (loseHealth)
        //{
        //    playerHealthImage.fillAmount -= 0.1f * Time.deltaTime;
        //    //increase the opacity of the blood overlay
        //    canGroup.alpha += 0.15f *Time.deltaTime;
        //}
        //else {
            playerHealthImage.fillAmount += 0.01f * Time.deltaTime;
            canGroup.alpha -= 0.01f * Time.deltaTime;
        //}

    }

    //public void LoseHealth() {

    //    Debug.Log("lose health");
    //    loseHealth = true;

    //}

    //public void dontLoseHealth() {
    //    loseHealth = false;
    //}

}
