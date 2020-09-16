using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//include UnityEditor to let the window be created
using UnityEditor;

//the window which lets the user create waypoints in an easier fashion
public class WaypointManagerWindow : EditorWindow
{
    //create the ability to open the window
    [MenuItem("Tools/Waypoint Editor")]
    static void Open()
    {
        //create the window
        GetWindow<WaypointManagerWindow>();
    }

    //get the parent that the waypoints will be put under
    public Transform waypointRoot;

    //GUI
    private void OnGUI()
    {
        //create a reference to the menu object
        SerializedObject obj = new SerializedObject(this);

        //need a parent object for the waypoints
        EditorGUILayout.PropertyField(obj.FindProperty("waypointRoot"));

        //if there is no gameobject parent for the waypoint parent
        if (waypointRoot == null)
        {
            //let the user know that there is no parent in which the waypoints will be children of
            EditorGUILayout.HelpBox("Root transform must be selected", MessageType.Warning);
        }
        //otherwise draw the buttons
        else
        {
            //start the button box
            EditorGUILayout.BeginVertical("box");
            //call function draw button
            DrawButtons();
            //end the button box
            EditorGUILayout.EndVertical();
        }
        //apply any modifications to the menu
        obj.ApplyModifiedProperties();
    }

    //how to draw the buttons
    void DrawButtons()
    {
        //what to do if the create waypoint button is pushed
        if (GUILayout.Button("Create a waypoint"))
        {
            CreateWaypoint();
        }
        //if the user has selected the waypoint
        if (Selection.activeGameObject != null && Selection.activeGameObject.GetComponent<Waypoint>())
        {
            //what to do when the create branch button is pushed
            if (GUILayout.Button("CreateBranch"))
            {
                CreateBranch();
            }
            //what to do when the create waypoint before button is pushed
            if (GUILayout.Button("Create Waypoint Before"))
            {
                CreateWaypointBefore();
            }
            //what to do when the create waypoint after button is pushed
            if (GUILayout.Button("Create Waypoint After"))
            {
                CreateWaypointAfter();
            }
            //what to do when the remove waypoint button is pushed
            if (GUILayout.Button("Remove Waypoint"))
            {
                RemoveWaypoint();
            }
        }
    }

    //How to create a branching path
    void CreateBranch()
    {
        //create a new gameobject of type waypoint with the name of branch + the number of children in the root gameobject
        GameObject waypointObject = new GameObject("Branch " + waypointRoot.childCount, typeof(Waypoint));
        //set the branch to be a child of the waypointRoot
        waypointObject.transform.SetParent(waypointRoot, false);

        //set a waypoint based on the component of waypoint from the branch
        Waypoint waypoint = waypointObject.GetComponent<Waypoint>();

        //find the waypoint that the branch is coming from
        Waypoint branchedFrom = Selection.activeGameObject.GetComponent<Waypoint>();
        //add the branch to the branchedFrom part of the waypoint that is being branched from
        branchedFrom.branches.Add(waypoint);

        //set the branch to the same pos as the original waypoint
        waypoint.transform.position = branchedFrom.transform.position;
        //set the branch to the same forward dir as the original waypoint
        waypoint.transform.forward = branchedFrom.transform.forward;

        //make the selected object the new branch
        Selection.activeGameObject = waypoint.gameObject;

    }

    //how to remove a waypoint
    void RemoveWaypoint()
    {
        //set the selected waypoint to the waypoint that is actually selected
        Waypoint selectedWaypoint = Selection.activeGameObject.GetComponent<Waypoint>();

        //if there is a next waypoint
        if (selectedWaypoint.nextWaypoint != null)
        {
            //set the the previous waypoint of the next waypoint to the waypoint before the current one
            selectedWaypoint.nextWaypoint.previousWaypoint = selectedWaypoint.previousWaypoint;
        }
        //if there is a previous waypoint
        if (selectedWaypoint.previousWaypoint != null)
        {
            //set the previous waypoints next waypoint to the next waypoint of the current waypoint
            selectedWaypoint.previousWaypoint.nextWaypoint = selectedWaypoint.nextWaypoint;
            //selecet the previous waypoint
            Selection.activeGameObject = selectedWaypoint.previousWaypoint.gameObject;
        }
        //destroy the waypoint that was selected to be removed
        DestroyImmediate(selectedWaypoint.gameObject);

    }

    //how to create a waypoint before the current waypoint
    void CreateWaypointBefore()
    {
        GameObject waypointObject = new GameObject("Waypoint " + waypointRoot.childCount, typeof(Waypoint));
        waypointObject.transform.SetParent(waypointRoot, false);

        Waypoint newWaypoint = waypointObject.GetComponent<Waypoint>();

        Waypoint selectedWaypoint = Selection.activeGameObject.GetComponent<Waypoint>();

        waypointObject.transform.position = selectedWaypoint.transform.position;
        waypointObject.transform.forward = selectedWaypoint.transform.forward;

        if (selectedWaypoint.previousWaypoint != null)
        {
            newWaypoint.previousWaypoint = selectedWaypoint.previousWaypoint;
            selectedWaypoint.previousWaypoint.nextWaypoint = newWaypoint;
        }

        newWaypoint.nextWaypoint = selectedWaypoint;

        selectedWaypoint.previousWaypoint = newWaypoint;

        newWaypoint.transform.SetSiblingIndex(selectedWaypoint.transform.GetSiblingIndex());

        Selection.activeGameObject = newWaypoint.gameObject;

    }

    //how to create a waypoint after the current waypoint
    void CreateWaypointAfter()
    {

        GameObject waypointObject = new GameObject("Waypoint " + waypointRoot.childCount, typeof(Waypoint));
        waypointObject.transform.SetParent(waypointRoot, false);

        Waypoint newWaypoint = waypointObject.GetComponent<Waypoint>();

        Waypoint selectedWaypoint = Selection.activeGameObject.GetComponent<Waypoint>();

        waypointObject.transform.position = selectedWaypoint.transform.position;
        waypointObject.transform.forward = selectedWaypoint.transform.forward;

        newWaypoint.previousWaypoint = selectedWaypoint;

        if (selectedWaypoint.nextWaypoint != null)
        {
            selectedWaypoint.nextWaypoint.previousWaypoint = newWaypoint;
            newWaypoint.nextWaypoint = selectedWaypoint.nextWaypoint;
        }

        selectedWaypoint.nextWaypoint = newWaypoint;
        newWaypoint.transform.SetSiblingIndex(selectedWaypoint.transform.GetSiblingIndex());

        Selection.activeGameObject = newWaypoint.gameObject;
    }

    //how to create a waypoint
    void CreateWaypoint()
    {

        GameObject waypointObject = new GameObject("Waypoint " + waypointRoot.childCount, typeof(Waypoint));
        waypointObject.transform.SetParent(waypointRoot, false);

        Waypoint waypoint = waypointObject.GetComponent<Waypoint>();
        if (waypointRoot.childCount > 1)
        {
            waypoint.previousWaypoint = waypointRoot.GetChild(waypointRoot.childCount - 2).GetComponent<Waypoint>();
            waypoint.previousWaypoint.nextWaypoint = waypoint;
            //place the waypoint at the last position
            waypoint.transform.position = waypoint.previousWaypoint.transform.position;
            waypoint.transform.forward = waypoint.previousWaypoint.transform.forward;
        }
        Selection.activeGameObject = waypoint.gameObject;

    }
}