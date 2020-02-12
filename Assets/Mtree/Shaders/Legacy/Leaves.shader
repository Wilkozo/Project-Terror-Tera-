// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Mtree/Leaves"
{
	Properties
	{
		[Header(Albedo Texture)]_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo", 2D) = "white" {}
		[Enum(Off,0,Front,1,Back,2)]_CullMode("Cull Mode", Int) = 0
		[Enum(Flip,0,Mirror,1,None,2)]_DoubleSidedNormalMode("Double Sided Normal Mode", Int) = 0
		_Cutoff("Cutoff", Range( 0 , 1)) = 0.5
		[Header(Normal Texture)]_BumpMap("Normal Map", 2D) = "bump" {}
		_BumpScale("Normal Strength", Float) = 1
		[Header(Color Settings)]_Hue("Hue", Range( -0.5 , 0.5)) = 0
		_Value("Value", Range( 0 , 3)) = 1
		_Saturation("Saturation", Range( 0 , 2)) = 1
		_ColorVariation("Color Variation", Range( 0 , 0.3)) = 0.15
		[Header(Smoothness)]_Glossiness("Smoothness", Range( 0 , 1)) = 0
		_GlossinessVariance("Smoothness Variance", Range( 0 , 1)) = 0
		_GlossinessThreshold("Smoothness Threshold", Range( 0 , 1)) = 0
		[Header(Other Settings)]_OcclusionStrength("AO strength", Range( 0 , 1)) = 0.6
		_Metallic("Metallic", Range( 0 , 1)) = 0
		[Header(Translucency)]_Scale("Scale", Range( 0.001 , 8)) = 2
		_Power("Power", Range( 0.001 , 8)) = 2
		_Distortion("Distortion", Range( 0.001 , 8)) = 2
		[Enum(Global,0,Custom,1)]_LightSouce("Light Souce", Int) = 0
		_TranslucentColor("Translucent Color", Color) = (1,1,1,1)
		[Enum(Default,0,Leaf,1,Palm,2,Grass,3)][Header(Wind)]_WindMode("Wind Mode", Int) = 0
		_GlobalWindInfluence("Global Wind Influence", Range( 0 , 1)) = 1
		_GlobalTurbulenceInfluence("Global Turbulence Influence", Range( 0 , 1)) = 1
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
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
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
			half ASEVFace : VFACE;
			float4 vertexColor : COLOR;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform int _WindMode;
		uniform float _WindStrength;
		uniform float _GlobalWindInfluence;
		uniform float _RandomWindOffset;
		uniform float _WindPulse;
		uniform float _WindDirection;
		uniform float _WindTurbulence;
		uniform float _GlobalTurbulenceInfluence;
		uniform int _DoubleSidedNormalMode;
		uniform int _CullMode;
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform half _BumpScale;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _ColorVariation;
		uniform half _Hue;
		uniform float _Saturation;
		uniform float _Value;
		uniform float _Distortion;
		uniform float _Power;
		uniform float _Scale;
		uniform int _LightSouce;
		uniform float4 _TranslucentColor;
		uniform float _Glossiness;
		uniform float _GlossinessVariance;
		uniform float _GlossinessThreshold;
		uniform half _OcclusionStrength;
		uniform float _Metallic;
		uniform half _Cutoff;


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


		float3 switch254_g316( int Enum , float3 zero , float3 one , float3 two , float3 three )
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


		float3 If4_g315( float Mode , float Cull , float3 Flip , float3 Mirror , float3 None )
		{
			float3 OUT = None;
			if(Cull == 0){
			    if(Mode == 0)
			        OUT = Flip;
			    if(Mode == 1)
			        OUT = Mirror;
			    if(Mode == 2)
			        OUT == None;
			}else{
			    OUT = None;
			}
			return OUT;
		}


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			int Enum254_g316 = _WindMode;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPosition255_g316 = mul( unity_ObjectToWorld, float4( ase_vertex3Pos , 0.0 ) ).xyz;
			float3 break261_g316 = vertexPosition255_g316;
			float2 appendResult196_g316 = (float2(break261_g316.x , break261_g316.z));
			float MainWind71_g316 = ( _WindStrength * _GlobalWindInfluence );
			float4 transform21_g317 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float2 appendResult22_g317 = (float2(transform21_g317.x , transform21_g317.z));
			float dotResult2_g317 = dot( ( appendResult22_g317 + float2( 0,0 ) ) , float2( 12.9898,78.233 ) );
			float lerpResult8_g317 = lerp( 0.8 , ( ( _RandomWindOffset / 2.0 ) + 0.9 ) , frac( ( sin( dotResult2_g317 ) * 43758.55 ) ));
			float RandomTime45_g316 = ( _Time.x * lerpResult8_g317 );
			float Turbulence58_g316 = ( sin( ( ( RandomTime45_g316 * 40.0 ) - ( (vertexPosition255_g316).z / 15.0 ) ) ) * 0.5 );
			float Angle89_g316 = ( MainWind71_g316 * ( 1.0 + sin( ( ( ( RandomTime45_g316 * 2.0 ) + Turbulence58_g316 ) - ( ( vertexPosition255_g316.z / 50.0 ) - ( v.color.r / 20.0 ) ) ) ) ) * sqrt( v.color.r ) * 0.02 * _WindPulse );
			float sin_a100_g316 = sin( Angle89_g316 );
			float cos_a119_g316 = cos( Angle89_g316 );
			float temp_output_99_0_g316 = radians( _WindDirection );
			float2 appendResult200_g316 = (float2(cos( temp_output_99_0_g316 ) , sin( temp_output_99_0_g316 )));
			float2 xzLerp129_g316 = ( ( appendResult200_g316 + 1 ) / 2 );
			float2 lerpResult140_g316 = lerp( appendResult196_g316 , ( ( appendResult196_g316 + ( break261_g316.y * sin_a100_g316 ) ) * cos_a119_g316 ) , (xzLerp129_g316).yx);
			float2 break204_g316 = lerpResult140_g316;
			float3 appendResult174_g316 = (float3(break204_g316.x , ( ( break261_g316.y * cos_a119_g316 ) - ( break261_g316.z * sin_a100_g316 ) ) , break204_g316.y));
			float3 v_pos175_g316 = appendResult174_g316;
			float3 zero254_g316 = v_pos175_g316;
			float3 break188_g316 = v_pos175_g316;
			float WindTurbulence110_g316 = ( _WindTurbulence * _GlobalTurbulenceInfluence );
			float leaf_turbulence135_g316 = ( sin( ( ( ( RandomTime45_g316 * 200.0 ) * ( v.color.g + 0.2 ) ) + ( v.color.g * 10.0 ) + Turbulence58_g316 + ( vertexPosition255_g316.z / 2.0 ) ) ) * v.color.b * ( ( MainWind71_g316 / 200.0 ) + Angle89_g316 ) * WindTurbulence110_g316 );
			float3 appendResult153_g316 = (float3(break188_g316.x , ( break188_g316.y + leaf_turbulence135_g316 ) , break188_g316.z));
			float3 one254_g316 = appendResult153_g316;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 appendResult184_g316 = (float3(( ase_normWorldNormal.x * v.color.g ) , ( ase_normWorldNormal.y / v.color.r ) , ( ase_normWorldNormal.z * v.color.g )));
			float3 two254_g316 = ( ( appendResult184_g316 * leaf_turbulence135_g316 ) + v_pos175_g316 );
			float3 break247_g316 = v_pos175_g316;
			float2 break241_g316 = xzLerp129_g316;
			float lerpResult238_g316 = lerp( 0.0 , leaf_turbulence135_g316 , break241_g316.x);
			float lerpResult242_g316 = lerp( 0.0 , leaf_turbulence135_g316 , break241_g316.y);
			float3 appendResult249_g316 = (float3(( break247_g316.x + lerpResult238_g316 ) , break247_g316.y , ( break247_g316.z + lerpResult242_g316 )));
			float3 three254_g316 = appendResult249_g316;
			float3 localswitch254_g316 = switch254_g316( Enum254_g316 , zero254_g316 , one254_g316 , two254_g316 , three254_g316 );
			v.vertex.xyz = mul( unity_WorldToObject, float4( localswitch254_g316 , 0.0 ) ).xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float Mode4_g315 = (float)_DoubleSidedNormalMode;
			float Cull4_g315 = (float)_CullMode;
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float3 bump5_g315 = UnpackScaleNormal( tex2D( _BumpMap, uv_BumpMap ), _BumpScale );
			float3 Flip4_g315 = ( bump5_g315 * i.ASEVFace );
			float3 break7_g315 = bump5_g315;
			float3 appendResult11_g315 = (float3(break7_g315.x , break7_g315.y , ( break7_g315.z * i.ASEVFace )));
			float3 Mirror4_g315 = appendResult11_g315;
			float3 None4_g315 = bump5_g315;
			float3 localIf4_g315 = If4_g315( Mode4_g315 , Cull4_g315 , Flip4_g315 , Mirror4_g315 , None4_g315 );
			o.Normal = localIf4_g315;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode13 = tex2D( _MainTex, uv_MainTex );
			float4 Albedo101 = ( _Color * tex2DNode13 );
			float3 hsvTorgb19 = RGBToHSV( Albedo101.rgb );
			float3 hsvTorgb38 = HSVToRGB( float3(( hsvTorgb19 + ( ( i.vertexColor.g - 0.5 ) * _ColorVariation ) + _Hue ).x,( hsvTorgb19.y * _Saturation ),( hsvTorgb19.z * _Value )) );
			float4 color31_g302 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
			float3 appendResult77_g302 = (float3(color31_g302.rgb));
			float temp_output_32_0_g302 = ( 1 * 2.0 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 normalizeResult11_g302 = normalize( ase_worldViewDir );
			float3 viewDir97_g302 = normalizeResult11_g302;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult12_g302 = normalize( ase_worldlightDir );
			float3 lightDir93_g302 = normalizeResult12_g302;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float dotResult23_g302 = dot( viewDir97_g302 , ( ( ( lightDir93_g302 + ase_worldNormal ) * _Distortion ) * -1.0 ) );
			float4 break38_g302 = Albedo101;
			float3 appendResult118_g302 = (float3(_TranslucentColor.rgb));
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 TranslucentCol119_g302 =  ( (float)_LightSouce - 0.0 > 0.0 ? appendResult118_g302 : (float)_LightSouce - 0.0 <= 0.0 && (float)_LightSouce + 0.0 >= 0.0 ? ase_lightColor.rgb : 0.0 ) ;
			float3 appendResult41_g302 = (float3(break38_g302.x , break38_g302.y , break38_g302.z));
			float dotResult50_g302 = dot( ase_worldNormal , lightDir93_g302 );
			float4 color69_g302 = IsGammaSpace() ? float4(0.5,0.5,0.5,1) : float4(0.2140411,0.2140411,0.2140411,1);
			float3 appendResult71_g302 = (float3(color69_g302.rgb));
			float3 normalizeResult46_g302 = normalize( ( lightDir93_g302 + viewDir97_g302 ) );
			float dotResult54_g302 = dot( ase_worldNormal , normalizeResult46_g302 );
			float perceptualSmoothness39 = _Glossiness;
			float3 geometricNormalWS39 = ase_worldNormal;
			float screenSpaceVariance39 = _GlossinessVariance;
			float threshold39 = _GlossinessThreshold;
			float localGetGeometricNormalVariance39 = GetGeometricNormalVariance( perceptualSmoothness39 , geometricNormalWS39 , screenSpaceVariance39 , threshold39 );
			float Smoothness50 = localGetGeometricNormalVariance39;
			float spec100_g302 = ( pow( max( 0.0 , dotResult54_g302 ) , ( 1.0 * 128.0 ) ) * Smoothness50 );
			float speca103_g302 = color69_g302.a;
			float4 appendResult75_g302 = (float4(( ( ( appendResult77_g302 * ( ( temp_output_32_0_g302 * ( pow( max( 0.0 , dotResult23_g302 ) , _Power ) * _Scale ) ) * break38_g302.w ) ) * ( TranslucentCol119_g302 * appendResult41_g302 ) ) + ( ( ( ( ( ( appendResult41_g302 * TranslucentCol119_g302 ) * max( 0.0 , dotResult50_g302 ) ) + TranslucentCol119_g302 ) * appendResult71_g302 ) * spec100_g302 ) * temp_output_32_0_g302 ) ) , ( ( ( ase_lightColor.a * speca103_g302 ) * spec100_g302 ) * 1 )));
			float lerpResult41 = lerp( 2.0 , i.vertexColor.a , _OcclusionStrength);
			float AO44 = lerpResult41;
			o.Albedo = ( ( float4( hsvTorgb38 , 0.0 ) + ( appendResult75_g302 * i.vertexColor.a * float4( hsvTorgb38 , 0.0 ) ) ) * AO44 ).xyz;
			o.Metallic = _Metallic;
			o.Smoothness = Smoothness50;
			clip( tex2DNode13.a - _Cutoff);
			float AlphaMask46 = tex2DNode13.a;
			o.Alpha = AlphaMask46;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=17500
34;89;1343;586;927.8979;461.4461;1.181047;True;False
Node;AmplifyShaderEditor.CommentaryNode;1;-3062.745,-1123.287;Inherit;False;1122.39;558.947;Albedo;9;51;46;32;30;14;13;11;10;101;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;10;-3026.142,-860.064;Float;True;Property;_MainTex;Albedo;1;0;Create;False;0;0;False;1;;None;8b0017825887ee44e83ac0cb49ceadf0;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ColorNode;11;-2711.997,-1039.753;Inherit;False;Property;_Color;Color;0;0;Create;True;0;0;False;1;Header(Albedo Texture);1,1,1,1;0.9174442,1,0.8382353,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;13;-2797.785,-859.193;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-2370.901,-878.1384;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;2;-1840.551,-1121.044;Inherit;False;1493.488;954.6044;Color Settings;17;54;49;38;27;28;22;19;21;17;20;18;15;16;12;102;216;217;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;4;-3009.102,388.5925;Inherit;False;1068.058;483.6455;Comment;6;50;39;29;26;25;23;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2953.37,773.2766;Float;False;Property;_GlossinessThreshold;Smoothness Threshold;14;0;Create;False;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-2963.272,448.2056;Inherit;False;Property;_Glossiness;Smoothness;12;0;Create;False;0;0;False;1;Header(Smoothness);0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-2959.102,678.6366;Float;False;Property;_GlossinessVariance;Smoothness Variance;13;0;Create;False;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;101;-2194.34,-854.3077;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;12;-1770.079,-1006.449;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;29;-2874.704,532.0186;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CustomExpressionNode;39;-2604.582,581.5456;Float;False;#define PerceptualSmoothnessToRoughness(perceptualSmoothness) (1.0 - perceptualSmoothness) * (1.0 - perceptualSmoothness)$#define RoughnessToPerceptualSmoothness(roughness) 1.0 - sqrt(roughness)$float3 deltaU = ddx(geometricNormalWS)@$float3 deltaV = ddy(geometricNormalWS)@$float variance = screenSpaceVariance * (dot(deltaU, deltaU) + dot(deltaV, deltaV))@$float roughness = PerceptualSmoothnessToRoughness(perceptualSmoothness)@$// Ref: Geometry into Shading - http://graphics.pixar.com/library/BumpRoughness/paper.pdf - equation (3)$float squaredRoughness = saturate(roughness * roughness + min(2.0 * variance, threshold * threshold))@ // threshold can be really low, square the value for easier$return RoughnessToPerceptualSmoothness(sqrt(squaredRoughness))@;1;False;4;True;perceptualSmoothness;FLOAT;0;In;;Float;False;True;geometricNormalWS;FLOAT3;0,0,0;In;;Float;False;True;screenSpaceVariance;FLOAT;0.5;In;;Float;False;True;threshold;FLOAT;0.5;In;;Float;False;GetGeometricNormalVariance;False;True;0;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0.5;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;-1422.356,-1045.862;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-1713.34,-782.3077;Inherit;False;101;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1549.556,-948.7612;Float;False;Property;_ColorVariation;Color Variation;11;0;Create;True;0;0;False;0;0.15;0.15;0;0.3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1533.596,-629.1736;Float;False;Property;_Saturation;Saturation;10;0;Create;True;0;0;False;0;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1245.357,-961.9563;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-2279.743,581.3916;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;19;-1486.634,-778.3936;Float;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;3;-3004.281,904.856;Inherit;False;789.6466;355.3238;AO;4;44;41;31;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1546.12,-862.4572;Half;False;Property;_Hue;Hue;8;0;Create;True;0;0;False;1;Header(Color Settings);0;0;-0.5;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1531.751,-548.0708;Float;False;Property;_Value;Value;9;0;Create;True;0;0;False;0;1;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1097.384,-729.265;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-1089.186,-860.0214;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-2954.281,1136.496;Half;False;Property;_OcclusionStrength;AO strength;15;0;Create;False;0;0;False;1;Header(Other Settings);0.6;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;5;-1839.721,-142.752;Inherit;False;1493.222;463.5325;Normals;5;53;48;108;47;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;216;-1329.064,-459.8107;Inherit;False;101;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;31;-2970.915,952.8558;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;217;-1352.064,-387.8107;Inherit;False;50;Smoothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1093.254,-635.1566;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2775.99,-663.3857;Half;False;Property;_Cutoff;Cutoff;5;0;Create;True;0;0;False;0;0.5;0.422;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;37;-1789.721,-88.45222;Float;True;Property;_BumpMap;Normal Map;6;0;Create;False;0;0;False;1;Header(Normal Texture);None;bdcffb5968b084b4490b00efe97041e3;True;bump;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.LerpOp;41;-2643.427,1097.343;Inherit;False;3;0;FLOAT;2;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;245;-1039.316,-454.6885;Inherit;False;Translucent;17;;302;31c572777d9de6b4a8b2748411bf4658;0;3;37;FLOAT4;0,0,0,0;False;62;FLOAT;1;False;58;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.HSVToRGBNode;38;-939.7856,-730.908;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;48;-1451.371,133.5333;Half;False;Property;_BumpScale;Normal Strength;7;0;Create;False;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;6;-1836.591,364.7846;Inherit;False;1235.482;529.9922;Wind;3;74;43;77;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClipNode;32;-2409.253,-710.3296;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;44;-2472.646,1095.948;Inherit;False;AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-695.2146,-573.8313;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;47;-1538.721,-62.45196;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;77;-1603.771,555.9008;Inherit;False;Property;_GlobalWindInfluence;Global Wind Influence;24;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;108;-1128.812,130.5641;Inherit;False;Property;_CullMode;Cull Mode;2;1;[Enum];Create;True;3;Off;0;Front;1;Back;2;0;True;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1620.732,635.7382;Inherit;False;Property;_GlobalTurbulenceInfluence;Global Turbulence Influence;25;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;74;-1493.075,477.5758;Inherit;False;Property;_WindMode;Wind Mode;23;1;[Enum];Create;True;4;Default;0;Leaf;1;Palm;2;Grass;3;0;False;1;Header(Wind);0;1;0;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-2163.651,-714.051;Inherit;False;AlphaMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;53;-1213.393,-62.87763;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-524.5686,-623.2985;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;7;-297.5982,-164.3272;Inherit;False;44;AO;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;246;-794.7278,-61.63486;Inherit;False;Double Sided Backface Switch;3;;315;243a51f22b364cf4eac05d94dacd3901;0;2;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;8;-256.05,225.4026;Inherit;False;46;AlphaMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;250;-1218.598,516.7045;Inherit;False;Mtree Wind Node;-1;;316;64b78a30028980947ab723bea7191537;0;3;235;INT;0;False;167;FLOAT;0;False;166;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;222;-269.3214,2.728832;Inherit;False;Property;_Metallic;Metallic;16;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-3030.017,-983.7396;Inherit;False;Constant;_MaskClipValue;Mask Clip Value;14;1;[HideInInspector];Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;251;-66.91472,-185.0812;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;9;-269.6682,77.80556;Inherit;False;50;Smoothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;213;106.1244,-74.85284;Float;False;True;-1;2;;0;0;Standard;Mtree/Leaves;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.422;True;True;0;True;TransparentCutout;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;-1;-1;-1;-1;0;False;0;0;True;108;-1;0;True;51;3;Pragma;instancing_options procedural:setup;False;;Custom;Pragma;multi_compile GPU_FRUSTUM_ON __;False;;Custom;Include;;True;a6d16d0571c954c4bbcc7edb6344bb7c;Custom;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;0;10;0
WireConnection;14;0;11;0
WireConnection;14;1;13;0
WireConnection;101;0;14;0
WireConnection;39;0;26;0
WireConnection;39;1;29;0
WireConnection;39;2;23;0
WireConnection;39;3;25;0
WireConnection;16;0;12;2
WireConnection;21;0;16;0
WireConnection;21;1;15;0
WireConnection;50;0;39;0
WireConnection;19;0;102;0
WireConnection;27;0;19;2
WireConnection;27;1;18;0
WireConnection;28;0;19;0
WireConnection;28;1;21;0
WireConnection;28;2;20;0
WireConnection;22;0;19;3
WireConnection;22;1;17;0
WireConnection;41;1;31;4
WireConnection;41;2;24;0
WireConnection;245;37;216;0
WireConnection;245;62;217;0
WireConnection;38;0;28;0
WireConnection;38;1;27;0
WireConnection;38;2;22;0
WireConnection;32;0;13;4
WireConnection;32;1;13;4
WireConnection;32;2;30;0
WireConnection;44;0;41;0
WireConnection;49;0;245;0
WireConnection;49;1;12;4
WireConnection;49;2;38;0
WireConnection;47;0;37;0
WireConnection;46;0;32;0
WireConnection;53;0;47;0
WireConnection;53;1;48;0
WireConnection;54;0;38;0
WireConnection;54;1;49;0
WireConnection;246;1;53;0
WireConnection;246;2;108;0
WireConnection;250;235;74;0
WireConnection;250;167;77;0
WireConnection;250;166;43;0
WireConnection;251;0;54;0
WireConnection;251;1;7;0
WireConnection;213;0;251;0
WireConnection;213;1;246;0
WireConnection;213;3;222;0
WireConnection;213;4;9;0
WireConnection;213;9;8;0
WireConnection;213;11;250;0
ASEEND*/
//CHKSM=1FEE62968A6AF21A88980735388DFD79AB1C494C