// Upgrade NOTE: removed variant '__' where variant LOD_FADE_PERCENTAGE is used.

Shader "CTI/LOD Bark Tessellation" {
Properties {

     _HueVariation                       ("Color Variation", Color) = (0.9,0.5,0.0,0.1)
    
    [Header(Main Maps)]
    [Space(5)]
    _MainTex                            ("Albedo (RGB) Smoothness (A)", 2D) = "white" {}
    [NoScaleOffset] _BumpSpecAOMap      ("Normal Map (GA) Specular (R) AO (B)", 2D) = "bump" {}

    [Header(Secondary Maps)]
    [Space(5)]
    [CTI_DetailsEnum] _DetailMode       ("Secondary Maps (need UV2)", Float) = 0
    [Toggle(_SWAP_UVS)] _SwapUVS        ("    Swap UVS", Float) = 0.0
    _AverageCol                         ("    Average Color (RGB) Smoothness (A)", Color) = (1,1,1,0.5)
    [Space(5)]

    [NoScaleOffset] _DetailAlbedoMap    ("    Detail Albedo x2 (RGB) Smoothness (A)", 2D) = "gray" {}
    [NoScaleOffset] _DetailNormalMapX   ("    Normal Map (GA) Specular (R) AO (B)", 2D) = "gray" {}
    _DetailNormalMapScale               ("    Normal Strength", Float) = 1.0

    [Header(Wind)]
    [Space(5)]
    [Toggle(_METALLICGLOSSMAP)] _LODTerrain ("Use Wind from Script", Float) = 0.0

    [Header(Options for lowest LOD)]
    [Space(5)]
    [Toggle] _FadeOutWind               ("Fade out Wind", Float) = 0.0

    [Header(Tessellation)]
    [IntRange] _Tess                    ("Tessellation", Range(1,64)) = 7
    _maxDist                            ("    Max Dist", Range(0,50)) = 20
    _minDist                            ("    Min Dist", Range(0,50)) = 19
    _ExtrudeRange                       ("    Extrusion Range", float) = 4
    [NoScaleOffset]_DispTex             ("Height Map (A)", 2D) = "black" {}
    _Displacement                       ("    Displacement", Range(0, 1)) = 0.05

    // In case we switch to the debug shader
    [HideInInspector] _Cutoff ("Cutoff", Range(0,1)) = 1
}

        
SubShader {
    Tags {
        "Queue"="Geometry"
        "RenderType"="CTI-TreeBarkLOD"
        "DisableBatching"="LODFading"
    }
    LOD 300
    CGPROGRAM
// noshadowmask does not fix the problem with baked shadows in deferred
// removing nolightmap does             
        #pragma surface surf StandardSpecular fullforwardshadows vertex:CTIDisplace addshadow nodynlightmap tessellate:CTIDistanceBasedTess dithercrossfade
// nolightmap
        #pragma target 4.6
        #pragma multi_compile  LOD_FADE_PERCENTAGE LOD_FADE_CROSSFADE
        #pragma multi_compile __ _METALLICGLOSSMAP
//      #pragma multi_compile_instancing
        
    //  Detail modes: simply on / fade base textures / skip base textures
        #pragma shader_feature __ GEOM_TYPE_BRANCH GEOM_TYPE_BRANCH_DETAIL GEOM_TYPE_FROND
        #pragma shader_feature _SWAP_UVS

        //#if UNITY_VERSION >= 550
            #pragma instancing_options assumeuniformscaling lodfade
        //#endif

        #define IS_BARK
        #define IS_LODTREE
        #define CTIBARKTESS

        #include "Tessellation.cginc"
        #include "Includes/CTI_Builtin4xTreeLibraryTumbling.cginc"


    //  -----------------------------------------

        float _Tess;
        float _minDist;
        float _maxDist;
        float _ExtrudeRange;
        float _Displacement;
        sampler2D _DispTex;

        float4 CTIDistanceBasedTess (appdata_ctitree v0, appdata_ctitree  v1, appdata_ctitree  v2) {
            return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, _minDist, _maxDist, _Tess );
        }

    //  Using tessellation does not let us define a custom Input structure – so we have to use the defaults: no "out Input o"
        void CTIDisplace (inout appdata_ctitree v)
        {
    		UNITY_SETUP_INSTANCE_ID(v); // Does work... at least in DX11
            /*#if defined(INSTANCING_ON)
    		    v.instanceID = v.instanceID;
                #if defined(UNITY_INSTANCING_ENABLED)
    		        unity_InstanceID = v.instanceID + unity_BaseInstanceID;
                #endif
            #endif*/
            float3 wpos = mul(unity_ObjectToWorld, v.vertex).xyz;
            float dist = distance(wpos, _WorldSpaceCameraPos);
            float near = _minDist - _ExtrudeRange;
            float f = saturate(1.0 - (dist - near) / (_minDist - near)) /* mask dosplacement by vertex color green*/ * (1.0 - v.color.g);
            
            if (f > 0.0f) {
                float2 texcoordCorrection = float2(0,0);
            //  We have to fix a seam
// should be > 0 – but 0.96 seems to work as well (floating point issue...)
                if(v.texcoord2.z > 0.96f) {
                    texcoordCorrection = v.texcoord2.xy * pow(v.texcoord2.z, 1024.0f);
                }
                float d = (tex2Dlod(_DispTex, float4(v.texcoord.xy + texcoordCorrection, 0.0f, 0.0f)).a  - 0.5f) ; 
                v.vertex.xyz += v.normal * d * _Displacement * f;
            }

        //  From here on it should match CTI_TreeVertBark
            #if defined(_METALLICGLOSSMAP)
                float4 TerrainLODWind = _TerrainLODWind;
                TerrainLODWind.xyz = mul((float3x3)unity_WorldToObject, _TerrainLODWind.xyz);
                CTI_AnimateVertex( v, float4(v.vertex.xyz, v.color.b), v.normal, float4(v.color.xy, v.texcoord1.xy), float3(0,0,0), 0, TerrainLODWind, 0); //v.texcoord2.z);
            #else
                CTI_AnimateVertex( v, float4(v.vertex.xyz, v.color.b), v.normal, float4(v.color.xy, v.texcoord1.xy), float3(0,0,0), 0, UNITY_ACCESS_INSTANCED_PROP(_Wind_arr, _Wind), 0); //v.texcoord2.z);
            #endif
            v.normal = normalize(v.normal);
            v.tangent.xyz = normalize(v.tangent.xyz);

        //  Copy detail texture UVs
            v.texcoord1.xy = v.texcoord1.zw;
        }

    //  -----------------------------------------


        sampler2D _MainTex;
        sampler2D _BumpSpecAOMap;
        fixed4 _AverageCol;

        #if defined(GEOM_TYPE_BRANCH) || defined(GEOM_TYPE_BRANCH_DETAIL) || defined(GEOM_TYPE_FROND)
            sampler2D _DetailAlbedoMap;
            sampler2D _DetailNormalMapX;
            half _DetailNormalMapScale;
        #endif

        void surf (Input IN, inout SurfaceOutputStandardSpecular o) {

            #if UNITY_VERSION < 2017
                #if defined(LOD_FADE_CROSSFADE)
                    IN.ditherScreenPos = IN.screenPos.xyw;
                    IN.ditherScreenPos.xy *= _ScreenParams.xy * 0.25;
                #endif
                UNITY_APPLY_DITHER_CROSSFADE(IN)
            #endif
        
        //  Swapped UVs 
            #if ( defined(GEOM_TYPE_BRANCH) || defined(GEOM_TYPE_BRANCH_DETAIL) || defined(GEOM_TYPE_FROND) ) && defined (_SWAP_UVS)
            //  Skip base textures (details)
                #if defined(GEOM_TYPE_FROND)
                    fixed4 c = _AverageCol;
                    fixed4 bumpSpecAO = fixed4(unity_ColorSpaceDielectricSpec.r, 0.5, 1, 0.5);
                #else
                    fixed4 c = tex2D(_MainTex, IN.uv2_DetailAlbedoMap);
                    fixed4 bumpSpecAO = tex2D(_BumpSpecAOMap, IN.uv2_DetailAlbedoMap);
                //  Fade out base texture (details)
                    #if defined(GEOM_TYPE_BRANCH_DETAIL) && defined(LOD_FADE_PERCENTAGE)
                        c = lerp(c, _AverageCol, unity_LODFade.x);
                        bumpSpecAO = lerp(bumpSpecAO, fixed4(unity_ColorSpaceDielectricSpec.r, 0.5, 1, 0.5), unity_LODFade.x);
                    #endif
                #endif
        
        //  Regular UVs     
            #else
            //  Skip base textures (details)
                #if defined(GEOM_TYPE_FROND)
                    fixed4 c = _AverageCol;
                    fixed4 bumpSpecAO = fixed4(unity_ColorSpaceDielectricSpec.r, 0.5, 1, 0.5);
                #else
                    fixed4 c = tex2D(_MainTex, IN.uv_MainTex.xy);
                    fixed4 bumpSpecAO = tex2D(_BumpSpecAOMap, IN.uv_MainTex.xy);
                //  Fade out base texture (details)
                    #if defined(GEOM_TYPE_BRANCH_DETAIL) && defined(LOD_FADE_PERCENTAGE)
                        c = lerp(c, _AverageCol, unity_LODFade.x);
                        bumpSpecAO = lerp(bumpSpecAO, fixed4(unity_ColorSpaceDielectricSpec.r, 0.5, 1, 0.5), unity_LODFade.x);
                    #endif
                #endif
            #endif

            o.Albedo = lerp(c.rgb, (c.rgb + _HueVariation.rgb) * 0.5, IN.color.r * _HueVariation.a);
            o.Smoothness = c.a * _HueVariation.r;
            o.Occlusion = bumpSpecAO.b * IN.color.a;
            o.Alpha = c.a;
            o.Specular = bumpSpecAO.r;

            #if defined(GEOM_TYPE_BRANCH) || defined(GEOM_TYPE_BRANCH_DETAIL) || defined(GEOM_TYPE_FROND)

                #if !defined (_SWAP_UVS)
                    fixed4 detailAlbedo = tex2D(_DetailAlbedoMap, IN.uv2_DetailAlbedoMap);
                    fixed4 detailNormalSample = tex2D(_DetailNormalMapX, IN.uv2_DetailAlbedoMap);
                #else
                    fixed4 detailAlbedo = tex2D(_DetailAlbedoMap, IN.uv_MainTex);
                    fixed4 detailNormalSample = tex2D(_DetailNormalMapX, IN.uv_MainTex);
                #endif
                
            //  Here we use a custom function to make sure it works in all versions of Unity
                half3 detailNormalTangent = CTI_UnpackScaleNormal( detailNormalSample, _DetailNormalMapScale);

                o.Albedo *= detailAlbedo.rgb * unity_ColorSpaceDouble.rgb;
                o.Smoothness = (o.Smoothness + detailAlbedo.a) * 0.5;
                o.Specular = (o.Specular + detailNormalSample.rrr) * 0.5;
                o.Occlusion *= detailNormalSample.b;

            #endif

        //  Get normal
            #if defined(GEOM_TYPE_FROND)
                o.Normal = detailNormalTangent;
            #else
            //  Here we use a custom function to make sure it works in all versions of Unity
                o.Normal = CTI_UnpackScaleNormal( bumpSpecAO, 1.0 + _Displacement);
            #endif
        //  Fade out base texture (details)
            #if defined(GEOM_TYPE_BRANCH_DETAIL) && defined(LOD_FADE_PERCENTAGE)
                o.Normal = lerp(o.Normal, half3(0,0,1), unity_LODFade.x);
            #endif
        //  Blend normals from UV2
            #if defined(GEOM_TYPE_BRANCH) || defined(GEOM_TYPE_BRANCH_DETAIL)
                o.Normal = BlendNormals(o.Normal, detailNormalTangent);
            #endif
        }
    ENDCG
}
FallBack "CTI/LOD Bark"
CustomEditor "CTI_ShaderGUI"
}