using System.Collections;
using UnityEngine.AI;
using System.Collections.Generic;
using UnityEngine;


//used to detect audio and visual sources
public class Detect : MonoBehaviour
{

    public GameObject player;

    public NavMeshAgent agent;

    public float viewLength;

    public bool heardSound;
    public bool playerHeard;
    public Transform moveToSound;
    public float timeToReset;
    public float timerHearing;
    public float radiusSeenPlayer;

    public AudioClip roar;
    public AudioSource roarSource;
    public float range;

    public bool lookAt;

    //what to do when the scene loads
    private void Start()
    {
        //find the navmesh agent component
        agent = this.GetComponent<NavMeshAgent>();
        //find the player
        player = GameObject.FindGameObjectWithTag("Player");
    }

    private void Update()
    {
        //raycast hit
        RaycastHit rayHit;

        //get the players position - this position
        Vector3 targetDir = player.transform.position - this.transform.position;
        //get angle between playe and this transform
        float angle = Vector3.Angle(targetDir, this.transform.forward);

        //if the player has not been seen set the radius to 45

        //else
        //set the radius to 175 if the player has been seen

        Collider[] hits = Physics.OverlapSphere(transform.position, 50.0f);
        int i = 0;
        while (i < hits.Length) {
            if (hits[i].name == "Player") {

                if (angle < 45.0f)
                {
                    lookAt = true;
                }
                else
                {
                    lookAt = false;
                }
                Debug.Log("I should be dead");
                transform.LookAt(player.transform);
                //makes it so it has seen the player
               // wander.playerNotSeen = false;

                //look at the player
                transform.LookAt(player.transform.position);

                //move towards the player
                agent.destination = player.transform.position;


                SeenPlayer();
            }
            i++;
        }
        if (heardSound) {
            timerHearing += 1 + Time.deltaTime;
            if (playerHeard)
            {
                //go to where the player was
                Transform temp = player.transform;
                transform.LookAt(temp);
                agent.destination = temp.position;
            }
            else {
                //go to the rock sound
                GameObject temp = GameObject.FindGameObjectWithTag("Rock");
                transform.LookAt(temp.transform);
                agent.destination = temp.transform.position;
            }
        }
        if (timerHearing >= timeToReset) {
            //if the time to investigate is full then return to path follow
            timerHearing = 0;
            heardSound = false;
        }

    }

