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

    public CanvasGroup canGroup;

    public void Start()
    {
        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;
        loadingText.enabled = false;
    }

    private void Update()
    {
        if (canGroup.alpha > 0)
        {
            canGroup.alpha -= 1.0f * Time.deltaTime;
        }
        Cursor.visible = true;
    }
    public void PlayGame()
    {
        loadingText.enabled = true;
        // Use a coroutine to load the Scene in the background
        StartCoroutine(LoadYourAsyncScene());


    }

    IEnumerator LoadYourAsyncScene()
    {
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
        //FindObjectOfType<AudioManager>().Play("Button");
        SceneManager.LoadScene(0);
    }

    public void EndGame()
    {
        //FindObjectOfType<AudioManager>().Play("Button");
        Application.Quit();
    }
}
