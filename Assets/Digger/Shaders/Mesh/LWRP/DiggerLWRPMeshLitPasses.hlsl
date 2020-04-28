#ifndef LIGHTWEIGHT_MESH_LIT_PASSES_INCLUDED
#define LIGHTWEIGHT_MESH_LIT_PASSES_INCLUDED

#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"


struct Attributes
{
    float4 positionOS   : POSITION;
    float3 normalOS     : NORMAL;
    float2 texcoord     : TEXCOORD0;
    float4 color        : COLOR;
    float4 texcoord1    : TEXCOORD1;
    float4 texcoord2    : TEXCOORD2;
    float4 texcoord3    : TEXCOORD3;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct Varyings
{
    float4 uvMainAndLM              : TEXCOORD0; // xy: control, zw: lightmap

    half4 splat_control             : TEXCOORD1;

    half4 normal                    : TEXCOORD3;    // xyz: normal, w: viewDir.x
    half4 tangent                   : TEXCOORD4;    // xyz: tangent, w: viewDir.y
    half4 bitangent                 : TEXCOORD5;    // xyz: bitangent, w: viewDir.z


    half4 fogFactorAndVertexLight   : TEXCOORD6; // x: fogFactor, yzw: vertex light
    float3 positionWS               : TEXCOORD7;
    float4 shadowCoord              : TEXCOORD8;
    float4 clipPos                  : SV_POSITION;
};

// Copied from Unity built-in shader v2018.3
float3 UnpackNormalWithScale_(float4 packednormal, float scale)
{
#ifndef UNITY_NO_DXT5nm
    // Unpack normal as DXT5nm (1, y, 1, x) or BC5 (x, y, 0, 1)
    // Note neutral texture like "bump" is (0, 0, 1, 1) to work with both plain RGB normal and DXT5nm/BC5
    packednormal.x *= packednormal.w;
#endif
    float3 normal;
    normal.xy = (packednormal.xy * 2 - 1) * scale;
    normal.z = sqrt(1 - saturate(dot(normal.xy, normal.xy)));
    return normal;
}

void InitializeInputData(Varyings IN, half3 normalTS, out InputData input)
{
    input = (InputData)0;

    input.positionWS = IN.positionWS;
    half3 SH = half3(0, 0, 0);

    half3 viewDirWS = half3(IN.normal.w, IN.tangent.w, IN.bitangent.w);
    input.normalWS = TransformTangentToWorld(normalTS, half3x3(IN.tangent.xyz, IN.bitangent.xyz, IN.normal.xyz));
    SH = SampleSH(input.normalWS.xyz);

#if SHADER_HINT_NICE_QUALITY
    viewDirWS = SafeNormalize(viewDirWS);
#endif

    input.normalWS = NormalizeNormalPerPixel(input.normalWS);

    input.viewDirectionWS = viewDirWS;
#ifdef _MAIN_LIGHT_SHADOWS
    input.shadowCoord = IN.shadowCoord;
#else
    input.shadowCoord = float4(0, 0, 0, 0);
#endif
    input.fogCoord = IN.fogFactorAndVertexLight.x;
    input.vertexLighting = IN.fogFactorAndVertexLight.yzw;

    input.bakedGI = SAMPLE_GI(IN.uvMainAndLM.zw, SH, input.normalWS);
}


void SplatmapMix(Varyings IN, half4 defaultAlpha, half4 splatControl, half weight, out half4 mixedDiffuse, inout half3 mixedNormal)
{

#if !defined(SHADER_API_MOBILE) && defined(TERRAIN_SPLAT_ADDPASS)
    clip(weight == 0.0h ? -1.0h : 1.0h);
#endif

    half4 alpha = defaultAlpha * splatControl;

    float y = abs(IN.normal.y);
    float z = abs(IN.normal.z);
    
    mixedDiffuse = 0.0h;    
    
    float2 tile = float2(_tiles0x, _tiles0y);
    float2 offset = float2(_offset0x, _offset0y);
    float2 y0 = IN.positionWS.zy * tile + offset;
    float2 x0 = IN.positionWS.xz * tile + offset;
    float2 z0 = IN.positionWS.xy * tile + offset;
    float4 cX0 = SAMPLE_TEXTURE2D(_Splat0, sampler_Splat0, y0);
    float4 cY0 = SAMPLE_TEXTURE2D(_Splat0, sampler_Splat0, x0);
    float4 cZ0 = SAMPLE_TEXTURE2D(_Splat0, sampler_Splat0, z0);
    float4 side0 = lerp(cX0, cZ0, z);
    float4 top0 = lerp(side0, cY0, y);
    mixedDiffuse += splatControl.r * top0 * half4(1.0, 1.0, 1.0, alpha.r); 
    
    tile = float2(_tiles1x, _tiles1y);
    offset = float2(_offset1x, _offset1y);
    float2 y1 = IN.positionWS.zy * tile + offset;
    float2 x1 = IN.positionWS.xz * tile + offset;
    float2 z1 = IN.positionWS.xy * tile + offset;
    float4 cX1 = SAMPLE_TEXTURE2D(_Splat1, sampler_Splat0, y1);
    float4 cY1 = SAMPLE_TEXTURE2D(_Splat1, sampler_Splat0, x1);
    float4 cZ1 = SAMPLE_TEXTURE2D(_Splat1, sampler_Splat0, z1);
    float4 side1 = lerp(cX1, cZ1, z);
    float4 top1 = lerp(side1, cY1, y);
    mixedDiffuse += splatControl.g * top1 * half4(1.0, 1.0, 1.0, alpha.g); 

    tile = float2(_tiles2x, _tiles2y);
    offset = float2(_offset2x, _offset2y);
    float2 y2 = IN.positionWS.zy * tile + offset;
    float2 x2 = IN.positionWS.xz * tile + offset;
    float2 z2 = IN.positionWS.xy * tile + offset;
    float4 cX2 = SAMPLE_TEXTURE2D(_Splat2, sampler_Splat0, y2);
    float4 cY2 = SAMPLE_TEXTURE2D(_Splat2, sampler_Splat0, x2);
    float4 cZ2 = SAMPLE_TEXTURE2D(_Splat2, sampler_Splat0, z2);
    float4 side2 = lerp(cX2, cZ2, z);
    float4 top2 = lerp(side2, cY2, y);
    mixedDiffuse += splatControl.b * top2 * half4(1.0, 1.0, 1.0, alpha.b); 
    
    tile = float2(_tiles3x, _tiles3y);
    offset = float2(_offset3x, _offset3y);
    float2 y3 = IN.positionWS.zy * tile + offset;
    float2 x3 = IN.positionWS.xz * tile + offset;
    float2 z3 = IN.positionWS.xy * tile + offset;
    float4 cX3 = SAMPLE_TEXTURE2D(_Splat3, sampler_Splat0, y3);
    float4 cY3 = SAMPLE_TEXTURE2D(_Splat3, sampler_Splat0, x3);
    float4 cZ3 = SAMPLE_TEXTURE2D(_Splat3, sampler_Splat0, z3);
    float4 side3 = lerp(cX3, cZ3, z);
    float4 top3 = lerp(side3, cY3, y);
    mixedDiffuse += splatControl.a * top3 * half4(1.0, 1.0, 1.0, alpha.a);

    
    float4 nX0 = SAMPLE_TEXTURE2D(_Normal0, sampler_Normal0, y0);
    float4 nY0 = SAMPLE_TEXTURE2D(_Normal0, sampler_Normal0, x0);
    float4 nZ0 = SAMPLE_TEXTURE2D(_Normal0, sampler_Normal0, z0);
    float4 side0n = lerp(nX0, nZ0, z);
    float4 top0n = lerp(side0n, nY0, y);
    mixedNormal  = UnpackNormalWithScale_(top0n, _normalScale0) * splatControl.r;
    
    float4 nX1 = SAMPLE_TEXTURE2D(_Normal1, sampler_Normal0, y1);
    float4 nY1 = SAMPLE_TEXTURE2D(_Normal1, sampler_Normal0, x1);
    float4 nZ1 = SAMPLE_TEXTURE2D(_Normal1, sampler_Normal0, z1);
    float4 side1n = lerp(nX1, nZ1, z);
    float4 top1n = lerp(side1n, nY1, y);
    mixedNormal += UnpackNormalWithScale_(top1n, _normalScale1) * splatControl.g;
    
    float4 nX2 = SAMPLE_TEXTURE2D(_Normal2, sampler_Normal0, y2);
    float4 nY2 = SAMPLE_TEXTURE2D(_Normal2, sampler_Normal0, x2);
    float4 nZ2 = SAMPLE_TEXTURE2D(_Normal2, sampler_Normal0, z2);
    float4 side2n = lerp(nX2, nZ2, z);
    float4 top2n = lerp(side2n, nY2, y);
    mixedNormal += UnpackNormalWithScale_(top2n, _normalScale2) * splatControl.b;

    float4 nX3 = SAMPLE_TEXTURE2D(_Normal3, sampler_Normal0, y3);
    float4 nY3 = SAMPLE_TEXTURE2D(_Normal3, sampler_Normal0, x3);
    float4 nZ3 = SAMPLE_TEXTURE2D(_Normal3, sampler_Normal0, z3);
    float4 side3n = lerp(nX3, nZ3, z);
    float4 top3n = lerp(side3n, nY3, y);
    mixedNormal += UnpackNormalWithScale_(top3n, _normalScale3) * splatControl.a;
}


void SplatmapFinalColor(inout half4 color, half fogCoord)
{
    color.rgb *= color.a;
    #ifdef TERRAIN_SPLAT_ADDPASS
        color.rgb = MixFogColor(color.rgb, half3(0,0,0), fogCoord);
    #else
        color.rgb = MixFog(color.rgb, fogCoord);
    #endif
}

///////////////////////////////////////////////////////////////////////////////
//                  Vertex and Fragment functions                            //
///////////////////////////////////////////////////////////////////////////////

Varyings GenericSplatmapVert(Attributes v, half4 control)
{
    Varyings o = (Varyings)0;

    VertexPositionInputs Attributes = GetVertexPositionInputs(v.positionOS.xyz);

    o.splat_control = control;
    o.uvMainAndLM.xy = v.texcoord;
    o.uvMainAndLM.zw = v.texcoord * unity_LightmapST.xy + unity_LightmapST.zw;

    half3 viewDirWS = GetCameraPositionWS() - Attributes.positionWS;
#if !SHADER_HINT_NICE_QUALITY
    viewDirWS = SafeNormalize(viewDirWS);
#endif

    float4 vertexTangent = float4(cross(float3(0, 0, 1), v.normalOS), 1.0);
    VertexNormalInputs normalInput = GetVertexNormalInputs(v.normalOS, vertexTangent);

    o.normal = half4(normalInput.normalWS, viewDirWS.x);
    o.tangent = half4(normalInput.tangentWS, viewDirWS.y);
    o.bitangent = half4(normalInput.bitangentWS, viewDirWS.z);
    

    o.fogFactorAndVertexLight.x = ComputeFogFactor(Attributes.positionCS.z);
    o.fogFactorAndVertexLight.yzw = VertexLighting(Attributes.positionWS, o.normal.xyz);
    o.positionWS = Attributes.positionWS;
    o.clipPos = Attributes.positionCS;

#ifdef _MAIN_LIGHT_SHADOWS
    o.shadowCoord = GetShadowCoord(Attributes);
#endif

    return o;
}

Varyings SplatmapVert0(Attributes v)
{
    return GenericSplatmapVert(v, v.color);
}
Varyings SplatmapVert1(Attributes v)
{
    return GenericSplatmapVert(v, v.texcoord1);
}
Varyings SplatmapVert2(Attributes v)
{
    return GenericSplatmapVert(v, v.texcoord2);
}
Varyings SplatmapVert3(Attributes v)
{
    return GenericSplatmapVert(v, v.texcoord3);
}

// Used in Standard Terrain shader
half4 SplatmapFragment(Varyings IN) : SV_TARGET
{
    half3 normalTS = half3(0.0h, 0.0h, 1.0h);
    half4 splatControl = IN.splat_control;
    half weight = dot(splatControl, 1.0h);
    // Normalize weights before lighting and restore weights in final modifier functions so that the overal
    // lighting result can be correctly weighted.
    splatControl /= (weight + HALF_MIN);

    half4 mixedDiffuse;
    half4 defaultSmoothness = half4(_Smoothness0, _Smoothness1, _Smoothness2, _Smoothness3);
    SplatmapMix(IN, defaultSmoothness, splatControl, weight, mixedDiffuse, normalTS);

    half3 albedo = mixedDiffuse.rgb;
    half smoothness = mixedDiffuse.a;
    half metallic = dot(splatControl, half4(_Metallic0, _Metallic1, _Metallic2, _Metallic3));
    half alpha = weight;
    

    InputData inputData;
    InitializeInputData(IN, normalTS, inputData);
    half4 color = LightweightFragmentPBR(inputData, albedo, metallic, half3(0.0h, 0.0h, 0.0h), smoothness, /* occlusion */ 1.0, /* emission */ half3(0, 0, 0), alpha);

    SplatmapFinalColor(color, inputData.fogCoord);

    return half4(color.rgb, 1.0h);
}

// Shadow pass

// x: global clip space bias, y: normal world space bias
float3 _LightDirection;

struct AttributesLean
{
    float4 position     : POSITION;
    float3 normalOS       : NORMAL;
};

float4 ShadowPassVertex(AttributesLean v) : SV_POSITION
{
    Varyings o;

    float3 positionWS = TransformObjectToWorld(v.position.xyz);
    float3 normalWS = TransformObjectToWorldNormal(v.normalOS);

    float4 clipPos = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, _LightDirection));

#if UNITY_REVERSED_Z
    clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
#else
    clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
#endif

    return clipPos;
}

half4 ShadowPassFragment() : SV_TARGET
{
    return 0;
}

// Depth pass

float4 DepthOnlyVertex(AttributesLean v) : SV_POSITION
{
    Varyings o = (Varyings)0;
    UNITY_SETUP_INSTANCE_ID(v);
    return TransformObjectToHClip(v.position.xyz);
}

half4 DepthOnlyFragment() : SV_TARGET
{
    return 0;
}
#endif
