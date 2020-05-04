Shader "NatureManufacture Shaders/Lava/Lava River Tesseled Vertex Color Flowmap Cheap"
{
	Properties
	{
		_RimLightPower("Rim Light Power", Range( 0 , 4)) = 4
		_RimColor("Rim Color", Color) = (1,0,0,0)
		_UVVDirection1UDirection0("UV - V Direction (1) U Direction (0)", Int) = 0
		_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_ColdLavaAlbedo_SM("Cold Lava Albedo_SM", 2D) = "bump" {}
		_ColdLavaAlbedoColor("Cold Lava Albedo Color", Color) = (1,1,1,0)
		_ColdLavaAlbedoColorMultiply("Cold Lava Albedo Color Multiply ", Float) = 1
		_ColdLavaMainSpeed("Cold Lava Main Speed", Vector) = (0.01,0,0,0)
		_ColdLavaSmoothness("Cold Lava Smoothness", Float) = 1
		_ColdLavaNormal("Cold Lava Normal", 2D) = "bump" {}
		_ColdLavaNormalScale("Cold Lava Normal Scale", Float) = 0
		_ColdLavaMT_AO_H_EM("Cold Lava MT_AO_H_EM", 2D) = "bump" {}
		_ColdLavaMetalic("Cold Lava Metalic", Range( 0 , 1)) = 1
		_ColdLavaAO("Cold Lava AO", Range( 0 , 1)) = 1
		_ColdLavaEmissionMaskTreshold("Cold Lava Emission Mask Treshold", Float) = 0
		_ColdLavaEmissionMaskIntensivity("Cold Lava Emission Mask Intensivity", Range( 0 , 100)) = 0
		_ColdLavaNoisePower("Cold Lava Noise Power", Range( 0 , 10)) = 2.71
		_ColdLavaTessScale("Cold Lava Tess Scale", Float) = 0
		_MediumLavaAngle("Medium Lava Angle", Range( 0.001 , 90)) = 90
		_MediumLavaAngleFalloff("Medium Lava Angle Falloff", Range( 0 , 80)) = 5
		_MediumLavaHeightBlendTreshold("Medium Lava Height Blend Treshold", Range( 0.1 , 10)) = 1
		_MediumLavaHeightBlendStrenght("Medium Lava Height Blend Strenght", Range( 0.1 , 10)) = 2
		_MediumLavaAlbedoColor("Medium Lava Albedo Color", Color) = (1,1,1,0)
		_MediumLavaAlbedoColorMultiply("Medium Lava Albedo Color Multiply ", Float) = 1
		_MediumLavaMainSpeed("Medium Lava Main Speed", Vector) = (0,0.08,0,0)
		_MediumLavaSmoothness("Medium Lava Smoothness", Float) = 0
		_MediumLavaNormalScale("Medium Lava Normal Scale", Float) = 0
		_MediumLavaMetallic("Medium Lava Metallic", Range( 0 , 1)) = 1
		_MediumLavaAO("Medium Lava AO", Range( 0 , 1)) = 1
		_MediumLavaEmissionMaskIntesivity("Medium Lava Emission Mask Intesivity", Range( 0 , 100)) = 0
		_MediumLavaEmissionMaskTreshold("Medium Lava Emission Mask Treshold", Float) = 0
		_MediumLavaNoisePower("Medium Lava Noise Power", Range( 0 , 10)) = 2.71
		_MediumLavaTessScale("Medium Lava Tess Scale", Float) = 0
		_HotLavaAngle("Hot Lava Angle", Range( 0.001 , 90)) = 90
		_HotLavaAngleFalloff("Hot Lava Angle Falloff", Range( 0 , 80)) = 15
		_HotLavaHeightBlendTreshold("Hot Lava Height Blend Treshold", Range( 0.1 , 10)) = 1
		_HotLavaHeightBlendStrenght("Hot Lava Height Blend Strenght", Range( 0.1 , 20)) = 2
		_HotLavaAlbedoColor("Hot Lava Albedo Color", Color) = (1,1,1,0)
		_HotLavaAlbedoColorMultiply("Hot Lava Albedo Color Multiply ", Float) = 1
		_HotLavaMainSpeed("Hot Lava Main Speed", Vector) = (0.02,0,0,0)
		_HotLavaSmoothness("Hot Lava Smoothness", Float) = 1
		_HotLavaNormalScale("Hot Lava Normal Scale", Float) = 0
		_HotLavaMetallic("Hot Lava Metallic", Range( 0 , 1)) = 1
		_HotLavaAO("Hot Lava AO", Range( 0 , 1)) = 1
		_HotLavaEmissionMaskIntensivity("Hot Lava Emission Mask Intensivity", Range( 0 , 100)) = 0
		_HotLavaEmissionMaskTreshold("Hot Lava Emission Mask Treshold", Float) = 0
		_HotLavaNoisePower("Hot Lava Noise Power", Range( 0 , 10)) = 2.71
		_HotLavaTessScale("Hot Lava Tess Scale", Float) = 0
		_Noise("Noise", 2D) = "white" {}
		_NoiseSpeed("Noise Speed", Vector) = (-0.2,-0.5,0,0)
		_VCColdLavaHeightBlendStrenght("VC Cold Lava Height Blend Strenght", Range( 2 , 10)) = 10
		_VCMediumLavaHeightBlendStrenght("VC Medium Lava Height Blend Strenght", Range( 2 , 10)) = 10
		_VCHotLavaHeightBlendStrenght("VC Hot Lava Height Blend Strenght", Range( 2 , 10)) = 10
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 29.6
		_TessMaxDisp( "Max Displacement", Float ) = 0
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord4( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
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
			half2 uv4_texcoord4;
			float3 worldNormal;
			INTERNAL_DATA
			float4 vertexColor : COLOR;
			float3 viewDir;
		};

		uniform half _ColdLavaMetalic;
		uniform sampler2D _ColdLavaMT_AO_H_EM;
		uniform sampler2D _ColdLavaAlbedo_SM;
		uniform float4 _ColdLavaAlbedo_SM_ST;
		uniform int _UVVDirection1UDirection0;
		uniform half2 _ColdLavaMainSpeed;
		uniform half _ColdLavaAO;
		uniform half _ColdLavaEmissionMaskIntensivity;
		uniform half _ColdLavaEmissionMaskTreshold;
		uniform half _ColdLavaTessScale;
		uniform half _MediumLavaMetallic;
		uniform half2 _MediumLavaMainSpeed;
		uniform half _MediumLavaAO;
		uniform half _MediumLavaEmissionMaskIntesivity;
		uniform half _MediumLavaEmissionMaskTreshold;
		uniform half _MediumLavaTessScale;
		uniform half _MediumLavaHeightBlendTreshold;
		uniform half _MediumLavaAngle;
		uniform half _MediumLavaAngleFalloff;
		uniform half _MediumLavaHeightBlendStrenght;
		uniform half _HotLavaMetallic;
		uniform half2 _HotLavaMainSpeed;
		uniform half _HotLavaAO;
		uniform half _HotLavaEmissionMaskIntensivity;
		uniform half _HotLavaEmissionMaskTreshold;
		uniform half _HotLavaTessScale;
		uniform half _HotLavaHeightBlendTreshold;
		uniform half _HotLavaAngle;
		uniform half _HotLavaAngleFalloff;
		uniform half _HotLavaHeightBlendStrenght;
		uniform half _VCColdLavaHeightBlendStrenght;
		uniform half _VCMediumLavaHeightBlendStrenght;
		uniform half _VCHotLavaHeightBlendStrenght;
		uniform half _ColdLavaNormalScale;
		uniform sampler2D _ColdLavaNormal;
		uniform half _MediumLavaNormalScale;
		uniform half _HotLavaNormalScale;
		uniform half4 _ColdLavaAlbedoColor;
		uniform half _ColdLavaAlbedoColorMultiply;
		uniform half _ColdLavaSmoothness;
		uniform half4 _MediumLavaAlbedoColor;
		uniform half _MediumLavaAlbedoColorMultiply;
		uniform half _MediumLavaSmoothness;
		uniform half4 _HotLavaAlbedoColor;
		uniform half _HotLavaAlbedoColorMultiply;
		uniform half _HotLavaSmoothness;
		uniform half _RimLightPower;
		uniform half4 _RimColor;
		uniform half4 _EmissionColor;
		uniform sampler2D _Noise;
		uniform half2 _NoiseSpeed;
		uniform float4 _Noise_ST;
		uniform half _ColdLavaNoisePower;
		uniform half _MediumLavaNoisePower;
		uniform half _HotLavaNoisePower;
		uniform half _EdgeLength;
		uniform half _TessMaxDisp;
		uniform half _TessPhongStrength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTessCull (v0.vertex, v1.vertex, v2.vertex, _EdgeLength , _TessMaxDisp );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv0_ColdLavaAlbedo_SM = v.texcoord.xy * _ColdLavaAlbedo_SM_ST.xy + _ColdLavaAlbedo_SM_ST.zw;
			int Direction723 = _UVVDirection1UDirection0;
			float2 appendResult705 = (half2(_ColdLavaMainSpeed.y , _ColdLavaMainSpeed.x));
			float2 WaterSpeedValueMain614 = (( (float)Direction723 == 1.0 ) ? _ColdLavaMainSpeed :  appendResult705 );
			float2 break1202 = WaterSpeedValueMain614;
			float2 appendResult1078 = (half2(( break1202.x * v.texcoord3.xy.x ) , ( break1202.y * v.texcoord3.xy.y )));
			float temp_output_1136_0 = ( _Time.y * 0.15 );
			float temp_output_1139_0 = frac( ( temp_output_1136_0 + 1.0 ) );
			float2 temp_output_1143_0 = ( uv0_ColdLavaAlbedo_SM + ( appendResult1078 * temp_output_1139_0 ) );
			float2 SlowFlowUV11195 = temp_output_1143_0;
			half4 tex2DNode851 = tex2Dlod( _ColdLavaMT_AO_H_EM, half4( SlowFlowUV11195, 0, 1.0) );
			float temp_output_1137_0 = frac( ( temp_output_1136_0 + 0.5 ) );
			float2 SlowFlowUV21196 = ( uv0_ColdLavaAlbedo_SM + ( appendResult1078 * temp_output_1137_0 ) );
			half4 tex2DNode856 = tex2Dlod( _ColdLavaMT_AO_H_EM, half4( SlowFlowUV21196, 0, 1.0) );
			float clampResult1193 = clamp( pow( abs( ( ( temp_output_1139_0 + -0.5 ) * 2.0 ) ) , ( tex2Dlod( _ColdLavaMT_AO_H_EM, half4( temp_output_1143_0, 0, 0.0) ).b * 7.0 ) ) , 0.0 , 1.0 );
			float SlowFlowHeightBase1197 = clampResult1193;
			float4 lerpResult1290 = lerp( tex2DNode851 , tex2DNode856 , SlowFlowHeightBase1197);
			float4 break879 = lerpResult1290;
			float clampResult883 = clamp( break879.g , ( 1.0 - _ColdLavaAO ) , 1.0 );
			float4 appendResult876 = (half4(( _ColdLavaMetalic * break879.r ) , clampResult883 , pow( ( _ColdLavaEmissionMaskIntensivity * break879.a ) , _ColdLavaEmissionMaskTreshold ) , ( break879.b * _ColdLavaTessScale )));
			float2 appendResult710 = (half2(_MediumLavaMainSpeed.y , _MediumLavaMainSpeed.x));
			float2 SmallCascadeSpeedValueMain600 = (( (float)Direction723 == 1.0 ) ? _MediumLavaMainSpeed :  appendResult710 );
			float2 break1204 = SmallCascadeSpeedValueMain600;
			float2 appendResult1208 = (half2(( break1204.x * v.texcoord3.xy.x ) , ( break1204.y * v.texcoord3.xy.y )));
			float2 temp_output_1213_0 = ( uv0_ColdLavaAlbedo_SM + ( appendResult1208 * temp_output_1139_0 ) );
			float2 MediumFlowUV11226 = temp_output_1213_0;
			half4 tex2DNode852 = tex2Dlod( _ColdLavaMT_AO_H_EM, half4( MediumFlowUV11226, 0, 1.0) );
			float2 MediumFlowUV21227 = ( uv0_ColdLavaAlbedo_SM + ( appendResult1208 * temp_output_1137_0 ) );
			half4 tex2DNode860 = tex2Dlod( _ColdLavaMT_AO_H_EM, half4( MediumFlowUV21227, 0, 1.0) );
			float clampResult1223 = clamp( pow( abs( ( ( temp_output_1139_0 + -0.5 ) * 2.0 ) ) , ( tex2Dlod( _ColdLavaMT_AO_H_EM, half4( temp_output_1213_0, 0, 0.0) ).b * 7.0 ) ) , 0.0 , 1.0 );
			float MediumFlowHeightBase1228 = clampResult1223;
			float4 lerpResult1291 = lerp( tex2DNode852 , tex2DNode860 , MediumFlowHeightBase1228);
			float4 break884 = lerpResult1291;
			float clampResult890 = clamp( break884.g , ( 1.0 - _MediumLavaAO ) , 1.0 );
			float temp_output_889_0 = ( break884.b * _MediumLavaTessScale );
			float4 appendResult892 = (half4(( _MediumLavaMetallic * break884.r ) , clampResult890 , pow( ( _MediumLavaEmissionMaskIntesivity * break884.a ) , _MediumLavaEmissionMaskTreshold ) , temp_output_889_0));
			float temp_output_932_0 = ( 1.0 - break879.b );
			half3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float clampResult259 = clamp( ase_worldNormal.y , 0.0 , 1.0 );
			float temp_output_258_0 = ( _MediumLavaAngle / 45.0 );
			float clampResult263 = clamp( ( clampResult259 - ( 1.0 - temp_output_258_0 ) ) , 0.0 , 2.0 );
			float clampResult584 = clamp( ( clampResult263 * ( 1.0 / temp_output_258_0 ) ) , 0.0 , 1.0 );
			float clampResult285 = clamp( pow( ( 1.0 - clampResult584 ) , _MediumLavaAngleFalloff ) , 0.0 , 1.0 );
			float HeightMask927 = saturate(pow(((pow( temp_output_932_0 , _MediumLavaHeightBlendTreshold )*clampResult285)*4)+(clampResult285*2),_MediumLavaHeightBlendStrenght));
			float4 lerpResult853 = lerp( appendResult876 , appendResult892 , HeightMask927);
			float2 appendResult712 = (half2(_HotLavaMainSpeed.y , _HotLavaMainSpeed.x));
			float2 BigCascadeSpeedMain608 = (( (float)Direction723 == 1.0 ) ? _HotLavaMainSpeed :  appendResult712 );
			float2 break1235 = BigCascadeSpeedMain608;
			float2 appendResult1238 = (half2(( break1235.x * v.texcoord3.xy.x ) , ( break1235.y * v.texcoord3.xy.y )));
			float2 temp_output_1243_0 = ( uv0_ColdLavaAlbedo_SM + ( appendResult1238 * temp_output_1139_0 ) );
			float2 HotFlowUV11257 = temp_output_1243_0;
			half4 tex2DNode861 = tex2Dlod( _ColdLavaMT_AO_H_EM, half4( HotFlowUV11257, 0, 1.0) );
			float2 HotFlowUV21258 = ( uv0_ColdLavaAlbedo_SM + ( appendResult1238 * temp_output_1137_0 ) );
			half4 tex2DNode854 = tex2Dlod( _ColdLavaMT_AO_H_EM, half4( HotFlowUV21258, 0, 1.0) );
			float clampResult1255 = clamp( pow( abs( ( ( temp_output_1139_0 + -0.5 ) * 2.0 ) ) , ( tex2Dlod( _ColdLavaMT_AO_H_EM, half4( temp_output_1243_0, 0, 0.0) ).b * 7.0 ) ) , 0.0 , 1.0 );
			float HotFlowHeightBase1259 = clampResult1255;
			float4 lerpResult1292 = lerp( tex2DNode861 , tex2DNode854 , HotFlowHeightBase1259);
			float4 break893 = lerpResult1292;
			float clampResult896 = clamp( break893.g , ( 1.0 - _HotLavaAO ) , 1.0 );
			float4 appendResult898 = (half4(( _HotLavaMetallic * break893.r ) , clampResult896 , pow( ( _HotLavaEmissionMaskIntensivity * break893.a ) , _HotLavaEmissionMaskTreshold ) , ( break893.b * _HotLavaTessScale )));
			float temp_output_942_0 = ( 1.0 - break884.b );
			float clampResult507 = clamp( ase_worldNormal.y , 0.0 , 1.0 );
			float temp_output_504_0 = ( _HotLavaAngle / 45.0 );
			float clampResult509 = clamp( ( clampResult507 - ( 1.0 - temp_output_504_0 ) ) , 0.0 , 2.0 );
			float clampResult583 = clamp( ( clampResult509 * ( 1.0 / temp_output_504_0 ) ) , 0.0 , 1.0 );
			float clampResult514 = clamp( pow( ( 1.0 - clampResult583 ) , _HotLavaAngleFalloff ) , 0.0 , 1.0 );
			float HeightMask943 = saturate(pow(((pow( temp_output_942_0 , _HotLavaHeightBlendTreshold )*clampResult514)*4)+(clampResult514*2),_HotLavaHeightBlendStrenght));
			float4 lerpResult855 = lerp( lerpResult853 , appendResult898 , HeightMask943);
			float4 break770 = ( v.color / float4( 1,1,1,1 ) );
			float HeightMask988 = saturate(pow(((temp_output_932_0*break770.r)*4)+(break770.r*2),_VCColdLavaHeightBlendStrenght));
			float temp_output_1002_0 = ( break770.r * HeightMask988 );
			float4 lerpResult902 = lerp( lerpResult855 , appendResult876 , temp_output_1002_0);
			float HeightMask992 = saturate(pow(((temp_output_942_0*break770.g)*4)+(break770.g*2),_VCMediumLavaHeightBlendStrenght));
			float temp_output_1001_0 = ( break770.g * HeightMask992 );
			float4 lerpResult903 = lerp( lerpResult902 , appendResult892 , temp_output_1001_0);
			float HeightMask998 = saturate(pow(((( 1.0 - break893.b )*break770.b)*4)+(break770.b*2),_VCHotLavaHeightBlendStrenght));
			float temp_output_1000_0 = ( break770.b * HeightMask998 );
			float4 lerpResult904 = lerp( lerpResult903 , appendResult898 , temp_output_1000_0);
			float4 break967 = appendResult876;
			float4 appendResult965 = (half4(break967.x , break967.y , 0.0 , break967.w));
			float temp_output_968_0 = ( 1.0 - break770.a );
			float4 lerpResult964 = lerp( lerpResult904 , appendResult965 , temp_output_968_0);
			float4 break905 = lerpResult964;
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( break905.w * ase_vertexNormal );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv0_ColdLavaAlbedo_SM = i.uv_texcoord * _ColdLavaAlbedo_SM_ST.xy + _ColdLavaAlbedo_SM_ST.zw;
			int Direction723 = _UVVDirection1UDirection0;
			float2 appendResult705 = (half2(_ColdLavaMainSpeed.y , _ColdLavaMainSpeed.x));
			float2 WaterSpeedValueMain614 = (( (float)Direction723 == 1.0 ) ? _ColdLavaMainSpeed :  appendResult705 );
			float2 break1202 = WaterSpeedValueMain614;
			float2 appendResult1078 = (half2(( break1202.x * i.uv4_texcoord4.x ) , ( break1202.y * i.uv4_texcoord4.y )));
			float temp_output_1136_0 = ( _Time.y * 0.15 );
			float temp_output_1139_0 = frac( ( temp_output_1136_0 + 1.0 ) );
			float2 temp_output_1143_0 = ( uv0_ColdLavaAlbedo_SM + ( appendResult1078 * temp_output_1139_0 ) );
			float2 SlowFlowUV11195 = temp_output_1143_0;
			float temp_output_1137_0 = frac( ( temp_output_1136_0 + 0.5 ) );
			float2 SlowFlowUV21196 = ( uv0_ColdLavaAlbedo_SM + ( appendResult1078 * temp_output_1137_0 ) );
			float clampResult1193 = clamp( pow( abs( ( ( temp_output_1139_0 + -0.5 ) * 2.0 ) ) , ( tex2D( _ColdLavaMT_AO_H_EM, temp_output_1143_0 ).b * 7.0 ) ) , 0.0 , 1.0 );
			float SlowFlowHeightBase1197 = clampResult1193;
			float3 lerpResult1278 = lerp( UnpackScaleNormal( tex2D( _ColdLavaNormal, SlowFlowUV11195 ), _ColdLavaNormalScale ) , UnpackScaleNormal( tex2D( _ColdLavaNormal, SlowFlowUV21196 ), _ColdLavaNormalScale ) , SlowFlowHeightBase1197);
			float2 appendResult710 = (half2(_MediumLavaMainSpeed.y , _MediumLavaMainSpeed.x));
			float2 SmallCascadeSpeedValueMain600 = (( (float)Direction723 == 1.0 ) ? _MediumLavaMainSpeed :  appendResult710 );
			float2 break1204 = SmallCascadeSpeedValueMain600;
			float2 appendResult1208 = (half2(( break1204.x * i.uv4_texcoord4.x ) , ( break1204.y * i.uv4_texcoord4.y )));
			float2 temp_output_1213_0 = ( uv0_ColdLavaAlbedo_SM + ( appendResult1208 * temp_output_1139_0 ) );
			float2 MediumFlowUV11226 = temp_output_1213_0;
			float2 MediumFlowUV21227 = ( uv0_ColdLavaAlbedo_SM + ( appendResult1208 * temp_output_1137_0 ) );
			float clampResult1223 = clamp( pow( abs( ( ( temp_output_1139_0 + -0.5 ) * 2.0 ) ) , ( tex2D( _ColdLavaMT_AO_H_EM, temp_output_1213_0 ).b * 7.0 ) ) , 0.0 , 1.0 );
			float MediumFlowHeightBase1228 = clampResult1223;
			float3 lerpResult1279 = lerp( UnpackScaleNormal( tex2D( _ColdLavaNormal, MediumFlowUV11226 ), _MediumLavaNormalScale ) , UnpackScaleNormal( tex2D( _ColdLavaNormal, MediumFlowUV21227 ), _MediumLavaNormalScale ) , MediumFlowHeightBase1228);
			half4 tex2DNode851 = tex2D( _ColdLavaMT_AO_H_EM, SlowFlowUV11195 );
			half4 tex2DNode856 = tex2D( _ColdLavaMT_AO_H_EM, SlowFlowUV21196 );
			float4 lerpResult1290 = lerp( tex2DNode851 , tex2DNode856 , SlowFlowHeightBase1197);
			float4 break879 = lerpResult1290;
			float temp_output_932_0 = ( 1.0 - break879.b );
			half3 ase_worldNormal = WorldNormalVector( i, half3( 0, 0, 1 ) );
			float clampResult259 = clamp( ase_worldNormal.y , 0.0 , 1.0 );
			float temp_output_258_0 = ( _MediumLavaAngle / 45.0 );
			float clampResult263 = clamp( ( clampResult259 - ( 1.0 - temp_output_258_0 ) ) , 0.0 , 2.0 );
			float clampResult584 = clamp( ( clampResult263 * ( 1.0 / temp_output_258_0 ) ) , 0.0 , 1.0 );
			float clampResult285 = clamp( pow( ( 1.0 - clampResult584 ) , _MediumLavaAngleFalloff ) , 0.0 , 1.0 );
			float HeightMask927 = saturate(pow(((pow( temp_output_932_0 , _MediumLavaHeightBlendTreshold )*clampResult285)*4)+(clampResult285*2),_MediumLavaHeightBlendStrenght));
			float3 lerpResult330 = lerp( lerpResult1278 , lerpResult1279 , HeightMask927);
			float2 appendResult712 = (half2(_HotLavaMainSpeed.y , _HotLavaMainSpeed.x));
			float2 BigCascadeSpeedMain608 = (( (float)Direction723 == 1.0 ) ? _HotLavaMainSpeed :  appendResult712 );
			float2 break1235 = BigCascadeSpeedMain608;
			float2 appendResult1238 = (half2(( break1235.x * i.uv4_texcoord4.x ) , ( break1235.y * i.uv4_texcoord4.y )));
			float2 temp_output_1243_0 = ( uv0_ColdLavaAlbedo_SM + ( appendResult1238 * temp_output_1139_0 ) );
			float2 HotFlowUV11257 = temp_output_1243_0;
			float2 HotFlowUV21258 = ( uv0_ColdLavaAlbedo_SM + ( appendResult1238 * temp_output_1137_0 ) );
			float clampResult1255 = clamp( pow( abs( ( ( temp_output_1139_0 + -0.5 ) * 2.0 ) ) , ( tex2D( _ColdLavaMT_AO_H_EM, temp_output_1243_0 ).b * 7.0 ) ) , 0.0 , 1.0 );
			float HotFlowHeightBase1259 = clampResult1255;
			float3 lerpResult1280 = lerp( UnpackScaleNormal( tex2D( _ColdLavaNormal, HotFlowUV11257 ), _HotLavaNormalScale ) , UnpackScaleNormal( tex2D( _ColdLavaNormal, HotFlowUV21258 ), _HotLavaNormalScale ) , HotFlowHeightBase1259);
			half4 tex2DNode852 = tex2D( _ColdLavaMT_AO_H_EM, MediumFlowUV11226 );
			half4 tex2DNode860 = tex2D( _ColdLavaMT_AO_H_EM, MediumFlowUV21227 );
			float4 lerpResult1291 = lerp( tex2DNode852 , tex2DNode860 , MediumFlowHeightBase1228);
			float4 break884 = lerpResult1291;
			float temp_output_942_0 = ( 1.0 - break884.b );
			float clampResult507 = clamp( ase_worldNormal.y , 0.0 , 1.0 );
			float temp_output_504_0 = ( _HotLavaAngle / 45.0 );
			float clampResult509 = clamp( ( clampResult507 - ( 1.0 - temp_output_504_0 ) ) , 0.0 , 2.0 );
			float clampResult583 = clamp( ( clampResult509 * ( 1.0 / temp_output_504_0 ) ) , 0.0 , 1.0 );
			float clampResult514 = clamp( pow( ( 1.0 - clampResult583 ) , _HotLavaAngleFalloff ) , 0.0 , 1.0 );
			float HeightMask943 = saturate(pow(((pow( temp_output_942_0 , _HotLavaHeightBlendTreshold )*clampResult514)*4)+(clampResult514*2),_HotLavaHeightBlendStrenght));
			float3 lerpResult529 = lerp( lerpResult330 , lerpResult1280 , HeightMask943);
			float4 break770 = ( i.vertexColor / float4( 1,1,1,1 ) );
			float HeightMask988 = saturate(pow(((temp_output_932_0*break770.r)*4)+(break770.r*2),_VCColdLavaHeightBlendStrenght));
			float temp_output_1002_0 = ( break770.r * HeightMask988 );
			float3 lerpResult748 = lerp( lerpResult529 , lerpResult1278 , temp_output_1002_0);
			float HeightMask992 = saturate(pow(((temp_output_942_0*break770.g)*4)+(break770.g*2),_VCMediumLavaHeightBlendStrenght));
			float temp_output_1001_0 = ( break770.g * HeightMask992 );
			float3 lerpResult749 = lerp( lerpResult748 , lerpResult1279 , temp_output_1001_0);
			half4 tex2DNode861 = tex2D( _ColdLavaMT_AO_H_EM, HotFlowUV11257 );
			half4 tex2DNode854 = tex2D( _ColdLavaMT_AO_H_EM, HotFlowUV21258 );
			float4 lerpResult1292 = lerp( tex2DNode861 , tex2DNode854 , HotFlowHeightBase1259);
			float4 break893 = lerpResult1292;
			float HeightMask998 = saturate(pow(((( 1.0 - break893.b )*break770.b)*4)+(break770.b*2),_VCHotLavaHeightBlendStrenght));
			float temp_output_1000_0 = ( break770.b * HeightMask998 );
			float3 lerpResult750 = lerp( lerpResult749 , lerpResult1280 , temp_output_1000_0);
			float temp_output_968_0 = ( 1.0 - break770.a );
			float3 lerpResult963 = lerp( lerpResult750 , lerpResult330 , temp_output_968_0);
			o.Normal = lerpResult963;
			float4 break1023 = ( _ColdLavaAlbedoColor * _ColdLavaAlbedoColorMultiply );
			float4 appendResult1024 = (half4(break1023.r , break1023.g , break1023.b , 1.0));
			float4 lerpResult1087 = lerp( tex2D( _ColdLavaAlbedo_SM, SlowFlowUV11195 ) , tex2D( _ColdLavaAlbedo_SM, SlowFlowUV21196 ) , SlowFlowHeightBase1197);
			float4 break866 = lerpResult1087;
			float4 appendResult867 = (half4(break866.r , break866.g , break866.b , ( break866.a * _ColdLavaSmoothness )));
			float4 temp_output_1018_0 = ( appendResult1024 * appendResult867 );
			float4 break1025 = ( _MediumLavaAlbedoColor * _MediumLavaAlbedoColorMultiply );
			float4 appendResult1026 = (half4(break1025.r , break1025.g , break1025.b , 1.0));
			float4 lerpResult1231 = lerp( tex2D( _ColdLavaAlbedo_SM, MediumFlowUV11226 ) , tex2D( _ColdLavaAlbedo_SM, MediumFlowUV21227 ) , MediumFlowHeightBase1228);
			float4 break868 = lerpResult1231;
			float4 appendResult870 = (half4(break868.r , break868.g , break868.b , ( break868.a * _MediumLavaSmoothness )));
			float4 temp_output_1020_0 = ( appendResult1026 * appendResult870 );
			float4 lerpResult836 = lerp( temp_output_1018_0 , temp_output_1020_0 , HeightMask927);
			float4 break1027 = ( _HotLavaAlbedoColor * _HotLavaAlbedoColorMultiply );
			float4 appendResult1028 = (half4(break1027.r , break1027.g , break1027.b , 1.0));
			float4 lerpResult1256 = lerp( tex2D( _ColdLavaAlbedo_SM, HotFlowUV11257 ) , tex2D( _ColdLavaAlbedo_SM, HotFlowUV21258 ) , HotFlowHeightBase1259);
			float4 break872 = lerpResult1256;
			float4 appendResult874 = (half4(break872.r , break872.g , break872.b , ( break872.a * _HotLavaSmoothness )));
			float4 temp_output_1022_0 = ( appendResult1028 * appendResult874 );
			float4 lerpResult844 = lerp( lerpResult836 , temp_output_1022_0 , HeightMask943);
			float4 lerpResult845 = lerp( lerpResult844 , temp_output_1018_0 , temp_output_1002_0);
			float4 lerpResult846 = lerp( lerpResult845 , temp_output_1020_0 , temp_output_1001_0);
			float4 lerpResult847 = lerp( lerpResult846 , temp_output_1022_0 , temp_output_1000_0);
			float4 lerpResult962 = lerp( lerpResult847 , temp_output_1018_0 , temp_output_968_0);
			o.Albedo = lerpResult962.xyz;
			float clampResult883 = clamp( break879.g , ( 1.0 - _ColdLavaAO ) , 1.0 );
			float4 appendResult876 = (half4(( _ColdLavaMetalic * break879.r ) , clampResult883 , pow( ( _ColdLavaEmissionMaskIntensivity * break879.a ) , _ColdLavaEmissionMaskTreshold ) , ( break879.b * _ColdLavaTessScale )));
			float clampResult890 = clamp( break884.g , ( 1.0 - _MediumLavaAO ) , 1.0 );
			float temp_output_889_0 = ( break884.b * _MediumLavaTessScale );
			float4 appendResult892 = (half4(( _MediumLavaMetallic * break884.r ) , clampResult890 , pow( ( _MediumLavaEmissionMaskIntesivity * break884.a ) , _MediumLavaEmissionMaskTreshold ) , temp_output_889_0));
			float4 lerpResult853 = lerp( appendResult876 , appendResult892 , HeightMask927);
			float clampResult896 = clamp( break893.g , ( 1.0 - _HotLavaAO ) , 1.0 );
			float4 appendResult898 = (half4(( _HotLavaMetallic * break893.r ) , clampResult896 , pow( ( _HotLavaEmissionMaskIntensivity * break893.a ) , _HotLavaEmissionMaskTreshold ) , ( break893.b * _HotLavaTessScale )));
			float4 lerpResult855 = lerp( lerpResult853 , appendResult898 , HeightMask943);
			float4 lerpResult902 = lerp( lerpResult855 , appendResult876 , temp_output_1002_0);
			float4 lerpResult903 = lerp( lerpResult902 , appendResult892 , temp_output_1001_0);
			float4 lerpResult904 = lerp( lerpResult903 , appendResult898 , temp_output_1000_0);
			float4 break967 = appendResult876;
			float4 appendResult965 = (half4(break967.x , break967.y , 0.0 , break967.w));
			float4 lerpResult964 = lerp( lerpResult904 , appendResult965 , temp_output_968_0);
			float4 break905 = lerpResult964;
			float3 normalizeResult1030 = normalize( i.viewDir );
			float dotResult1031 = dot( lerpResult963 , normalizeResult1030 );
			float2 appendResult718 = (half2(_NoiseSpeed.y , _NoiseSpeed.x));
			float2 temp_output_743_0 = (( (float)Direction723 == 1.0 ) ? float2( 0,0 ) :  appendResult718 );
			float2 uv0_Noise = i.uv_texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float2 panner646 = ( _SinTime.x * ( temp_output_743_0 * float2( -1.2,-0.9 ) ) + uv0_Noise);
			float2 panner321 = ( _SinTime.x * temp_output_743_0 + uv0_Noise);
			float lerpResult1007 = lerp( _ColdLavaNoisePower , _MediumLavaNoisePower , HeightMask927);
			float lerpResult1006 = lerp( lerpResult1007 , _HotLavaNoisePower , HeightMask943);
			float clampResult488 = clamp( ( pow( min( tex2D( _Noise, ( panner646 + float2( 0.5,0.5 ) ) ).r , tex2D( _Noise, panner321 ).r ) , lerpResult1006 ) * 20.0 ) , 0.05 , 1.2 );
			float4 temp_output_1044_0 = ( ( break905.z * ( _RimLightPower * ( pow( ( 1.0 - saturate( dotResult1031 ) ) , 10.0 ) * _RimColor ) ) ) + ( ( break905.z * _EmissionColor ) * clampResult488 ) );
			float4 clampResult1296 = clamp( temp_output_1044_0 , float4( 0,0,0,0 ) , temp_output_1044_0 );
			o.Emission = clampResult1296.rgb;
			o.Metallic = break905;
			o.Smoothness = lerpResult962.w;
			o.Occlusion = break905.y;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows noinstancing vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
				float4 customPack1 : TEXCOORD1;
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
				vertexDataFunc( v );
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
				o.customPack1.zw = customInputData.uv4_texcoord4;
				o.customPack1.zw = v.texcoord3;
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
				surfIN.uv4_texcoord4 = IN.customPack1.zw;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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