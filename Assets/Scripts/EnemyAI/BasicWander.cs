using System.Collections;
using UnityEngine.AI;
using System.Collections.Generic;
using UnityEngine;


//used as a base class for ai to wander
public class BasicWander : MonoBehaviour
{

    [SerializeField] public bool playerNotSeen;
    public Transform[] points;
    private int destPoint = 0;
    private NavMeshAgent agent;


    void Start()
    {
        agent = GetComponent<NavMeshAgent>();

        // Disabling auto-braking allows for continuous movement
        // between points (ie, the agent doesn't slow down as it
        // approaches a destination point).
        agent.autoBraking = true;

        GotoNextPoint();
    }


    void GotoNextPoint()
    {
        // Returns if no points have been set up
        if (points.Length == 0)
            return;

        int rand = Random.Range(0, 3);

        // Set the agent to go to the currently selected destination.
        agent.destination = points[rand].position;
      //  agent.destination = points[destPoint].position;

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
}
