 Shader "NatureManufacture Shaders/Lava/Standard Metalic UV Free Lava"
{
	Properties
	{
		_BottomColor("Bottom Color", Color) = (1,1,1,1)
		_BottomAlbedo_Sm("Bottom Albedo_Sm", 2D) = "white" {}
		_BottomSmoothnessPower("Bottom Smoothness Power", Range( 0 , 2)) = 1
		_BottomTiling("Bottom Tiling", Range( 0.0001 , 100)) = 15
		_BottomTriplanarFalloff("Bottom Triplanar Falloff", Range( 1 , 100)) = 100
		_BottomNormal("Bottom Normal", 2D) = "bump" {}
		_BottomNormalScale("Bottom Normal Scale", Range( 0 , 5)) = 1
		_BottomMetalicRAmbientOcclusionGEmissionA("Bottom Metalic (R) Ambient Occlusion (G)  Emission(A)", 2D) = "white" {}
		_BottomMetalicPower("Bottom Metalic Power", Range( 0 , 2)) = 1
		_BottomAmbientOcclusionPower("Bottom Ambient Occlusion Power", Range( 0 , 1)) = 1
		_BottomLavaEmissionMaskIntensivity("Bottom Lava Emission Mask Intensivity", Range( 0 , 100)) = 0
		_BottomLavaEmissionMaskTreshold("Bottom Lava Emission Mask Treshold", Range( 0.01 , 100)) = 0.01
		_Cover_Amount("Cover_Amount", Range( 0 , 2)) = 2
		_CoverHardness("Cover Hardness", Range( 1 , 10)) = 5
		_CoverMaxAngle("Cover Max Angle ", Range( 0.001 , 90)) = 90
		_Cover_Min_Height("Cover_Min_Height", Range( -1000 , 10000)) = -1000
		_Cover_Min_Height_Blending("Cover_Min_Height_Blending", Range( 0 , 500)) = 1
		_CoverBottomNormalScale("Cover Bottom Normal Scale", Range( 0 , 10)) = 1
		_CoverShapeNormalScale("Cover Shape Normal Scale", Range( 0 , 10)) = 1
		_TopColor("Top Color", Color) = (1,1,1,1)
		_TopAlbedo_Sm("Top Albedo_Sm", 2D) = "white" {}
		_TopSmoothnessPower("Top Smoothness Power", Range( 0 , 2)) = 0
		_TopTiling("Top Tiling", Range( 0.0001 , 100)) = 15
		_TopTriplanarFalloff("Top Triplanar Falloff", Range( 1 , 100)) = 100
		_TopNormal("Top Normal", 2D) = "bump" {}
		_TopNormalScale("Top Normal Scale", Range( 0 , 5)) = 1
		_TopMetalicRAmbientOcclusionGEmissionA("Top Metalic (R) Ambient Occlusion (G)  Emission(A)", 2D) = "white" {}
		_TopMetalicPower("Top Metalic Power", Range( 0 , 2)) = 0
		_TopAmbientOcclusionPower("Top Ambient Occlusion Power", Range( 0 , 1)) = 0
		_TopLavaEmissionMaskIntensivity("Top Lava Emission Mask Intensivity", Range( 0 , 100)) = 0
		_TopLavaEmissionMaskTreshold("Top Lava Emission Mask Treshold", Range( 0.01 , 100)) = 0.01
		_BumpMap("Shape Normal", 2D) = "bump" {}
		_ShapeNormalScale("Shape Normal Scale", Range( 0 , 2)) = 1
		_ShapeAmbientOcclusionG("Shape Ambient Occlusion (G)", 2D) = "white" {}
		_ShapeAmbientOcclusionPower("Shape Ambient Occlusion Power", Range( 0 , 1)) = 1
		_LavaEmissionColor("Lava Emission Color", Color) = (1,0.1862036,0,0)
		_RimColor("Rim Color", Color) = (1,0,0,0)
		_RimLightPower("Rim Light Power", Range( 0 , 4)) = 4
		_LavaNoiseR("Lava Noise (R)", 2D) = "white" {}
		_LavaNoisePower("Lava Noise Power", Range( 0 , 10)) = 2.71
		_LavaNoiseSpeed("Lava Noise Speed", Vector) = (-0.2,-0.5,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#define ASE_TEXTURE_PARAMS(textureName) textureName

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
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float3 viewDir;
		};

		uniform sampler2D _BottomNormal;
		uniform half _BottomTiling;
		uniform float _BottomTriplanarFalloff;
		uniform half _BottomNormalScale;
		uniform half _ShapeNormalScale;
		uniform sampler2D _BumpMap;
		uniform sampler2D _TopNormal;
		uniform half _TopTiling;
		uniform float _TopTriplanarFalloff;
		uniform half _TopNormalScale;
		uniform half _CoverBottomNormalScale;
		uniform half _CoverShapeNormalScale;
		uniform half _Cover_Amount;
		uniform half _CoverMaxAngle;
		uniform half _CoverHardness;
		uniform half _Cover_Min_Height;
		uniform half _Cover_Min_Height_Blending;
		uniform sampler2D _BottomAlbedo_Sm;
		uniform half4 _BottomColor;
		uniform sampler2D _TopAlbedo_Sm;
		uniform half4 _TopColor;
		uniform float _BottomLavaEmissionMaskIntensivity;
		uniform sampler2D _BottomMetalicRAmbientOcclusionGEmissionA;
		uniform float _BottomLavaEmissionMaskTreshold;
		uniform float _TopLavaEmissionMaskIntensivity;
		uniform sampler2D _TopMetalicRAmbientOcclusionGEmissionA;
		uniform float _TopLavaEmissionMaskTreshold;
		uniform float _RimLightPower;
		uniform float4 _RimColor;
		uniform float4 _LavaEmissionColor;
		uniform sampler2D _LavaNoiseR;
		uniform float2 _LavaNoiseSpeed;
		uniform float4 _LavaNoiseR_ST;
		uniform float _LavaNoisePower;
		uniform half _BottomMetalicPower;
		uniform half _TopMetalicPower;
		uniform half _BottomSmoothnessPower;
		uniform half _TopSmoothnessPower;
		uniform half _BottomAmbientOcclusionPower;
		uniform half _TopAmbientOcclusionPower;
		uniform sampler2D _ShapeAmbientOcclusionG;
		uniform half _ShapeAmbientOcclusionPower;


		inline float3 TriplanarSamplingSNF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
			zNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			xNorm.xyz = half3( UnpackNormal( xNorm ).xy * float2( nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
			yNorm.xyz = half3( UnpackNormal( yNorm ).xy * float2( nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
			zNorm.xyz = half3( UnpackNormal( zNorm ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
			return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
		}


		inline float4 TriplanarSamplingSF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
			zNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_3656_0 = ( 1.0 / _BottomTiling );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 triplanar3729 = TriplanarSamplingSNF( _BottomNormal, ase_worldPos, ase_worldNormal, _BottomTriplanarFalloff, temp_output_3656_0, 1.0, 0 );
			float3 tanTriplanarNormal3729 = mul( ase_worldToTangent, triplanar3729 );
			float3 appendResult3730 = (float3(_BottomNormalScale , _BottomNormalScale , 1.0));
			float3 tex2DNode3607 = UnpackScaleNormal( tex2D( _BumpMap, i.uv_texcoord ), _ShapeNormalScale );
			float3 temp_output_3616_0 = BlendNormals( ( tanTriplanarNormal3729 * appendResult3730 ) , tex2DNode3607 );
			float temp_output_3685_0 = ( 1.0 / _TopTiling );
			float3 triplanar3735 = TriplanarSamplingSNF( _TopNormal, ase_worldPos, ase_worldNormal, _TopTriplanarFalloff, temp_output_3685_0, 1.0, 0 );
			float3 tanTriplanarNormal3735 = mul( ase_worldToTangent, triplanar3735 );
			float3 appendResult3734 = (float3(_TopNormalScale , _TopNormalScale , 1.0));
			float3 temp_output_3736_0 = ( tanTriplanarNormal3735 * appendResult3734 );
			float3 appendResult3789 = (float3(_CoverBottomNormalScale , _CoverBottomNormalScale , 1.0));
			float3 temp_output_3818_0 = BlendNormals( tex2DNode3607 , temp_output_3736_0 );
			float clampResult3628 = clamp( ase_worldNormal.y , 0.0 , 0.999999 );
			float temp_output_3625_0 = ( _CoverMaxAngle / 45.0 );
			float clampResult3634 = clamp( ( clampResult3628 - ( 1.0 - temp_output_3625_0 ) ) , 0.0 , 2.0 );
			float temp_output_3620_0 = ( ( 1.0 - _Cover_Min_Height ) + ase_worldPos.y );
			float clampResult3636 = clamp( ( temp_output_3620_0 + 1.0 ) , 0.0 , 1.0 );
			float clampResult3633 = clamp( ( ( 1.0 - ( ( temp_output_3620_0 + _Cover_Min_Height_Blending ) / temp_output_3620_0 ) ) + -0.5 ) , 0.0 , 1.0 );
			float clampResult3643 = clamp( ( clampResult3636 + clampResult3633 ) , 0.0 , 1.0 );
			float temp_output_3645_0 = ( pow( ( clampResult3634 * ( 1.0 / temp_output_3625_0 ) ) , _CoverHardness ) * clampResult3643 );
			float3 lerpResult3792 = lerp( BlendNormals( ( tanTriplanarNormal3729 * appendResult3789 ) , UnpackScaleNormal( tex2D( _BumpMap, i.uv_texcoord ), _CoverShapeNormalScale ) ) , temp_output_3818_0 , ( saturate( ( ase_worldNormal.y * _Cover_Amount ) ) * temp_output_3645_0 ));
			float temp_output_3800_0 = ( saturate( ( ( (WorldNormalVector( i , lerpResult3792 )).y * _Cover_Amount ) * ( ( _Cover_Amount * _CoverHardness ) * temp_output_3645_0 ) ) ) * 1.0 );
			float3 lerpResult3647 = lerp( temp_output_3616_0 , temp_output_3736_0 , temp_output_3800_0);
			float4 temp_output_3743_0 = ( i.vertexColor / float4( 1,1,1,1 ) );
			float4 break3744 = ( 1.0 - temp_output_3743_0 );
			float3 lerpResult3812 = lerp( lerpResult3647 , temp_output_3616_0 , break3744.g);
			float3 lerpResult3813 = lerp( lerpResult3812 , temp_output_3818_0 , break3744.b);
			o.Normal = lerpResult3813;
			float4 triplanar3728 = TriplanarSamplingSF( _BottomAlbedo_Sm, ase_worldPos, ase_worldNormal, _BottomTriplanarFalloff, temp_output_3656_0, 1.0, 0 );
			float4 temp_output_3379_0 = ( triplanar3728 * _BottomColor );
			float4 triplanar3738 = TriplanarSamplingSF( _TopAlbedo_Sm, ase_worldPos, ase_worldNormal, _TopTriplanarFalloff, temp_output_3685_0, 1.0, 0 );
			float4 temp_output_3378_0 = ( triplanar3738 * _TopColor );
			float4 lerpResult3317 = lerp( temp_output_3379_0 , temp_output_3378_0 , temp_output_3800_0);
			float4 lerpResult3803 = lerp( lerpResult3317 , temp_output_3379_0 , break3744.g);
			float4 lerpResult3807 = lerp( lerpResult3803 , temp_output_3378_0 , break3744.b);
			float4 clampResult3290 = clamp( lerpResult3807 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Albedo = clampResult3290.xyz;
			float4 triplanar3731 = TriplanarSamplingSF( _BottomMetalicRAmbientOcclusionGEmissionA, ase_worldPos, ase_worldNormal, _BottomTriplanarFalloff, temp_output_3656_0, 1.0, 0 );
			float lerpResult3747 = lerp( 0.0 , triplanar3731.w , break3744.r);
			float temp_output_3750_0 = pow( ( _BottomLavaEmissionMaskIntensivity * lerpResult3747 ) , _BottomLavaEmissionMaskTreshold );
			float4 triplanar3737 = TriplanarSamplingSF( _TopMetalicRAmbientOcclusionGEmissionA, ase_worldPos, ase_worldNormal, _TopTriplanarFalloff, temp_output_3685_0, 1.0, 0 );
			float lerpResult3754 = lerp( 0.0 , triplanar3737.w , break3744.r);
			float temp_output_3753_0 = pow( ( _TopLavaEmissionMaskIntensivity * lerpResult3754 ) , _TopLavaEmissionMaskTreshold );
			float lerpResult3751 = lerp( temp_output_3750_0 , temp_output_3753_0 , temp_output_3800_0);
			float lerpResult3814 = lerp( lerpResult3751 , temp_output_3750_0 , break3744.g);
			float lerpResult3815 = lerp( lerpResult3814 , temp_output_3753_0 , break3744.b);
			float3 normalizeResult3758 = normalize( i.viewDir );
			float dotResult3759 = dot( lerpResult3813 , normalizeResult3758 );
			float4 temp_output_3767_0 = ( lerpResult3815 * ( _RimLightPower * ( pow( ( 1.0 - saturate( dotResult3759 ) ) , 10.0 ) * _RimColor ) ) );
			float4 clampResult3798 = clamp( temp_output_3767_0 , float4( 0,0,0,0 ) , temp_output_3767_0 );
			float2 uv0_LavaNoiseR = i.uv_texcoord * _LavaNoiseR_ST.xy + _LavaNoiseR_ST.zw;
			float2 panner3773 = ( _SinTime.x * ( _LavaNoiseSpeed * float2( -1.2,-0.9 ) ) + uv0_LavaNoiseR);
			float2 panner3774 = ( _SinTime.x * _LavaNoiseSpeed + uv0_LavaNoiseR);
			float clampResult3783 = clamp( ( pow( min( tex2D( _LavaNoiseR, ( panner3773 + float2( 0.5,0.5 ) ) ).r , tex2D( _LavaNoiseR, panner3774 ).r ) , _LavaNoisePower ) * 20.0 ) , 0.05 , 1.2 );
			float4 temp_output_3785_0 = ( ( lerpResult3815 * _LavaEmissionColor ) * clampResult3783 );
			float4 clampResult3799 = clamp( temp_output_3785_0 , float4( 0,0,0,0 ) , temp_output_3785_0 );
			o.Emission = ( clampResult3798 + clampResult3799 ).rgb;
			float4 break3366 = triplanar3731;
			float temp_output_3374_0 = ( break3366.x * _BottomMetalicPower );
			float4 break3447 = triplanar3737;
			float temp_output_3341_0 = ( break3447.x * _TopMetalicPower );
			float lerpResult3332 = lerp( temp_output_3374_0 , temp_output_3341_0 , temp_output_3800_0);
			float lerpResult3805 = lerp( lerpResult3332 , temp_output_3374_0 , break3744.g);
			float lerpResult3809 = lerp( lerpResult3805 , temp_output_3341_0 , break3744.b);
			o.Metallic = lerpResult3809;
			float temp_output_3372_0 = ( triplanar3728.w * _BottomSmoothnessPower );
			float temp_output_3344_0 = ( triplanar3738.w * _TopSmoothnessPower );
			float lerpResult3345 = lerp( temp_output_3372_0 , temp_output_3344_0 , temp_output_3800_0);
			float lerpResult3804 = lerp( lerpResult3345 , temp_output_3372_0 , break3744.g);
			float lerpResult3808 = lerp( lerpResult3804 , temp_output_3344_0 , break3744.b);
			o.Smoothness = lerpResult3808;
			float clampResult3582 = clamp( break3366.y , ( 1.0 - _BottomAmbientOcclusionPower ) , 1.0 );
			float clampResult3589 = clamp( break3447.y , ( 1.0 - _TopAmbientOcclusionPower ) , 1.0 );
			float lerpResult3333 = lerp( clampResult3582 , clampResult3589 , temp_output_3800_0);
			float lerpResult3802 = lerp( lerpResult3333 , clampResult3582 , break3744.g);
			float lerpResult3806 = lerp( lerpResult3802 , clampResult3589 , break3744.b);
			float clampResult3614 = clamp( tex2D( _ShapeAmbientOcclusionG, i.uv_texcoord ).g , ( 1.0 - _ShapeAmbientOcclusionPower ) , 1.0 );
			o.Occlusion = min( lerpResult3806 , clampResult3614 );
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
				surfIN.worldPos = worldPos;
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