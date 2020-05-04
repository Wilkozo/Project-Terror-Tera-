 Shader "NatureManufacture Shaders/Lava/Standard Specular UV Free Lava"
{
	Properties
	{
		_BottomColor("Bottom Color", Color) = (1,1,1,1)
		_BottomAlbedo_Sm("Bottom Albedo_Sm", 2D) = "white" {}
		_BottomSmoothnessPower("Bottom Smoothness Power", Range( 0 , 2)) = 1
		_BottomTiling("Bottom Tiling", Range( 0.0001 , 100)) = 15
		_BottomTriplanarFalloff("Bottom Triplanar Falloff", Range( 0 , 100)) = 100
		_BottomNormal("Bottom Normal", 2D) = "bump" {}
		_BottomNormalScale("Bottom Normal Scale", Range( 0 , 5)) = 1
		_BottomSpecularRGBEmissionA("Bottom Specular (RGB) Emission (A)", 2D) = "white" {}
		_BottomSpecularPower("Bottom Specular Power", Range( 0 , 2)) = 1
		_BottomLavaEmissionMaskIntensivity("Bottom Lava Emission Mask Intensivity", Range( 0 , 100)) = 100
		_BottomLavaEmissionMaskTreshold("Bottom Lava Emission Mask Treshold", Range( 0.01 , 100)) = 0.01
		_BottomAmbientOcclusionG("Bottom Ambient Occlusion (G)", 2D) = "white" {}
		_BottomAmbientOcclusionPower("Bottom Ambient Occlusion Power", Range( 0 , 2)) = 1
		_Cover_Amount("Cover_Amount", Range( 0 , 2)) = 2
		_CoverHardness("Cover Hardness", Range( 0 , 10)) = 5
		_CoverMaxAngle("Cover Max Angle", Range( 0.001 , 90)) = 90
		_Cover_Min_Height("Cover_Min_Height", Range( -1000 , 10000)) = -1000
		_Cover_Min_Height_Blending("Cover_Min_Height_Blending", Range( 0 , 500)) = 1
		_CoverBottomNormalScale("Cover Bottom Normal Scale", Range( 0 , 10)) = 1
		_CoverShapeNormalScale("Cover Shape Normal Scale", Range( 0 , 2)) = 1
		_TopColor("Top Color", Color) = (1,1,1,1)
		_TopAlbedo_Sm("Top Albedo_Sm", 2D) = "white" {}
		_TopSmoothnessPower("Top Smoothness Power", Range( 0 , 2)) = 1
		_TopTiling("Top Tiling", Range( 0.0001 , 100)) = 15
		_TopTriplanarFalloff("Top Triplanar Falloff", Range( 0 , 100)) = 100
		_TopNormal("Top Normal", 2D) = "bump" {}
		_TopNormalScale("Top Normal Scale", Range( 0 , 5)) = 1
		_TopSpecularRGBEmissionA("Top Specular (RGB) Emission (A)", 2D) = "white" {}
		_TopSpecularPower("Top Specular Power", Range( 0 , 2)) = 1
		_TopLavaEmissionMaskIntensivity("Top Lava Emission Mask Intensivity", Range( 0 , 100)) = 0
		_TopLavaEmissionMaskTreshold("Top Lava Emission Mask Treshold", Range( 0.01 , 100)) = 0.01
		_TopAmbientOcclusionG("Top Ambient Occlusion(G)", 2D) = "white" {}
		_TopAmbientOcclusionPower("Top Ambient Occlusion Power", Range( 0 , 1)) = 1
		_ShapeNormal("Shape Normal", 2D) = "bump" {}
		_ShapeNormalScale("Shape Normal Scale", Range( 0 , 2)) = 1
		_ShapeAmbientOcclusionG("Shape Ambient Occlusion (G)", 2D) = "white" {}
		_ShapeAmbientOcclusionPower("Shape Ambient Occlusion Power", Range( 0 , 1)) = 1
		_LavaEmissionColor("Lava Emission Color", Color) = (1,0.1862036,0,0)
		_RimColor("Rim Color", Color) = (1,0,0,0)
		_RimLightPower("Rim Light Power", Range( 0 , 4)) = 4
		_NoiseR("Noise (R)", 2D) = "white" {}
		_LavaNoisePower("Lava Noise Power", Range( 0 , 10)) = 2.71
		_LavaNoiseSpeed("Lava Noise Speed", Vector) = (-0.2,-0.5,0,0)
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
			half2 uv_texcoord;
			float4 vertexColor : COLOR;
			float3 viewDir;
		};

		uniform sampler2D _BottomNormal;
		uniform half _BottomTiling;
		uniform half _BottomTriplanarFalloff;
		uniform half _BottomNormalScale;
		uniform half _ShapeNormalScale;
		uniform sampler2D _ShapeNormal;
		uniform sampler2D _TopNormal;
		uniform half _TopTiling;
		uniform half _TopTriplanarFalloff;
		uniform half _TopNormalScale;
		uniform half _Cover_Amount;
		uniform half _CoverMaxAngle;
		uniform half _CoverHardness;
		uniform half _Cover_Min_Height;
		uniform half _Cover_Min_Height_Blending;
		uniform sampler2D _BottomAlbedo_Sm;
		uniform half4 _BottomColor;
		uniform sampler2D _TopAlbedo_Sm;
		uniform half4 _TopColor;
		uniform half _CoverBottomNormalScale;
		uniform half _CoverShapeNormalScale;
		uniform half _BottomLavaEmissionMaskIntensivity;
		uniform sampler2D _BottomSpecularRGBEmissionA;
		uniform half _BottomLavaEmissionMaskTreshold;
		uniform half _TopLavaEmissionMaskIntensivity;
		uniform sampler2D _TopSpecularRGBEmissionA;
		uniform half _TopLavaEmissionMaskTreshold;
		uniform half4 _LavaEmissionColor;
		uniform sampler2D _NoiseR;
		uniform half2 _LavaNoiseSpeed;
		uniform float4 _NoiseR_ST;
		uniform half _LavaNoisePower;
		uniform half _BottomSmoothnessPower;
		uniform half _RimLightPower;
		uniform half4 _RimColor;
		uniform half _BottomSpecularPower;
		uniform half _TopSpecularPower;
		uniform half _TopSmoothnessPower;
		uniform sampler2D _ShapeAmbientOcclusionG;
		uniform half _ShapeAmbientOcclusionPower;
		uniform sampler2D _BottomAmbientOcclusionG;
		uniform half _BottomAmbientOcclusionPower;
		uniform sampler2D _TopAmbientOcclusionG;
		uniform half _TopAmbientOcclusionPower;


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


		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float temp_output_3715_0 = ( 1.0 / _BottomTiling );
			float3 ase_worldPos = i.worldPos;
			half3 ase_worldNormal = WorldNormalVector( i, half3( 0, 0, 1 ) );
			half3 ase_worldTangent = WorldNormalVector( i, half3( 1, 0, 0 ) );
			half3 ase_worldBitangent = WorldNormalVector( i, half3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 triplanar3771 = TriplanarSamplingSNF( _BottomNormal, ase_worldPos, ase_worldNormal, _BottomTriplanarFalloff, temp_output_3715_0, 1.0, 0 );
			float3 tanTriplanarNormal3771 = mul( ase_worldToTangent, triplanar3771 );
			float3 appendResult3772 = (half3(_BottomNormalScale , _BottomNormalScale , 1.0));
			half3 tex2DNode3309 = UnpackScaleNormal( tex2D( _ShapeNormal, i.uv_texcoord ), _ShapeNormalScale );
			float3 temp_output_3311_0 = BlendNormals( ( tanTriplanarNormal3771 * appendResult3772 ) , tex2DNode3309 );
			float temp_output_3742_0 = ( 1.0 / _TopTiling );
			float3 triplanar3778 = TriplanarSamplingSNF( _TopNormal, ase_worldPos, ase_worldNormal, _TopTriplanarFalloff, temp_output_3742_0, 1.0, 0 );
			float3 tanTriplanarNormal3778 = mul( ase_worldToTangent, triplanar3778 );
			float3 appendResult3779 = (half3(_TopNormalScale , _TopNormalScale , 1.0));
			float3 temp_output_3754_0 = ( tanTriplanarNormal3778 * appendResult3779 );
			float clampResult3644 = clamp( ase_worldNormal.y , 0.0 , 0.999999 );
			float temp_output_3640_0 = ( _CoverMaxAngle / 45.0 );
			float clampResult3659 = clamp( ( clampResult3644 - ( 1.0 - temp_output_3640_0 ) ) , 0.0 , 2.0 );
			float temp_output_3637_0 = ( ( 1.0 - _Cover_Min_Height ) + ase_worldPos.y );
			float clampResult3657 = clamp( ( temp_output_3637_0 + 1.0 ) , 0.0 , 1.0 );
			float clampResult3656 = clamp( ( ( 1.0 - ( ( temp_output_3637_0 + _Cover_Min_Height_Blending ) / temp_output_3637_0 ) ) + -0.5 ) , 0.0 , 1.0 );
			float clampResult3670 = clamp( ( clampResult3657 + clampResult3656 ) , 0.0 , 1.0 );
			float temp_output_3673_0 = ( pow( ( clampResult3659 * ( 1.0 / temp_output_3640_0 ) ) , _CoverHardness ) * clampResult3670 );
			float temp_output_3675_0 = ( saturate( ( ase_worldNormal.y * _Cover_Amount ) ) * temp_output_3673_0 );
			float3 lerpResult3676 = lerp( temp_output_3311_0 , temp_output_3754_0 , temp_output_3675_0);
			float4 break3786 = ( 1.0 - ( i.vertexColor / float4( 1,1,1,1 ) ) );
			float3 lerpResult3839 = lerp( lerpResult3676 , temp_output_3311_0 , break3786.r);
			float3 temp_output_3850_0 = BlendNormals( tex2DNode3309 , temp_output_3754_0 );
			float3 lerpResult3840 = lerp( lerpResult3839 , temp_output_3850_0 , break3786.b);
			o.Normal = lerpResult3840;
			float4 triplanar3768 = TriplanarSamplingSF( _BottomAlbedo_Sm, ase_worldPos, ase_worldNormal, _BottomTriplanarFalloff, temp_output_3715_0, 1.0, 0 );
			float4 temp_output_3393_0 = ( triplanar3768 * _BottomColor );
			float4 triplanar3776 = TriplanarSamplingSF( _TopAlbedo_Sm, ase_worldPos, ase_worldNormal, _TopTriplanarFalloff, temp_output_3742_0, 1.0, 0 );
			float4 temp_output_3392_0 = ( triplanar3776 * _TopColor );
			float3 appendResult3832 = (half3(_CoverBottomNormalScale , _CoverBottomNormalScale , 1.0));
			float3 lerpResult3829 = lerp( BlendNormals( ( tanTriplanarNormal3771 * appendResult3832 ) , UnpackScaleNormal( tex2D( _ShapeNormal, i.uv_texcoord ), _CoverShapeNormalScale ) ) , temp_output_3850_0 , temp_output_3675_0);
			float temp_output_3682_0 = saturate( ( ( (WorldNormalVector( i , lerpResult3829 )).y * _Cover_Amount ) * ( ( _Cover_Amount * _CoverHardness ) * temp_output_3673_0 ) ) );
			float4 lerpResult3317 = lerp( temp_output_3393_0 , temp_output_3392_0 , temp_output_3682_0);
			float4 lerpResult3841 = lerp( lerpResult3317 , temp_output_3393_0 , break3786.g);
			float4 lerpResult3845 = lerp( lerpResult3841 , temp_output_3392_0 , break3786.b);
			float4 clampResult3290 = clamp( lerpResult3845 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Albedo = clampResult3290.xyz;
			float4 triplanar3775 = TriplanarSamplingSF( _BottomSpecularRGBEmissionA, ase_worldPos, ase_worldNormal, _BottomTriplanarFalloff, temp_output_3715_0, 1.0, 0 );
			float lerpResult3790 = lerp( 0.0 , triplanar3775.w , break3786.r);
			float temp_output_3796_0 = pow( ( _BottomLavaEmissionMaskIntensivity * lerpResult3790 ) , _BottomLavaEmissionMaskTreshold );
			float4 triplanar3780 = TriplanarSamplingSF( _TopSpecularRGBEmissionA, ase_worldPos, ase_worldNormal, _TopTriplanarFalloff, temp_output_3742_0, 1.0, 0 );
			float lerpResult3789 = lerp( 0.0 , triplanar3780.w , break3786.r);
			float temp_output_3797_0 = pow( ( _TopLavaEmissionMaskIntensivity * lerpResult3789 ) , _TopLavaEmissionMaskTreshold );
			float lerpResult3798 = lerp( temp_output_3796_0 , temp_output_3797_0 , temp_output_3682_0);
			float lerpResult3851 = lerp( lerpResult3798 , temp_output_3796_0 , break3786.g);
			float lerpResult3852 = lerp( lerpResult3851 , temp_output_3797_0 , break3786.b);
			float2 uv0_NoiseR = i.uv_texcoord * _NoiseR_ST.xy + _NoiseR_ST.zw;
			float2 panner3803 = ( _SinTime.x * ( _LavaNoiseSpeed * float2( -1.2,-0.9 ) ) + uv0_NoiseR);
			float2 panner3804 = ( _SinTime.x * _LavaNoiseSpeed + uv0_NoiseR);
			float clampResult3813 = clamp( ( pow( min( tex2D( _NoiseR, ( panner3803 + float2( 0.5,0.5 ) ) ).r , tex2D( _NoiseR, panner3804 ).r ) , _LavaNoisePower ) * 20.0 ) , 0.05 , 1.2 );
			float4 temp_output_3815_0 = ( ( lerpResult3852 * _LavaEmissionColor ) * clampResult3813 );
			float4 clampResult3836 = clamp( temp_output_3815_0 , float4( 0,0,0,0 ) , temp_output_3815_0 );
			float temp_output_3390_0 = ( triplanar3768.w * _BottomSmoothnessPower );
			float3 normalizeResult3819 = normalize( i.viewDir );
			float dotResult3820 = dot( lerpResult3840 , normalizeResult3819 );
			float4 temp_output_3828_0 = ( temp_output_3390_0 * ( _RimLightPower * ( pow( ( 1.0 - saturate( dotResult3820 ) ) , 10.0 ) * _RimColor ) ) );
			float4 clampResult3837 = clamp( temp_output_3828_0 , float4( 0,0,0,0 ) , temp_output_3828_0 );
			o.Emission = ( clampResult3836 + clampResult3837 ).rgb;
			float4 break3388 = triplanar3775;
			float3 appendResult3389 = (half3(break3388.x , break3388.y , break3388.z));
			float3 temp_output_3488_0 = ( _BottomSpecularPower * appendResult3389 );
			float4 break3454 = triplanar3780;
			float3 appendResult3467 = (half3(break3454.x , break3454.y , break3454.z));
			float3 temp_output_3341_0 = ( appendResult3467 * _TopSpecularPower );
			float3 lerpResult3332 = lerp( temp_output_3488_0 , temp_output_3341_0 , temp_output_3682_0);
			float3 lerpResult3846 = lerp( lerpResult3332 , temp_output_3488_0 , break3786.g);
			float3 lerpResult3848 = lerp( lerpResult3846 , temp_output_3341_0 , break3786.b);
			o.Specular = lerpResult3848;
			float temp_output_3758_0 = ( triplanar3776.w * _TopSmoothnessPower );
			float lerpResult3345 = lerp( temp_output_3390_0 , temp_output_3758_0 , temp_output_3682_0);
			float lerpResult3842 = lerp( lerpResult3345 , temp_output_3390_0 , break3786.g);
			float lerpResult3844 = lerp( lerpResult3842 , temp_output_3758_0 , break3786.b);
			o.Smoothness = lerpResult3844;
			float clampResult3626 = clamp( tex2D( _ShapeAmbientOcclusionG, i.uv_texcoord ).g , ( 1.0 - _ShapeAmbientOcclusionPower ) , 1.0 );
			float4 triplanar3774 = TriplanarSamplingSF( _BottomAmbientOcclusionG, ase_worldPos, ase_worldNormal, _BottomTriplanarFalloff, temp_output_3715_0, 1.0, 0 );
			float clampResult3629 = clamp( triplanar3774.y , ( 1.0 - _BottomAmbientOcclusionPower ) , 1.0 );
			float4 triplanar3783 = TriplanarSamplingSF( _TopAmbientOcclusionG, ase_worldPos, ase_worldNormal, _TopTriplanarFalloff, temp_output_3742_0, 1.0, 0 );
			float clampResult3632 = clamp( 0.0 , ( triplanar3783.y - _TopAmbientOcclusionPower ) , 1.0 );
			float lerpResult3333 = lerp( clampResult3629 , clampResult3632 , temp_output_3682_0);
			float lerpResult3843 = lerp( lerpResult3333 , clampResult3629 , break3786.g);
			float lerpResult3847 = lerp( lerpResult3843 , clampResult3632 , break3786.b);
			o.Occlusion = min( clampResult3626 , lerpResult3847 );
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows 

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