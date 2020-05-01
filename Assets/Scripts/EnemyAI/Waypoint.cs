using System.Collections;
using System.Collections.Generic;
using UnityEngine;


//base waypoint class that holds how they link together
//similar in some design to a linked list
public class Waypoint : MonoBehaviour
{
    //references to the previous and next waypoint
    public Waypoint previousWaypoint;
    public Waypoint nextWaypoint;

    //let there be a max of 5
    [Range(0f, 5f)]
    public float width = 1f;
    //list of branches
    public List<Waypoint> branches = new List<Waypoint>();

    //let there be a max of 1 
    [Range(0f, 1f)]
    //what the branch ratio is
    public float branchRatio = 0.5f;

    //get the position of the waypoint
    public Vector3 GetPosition()
    {
        //let there be a little bit of give and take so the waypoint is not in just one set pos
        Vector3 minBound = transform.position + transform.right * width / 2;
        Vector3 maxBound = transform.position + transform.right * width / 2;
        //lerp between the two points, in order to make something that is close enough to the center
        return Vector3.Lerp(minBound, maxBound, Random.Range(0f, 1f));
    }
}