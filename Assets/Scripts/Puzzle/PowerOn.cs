using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PowerOn : MonoBehaviour
{

    public bool lightOne = false;
    public bool lightTwo = false;
    public bool lightThree = false;

    public Text message; 

    public void buttonPushOne() {
        lightOne = !lightOne;
        lightThree = true;
        puzzleCompleted();
    }
    public void buttonPushTwo()
    {
        lightOne = false;
        lightTwo = true;
        lightThree = !lightThree;
        puzzleCompleted();
    }
    public void buttonPushThree()
    {
        lightOne = true;
        lightTwo = !lightTwo;
        lightThree = false;
        puzzleCompleted();
    }

    public void resetPuzzle() {
        lightOne = false;
        lightTwo = false;
        lightThree = false;
    }

    //checks to see if the puzzle has been completed
    public void puzzleCompleted() {
        if (lightOne)
        {
            this.transform.GetChild(0).GetChild(0).GetComponent<Light>().color = Color.green;
        }
        else {
            this.transform.GetChild(0).GetChild(0).GetComponent<Light>().color = Color.red;
        }
        if (lightTwo)
        {
            this.transform.GetChild(1).GetChild(0).GetComponent<Light>().color = Color.green;
        }
        else
        {
            this.transform.GetChild(1).GetChild(0).GetComponent<Light>().color = Color.red;
        }
        if (lightThree)
        {
            this.transform.GetChild(2).GetChild(0).GetComponent<Light>().color = Color.green;
        }
        else
        {
            this.transform.GetChild(2).GetChild(0).GetComponent<Light>().color = Color.red;
        }
        if (lightOne && lightTwo && lightThree) {
            message.CrossFadeAlpha(1, 0, true);
            message.text = "Seems like the power has been turned on now";
            message.CrossFadeAlpha(0, 10.0f, true);
            //sets the static bool for the power to true
            Keycards.setPoweredOn();
        }
    }


}
