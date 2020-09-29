using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Doors : MonoBehaviour
{
    
    public int levelToOpen;

    public Animator anim;
    public Animator anim2;

    //when the door should be opened destroy it temp
    public void OpenDoor() {
        int temp = Keycards.getKeycardLevel();
        if(temp >= levelToOpen) {
            //SFX HERE
            anim.SetBool("Open", true);
            anim2.SetBool("Open", true);
        }
    }
}
