// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Mtree/Billboard"
{
	Properties
	{
		[Header(Albedo)]_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo", 2D) = "white" {}
		[Enum(Off,0,Front,1,Back,2)]_CullMode("Cull Mode", Int) = 2
		_Cutoff("Cutoff", Range( 0 , 1)) = 0.5
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull [_CullMode]
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature _GLOSSYREFLECTIONS_OFF
		#pragma instancing_options procedural:setup
		#pragma multi_compile GPU_FRUSTUM_ON __
		#include "Assets/Mtree/Shaders/Legacy/VS_indirect.cginc"
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform int _CullMode;
		uniform int BillboardWindEnabled;
		uniform float _WindStrength;
		uniform float Billboard_WindStrength;
		uniform float _RandomWindOffset;
		uniform float _WindPulse;
		uniform float _WindDirection;
		uniform float _WindTurbulence;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Color;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform half _Cutoff;


		float3 switch254_g8( int Enum , float3 zero , float3 one , float3 two , float3 three )
		{
			float3 output;
			if(Enum == 0){
				output = zero;}
			if(Enum == 1){
				output = one;}
			if(Enum == 2){
				output = two;}
			if(Enum == 3){
				output = three;}
			return output;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			int Enum254_g8 = 0;
			float3 vertexPosition255_g8 = mul( unity_ObjectToWorld, float4( ase_vertex3Pos , 0.0 ) ).xyz;
			float3 break261_g8 = vertexPosition255_g8;
			float2 appendResult196_g8 = (float2(break261_g8.x , break261_g8.z));
			float MainWind71_g8 = ( _WindStrength * Billboard_WindStrength );
			float4 transform21_g9 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float2 appendResult22_g9 = (float2(transform21_g9.x , transform21_g9.z));
			float dotResult2_g9 = dot( ( appendResult22_g9 + float2( 0,0 ) ) , float2( 12.9898,78.233 ) );
			float lerpResult8_g9 = lerp( 0.8 , ( ( _RandomWindOffset / 2.0 ) + 0.9 ) , frac( ( sin( dotResult2_g9 ) * 43758.55 ) ));
			float RandomTime45_g8 = ( _Time.x * lerpResult8_g9 );
			float Turbulence58_g8 = ( sin( ( ( RandomTime45_g8 * 40.0 ) - ( (vertexPosition255_g8).z / 15.0 ) ) ) * 0.5 );
			float Angle89_g8 = ( MainWind71_g8 * ( 1.0 + sin( ( ( ( RandomTime45_g8 * 2.0 ) + Turbulence58_g8 ) - ( ( vertexPosition255_g8.z / 50.0 ) - ( v.color.r / 20.0 ) ) ) ) ) * sqrt( v.color.r ) * 0.02 * _WindPulse );
			float sin_a100_g8 = sin( Angle89_g8 );
			float cos_a119_g8 = cos( Angle89_g8 );
			float temp_output_99_0_g8 = radians( _WindDirection );
			float2 appendResult200_g8 = (float2(cos( temp_output_99_0_g8 ) , sin( temp_output_99_0_g8 )));
			float2 xzLerp129_g8 = ( ( appendResult200_g8 + 1 ) / 2 );
			float2 lerpResult140_g8 = lerp( appendResult196_g8 , ( ( appendResult196_g8 + ( break261_g8.y * sin_a100_g8 ) ) * cos_a119_g8 ) , (xzLerp129_g8).yx);
			float2 break204_g8 = lerpResult140_g8;
			float3 appendResult174_g8 = (float3(break204_g8.x , ( ( break261_g8.y * cos_a119_g8 ) - ( break261_g8.z * sin_a100_g8 ) ) , break204_g8.y));
			float3 v_pos175_g8 = appendResult174_g8;
			float3 zero254_g8 = v_pos175_g8;
			float3 break188_g8 = v_pos175_g8;
			float WindTurbulence110_g8 = ( _WindTurbulence * 0.0 );
			float leaf_turbulence135_g8 = ( sin( ( ( ( RandomTime45_g8 * 200.0 ) * ( v.color.g + 0.2 ) ) + ( v.color.g * 10.0 ) + Turbulence58_g8 + ( vertexPosition255_g8.z / 2.0 ) ) ) * v.color.b * ( ( MainWind71_g8 / 200.0 ) + Angle89_g8 ) * WindTurbulence110_g8 );
			float3 appendResult153_g8 = (float3(break188_g8.x , ( break188_g8.y + leaf_turbulence135_g8 ) , break188_g8.z));
			float3 one254_g8 = appendResult153_g8;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 appendResult184_g8 = (float3(( ase_normWorldNormal.x * v.color.g ) , ( ase_normWorldNormal.y / v.color.r ) , ( ase_normWorldNormal.z * v.color.g )));
			float3 two254_g8 = ( ( appendResult184_g8 * leaf_turbulence135_g8 ) + v_pos175_g8 );
			float3 break247_g8 = v_pos175_g8;
			float2 break241_g8 = xzLerp129_g8;
			float lerpResult238_g8 = lerp( 0.0 , leaf_turbulence135_g8 , break241_g8.x);
			float lerpResult242_g8 = lerp( 0.0 , leaf_turbulence135_g8 , break241_g8.y);
			float3 appendResult249_g8 = (float3(( break247_g8.x + lerpResult238_g8 ) , break247_g8.y , ( break247_g8.z + lerpResult242_g8 )));
			float3 three254_g8 = appendResult249_g8;
			float3 localswitch254_g8 = switch254_g8( Enum254_g8 , zero254_g8 , one254_g8 , two254_g8 , three254_g8 );
			float3 ifLocalVar38 = 0;
			if( BillboardWindEnabled > 0.0 )
				ifLocalVar38 = ase_vertex3Pos;
			else if( BillboardWindEnabled == 0.0 )
				ifLocalVar38 = mul( unity_WorldToObject, float4( localswitch254_g8 , 0.0 ) ).xyz;
			v.vertex.xyz = ifLocalVar38;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode3 = tex2D( _MainTex, uv_MainTex );
			o.Albedo = ( tex2DNode3 * _Color ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			clip( tex2DNode3.a - _Cutoff);
			o.Alpha = tex2DNode3.a;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=17300
431;337;1264;592;1822.45;114.67;1.633304;True;False
Node;AmplifyShaderEditor.CommentaryNode;1;-1354.891,4.554405;Inherit;False;1279.983;871.9046;;15;12;6;9;10;4;3;8;2;23;25;26;27;28;38;40;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;2;-1304.891,54.55442;Float;True;Property;_MainTex;Albedo;1;0;Create;False;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1347.554,755.7338;Inherit;False;Global;Billboard_WindStrength;Billboard_WindStrength;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;23;-700.8624,592.0113;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;26;-1078.754,737.2339;Inherit;False;Mtree Wind Node;-1;;8;64b78a30028980947ab723bea7191537;0;3;235;INT;0;False;167;FLOAT;0;False;166;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;25;-750.2974,520.1067;Inherit;False;Global;BillboardWindEnabled;BillboardWindEnabled;3;1;[Enum];Create;True;2;On;0;Off;1;0;False;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.ColorNode;8;-894.0508,258.5437;Inherit;False;Property;_Color;Color;0;0;Create;True;0;0;False;1;Header(Albedo);1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-985.0397,68.42551;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-953.6189,434.1565;Half;False;Property;_Cutoff;Cutoff;3;0;Create;True;0;0;False;0;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-617.0268,139.8965;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1298.6,284.0134;Inherit;False;Constant;_MaskClipValue;Mask Clip Value;14;1;[HideInInspector];Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;28;-1288.554,370.3961;Inherit;False;Property;_CullMode;Cull Mode;2;1;[Enum];Create;True;3;Off;0;Front;1;Back;2;0;True;0;2;0;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-522.0943,298.1364;Inherit;False;Property;_Smoothness;Smoothness;5;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-523.2556,225.2081;Inherit;False;Property;_Metallic;Metallic;4;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;38;-350.5879,584.4824;Inherit;False;False;5;0;INT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClipNode;12;-525.8605,372.2194;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;39;-48.5773,89.05838;Float;False;True;-1;2;;0;0;Standard;Mtree/Billboard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;-1;-1;-1;-1;0;False;0;0;True;28;-1;0;True;6;3;Pragma;instancing_options procedural:setup;False;;Custom;Pragma;multi_compile GPU_FRUSTUM_ON __;False;;Custom;Include;;True;a6d16d0571c954c4bbcc7edb6344bb7c;Custom;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;167;27;0
WireConnection;3;0;2;0
WireConnection;9;0;3;0
WireConnection;9;1;8;0
WireConnection;38;0;25;0
WireConnection;38;2;23;0
WireConnection;38;3;26;0
WireConnection;12;0;3;4
WireConnection;12;1;3;4
WireConnection;12;2;4;0
WireConnection;39;0;9;0
WireConnection;39;3;40;0
WireConnection;39;4;10;0
WireConnection;39;9;12;0
WireConnection;39;11;38;0
ASEEND*/
//CHKSM=90D0857D1CC4CF1053F48965BCFD5EF1658D2A6F