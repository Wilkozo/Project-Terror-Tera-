Shader "CTI/Tree Creator Leaves Optimized Tumbling" {
	Properties{

		[Space(6)]
		[Enum(UnityEngine.Rendering.CullMode)] _Culling ("Culling", Float) = 2

		_Color("Main Color", Color) = (1,1,1,1)

		[Space(5)]
		_MainTex("Base (RGB) Alpha (A)", 2D) = "white" {}
		_Cutoff("Alpha cutoff", Range(0,1)) = 0.3
		[Space(5)]
		[NoScaleOffset] _BumpSpecMap("Normalmap (GA) Spec (R)", 2D) = "bump" {}
		[NoScaleOffset] _TranslucencyMap("Trans (B) Gloss(A)", 2D) = "white" {}

		[Space(5)]
		_TranslucencyColor("Translucency Color", Color) = (0.73,0.85,0.41,1) // (187,219,106,255)
		_TranslucencyViewDependency("View dependency", Range(0,1)) = 0.7
		_ShadowStrength("Shadow Strength", Range(0,1)) = 0.8

		[Header(Wind)]
		[Space(3)]
		_TumbleStrength("Tumble Strength", Range(-1,1)) = 0.0
		_TumbleFrequency("Tumble Frequency", Range(0,4)) = 1
		_TimeOffset("Time Offset", Range(0,2)) = 0.25
		[Space(5)]
		[Toggle(_DETAIL_MULX2)] _EnableLeafTurbulence("Enable Leaf Turbulence", Float) = 0.0
		_LeafTurbulence("Leaf Turbulence", Range(0,4)) = 0.2
		_EdgeFlutterInfluence("Edge Flutter Influence", Range(0,1)) = 0.25

		[Header(Animate Normals)]
		[Space(3)]
		[Toggle(_NORMALMAP)] _AnimateNormal("Enable Normal Rotation", Float) = 0.0
		[Space(10)]

		// These are here only to provide default values
		[HideInInspector] _TreeInstanceColor("TreeInstanceColor", Vector) = (1,1,1,1)
		[HideInInspector] _TreeInstanceScale("TreeInstanceScale", Vector) = (1,1,1,1)
		[HideInInspector] _SquashAmount("Squash", Float) = 1
	}

		SubShader{
			Tags{
			"IgnoreProjector" = "True"
			"RenderType" = "CTI-TreeLeaf"
			}
			LOD 200
			Cull [_Culling]

		CGPROGRAM
			#pragma surface surf TreeLeaf alphatest:_Cutoff vertex:CTI_TreeVertLeaf nolightmap noforwardadd keepalpha
			#pragma target 3.0
			#pragma shader_feature _DETAIL_MULX2
			#pragma shader_feature _NORMALMAP
			// #include "UnityBuiltin3xTreeLibrary.cginc" // We can not do this as we want instancing
			#define LEAFTUMBLING
			#include "Includes/CTI_Builtin4xTreeLibraryTumbling.cginc"

			sampler2D _MainTex;
			sampler2D _BumpSpecMap;
			sampler2D _TranslucencyMap;
			fixed4 _Color;

			// moved to include
			//struct Input {
			//	float2 uv_MainTex;
			//	fixed4 color : COLOR; // color.a = AO
			//};

			void surf(Input IN, inout LeafSurfaceOutput o) {
				fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
				o.Alpha = c.a;
				o.Albedo = c.rgb * IN.color.rgb * IN.color.a;
				fixed4 trngls = tex2D(_TranslucencyMap, IN.uv_MainTex);
				o.Translucency = trngls.b;
				o.Gloss = trngls.a * _Color.r;
				half4 norspc = tex2D(_BumpSpecMap, IN.uv_MainTex);
				o.Specular = norspc.r;
				o.Normal = UnpackNormalDXT5nm(norspc);
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
				#pragma shader_feature _DETAIL_MULX2
				#pragma multi_compile_shadowcaster
				#include "HLSLSupport.cginc"
				#include "UnityCG.cginc"
				#include "Lighting.cginc"

				#define UNITY_PASS_SHADOWCASTER
				// #include "UnityBuiltin3xTreeLibrary.cginc" // We can not do this as we want instancing
				#define DEPTH_NORMAL
				#define LEAFTUMBLING
				#include "Includes/CTI_Builtin4xTreeLibraryTumbling.cginc"

				sampler2D _MainTex;

				//  Already defined in include
				//	struct Input {
				//		float2 uv_MainTex;
				//	};

				struct v2f_surf {
					V2F_SHADOW_CASTER;
					float2 hip_pack0 : TEXCOORD1;
				};

				float4 _MainTex_ST;

				v2f_surf vert_surf(appdata_ctitree v) {
					v2f_surf o;
					CTI_TreeVertLeaf(v);
					o.hip_pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
						return o;
				}
				fixed _Cutoff;

				float4 frag_surf(v2f_surf IN) : SV_Target{
					half alpha = tex2D(_MainTex, IN.hip_pack0.xy).a;
				clip(alpha - _Cutoff);
				SHADOW_CASTER_FRAGMENT(IN)
				}
			ENDCG
		}
		///
	}
Dependency "BillboardShader" = "Hidden/Nature/Tree Creator Leaves Rendertex"
}
