using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class KeycardUI : MonoBehaviour
{

    //images for the keycards
    public Image greenKeycard;
    public Image blueKeycard;
    public Image redKeycard;

    //used to let the player know that they have picked up something
    public Text pickUpNotification;

    public void OnEnable()
    {
        //enabled ui elements for the keycards
        if (Keycards.getKeycardLevel() >= 1)
        {
            greenKeycard.enabled = true;
        }
        else {
            greenKeycard.enabled = false;
        }
        if (Keycards.getKeycardLevel() >= 2) {
            blueKeycard.enabled = true;
        }
        else
        {
            blueKeycard.enabled = false;
        }
        if (Keycards.getKeycardLevel() >= 3) {
            redKeycard.enabled = true;
        }
        else
        {
            redKeycard.enabled = false;
        }
    }


}
