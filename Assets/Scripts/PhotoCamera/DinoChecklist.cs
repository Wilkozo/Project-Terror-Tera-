using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DinoChecklist : MonoBehaviour
{
    //list of dinos to take photos of
    public List<string> dinosaursPhotographed;

    public void dinosPhotographed(string tagOfDino) {
        Debug.Log(tagOfDino);
        //checks through the array
        for(int i = 0; i < dinosaursPhotographed.Count; i++) {
            //if the dinosaur photographed is the same as the tag of the dino
            if (dinosaursPhotographed[i] == tagOfDino) {
                //remove it from the list of dinos
                dinosaursPhotographed.Remove(tagOfDino);
            }
        }

    }

}
