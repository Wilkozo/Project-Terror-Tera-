Shader "CTI/LOD Leaves" {
Properties {
	
	[Space(5)]
	[Enum(UnityEngine.Rendering.CullMode)] _Culling ("Culling", Float) = 0
	
	[Space(5)]
	_HueVariation						("Color Variation", Color) = (0.9,0.5,0.0,0.1)
	[Space(5)]
	_MainTex 							("Albedo (RGB) Alpha (A)", 2D) = "white" {}
	_Cutoff 							("Alpha Cutoff", Range(0,1)) = 0.3
	
	[Space(5)]
	[NoScaleOffset] _BumpSpecMap 		("Normal Map (GA) Specular (B)", 2D) = "bump" {}
	[NoScaleOffset] _TranslucencyMap 	("Snow Mask (R) AO (G) Translucency (B) Smoothness (A)", 2D) = "white" {}

	[Space(5)]
	_TranslucencyStrength				("Translucency Strength", Range(0,1)) = 0.5
	_ViewDependency						("View Dependency", Range(0,1)) = 0.8
	[Toggle(_PARALLAXMAP)] _EnableTransFade("Fade out Translucency", Float) = 0.0

	[Header(Wind)]
	[Space(3)]
	_TumbleStrength						("Tumble Strength", Range(-1,1)) = 0
	_TumbleFrequency					("Tumble Frequency", Range(0,4)) = 1
	_TimeOffset							("Time Offset", Range(0,2)) = 0.25
	[Space(3)]
	[Toggle(_EMISSION)] _EnableLeafTurbulence("Enable Leaf Turbulence", Float) = 0.0
	_LeafTurbulence 					("Leaf Turbulence", Range(0,4)) = 0.2
	_EdgeFlutterInfluence				("Edge Flutter Influence", Range(0,1)) = 0.25
	[Space(5)]
	[Toggle(_METALLICGLOSSMAP)] _LODTerrain ("Use Wind from Script", Float) = 0.0
	[Space(10)]

	[Header(Animate Normals)]
	[Space(3)]
	[Toggle(_NORMALMAP)] _AnimateNormal	("Enable Normal Rotation", Float) = 0.0
	[Space(10)]

	[Header(Options for lowest LOD)]
	[Space(3)]
	[Toggle] _FadeOutWind				("Fade out Wind", Float) = 0.0

	[Header(Snow)]
	_SnowMultiplier("Multiplier", Float) = 1.75
	_Snow("Sharpness", Range(1,10)) = 5
	_NormalInfluence("Normal Influence", Range(0,1)) = 0.3
	
	[Header(Wetness)]
	_WetnessMaxSmoothness ("Wet Smoothness", Range(0.0,0.96)) = 0.8
	//_Drops("drops", 2D) = "bump" {}
	//_DropScale("Tiling", Vector) = (1,1,0,0)

}

SubShader { 
	Tags {

"Queue"="Geometry"		
		"IgnoreProjector"="True"
		"RenderType"="CTI-TreeLeafLOD"
		"DisableBatching" = "LODFading"
	}
	LOD 200
	Cull [_Culling]

	CGPROGRAM

// noshadowmask does not fix the problem with baked shadows in deferred
// removing nolightmap does	
		#pragma surface surf StandardTranslucent vertex:CTI_TreeVertLeaf fullforwardshadows dithercrossfade
// nolightmap
		#pragma target 3.0
		
		// #pragma multi_compile  LOD_FADE_CROSSFADE LOD_FADE_PERCENTAGE
	//	2018.2 and above:
		#pragma multi_compile_vertex LOD_FADE_PERCENTAGE

		#pragma shader_feature _METALLICGLOSSMAP
		#pragma shader_feature _EMISSION
		#pragma shader_feature _NORMALMAP
		#pragma shader_feature _PARALLAXMAP
		#pragma multi_compile_instancing

	//	#if UNITY_VERSION >= 550
			#pragma instancing_options assumeuniformscaling lodfade procedural:setup 	 
	//	#endif

		// #include "UnityBuiltin3xTreeLibrary.cginc" // We can not do this as we want instancing
		#define USE_VFACE
		#define LEAFTUMBLING
		#define IS_LODTREE
		#define IS_SURFACESHADER
		
		#include "Includes/CTI_TranslucentLighting.cginc"
		#include "Includes/CTI_Builtin4xTreeLibraryTumbling.cginc"
		#include "Includes/CTI_indirect.cginc"		

		sampler2D _MainTex;
		sampler2D _BumpSpecMap;
		sampler2D _TranslucencyMap;
		half _TranslucencyStrength;
		half _ViewDependency;
		half _Cutoff;

	//	Snow
		half _SnowMultiplier;
		half _Snow;
		half _NormalInfluence;
	//	Wetness
		half _WetnessMaxSmoothness;

	//	sampler2D _Drops;
	//	float2 _DropScale;
	//	sampler2D _Lux_RainRipplesRT;
	//	half _Lux_RippleTiling;

		void surf (Input IN, inout SurfaceOutputStandardTranslucent o) {

			#if UNITY_VERSION < 2017
    			UNITY_APPLY_DITHER_CROSSFADE(IN)
   			#endif

			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			clip (c.a - _Cutoff);
			o.Alpha = c.a;
			
		//	Add Color Variation
			o.Albedo = lerp(c.rgb, (c.rgb + _HueVariation.rgb) * 0.5, IN.color.r * _HueVariation.a);
			fixed4 trngls = tex2D (_TranslucencyMap, IN.uv_MainTex);
			
			o.Translucency = trngls.b * _TranslucencyStrength
		//	Fade out translucency	
			#if defined(_PARALLAXMAP)
				* IN.color.b
			#endif
			;

			o.ScatteringPower = _ViewDependency;
		//	Fade out smoothness
			o.Smoothness = trngls.a
			#if defined(_PARALLAXMAP)
				* IN.color.b
			#endif
			;

			o.Occlusion = trngls.g; // * IN.color.a;
				
			half4 norspc = tex2D (_BumpSpecMap, IN.uv_MainTex);
			o.Specular = norspc.b;
			o.Normal = UnpackNormalDXT5nm(norspc) * float3(1,1,IN.FacingSign);


			fixed3 wNormal = WorldNormalVector(IN, o.Normal);
			//saturate(1.0 - lux.worldNormal.y - baseSnowAmount * 0.25)
			//o.Albedo = lerp(half3(1,1,1), o.Albedo, 1.0 - wNormal.y);
			//half snow = pow( saturate(wNormal.y) * trngls.r, 4);

			UNITY_BRANCH
			if (_Lux_SnowAmount > 0.0) {
				half2 normalInfluence = lerp(half2(1,1), half2(wNormal.y, -wNormal.y) /* saturate(wNormal.y + 1) */, _NormalInfluence.xx);
				half baseSnowAmount = saturate(_Lux_SnowAmount * _SnowMultiplier /* 1.75 */ ) * IN.color.a;
				half2 snow = saturate(baseSnowAmount.xx - saturate(half2(1,1) - normalInfluence - baseSnowAmount.xx * 0.25));
				//snow *= trngls.r;
				//BlendValue = saturate ( (CrrentBlendStrength - ( 1.0 - Mask)) / _Sharpness );
				snow = saturate( (snow - trngls.rr) * _Snow.xx ); // / 20 );
			//  Sharpen snow
				//snow = saturate(snow * 1.0 * (2.0 - _Lux_SnowAmount));
				//snow = smoothstep(0.5, 1, snow);
				o.Albedo = lerp( o.Albedo, _Lux_SnowColor.xyz, snow.xxx);
			//	We need snow on backfaces!
				o.Translucency = lerp(o.Translucency, o.Translucency * 0.2, saturate(snow.x + snow.y) );
				o.Specular = lerp(o.Specular, _Lux_SnowSpecColor.rgb, snow.xxx);
				o.Smoothness = lerp(o.Smoothness, _Lux_SnowSpecColor.a, snow.x);
				// Smooth normals a bit
				o.Normal = lerp(o.Normal, half3(0, 0, 1), snow.xxx * 0.5);
				o.Occlusion = lerp(o.Occlusion, 1.0, snow.x);
			}

		//	Keep large scale occlusion - even if there is snow on top
			o.Occlusion *= IN.color.a;

		//	Wetness
			UNITY_BRANCH
			if (_Lux_WaterFloodlevel.x > 0.0) {
				half Rainamount = _Lux_WaterFloodlevel.x * saturate(wNormal.y + IN.color.g);
				Rainamount = smoothstep(.1, 1.0, Rainamount);
				float porosity = saturate(((1.0 - o.Smoothness) - 0.5) / 0.4);
				// Calc diffuse factor
				float factor = lerp(1.0, 0.2, porosity);
				// Water influence on material BRDF
				o.Albedo *= lerp(1.0, factor, Rainamount); // Attenuate diffuse
				o.Smoothness = lerp(o.Smoothness, _WetnessMaxSmoothness, Rainamount);
				// Lerp specular Color towards IOR of Water
				o.Specular = lerp(o.Specular, unity_ColorSpaceDielectricSpec.rgb * 0.5, Rainamount);
				// Smooth normals a bit
				o.Normal = lerp(o.Normal, half3(0, 0, 1), Rainamount * Rainamount * 0.5);

				//dx *= _Lux_RippleTiling;
				//dy *= _Lux_RippleTiling;
				//float2 rippleOffset = max(lux.offsetInWS, lerp(lux.offsetWaterInWS, 0, lux.waterAmount.x));
				//half3 rippleNormal = UnpackNormalDXT5nm(tex2Dgrad(_Lux_RainRipplesRT, (lux.worldPos.xz + rippleOffset) * _Lux_RippleTiling, dx, dy).gggr);

				//half3 rippleNormal = UnpackNormalDXT5nm(tex2D(_Lux_RainRipplesRT, (IN.worldPos.xz) * _Lux_RippleTiling).gggr);
				//half3 rippleNormal = UnpackNormalDXT5nm(tex2D(_Lux_RainRipplesRT, (IN.uv_MainTex)).gggr);

				// Blend and fade out Ripples
				//return lerp(half3(0, 0, 1), rippleNormal, lux.waterAmount.y * saturate(lux.worldNormalFace.y));
				

			//	Calculate Ripples
			//	Ripples just look odd - so we skip this
			/*	fixed4 Ripple = tex2D (_Drops, IN.uv_MainTex * _DropScale);
				half Intensity = Ripple.a;

				float rippleSpeed = 1.0 + Ripple.a * 0.25; //( 1 + ( 1 + (Ripple.b * 0.25 - 0.25)));
				float DropFrac = ( Ripple.b + _Time.y * 0.4); //_FrontShield_RainTime * (_RealRainSpeed) ); // Apply time shift
				// We need negative values here to create a little pause at the end of the loop --> (* _RainLoopDelay)
				DropFrac = 1.0 - ( sin( frac(DropFrac * rippleSpeed * UNITY_PI * 0.5)) * (3 ) ) ; // changing 3 = _RainLoopDelay makes loop more visible
				float FinalFactor = saturate(DropFrac);

				FinalFactor *= saturate( saturate(_Lux_RainfallRainSnowIntensity.y * 2) - Intensity);

				half3 refractNormalRain = UnpackNormalDXT5nm(Ripple.rrrg);     //normalize( half3( (Ripple.rg * 2.0 - 1.0) * FinalFactor * 0.5, 1.0f) ) ;
				refractNormalRain = lerp(o.Normal, refractNormalRain, FinalFactor);
				o.Normal = lerp(o.Normal, refractNormalRain, Rainamount * saturate(wNormal.y) );
			*/
			}
		}
	ENDCG

	// Pass to render object as a shadow caster
	// Do not forget to setup the instance ID!
	Pass {
		Name "ShadowCaster"
		Tags { 
			"LightMode" = "ShadowCaster"
		}
		
		CGPROGRAM
		#pragma vertex vert_surf
		#pragma fragment frag_surf
		#pragma target 3.0
		
		// #pragma multi_compile  LOD_FADE_PERCENTAGE LOD_FADE_CROSSFADE
	//	2018.2 and above:
		#pragma multi_compile_vertex LOD_FADE_PERCENTAGE
		#pragma multi_compile_fragment __ LOD_FADE_CROSSFADE
		
		#pragma multi_compile_instancing
		//#if UNITY_VERSION >= 550
			#pragma instancing_options assumeuniformscaling lodfade procedural:setup
		//#endif
		#pragma shader_feature _METALLICGLOSSMAP
		#pragma shader_feature _EMISSION
		#pragma multi_compile_shadowcaster
		
		#include "HLSLSupport.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		#define UNITY_PASS_SHADOWCASTER
		// #include "UnityBuiltin3xTreeLibrary.cginc" // We can not do this as we want instancing
		#define USE_VFACE
		#define LEAFTUMBLING
		#define DEPTH_NORMAL
		#define IS_LODTREE
		#include "Includes/CTI_Builtin4xTreeLibraryTumbling.cginc"
		#include "Includes/CTI_indirect.cginc"		

		sampler2D _MainTex;

	//  Already defined in include
	//	struct Input {
	//		float2 uv_MainTex;
	//	};

		struct v2f_surf {
			V2F_SHADOW_CASTER;
			float2 hip_pack0 : TEXCOORD1;
			UNITY_DITHER_CROSSFADE_COORDS_IDX(2)
			UNITY_VERTEX_INPUT_INSTANCE_ID
			UNITY_VERTEX_OUTPUT_STEREO
		};

		float4 _MainTex_ST;
		
		v2f_surf vert_surf (appdata_ctitree v) {
			v2f_surf o;
			UNITY_SETUP_INSTANCE_ID(v);
			UNITY_TRANSFER_INSTANCE_ID(v, o);
			UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
			CTI_TreeVertLeaf(v);
			o.hip_pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
			TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
			UNITY_TRANSFER_DITHER_CROSSFADE_HPOS(o, o.pos)
			return o;
		}
		fixed _Cutoff;
		
		float4 frag_surf (v2f_surf IN) : SV_Target {
			UNITY_SETUP_INSTANCE_ID(IN);
			#if UNITY_VERSION < 2017
				UNITY_APPLY_DITHER_CROSSFADE(IN)
			#else
				UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
			#endif
			half alpha = tex2D(_MainTex, IN.hip_pack0.xy).a;
			clip (alpha - _Cutoff);
			SHADOW_CASTER_FRAGMENT(IN)
		}
		ENDCG
	}


///
}

CustomEditor "CTI_ShaderGUI"

}
