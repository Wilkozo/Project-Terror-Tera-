// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hidden/Mtree/VertexColorShader"
{
	Properties
	{
		[Enum(Default,0,Leaf,1,Palm,2,Grass,3)][Header(Wind)]_WindMode("Wind Mode", Int) = 3
		[Enum(Off,0,Front,1,Back,2)]_CullMode("Cull Mode", Int) = 2
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull [_CullMode]
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature _GLOSSYREFLECTIONS_OFF
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float4 vertexColor : COLOR;
		};

		uniform int _CullMode;
		uniform int _WindMode;
		uniform float _WindStrength;
		uniform float _RandomWindOffset;
		uniform float _WindPulse;
		uniform float _WindDirection;
		uniform float _WindTurbulence;


		float3 switch254_g10( int Enum , float3 zero , float3 one , float3 two , float3 three )
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
			int Enum254_g10 = _WindMode;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPosition255_g10 = mul( unity_ObjectToWorld, float4( ase_vertex3Pos , 0.0 ) ).xyz;
			float3 break261_g10 = vertexPosition255_g10;
			float2 appendResult196_g10 = (float2(break261_g10.x , break261_g10.z));
			float MainWind71_g10 = ( _WindStrength * 1.0 );
			float4 transform21_g11 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float2 appendResult22_g11 = (float2(transform21_g11.x , transform21_g11.z));
			float dotResult2_g11 = dot( ( appendResult22_g11 + float2( 0,0 ) ) , float2( 12.9898,78.233 ) );
			float lerpResult8_g11 = lerp( 0.8 , ( ( _RandomWindOffset / 2.0 ) + 0.9 ) , frac( ( sin( dotResult2_g11 ) * 43758.55 ) ));
			float RandomTime45_g10 = ( _Time.x * lerpResult8_g11 );
			float Turbulence58_g10 = ( sin( ( ( RandomTime45_g10 * 40.0 ) - ( (vertexPosition255_g10).z / 15.0 ) ) ) * 0.5 );
			float Angle89_g10 = ( MainWind71_g10 * ( 1.0 + sin( ( ( ( RandomTime45_g10 * 2.0 ) + Turbulence58_g10 ) - ( ( vertexPosition255_g10.z / 50.0 ) - ( v.color.r / 20.0 ) ) ) ) ) * sqrt( v.color.r ) * 0.02 * _WindPulse );
			float sin_a100_g10 = sin( Angle89_g10 );
			float cos_a119_g10 = cos( Angle89_g10 );
			float temp_output_99_0_g10 = radians( _WindDirection );
			float2 appendResult200_g10 = (float2(cos( temp_output_99_0_g10 ) , sin( temp_output_99_0_g10 )));
			float2 xzLerp129_g10 = ( ( appendResult200_g10 + 1 ) / 2 );
			float2 lerpResult140_g10 = lerp( appendResult196_g10 , ( ( appendResult196_g10 + ( break261_g10.y * sin_a100_g10 ) ) * cos_a119_g10 ) , (xzLerp129_g10).yx);
			float2 break204_g10 = lerpResult140_g10;
			float3 appendResult174_g10 = (float3(break204_g10.x , ( ( break261_g10.y * cos_a119_g10 ) - ( break261_g10.z * sin_a100_g10 ) ) , break204_g10.y));
			float3 v_pos175_g10 = appendResult174_g10;
			float3 zero254_g10 = v_pos175_g10;
			float3 break188_g10 = v_pos175_g10;
			float WindTurbulence110_g10 = ( _WindTurbulence * 1.0 );
			float leaf_turbulence135_g10 = ( sin( ( ( ( RandomTime45_g10 * 200.0 ) * ( v.color.g + 0.2 ) ) + ( v.color.g * 10.0 ) + Turbulence58_g10 + ( vertexPosition255_g10.z / 2.0 ) ) ) * v.color.b * ( ( MainWind71_g10 / 200.0 ) + Angle89_g10 ) * WindTurbulence110_g10 );
			float3 appendResult153_g10 = (float3(break188_g10.x , ( break188_g10.y + leaf_turbulence135_g10 ) , break188_g10.z));
			float3 one254_g10 = appendResult153_g10;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 appendResult184_g10 = (float3(( ase_normWorldNormal.x * v.color.g ) , ( ase_normWorldNormal.y / v.color.r ) , ( ase_normWorldNormal.z * v.color.g )));
			float3 two254_g10 = ( ( appendResult184_g10 * leaf_turbulence135_g10 ) + v_pos175_g10 );
			float3 break247_g10 = v_pos175_g10;
			float2 break241_g10 = xzLerp129_g10;
			float lerpResult238_g10 = lerp( 0.0 , leaf_turbulence135_g10 , break241_g10.x);
			float lerpResult242_g10 = lerp( 0.0 , leaf_turbulence135_g10 , break241_g10.y);
			float3 appendResult249_g10 = (float3(( break247_g10.x + lerpResult238_g10 ) , break247_g10.y , ( break247_g10.z + lerpResult242_g10 )));
			float3 three254_g10 = appendResult249_g10;
			float3 localswitch254_g10 = switch254_g10( Enum254_g10 , zero254_g10 , one254_g10 , two254_g10 , three254_g10 );
			v.vertex.xyz = mul( unity_WorldToObject, float4( localswitch254_g10 , 0.0 ) ).xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = i.vertexColor.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=17300
431;337;1264;592;1570.512;-20.92221;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;3;-997.005,404.2226;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;6;-1015.505,331.7226;Inherit;False;Property;_WindMode;Wind Mode;0;1;[Enum];Create;True;4;Default;0;Leaf;1;Palm;2;Grass;3;0;False;1;Header(Wind);3;0;0;1;INT;0
Node;AmplifyShaderEditor.VertexColorNode;1;-360.5,-56;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;5;-740.2638,349.5572;Inherit;False;Mtree Wind Node;-1;;10;64b78a30028980947ab723bea7191537;0;3;235;INT;3;False;167;FLOAT;0;False;166;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;17;-1006.908,248.6407;Inherit;False;Property;_CullMode;Cull Mode;1;1;[Enum];Create;True;3;Off;0;Front;1;Back;2;0;True;0;2;0;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;16;0,0;Float;False;True;-1;2;;0;0;Standard;Hidden/Mtree/VertexColorShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;-1;-1;-1;-1;0;False;0;0;True;17;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;235;6;0
WireConnection;5;167;3;0
WireConnection;5;166;3;0
WireConnection;16;0;1;0
WireConnection;16;11;5;0
ASEEND*/
//CHKSM=23254439B4F1A4D1ED786AF87650F22805D0B548