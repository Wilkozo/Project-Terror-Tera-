Shader "Self-Illumin/WallLamp" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	//_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	_EmisColor ("Emission Color", Color) = (0.0, 0.0, 0.0, 1)
	_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
	_Emission ("Emission", Range (0.0, 10.0)) = 1.0
	_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	_Illum ("Illumin (A)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	//_EmissionLM ("Emission (Lightmapper)", Float) = 0
	//_Cube ("Reflection Cubemap", Cube) = "_Skybox" { TexGen CubeReflect }
}
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 400
CGPROGRAM
#pragma surface surf BlinnPhong

sampler2D _MainTex;
sampler2D _BumpMap;
sampler2D _Illum;
//samplerCUBE _Cube;
fixed4 _Color;
fixed4 _EmisColor;
half _Shininess;
half _Emission;

struct Input {
	float2 uv_MainTex;
	float2 uv_Illum;
	float2 uv_BumpMap;
	//float3 worldRefl;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 c = tex * _Color;
	//float3 worldRefl = WorldReflectionVector (IN, o.Normal);
	//fixed4 reflcol = texCUBE (_Cube, worldRefl);
	//reflcol *= tex.a;
	o.Albedo = c.rgb;
	//o.Emission = c.rgb * tex2D(_Illum, IN.uv_Illum).a;
	//o.Emission = c.rgb * tex2D(_Illum, IN.uv_Illum).a * tex2D(_Illum, IN.uv_Illum).rgb;
	//o.Emission = c.rgb * tex2D(_Illum, IN.uv_Illum).a + tex2D(_Illum, IN.uv_Illum).rgb;
	//o.Emission = c.rgb + tex2D(_Illum, IN.uv_Illum).rgb;
	//o.Emission = tex2D(_Illum, IN.uv_Illum).a * tex2D(_Illum, IN.uv_Illum).rgb;
	o.Emission = _Emission * _EmisColor.rgb * tex2D(_Illum, IN.uv_Illum).rgb * tex2D(_MainTex, IN.uv_MainTex).rgb;
	//o.Emission = _Emission * _EmisColor.rgb * tex2D(_Illum, IN.uv_Illum).rgb * tex2D(_MainTex, IN.uv_MainTex).rgb + reflcol.rgb;
	o.Gloss = tex.a;
	o.Alpha = c.a;
	o.Specular = _Shininess;
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
}
ENDCG
}
FallBack "Self-Illumin/Specular"
}
