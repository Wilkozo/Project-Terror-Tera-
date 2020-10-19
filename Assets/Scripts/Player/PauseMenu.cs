using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
namespace UnityStandardAssets.Characters.FirstPerson
{
    public class PauseMenu : MonoBehaviour
    {

        //get the pause canvas
        public Canvas pauseCanvas;

        private void Start()
        {
            //disable the pause canvas
            pauseCanvas.enabled = false;
        }

        private void Update()
        {
            //if the player hits the escape key
            if (Input.GetKeyDown(KeyCode.Escape))
            {
                Cursor.visible = false;

                //if the pause menu is not enabled
                if (!pauseCanvas.enabled)
                {
                    //set the time scale to 0
                    Time.timeScale = 0.0f;
                    //enable the pause canvas
                    pauseCanvas.enabled = true;
                }
                //otherwise
                else {
                    //set the timescale to 1
                    Time.timeScale = 1.0f;
                    //disable the pause menu
                    pauseCanvas.enabled = false;
                }
            }
            //if the pause menu is enabled
            if (pauseCanvas.enabled) {
                //if the player presses q
                if (Input.GetKeyDown(KeyCode.Q)) {
                    //set the time scale to 1
                    Time.timeScale = 1.0f;
                    //load into the main menu
                    Application.LoadLevel("NewMainMenu");
                }
            }
        }
    }
}
