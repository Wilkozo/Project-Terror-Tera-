using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class PlayerManager : MonoBehaviour
{
    public Text totalDocuments;
    public Text digZones;
    public int digCount;
    public int documentCount;

    public void documentsPickedUp() {
        documentCount++;
        totalDocuments.text = "Documents: " + documentCount.ToString() + " / 5";
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.P)) {
            digCount +=1;
            digZones.text = "Dig Zones: " + digCount.ToString() + " / 7";
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.tag == "DigZone"){
            digCount++;
            Destroy(other.GetComponent<SphereCollider>());
            digZones.text = "Dig Zones: " + digCount.ToString() + " / 7";
        }
    }

}