    void SeenPlayer() {


    }
            
    }

    //        #region raycasting to detect player

    //        //get the forward vector3
    //        Vector3 fwd = transform.TransformDirection(Vector3.forward);
    //        //draw a ray from the enemy
    //        Debug.DrawRay(new Vector3(transform.position.x, transform.position.y - 0.75f, transform.position.z), fwd * viewLength, Color.green);
    //        Debug.DrawRay(new Vector3(transform.position.x, transform.position.y, transform.position.z), fwd * viewLength, Color.green);
    //        Debug.DrawRay(new Vector3(transform.position.x, transform.position.y + 0.75f, transform.position.z), fwd * viewLength, Color.green);
    //        Debug.DrawRay(new Vector3(transform.position.x, transform.position.y + 1.25f, transform.position.z), fwd * viewLength, Color.green);
    //        Debug.DrawRay(new Vector3(transform.position.x, transform.position.y + 1.75f, transform.position.z), fwd * viewLength, Color.green);

    //        //if it hits something then proceed

    //        if (Physics.Raycast(new Vector3(transform.position.x, transform.position.y - 1.25f, transform.position.z), fwd, out objectHit, viewLength))
    //        {
    //            //if it hit the player then move towards the player
    //            if (objectHit.transform.tag == "Player")
    //            {
    //                //what to do when it sees the player
    //                SeenPlayer();
    //            }
    //            else
    //            {
    //                //makes it so it has not yet seen the player
    //                wander.playerNotSeen = true;
    //            }
    //        }

    //        if (Physics.Raycast(new Vector3(transform.position.x, transform.position.y - 1.75f, transform.position.z), fwd, out objectHit, viewLength))
    //        {
    //            //if it hit the player then move towards the player
    //            if (objectHit.transform.tag == "Player")
    //            {
    //                //what to do when it sees the player
    //                SeenPlayer();
    //            }
    //            else
    //            {
    //                //makes it so it has not yet seen the player
    //                wander.playerNotSeen = true;
    //            }
    //        }
    //        if (Physics.Raycast(new Vector3(transform.position.x, transform.position.y - 2.25f, transform.position.z), fwd, out objectHit, viewLength))
    //        {
    //            //if it hit the player then move towards the player
    //            if (objectHit.transform.tag == "Player")
    //            {
    //                //what to do when it sees the player
    //                SeenPlayer();
    //            }
    //            else
    //            {
    //                //makes it so it has not yet seen the player
    //                wander.playerNotSeen = true;
    //            }
    //        }
    //        if (Physics.Raycast(new Vector3(transform.position.x, transform.position.y - 2.75f, transform.position.z), fwd, out objectHit, viewLength))
    //        {
    //            //if it hit the player then move towards the player
    //            if (objectHit.transform.tag == "Player")
    //            {
    //                //what to do when it sees the player
    //                SeenPlayer();
    //            }
    //            else
    //            {
    //                //makes it so it has not yet seen the player
    //                wander.playerNotSeen = true;
    //            }
    //        }

    //        if (Physics.Raycast(new Vector3(transform.position.x, transform.position.y - 0.75f, transform.position.z), fwd, out objectHit, viewLength))
    //        {
    //            //if it hit the player then move towards the player
    //            if (objectHit.transform.tag == "Player")
    //            {
    //                //what to do when it sees the player
    //                SeenPlayer();
    //            }
    //            else {
    //                //makes it so it has not yet seen the player
    //                wander.playerNotSeen = true;
    //            }
    //        }

    //        if (Physics.Raycast(new Vector3(transform.position.x, transform.position.y, transform.position.z), fwd, out objectHit, viewLength))
    //        {
    //            //if it hit the player then move towards the player
    //            if (objectHit.transform.tag == "Player")
    //            {
    //                //what to do when it sees the player
    //                SeenPlayer();
    //            }
    //            else
    //            {
    //                //makes it so it has not yet seen the player
    //                wander.playerNotSeen = true;
    //            }
    //        }

    //        if (Physics.Raycast(new Vector3(transform.position.x, transform.position.y + 0.75f, transform.position.z), fwd, out objectHit, viewLength))
    //        {
    //            //if it hit the player then move towards the player
    //            if (objectHit.transform.tag == "Player")
    //            {
    //                //what to do when it sees the player
    //                SeenPlayer();
    //            }
    //            else
    //            {
    //                //makes it so it has not yet seen the player
    //                wander.playerNotSeen = true;
    //            }
    //        }
    //        if (Physics.Raycast(new Vector3(transform.position.x, transform.position.y + 1.25f, transform.position.z), fwd, out objectHit, viewLength))
    //        {
    //            //if it hit the player then move towards the player
    //            if (objectHit.transform.tag == "Player")
    //            {
    //                //what to do when it sees the player
    //                SeenPlayer();
    //            }
    //            else
    //            {
    //                //makes it so it has not yet seen the player
    //                wander.playerNotSeen = true;
    //            }
    //        }

    //        if (Physics.Raycast(new Vector3(transform.position.x, transform.position.y + 1.75f, transform.position.z), fwd, out objectHit, viewLength))
    //        {
    //            //if it hit the player then move towards the player
    //            if (objectHit.transform.tag == "Player")
    //            {
    //                //what to do when it sees the player
    //                SeenPlayer();
    //            }
    //            else
    //            {
    //                //makes it so it has not yet seen the player
    //                wander.playerNotSeen = true;
    //            }
    //        }
    //    }

    //    #endregion

    //    //what to do when the ai has seen the player
    //    void SeenPlayer() {
    //        if (Played == false)
    //        {

    //            FindObjectOfType<AudioManager>().Play("Detected");
    //            Played = true;
    //        }

    //        //makes it so it has seen the player
    //        wander.playerNotSeen = false;

    //        //look at the player
    //        transform.LookAt(player.transform.position);

    //        //move towards the player
    //        agent.destination = player.transform.position;

    //    }

    //    //what to do when the ai has heard something
    //    public void HeardSomethingPlayer()
    //    {
    //        if (!heardSomethingFollow && wander.playerNotSeen)
    //        {
    //            heardSomethingFollow = true;
    //            playerHeard = true;
    //          ////sets the previous position to temp
    //          //  Transform temp = player.transform;
    //          //  transform.LookAt(temp);
    //          //  //move towards the temp position
    //          //  agent.destination = temp.position;
    //        }
    //    }

    //    public void HeardSomethingRock() {

    //        if (!heardSomethingFollow && wander.playerNotSeen)
    //        {
    //            heardSomethingFollow = true;
    //            ////find the rock as there can only be one in the scene at a time
    //            //GameObject temp = GameObject.FindGameObjectWithTag("Rock");
    //            //transform.LookAt(temp.transform);
    //            ////move towards the Rock
    //            //agent.destination = temp.transform.position;
    //        }
    //    }
