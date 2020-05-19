Shader "CTI/LOD Debug" {
	Properties {

		[Header(Visualize baked data)]
		[Space(3)]
		[Enum(RGB,0,Red (Phase),1,Green (Edge Flutter),2,Blue (Tumble Strength),3,Alpha (Ambient Occlusion),4)] _DebugMode ("Vertex Color Channels", Float) = 0
		[Enum(None,0,Main Bending,1,Branch Bending,2,Branch Axis,3)] _DebugBending ("Bending", Float) = 0
		_ColorMultiplier("Brighten Color Output", Range (0.1, 10.0)) = 1
		_ColorContrast("Contrast Color Output", Range (1, 4.0)) = 1

		[Header(Classic Wind Features)]
		[Space(3)]
		[Toggle(ENABLE_WIND)] _MainWind ("Disable main Wind", Float) = 0.0
		[Toggle(EFFECT_BUMP)] _BranchWind ("Disable main Turbulence and Edge Flutter", Float) = 0.0

		[Header(Custom Wind Feature)]
		[Space(3)]
		[Toggle(EFFECT_HUE_VARIATION)] _LeafTumbling ("Disable Leaf Tumbling", Float) = 0.0
		_TumbleStrength("Tumble Strength", Range(-1,1)) = 0.1
		_TumbleFrequency("Tumble Frequency", Range(0,4)) = 1
		_TimeOffset("Time Offset", Range(0,2)) = 0.25
		[Space(3)]
		[Toggle(_EMISSION)] _EnableLeafTurbulence("Enable Leaf Turbulence", Float) = 0.0
		_LeafTurbulence("Leaf Turbulence", Range(0,4)) = 0.2
		_EdgeFlutterInfluence("Edge Flutter Influence", Range(0,1)) = 0.25
		[Space(5)]
		[Toggle(_METALLICGLOSSMAP)] _LODTerrain ("Use Wind for LODGroups on Terrain", Float) = 0.0
		[Space(10)]

		[Header(Options for lowest LOD)]
		[Space(3)]
	//	[Toggle] _FadeOutAllLeaves("Fade out all Leaf Planes", Float) = 0.0
		[Toggle] _FadeOutWind("Fade out Wind", Float) = 0.0

		[Space(10)]
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Cutoff ("Cutoff", Range (0.0, 1)) = 0

	}
	SubShader {
		Tags { "RenderType"="CTI-TreeLeafLOD"}
		LOD 200
		Cull Off
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:CTI_TreeVertLeaf nolightmap alphatest:_Cutoff addshadow dithercrossfade
		#pragma target 3.0
		// #pragma multi_compile  LOD_FADE_CROSSFADE LOD_FADE_PERCENTAGE
	//	2018.2 and above:
		#pragma multi_compile_vertex LOD_FADE_PERCENTAGE

		#pragma shader_feature _METALLICGLOSSMAP
		#pragma shader_feature _EMISSION

		#define USE_VFACE
		#define DEBUG
		#define LEAFTUMBLING
		#define IS_LODTREE
		
		// We use Speed Tree keywords here to safe overall number of used ones
		// disable main bending
		#pragma shader_feature ENABLE_WIND
		// disable branch bending
		#pragma shader_feature EFFECT_BUMP
		// disable leaf tumbling
		#pragma shader_feature EFFECT_HUE_VARIATION

		// #include "UnityBuiltin3xTreeLibrary.cginc" // We can not do this as we want instancing
		#include "Includes/CTI_Builtin4xTreeLibraryTumbling.cginc"

		sampler2D _MainTex;
		float _DebugMode;
		float _DebugBending;
		float _ColorMultiplier;
		float _ColorContrast;


		void surf (Input IN, inout SurfaceOutput o) {

			#if UNITY_VERSION < 2017
    			UNITY_APPLY_DITHER_CROSSFADE(IN)
   			#endif

			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

			IN.color.rgba *= _ColorMultiplier;
			IN.my_uv2 *= _ColorMultiplier;

			IN.color.rgba = pow(IN.color.rgba, _ColorContrast);
			IN.my_uv2 = pow(IN.my_uv2, _ColorContrast);

			o.Albedo = 0;
			
			if (_DebugMode == 0) {
				o.Emission = IN.color.rgb;
			}
			if (_DebugMode == 1) {
				o.Emission = half3(IN.color.r, 0, 0);
			}
			if (_DebugMode == 2) {
				o.Emission = half3(0, IN.color.g, 0);
			}
			if (_DebugMode == 3) {
				//o.Emission = half3(0, 0, frac(IN.color.b * 2)) * _ColorMultiplier; //moved to vertex shader
				o.Emission = half3(0, 0, IN.color.b);
			}
			if (_DebugMode == 4) {
				o.Emission = half3(IN.color.a, IN.color.a, IN.color.a);
			}
			if (_DebugBending == 1) {
				o.Emission = half3(IN.my_uv2.x, IN.my_uv2.x, IN.my_uv2.x);
			}
			if (_DebugBending == 2) {
				o.Emission = half3(IN.my_uv2.y, IN.my_uv2.y, IN.my_uv2.y);
			}
			if (_DebugBending == 3) {
				//o.Albedo = (IN.my_uv3.z, IN.my_uv3.z, IN.my_uv3.z);
				float3 branchAxis1;
				branchAxis1 = frac(IN.my_uv3.xyz * float3(1.0, 256.0f, 65536.0f) );
				o.Emission = branchAxis1;
			}
			
			o.Specular = 0;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
