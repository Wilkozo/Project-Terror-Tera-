using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class pickupAmmo : MonoBehaviour
{

    //checks to see what ammo it is
    public bool shotgunAmmoPickup;
    public bool tranqAmmoPickup;

    [SerializeField] Gun gun;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player") {
            if (shotgunAmmoPickup) {
                gun.pickup("Shotgun");
                Destroy(this.gameObject);
            }
            if (tranqAmmoPickup) {
                gun.pickup("Tranq");
            }
        }
    }

}
