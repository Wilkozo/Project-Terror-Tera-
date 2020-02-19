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

    public float radiusSeenPlayer = 5.0f;

    public bool lookAt;

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


        if (wander.playerNotSeen)
        {
            radiusSeenPlayer = 5.0f;
        }
        else {
            transform.LookAt(player.transform);
            radiusSeenPlayer = 75.0f;
        }

        //makes it so the raptor can smell the player and then look at them
        Collider[] hits = Physics.OverlapSphere(transform.position, radiusSeenPlayer);
        int i = 0;

        while (i < hits.Length)
        {
            if (hits[i].name == "Player") {


                if (angle < 45.0f)
                {
                    lookAt = true;
                }
                else {
                    lookAt = false;
                }
            Debug.Log("I should be dead");
                transform.LookAt(player.transform);
                HeardSomethingPlayer();
                break;
            }
            i++;
        }

        //if the ai has heard something
        if (heardSomethingFollow) {
            timerHearing += 1 + Time.deltaTime;
        }
        if (timerHearing >= timeToReset) {
            timerHearing = 0;
            heardSomethingFollow = false;
            wander.playerNotSeen = true;
        }

        #region raycasting to detect player

        //get the forward vector3
        Vector3 fwd = transform.TransformDirection(Vector3.forward);
        //draw a ray from the enemy
        Debug.DrawRay(new Vector3(transform.position.x, transform.position.y - 0.75f, transform.position.z), fwd * viewLength, Color.green);
        Debug.DrawRay(new Vector3(transform.position.x, transform.position.y, transform.position.z), fwd * viewLength, Color.green);
        Debug.DrawRay(new Vector3(transform.position.x, transform.position.y + 0.75f, transform.position.z), fwd * viewLength, Color.green);
        Debug.DrawRay(new Vector3(transform.position.x, transform.position.y + 1.25f, transform.position.z), fwd * viewLength, Color.green);
        Debug.DrawRay(new Vector3(transform.position.x, transform.position.y + 1.75f, transform.position.z), fwd * viewLength, Color.green);

        //if it hits something then proceed

        if (Physics.Raycast(new Vector3(transform.position.x, transform.position.y - 1.25f, transform.position.z), fwd, out objectHit, viewLength))
        {
            //if it hit the player then move towards the player
            if (objectHit.transform.tag == "Player")
            {
                //what to do when it sees the player
                SeenPlayer();
            }
            else
            {
                //makes it so it has not yet seen the player
                wander.playerNotSeen = true;
            }
        }

        if (Physics.Raycast(new Vector3(transform.position.x, transform.position.y - 1.75f, transform.position.z), fwd, out objectHit, viewLength))
        {
            //if it hit the player then move towards the player
            if (objectHit.transform.tag == "Player")
            {
                //what to do when it sees the player
                SeenPlayer();
            }
            else
            {
                //makes it so it has not yet seen the player
                wander.playerNotSeen = true;
            }
        }
        if (Physics.Raycast(new Vector3(transform.position.x, transform.position.y - 2.25f, transform.position.z), fwd, out objectHit, viewLength))
        {
            //if it hit the player then move towards the player
            if (objectHit.transform.tag == "Player")
            {
                //what to do when it sees the player
                SeenPlayer();
            }
            else
            {
                //makes it so it has not yet seen the player
                wander.playerNotSeen = true;
            }
        }
        if (Physics.Raycast(new Vector3(transform.position.x, transform.position.y - 2.75f, transform.position.z), fwd, out objectHit, viewLength))
        {
            //if it hit the player then move towards the player
            if (objectHit.transform.tag == "Player")
            {
                //what to do when it sees the player
                SeenPlayer();
            }
            else
            {
                //makes it so it has not yet seen the player
                wander.playerNotSeen = true;
            }
        }

        if (Physics.Raycast(new Vector3(transform.position.x, transform.position.y - 0.75f, transform.position.z), fwd, out objectHit, viewLength))
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

        if (Physics.Raycast(new Vector3(transform.position.x, transform.position.y, transform.position.z), fwd, out objectHit, viewLength))
        {
            //if it hit the player then move towards the player
            if (objectHit.transform.tag == "Player")
            {
                //what to do when it sees the player
                SeenPlayer();
            }
            else
            {
                //makes it so it has not yet seen the player
                wander.playerNotSeen = true;
            }
        }

        if (Physics.Raycast(new Vector3(transform.position.x, transform.position.y + 0.75f, transform.position.z), fwd, out objectHit, viewLength))
        {
            //if it hit the player then move towards the player
            if (objectHit.transform.tag == "Player")
            {
                //what to do when it sees the player
                SeenPlayer();
            }
            else
            {
                //makes it so it has not yet seen the player
                wander.playerNotSeen = true;
            }
        }
        if (Physics.Raycast(new Vector3(transform.position.x, transform.position.y + 1.25f, transform.position.z), fwd, out objectHit, viewLength))
        {
            //if it hit the player then move towards the player
            if (objectHit.transform.tag == "Player")
            {
                //what to do when it sees the player
                SeenPlayer();
            }
            else
            {
                //makes it so it has not yet seen the player
                wander.playerNotSeen = true;
            }
        }

        if (Physics.Raycast(new Vector3(transform.position.x, transform.position.y + 1.75f, transform.position.z), fwd, out objectHit, viewLength))
        {
            //if it hit the player then move towards the player
            if (objectHit.transform.tag == "Player")
            {
                //what to do when it sees the player
                SeenPlayer();
            }
            else
            {
                //makes it so it has not yet seen the player
                wander.playerNotSeen = true;
            }
        }
    }

    #endregion

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
    public void HeardSomethingPlayer()
    {
        if (!heardSomethingFollow && wander.playerNotSeen)
        {
            heardSomethingFollow = true;
          //sets the previous position to temp
            Transform temp = player.transform;
            transform.LookAt(temp);
            //move towards the temp position
            agent.destination = temp.position;
        }
    }

    public void HeardSomethingRock() {

        if (!heardSomethingFollow && wander.playerNotSeen)
        {
            heardSomethingFollow = true;
            //find the rock as there can only be one in the scene at a time
            GameObject temp = GameObject.FindGameObjectWithTag("Rock");
            transform.LookAt(temp.transform);
            //move towards the Rock
            agent.destination = temp.transform.position;
        }
    }
}
