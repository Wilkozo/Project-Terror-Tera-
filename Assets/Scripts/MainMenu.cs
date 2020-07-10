using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class MainMenu : MonoBehaviour
{

    [SerializeField]
    private int scene;
    [SerializeField]
    private Text loadingText;

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
        // FindObjectOfType<AudioManager>().Play("Button");

        // Gets The Next Scene for the Play Mode
        // Use a coroutine to load the Scene in the background
        StartCoroutine(LoadYourAsyncScene());
       // SceneManager.LoadScene(1);


    }

    IEnumerator LoadYourAsyncScene()
    {
        // The Application loads the Scene in the background as the current Scene runs.
        // This is particularly good for creating loading screens.
        // You could also load the Scene by using sceneBuildIndex. In this case Scene2 has
        // a sceneBuildIndex of 1 as shown in Build Settings.

        AsyncOperation asyncLoad = SceneManager.LoadSceneAsync(1);

        // Wait until the asynchronous scene fully loads
        while (!asyncLoad.isDone)
        {
            // ...then pulse the transparency of the loading text to let the player know that the computer is still working.
            loadingText.color = new Color(loadingText.color.r, loadingText.color.g, loadingText.color.b, Mathf.PingPong(Time.time, 1));

            yield return null;
        }
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
