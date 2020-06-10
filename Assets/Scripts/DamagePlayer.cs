using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DamagePlayer : MonoBehaviour
{
    private void OnTriggerStay(Collider other)
    {
        if (other.tag == "Player") {
            other.GetComponent<playerHealth>().health -= 0.5f * Time.deltaTime;
        }
    }

}
