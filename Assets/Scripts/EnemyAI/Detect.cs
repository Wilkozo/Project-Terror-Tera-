using System.Collections;
using UnityEngine.AI;
using System.Collections.Generic;
using UnityEngine;
namespace UnityStandardAssets.Characters.FirstPerson
{

    //used to detect audio and visual sources
    public class Detect : MonoBehaviour
    {

        [Header("Player Detection")]
        [SerializeField] WaypointNavigator navigator;
        public Transform target;
        public float distance;
        [SerializeField] playerHealth healthPlayer;
        public float maxDistance;
        public float damageDistance = 10;

        //player and AI components
        public GameObject player;
        public NavMeshAgent agent;

        //raycast view length
        public float viewLength;

        [Header("Audio Detection")]
        public bool heardSound;
        public bool playerHeard;
        public Transform moveToSound;
        public float timeToReset;
        public float timerHearing;
        public float radiusSeenPlayer;
        public bool lookAt;

        [Header("Audio Clips")]
        public AudioSource roarSource;
        public AudioClip hitRoar;
        public float range;


        [Header("Has the AI been hit with a weapon")]
        public bool hitWithShotgun = false;
        public float weaponSlowTimer;
        public float maxWeaponSlowTimer;

        public Animator animator;

        bool blocked = false;


        //what to do when the scene loads
        private void Start()
        {

            animator = this.GetComponentInChildren<Animator>();
            //find the navmesh agent component
            agent = this.GetComponent<NavMeshAgent>();
            //find the player
           // player = GameObject.FindGameObjectWithTag("Player");
           // healthPlayer = player.GetComponent<playerHealth>();
        }


        private void Update()
        {

            //what happens if the ai is hit with the shotgun
            if (hitWithShotgun)
            {
                if (!roarSource.isPlaying)
                {
                    roarSource.PlayOneShot(hitRoar);
                }
                weaponSlowTimer += Time.deltaTime;
                if (weaponSlowTimer >= maxWeaponSlowTimer)
                {

                    weaponSlowTimer = 0;
                    hitWithShotgun = false;
                    agent.speed = 15.0f;
                    animator.SetBool("Hit", false);
                }
            }

            if (!navigator.playerNotSeen)
            {
                agent.destination = player.transform.position;
            }

            //detection
            NavMeshHit hit;
            distance = Vector3.Distance(target.position, this.transform.position);
            //using a navmesh raycast to detect where the player is
            blocked = NavMesh.Raycast(transform.position, target.position, out hit, NavMesh.AllAreas);
            //draw a line
            Debug.DrawLine(transform.position, target.position, blocked ? Color.red : Color.green);

            //if the way is blocked
            if (blocked)
            {
                //draw a ray
                Debug.DrawRay(hit.position, Vector3.up, Color.red);
            }
            //if it isn't blocked
            else if (!blocked)
            {
                //get distance between player and enemy

                //if the distance is less than the max
                if (distance <= maxDistance)
                {
                    //get it so the ai has seen the player
                    SeenPlayer();
                }
            }
            //otherwise if the ai has not heard a sound
            else if (!heardSound || !playerHeard)
            {
                //make it so the player has not been seen
                navigator.playerNotSeen = true;
            }
            if (distance >= 20)
            {
                //make it so the player has not been seen
                navigator.playerNotSeen = true;
            }

            if (distance <= damageDistance)
            {
                healthPlayer.playerHealthImage.fillAmount -= 0.2f * Time.deltaTime;
                //increase the blood overlay effect
                healthPlayer.canGroup.alpha += 0.2f * Time.deltaTime;
                healthPlayer.health -= 0.2f * Time.deltaTime;
                //healthPlayer.LoseHealth();
            }

            if (heardSound || playerHeard)
            {
                timerHearing += Time.deltaTime;

                if (playerHeard)
                {
                }
                else
                {
                    //go to the rock sound
                    GameObject temp = GameObject.FindGameObjectWithTag("Rock");
                    transform.LookAt(temp.transform);
                    agent.destination = temp.transform.position;
                }
                heardSound = false;
            }
            if (timerHearing >= timeToReset)
            {
                //if the time to investigate is full then return to path follow
                timerHearing = 0;
                heardSound = false;
                playerHeard = false;

                if (navigator.playerNotSeen)
                {
                    navigator.waypointToGoTo();
                }
            }
        }

        private void OnTriggerEnter(Collider other)
        {
            if (other.tag == "Bullet")
            {
                animator.SetBool("Hit", true);
                agent.speed = 0;
                agent.velocity = Vector3.zero;
                hitWithShotgun = true;

            }
        }

        //what to do when the player has been seen by the enemy
        void SeenPlayer()
        {
            //makes it so it has seen the player
            navigator.playerNotSeen = false;

            //look at the player
            transform.LookAt(player.transform.position);

            //move towards the player
            agent.destination = player.transform.position;
        }

        public void HeardSomethingPlayer()
        {

            if (!heardSound && navigator.playerNotSeen)
            {
                heardSound = true;
                playerHeard = true;
                //sets the previous position to temp
                Transform temp = player.transform;
                transform.LookAt(temp);
                //move towards the temp position
                agent.destination = temp.position;
            }
        }
        public void HeardSomethingRock()
        {

            if (!heardSound && navigator.playerNotSeen)
            {
                heardSound = true;
                //find the rock as there can only be one in the scene at a time
                GameObject temp = GameObject.FindGameObjectWithTag("Rock");
                transform.LookAt(temp.transform);
                //move towards the Rock
                agent.destination = temp.transform.position;
            }
        }
    }
}