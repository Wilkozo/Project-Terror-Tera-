Shader "NatureManufacture Shaders/Lava/Lava Particles"
{
	Properties
	{
		_Opacity("Opacity", Range( 0 , 20)) = 0.5
		_ParticleTexture("Particle Texture", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		_NormalScale("Normal Scale", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		GrabPass{ }
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf StandardSpecular alpha:fade keepalpha 
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			float3 worldPos;
			float4 screenPos;
			float4 vertexColor : COLOR;
		};

		uniform float _NormalScale;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform sampler2D _GrabTexture;
		uniform float _Opacity;
		uniform sampler2D _ParticleTexture;
		uniform float4 _ParticleTexture_ST;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 tex2DNode10 = UnpackScaleNormal( tex2D( _NormalMap, uv_NormalMap ), _NormalScale );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult25 = dot( (WorldNormalVector( i , tex2DNode10 )) , ase_worldViewDir );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor8 = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD( ( ase_grabScreenPosNorm + float4( tex2DNode10 , 0.0 ) ) ) );
			o.Emission = ( ( 1.0 - ( dotResult25 * 0.8 ) ) * screenColor8 ).rgb;
			float2 uv_ParticleTexture = i.uv_texcoord * _ParticleTexture_ST.xy + _ParticleTexture_ST.zw;
			float clampResult40 = clamp( ( _Opacity * tex2D( _ParticleTexture, uv_ParticleTexture ).r ) , 0.0 , 1.0 );
			o.Alpha = ( clampResult40 * i.vertexColor.a );
		}

		ENDCG
	}
	Fallback "Diffuse"
}