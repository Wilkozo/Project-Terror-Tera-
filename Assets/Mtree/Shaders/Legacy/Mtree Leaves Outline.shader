// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Mtree/Leaves Outline"
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
		[Header(Toon Settings)]_ToonRamp("Toon Ramp", 2D) = "white" {}
		_ToonStyle("Toon Style", Range( 0 , 1)) = 1
		_OutlineColor("Outline Color", Color) = (0,0,0,0)
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
		ZWrite On
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
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
		uniform float4 _OutlineColor;
		uniform float4 _MainTex_TexelSize;
		uniform float _ToonStyle;
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
		uniform sampler2D _ToonRamp;
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


		float3 switch254_g320( int Enum , float3 zero , float3 one , float3 two , float3 three )
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


		float3 If4_g322( float Mode , float Cull , float3 Flip , float3 Mirror , float3 None )
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
			int Enum254_g320 = _WindMode;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPosition255_g320 = mul( unity_ObjectToWorld, float4( ase_vertex3Pos , 0.0 ) ).xyz;
			float3 break261_g320 = vertexPosition255_g320;
			float2 appendResult196_g320 = (float2(break261_g320.x , break261_g320.z));
			float MainWind71_g320 = ( _WindStrength * _GlobalWindInfluence );
			float4 transform21_g321 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float2 appendResult22_g321 = (float2(transform21_g321.x , transform21_g321.z));
			float dotResult2_g321 = dot( ( appendResult22_g321 + float2( 0,0 ) ) , float2( 12.9898,78.233 ) );
			float lerpResult8_g321 = lerp( 0.8 , ( ( _RandomWindOffset / 2.0 ) + 0.9 ) , frac( ( sin( dotResult2_g321 ) * 43758.55 ) ));
			float RandomTime45_g320 = ( _Time.x * lerpResult8_g321 );
			float Turbulence58_g320 = ( sin( ( ( RandomTime45_g320 * 40.0 ) - ( (vertexPosition255_g320).z / 15.0 ) ) ) * 0.5 );
			float Angle89_g320 = ( MainWind71_g320 * ( 1.0 + sin( ( ( ( RandomTime45_g320 * 2.0 ) + Turbulence58_g320 ) - ( ( vertexPosition255_g320.z / 50.0 ) - ( v.color.r / 20.0 ) ) ) ) ) * sqrt( v.color.r ) * 0.02 * _WindPulse );
			float sin_a100_g320 = sin( Angle89_g320 );
			float cos_a119_g320 = cos( Angle89_g320 );
			float temp_output_99_0_g320 = radians( _WindDirection );
			float2 appendResult200_g320 = (float2(cos( temp_output_99_0_g320 ) , sin( temp_output_99_0_g320 )));
			float2 xzLerp129_g320 = ( ( appendResult200_g320 + 1 ) / 2 );
			float2 lerpResult140_g320 = lerp( appendResult196_g320 , ( ( appendResult196_g320 + ( break261_g320.y * sin_a100_g320 ) ) * cos_a119_g320 ) , (xzLerp129_g320).yx);
			float2 break204_g320 = lerpResult140_g320;
			float3 appendResult174_g320 = (float3(break204_g320.x , ( ( break261_g320.y * cos_a119_g320 ) - ( break261_g320.z * sin_a100_g320 ) ) , break204_g320.y));
			float3 v_pos175_g320 = appendResult174_g320;
			float3 zero254_g320 = v_pos175_g320;
			float3 break188_g320 = v_pos175_g320;
			float WindTurbulence110_g320 = ( _WindTurbulence * _GlobalTurbulenceInfluence );
			float leaf_turbulence135_g320 = ( sin( ( ( ( RandomTime45_g320 * 200.0 ) * ( v.color.g + 0.2 ) ) + ( v.color.g * 10.0 ) + Turbulence58_g320 + ( vertexPosition255_g320.z / 2.0 ) ) ) * v.color.b * ( ( MainWind71_g320 / 200.0 ) + Angle89_g320 ) * WindTurbulence110_g320 );
			float3 appendResult153_g320 = (float3(break188_g320.x , ( break188_g320.y + leaf_turbulence135_g320 ) , break188_g320.z));
			float3 one254_g320 = appendResult153_g320;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 appendResult184_g320 = (float3(( ase_normWorldNormal.x * v.color.g ) , ( ase_normWorldNormal.y / v.color.r ) , ( ase_normWorldNormal.z * v.color.g )));
			float3 two254_g320 = ( ( appendResult184_g320 * leaf_turbulence135_g320 ) + v_pos175_g320 );
			float3 break247_g320 = v_pos175_g320;
			float2 break241_g320 = xzLerp129_g320;
			float lerpResult238_g320 = lerp( 0.0 , leaf_turbulence135_g320 , break241_g320.x);
			float lerpResult242_g320 = lerp( 0.0 , leaf_turbulence135_g320 , break241_g320.y);
			float3 appendResult249_g320 = (float3(( break247_g320.x + lerpResult238_g320 ) , break247_g320.y , ( break247_g320.z + lerpResult242_g320 )));
			float3 three254_g320 = appendResult249_g320;
			float3 localswitch254_g320 = switch254_g320( Enum254_g320 , zero254_g320 , one254_g320 , two254_g320 , three254_g320 );
			v.vertex.xyz += ( mul( unity_WorldToObject, float4( localswitch254_g320 , 0.0 ) ).xyz - ase_vertex3Pos );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float Mode4_g322 = (float)_DoubleSidedNormalMode;
			float Cull4_g322 = (float)_CullMode;
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float3 bump5_g322 = UnpackScaleNormal( tex2D( _BumpMap, uv_BumpMap ), _BumpScale );
			float3 Flip4_g322 = ( bump5_g322 * i.ASEVFace );
			float3 break7_g322 = bump5_g322;
			float3 appendResult11_g322 = (float3(break7_g322.x , break7_g322.y , ( break7_g322.z * i.ASEVFace )));
			float3 Mirror4_g322 = appendResult11_g322;
			float3 None4_g322 = bump5_g322;
			float3 localIf4_g322 = If4_g322( Mode4_g322 , Cull4_g322 , Flip4_g322 , Mirror4_g322 , None4_g322 );
			o.Normal = localIf4_g322;
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode294 = tex2D( _MainTex, uv0_MainTex );
			float2 appendResult281 = (float2(_MainTex_TexelSize.x , 0.0));
			float2 appendResult283 = (float2(0.0 , _MainTex_TexelSize.y));
			float lerpResult349 = lerp( 1.0 , 10.0 , _ToonStyle);
			float4 lerpResult299 = lerp( ( _Color * tex2DNode294 ) , _OutlineColor , ( tex2DNode294.a * ( 1.0 - ( tex2D( _MainTex, ( uv0_MainTex + appendResult281 ) ).a * tex2D( _MainTex, ( uv0_MainTex - appendResult281 ) ).a * tex2D( _MainTex, ( uv0_MainTex + appendResult283 ) ).a * tex2D( _MainTex, ( uv0_MainTex - appendResult283 ) ).a * lerpResult349 ) ) ));
			float4 Albedo339 = lerpResult299;
			float3 hsvTorgb19 = RGBToHSV( Albedo339.rgb );
			float3 hsvTorgb38 = HSVToRGB( float3(( hsvTorgb19 + ( ( i.vertexColor.g - 0.5 ) * _ColorVariation ) + _Hue ).x,( hsvTorgb19.y * _Saturation ),( hsvTorgb19.z * _Value )) );
			float4 color31_g315 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
			float3 appendResult77_g315 = (float3(color31_g315.rgb));
			float temp_output_32_0_g315 = ( 1 * 2.0 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 normalizeResult11_g315 = normalize( ase_worldViewDir );
			float3 viewDir97_g315 = normalizeResult11_g315;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult12_g315 = normalize( ase_worldlightDir );
			float3 lightDir93_g315 = normalizeResult12_g315;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float dotResult23_g315 = dot( viewDir97_g315 , ( ( ( lightDir93_g315 + ase_worldNormal ) * _Distortion ) * -1.0 ) );
			float4 break38_g315 = Albedo339;
			float3 appendResult118_g315 = (float3(_TranslucentColor.rgb));
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 TranslucentCol119_g315 =  ( (float)_LightSouce - 0.0 > 0.0 ? appendResult118_g315 : (float)_LightSouce - 0.0 <= 0.0 && (float)_LightSouce + 0.0 >= 0.0 ? ase_lightColor.rgb : 0.0 ) ;
			float3 appendResult41_g315 = (float3(break38_g315.x , break38_g315.y , break38_g315.z));
			float dotResult50_g315 = dot( ase_worldNormal , lightDir93_g315 );
			float4 color69_g315 = IsGammaSpace() ? float4(0.5,0.5,0.5,1) : float4(0.2140411,0.2140411,0.2140411,1);
			float3 appendResult71_g315 = (float3(color69_g315.rgb));
			float3 normalizeResult46_g315 = normalize( ( lightDir93_g315 + viewDir97_g315 ) );
			float dotResult54_g315 = dot( ase_worldNormal , normalizeResult46_g315 );
			float perceptualSmoothness39 = _Glossiness;
			float3 geometricNormalWS39 = ase_worldNormal;
			float screenSpaceVariance39 = _GlossinessVariance;
			float threshold39 = _GlossinessThreshold;
			float localGetGeometricNormalVariance39 = GetGeometricNormalVariance( perceptualSmoothness39 , geometricNormalWS39 , screenSpaceVariance39 , threshold39 );
			float Smoothness50 = localGetGeometricNormalVariance39;
			float spec100_g315 = ( pow( max( 0.0 , dotResult54_g315 ) , ( 1.0 * 128.0 ) ) * Smoothness50 );
			float speca103_g315 = color69_g315.a;
			float4 appendResult75_g315 = (float4(( ( ( appendResult77_g315 * ( ( temp_output_32_0_g315 * ( pow( max( 0.0 , dotResult23_g315 ) , _Power ) * _Scale ) ) * break38_g315.w ) ) * ( TranslucentCol119_g315 * appendResult41_g315 ) ) + ( ( ( ( ( ( appendResult41_g315 * TranslucentCol119_g315 ) * max( 0.0 , dotResult50_g315 ) ) + TranslucentCol119_g315 ) * appendResult71_g315 ) * spec100_g315 ) * temp_output_32_0_g315 ) ) , ( ( ( ase_lightColor.a * speca103_g315 ) * spec100_g315 ) * 1 )));
			float dotResult269 = dot( ase_worldNormal , ase_worldlightDir );
			float2 temp_cast_12 = (saturate( (dotResult269*0.5 + 0.5) )).xx;
			float4 ColorRamp274 = tex2D( _ToonRamp, temp_cast_12 );
			float lerpResult41 = lerp( 2.0 , i.vertexColor.a , _OcclusionStrength);
			float AO44 = lerpResult41;
			o.Albedo = ( ( float4( hsvTorgb38 , 0.0 ) + ( appendResult75_g315 * i.vertexColor.a * float4( hsvTorgb38 , 0.0 ) ) ) * ColorRamp274 * AO44 ).xyz;
			o.Metallic = _Metallic;
			o.Smoothness = Smoothness50;
			clip( lerpResult299.a - _Cutoff);
			float Alpha340 = lerpResult299.a;
			o.Alpha = Alpha340;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=17500
100;584;1343;586;6790.105;1935.249;6.039587;True;False
Node;AmplifyShaderEditor.CommentaryNode;278;-6144.91,-1081.753;Inherit;False;4207.745;1428.862;Outline Leafes;29;346;51;340;32;303;30;339;299;297;295;301;293;294;300;292;289;288;291;290;285;286;284;287;283;281;282;280;279;349;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;279;-6058.517,-966.4288;Float;True;Property;_MainTex;Albedo;1;0;Create;False;0;0;False;1;;None;8b0017825887ee44e83ac0cb49ceadf0;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexelSizeNode;280;-5777.667,-452.5112;Inherit;False;-1;1;0;SAMPLER2D;;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;282;-5529.73,-1031.753;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;283;-5421.606,-310.5443;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;281;-5416.606,-456.5441;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;286;-5019.532,-36.01417;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;346;-4738.332,135.4289;Inherit;False;Property;_ToonStyle;Toon Style;9;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;285;-5013.825,-482.8749;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;284;-5005.201,-258.929;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;287;-4999.773,-687.2952;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;288;-4569.594,-506.7901;Inherit;True;Property;_TextureSample3;Texture Sample 2;4;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;349;-4427.779,137.5267;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;10;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;290;-4565.594,-286.7901;Inherit;True;Property;_TextureSample4;Texture Sample 3;5;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;289;-4573.594,-717.7901;Inherit;True;Property;_TextureSample2;Texture Sample 1;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;291;-4570.63,-67.54908;Inherit;True;Property;_TextureSample5;Texture Sample 4;6;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;292;-4132.009,-343.1813;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;300;-4143.729,-1047.559;Inherit;False;Property;_Color;Color;0;0;Create;True;0;0;False;1;Header(Albedo Texture);1,1,1,1;0.9174442,1,0.8382353,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;294;-4569.706,-931.7089;Inherit;True;Property;_TextureSample6;Texture Sample 0;0;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;293;-3953.402,-427.1693;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;264;-3005.746,2394.783;Inherit;False;2082.579;669.7218;;4;274;273;267;265;Color Ramp;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;297;-3738.284,-793.0069;Inherit;False;Property;_OutlineColor;Outline Color;10;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;295;-3709.278,-509.5268;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;301;-3746.568,-946.2428;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;2;-1840.551,-1121.044;Inherit;False;1493.488;954.6044;Color Settings;17;54;49;38;27;28;22;19;21;17;20;18;15;16;12;102;216;217;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;265;-2983.271,2626.461;Inherit;False;540.401;361.8907;Comment;3;269;268;266;N . L;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;299;-3331.907,-944.6128;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;4;-3009.102,388.5925;Inherit;False;1068.058;483.6455;Comment;6;50;39;29;26;25;23;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-2959.102,678.6366;Float;False;Property;_GlossinessVariance;Smoothness Variance;16;0;Create;False;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;267;-2292.642,2646.252;Inherit;False;723.599;290;Also know as Lambert Wrap or Half Lambert;3;272;271;270;Diffuse Wrap;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2953.37,773.2766;Float;False;Property;_GlossinessThreshold;Smoothness Threshold;17;0;Create;False;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;266;-2919.271,2834.46;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VertexColorNode;12;-1770.079,-1006.449;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;339;-3112.962,-943.8096;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-2963.272,448.2056;Inherit;False;Property;_Glossiness;Smoothness;15;0;Create;False;0;0;False;1;Header(Smoothness);0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;29;-2874.704,532.0186;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;268;-2871.271,2674.46;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;102;-1713.34,-782.3077;Inherit;False;339;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1549.556,-948.7612;Float;False;Property;_ColorVariation;Color Variation;14;0;Create;True;0;0;False;0;0.15;0.15;0;0.3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;270;-2242.642,2821.252;Float;False;Constant;_WrapperValue;Wrapper Value;0;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;39;-2604.582,581.5456;Float;False;#define PerceptualSmoothnessToRoughness(perceptualSmoothness) (1.0 - perceptualSmoothness) * (1.0 - perceptualSmoothness)$#define RoughnessToPerceptualSmoothness(roughness) 1.0 - sqrt(roughness)$float3 deltaU = ddx(geometricNormalWS)@$float3 deltaV = ddy(geometricNormalWS)@$float variance = screenSpaceVariance * (dot(deltaU, deltaU) + dot(deltaV, deltaV))@$float roughness = PerceptualSmoothnessToRoughness(perceptualSmoothness)@$// Ref: Geometry into Shading - http://graphics.pixar.com/library/BumpRoughness/paper.pdf - equation (3)$float squaredRoughness = saturate(roughness * roughness + min(2.0 * variance, threshold * threshold))@ // threshold can be really low, square the value for easier$return RoughnessToPerceptualSmoothness(sqrt(squaredRoughness))@;1;False;4;True;perceptualSmoothness;FLOAT;0;In;;Float;False;True;geometricNormalWS;FLOAT3;0,0,0;In;;Float;False;True;screenSpaceVariance;FLOAT;0.5;In;;Float;False;True;threshold;FLOAT;0.5;In;;Float;False;GetGeometricNormalVariance;False;True;0;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0.5;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;-1422.356,-1045.862;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;269;-2583.272,2738.46;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1546.12,-862.4572;Half;False;Property;_Hue;Hue;11;0;Create;True;0;0;False;1;Header(Color Settings);0;0;-0.5;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;19;-1486.634,-778.3936;Float;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;3;-3004.281,904.856;Inherit;False;789.6466;355.3238;AO;4;44;41;31;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;271;-1977.24,2696.252;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1533.596,-629.1736;Float;False;Property;_Saturation;Saturation;13;0;Create;True;0;0;False;0;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1531.751,-548.0708;Float;False;Property;_Value;Value;12;0;Create;True;0;0;False;0;1;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1245.357,-961.9563;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-2279.743,581.3916;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;217;-1352.064,-387.8107;Inherit;False;50;Smoothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1097.384,-729.265;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1093.254,-635.1566;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-1089.186,-860.0214;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;31;-2970.915,952.8558;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;216;-1329.064,-459.8107;Inherit;False;339;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;272;-1744.043,2703.053;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-2954.281,1136.496;Half;False;Property;_OcclusionStrength;AO strength;18;0;Create;False;0;0;False;1;Header(Other Settings);0.6;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;5;-1839.721,-142.752;Inherit;False;1493.222;463.5325;Normals;5;53;48;108;47;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;252;-1922.67,695.8496;Inherit;False;1101.824;437.9815;Mtree Wind;6;317;250;74;77;43;316;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-3197.495,-556.2325;Half;False;Property;_Cutoff;Cutoff;5;0;Create;True;0;0;False;0;0.5;0.015;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;37;-1789.721,-88.45222;Float;True;Property;_BumpMap;Normal Map;6;0;Create;False;0;0;False;1;Header(Normal Texture);None;bdcffb5968b084b4490b00efe97041e3;True;bump;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;273;-1497.414,2676.447;Inherit;True;Property;_ToonRamp;Toon Ramp;8;0;Create;True;0;0;False;1;Header(Toon Settings);-1;52e66a9243cdfed44b5e906f5910d35b;52e66a9243cdfed44b5e906f5910d35b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;303;-3153.422,-824.6177;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.LerpOp;41;-2643.427,1097.343;Inherit;False;3;0;FLOAT;2;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;38;-939.7856,-730.908;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;245;-1039.316,-454.6885;Inherit;False;Translucent;20;;315;31c572777d9de6b4a8b2748411bf4658;0;3;37;FLOAT4;0,0,0,0;False;62;FLOAT;1;False;58;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;44;-2472.646,1095.948;Inherit;False;AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-695.2146,-573.8313;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;274;-1197.998,2677.322;Inherit;False;ColorRamp;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-1451.371,133.5333;Half;False;Property;_BumpScale;Normal Strength;7;0;Create;False;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-1887.655,823.9556;Inherit;False;Property;_GlobalWindInfluence;Global Wind Influence;27;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;74;-1776.959,745.6306;Inherit;False;Property;_WindMode;Wind Mode;26;1;[Enum];Create;True;4;Default;0;Leaf;1;Palm;2;Grass;3;0;False;1;Header(Wind);0;1;0;1;INT;0
Node;AmplifyShaderEditor.SamplerNode;47;-1538.721,-62.45196;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClipNode;32;-2830.758,-603.1763;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1894.849,913.5596;Inherit;False;Property;_GlobalTurbulenceInfluence;Global Turbulence Influence;28;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;53;-1213.393,-62.87763;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;340;-2554.121,-601.8583;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;108;-1128.812,130.5641;Inherit;False;Property;_CullMode;Cull Mode;2;1;[Enum];Create;True;3;Off;0;Front;1;Back;2;0;True;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.PosVertexDataNode;317;-1506.822,940.5667;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;275;-325.9922,-179.0601;Inherit;False;274;ColorRamp;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;7;-310.451,-103.9877;Inherit;False;44;AO;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-524.5686,-623.2985;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;250;-1591.073,800.8666;Inherit;False;Mtree Wind Node;-1;;320;64b78a30028980947ab723bea7191537;0;3;235;INT;0;False;167;FLOAT;0;False;166;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;8;-256.05,225.4026;Inherit;False;340;Alpha;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-4523.719,-1029.48;Inherit;False;Constant;_MaskClipValue;Mask Clip Value;14;1;[HideInInspector];Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;316;-998.4258,919.2407;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;276;-26.99219,-145.0601;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;246;-794.7278,-61.63486;Inherit;False;Double Sided Backface Switch;3;;322;243a51f22b364cf4eac05d94dacd3901;0;2;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;9;-269.6682,77.80556;Inherit;False;50;Smoothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;222;-269.3214,2.728832;Inherit;False;Property;_Metallic;Metallic;19;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;213;183.1244,-75.85284;Float;False;True;-1;2;;0;0;Standard;Mtree/Leaves Outline;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.015;True;True;0;True;TransparentCutout;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexScale;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;108;-1;0;True;30;3;Pragma;instancing_options procedural:setup;False;;Custom;Pragma;multi_compile GPU_FRUSTUM_ON __;False;;Custom;Include;;True;a6d16d0571c954c4bbcc7edb6344bb7c;Custom;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;280;0;279;0
WireConnection;282;2;279;0
WireConnection;283;1;280;2
WireConnection;281;0;280;1
WireConnection;286;0;282;0
WireConnection;286;1;283;0
WireConnection;285;0;282;0
WireConnection;285;1;281;0
WireConnection;284;0;282;0
WireConnection;284;1;283;0
WireConnection;287;0;282;0
WireConnection;287;1;281;0
WireConnection;288;0;279;0
WireConnection;288;1;285;0
WireConnection;349;2;346;0
WireConnection;290;0;279;0
WireConnection;290;1;284;0
WireConnection;289;0;279;0
WireConnection;289;1;287;0
WireConnection;291;0;279;0
WireConnection;291;1;286;0
WireConnection;292;0;289;4
WireConnection;292;1;288;4
WireConnection;292;2;290;4
WireConnection;292;3;291;4
WireConnection;292;4;349;0
WireConnection;294;0;279;0
WireConnection;294;1;282;0
WireConnection;293;1;292;0
WireConnection;295;0;294;4
WireConnection;295;1;293;0
WireConnection;301;0;300;0
WireConnection;301;1;294;0
WireConnection;299;0;301;0
WireConnection;299;1;297;0
WireConnection;299;2;295;0
WireConnection;339;0;299;0
WireConnection;39;0;26;0
WireConnection;39;1;29;0
WireConnection;39;2;23;0
WireConnection;39;3;25;0
WireConnection;16;0;12;2
WireConnection;269;0;268;0
WireConnection;269;1;266;0
WireConnection;19;0;102;0
WireConnection;271;0;269;0
WireConnection;271;1;270;0
WireConnection;271;2;270;0
WireConnection;21;0;16;0
WireConnection;21;1;15;0
WireConnection;50;0;39;0
WireConnection;27;0;19;2
WireConnection;27;1;18;0
WireConnection;22;0;19;3
WireConnection;22;1;17;0
WireConnection;28;0;19;0
WireConnection;28;1;21;0
WireConnection;28;2;20;0
WireConnection;272;0;271;0
WireConnection;273;1;272;0
WireConnection;303;0;299;0
WireConnection;41;1;31;4
WireConnection;41;2;24;0
WireConnection;38;0;28;0
WireConnection;38;1;27;0
WireConnection;38;2;22;0
WireConnection;245;37;216;0
WireConnection;245;62;217;0
WireConnection;44;0;41;0
WireConnection;49;0;245;0
WireConnection;49;1;12;4
WireConnection;49;2;38;0
WireConnection;274;0;273;0
WireConnection;47;0;37;0
WireConnection;32;0;303;3
WireConnection;32;1;303;3
WireConnection;32;2;30;0
WireConnection;53;0;47;0
WireConnection;53;1;48;0
WireConnection;340;0;32;0
WireConnection;54;0;38;0
WireConnection;54;1;49;0
WireConnection;250;235;74;0
WireConnection;250;167;77;0
WireConnection;250;166;43;0
WireConnection;316;0;250;0
WireConnection;316;1;317;0
WireConnection;276;0;54;0
WireConnection;276;1;275;0
WireConnection;276;2;7;0
WireConnection;246;1;53;0
WireConnection;246;2;108;0
WireConnection;213;0;276;0
WireConnection;213;1;246;0
WireConnection;213;3;222;0
WireConnection;213;4;9;0
WireConnection;213;9;8;0
WireConnection;213;11;316;0
ASEEND*/
//CHKSM=0DA9F6291314DB69AEC48B54A1D74DE11036BFAB