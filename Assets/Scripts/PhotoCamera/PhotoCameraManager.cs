using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PhotoCameraManager : MonoBehaviour
{
    int numberOfPhotos;

    // Update is called once per frame
    void Update()
    {
        //if the player pushes the p key
        if (Input.GetKey(KeyCode.P)) {
            //capture a screenshot
            ScreenCapture.CaptureScreenshot(Application.dataPath + "/screenshots/" + numberOfPhotos + ".png");
            numberOfPhotos++;
            UnityEditor.AssetDatabase.Refresh();
            Collider[] hits = Physics.OverlapSphere(transform.position, 150.0f);
            int i = 0;

            while (i < hits.Length)
            {
                hits[i].SendMessage("Photographed", SendMessageOptions.DontRequireReceiver);
                i++;
            }
        }
    }
}
