Shader "Digger/LWRP/Terrain/Lit (Add Pass)"
{
    Properties
    {
        // set by terrain engine
        [HideInInspector] _Control("Control (RGBA)", 2D) = "red" {}
        [HideInInspector] _Splat3("Layer 3 (A)", 2D) = "white" {}
        [HideInInspector] _Splat2("Layer 2 (B)", 2D) = "white" {}
        [HideInInspector] _Splat1("Layer 1 (G)", 2D) = "white" {}
        [HideInInspector] _Splat0("Layer 0 (R)", 2D) = "white" {}
        [HideInInspector] _Normal3("Normal 3 (A)", 2D) = "bump" {}
        [HideInInspector] _Normal2("Normal 2 (B)", 2D) = "bump" {}
        [HideInInspector] _Normal1("Normal 1 (G)", 2D) = "bump" {}
        [HideInInspector] _Normal0("Normal 0 (R)", 2D) = "bump" {}
        [HideInInspector][Gamma] _Metallic0("Metallic 0", Range(0.0, 1.0)) = 0.0
        [HideInInspector][Gamma] _Metallic1("Metallic 1", Range(0.0, 1.0)) = 0.0
        [HideInInspector][Gamma] _Metallic2("Metallic 2", Range(0.0, 1.0)) = 0.0
        [HideInInspector][Gamma] _Metallic3("Metallic 3", Range(0.0, 1.0)) = 0.0
        [HideInInspector] _Smoothness0("Smoothness 0", Range(0.0, 1.0)) = 1.0
        [HideInInspector] _Smoothness1("Smoothness 1", Range(0.0, 1.0)) = 1.0
        [HideInInspector] _Smoothness2("Smoothness 2", Range(0.0, 1.0)) = 1.0
        [HideInInspector] _Smoothness3("Smoothness 3", Range(0.0, 1.0)) = 1.0

        // used in fallback on old cards & base map
        [HideInInspector] _BaseMap("BaseMap (RGB)", 2D) = "white" {}
        [HideInInspector] _BaseColor("Main Color", Color) = (1,1,1,1)
        
        // controls transparency to cut holes
        [HideInInspector] _TerrainHolesTexture ("Transparency Map (RGBA)", 2D) = "white" {}
        
        [HideInInspector] _TerrainWidthInv ("_TerrainWidthInv", float) = 0.001
        [HideInInspector] _TerrainHeightInv ("_TerrainHeightInv", float) = 0.001
    }
    
    HLSLINCLUDE

	#define _ALPHATEST_ON

	ENDHLSL

    SubShader
    {
        Tags { "Queue" = "Geometry-101" "RenderType" = "Opaque" "RenderPipeline" = "LightweightPipeline" "IgnoreProjector" = "True"}

        Pass
        {
            Name "TerrainAddLit"
            Tags { "LightMode" = "LightweightForward" }
            Blend One One
            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 3.0

            #pragma vertex SplatmapVert
            #pragma fragment SplatmapFragment

            // -------------------------------------
            // Lightweight Pipeline keywords
            #pragma multi_compile_local _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile_local _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile_local _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_local _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_local _ _SHADOWS_SOFT
            #pragma multi_compile_local _ _MIXED_LIGHTING_SUBTRACTIVE

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile_local _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile_local _ LIGHTMAP_ON
            #pragma multi_compile_local_fog
            #pragma multi_compile_local_instancing
            #pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap

            #pragma shader_feature_local _NORMALMAP
            #define TERRAIN_SPLAT_ADDPASS 1

            #include "DiggerLWRPTerrainLitInput.hlsl"
            #include "DiggerLWRPTerrainLitPasses.hlsl"
            ENDHLSL
        }
    }
    Fallback "Hidden/InternalErrorShader"
}
