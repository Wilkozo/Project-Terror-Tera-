using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class DocumentPickup : MonoBehaviour
{


    public Text documentText;
    public Image documentImage;


    void ReadMessage()
    {
        Time.timeScale = 0;
        Debug.Log("Hit the document");

    }
}
