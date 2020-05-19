Shader "NatureManufacture Shaders/Lava/Standard Metalic Lava Frozen River"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 14.89
		_TessMin( "Tess Min Distance", Float ) = 0
		_TessMax( "Tess Max Distance", Float ) = 35
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.47
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo_Sm", 2D) = "white" {}
		_SmothnessPower("Smothness Power", Range( 0 , 2)) = 1
		[NoScaleOffset]_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 5)) = 0
		[NoScaleOffset]_MetalicRAmbientOcclusionGHeightBEmissionA("Metalic (R) Ambient Occlusion (G) Height (B) Emission(A)", 2D) = "white" {}
		_MetalicPower("Metalic Power", Range( 0 , 2)) = 1
		_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 1)) = 1
		_LavaEmissionColor("Lava Emission Color", Color) = (1,0.1862036,0,0)
		_HeightmapDepth("Heightmap Depth", Range( 0 , 1)) = 1
		_TesselationDepth("Tesselation Depth", Range( 0 , 10)) = 5
		_LavaEmissionMaskIntensivity("Lava Emission Mask Intensivity", Range( 0 , 100)) = 0
		_LavaEmissionMaskTreshold("Lava Emission Mask Treshold", Range( 0.01 , 100)) = 0.01
		_LavaNoiseR("Lava Noise (R) ", 2D) = "white" {}
		_LavaNoisePower("Lava Noise Power", Range( 0 , 10)) = 2.71
		_LavaNoiseSpeed("Lava Noise Speed", Vector) = (-0.2,-0.5,0,0)
		_RimColor("Rim Color", Color) = (1,0,0,0)
		_RimLightPower("Rim Light Power", Range( 0 , 4)) = 4
		_DetailMask("DetailMask (A)", 2D) = "white" {}
		_DetailAlbedoPower("Detail Albedo Power", Range( 0 , 2)) = 0
		_DetailMapAlbedoRNyGNxA("Detail Map Albedo(R) Ny(G) Nx(A)", 2D) = "black" {}
		_DetailNormalMapScale("DetailNormalMapScale", Range( 0 , 5)) = 0
		_CoverColor("Cover Color", Color) = (1,1,1,1)
		_TextureSample3("Cover Albedo Sm", 2D) = "white" {}
		_CoverSmothnessPower("Cover Smothness Power", Range( 0 , 2)) = 1
		[NoScaleOffset]_CoverNormal("Cover Normal", 2D) = "bump" {}
		_CoverNormalScale("Cover Normal Scale", Range( 0 , 5)) = 0
		_CoverNormalBlend("Cover Normal Blend", Range( 0 , 1)) = 0.8
		[NoScaleOffset]_CoverMetalicRAmbientocclusionGHeightBEmissionA("Cover Metalic (R) Ambient occlusion (G) Height (B) Emission (A)", 2D) = "white" {}
		_CoverMetalicPower("Cover Metalic Power", Range( 0 , 2)) = 1
		_CoverAmbientOcclusionPower("Cover Ambient Occlusion Power", Range( 0 , 1)) = 1
		_CoverTesselationDepth("Cover Tesselation Depth ", Range( 0 , 10)) = 0.27
		_CoverLavaEmissionMaskIntensivity("Cover Lava Emission Mask Intensivity", Range( 0 , 100)) = 0
		_CoverLavaEmissionMaskTreshold("Cover Lava Emission Mask Treshold", Range( 0.01 , 100)) = 0.01
		_CoverHeightmapDepth("Cover Heightmap Depth", Range( 0 , 1)) = 0.876
		_CoverHeightmapContrast("Cover Heightmap Contrast", Range( 0 , 5)) = 0.16
		_CoverHeighblendTreshold("Cover Heighblend Treshold", Range( 0 , 100)) = 41
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		ZTest LEqual
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
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
			float4 vertexColor : COLOR;
			float3 viewDir;
			INTERNAL_DATA
		};

		uniform sampler2D _MetalicRAmbientOcclusionGHeightBEmissionA;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform half _TesselationDepth;
		uniform sampler2D _CoverMetalicRAmbientocclusionGHeightBEmissionA;
		uniform sampler2D _TextureSample3;
		uniform float4 _TextureSample3_ST;
		uniform half _CoverTesselationDepth;
		uniform half _CoverHeightmapContrast;
		uniform half _CoverHeightmapDepth;
		uniform half _HeightmapDepth;
		uniform half _CoverHeighblendTreshold;
		uniform half _BumpScale;
		uniform sampler2D _BumpMap;
		uniform sampler2D _DetailMapAlbedoRNyGNxA;
		uniform float4 _DetailMapAlbedoRNyGNxA_ST;
		uniform half _DetailNormalMapScale;
		uniform sampler2D _DetailMask;
		uniform half4 _DetailMask_ST;
		uniform half _CoverNormalScale;
		uniform sampler2D _CoverNormal;
		uniform half _CoverNormalBlend;
		uniform half4 _Color;
		uniform half _DetailAlbedoPower;
		uniform half4 _CoverColor;
		uniform half _LavaEmissionMaskIntensivity;
		uniform half _LavaEmissionMaskTreshold;
		uniform half _CoverLavaEmissionMaskIntensivity;
		uniform half _CoverLavaEmissionMaskTreshold;
		uniform half _RimLightPower;
		uniform half4 _RimColor;
		uniform half4 _LavaEmissionColor;
		uniform sampler2D _LavaNoiseR;
		uniform half2 _LavaNoiseSpeed;
		uniform float4 _LavaNoiseR_ST;
		uniform half _LavaNoisePower;
		uniform half _MetalicPower;
		uniform half _CoverMetalicPower;
		uniform half _SmothnessPower;
		uniform half _CoverSmothnessPower;
		uniform half _AmbientOcclusionPower;
		uniform half _CoverAmbientOcclusionPower;
		uniform half _TessValue;
		uniform half _TessMin;
		uniform half _TessMax;
		uniform half _TessPhongStrength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv0_MainTex = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			half4 tex2DNode2 = tex2Dlod( _MetalicRAmbientOcclusionGHeightBEmissionA, half4( uv0_MainTex, 0, 1.0) );
			float temp_output_580_0 = ( tex2DNode2.b * _TesselationDepth );
			float2 uv0_TextureSample3 = v.texcoord.xy * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
			half4 tex2DNode536 = tex2Dlod( _CoverMetalicRAmbientocclusionGHeightBEmissionA, half4( uv0_TextureSample3, 0, 1.0) );
			float4 break496 = ( v.color / float4( 1,1,1,1 ) );
			float temp_output_578_0 = ( ( pow( tex2DNode536.b , _CoverHeightmapContrast ) * _CoverHeightmapDepth ) + ( tex2DNode2.b * _HeightmapDepth ) );
			float clampResult579 = clamp( temp_output_578_0 , 0.0 , temp_output_578_0 );
			float clampResult587 = clamp( clampResult579 , 0.0 , 1.0 );
			float temp_output_586_0 = ( 1.0 - clampResult587 );
			float HeightMask588 = saturate(pow(((temp_output_586_0*break496.g)*4)+(break496.g*2),_CoverHeighblendTreshold));
			float clampResult591 = clamp( _CoverHeighblendTreshold , 0.0 , 1.0 );
			float HeightMask590 = saturate(pow(((temp_output_586_0*break496.g)*4)+(break496.g*2),clampResult591));
			float lerpResult595 = lerp( HeightMask588 , HeightMask590 , break496.g);
			float lerpResult598 = lerp( temp_output_580_0 , max( temp_output_580_0 , ( ( ( ( tex2DNode536.b * _CoverTesselationDepth ) + temp_output_580_0 ) * break496.g ) * 0.5 ) ) , lerpResult595);
			half3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			v.vertex.xyz += ( lerpResult598 * ase_worldNormal );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			half3 tex2DNode4 = UnpackScaleNormal( tex2D( _BumpMap, uv0_MainTex ), _BumpScale );
			float2 uv0_DetailMapAlbedoRNyGNxA = i.uv_texcoord * _DetailMapAlbedoRNyGNxA_ST.xy + _DetailMapAlbedoRNyGNxA_ST.zw;
			half4 tex2DNode486 = tex2D( _DetailMapAlbedoRNyGNxA, uv0_DetailMapAlbedoRNyGNxA );
			float2 appendResult11_g1 = (half2(tex2DNode486.a , tex2DNode486.g));
			float2 temp_output_4_0_g1 = ( ( ( appendResult11_g1 * float2( 2,2 ) ) + float2( -1,-1 ) ) * _DetailNormalMapScale );
			float2 break8_g1 = temp_output_4_0_g1;
			float dotResult5_g1 = dot( temp_output_4_0_g1 , temp_output_4_0_g1 );
			float temp_output_9_0_g1 = sqrt( ( 1.0 - saturate( dotResult5_g1 ) ) );
			float3 appendResult10_g1 = (half3(break8_g1.x , break8_g1.y , temp_output_9_0_g1));
			float2 uv_DetailMask = i.uv_texcoord * _DetailMask_ST.xy + _DetailMask_ST.zw;
			half4 tex2DNode481 = tex2D( _DetailMask, uv_DetailMask );
			float3 lerpResult479 = lerp( tex2DNode4 , BlendNormals( tex2DNode4 , appendResult10_g1 ) , tex2DNode481.a);
			float2 uv0_TextureSample3 = i.uv_texcoord * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
			float3 lerpResult570 = lerp( lerpResult479 , UnpackScaleNormal( tex2D( _CoverNormal, uv0_TextureSample3 ), _CoverNormalScale ) , _CoverNormalBlend);
			half4 tex2DNode536 = tex2D( _CoverMetalicRAmbientocclusionGHeightBEmissionA, uv0_TextureSample3 );
			half4 tex2DNode2 = tex2D( _MetalicRAmbientOcclusionGHeightBEmissionA, uv0_MainTex );
			float temp_output_578_0 = ( ( pow( tex2DNode536.b , _CoverHeightmapContrast ) * _CoverHeightmapDepth ) + ( tex2DNode2.b * _HeightmapDepth ) );
			float clampResult579 = clamp( temp_output_578_0 , 0.0 , temp_output_578_0 );
			float clampResult587 = clamp( clampResult579 , 0.0 , 1.0 );
			float temp_output_586_0 = ( 1.0 - clampResult587 );
			float4 break496 = ( i.vertexColor / float4( 1,1,1,1 ) );
			float HeightMask588 = saturate(pow(((temp_output_586_0*break496.g)*4)+(break496.g*2),_CoverHeighblendTreshold));
			float3 lerpResult593 = lerp( lerpResult479 , lerpResult570 , HeightMask588);
			o.Normal = lerpResult593;
			half4 tex2DNode1 = tex2D( _MainTex, uv0_MainTex );
			float4 temp_output_77_0 = ( tex2DNode1 * _Color );
			half4 temp_cast_0 = (( _DetailAlbedoPower * tex2DNode486.r )).xxxx;
			half4 blendOpSrc474 = temp_output_77_0;
			half4 blendOpDest474 = temp_cast_0;
			float4 lerpResult480 = lerp( temp_output_77_0 , (( blendOpDest474 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest474 - 0.5 ) ) * ( 1.0 - blendOpSrc474 ) ) : ( 2.0 * blendOpDest474 * blendOpSrc474 ) ) , ( _DetailAlbedoPower * tex2DNode481.a ));
			half4 tex2DNode537 = tex2D( _TextureSample3, uv0_TextureSample3 );
			float4 lerpResult592 = lerp( lerpResult480 , ( tex2DNode537 * _CoverColor ) , HeightMask588);
			o.Albedo = lerpResult592.rgb;
			float lerpResult497 = lerp( 0.0 , tex2DNode2.a , break496.r);
			float temp_output_498_0 = ( _LavaEmissionMaskIntensivity * lerpResult497 );
			float lerpResult612 = lerp( 0.0 , tex2DNode536.a , break496.r);
			float lerpResult610 = lerp( pow( temp_output_498_0 , _LavaEmissionMaskTreshold ) , pow( ( _CoverLavaEmissionMaskIntensivity * lerpResult612 ) , _CoverLavaEmissionMaskTreshold ) , break496.g);
			float3 normalizeResult524 = normalize( i.viewDir );
			float dotResult525 = dot( lerpResult593 , normalizeResult524 );
			float4 temp_output_534_0 = ( lerpResult610 * ( _RimLightPower * ( pow( ( 1.0 - saturate( dotResult525 ) ) , 10.0 ) * _RimColor ) ) );
			float4 clampResult614 = clamp( temp_output_534_0 , float4( 0,0,0,0 ) , temp_output_534_0 );
			float2 uv0_LavaNoiseR = i.uv_texcoord * _LavaNoiseR_ST.xy + _LavaNoiseR_ST.zw;
			float2 panner509 = ( _SinTime.x * ( _LavaNoiseSpeed * float2( -1.2,-0.9 ) ) + uv0_LavaNoiseR);
			float2 panner510 = ( _SinTime.x * _LavaNoiseSpeed + uv0_LavaNoiseR);
			float clampResult518 = clamp( ( pow( min( tex2D( _LavaNoiseR, ( panner509 + float2( 0.5,0.5 ) ) ).r , tex2D( _LavaNoiseR, panner510 ).r ) , _LavaNoisePower ) * 20.0 ) , 0.05 , 1.2 );
			float4 temp_output_521_0 = ( ( lerpResult610 * _LavaEmissionColor ) * clampResult518 );
			float4 clampResult613 = clamp( temp_output_521_0 , float4( 0,0,0,0 ) , temp_output_521_0 );
			o.Emission = ( clampResult614 + clampResult613 ).rgb;
			float lerpResult601 = lerp( ( tex2DNode2.r * _MetalicPower ) , ( tex2DNode536.r * _CoverMetalicPower ) , HeightMask588);
			o.Metallic = lerpResult601;
			float lerpResult594 = lerp( ( tex2DNode1.a * _SmothnessPower ) , ( tex2DNode537.a * _CoverSmothnessPower ) , HeightMask588);
			o.Smoothness = lerpResult594;
			float clampResult96 = clamp( tex2DNode2.g , ( 1.0 - _AmbientOcclusionPower ) , 1.0 );
			float clampResult546 = clamp( tex2DNode536.g , ( 1.0 - _CoverAmbientOcclusionPower ) , 1.0 );
			float lerpResult602 = lerp( clampResult96 , clampResult546 , HeightMask588);
			o.Occlusion = lerpResult602;
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