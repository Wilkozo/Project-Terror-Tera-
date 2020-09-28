using System.Collections;
using System.Collections.Generic;
using UnityEngine.AI;
using UnityEngine;

//how the ai navigates through the waypoint system
public class WaypointNavigator : MonoBehaviour
{

    [SerializeField] public bool playerNotSeen = true;

    //get references to the NavMeshAgent
    //and the Waypoints
    public NavMeshAgent controller;
    public Waypoint currentWaypoint;

    //on awake
    private void Awake()
    {
        //set it so the ai slows down before reaching a waypoint
        controller.autoBraking = true;
        //get the component for the navmesh
        controller = GetComponent<NavMeshAgent>();
        //set the initial waypoint to move to
        controller.destination = currentWaypoint.GetPosition();
    }

    //used for other calls to make sure that the AI can still use the waypoints
    public void waypointToGoTo()
    {
        //set the destination to the current waypoints position
        controller.destination = currentWaypoint.GetPosition();
    }

    // Update is called once per frame
    void Update()
    {
        //if the player has not been seen yet
        if (playerNotSeen && isActiveAndEnabled)
        {
            //if the distance to the waypoint is less than 0.5
            if (controller.remainingDistance < 0.5f)
            {
                //set shouldbranch to false
                bool shouldBranch = false;
                //if there are some branches and the branches in the current waypoint are greater than 1 
                if (currentWaypoint.branches != null && currentWaypoint.branches.Count > 0)
                {
                    //sets should branch based on the branch ratio
                    shouldBranch = Random.Range(0f, 1f) <= currentWaypoint.branchRatio ? true : false;
                }
                //if the ai should branch
                if (shouldBranch)
                {
                    //set the current waypoint to one of the branches in the current waypoint
                    currentWaypoint = currentWaypoint.branches[Random.Range(0, currentWaypoint.branches.Count - 1)];
                }
                //if it should not branch
                else
                {
                    //set the current waypoint to the next waypoint in the list
                    currentWaypoint = currentWaypoint.nextWaypoint;
                }
                //if there is no waypoints remaining
                if (currentWaypoint.nextWaypoint == null)
                {
                    //set it so the navmesh agent does not move
                    controller.velocity = Vector3.zero;
                }
                //set the destination to the current waypoints posiiton
                controller.destination = currentWaypoint.GetPosition();
                //make it so the player has not been seen
                playerNotSeen = true;
            }
        }
    }
}