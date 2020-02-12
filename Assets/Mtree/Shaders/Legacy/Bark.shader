// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Mtree/Bark"
{
	Properties
	{
		[Header(Albedo Texture)]_Color("Color", Color) = (1,1,1,0)
		_MainTex("Albedo", 2D) = "white" {}
		[Enum(Off,0,Front,1,Back,2)]_CullMode("Cull Mode", Int) = 2
		[Header(Normal Texture)]_BumpMap("Normal", 2D) = "bump" {}
		_BumpScale("Normal Strength", Float) = 1
		[Enum(On,0,Off,1)][Header(Detail Settings)]_BaseDetail("Base Detail", Int) = 1
		_DetailColor("Detail Color", Color) = (1,1,1,0)
		_DetailAlbedoMap("Detail", 2D) = "white" {}
		_DetailNormalMap("Detail Normal", 2D) = "bump" {}
		_Height("Height", Range( 0 , 1)) = 0
		_Smooth("Smooth", Range( 0.01 , 0.5)) = 0.02
		_TextureInfluence("Texture Influence", Range( 0 , 1)) = 0.5
		[Header(Smoothness)]_Glossiness("Smoothness", Range( 0 , 1)) = 0
		_GlossinessVariance("Smoothness Variance", Range( 0 , 1)) = 0
		_GlossinessThreshold("Smoothness Threshold", Range( 0 , 1)) = 0
		[Header(Other Settings)]_OcclusionStrength("AO strength", Range( 0 , 1)) = 0.6
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_GlobalWindInfluence("Global Wind Influence", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
		#include "UnityStandardUtils.cginc"
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
			float4 vertexColor : COLOR;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform int _CullMode;
		uniform float _WindStrength;
		uniform float _GlobalWindInfluence;
		uniform float _RandomWindOffset;
		uniform float _WindPulse;
		uniform float _WindDirection;
		uniform float _WindTurbulence;
		uniform int _BaseDetail;
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform half _BumpScale;
		uniform sampler2D _DetailNormalMap;
		uniform float4 _DetailNormalMap_ST;
		uniform half _Height;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform half _TextureInfluence;
		uniform half _Smooth;
		uniform float4 _Color;
		uniform float4 _DetailColor;
		uniform sampler2D _DetailAlbedoMap;
		uniform float4 _DetailAlbedoMap_ST;
		uniform half _OcclusionStrength;
		uniform float _Metallic;
		uniform float _Glossiness;
		uniform float _GlossinessVariance;
		uniform float _GlossinessThreshold;


		float GetGeometricNormalVariance( float perceptualSmoothness , float3 geometricNormalWS , float screenSpaceVariance , float threshold )
		{
			#define PerceptualSmoothnessToRoughness(perceptualSmoothness) (1.0 - perceptualSmoothness) * (1.0 - perceptualSmoothness)
			#define RoughnessToPerceptualSmoothness(roughness) 1.0 - sqrt(roughness)
			float3 deltaU = ddx(geometricNormalWS);
			float3 deltaV = ddy(geometricNormalWS);
			float variance = screenSpaceVariance * (dot(deltaU, deltaU) + dot(deltaV, deltaV));
			float roughness = PerceptualSmoothnessToRoughness(perceptualSmoothness);
			// Ref: Geometry into Shading - http://graphics.pixar.com/library/BumpRoughness/paper.pdf - equation (3)
			float squaredRoughness = saturate(roughness * roughness + min(2.0 * variance, threshold * threshold)); // threshold can be really low, square the value for easier
			return RoughnessToPerceptualSmoothness(sqrt(squaredRoughness));
		}


		float3 switch254_g123( int Enum , float3 zero , float3 one , float3 two , float3 three )
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
			int Enum254_g123 = 0;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPosition255_g123 = mul( unity_ObjectToWorld, float4( ase_vertex3Pos , 0.0 ) ).xyz;
			float3 break261_g123 = vertexPosition255_g123;
			float2 appendResult196_g123 = (float2(break261_g123.x , break261_g123.z));
			float MainWind71_g123 = ( _WindStrength * _GlobalWindInfluence );
			float4 transform21_g124 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float2 appendResult22_g124 = (float2(transform21_g124.x , transform21_g124.z));
			float dotResult2_g124 = dot( ( appendResult22_g124 + float2( 0,0 ) ) , float2( 12.9898,78.233 ) );
			float lerpResult8_g124 = lerp( 0.8 , ( ( _RandomWindOffset / 2.0 ) + 0.9 ) , frac( ( sin( dotResult2_g124 ) * 43758.55 ) ));
			float RandomTime45_g123 = ( _Time.x * lerpResult8_g124 );
			float Turbulence58_g123 = ( sin( ( ( RandomTime45_g123 * 40.0 ) - ( (vertexPosition255_g123).z / 15.0 ) ) ) * 0.5 );
			float Angle89_g123 = ( MainWind71_g123 * ( 1.0 + sin( ( ( ( RandomTime45_g123 * 2.0 ) + Turbulence58_g123 ) - ( ( vertexPosition255_g123.z / 50.0 ) - ( v.color.r / 20.0 ) ) ) ) ) * sqrt( v.color.r ) * 0.02 * _WindPulse );
			float sin_a100_g123 = sin( Angle89_g123 );
			float cos_a119_g123 = cos( Angle89_g123 );
			float temp_output_99_0_g123 = radians( _WindDirection );
			float2 appendResult200_g123 = (float2(cos( temp_output_99_0_g123 ) , sin( temp_output_99_0_g123 )));
			float2 xzLerp129_g123 = ( ( appendResult200_g123 + 1 ) / 2 );
			float2 lerpResult140_g123 = lerp( appendResult196_g123 , ( ( appendResult196_g123 + ( break261_g123.y * sin_a100_g123 ) ) * cos_a119_g123 ) , (xzLerp129_g123).yx);
			float2 break204_g123 = lerpResult140_g123;
			float3 appendResult174_g123 = (float3(break204_g123.x , ( ( break261_g123.y * cos_a119_g123 ) - ( break261_g123.z * sin_a100_g123 ) ) , break204_g123.y));
			float3 v_pos175_g123 = appendResult174_g123;
			float3 zero254_g123 = v_pos175_g123;
			float3 break188_g123 = v_pos175_g123;
			float WindTurbulence110_g123 = ( _WindTurbulence * 0.0 );
			float leaf_turbulence135_g123 = ( sin( ( ( ( RandomTime45_g123 * 200.0 ) * ( v.color.g + 0.2 ) ) + ( v.color.g * 10.0 ) + Turbulence58_g123 + ( vertexPosition255_g123.z / 2.0 ) ) ) * v.color.b * ( ( MainWind71_g123 / 200.0 ) + Angle89_g123 ) * WindTurbulence110_g123 );
			float3 appendResult153_g123 = (float3(break188_g123.x , ( break188_g123.y + leaf_turbulence135_g123 ) , break188_g123.z));
			float3 one254_g123 = appendResult153_g123;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 appendResult184_g123 = (float3(( ase_normWorldNormal.x * v.color.g ) , ( ase_normWorldNormal.y / v.color.r ) , ( ase_normWorldNormal.z * v.color.g )));
			float3 two254_g123 = ( ( appendResult184_g123 * leaf_turbulence135_g123 ) + v_pos175_g123 );
			float3 break247_g123 = v_pos175_g123;
			float2 break241_g123 = xzLerp129_g123;
			float lerpResult238_g123 = lerp( 0.0 , leaf_turbulence135_g123 , break241_g123.x);
			float lerpResult242_g123 = lerp( 0.0 , leaf_turbulence135_g123 , break241_g123.y);
			float3 appendResult249_g123 = (float3(( break247_g123.x + lerpResult238_g123 ) , break247_g123.y , ( break247_g123.z + lerpResult242_g123 )));
			float3 three254_g123 = appendResult249_g123;
			float3 localswitch254_g123 = switch254_g123( Enum254_g123 , zero254_g123 , one254_g123 , two254_g123 , three254_g123 );
			v.vertex.xyz = mul( unity_WorldToObject, float4( localswitch254_g123 , 0.0 ) ).xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float2 uv_DetailNormalMap = i.uv_texcoord * _DetailNormalMap_ST.xy + _DetailNormalMap_ST.zw;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 AlbedoTexture132 = tex2D( _MainTex, uv_MainTex );
			float4 break93 = AlbedoTexture132;
			float clampResult70 = clamp( ( ( ( i.vertexColor.r - _Height ) + ( ( ( break93.r + break93.g + break93.b ) - 0.5 ) * _TextureInfluence ) ) / _Smooth ) , 0.0 , 1.0 );
			float BarkDamageBlend137 = clampResult70;
			float3 lerpResult73 = lerp( UnpackScaleNormal( tex2D( _DetailNormalMap, uv_DetailNormalMap ), _BumpScale ) , UnpackScaleNormal( tex2D( _BumpMap, uv_BumpMap ), _BumpScale ) , BarkDamageBlend137);
			float3 ifLocalVar184 = 0;
			if( _BaseDetail > 0.0 )
				ifLocalVar184 = UnpackScaleNormal( tex2D( _BumpMap, uv_BumpMap ), _BumpScale );
			else if( _BaseDetail == 0.0 )
				ifLocalVar184 = lerpResult73;
			o.Normal = ifLocalVar184;
			float4 temp_output_94_0 = ( AlbedoTexture132 * _Color );
			float2 uv_DetailAlbedoMap = i.uv_texcoord * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
			float4 lerpResult89 = lerp( ( _DetailColor * tex2D( _DetailAlbedoMap, uv_DetailAlbedoMap ) ) , temp_output_94_0 , BarkDamageBlend137);
			float4 ifLocalVar183 = 0;
			if( _BaseDetail > 0.0 )
				ifLocalVar183 = temp_output_94_0;
			else if( _BaseDetail == 0.0 )
				ifLocalVar183 = lerpResult89;
			float lerpResult40 = lerp( 1.0 , i.vertexColor.a , _OcclusionStrength);
			float AO204 = lerpResult40;
			o.Albedo = ( ifLocalVar183 * AO204 ).rgb;
			o.Metallic = _Metallic;
			float perceptualSmoothness103 = _Glossiness;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 geometricNormalWS103 = ase_worldNormal;
			float screenSpaceVariance103 = _GlossinessVariance;
			float threshold103 = _GlossinessThreshold;
			float localGetGeometricNormalVariance103 = GetGeometricNormalVariance( perceptualSmoothness103 , geometricNormalWS103 , screenSpaceVariance103 , threshold103 );
			float smoothnessMixed105 = localGetGeometricNormalVariance103;
			o.Smoothness = smoothnessMixed105;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=17500
34;89;1343;586;274.7715;375.0492;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;62;-1973.925,-1536.524;Inherit;False;1513.586;813.0795;;13;94;89;88;80;79;78;75;67;65;132;138;181;183;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;80;-1825.863,-1033.057;Float;True;Property;_MainTex;Albedo;1;0;Create;False;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;79;-1561.944,-1084.441;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;63;-3719.749,-1532.3;Inherit;False;1643.232;779.4377;;14;66;70;85;87;84;90;81;82;83;68;92;93;133;137;Bark Damage Blend;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;-1267.396,-1081.275;Inherit;False;AlbedoTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;-3681.569,-1104.222;Inherit;False;132;AlbedoTexture;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;93;-3442.833,-1099.605;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-3145.315,-1165.81;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-3209.13,-1359.019;Half;False;Property;_TextureInfluence;Texture Influence;11;0;Create;True;0;0;False;0;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-3237.036,-871.6853;Half;False;Property;_Height;Height;9;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;82;-3152.854,-1033.099;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;81;-3030.867,-1476.276;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-2852.797,-1377.72;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;90;-2911.169,-1048.271;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;-2746.325,-1037.291;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-3029.416,-1227.209;Half;False;Property;_Smooth;Smooth;10;0;Create;True;0;0;False;0;0.02;0.02;0.01;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;66;-2610.113,-1036.309;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;78;-1800.048,-1321.463;Float;True;Property;_DetailAlbedoMap;Detail;7;0;Create;False;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;111;-1004.02,87.42179;Inherit;False;789.0012;362.734;;4;40;38;39;204;AO;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;70;-2484.016,-1035.081;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;64;-2008.856,-613.656;Inherit;False;1548.867;573.6572;;10;86;77;76;74;73;72;71;69;139;184;Normals;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;67;-1561.896,-1317.991;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;65;-1798.434,-1491.869;Float;False;Property;_DetailColor;Detail Color;6;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;-2311.651,-1032.488;Inherit;False;BarkDamageBlend;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;75;-1493.165,-885.1214;Float;False;Property;_Color;Color;0;0;Create;True;0;0;False;1;Header(Albedo Texture);1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;39;-959.0199,138.7559;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;86;-1914.669,-266.2305;Float;True;Property;_BumpMap;Normal;3;0;Create;False;0;0;False;1;Header(Normal Texture);None;None;True;bump;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;109;-3437.689,-600.3625;Inherit;False;1288.315;497.5828;Comment;6;98;101;102;103;100;105;Smoothness;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;74;-1921.855,-567.1551;Float;True;Property;_DetailNormalMap;Detail Normal;8;0;Create;False;0;0;False;0;None;None;True;bump;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-962.0718,304.0858;Half;False;Property;_OcclusionStrength;AO strength;15;0;Create;False;0;0;False;1;Header(Other Settings);0.6;0.682;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-1139.046,-1431.373;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;40;-591.0181,137.4218;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-1216.248,-1162.403;Inherit;False;137;BarkDamageBlend;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-1037.527,-1037.099;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;98;-3303.291,-456.9365;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;69;-1490.999,-364.0097;Half;False;Property;_BumpScale;Normal Strength;4;0;Create;False;0;0;False;0;1;1.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-3382.701,-550.3624;Float;False;Property;_Glossiness;Smoothness;12;0;Create;False;0;0;False;1;Header(Smoothness);0;0.209;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-3384.28,-217.2798;Float;False;Property;_GlossinessThreshold;Smoothness Threshold;14;0;Create;False;0;0;False;0;0;0.318;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-3388.949,-310.3199;Float;False;Property;_GlossinessVariance;Smoothness Variance;13;0;Create;False;0;0;False;0;0;0.397;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;77;-1667.874,-269.9987;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;76;-1651.893,-563.6559;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;176;-933.2706,-699.5867;Inherit;False;Property;_BaseDetail;Base Detail;5;1;[Enum];Create;True;2;On;0;Off;1;0;False;1;Header(Detail Settings);1;0;0;1;INT;0
Node;AmplifyShaderEditor.LerpOp;89;-879.6074,-1176.063;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;204;-443.8072,135.3569;Inherit;False;AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;71;-1258.948,-472.1585;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.UnpackScaleNormalNode;72;-1256.158,-299.0885;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CustomExpressionNode;103;-3017.938,-400.0432;Float;False;#define PerceptualSmoothnessToRoughness(perceptualSmoothness) (1.0 - perceptualSmoothness) * (1.0 - perceptualSmoothness)$#define RoughnessToPerceptualSmoothness(roughness) 1.0 - sqrt(roughness)$float3 deltaU = ddx(geometricNormalWS)@$float3 deltaV = ddy(geometricNormalWS)@$float variance = screenSpaceVariance * (dot(deltaU, deltaU) + dot(deltaV, deltaV))@$float roughness = PerceptualSmoothnessToRoughness(perceptualSmoothness)@$// Ref: Geometry into Shading - http://graphics.pixar.com/library/BumpRoughness/paper.pdf - equation (3)$float squaredRoughness = saturate(roughness * roughness + min(2.0 * variance, threshold * threshold))@ // threshold can be really low, square the value for easier$return RoughnessToPerceptualSmoothness(sqrt(squaredRoughness))@;1;False;4;True;perceptualSmoothness;FLOAT;0;In;;Float;False;True;geometricNormalWS;FLOAT3;0,0,0;In;;Float;False;True;screenSpaceVariance;FLOAT;0.5;In;;Float;False;True;threshold;FLOAT;0.5;In;;Float;False;GetGeometricNormalVariance;False;True;0;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0.5;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-1266.494,-556.2476;Inherit;False;137;BarkDamageBlend;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;206;243.2285,-200.0492;Inherit;False;204;AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;183;-634.4489,-909.9493;Inherit;False;False;5;0;INT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;-2543.59,-405.7707;Inherit;False;smoothnessMixed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;172;-341.7445,472.194;Inherit;False;Property;_GlobalWindInfluence;Global Wind Influence;17;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;73;-918.8367,-418.8563;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;195;152.0952,15.93149;Inherit;False;Property;_Metallic;Metallic;16;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;183.5301,87.84405;Inherit;False;105;smoothnessMixed;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;499.2285,-223.0492;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;203;-3.878095,454.0785;Inherit;False;Mtree Wind Node;-1;;123;64b78a30028980947ab723bea7191537;0;3;235;INT;0;False;167;FLOAT;0;False;166;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ConditionalIfNode;184;-636.5781,-385.2496;Inherit;False;False;5;0;INT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;181;-789.5757,-1451.361;Inherit;False;Property;_CullMode;Cull Mode;2;1;[Enum];Create;True;3;Off;0;Front;1;Back;2;0;True;0;2;0;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;194;646.6631,-0.9847908;Float;False;True;-1;2;;0;0;Standard;Mtree/Bark;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;-1;-1;-1;-1;0;False;0;0;True;181;-1;0;False;-1;3;Pragma;instancing_options procedural:setup;False;;Custom;Pragma;multi_compile GPU_FRUSTUM_ON __;False;;Custom;Include;;True;a6d16d0571c954c4bbcc7edb6344bb7c;Custom;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;79;0;80;0
WireConnection;132;0;79;0
WireConnection;93;0;133;0
WireConnection;92;0;93;0
WireConnection;92;1;93;1
WireConnection;92;2;93;2
WireConnection;81;0;92;0
WireConnection;84;0;81;0
WireConnection;84;1;83;0
WireConnection;90;0;82;1
WireConnection;90;1;68;0
WireConnection;85;0;90;0
WireConnection;85;1;84;0
WireConnection;66;0;85;0
WireConnection;66;1;87;0
WireConnection;70;0;66;0
WireConnection;67;0;78;0
WireConnection;137;0;70;0
WireConnection;88;0;65;0
WireConnection;88;1;67;0
WireConnection;40;1;39;4
WireConnection;40;2;38;0
WireConnection;94;0;132;0
WireConnection;94;1;75;0
WireConnection;77;0;86;0
WireConnection;76;0;74;0
WireConnection;89;0;88;0
WireConnection;89;1;94;0
WireConnection;89;2;138;0
WireConnection;204;0;40;0
WireConnection;71;0;76;0
WireConnection;71;1;69;0
WireConnection;72;0;77;0
WireConnection;72;1;69;0
WireConnection;103;0;100;0
WireConnection;103;1;98;0
WireConnection;103;2;101;0
WireConnection;103;3;102;0
WireConnection;183;0;176;0
WireConnection;183;2;94;0
WireConnection;183;3;89;0
WireConnection;105;0;103;0
WireConnection;73;0;71;0
WireConnection;73;1;72;0
WireConnection;73;2;139;0
WireConnection;205;0;183;0
WireConnection;205;1;206;0
WireConnection;203;167;172;0
WireConnection;184;0;176;0
WireConnection;184;2;72;0
WireConnection;184;3;73;0
WireConnection;194;0;205;0
WireConnection;194;1;184;0
WireConnection;194;3;195;0
WireConnection;194;4;108;0
WireConnection;194;11;203;0
ASEEND*/
//CHKSM=F3353AD548ADF6AF1B102B7D9CF519D7A9E9985E