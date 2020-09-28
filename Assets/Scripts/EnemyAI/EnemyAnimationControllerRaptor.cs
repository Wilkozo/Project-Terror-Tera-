using System.Collections;
using System.Collections.Generic;
using UnityEngine.AI;
using UnityEngine;

public class EnemyAnimationControllerRaptor : MonoBehaviour
{
    public Animator animator;

    public NavMeshAgent agent;

    private void Start()
    {
        animator = GetComponent<Animator>();
        agent = GetComponentInParent<NavMeshAgent>();
    }

    private void Update()
    {
        float velocity = agent.velocity.magnitude / agent.speed;
        if (velocity != 0)
        {
            animator.SetBool("IsMoving", true);
        }
        else{
            animator.SetBool("IsMoving", false);
        }
    }

}
