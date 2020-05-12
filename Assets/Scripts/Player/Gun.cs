﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Gun : MonoBehaviour
{
    public AudioSource source;
    public AudioClip clip;

    //whether the player has the weapon or not
    public bool gotShotgun;
    public bool gotTranqGun;

    public float slugSpeed = 10;
    public Rigidbody slugRound;

    //how much munitions the player has
    public int shotgunAmmo;
    public int tranqAmmo;
    float delay;

    public Image shotgunRoundsImage;

    //shotgun = 1
    //tranqgun = 2
    public int currentWeapon;

    private void Start()
    {
        shotgunRoundsImage.fillAmount = 0;
        for (int i = 0; i < shotgunAmmo; i++) {
            shotgunRoundsImage.fillAmount += 0.056666f;
        }
    }

    // Update is called once per frame
    void Update()
    {
        delay += Time.deltaTime;
        //what to do if the player has the shotgun equipped
        if (gotShotgun && currentWeapon == 1) {
            //TODO: display the shotgun

            //if the player pushes the left mouse button and has ammo
            if (Input.GetMouseButtonDown(0) && shotgunAmmo > 0 && delay >= 1) {
                //be lazy and instantiate bullet prefabs
                for (int i = 0; i < 5; i++)
                {
                    source.PlayOneShot(clip);
                    Rigidbody slugRoundClone = (Rigidbody)Instantiate(slugRound, transform.position, transform.rotation);
                    slugRoundClone.velocity = transform.forward * slugSpeed;
                    delay = 0;
                }
                //reduce shotgun ammo by one
                shotgunAmmo -= 1;
                shotgunRoundsImage.fillAmount -= 0.056666666f;
            }
        }


    }
}
