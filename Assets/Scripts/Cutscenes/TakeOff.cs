using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TakeOff : MonoBehaviour
{

    public CanvasGroup fadeToBlack;
    float timer;
    Animator animController;
    // Start is called before the first frame update
    void Awake()
    {
        //find the anim controller
        animController = GetComponentInParent<Animator>();
        //sets it so the heli will take off
        animController.SetBool("TakeOff", true);
    }

    private void Update()
    {
        timer += 1 * Time.deltaTime;
        if (timer >= 25.0f)
        {
            fadeToBlack.alpha += 0.5f * Time.deltaTime;
            if (fadeToBlack.alpha >= 1)
            {
                Application.LoadLevel(4);
            }
        }
    }

}
