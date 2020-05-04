using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class shotgunBullet : MonoBehaviour
{

    public float speed;

    public Rigidbody rb;

    public float timer;
    public float maxTimer;

    private void Update()
    {
        timer++;
        if (timer > maxTimer)
        {
            //destroy the bullet
            Destroy(this.gameObject);
        }
    }

}
