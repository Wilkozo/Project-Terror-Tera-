using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


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
