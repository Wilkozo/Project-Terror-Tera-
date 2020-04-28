Shader "CTI/Tree Creator Bark Optimized Tumbling" {
Properties {
	
	_Color ("Main Color", Color) = (1,1,1,1)
	
	[Space(5)]
	_MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
	[NoScaleOffset] _BumpSpecMap ("Normalmap (GA) Spec (R)", 2D) = "bump" {}
	[NoScaleOffset] _TranslucencyMap ("Trans (RGB) Gloss(A)", 2D) = "black" {}
	
	[Space(5)]
	_SpecColor ("Specular Color", Color) = (0.2, 0.2, 0.2, 1)
	// These are here only to provide default values
	[HideInInspector] _TreeInstanceColor ("TreeInstanceColor", Vector) = (1,1,1,1)
	[HideInInspector] _TreeInstanceScale ("TreeInstanceScale", Vector) = (1,1,1,1)
	[HideInInspector] _SquashAmount ("Squash", Float) = 1
}

SubShader { 
	Tags { "RenderType"="CTI-TreeBark" }
	LOD 200

// noshadowmask does not fix the problem with baked shadows in deferred
// removing nolightmap does		
	CGPROGRAM
		#pragma surface surf BlinnPhong vertex:CTI_TreeVertBark keepalpha
// nolightmap 
		#pragma target 3.0
		// #include "UnityBuiltin3xTreeLibrary.cginc" // We can not do this as we want instancing
		// We do NOT define LEAFTUMBLING here
		#define IS_BARK
		#include "Includes/CTI_Builtin4xTreeLibraryTumbling.cginc"

		sampler2D _MainTex;
		sampler2D _BumpSpecMap;
		sampler2D _TranslucencyMap;
		fixed4 _Color;

		// moved to include
		//	struct Input {
		//		float2 uv_MainTex;
		//		fixed4 color : COLOR;
		//	};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb * IN.color.a * IN.color.rgb; 
			
			fixed4 trngls = tex2D (_TranslucencyMap, IN.uv_MainTex);
			o.Gloss = trngls.a * _Color.r;
			o.Alpha = c.a;
			half4 norspc = tex2D (_BumpSpecMap, IN.uv_MainTex);
			o.Specular = norspc.r;
			o.Normal = UnpackNormalDXT5nm(norspc);

//o.Specular = trngls.a * _Color.r;

		}
	ENDCG

//	Pass to render object as a shadow caster
	Pass{
		Name "ShadowCaster"
		Tags{ "LightMode" = "ShadowCaster" }

	CGPROGRAM
		#pragma vertex vert_surf
		#pragma fragment frag_surf
		#pragma target 3.0
		#pragma multi_compile_shadowcaster
		#include "HLSLSupport.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		#define UNITY_PASS_SHADOWCASTER
		// #include "UnityBuiltin3xTreeLibrary.cginc" // We can not do this as we want instancing
		#define IS_BARK
		#define DEPTH_NORMAL
		#include "Includes/CTI_Builtin4xTreeLibraryTumbling.cginc"

		//  Already defined in include
		//	struct Input {
		//		float2 uv_MainTex;
		//	};

		struct v2f_surf {
			V2F_SHADOW_CASTER;
		};

		v2f_surf vert_surf(appdata_ctitree v) {
			v2f_surf o;
			CTI_TreeVertBark(v);
			TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
			return o;
		}

		float4 frag_surf(v2f_surf IN) : SV_Target{
			SHADOW_CASTER_FRAGMENT(IN)
		}
	ENDCG
	}
///
}

Dependency "BillboardShader" = "Hidden/Nature/Tree Creator Bark Rendertex"
}
