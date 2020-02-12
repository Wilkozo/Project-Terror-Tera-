﻿
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using Mtree;
[ExecuteInEditMode]
public class ExampleSceneManager : MonoBehaviour
{
    List<Material> BarkMaterials,LeafMaterials;
    Material Floor;
    GameObject Trees,PostProcessing;
    bool Setup = true;
    
    void PostProcessActive()
    {
#if UNITY_POST_PROCESSING_STACK_V2
        
#if UNITY_2019_3_OR_NEWER
        
    if( Utils.GetCurrentPipeline() == "legacy"){
        PostProcessing = Instantiate(Resources.Load("Mtree/Examples/Post Processing") as GameObject,this.transform);
        PostProcessing.layer = 1;
        var cam = GetComponentInChildren<Camera>().gameObject;
        cam.layer = 1;
        var PPlayer = cam.AddComponent<UnityEngine.Rendering.PostProcessing.PostProcessLayer>();
        PPlayer.antialiasingMode = UnityEngine.Rendering.PostProcessing.PostProcessLayer.Antialiasing.FastApproximateAntialiasing;
        PPlayer.volumeLayer = 2;
        PostProcessing.transform.SetParent(this.transform);
    }
#else
        PostProcessing = Instantiate(Resources.Load("Mtree/Examples/Post Processing") as GameObject,this.transform);
        PostProcessing.layer = 1;
        var cam = GetComponentInChildren<Camera>().gameObject;
        cam.layer = 1;
        var PPlayer = cam.AddComponent<UnityEngine.Rendering.PostProcessing.PostProcessLayer>();
        PPlayer.antialiasingMode = UnityEngine.Rendering.PostProcessing.PostProcessLayer.Antialiasing.FastApproximateAntialiasing;
        PPlayer.volumeLayer.value = 2;
        PostProcessing.transform.SetParent(this.transform);
    #endif
#endif
    
    }
    void LegacySetup(){
#if UNITY_2019_1_OR_NEWER
        Instantiate(Resources.Load("Mtree/Examples/Legacy") as GameObject,this.transform);
        Debug.Log("Legacy Scene loaded!");
#else
        Instantiate(Resources.Load("Mtree/Examples/Legacy 2018_3_OR_OLDER") as GameObject,this.transform);
        Debug.Log("Legacy 2018.3 and Older was loaded!");
#endif
    }
    void LWRPSetup()
    {
    #if UNITY_2018_3_OR_NEWER
        Instantiate(Resources.Load("Mtree/Examples/LWRP") as GameObject,this.transform);
        Debug.Log("LWRP Scene loaded!");
    #endif
    }

    void HDRPSetup()
    {
        
    #if UNITY_2019_3_OR_NEWER
        Instantiate(Resources.Load("Mtree/Examples/HDRP 2019_3_OR_NEWER") as GameObject,this.transform);
        Debug.Log("HDRP 2019.3+ Scene loaded!");
    #else
        Instantiate(Resources.Load("Mtree/Examples/HDRP") as GameObject,this.transform);
        Debug.Log("HDRP Scene loaded!");
    #endif
    }
    void URPSetup()
    {
        #if UNITY_2019_3_OR_NEWER
            Instantiate(Resources.Load("Mtree/Examples/URP") as GameObject,this.transform);
            Debug.Log("URP Scene loaded!");
        #endif       
    }
    void Start()
    {
        
        if(Setup){
            foreach(Transform t in this.transform)
                DestroyImmediate(t.gameObject);
            switch(Utils.GetCurrentPipeline())
            {
                case "legacy":
                    LegacySetup();
                break;

                case "lwrp":
                    LWRPSetup();
                break;

                case "hdrp":
                    HDRPSetup();
                break;

                case "urp":
                    URPSetup();
                break;
            }
            PostProcessActive();
            UpdateMaterials();
            Setup = false;
        }
    }
    void UpdateMaterials(){
        
        BarkMaterials = new List<Material>();
        LeafMaterials = new List<Material>();
        var renderers = GameObject.Find("Trees").GetComponentsInChildren<MeshRenderer>();
        Floor = transform.GetComponent<MeshRenderer>().sharedMaterial;
        foreach (var r in renderers){
            foreach(var m in r.sharedMaterials){
                if(m.shader.name.Contains("Leaves"))
                    LeafMaterials.Add(m);
                if(m.shader.name.Contains("Bark"))
                    BarkMaterials.Add(m);
            }
        }

        for(int i = 0; i<BarkMaterials.Count;i++)
            BarkMaterials[i].shader = Utils.GetBarkShader();
        for(int i = 0; i<LeafMaterials.Count;i++)
            LeafMaterials[i].shader = Utils.GetLeafShader();

        switch(Utils.GetCurrentPipeline())
            {
                case "legacy":
                    Floor.shader = Shader.Find("Standard");
                break;

                case "lwrp":
                    Floor.shader = Shader.Find("Lightweight Render Pipeline/Lit");
                break;

                case "hdrp":
                    Floor.shader = Shader.Find("HDRP/Lit");
                break;

                case "urp":
                    Floor.shader = Shader.Find("Universal Render Pipeline/Lit");
                break;
            }


        
    }
}