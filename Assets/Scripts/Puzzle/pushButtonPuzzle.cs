using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class pushButtonPuzzle : MonoBehaviour
{

    [SerializeField] PlayerInteract playerInteract;

    //sets the bools for the puzzle
    public bool blockOne;
    public bool blockTwo;
    public bool blockThree;

    public bool completePuzzle = false;


    void Update()
    {
        //set raycast return value
        if (playerInteract.checkForInteract() == "ResetBlock")
        {
            //set the blocks to false
            blockOne = false;
            blockTwo = false;
            blockThree = false;
        }
        if (playerInteract.checkForInteract() == "BlockOne")
        {
            blockOne = true;
            blockTwo = false;

        }
        if (playerInteract.checkForInteract() == "BlockTwo")
        {
            blockOne = false;
            blockTwo = true;
        }
        if (playerInteract.checkForInteract() == "BlockThree")
        {
            blockThree = true;
            blockOne = true;
        }
    }

}
