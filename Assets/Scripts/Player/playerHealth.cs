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

        public Transform checkpoint;

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
            //set the pos of the player when they die
            this.gameObject.transform.position = checkpoint.position;

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
                //set the pos of the player when they die
                this.gameObject.transform.position = checkpoint.position;
            }
        }

        public void OnTriggerStay(Collider other)
        {
            if (other.tag == "Checkpoint") {
                message.CrossFadeAlpha(1, 0, true);
                message.text = "CheckPoint Reached";
                message.CrossFadeAlpha(0, 10.0f, true);
                //set the var for checkpoint to the other transform
                checkpoint = other.gameObject.transform;
            }

            //if the player hits the kill floor
            if (other.tag == "KillFloor")
            {
                //sets the blackout overlay
                canGroup.alpha = 1.0f;
                //kills the player
                playerHealthImage.fillAmount = 0;
                //health = 0;
            }
        }
    }
}
