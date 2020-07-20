using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace UnityStandardAssets.Characters.FirstPerson
{
    public class playerHealth : MonoBehaviour
    {

        //UI elements
        public Image playerHealthImage;
        public Image bloodOverlay;
        //player health
        public float health = 100;

        public float timer;
        public Text message;
        public Text BlackedOutText;

        //more UI elements for the blood overlay
        public CanvasGroup canGroup;
        //UI elements for the game over screen
        public CanvasGroup gameOverCanGroup;

        //is the player losing health
        public bool loseHealth;

        private void Start()
        {
            //set the canvas to be transparent
            canGroup.alpha = 0;
            gameOverCanGroup.alpha = 0;
            BlackedOutText.CrossFadeAlpha(0, 0, true);
        }

        private void Update()
        {
            //set the player health to the image fill amount
            health = playerHealthImage.fillAmount;

            //debug damage the player
            if (Input.GetKey(KeyCode.T))
            {
                playerHealthImage.fillAmount -= 0.1f * Time.deltaTime;
                health -= 1.0f * Time.deltaTime;
                canGroup.alpha += 0.1f * Time.deltaTime;
            }
            else if(health > 0)
            {

                playerHealthImage.fillAmount += 0.01f * Time.deltaTime;
                canGroup.alpha -= 0.01f * Time.deltaTime;
            }

            //if the player is dead
            if (health <= 0)
            {
                //set the health to 0
                health = 0;
                //call game over
                gameOver();
            }

        }

        //what to do in the case of a game over
        public void gameOver() {
            BlackedOutText.CrossFadeAlpha(1, 0, true);
            //what to do when a player dies 
            gameOverCanGroup.alpha += 0.75f * Time.deltaTime;
            //set the text to be visible
            
            //disable the player controller
            this.gameObject.GetComponent<FirstPersonController>().enabled = false;

            timer += 0.1f * Time.deltaTime;
            if (timer >= 0.3f) {
                timer = 0.3f;
                canGroup.alpha -= 0.75f * Time.deltaTime;
                //make the text not visible
                BlackedOutText.CrossFadeAlpha(0, 2.0f, true);
            }
            if (canGroup.alpha == 0)
            {
                timer = 0;
                Time.timeScale = 1.0f;
                playerHealthImage.fillAmount = 1;
                this.gameObject.GetComponent<FirstPersonController>().enabled = true;
                message.CrossFadeAlpha(1, 0, true);
                message.text = "Hey, You're finally Awake";
                message.CrossFadeAlpha(0, 10.0f, true);
            }

            ////if the user inputs r restart the current scene 
            //if (Input.GetKeyDown(KeyCode.R))
            //{
            //    Application.LoadLevel(Application.loadedLevel);
            //}
            ////if the user inputs q then return to menu
            //if (Input.GetKeyDown(KeyCode.Q))
            //{
            //    Application.LoadLevel("NewMainMenu");
            //}
        }

        public void OnTriggerStay(Collider other)
        {
            //if the player hits the kill floor
            if (other.tag == "KillFloor")
            {
                //go to the gameover screen
                gameOver();
            }
        }
    }
}
