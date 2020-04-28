Shader "Digger/LWRP/Mesh-Pass1"
{
    Properties
    {
        // set by terrain engine
         _Control("Control (RGBA)", 2D) = "red" {}
         _Splat3("Layer 3 (A)", 2D) = "white" {}
         _Splat2("Layer 2 (B)", 2D) = "white" {}
         _Splat1("Layer 1 (G)", 2D) = "white" {}
         _Splat0("Layer 0 (R)", 2D) = "white" {}
         _Normal3("Normal 3 (A)", 2D) = "bump" {}
         _Normal2("Normal 2 (B)", 2D) = "bump" {}
         _Normal1("Normal 1 (G)", 2D) = "bump" {}
         _Normal0("Normal 0 (R)", 2D) = "bump" {}
        [Gamma] _Metallic0("Metallic 0", Range(0.0, 1.0)) = 0.0
        [Gamma] _Metallic1("Metallic 1", Range(0.0, 1.0)) = 0.0
        [Gamma] _Metallic2("Metallic 2", Range(0.0, 1.0)) = 0.0
        [Gamma] _Metallic3("Metallic 3", Range(0.0, 1.0)) = 0.0
         _Smoothness0("Smoothness 0", Range(0.0, 1.0)) = 1.0
         _Smoothness1("Smoothness 1", Range(0.0, 1.0)) = 1.0
         _Smoothness2("Smoothness 2", Range(0.0, 1.0)) = 1.0
         _Smoothness3("Smoothness 3", Range(0.0, 1.0)) = 1.0

        // used in fallback on old cards & base map
        _BaseMap("BaseMap (RGB)", 2D) = "white" {}
        _BaseColor("Main Color", Color) = (1,1,1,1)
        
        _tiles0x ("tile0X", float) = 0.03
        _tiles0y ("tile0Y", float) = 0.03
        _tiles1x ("tile1X", float) = 0.03
        _tiles1y ("tile1Y", float) = 0.03
        _tiles2x ("tile2X", float) = 0.03
        _tiles2y ("tile2Y", float) = 0.03
        _tiles3x ("tile3X", float) = 0.03
        _tiles3y ("tile3Y", float) = 0.03
        _offset0x ("offset0X", float) = 0
        _offset0y ("offset0Y", float) = 0
        _offset1x ("offset1X", float) = 0
        _offset1y ("offset1Y", float) = 0
        _offset2x ("offset2X", float) = 0
        _offset2y ("offset2Y", float) = 0
        _offset3x ("offset3X", float) = 0
        _offset3y ("offset3Y", float) = 0

        _normalScale0 ("normalScale0", float) = 1
        _normalScale1 ("normalScale1", float) = 1
        _normalScale2 ("normalScale2", float) = 1
        _normalScale3 ("normalScale3", float) = 1
    }

    SubShader
    {
        Tags { "Queue" = "Geometry-104" "RenderType" = "Opaque" "RenderPipeline" = "LightweightPipeline" "IgnoreProjector" = "True"}

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

            #pragma vertex SplatmapVert1
            #pragma fragment SplatmapFragment

            // -------------------------------------
            // Lightweight Pipeline keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            //#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile_fog

            #pragma shader_feature _NORMALMAP
            #define TERRAIN_SPLAT_ADDPASS 1

            #include "DiggerLWRPMeshLitInput.hlsl"
            #include "DiggerLWRPMeshLitPasses.hlsl"
            ENDHLSL
        }
    }
    Fallback "Hidden/InternalErrorShader"
}
