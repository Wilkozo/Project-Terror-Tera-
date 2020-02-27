using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameOverLos : MonoBehaviour
{

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Q))
        {
            //Application.Quit();
            SceneManager.LoadScene(0);
//            Application.LoadLevel("MainMenu");
        }
        if (Input.GetKeyDown(KeyCode.R))
        {
            SceneManager.LoadScene(1);
            //          Application.LoadLevel("Game");
        }
    }

}
