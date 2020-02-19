Shader "NatureManufacture Shaders/Grass/Advanced Grass Light"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.051
		_HealthyColor("Healthy Color", Color) = (1,1,1,1)
		_DryColor("Dry Color", Color) = (0.875,0.8280551,0.7270221,1)
		_ColorNoiseSpread("Color Noise Spread", Float) = 15
		_MainTex("MainTex", 2D) = "white" {}
		_MetallicPower("Metallic Power", Range( 0 , 1)) = 0
		_SmoothnessPower("Smoothness Power", Range( 0 , 2)) = 0
		_NewNormal("Vertex Normal Multiply", Vector) = (0,0,0,0)
		_InitialBend("Wind Initial Bend", Float) = 1
		_Stiffness("Wind Stiffness", Float) = 1
		_Drag("Wind Drag", Float) = 1
		_ShiverDrag("Wind Shiver Drag", Float) = 0.05
		_ShiverDirectionality("Wind Shiver Directionality", Range( 0 , 1)) = 0.5
		_WindColorInfluence("Wind Color Influence", Vector) = (0,0,0,0)
		_WindColorThreshold("Wind Color Threshold", Range( 0 , 10)) = 1
		_WindNormalInfluence("Wind Normal Influence", Float) = 0
		_CullFarDistance("CullFarDistance", Range( 0 , 10000)) = 5
		_CullFarStart("CullFarStart", Range( 0 , 10000)) = 40
		[Toggle]_BackFaceMirrorNormal("BackFace Mirror Normal", Float) = 1
		[Toggle(_TOUCHREACTACTIVE_ON)] _TouchReactActive("TouchReactActive", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma shader_feature _TOUCHREACTACTIVE_ON
		#include "NMWind.cginc"
		#include "NM_indirect.cginc"
		#pragma vertex vert
		#pragma multi_compile GPU_FRUSTUM_ON __
		#pragma instancing_options procedural:setup
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			half ASEVFace : VFACE;
			float3 worldPos;
			half2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform half _BackFaceMirrorNormal;
		uniform half4 _HealthyColor;
		uniform half4 _DryColor;
		uniform half _ColorNoiseSpread;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform half3 _WindColorInfluence;
		uniform half _WindColorThreshold;
		uniform half _MetallicPower;
		uniform half _SmoothnessPower;
		uniform half _CullFarStart;
		uniform half _CullFarDistance;
		uniform float _Cutoff = 0.051;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 switchResult433 = (((i.ASEVFace>0)?(half3(0,0,1)):(half3(0,0,-1))));
			o.Normal = lerp(float3( 0,0,1 ),switchResult433,_BackFaceMirrorNormal);
			float3 ase_worldPos = i.worldPos;
			float2 appendResult427 = (half2(ase_worldPos.x , ase_worldPos.z));
			float simplePerlin2D430 = snoise( ( appendResult427 / _ColorNoiseSpread ) );
			float4 lerpResult432 = lerp( _HealthyColor , _DryColor , simplePerlin2D430);
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			half4 tex2DNode3 = tex2D( _MainTex, uv0_MainTex );
			float clampResult424 = clamp( i.vertexColor.r , 0.0 , 1.0 );
			float3 lerpResult443 = lerp( ( float3( 1,1,1 ) - _WindColorInfluence ) , ( float3( 1,1,1 ) + _WindColorInfluence ) , pow( clampResult424 , _WindColorThreshold ));
			o.Albedo = ( ( lerpResult432 * tex2DNode3 ) * half4( lerpResult443 , 0.0 ) ).rgb;
			o.Metallic = _MetallicPower;
			o.Smoothness = _SmoothnessPower;
			o.Alpha = 1;
			clip( ( ( 1.0 - saturate( ( ( distance( ase_worldPos , _WorldSpaceCameraPos ) - _CullFarStart ) / _CullFarDistance ) ) ) * tex2DNode3.a ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}