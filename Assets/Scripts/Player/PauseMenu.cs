﻿using System.Collections;
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
                //this.GetComponent<FirstPersonController>().enabled = false;
                Cursor.visible = true;
                Time.timeScale = 0;
                pauseCanvas.enabled = true;
            }
        }

        public void continueButton()
        {   Time.timeScale = 1.0f;
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
