Shader "NatureManufacture Shaders/Lava/Standard Specular Lava CutOut"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_CutOutMaskA("CutOut Mask (A)", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo_Sm", 2D) = "white" {}
		_SmoothnessPower("Smoothness Power", Range( 0 , 2)) = 1
		[NoScaleOffset]_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 2)) = 1
		[NoScaleOffset]_SpecularRGBEmissionA("Specular (RGB) Emission (A)", 2D) = "white" {}
		_SpecularPower("Specular Power", Range( 0 , 2)) = 1
		_LavaEmissionColor("Lava Emission Color", Color) = (1,0.1862036,0,0)
		_LavaEmissionMaskIntensivity("Lava Emission Mask Intensivity", Range( 0 , 100)) = 0
		_LavaEmissionMaskTreshold("Lava Emission Mask Treshold", Range( 0.01 , 100)) = 0.01
		_LavaNoise("Lava Noise", 2D) = "white" {}
		_LavaNoisePower("Lava Noise Power", Range( 0 , 10)) = 2.71
		_LavaNoiseSpeed("Lava Noise Speed", Vector) = (-0.2,-0.5,0,0)
		_RimColor("Rim Color", Color) = (1,0,0,0)
		_RimLightPower("Rim Light Power", Range( 0 , 4)) = 4
		[NoScaleOffset]_AmbientOcclusionG("Ambient Occlusion (G)", 2D) = "white" {}
		_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 1)) = 1
		_DetailMask("DetailMask", 2D) = "white" {}
		_DetailAlbedoPower("Detail Albedo Power", Range( 0 , 2)) = 0
		_DetailMapAlbedoRNyGNxA("Detail Map Albedo(R) Ny(G) Nx(A)", 2D) = "black" {}
		_DetailNormalMapScale("DetailNormalMapScale", Range( 0 , 5)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		ZTest LEqual
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#include "NM_indirect.cginc"
		#pragma multi_compile GPU_FRUSTUM_ON __
		#pragma instancing_options procedural:setup
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			half2 uv_texcoord;
			float4 vertexColor : COLOR;
			float3 viewDir;
			INTERNAL_DATA
		};

		uniform half _BumpScale;
		uniform sampler2D _BumpMap;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _DetailMapAlbedoRNyGNxA;
		uniform float4 _DetailMapAlbedoRNyGNxA_ST;
		uniform sampler2D _DetailMask;
		uniform half4 _DetailMask_ST;
		uniform half4 _Color;
		uniform half _DetailAlbedoPower;
		uniform half _DetailNormalMapScale;
		uniform half _LavaEmissionMaskIntensivity;
		uniform sampler2D _SpecularRGBEmissionA;
		uniform half _LavaEmissionMaskTreshold;
		uniform half _RimLightPower;
		uniform half4 _RimColor;
		uniform half4 _LavaEmissionColor;
		uniform sampler2D _LavaNoise;
		uniform half2 _LavaNoiseSpeed;
		uniform float4 _LavaNoise_ST;
		uniform half _LavaNoisePower;
		uniform half _SpecularPower;
		uniform half _SmoothnessPower;
		uniform sampler2D _AmbientOcclusionG;
		uniform half _AmbientOcclusionPower;
		uniform sampler2D _CutOutMaskA;
		uniform half4 _CutOutMaskA_ST;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			half3 tex2DNode4 = UnpackScaleNormal( tex2D( _BumpMap, uv0_MainTex ), _BumpScale );
			float2 uv0_DetailMapAlbedoRNyGNxA = i.uv_texcoord * _DetailMapAlbedoRNyGNxA_ST.xy + _DetailMapAlbedoRNyGNxA_ST.zw;
			half4 tex2DNode205 = tex2D( _DetailMapAlbedoRNyGNxA, uv0_DetailMapAlbedoRNyGNxA );
			half3 temp_cast_0 = (tex2DNode205.r).xxx;
			float3 normalizeResult202 = normalize( BlendNormals( tex2DNode4 , temp_cast_0 ) );
			float2 uv_DetailMask = i.uv_texcoord * _DetailMask_ST.xy + _DetailMask_ST.zw;
			half4 tex2DNode195 = tex2D( _DetailMask, uv_DetailMask );
			float3 lerpResult193 = lerp( tex2DNode4 , normalizeResult202 , tex2DNode195.a);
			o.Normal = lerpResult193;
			half4 tex2DNode1 = tex2D( _MainTex, uv0_MainTex );
			float4 temp_output_44_0 = ( tex2DNode1 * _Color );
			float2 appendResult11_g1 = (half2(tex2DNode205.a , tex2DNode205.g));
			float2 temp_output_4_0_g1 = ( ( ( appendResult11_g1 * float2( 2,2 ) ) + float2( -1,-1 ) ) * _DetailNormalMapScale );
			float2 break8_g1 = temp_output_4_0_g1;
			float dotResult5_g1 = dot( temp_output_4_0_g1 , temp_output_4_0_g1 );
			float temp_output_9_0_g1 = sqrt( ( 1.0 - saturate( dotResult5_g1 ) ) );
			float3 appendResult10_g1 = (half3(break8_g1.x , break8_g1.y , temp_output_9_0_g1));
			half4 blendOpSrc189 = temp_output_44_0;
			half4 blendOpDest189 = half4( ( _DetailAlbedoPower * appendResult10_g1 ) , 0.0 );
			float4 lerpResult192 = lerp( temp_output_44_0 , (( blendOpDest189 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest189 - 0.5 ) ) * ( 1.0 - blendOpSrc189 ) ) : ( 2.0 * blendOpDest189 * blendOpSrc189 ) ) , ( _DetailAlbedoPower * tex2DNode195.a ));
			o.Albedo = lerpResult192.rgb;
			half4 tex2DNode29 = tex2D( _SpecularRGBEmissionA, uv0_MainTex );
			float lerpResult263 = lerp( 0.0 , tex2DNode29.a , ( 1.0 - ( i.vertexColor / float4( 1,1,1,1 ) ).r ));
			float temp_output_266_0 = pow( ( _LavaEmissionMaskIntensivity * lerpResult263 ) , _LavaEmissionMaskTreshold );
			float3 normalizeResult254 = normalize( i.viewDir );
			float dotResult255 = dot( lerpResult193 , normalizeResult254 );
			float4 temp_output_252_0 = ( temp_output_266_0 * ( _RimLightPower * ( pow( ( 1.0 - saturate( dotResult255 ) ) , 10.0 ) * _RimColor ) ) );
			float4 clampResult269 = clamp( temp_output_252_0 , float4( 0,0,0,0 ) , temp_output_252_0 );
			float2 uv0_LavaNoise = i.uv_texcoord * _LavaNoise_ST.xy + _LavaNoise_ST.zw;
			float2 panner233 = ( _SinTime.x * ( _LavaNoiseSpeed * float2( -1.2,-0.9 ) ) + uv0_LavaNoise);
			float2 panner235 = ( _SinTime.x * _LavaNoiseSpeed + uv0_LavaNoise);
			float clampResult243 = clamp( ( pow( min( tex2D( _LavaNoise, ( panner233 + float2( 0.5,0.5 ) ) ).r , tex2D( _LavaNoise, panner235 ).r ) , _LavaNoisePower ) * 20.0 ) , 0.05 , 1.2 );
			float4 temp_output_245_0 = ( ( temp_output_266_0 * _LavaEmissionColor ) * clampResult243 );
			float4 clampResult268 = clamp( temp_output_245_0 , float4( 0,0,0,0 ) , temp_output_245_0 );
			o.Emission = ( clampResult269 + clampResult268 ).rgb;
			o.Specular = ( tex2DNode29 * _SpecularPower ).rgb;
			o.Smoothness = ( tex2DNode1.a * _SmoothnessPower );
			float clampResult67 = clamp( tex2D( _AmbientOcclusionG, uv0_MainTex ).g , ( 1.0 - _AmbientOcclusionPower ) , 1.0 );
			o.Occlusion = clampResult67;
			o.Alpha = 1;
			float2 uv_CutOutMaskA = i.uv_texcoord * _CutOutMaskA_ST.xy + _CutOutMaskA_ST.zw;
			clip( tex2D( _CutOutMaskA, uv_CutOutMaskA ).a - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows dithercrossfade 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}