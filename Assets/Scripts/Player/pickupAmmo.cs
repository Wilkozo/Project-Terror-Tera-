using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class pickupAmmo : MonoBehaviour
{

    //checks to see what ammo it is
    public bool shotgunAmmoPickup;
    public bool tranqAmmoPickup;

    public int amountToPickup;

    public AudioClip pickupSFX;
    public AudioSource pickupSource;

    [SerializeField] Gun gun;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player") {
            if (shotgunAmmoPickup) {
                if (gun.pickup("Shotgun", amountToPickup)) {
                    //play a pickup sound
                    pickupSource.PlayOneShot(pickupSFX);
                    //if the player can pick up the ammo then destroy it 
                    Destroy(this.gameObject);
                }
            }
            if (tranqAmmoPickup) {
                if (gun.pickup("Tranq", amountToPickup)) {
                    //play a pickup sound
                    pickupSource.PlayOneShot(pickupSFX);
                    //if the player can pickup the ammo then destroy it
                    Destroy(this.gameObject);
                }
            }
        }
    }

}
