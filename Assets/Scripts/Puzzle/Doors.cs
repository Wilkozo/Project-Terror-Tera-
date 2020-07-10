using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Doors : MonoBehaviour
{
    
    public int levelToOpen;
    
    //when the door should be opened destroy it temp
    public void OpenDoor() {
        int temp = Keycards.getKeycardLevel();
        if(temp >= levelToOpen) {
            Destroy(this.gameObject);
        }
    }
}
