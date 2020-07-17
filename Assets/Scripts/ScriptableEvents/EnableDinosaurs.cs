using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnableDinosaurs : MonoBehaviour
{
    //Parent object for the dinos in the manor region
    public GameObject dinosaurManorRegionHolder;

    private void Start()
    {
        dinosaurManorRegionHolder.SetActive(false);
    }

    //what to do when the player has collected the intel
    public void OnCollectDocuments() {
        //make it so the dinosaurs are enabled in the manor region
        dinosaurManorRegionHolder.SetActive(true);
    }



}
