#ifndef LIGHTWEIGHT_TERRAIN_LIT_PASSES_INCLUDED
#define LIGHTWEIGHT_TERRAIN_LIT_PASSES_INCLUDED

#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"

#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
    #define ENABLE_TERRAIN_PERPIXEL_NORMAL
#endif

#ifdef UNITY_INSTANCING_ENABLED
    TEXTURE2D(_TerrainHeightmapTexture);
    TEXTURE2D(_TerrainNormalmapTexture);
    SAMPLER(sampler_TerrainNormalmapTexture);
    float4 _TerrainHeightmapRecipSize;   // float4(1.0f/width, 1.0f/height, 1.0f/(width-1), 1.0f/(height-1))
    float4 _TerrainHeightmapScale;       // float4(hmScale.x, hmScale.y / (float)(kMaxHeight), hmScale.z, 0.0f)
#endif

UNITY_INSTANCING_BUFFER_START(Terrain)
    UNITY_DEFINE_INSTANCED_PROP(float4, _TerrainPatchInstanceData)  // float4(xBase, yBase, skipScale, ~)
UNITY_INSTANCING_BUFFER_END(Terrain)

#ifdef _ALPHATEST_ON
TEXTURE2D(_TerrainHolesTexture);
SAMPLER(sampler_TerrainHolesTexture);

void ClipHoles(float2 uv)
{
	float hole = SAMPLE_TEXTURE2D(_TerrainHolesTexture, sampler_TerrainHolesTexture, uv).r;
	clip(hole == 0.0f ? -1 : 1);
}
#endif

