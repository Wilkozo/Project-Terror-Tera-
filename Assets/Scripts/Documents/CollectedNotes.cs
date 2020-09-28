using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollectedNotes : MonoBehaviour
{
    //list of collected documents
    public List<string> collectedDocuments;

    //what to do when the player wants to read documents
    void activeDocumentInventory() {
        //display the notes

    }

    private void Update()
    {
        if (Input.GetKey(KeyCode.I)) {
        }
    }

}
