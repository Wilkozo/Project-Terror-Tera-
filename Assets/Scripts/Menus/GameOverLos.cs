using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameOverLos : MonoBehaviour
{

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Q))
        {
            Application.Quit();
        }
        if (Input.GetKeyDown(KeyCode.R))
        {
            Application.LoadLevel("Game");
        }
    }

}
