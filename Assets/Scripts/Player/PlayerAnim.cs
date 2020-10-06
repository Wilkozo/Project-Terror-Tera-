using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAnim : MonoBehaviour
{
    Animator animator;

    [SerializeField] SkullThrow throwSkull;


    private void Start()
    {
       // throwSkull = this.GetComponentInParent<SkullThrow>();
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

        if (throwSkull.hasSkull)
        {
            animator.SetBool("HasSkull", true);
        }

        if (throwSkull.hasSkull && Input.GetKey(KeyCode.E))
        {
            animator.SetBool("Interact", true);
            animator.SetBool("HasSkull", false);
        }
        if (throwSkull.hasSkull && Input.GetKeyUp(KeyCode.E))
        {
            animator.SetBool("Interact", false);
            animator.SetBool("HasSkull", true);
        }

        if (throwSkull.hasSkull && Input.GetKey(KeyCode.LeftShift))
        {
            animator.SetBool("Walk", true);
            animator.SetBool("HasSkull", false);
        }
        if (throwSkull.hasSkull && Input.GetKeyUp(KeyCode.LeftShift))
        {
            animator.SetBool("Walk", false);
            animator.SetBool("HasSkull", true);
        }


        if (throwSkull.hasSkull == false)
        {
            animator.SetBool("HasSkull", false);
        }

        if (Input.GetKeyUp(KeyCode.Mouse0))
        {
            //disable the skull model
           throwSkull.skullModel.SetActive(false);
        }
    }

}
