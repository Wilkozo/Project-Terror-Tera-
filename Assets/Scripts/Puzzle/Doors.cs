using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Doors : MonoBehaviour
{
    
    public int keycardLevel;
    
    //when the door should be opened destroy it temp
    public void OpenDoor() {
        Debug.Log(Keycards.getKeycardLevel());
        if(this.keycardLevel > Keycards.getKeycardLevel()) {
            Destroy(this.gameObject);
        }
    }
}
