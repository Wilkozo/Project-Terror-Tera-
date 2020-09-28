using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DinoInSight : MonoBehaviour
{
    [SerializeField] DinoChecklist checklist;
    Renderer m_Renderer;

    //what type of dino it is
    public string DinoType;

    private void Start()
    {
        m_Renderer = GetComponent<Renderer>();
        //gets the dino checklist
        checklist = GameObject.FindGameObjectWithTag("dinoChecklist").GetComponent<DinoChecklist>();
    }

    public void Photographed(){
        if (m_Renderer.isVisible)
        {
            Debug.Log("Object is visible");
            Debug.Log("Took photo of a dinosaur");
            checklist.dinosPhotographed(DinoType);
        }
    }
}
