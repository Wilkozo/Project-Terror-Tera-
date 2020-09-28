using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

//used to draw the gizmos so the user can actually see where the path is
[InitializeOnLoad()]
public class WaypointEditor
{
    [DrawGizmo(GizmoType.NonSelected | GizmoType.Selected | GizmoType.Pickable)]
    //draw gizmos in the scene
    public static void OnDrawSceneGizmo(Waypoint waypoint, GizmoType gizmoType)
    {
        //if the gizmo is selected
        if ((gizmoType & GizmoType.Selected) != 0)
        {
            //set the color to yellow
            Gizmos.color = Color.yellow;
        }
        //if the gizmo is not selected
        else
        {
            //set the color to a darker yellow
            Gizmos.color = Color.yellow * 0.5f;
        }

        //draw a sphere around each waypoint at their center positions
        Gizmos.DrawSphere(waypoint.transform.position, 0.1f);

        //set the Gizmos color to white
        Gizmos.color = Color.white;
        //Draw a line across the sphere to help find the waypoints
        Gizmos.DrawLine(waypoint.transform.position + (waypoint.transform.right * waypoint.width / 2f), waypoint.transform.position - (waypoint.transform.right * waypoint.width / 2f));

        //if there is a previous waypoint
        if (waypoint.previousWaypoint != null)
        {
            //set the color to red
            Gizmos.color = Color.red;
            //make it so there is an offset from the center of the waypoint
            Vector3 offset = waypoint.transform.right * waypoint.width / 2f;
            Vector3 offsetTo = waypoint.previousWaypoint.transform.right * waypoint.previousWaypoint.width / 2f;
            //draw a line between the 2 waypoints
            Gizmos.DrawLine(waypoint.transform.position + offset, waypoint.previousWaypoint.transform.position + offsetTo);
        }

        //if there is a next waypoint
        if (waypoint.nextWaypoint != null)
        {
            //set the gizmo color to green
            Gizmos.color = Color.green;
            //off set the gizmo from the center of the waypoint
            Vector3 offset = waypoint.transform.right * -waypoint.width / 2f;
            Vector3 offsetTo = waypoint.nextWaypoint.transform.right * -waypoint.nextWaypoint.width / 2f;
            //draw the line between the 2 waypoints
            Gizmos.DrawLine(waypoint.transform.position + offset, waypoint.nextWaypoint.transform.position + offsetTo);
        }

        //if there are branches
        if (waypoint.branches != null)
        {
            //go through each branch
            foreach (Waypoint branch in waypoint.branches)
            {
                //set gizmo color to blue
                Gizmos.color = Color.blue;
                //draw a line from the branch to the waypoint
                Gizmos.DrawLine(waypoint.transform.position, branch.transform.position);
            }
        }
    }
}