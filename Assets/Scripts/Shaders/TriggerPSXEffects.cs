using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerPSXEffects : MonoBehaviour
{

    [SerializeField] PSXEffects psxEffects;

    private void Start()
    {
        psxEffects = this.GetComponent<PSXEffects>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.P)) {
            psxEffects.enabled = !psxEffects.enabled;
        }    
    }
}
