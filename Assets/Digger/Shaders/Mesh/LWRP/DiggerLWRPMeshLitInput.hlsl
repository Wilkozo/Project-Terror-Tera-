#ifndef LIGHTWEIGHT_MESH_LIT_INPUT_INCLUDED
#define LIGHTWEIGHT_MESH_LIT_INPUT_INCLUDED

#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl"
#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/SurfaceInput.hlsl"

CBUFFER_START(_DiggerMesh)
half _Metallic0, _Metallic1, _Metallic2, _Metallic3;
half _Smoothness0, _Smoothness1, _Smoothness2, _Smoothness3;

half4 _Splat0_ST, _Splat1_ST, _Splat2_ST, _Splat3_ST;
CBUFFER_END

TEXTURE2D(_Splat0);     SAMPLER(sampler_Splat0);
TEXTURE2D(_Splat1);
TEXTURE2D(_Splat2);
TEXTURE2D(_Splat3);

TEXTURE2D(_Normal0);     SAMPLER(sampler_Normal0);
TEXTURE2D(_Normal1);
TEXTURE2D(_Normal2);
TEXTURE2D(_Normal3);
float _normalScale0, _normalScale1, _normalScale2, _normalScale3;

TEXTURE2D(_MainTex);            SAMPLER(sampler_MainTex);
TEXTURE2D(_SpecGlossMap);       SAMPLER(sampler_SpecGlossMap);

CBUFFER_START(UnityPerMaterial)
float4 _MainTex_ST;
half4 _BaseColor;
half _Cutoff;
CBUFFER_END

TEXTURE2D(_MetallicTex);   SAMPLER(sampler_MetallicTex);

float _tiles0x;
float _tiles0y;
float _tiles1x;
float _tiles1y;
float _tiles2x;
float _tiles2y;
float _tiles3x;
float _tiles3y;

float _offset0x;
float _offset0y;
float _offset1x;
float _offset1y;
float _offset2x;
float _offset2y;
float _offset3x;
float _offset3y;

half4 SampleMetallicSpecGloss(float2 uv, half albedoAlpha)
{
    half4 specGloss;
    specGloss = SAMPLE_TEXTURE2D(_MetallicTex, sampler_MetallicTex, uv);
    specGloss.a = albedoAlpha;
    return specGloss;
}

inline void InitializeStandardLitSurfaceData(float2 uv, out SurfaceData outSurfaceData)
{
    half4 albedoSmoothness = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv);
    outSurfaceData.alpha = 1;

    half4 specGloss = SampleMetallicSpecGloss(uv, albedoSmoothness.a);
    outSurfaceData.albedo = albedoSmoothness.rgb;

    outSurfaceData.metallic = specGloss.r;
    outSurfaceData.specular = half3(0.0h, 0.0h, 0.0h);

    outSurfaceData.smoothness = specGloss.a;
    outSurfaceData.normalTS = SampleNormal(uv, TEXTURE2D_ARGS(_BumpMap, sampler_BumpMap));
    outSurfaceData.occlusion = 1;
    outSurfaceData.emission = 0;
}

#endif
