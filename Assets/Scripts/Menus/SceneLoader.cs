using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class SceneLoader : MonoBehaviour
{

    private bool loadScene = false;

    [SerializeField]
    private int scene;
    [SerializeField]
    private Text loadingText;


    // Updates once per frame
    void LateUpdate()
    {

        //prevents reloading the same scene multiple times=
        loadScene = true;

        //set the loading text
        loadingText.text = "Loading...";

        //start the coroutine that loads the scene
        StartCoroutine(LoadNewScene());

        // If the new scene has started loading
        if (loadScene == true)
        {

            //loading text to phase in and out 
            loadingText.color = new Color(loadingText.color.r, loadingText.color.g, loadingText.color.b, Mathf.PingPong(Time.time, 1));

        }

    }
    
    IEnumerator LoadNewScene()
    {
        // Start an asynchronous operation to load the scene that was passed to the LoadNewScene coroutine.
        AsyncOperation async = Application.LoadLevelAsync(scene);

        // While the asynchronous operation to load the new scene is not yet complete, continue waiting until it's done.
        while (!async.isDone)
        {
            yield return null;
        }

    }

}
