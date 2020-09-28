using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Keycards : MonoBehaviour
{
    //a static int for what level keycard the player has
    static int keycardLevel = 0;
    //a static bool for the power
    static bool poweredOn;
    //a static bool for if the player has radioed in
    static bool radioedIn;

    //checks to see if the player has radioed in
    public static bool haveRadioedIn()
    {
        return radioedIn;
    }

    //sets radioedIn to true
    public static void setRadioedIn() {
        radioedIn = true;
    }

    //checks to see if the power is on
    public static bool isPoweredOn() {
        return poweredOn;
    }

    //sets the power to be on
    public static void setPoweredOn() {
        poweredOn = true;
    }

    //gets the level of keycard that the player has
    public static int getKeycardLevel() {
        return keycardLevel;
    }

    //sets the level of keycard that the player has
    public static void setKeycardLevel(int keycardLevelToSet) {
        keycardLevel = keycardLevelToSet;
    }
}
