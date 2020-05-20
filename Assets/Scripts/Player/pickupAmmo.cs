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
                if (gun.pickup("Shotgun")) {
                    //if the player can pick up the ammo then destroy it 
                    Destroy(this.gameObject);
                }
            }
            if (tranqAmmoPickup) {
                if (gun.pickup("Tranq")) {
                    //if the player can pickup the ammo then destroy it
                    Destroy(this.gameObject);
                }
            }
        }
    }

}
