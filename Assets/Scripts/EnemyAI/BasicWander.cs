using System.Collections;
using UnityEngine.AI;
using System.Collections.Generic;
using UnityEngine;


//used as a base class for ai to wander
public class BasicWander : MonoBehaviour
{

    [SerializeField] public bool playerNotSeen;
    [SerializeField] PlayerInteract player;
    public Transform[] points;
    private int destPoint = 0;
    private NavMeshAgent agent;
    public float timer;

    void Start()
    {
        agent = GetComponent<NavMeshAgent>();

        agent.autoBraking = true;

        GotoNextPoint();
    }


    void GotoNextPoint()
    {
        // Returns if no points have been set up
        if (points.Length == 0)
            return;

        int rand = Random.Range(0, points.Length);

        // Set the agent to go to the currently selected destination.
        agent.destination = points[rand].position;

        // Choose the next point in the array as the destination,
        // cycling to the start if necessary.
        destPoint = (destPoint + 1) % points.Length;
    }


    void Update()
    {
        // Choose the next destination point when the agent gets
        // close to the current one.

        if (!agent.pathPending && agent.remainingDistance < 0.5f && playerNotSeen)
            GotoNextPoint();
    }


   //when an enemy collides with the player load the game over scene.
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player") {
            Application.LoadLevel("GameOver");
        }
    }
}
