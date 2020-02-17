using System.Collections;
using UnityEngine.AI;
using System.Collections.Generic;
using UnityEngine;


//used to detect audio and visual sources
public class Detect : MonoBehaviour
{ 

    //getting the wander script
    [SerializeField] BasicWander wander;

    public GameObject player;

    private NavMeshAgent agent;

    //how fast the ai will travel
    public float speed;

    //how far the ai can see
    public float viewLength;

    //ai hearing a sound 
    public bool heardSomethingFollow;
    public Transform heardSomethingFollowPosition;
    public float timerHearing;
    public float timeToReset;

    private void Start()
    {
        //get the navemesh agent component of the ai
        agent = GetComponent<NavMeshAgent>();

        //find the player
        player = GameObject.FindGameObjectWithTag("Player");
        //if the player tag is not there
        if (!player)
        {
            Debug.Log("Make sure your player is tagged!!");
        }
    }

    void Update()
    {
        //raycast hiting object
        RaycastHit objectHit;

        //gets the target position to move to
        Vector3 targetDir = player.transform.position - transform.position;
        //gets the angle between the player and this transform
        float angle = Vector3.Angle(targetDir, transform.forward);

        //if the angle is less than 45 and the player is not more than 10 units away
        if (angle < 60)
        {
            //look at the player
            transform.LookAt(player.transform);
        }

        //if the ai has heard something
        if (heardSomethingFollow) {
            agent.destination = heardSomethingFollowPosition.position;
            timerHearing += Time.deltaTime;
        }
        if (timerHearing >= timeToReset) {
            heardSomethingFollow = false;
        }

        //get the forward vector3
        Vector3 fwd = transform.TransformDirection(Vector3.forward);
        //draw a ray from the enemy
        Debug.DrawRay(transform.position, fwd * viewLength, Color.green);
        //if it hits something then proceed
        if (Physics.Raycast(transform.position, fwd, out objectHit, viewLength))
        {
            //if it hit the player then move towards the player
            if (objectHit.transform.tag == "Player")
            {
                //what to do when it sees the player
                SeenPlayer();
            }
            else {
                //makes it so it has not yet seen the player
                wander.playerNotSeen = true;
            }
        }


    }

    //what to do when the ai has seen the player
    void SeenPlayer() {

        //makes it so it has seen the player
        wander.playerNotSeen = false;

        //look at the player
        transform.LookAt(player.transform.position);

        //move towards the player
        agent.destination = player.transform.position;

    }

    //what to do when the ai has heard something
    public void HeardSomething() {

    }


}
