using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAnim : MonoBehaviour
{
    Animator animator;

    private void Start()
    {
        animator = this.GetComponent<Animator>();
    }

    private void Update()
    {
        if (Input.GetKey(KeyCode.E)) {
            animator.SetBool("Interact", true);
        }
        if (Input.GetKeyUp(KeyCode.E)) {
            animator.SetBool("Interact", false);
        }
        if (Input.GetKey(KeyCode.LeftShift))
        {
            animator.SetBool("Walk", true);
        }
        if (Input.GetKeyUp(KeyCode.LeftShift))
        {
            animator.SetBool("Walk", false);
        }

        if (Input.GetKeyDown(KeyCode.LeftControl))
        {
            animator.SetBool("Crouch", true);
        }
        if (Input.GetKeyUp(KeyCode.LeftControl))
        {
            animator.SetBool("Crouch", false);
        }
    }

}
