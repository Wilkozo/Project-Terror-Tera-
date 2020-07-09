using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Keycards : MonoBehaviour
{
    //a static int for what level keycard the player has
    public static int keycardLevel = 0;

    //gets the level of keycard that the player has
    public static int getKeycardLevel() {
        return keycardLevel;
    }

    //sets the level of keycard that the player has
    public static void setKeycardLevel(int keycardLevelToSet) {
        keycardLevel = keycardLevelToSet;
    }
}
