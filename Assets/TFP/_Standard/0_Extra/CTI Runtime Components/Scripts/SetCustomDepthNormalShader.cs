using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class SetCustomDepthNormalShader : MonoBehaviour {

	public Shader depthNormalShader;

	void Start () {
		SetCustomShader();
	}
	
	void Awake () {
		SetCustomShader();
	}

	void OnValidate() {
		SetCustomShader();
	}


	void SetCustomShader () {
		if (depthNormalShader != null) {
			GraphicsSettings.SetShaderMode(BuiltinShaderType.DepthNormals, BuiltinShaderMode.UseCustom);
			GraphicsSettings.SetCustomShader(BuiltinShaderType.DepthNormals, depthNormalShader);
		}
		else {
			GraphicsSettings.SetShaderMode(BuiltinShaderType.DepthNormals, BuiltinShaderMode.UseBuiltin);
		}
	} 
}
