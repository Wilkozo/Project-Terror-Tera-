using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Gun : MonoBehaviour
{
    public AudioSource source;
    public AudioClip clip;

    //whether the player has the weapon or not
    public bool gotShotgun = true;
    public bool gotTranqGun = true;

    public float slugSpeed = 10;
    public float tranqSpeed = 50;
    public Rigidbody slugRound;

    //how much munitions the player has
    public int shotgunAmmo = 5;
    public int tranqAmmo = 3;
    float delay;

    public Image shotgunRoundsImage;
    public Image tranqRoundsImage;

    public Image staminaBar;
    public float staminaAmount = 10;

    //shotgun = 1
    //tranqgun = 2
    public bool currentWeapon = true;

    private void Start()
    {
        staminaBar.fillAmount = 1;

        shotgunRoundsImage.fillAmount = 0;
        for (int i = 0; i < shotgunAmmo; i++)
        {
            shotgunRoundsImage.fillAmount += 0.056666f;
        }

        //fill the tranq rounds image
        tranqRoundsImage.fillAmount = 0;
        for (int i = 0; i < tranqAmmo; i++)
        {
            tranqRoundsImage.fillAmount += 0.125f;
        }

        tranqRoundsImage.enabled = false;
    }

    public bool pickup(string ammoType, int amountToFill)
    {
        if (ammoType == "Shotgun")
        {
            if (shotgunAmmo < 18)
            {
                shotgunAmmo += amountToFill;
                shotgunRoundsImage.fillAmount += 0.056666f * amountToFill;
                return true;
            }
        }
        if (ammoType == "Tranq")
        {
            if (tranqAmmo < 8)
            {
                tranqAmmo += amountToFill;
                tranqRoundsImage.fillAmount += 0.125f * amountToFill;
                return true;
            }
        }
        return false;
    }

    // Update is called once per frame
    void Update()
    {

        if (Input.GetKeyDown(KeyCode.Q)) {
            currentWeapon = !currentWeapon;
        }

        delay += Time.deltaTime;
        //what to do if the player has the shotgun equipped
        if (gotShotgun && currentWeapon)
        {
            tranqRoundsImage.enabled = false;
            shotgunRoundsImage.enabled = true;

            //if the player pushes the left mouse button and has ammo
            if (Input.GetMouseButtonDown(0) && shotgunAmmo > 0 && delay >= 1 || Input.GetKey(KeyCode.Z) && shotgunAmmo > 0 && delay >= 1)
            {
                //be lazy and instantiate bullet prefabs
                for (int i = 0; i < 5; i++)
                {
                    source.PlayOneShot(clip);
                    //alert the dinosaur
                    audioSenderGun(40.0f);
                    Rigidbody slugRoundClone = (Rigidbody)Instantiate(slugRound, transform.position, transform.rotation);
                    slugRoundClone.velocity = transform.forward * slugSpeed;
                    delay = 0;
                }
                //reduce shotgun ammo by one
                shotgunAmmo -= 1;
                shotgunRoundsImage.fillAmount -= 0.056666666f;
            }
        }
        else if (gotTranqGun && !currentWeapon)
        {
            tranqRoundsImage.enabled = true;
            shotgunRoundsImage.enabled = false;
            //if the player pushes the left mouse button and has ammo
            if (Input.GetMouseButtonDown(0) && tranqAmmo > 0 && delay >= 1 || Input.GetKey(KeyCode.Z) && tranqAmmo > 0 && delay >= 1)
            {
                source.PlayOneShot(clip);
                //alert the dinosaur
                audioSenderGun(40.0f);
                Rigidbody slugRoundClone = (Rigidbody)Instantiate(slugRound, transform.position, transform.rotation);
                slugRoundClone.velocity = transform.forward * tranqSpeed;
                delay = 0;

                //reduce shotgun ammo by one
                tranqAmmo -= 1;
                tranqRoundsImage.fillAmount -= 0.125f;
            }
            else
            {
                //don't display a weapon
            }


        }

        void audioSenderGun(float radius)
        {

            Collider[] hits = Physics.OverlapSphere(transform.position, radius);
            int i = 0;

            while (i < hits.Length)
            {
                hits[i].SendMessage("HeardSomethingPlayer", SendMessageOptions.DontRequireReceiver);
                i++;
            }
        }
    }
}