struct Attributes
{
    float4 positionOS : POSITION;
    float3 normalOS : NORMAL;
    float2 texcoord : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct Varyings
{
    float4 uvMainAndLM              : TEXCOORD0; // xy: control, zw: lightmap
#ifndef TERRAIN_SPLAT_BASEPASS
    float4 uvSplat01                : TEXCOORD1; // xy: splat0, zw: splat1
    float4 uvSplat23                : TEXCOORD2; // xy: splat2, zw: splat3
#endif

#if defined(_NORMALMAP) && !defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
    half4 normal                    : TEXCOORD3;    // xyz: normal, w: viewDir.x
    half4 tangent                   : TEXCOORD4;    // xyz: tangent, w: viewDir.y
    half4 bitangent                  : TEXCOORD5;    // xyz: bitangent, w: viewDir.z
#else
    half3 normal                    : TEXCOORD3;
    half3 viewDir                   : TEXCOORD4;
    half3 vertexSH                  : TEXCOORD5; // SH
#endif

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

#if defined(_NORMALMAP) && !defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
    half3 viewDirWS = half3(IN.normal.w, IN.tangent.w, IN.bitangent.w);
    input.normalWS = TransformTangentToWorld(normalTS, half3x3(IN.tangent.xyz, IN.bitangent.xyz, IN.normal.xyz));
    SH = SampleSH(input.normalWS.xyz);
#elif defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
    half3 viewDirWS = IN.viewDir;
    float2 sampleCoords = (IN.uvMainAndLM.xy / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
    half3 normalWS = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
    half3 tangentWS = cross(GetObjectToWorldMatrix()._13_23_33, normalWS);
    input.normalWS = TransformTangentToWorld(normalTS, half3x3(tangentWS, cross(normalWS, tangentWS), normalWS));
#else
    half3 viewDirWS = IN.viewDir;
    input.normalWS = IN.normal;
    SH = IN.vertexSH;
#endif

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

#ifndef TERRAIN_SPLAT_BASEPASS

void SplatmapMix(Varyings IN, half4 defaultAlpha, out half4 splatControl, out half weight, out half4 mixedDiffuse, inout half3 mixedNormal)
{    
    splatControl = SAMPLE_TEXTURE2D(_Control, sampler_Control, IN.uvMainAndLM.xy);
    weight = dot(splatControl, 1.0h);

#if !defined(SHADER_API_MOBILE) && defined(TERRAIN_SPLAT_ADDPASS)
    clip(weight == 0.0h ? -1.0h : 1.0h);
#endif

    // Normalize weights before lighting and restore weights in final modifier functions so that the overal
    // lighting result can be correctly weighted.
    splatControl /= (weight + HALF_MIN);

    half4 alpha = defaultAlpha * splatControl;

    float y = abs(IN.normal.y);
    float z = abs(IN.normal.z);
    
    mixedDiffuse = 0.0h;
    //mixedDiffuse += SAMPLE_TEXTURE2D(_Splat0, sampler_Splat0, IN.uvSplat01.xy) * half4(splatControl.rrr, alpha.r);
    //mixedDiffuse += SAMPLE_TEXTURE2D(_Splat1, sampler_Splat0, IN.uvSplat01.zw) * half4(splatControl.ggg, alpha.g);
    //mixedDiffuse += SAMPLE_TEXTURE2D(_Splat2, sampler_Splat0, IN.uvSplat23.xy) * half4(splatControl.bbb, alpha.b);
    //mixedDiffuse += SAMPLE_TEXTURE2D(_Splat3, sampler_Splat0, IN.uvSplat23.zw) * half4(splatControl.aaa, alpha.a);
    
    float2 _TerrainSizeInv = float2(_TerrainWidthInv, _TerrainHeightInv);
    
    float2 tile0 = _Splat0_ST.xy * _TerrainSizeInv;
    float2 y0 = IN.positionWS.zy * tile0 + _Splat0_ST.zw;
    float2 x0 = IN.positionWS.xz * tile0 + _Splat0_ST.zw;
    float2 z0 = IN.positionWS.xy * tile0 + _Splat0_ST.zw;
    float4 cX0 = SAMPLE_TEXTURE2D(_Splat0, sampler_Splat0, y0);
    float4 cY0 = SAMPLE_TEXTURE2D(_Splat0, sampler_Splat0, x0);
    float4 cZ0 = SAMPLE_TEXTURE2D(_Splat0, sampler_Splat0, z0);
    float4 side0 = lerp(cX0, cZ0, z);
    float4 top0 = lerp(side0, cY0, y);
    mixedDiffuse += splatControl.r * top0 * half4(1.0, 1.0, 1.0, alpha.r); 
    
    float2 tile1 = _Splat1_ST.xy * _TerrainSizeInv;
    float2 y1 = IN.positionWS.zy * tile1 + _Splat1_ST.zw;
    float2 x1 = IN.positionWS.xz * tile1 + _Splat1_ST.zw;
    float2 z1 = IN.positionWS.xy * tile1 + _Splat1_ST.zw;
    float4 cX1 = SAMPLE_TEXTURE2D(_Splat1, sampler_Splat0, y1);
    float4 cY1 = SAMPLE_TEXTURE2D(_Splat1, sampler_Splat0, x1);
    float4 cZ1 = SAMPLE_TEXTURE2D(_Splat1, sampler_Splat0, z1);
    float4 side1 = lerp(cX1, cZ1, z);
    float4 top1 = lerp(side1, cY1, y);
    mixedDiffuse += splatControl.g * top1 * half4(1.0, 1.0, 1.0, alpha.g); 

    float2 tile2 = _Splat2_ST.xy * _TerrainSizeInv;
    float2 y2 = IN.positionWS.zy * tile2 + _Splat2_ST.zw;
    float2 x2 = IN.positionWS.xz * tile2 + _Splat2_ST.zw;
    float2 z2 = IN.positionWS.xy * tile2 + _Splat2_ST.zw;
    float4 cX2 = SAMPLE_TEXTURE2D(_Splat2, sampler_Splat0, y2);
    float4 cY2 = SAMPLE_TEXTURE2D(_Splat2, sampler_Splat0, x2);
    float4 cZ2 = SAMPLE_TEXTURE2D(_Splat2, sampler_Splat0, z2);
    float4 side2 = lerp(cX2, cZ2, z);
    float4 top2 = lerp(side2, cY2, y);
    mixedDiffuse += splatControl.b * top2 * half4(1.0, 1.0, 1.0, alpha.b); 
    
    float2 tile3 = _Splat3_ST.xy * _TerrainSizeInv;
    float2 y3 = IN.positionWS.zy * tile3 + _Splat3_ST.zw;
    float2 x3 = IN.positionWS.xz * tile3 + _Splat3_ST.zw;
    float2 z3 = IN.positionWS.xy * tile3 + _Splat3_ST.zw;
    float4 cX3 = SAMPLE_TEXTURE2D(_Splat3, sampler_Splat0, y3);
    float4 cY3 = SAMPLE_TEXTURE2D(_Splat3, sampler_Splat0, x3);
    float4 cZ3 = SAMPLE_TEXTURE2D(_Splat3, sampler_Splat0, z3);
    float4 side3 = lerp(cX3, cZ3, z);
    float4 top3 = lerp(side3, cY3, y);
    mixedDiffuse += splatControl.a * top3 * half4(1.0, 1.0, 1.0, alpha.a);

#ifdef _NORMALMAP
    //half4 nrm = 0.0f;
    //nrm += SAMPLE_TEXTURE2D(_Normal0, sampler_Normal0, IN.uvSplat01.xy) * splatControl.r;
    //nrm += SAMPLE_TEXTURE2D(_Normal1, sampler_Normal0, IN.uvSplat01.zw) * splatControl.g;
    //nrm += SAMPLE_TEXTURE2D(_Normal2, sampler_Normal0, IN.uvSplat23.xy) * splatControl.b;
    //nrm += SAMPLE_TEXTURE2D(_Normal3, sampler_Normal0, IN.uvSplat23.zw) * splatControl.a;
    //mixedNormal = UnpackNormal(nrm);
    
    float4 nX0 = SAMPLE_TEXTURE2D(_Normal0, sampler_Normal0, y0);
    float4 nY0 = SAMPLE_TEXTURE2D(_Normal0, sampler_Normal0, x0);
    float4 nZ0 = SAMPLE_TEXTURE2D(_Normal0, sampler_Normal0, z0);
    float4 side0n = lerp(nX0, nZ0, z);
    float4 top0n = lerp(side0n, nY0, y);
    mixedNormal  = UnpackNormalWithScale_(top0n, _NormalScale0) * splatControl.r;
    
    float4 nX1 = SAMPLE_TEXTURE2D(_Normal1, sampler_Normal0, y1);
    float4 nY1 = SAMPLE_TEXTURE2D(_Normal1, sampler_Normal0, x1);
    float4 nZ1 = SAMPLE_TEXTURE2D(_Normal1, sampler_Normal0, z1);
    float4 side1n = lerp(nX1, nZ1, z);
    float4 top1n = lerp(side1n, nY1, y);
    mixedNormal += UnpackNormalWithScale_(top1n, _NormalScale1) * splatControl.g;
    
    float4 nX2 = SAMPLE_TEXTURE2D(_Normal2, sampler_Normal0, y2);
    float4 nY2 = SAMPLE_TEXTURE2D(_Normal2, sampler_Normal0, x2);
    float4 nZ2 = SAMPLE_TEXTURE2D(_Normal2, sampler_Normal0, z2);
    float4 side2n = lerp(nX2, nZ2, z);
    float4 top2n = lerp(side2n, nY2, y);
    mixedNormal += UnpackNormalWithScale_(top2n, _NormalScale2) * splatControl.b;

    float4 nX3 = SAMPLE_TEXTURE2D(_Normal3, sampler_Normal0, y3);
    float4 nY3 = SAMPLE_TEXTURE2D(_Normal3, sampler_Normal0, x3);
    float4 nZ3 = SAMPLE_TEXTURE2D(_Normal3, sampler_Normal0, z3);
    float4 side3n = lerp(nX3, nZ3, z);
    float4 top3n = lerp(side3n, nY3, y);
    mixedNormal += UnpackNormalWithScale_(top3n, _NormalScale3) * splatControl.a;
#endif
}

#endif

void SplatmapFinalColor(inout half4 color, half fogCoord)
{
    color.rgb *= color.a;
    #ifdef TERRAIN_SPLAT_ADDPASS
        color.rgb = MixFogColor(color.rgb, half3(0,0,0), fogCoord);
    #else
        color.rgb = MixFog(color.rgb, fogCoord);
    #endif
}

void TerrainInstancing(inout float4 positionOS, inout float3 normal, inout float2 uv)
{
#ifdef UNITY_INSTANCING_ENABLED
    float2 patchVertex = positionOS.xy;
    float4 instanceData = UNITY_ACCESS_INSTANCED_PROP(Terrain, _TerrainPatchInstanceData);

    float2 sampleCoords = (patchVertex.xy + instanceData.xy) * instanceData.z; // (xy + float2(xBase,yBase)) * skipScale
    float height = UnpackHeightmap(_TerrainHeightmapTexture.Load(int3(sampleCoords, 0)));

    positionOS.xz = sampleCoords * _TerrainHeightmapScale.xz;
    positionOS.y = height * _TerrainHeightmapScale.y;

    #ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
        normal = float3(0, 1, 0);
    #else
        normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb * 2 - 1;
    #endif
    uv = sampleCoords * _TerrainHeightmapRecipSize.zw;
#endif
}

void TerrainInstancing(inout float4 positionOS, inout float3 normal)
{
    float2 uv = { 0, 0 };
    TerrainInstancing(positionOS, normal, uv);
}

///////////////////////////////////////////////////////////////////////////////
//                  Vertex and Fragment functions                            //
///////////////////////////////////////////////////////////////////////////////

// Used in Standard Terrain shader
Varyings SplatmapVert(Attributes v)
{
    Varyings o = (Varyings)0;

    UNITY_SETUP_INSTANCE_ID(v);
    TerrainInstancing(v.positionOS, v.normalOS, v.texcoord);

    VertexPositionInputs Attributes = GetVertexPositionInputs(v.positionOS.xyz);

    o.uvMainAndLM.xy = v.texcoord;
    o.uvMainAndLM.zw = v.texcoord * unity_LightmapST.xy + unity_LightmapST.zw;
#ifndef TERRAIN_SPLAT_BASEPASS
    o.uvSplat01.xy = TRANSFORM_TEX(v.texcoord, _Splat0);
    o.uvSplat01.zw = TRANSFORM_TEX(v.texcoord, _Splat1);
    o.uvSplat23.xy = TRANSFORM_TEX(v.texcoord, _Splat2);
    o.uvSplat23.zw = TRANSFORM_TEX(v.texcoord, _Splat3);
#endif

    half3 viewDirWS = GetCameraPositionWS() - Attributes.positionWS;
#if !SHADER_HINT_NICE_QUALITY
    viewDirWS = SafeNormalize(viewDirWS);
#endif

#if defined(_NORMALMAP) && !defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
    float4 vertexTangent = float4(cross(float3(0, 0, 1), v.normalOS), 1.0);
    VertexNormalInputs normalInput = GetVertexNormalInputs(v.normalOS, vertexTangent);

    o.normal = half4(normalInput.normalWS, viewDirWS.x);
    o.tangent = half4(normalInput.tangentWS, viewDirWS.y);
    o.bitangent = half4(normalInput.bitangentWS, viewDirWS.z);
#else
    o.normal = TransformObjectToWorldNormal(v.normalOS);
    o.viewDir = viewDirWS;
    o.vertexSH = SampleSH(o.normal);
#endif
    o.fogFactorAndVertexLight.x = ComputeFogFactor(Attributes.positionCS.z);
    o.fogFactorAndVertexLight.yzw = VertexLighting(Attributes.positionWS, o.normal.xyz);
    o.positionWS = Attributes.positionWS;
    o.clipPos = Attributes.positionCS;

#ifdef _MAIN_LIGHT_SHADOWS
    o.shadowCoord = GetShadowCoord(Attributes);
#endif

    return o;
}

// Used in Standard Terrain shader
half4 SplatmapFragment(Varyings IN) : SV_TARGET
{
#ifdef _ALPHATEST_ON
	ClipHoles(IN.uvMainAndLM.xy);
#endif	

    half3 normalTS = half3(0.0h, 0.0h, 1.0h);
#ifdef TERRAIN_SPLAT_BASEPASS
    half3 albedo = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uvMainAndLM.xy).rgb;
    half smoothness = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uvMainAndLM.xy).a;
    half metallic = SAMPLE_TEXTURE2D(_MetallicTex, sampler_MetallicTex, IN.uvMainAndLM.xy).r;
    half alpha = 1;
#else
    half4 splatControl;
    half weight;
    half4 mixedDiffuse;
    half4 defaultSmoothness = half4(_Smoothness0, _Smoothness1, _Smoothness2, _Smoothness3);
    SplatmapMix(IN, defaultSmoothness, splatControl, weight, mixedDiffuse, normalTS);

    half3 albedo = mixedDiffuse.rgb;
    half smoothness = mixedDiffuse.a;
    half metallic = dot(splatControl, half4(_Metallic0, _Metallic1, _Metallic2, _Metallic3));
    half alpha = weight;
#endif

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
    UNITY_VERTEX_INPUT_INSTANCE_ID
#ifdef _ALPHATEST_ON
	float2 texcoord     : TEXCOORD0;
#endif
};

struct VaryingsLean
{
    float4 clipPos      : SV_POSITION;
#ifdef _ALPHATEST_ON		
    float2 texcoord     : TEXCOORD0;
#endif
};

VaryingsLean ShadowPassVertex(AttributesLean v)
{
    VaryingsLean o = (VaryingsLean)0;
    UNITY_SETUP_INSTANCE_ID(v);
    TerrainInstancing(v.position, v.normalOS);

    float3 positionWS = TransformObjectToWorld(v.position.xyz);
    float3 normalWS = TransformObjectToWorldNormal(v.normalOS);

    float4 clipPos = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, _LightDirection));

#if UNITY_REVERSED_Z
    clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
#else
    clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
#endif

	o.clipPos = clipPos;

#ifdef _ALPHATEST_ON		
	o.texcoord = v.texcoord;
#endif	

	return o;
}

half4 ShadowPassFragment(VaryingsLean IN) : SV_TARGET
{
#ifdef _ALPHATEST_ON
	ClipHoles(IN.texcoord);
#endif	
    return 0;
}

// Depth pass

VaryingsLean DepthOnlyVertex(AttributesLean v)
{
    VaryingsLean o = (VaryingsLean)0;
    UNITY_SETUP_INSTANCE_ID(v);
    TerrainInstancing(v.position, v.normalOS);
    o.clipPos = TransformObjectToHClip(v.position.xyz);
#ifdef _ALPHATEST_ON		
	o.texcoord = v.texcoord;
#endif	
	return o;
}

half4 DepthOnlyFragment(VaryingsLean IN) : SV_TARGET
{
#ifdef _ALPHATEST_ON
	ClipHoles(IN.texcoord);
#endif
    return 0;
}

#endif
