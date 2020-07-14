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

        if (health <= 0)
        {
            //what to do when a player dies 
            Application.LoadLevel("GameOver");
        }
            playerHealthImage.fillAmount += 0.01f * Time.deltaTime;
            canGroup.alpha -= 0.01f * Time.deltaTime;
    }

    public void OnTriggerEnter(Collider other)
    {
        //if the player hits the kill floor
        if (other.tag == "KillFloor") {
            //go to the gameover screen
            Application.LoadLevel("Gameover");
        }
    }
}
