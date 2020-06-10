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
            if (Input.GetKey(KeyCode.Escape))
            {
                if (Cursor.visible == false)
                {
                    //this.GetComponent<FirstPersonController>().enabled = false;
                    Cursor.visible = true;
                    Time.timeScale = 0.0f;
                    pauseCanvas.enabled = true;
                }
                else {
                    Cursor.visible = false;
                    Time.timeScale = 1.0f;
                    pauseCanvas.enabled = false;
                }
            }
        }

        public void continueButton()
        {
            //this.GetComponent<FirstPersonController>().enabled = true;
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
