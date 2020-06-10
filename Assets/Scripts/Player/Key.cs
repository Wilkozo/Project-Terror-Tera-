using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Key : MonoBehaviour
{

    public Transform gateToMove;
    public Vector3 whereToMoveGateTo;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player") {

            gateToMove.position = whereToMoveGateTo;
            Destroy(this.gameObject);

        }
    }
}
