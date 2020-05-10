using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gun : MonoBehaviour
{
    //whether the player has the weapon or not
    public bool gotShotgun;
    public bool gotTranqGun;

    public float slugSpeed = 10;
    public Rigidbody slugRound;

    //how much munitions the player has
    public int shotgunAmmo;
    public int tranqAmmo;

    //shotgun = 1
    //tranqgun = 2
    public int currentWeapon;

    // Update is called once per frame
    void Update()
    {
        //what to do if the player has the shotgun equipped
        if (gotShotgun && currentWeapon == 1) {
            //TODO: display the shotgun

            //if the player pushes the left mouse button and has ammo
            if (Input.GetMouseButtonDown(0) && shotgunAmmo > 0) {
                //be lazy and instantiate bullet prefabs
                for (int i = 0; i < 5; i++)
                {
                    Rigidbody slugRoundClone = (Rigidbody)Instantiate(slugRound, transform.position, transform.rotation);
                    slugRoundClone.velocity = transform.forward * slugSpeed;
                }
                //reduce shotgun ammo by one
                shotgunAmmo -= 1;
            }
        }

    }
}
