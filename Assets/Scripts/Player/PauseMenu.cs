using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
namespace UnityStandardAssets.Characters.FirstPerson
{
    public class PauseMenu : MonoBehaviour
    {
        public Canvas pauseCanvas;

        private void Start()
        {
            pauseCanvas.enabled = false;
        }

        private void Update()
        {
            if (Input.GetKeyDown(KeyCode.Escape))
            {
                if (!pauseCanvas.enabled)
                {
                    Time.timeScale = 0.0f;
                    pauseCanvas.enabled = true;
                }
                else {
                    Time.timeScale = 1.0f;
                    pauseCanvas.enabled = false;
                }
            }
            if (pauseCanvas.enabled) {
                if (Input.GetKeyDown(KeyCode.Q)) {
                    Time.timeScale = 1.0f;
                    Application.LoadLevel("NewMainMenu");
                }
            }
        }

        public void continueButton()
        {
            Time.timeScale = 1.0f;
            pauseCanvas.enabled = false;
            Cursor.visible = false;

        }
        public void menuButton()
        {
            Time.timeScale = 1.0f;
            Application.Quit();
            Cursor.visible = true;
        }


    }
}
