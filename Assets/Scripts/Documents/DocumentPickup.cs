using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class DocumentPickup : MonoBehaviour
{

    public Text documentText;
    public Image documentImage;

    //[SerializeField] CollectedNotes notes;

    private void Start()
    {
        //get the script for the notes
       // notes = GameObject.FindGameObjectWithTag("Note").GetComponent<CollectedNotes>();
        if (documentText.name != "IntroText")
        {
            documentText.enabled = false;
        }
    }

    //when the player interacts with the document places
    void ReadMessage()
    {
        //set the ui stuff to be true
        documentText.enabled = true;
        documentImage.enabled = true;
        //used to add the document to the list of documents
        //notes.collectedDocuments.Add(this.gameObject.name);
        GameObject.FindGameObjectWithTag("Player").SendMessage("documentsPickedUp");
        //Time.timeScale = 0;
        Debug.Log("Hit the document");

    }

    private void Update()
    {
        //when the player presses Tab the document will disable
        if (Input.GetKeyDown(KeyCode.Tab) && documentText.enabled) {
            documentText.enabled = false;
            documentImage.enabled = false;
            Destroy(this.gameObject);
        }
    }
}
