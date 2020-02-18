using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rock : MonoBehaviour
{

    public float speed;

    public Rigidbody rb;

    public float timer;
    public float maxTimer;

    private void Update()
    {
        timer++;
        if (timer > maxTimer) {
            Destroy(this.gameObject);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Ground")
        {

            Collider[] hits = Physics.OverlapSphere(transform.position, 35.0f);
            int i = 0;

            while (i < hits.Length)
            {
                hits[i].SendMessage("HeardSomethingRock");
                i++;
            }
        }
    }

}
