using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class PlayerManager : MonoBehaviour
{
    public Text totalDocuments;
    public int documentCount;

    public void documentsPickedUp() {
        documentCount++;
        totalDocuments.text = "Documents: " + documentCount.ToString() + " / 5";
    }
}
