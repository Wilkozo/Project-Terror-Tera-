using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenu : MonoBehaviour
{

    public void Start()
    {
        Cursor.visible = true;
    }

    private void Update()
    {
        Cursor.visible = true;
    }
    public void PlayGame()
    {
        FindObjectOfType<AudioManager>().Play("Button");

        // Gets The Next Scene for the Play Mode
        SceneManager.LoadScene(1);
    }

    public void ReturnToMainMenu()
    {
        FindObjectOfType<AudioManager>().Play("Button");
        SceneManager.LoadScene(0);
    }

    public void EndGame()
    {
        FindObjectOfType<AudioManager>().Play("Button");
        Application.Quit();
    }
}
