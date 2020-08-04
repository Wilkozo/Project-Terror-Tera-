using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

//used for when the player needs to interact with the radio tower
public class RadioTower : MonoBehaviour
{
    //the message to the player that will be displayed
    public Text messageToPlayer;

    public void Start()
    {
        //make it so the message is transparent
        messageToPlayer.CrossFadeAlpha(0, 0, true);
    }

    //call this from the player interact script
    public void OnRadioInteract() {

        if (Keycards.isPoweredOn())
        {
            //make it so the player can return to the boat
            messageToPlayer.CrossFadeAlpha(1, 0, true);
            messageToPlayer.text = "The boat has been called, you can return to it or explore the island more";
            messageToPlayer.CrossFadeAlpha(0, 10.0f, true);
            //make it so the player has radioed in so they can leave via the boat
            Keycards.setRadioedIn();
        }
        else {
            //send out the message that the player cannot radio in yet
            messageToPlayer.CrossFadeAlpha(1, 0, true);
            messageToPlayer.text = "There seems to be no power, better try to find out where the power station is";
            messageToPlayer.CrossFadeAlpha(0, 10.0f, true);
            //provide a message saying that the power is not on and needs to be turned on for it to work
        }
    }
}
