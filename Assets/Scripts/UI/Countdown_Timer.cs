using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Countdown_Timer : MonoBehaviour
{
    // Destruction Timer
    // (Till the Volcano errupts)
    private float DTime = 15;
    public Text textBox;

    // Start is called before the first frame update
    void Start()
    {
        textBox.text = DTime.ToString();
    }

    // Update is called once per frame
    void Update()
    {
        // if Destruction of the island is taking place
        //{
        // Countdown is applied in Update()
        DTime -= Time.deltaTime;
        textBox.text = Mathf.Round(DTime).ToString();
        //}
        // if (DTime == 0)
        //{
        //  Destroy the island
        // Activate some global flag to toggle UI
        // and to let the player know they've lost...
        //}
    }
}
