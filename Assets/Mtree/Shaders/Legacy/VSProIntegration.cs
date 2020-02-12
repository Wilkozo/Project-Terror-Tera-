using System.Collections;
using System.Collections.Generic;

#if VEGETATION_STUDIO_PRO
using AwesomeTechnologies.VegetationSystem;
using UnityEngine;
 
namespace AwesomeTechnologies.Shaders
{
    public class MtreeShaderController : IShaderController
    {
        public bool MatchShader(string shaderName)
        {
            return (shaderName == "Mtree/Bark" || shaderName == "Mtree/Leafs");
        }
 
        public bool MatchBillboardShader(Material[] materials)
        {
            return false;
        }
 
        public ShaderControllerSettings Settings { get; set; }
        bool CustomLightSource;
 
        public void CreateDefaultSettings(Material[] materials)
        {
            Settings = new ShaderControllerSettings
            {
                Heading = "Mtree settings",
                Description = "",
                LODFadePercentage = true,
                LODFadeCrossfade = true,
                SampleWind = true,
                //DynamicHUE = true,
                //BillboardHDWind = false                                              
            };
  
            Settings.AddLabelProperty("Foliage settings");
            Settings.AddColorProperty("FoliageTintColor", "Foliage tint color", "", GetLeafColor(materials));
            Settings.AddFloatProperty("MtreeCutoff","Alpha Cutoff","",GetFloatValue(materials,"_Cutoff"),0,1);
            Settings.AddLabelProperty("Bark settings");
            Settings.AddColorProperty("BarkTintColor", "Bark tint color", "", GetBarkColor(materials));
            Settings.AddLabelProperty("Translucency Settings");
            Settings.AddFloatProperty("TranslucentScale", "Translucency Scale","",GetFloatValue(materials,"_Scale"),0,10);
            Settings.AddFloatProperty("TranslucentPower", "Translucency Power","",GetFloatValue(materials,"_Power"),0,10);
            Settings.AddFloatProperty("TranslucentDistortion", "Translucency Distortion","",GetFloatValue(materials,"_Distortion"),0,10);
            Settings.AddColorProperty("TranslucentColor","Translucency Color","Only Works if Translucent Light Mode set to Custom!",GetTranslucentColor(materials));
            Settings.AddLabelProperty("Mtree Wind Settings");
            Settings.AddFloatProperty("MtreeGlobalWindInfluence", "Global Wind Influence","",GetGlobalFloatValue(materials,"_GlobalWindInfluence"),0,1);
            Settings.AddFloatProperty("MtreeGlobalWindTurbulence", "Global Wind Turbulence Influence","",GetFloatValue(materials,"_GlobalTurbulenceInfluence"),0,1);

        }
       
        public void UpdateMaterial(Material material, EnvironmentSettings environmentSettings)
        {
            if (Settings == null) return;
            if (material.shader.name == "Mtree/Bark")
            {
                Color barkTintColor = Settings.GetColorPropertyValue("BarkTintColor");
                material.SetColor("_Color", barkTintColor);
                float GlobalWindInfluence = Settings.GetFloatPropertyValue("MtreeGlobalWindInfluence");
                material.SetFloat("_GlobalWindInfluence",GlobalWindInfluence);
            }
            if (material.shader.name == "Mtree/Leaves")
            {
                Color foliageTintColor = Settings.GetColorPropertyValue("FoliageTintColor");
                material.SetColor("_Color", foliageTintColor);

                float foliageCutoff = Settings.GetFloatPropertyValue("MtreeCutoff");
                material.SetFloat("_Cutoff", foliageCutoff);

                float translucentScale = Settings.GetFloatPropertyValue("TranslucentScale");
                float translucentPower = Settings.GetFloatPropertyValue("TranslucentPower");
                float translucentDistortion = Settings.GetFloatPropertyValue("TranslucentDistortion");
                
                material.SetFloat("_Scale",translucentScale);
                material.SetFloat("_Power",translucentPower);
                material.SetFloat("_Distortion",translucentDistortion);

                Color translucentColor = Settings.GetColorPropertyValue("TranslucentColor");
                material.SetColor("_TranslucentColor",translucentColor);

                float GlobalWindInfluence = Settings.GetFloatPropertyValue("MtreeGlobalWindInfluence");
                float GlobalWindTurbulence = Settings.GetFloatPropertyValue("MtreeGlobalWindTurbulence");
                material.SetFloat("_GlobalWindInfluence",GlobalWindInfluence);
                material.SetFloat("_GlobalTurbulenceInfluence",GlobalWindTurbulence);
            }
                
                
               


         
        }
        
        Color GetLeafColor(Material[] materials)
        {
            foreach (Material mat in materials)
            {
                if (mat.shader.name == "Mtree/Leaves")
                    return mat.GetColor("_Color");
            }
            return Color.black;
        }
        Color GetBarkColor(Material[] materials)
        {
            foreach (Material mat in materials)
            {
                if (mat.shader.name == "Mtree/Bark")
                    return mat.GetColor("_Color");
            }
            return Color.black;
        }
        float GetFloatValue(Material[] materials,string property){
            foreach(Material mat in materials)
                if (mat.shader.name == "Mtree/Leaves")
                    return mat.GetFloat(property);
            return 0.1f;
        }
        float GetGlobalFloatValue(Material[] materials,string property){
            foreach(Material mat in materials)
                if (mat.shader.name == "Mtree/Leaves" || mat.shader.name == "Mtree/Bark")
                    return mat.GetFloat(property);
            return 0.1f;
        }
        Color GetTranslucentColor(Material[] materials)
        {
            foreach (Material mat in materials)
            {
                if (mat.shader.name == "Mtree/Leaves")
                    return mat.GetColor("_TranslucentColor");
            }
            return Color.black;
        }
       


 
        public void UpdateWind(Material material, WindSettings windSettings)
        {
           
        }
    }
}
#endif