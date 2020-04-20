using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class DocumentPickup : MonoBehaviour
{

    public Text documentText;
    public Image documentImage;

    private void Start()
    {
        if (documentText.name != "IntroText")
        {
            documentText.enabled = false;
        }
       // documentImage.enabled = false;
    }

    //when the player interacts with the document places
    void ReadMessage()
    {
        //set the ui stuff to be true
        documentText.enabled = true;
        documentImage.enabled = true;
        GameObject.FindGameObjectWithTag("Player").SendMessage("documentsPickedUp");

        //Time.timeScale = 0;
        Debug.Log("Hit the document");

    }

    private void Update()
    {
        //when the player presses Q the document will disable
        if (Input.GetKeyDown(KeyCode.Q) && documentText.enabled) {
            documentText.enabled = false;
            documentImage.enabled = false;
            Destroy(this.gameObject);
        }
    }
}
