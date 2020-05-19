Shader "NatureManufacture Shaders/Lava/Vulcano Smoke"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,0)
		_ColorPower("Color Power", Vector) = (3,3,3,0)
		_AOPower("AO Power", Range( 0 , 1)) = 1
		_Opacity("Opacity", Range( 0 , 20)) = 0.5
		_ParticleTexture("Particle Texture", 2D) = "white" {}
		_Specular("Specular", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf StandardSpecular alpha:fade keepalpha 
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform float3 _ColorPower;
		uniform float4 _Color;
		uniform sampler2D _ParticleTexture;
		uniform float4 _ParticleTexture_ST;
		uniform float _Specular;
		uniform float _Smoothness;
		uniform float _AOPower;
		uniform float _Opacity;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_ParticleTexture = i.uv_texcoord * _ParticleTexture_ST.xy + _ParticleTexture_ST.zw;
			float4 tex2DNode34 = tex2D( _ParticleTexture, uv_ParticleTexture );
			o.Albedo = ( ( ( float4( _ColorPower , 0.0 ) * i.vertexColor ) * _Color ) * tex2DNode34 ).rgb;
			float3 temp_cast_2 = (_Specular).xxx;
			o.Specular = temp_cast_2;
			o.Smoothness = _Smoothness;
			o.Occlusion = _AOPower;
			float clampResult40 = clamp( ( _Opacity * tex2DNode34.r ) , 0.0 , 1.0 );
			o.Alpha = ( clampResult40 * i.vertexColor.a );
		}

		ENDCG
	}
	Fallback "Diffuse"
}