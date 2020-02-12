using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode]
[RequireComponent(typeof(Light))]
public class MtreeHDRPLights : MonoBehaviour
{
    Light m_light,c_light;    
    void Awake(){
        m_light = GetComponent<Light>();
        SendLightData();
    }
    void Update()
    {
        SendLightData();
    }
    void SendLightData(){
        if(m_light.type == LightType.Directional)
            {
                var colTemp =  Mathf.CorrelatedColorTemperatureToRGB(m_light.colorTemperature);
                Shader.SetGlobalColor("_LightColor",colTemp * m_light.color);
                Shader.SetGlobalFloat("_LightIntensity",m_light.intensity);
            }
    }
}
