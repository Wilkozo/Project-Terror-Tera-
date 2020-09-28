using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


//this is the old key class that was used in vertical slice
//it may be changed at a later date to do something else
//the new key system is in Keycards.cs
public class Key : MonoBehaviour
{

    public CanvasGroup fadeToWhite;
    bool win = false;

    private void Start()
    {
        fadeToWhite.alpha = 0;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player") {
            win = true;
        }
    }
    private void Update()
    {
        if (win) {
            fadeToWhite.alpha += 0.5f * Time.deltaTime;
            Cursor.visible = true;
            Cursor.lockState = CursorLockMode.None;
        }
    }

}
