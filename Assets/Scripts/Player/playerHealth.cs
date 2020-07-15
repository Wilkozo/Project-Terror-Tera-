using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace UnityStandardAssets.Characters.FirstPerson
{
    public class playerHealth : MonoBehaviour
    {

        public Image playerHealthImage;
        public Image bloodOverlay;
        public float health = 100;

        public CanvasGroup canGroup;
        public CanvasGroup gameOverCanGroup;

        public bool loseHealth;

        private void Start()
        {
            canGroup.alpha = 0;
            gameOverCanGroup.alpha = 0;
            // health = 100;
        }

        private void Update()
        {
            health = playerHealthImage.fillAmount;

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

            if (health <= 0)
            {
                health = 0;
                //what to do when a player dies 
                gameOverCanGroup.alpha += 0.75f * Time.deltaTime;
                this.gameObject.GetComponent<FirstPersonController>().enabled = false;
                if (Input.GetKeyDown(KeyCode.R)) {
                    Application.LoadLevel(Application.loadedLevel);
                }
                if (Input.GetKeyDown(KeyCode.Q)) {
                    Application.LoadLevel("NewMainMenu");
                }
            }

        }

        public void OnTriggerEnter(Collider other)
        {
            //if the player hits the kill floor
            if (other.tag == "KillFloor")
            {
                //go to the gameover screen
                Application.LoadLevel("Gameover");
            }
        }
    }
}
