// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:Standard (Specular setup),iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:3,spmd:1,trmd:1,grmd:1,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:True,enco:False,rmgx:True,imps:True,rpth:1,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:1,olmd:1,culm:2,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:3,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.4985801,fgcg:0.5,fgcb:0.4742647,fgca:1,fgde:0.002,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:2865,x:32719,y:32712,varname:node_2865,prsc:2|diff-4476-RGB,spec-7389-OUT,gloss-1956-OUT,normal-380-OUT;n:type:ShaderForge.SFN_Vector1,id:7389,x:32402,y:32748,varname:node_7389,prsc:2,v1:0;n:type:ShaderForge.SFN_Vector1,id:1956,x:32402,y:32806,varname:node_1956,prsc:2,v1:0.075;n:type:ShaderForge.SFN_Color,id:4476,x:32097,y:32502,ptovrint:False,ptlb:Fog Color,ptin:_FogColor,varname:_DepthColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.2666667,c2:0.4078432,c3:0.4196079,c4:1;n:type:ShaderForge.SFN_ValueProperty,id:9755,x:24703,y:35709,ptovrint:False,ptlb:U Speed,ptin:_USpeed,varname:_USpeed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_ValueProperty,id:8588,x:24703,y:35791,ptovrint:False,ptlb:V Speed,ptin:_VSpeed,varname:_VSpeed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.5;n:type:ShaderForge.SFN_Append,id:6552,x:25205,y:35720,varname:node_6552,prsc:2|A-7691-OUT,B-80-OUT;n:type:ShaderForge.SFN_Multiply,id:7614,x:25418,y:35720,varname:node_7614,prsc:2|A-6552-OUT,B-6908-T;n:type:ShaderForge.SFN_Time,id:6908,x:25205,y:35873,varname:node_6908,prsc:2;n:type:ShaderForge.SFN_TexCoord,id:142,x:26170,y:34416,varname:node_142,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Add,id:493,x:26972,y:34935,varname:node_493,prsc:2|A-8720-OUT,B-7614-OUT;n:type:ShaderForge.SFN_ValueProperty,id:2368,x:26170,y:34590,ptovrint:False,ptlb:Tiling,ptin:_Tiling,varname:_Tiling,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:8720,x:26343,y:34444,varname:node_8720,prsc:2|A-142-UVOUT,B-2368-OUT;n:type:ShaderForge.SFN_Tex2dAsset,id:3893,x:27938,y:32079,ptovrint:False,ptlb:Water Normal,ptin:_WaterNormal,varname:_WaterNormal,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:62d4b982696bb42478a854ec25d05508,ntxv:3,isnm:True;n:type:ShaderForge.SFN_Tex2d,id:1931,x:28856,y:31764,varname:node_1931,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-493-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Multiply,id:6101,x:28686,y:31594,varname:node_6101,prsc:2|A-493-OUT,B-2562-OUT;n:type:ShaderForge.SFN_Vector1,id:2562,x:28522,y:31628,varname:node_2562,prsc:2,v1:0.25;n:type:ShaderForge.SFN_Tex2d,id:2922,x:28856,y:31594,varname:node_2922,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-6101-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Tex2d,id:2609,x:28856,y:31961,varname:node_2609,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-7111-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Vector1,id:9807,x:28524,y:31995,varname:node_9807,prsc:2,v1:5;n:type:ShaderForge.SFN_Multiply,id:7111,x:28692,y:31961,varname:node_7111,prsc:2|A-4387-OUT,B-9807-OUT;n:type:ShaderForge.SFN_Add,id:4387,x:26972,y:35064,varname:node_4387,prsc:2|A-8720-OUT,B-3961-OUT;n:type:ShaderForge.SFN_Append,id:5448,x:25224,y:36347,varname:node_5448,prsc:2|A-7691-OUT,B-80-OUT;n:type:ShaderForge.SFN_Multiply,id:3961,x:25577,y:36347,varname:node_3961,prsc:2|A-1653-OUT,B-6908-T;n:type:ShaderForge.SFN_Multiply,id:1653,x:25404,y:36347,varname:node_1653,prsc:2|A-5448-OUT,B-4254-OUT;n:type:ShaderForge.SFN_Vector1,id:4254,x:25224,y:36507,varname:node_4254,prsc:2,v1:0.75;n:type:ShaderForge.SFN_Lerp,id:2011,x:30048,y:32595,varname:node_2011,prsc:2|A-9596-OUT,B-9728-OUT,T-4538-Z;n:type:ShaderForge.SFN_Vector4Property,id:4538,x:29752,y:32599,ptovrint:False,ptlb:Wave Scale,ptin:_WaveScale,varname:_WaveScale,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.1,v2:0.15,v3:0.25,v4:0.5;n:type:ShaderForge.SFN_Lerp,id:1495,x:30048,y:32725,varname:node_1495,prsc:2|A-2011-OUT,B-562-OUT,T-4538-Y;n:type:ShaderForge.SFN_Normalize,id:380,x:30242,y:32847,varname:node_380,prsc:2|IN-8314-OUT;n:type:ShaderForge.SFN_Vector1,id:2592,x:28522,y:31359,varname:node_2592,prsc:2,v1:0.05;n:type:ShaderForge.SFN_Multiply,id:1783,x:28689,y:31325,varname:node_1783,prsc:2|A-493-OUT,B-2592-OUT;n:type:ShaderForge.SFN_Tex2d,id:2649,x:28855,y:31325,varname:node_2649,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-1783-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Lerp,id:9596,x:30048,y:32466,varname:node_9596,prsc:2|A-7581-OUT,B-5117-OUT,T-4538-W;n:type:ShaderForge.SFN_Multiply,id:7691,x:24945,y:35665,varname:node_7691,prsc:2|A-9755-OUT,B-8631-OUT;n:type:ShaderForge.SFN_Multiply,id:80,x:24945,y:35807,varname:node_80,prsc:2|A-8588-OUT,B-8631-OUT;n:type:ShaderForge.SFN_Vector1,id:8631,x:24685,y:35939,varname:node_8631,prsc:2,v1:0.2;n:type:ShaderForge.SFN_RemapRange,id:8449,x:25122,y:36689,varname:node_8449,prsc:2,frmn:0,frmx:1,tomn:1,tomx:-5|IN-9755-OUT;n:type:ShaderForge.SFN_Multiply,id:8891,x:25297,y:36689,varname:node_8891,prsc:2|A-8449-OUT,B-3599-OUT;n:type:ShaderForge.SFN_Vector1,id:3599,x:25122,y:36854,varname:node_3599,prsc:2,v1:0.03;n:type:ShaderForge.SFN_RemapRange,id:8173,x:25122,y:36916,varname:node_8173,prsc:2,frmn:0,frmx:1,tomn:0.5,tomx:-0.25|IN-8588-OUT;n:type:ShaderForge.SFN_Multiply,id:1782,x:25297,y:36916,varname:node_1782,prsc:2|A-8173-OUT,B-4064-OUT,C-5360-OUT;n:type:ShaderForge.SFN_Add,id:5804,x:26972,y:35198,varname:node_5804,prsc:2|A-4063-OUT,B-5716-OUT;n:type:ShaderForge.SFN_Add,id:4860,x:26972,y:35348,varname:node_4860,prsc:2|A-4063-OUT,B-7786-OUT;n:type:ShaderForge.SFN_Append,id:4310,x:25507,y:36800,varname:node_4310,prsc:2|A-8891-OUT,B-1782-OUT;n:type:ShaderForge.SFN_Multiply,id:5716,x:25840,y:36804,varname:node_5716,prsc:2|A-3509-OUT,B-6908-T;n:type:ShaderForge.SFN_Multiply,id:5532,x:25673,y:36966,varname:node_5532,prsc:2|A-4310-OUT,B-2243-OUT;n:type:ShaderForge.SFN_Vector1,id:2243,x:25507,y:37071,varname:node_2243,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Multiply,id:7786,x:25840,y:36966,varname:node_7786,prsc:2|A-5532-OUT,B-6908-T;n:type:ShaderForge.SFN_Multiply,id:4063,x:26682,y:35350,varname:node_4063,prsc:2|A-142-UVOUT,B-8092-OUT;n:type:ShaderForge.SFN_Vector1,id:4064,x:25122,y:37087,varname:node_4064,prsc:2,v1:-1;n:type:ShaderForge.SFN_Multiply,id:8092,x:26448,y:35350,varname:node_8092,prsc:2|A-2368-OUT,B-7017-OUT;n:type:ShaderForge.SFN_Vector1,id:7017,x:26213,y:35426,varname:node_7017,prsc:2,v1:0.9;n:type:ShaderForge.SFN_Negate,id:3509,x:25673,y:36804,varname:node_3509,prsc:2|IN-4310-OUT;n:type:ShaderForge.SFN_Vector1,id:5360,x:25122,y:37145,varname:node_5360,prsc:2,v1:0.05;n:type:ShaderForge.SFN_Vector1,id:4887,x:28524,y:32218,varname:node_4887,prsc:2,v1:10;n:type:ShaderForge.SFN_Multiply,id:4966,x:28692,y:32184,varname:node_4966,prsc:2|A-4387-OUT,B-4887-OUT;n:type:ShaderForge.SFN_Lerp,id:8314,x:30048,y:32847,varname:node_8314,prsc:2|A-1495-OUT,B-5298-OUT,T-4538-X;n:type:ShaderForge.SFN_Tex2d,id:4345,x:28856,y:32184,varname:node_4345,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-4966-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Multiply,id:1725,x:28696,y:32680,varname:node_1725,prsc:2|A-5804-OUT,B-2473-OUT;n:type:ShaderForge.SFN_Vector1,id:2473,x:28532,y:32714,varname:node_2473,prsc:2,v1:0.25;n:type:ShaderForge.SFN_Vector1,id:6372,x:28534,y:33081,varname:node_6372,prsc:2,v1:5;n:type:ShaderForge.SFN_Multiply,id:8370,x:28702,y:33047,varname:node_8370,prsc:2|A-4860-OUT,B-6372-OUT;n:type:ShaderForge.SFN_Vector1,id:2958,x:28532,y:32445,varname:node_2958,prsc:2,v1:0.05;n:type:ShaderForge.SFN_Multiply,id:1506,x:28699,y:32411,varname:node_1506,prsc:2|A-5804-OUT,B-2958-OUT;n:type:ShaderForge.SFN_Vector1,id:8964,x:28534,y:33304,varname:node_8964,prsc:2,v1:10;n:type:ShaderForge.SFN_Multiply,id:525,x:28702,y:33270,varname:node_525,prsc:2|A-4797-OUT,B-8964-OUT;n:type:ShaderForge.SFN_Tex2d,id:5467,x:28871,y:32411,varname:node_5467,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-1506-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Tex2d,id:3704,x:28872,y:32693,varname:node_3704,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-1725-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Tex2d,id:9479,x:28872,y:32872,varname:node_9479,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-5804-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Tex2d,id:1345,x:28872,y:33063,varname:node_1345,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-8370-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Tex2d,id:1813,x:28872,y:33270,varname:node_1813,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-525-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Lerp,id:7581,x:29333,y:32317,varname:node_7581,prsc:2|A-2649-RGB,B-5467-RGB,T-4262-OUT;n:type:ShaderForge.SFN_Vector1,id:4262,x:29111,y:32643,varname:node_4262,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Lerp,id:5117,x:29333,y:32466,varname:node_5117,prsc:2|A-2922-RGB,B-3704-RGB,T-4262-OUT;n:type:ShaderForge.SFN_Lerp,id:9728,x:29333,y:32596,varname:node_9728,prsc:2|A-1931-RGB,B-9479-RGB,T-4262-OUT;n:type:ShaderForge.SFN_Lerp,id:562,x:29333,y:32736,varname:node_562,prsc:2|A-2609-RGB,B-1345-RGB,T-4262-OUT;n:type:ShaderForge.SFN_Lerp,id:5298,x:29333,y:32906,varname:node_5298,prsc:2|A-4345-RGB,B-1813-RGB,T-4262-OUT;n:type:ShaderForge.SFN_Multiply,id:9209,x:25673,y:37139,varname:node_9209,prsc:2|A-4310-OUT,B-2913-OUT;n:type:ShaderForge.SFN_Multiply,id:684,x:25840,y:37139,varname:node_684,prsc:2|A-9209-OUT,B-6908-T;n:type:ShaderForge.SFN_Vector1,id:2913,x:25507,y:37205,varname:node_2913,prsc:2,v1:0.3;n:type:ShaderForge.SFN_Add,id:4797,x:26972,y:35482,varname:node_4797,prsc:2|A-4063-OUT,B-684-OUT;proporder:4476-3893-4538-9755-8588-2368;pass:END;sub:END;*/

Shader "TFP/TFP_Water" {
    Properties {
        _FogColor ("Fog Color", Color) = (0.2666667,0.4078432,0.4196079,1)
        _WaterNormal ("Water Normal", 2D) = "bump" {}
        _WaveScale ("Wave Scale", Vector) = (0.1,0.15,0.25,0.5)
        _USpeed ("U Speed", Float ) = 1
        _VSpeed ("V Speed", Float ) = 0.5
        _Tiling ("Tiling", Float ) = 1
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        LOD 3000
        Pass {
            Name "DEFERRED"
            Tags {
                "LightMode"="Deferred"
            }
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile ___ UNITY_HDR_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles n3ds wiiu 
            #pragma target 3.0
            uniform float4 _FogColor;
            uniform float _USpeed;
            uniform float _VSpeed;
            uniform float _Tiling;
            uniform sampler2D _WaterNormal; uniform float4 _WaterNormal_ST;
            uniform float4 _WaveScale;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            void frag(
                VertexOutput i,
                out half4 outDiffuse : SV_Target0,
                out half4 outSpecSmoothness : SV_Target1,
                out half4 outNormal : SV_Target2,
                out half4 outEmission : SV_Target3,
                float facing : VFACE )
            {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float2 node_8720 = (i.uv0*_Tiling);
                float node_8631 = 0.2;
                float node_7691 = (_USpeed*node_8631);
                float node_80 = (_VSpeed*node_8631);
                float4 node_6908 = _Time;
                float2 node_493 = (node_8720+(float2(node_7691,node_80)*node_6908.g));
                float2 node_1783 = (node_493*0.05);
                float3 node_2649 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_1783, _WaterNormal)));
                float2 node_4063 = (i.uv0*(_Tiling*0.9));
                float2 node_4310 = float2(((_USpeed*-6.0+1.0)*0.03),((_VSpeed*-0.75+0.5)*(-1.0)*0.05));
                float2 node_5804 = (node_4063+((-1*node_4310)*node_6908.g));
                float2 node_1506 = (node_5804*0.05);
                float3 node_5467 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_1506, _WaterNormal)));
                float node_4262 = 0.5;
                float2 node_6101 = (node_493*0.25);
                float3 node_2922 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_6101, _WaterNormal)));
                float2 node_1725 = (node_5804*0.25);
                float3 node_3704 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_1725, _WaterNormal)));
                float3 node_1931 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_493, _WaterNormal)));
                float3 node_9479 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_5804, _WaterNormal)));
                float2 node_4387 = (node_8720+((float2(node_7691,node_80)*0.75)*node_6908.g));
                float2 node_7111 = (node_4387*5.0);
                float3 node_2609 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_7111, _WaterNormal)));
                float2 node_8370 = ((node_4063+((node_4310*0.5)*node_6908.g))*5.0);
                float3 node_1345 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_8370, _WaterNormal)));
                float2 node_4966 = (node_4387*10.0);
                float3 node_4345 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_4966, _WaterNormal)));
                float2 node_525 = ((node_4063+((node_4310*0.3)*node_6908.g))*10.0);
                float3 node_1813 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_525, _WaterNormal)));
                float3 normalLocal = normalize(lerp(lerp(lerp(lerp(lerp(node_2649.rgb,node_5467.rgb,node_4262),lerp(node_2922.rgb,node_3704.rgb,node_4262),_WaveScale.a),lerp(node_1931.rgb,node_9479.rgb,node_4262),_WaveScale.b),lerp(node_2609.rgb,node_1345.rgb,node_4262),_WaveScale.g),lerp(node_4345.rgb,node_1813.rgb,node_4262),_WaveScale.r));
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
////// Lighting:
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float gloss = 1.0 - 0.075; // Convert roughness to gloss
                float perceptualRoughness = 0.075;
                float roughness = perceptualRoughness * perceptualRoughness;
/////// GI Data:
                UnityLight light; // Dummy light
                light.color = 0;
                light.dir = half3(0,1,0);
                light.ndotl = max(0,dot(normalDirection,light.dir));
                UnityGIInput d;
                d.light = light;
                d.worldPos = i.posWorld.xyz;
                d.worldViewDir = viewDirection;
                d.atten = 1;
                #if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION
                    d.boxMin[0] = unity_SpecCube0_BoxMin;
                    d.boxMin[1] = unity_SpecCube1_BoxMin;
                #endif
                #if UNITY_SPECCUBE_BOX_PROJECTION
                    d.boxMax[0] = unity_SpecCube0_BoxMax;
                    d.boxMax[1] = unity_SpecCube1_BoxMax;
                    d.probePosition[0] = unity_SpecCube0_ProbePosition;
                    d.probePosition[1] = unity_SpecCube1_ProbePosition;
                #endif
                d.probeHDR[0] = unity_SpecCube0_HDR;
                d.probeHDR[1] = unity_SpecCube1_HDR;
                Unity_GlossyEnvironmentData ugls_en_data;
                ugls_en_data.roughness = 1.0 - gloss;
                ugls_en_data.reflUVW = viewReflectDirection;
                UnityGI gi = UnityGlobalIllumination(d, 1, normalDirection, ugls_en_data );
////// Specular:
                float3 specularColor = 0.0;
                float specularMonochrome;
                float3 diffuseColor = _FogColor.rgb; // Need this for specular when using metallic
                diffuseColor = DiffuseAndSpecularFromMetallic( diffuseColor, specularColor, specularColor, specularMonochrome );
                specularMonochrome = 1.0-specularMonochrome;
                float NdotV = max(0.0,dot( normalDirection, viewDirection ));
                half grazingTerm = saturate( gloss + specularMonochrome );
                float3 indirectSpecular = (gi.indirect.specular);
                indirectSpecular *= FresnelLerp (specularColor, grazingTerm, NdotV);
/////// Diffuse:
/// Final Color:
                outDiffuse = half4( diffuseColor, 1 );
                outSpecSmoothness = half4( specularColor, gloss );
                outNormal = half4( normalDirection * 0.5 + 0.5, 1 );
                outEmission = half4(0,0,0,1);
                #ifndef UNITY_HDR_ON
                    outEmission.rgb = exp2(-outEmission.rgb);
                #endif
            }
            ENDCG
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles n3ds wiiu 
            #pragma target 3.0
            uniform float4 _FogColor;
            uniform float _USpeed;
            uniform float _VSpeed;
            uniform float _Tiling;
            uniform sampler2D _WaterNormal; uniform float4 _WaterNormal_ST;
            uniform float4 _WaveScale;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
                UNITY_FOG_COORDS(7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float2 node_8720 = (i.uv0*_Tiling);
                float node_8631 = 0.2;
                float node_7691 = (_USpeed*node_8631);
                float node_80 = (_VSpeed*node_8631);
                float4 node_6908 = _Time;
                float2 node_493 = (node_8720+(float2(node_7691,node_80)*node_6908.g));
                float2 node_1783 = (node_493*0.05);
                float3 node_2649 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_1783, _WaterNormal)));
                float2 node_4063 = (i.uv0*(_Tiling*0.9));
                float2 node_4310 = float2(((_USpeed*-6.0+1.0)*0.03),((_VSpeed*-0.75+0.5)*(-1.0)*0.05));
                float2 node_5804 = (node_4063+((-1*node_4310)*node_6908.g));
                float2 node_1506 = (node_5804*0.05);
                float3 node_5467 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_1506, _WaterNormal)));
                float node_4262 = 0.5;
                float2 node_6101 = (node_493*0.25);
                float3 node_2922 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_6101, _WaterNormal)));
                float2 node_1725 = (node_5804*0.25);
                float3 node_3704 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_1725, _WaterNormal)));
                float3 node_1931 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_493, _WaterNormal)));
                float3 node_9479 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_5804, _WaterNormal)));
                float2 node_4387 = (node_8720+((float2(node_7691,node_80)*0.75)*node_6908.g));
                float2 node_7111 = (node_4387*5.0);
                float3 node_2609 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_7111, _WaterNormal)));
                float2 node_8370 = ((node_4063+((node_4310*0.5)*node_6908.g))*5.0);
                float3 node_1345 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_8370, _WaterNormal)));
                float2 node_4966 = (node_4387*10.0);
                float3 node_4345 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_4966, _WaterNormal)));
                float2 node_525 = ((node_4063+((node_4310*0.3)*node_6908.g))*10.0);
                float3 node_1813 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_525, _WaterNormal)));
                float3 normalLocal = normalize(lerp(lerp(lerp(lerp(lerp(node_2649.rgb,node_5467.rgb,node_4262),lerp(node_2922.rgb,node_3704.rgb,node_4262),_WaveScale.a),lerp(node_1931.rgb,node_9479.rgb,node_4262),_WaveScale.b),lerp(node_2609.rgb,node_1345.rgb,node_4262),_WaveScale.g),lerp(node_4345.rgb,node_1813.rgb,node_4262),_WaveScale.r));
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                UNITY_LIGHT_ATTENUATION(attenuation,i, i.posWorld.xyz);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float gloss = 1.0 - 0.075; // Convert roughness to gloss
                float perceptualRoughness = 0.075;
                float roughness = perceptualRoughness * perceptualRoughness;
                float specPow = exp2( gloss * 10.0 + 1.0 );
/////// GI Data:
                UnityLight light;
                #ifdef LIGHTMAP_OFF
                    light.color = lightColor;
                    light.dir = lightDirection;
                    light.ndotl = LambertTerm (normalDirection, light.dir);
                #else
                    light.color = half3(0.f, 0.f, 0.f);
                    light.ndotl = 0.0f;
                    light.dir = half3(0.f, 0.f, 0.f);
                #endif
                UnityGIInput d;
                d.light = light;
                d.worldPos = i.posWorld.xyz;
                d.worldViewDir = viewDirection;
                d.atten = attenuation;
                #if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION
                    d.boxMin[0] = unity_SpecCube0_BoxMin;
                    d.boxMin[1] = unity_SpecCube1_BoxMin;
                #endif
                #if UNITY_SPECCUBE_BOX_PROJECTION
                    d.boxMax[0] = unity_SpecCube0_BoxMax;
                    d.boxMax[1] = unity_SpecCube1_BoxMax;
                    d.probePosition[0] = unity_SpecCube0_ProbePosition;
                    d.probePosition[1] = unity_SpecCube1_ProbePosition;
                #endif
                d.probeHDR[0] = unity_SpecCube0_HDR;
                d.probeHDR[1] = unity_SpecCube1_HDR;
                Unity_GlossyEnvironmentData ugls_en_data;
                ugls_en_data.roughness = 1.0 - gloss;
                ugls_en_data.reflUVW = viewReflectDirection;
                UnityGI gi = UnityGlobalIllumination(d, 1, normalDirection, ugls_en_data );
                lightDirection = gi.light.dir;
                lightColor = gi.light.color;
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float LdotH = saturate(dot(lightDirection, halfDirection));
                float3 specularColor = 0.0;
                float specularMonochrome;
                float3 diffuseColor = _FogColor.rgb; // Need this for specular when using metallic
                diffuseColor = DiffuseAndSpecularFromMetallic( diffuseColor, specularColor, specularColor, specularMonochrome );
                specularMonochrome = 1.0-specularMonochrome;
                float NdotV = abs(dot( normalDirection, viewDirection ));
                float NdotH = saturate(dot( normalDirection, halfDirection ));
                float VdotH = saturate(dot( viewDirection, halfDirection ));
                float visTerm = SmithJointGGXVisibilityTerm( NdotL, NdotV, roughness );
                float normTerm = GGXTerm(NdotH, roughness);
                float specularPBL = (visTerm*normTerm) * UNITY_PI;
                #ifdef UNITY_COLORSPACE_GAMMA
                    specularPBL = sqrt(max(1e-4h, specularPBL));
                #endif
                specularPBL = max(0, specularPBL * NdotL);
                #if defined(_SPECULARHIGHLIGHTS_OFF)
                    specularPBL = 0.0;
                #endif
                half surfaceReduction;
                #ifdef UNITY_COLORSPACE_GAMMA
                    surfaceReduction = 1.0-0.28*roughness*perceptualRoughness;
                #else
                    surfaceReduction = 1.0/(roughness*roughness + 1.0);
                #endif
                specularPBL *= any(specularColor) ? 1.0 : 0.0;
                float3 directSpecular = attenColor*specularPBL*FresnelTerm(specularColor, LdotH);
                half grazingTerm = saturate( gloss + specularMonochrome );
                float3 indirectSpecular = (gi.indirect.specular);
                indirectSpecular *= FresnelLerp (specularColor, grazingTerm, NdotV);
                indirectSpecular *= surfaceReduction;
                float3 specular = (directSpecular + indirectSpecular);
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float nlPow5 = Pow5(1-NdotL);
                float nvPow5 = Pow5(1-NdotV);
                float3 directDiffuse = ((1 +(fd90 - 1)*nlPow5) * (1 + (fd90 - 1)*nvPow5) * NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse + specular;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles n3ds wiiu 
            #pragma target 3.0
            uniform float4 _FogColor;
            uniform float _USpeed;
            uniform float _VSpeed;
            uniform float _Tiling;
            uniform sampler2D _WaterNormal; uniform float4 _WaterNormal_ST;
            uniform float4 _WaveScale;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
                UNITY_FOG_COORDS(7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float2 node_8720 = (i.uv0*_Tiling);
                float node_8631 = 0.2;
                float node_7691 = (_USpeed*node_8631);
                float node_80 = (_VSpeed*node_8631);
                float4 node_6908 = _Time;
                float2 node_493 = (node_8720+(float2(node_7691,node_80)*node_6908.g));
                float2 node_1783 = (node_493*0.05);
                float3 node_2649 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_1783, _WaterNormal)));
                float2 node_4063 = (i.uv0*(_Tiling*0.9));
                float2 node_4310 = float2(((_USpeed*-6.0+1.0)*0.03),((_VSpeed*-0.75+0.5)*(-1.0)*0.05));
                float2 node_5804 = (node_4063+((-1*node_4310)*node_6908.g));
                float2 node_1506 = (node_5804*0.05);
                float3 node_5467 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_1506, _WaterNormal)));
                float node_4262 = 0.5;
                float2 node_6101 = (node_493*0.25);
                float3 node_2922 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_6101, _WaterNormal)));
                float2 node_1725 = (node_5804*0.25);
                float3 node_3704 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_1725, _WaterNormal)));
                float3 node_1931 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_493, _WaterNormal)));
                float3 node_9479 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_5804, _WaterNormal)));
                float2 node_4387 = (node_8720+((float2(node_7691,node_80)*0.75)*node_6908.g));
                float2 node_7111 = (node_4387*5.0);
                float3 node_2609 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_7111, _WaterNormal)));
                float2 node_8370 = ((node_4063+((node_4310*0.5)*node_6908.g))*5.0);
                float3 node_1345 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_8370, _WaterNormal)));
                float2 node_4966 = (node_4387*10.0);
                float3 node_4345 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_4966, _WaterNormal)));
                float2 node_525 = ((node_4063+((node_4310*0.3)*node_6908.g))*10.0);
                float3 node_1813 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_525, _WaterNormal)));
                float3 normalLocal = normalize(lerp(lerp(lerp(lerp(lerp(node_2649.rgb,node_5467.rgb,node_4262),lerp(node_2922.rgb,node_3704.rgb,node_4262),_WaveScale.a),lerp(node_1931.rgb,node_9479.rgb,node_4262),_WaveScale.b),lerp(node_2609.rgb,node_1345.rgb,node_4262),_WaveScale.g),lerp(node_4345.rgb,node_1813.rgb,node_4262),_WaveScale.r));
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                UNITY_LIGHT_ATTENUATION(attenuation,i, i.posWorld.xyz);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float gloss = 1.0 - 0.075; // Convert roughness to gloss
                float perceptualRoughness = 0.075;
                float roughness = perceptualRoughness * perceptualRoughness;
                float specPow = exp2( gloss * 10.0 + 1.0 );
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float LdotH = saturate(dot(lightDirection, halfDirection));
                float3 specularColor = 0.0;
                float specularMonochrome;
                float3 diffuseColor = _FogColor.rgb; // Need this for specular when using metallic
                diffuseColor = DiffuseAndSpecularFromMetallic( diffuseColor, specularColor, specularColor, specularMonochrome );
                specularMonochrome = 1.0-specularMonochrome;
                float NdotV = abs(dot( normalDirection, viewDirection ));
                float NdotH = saturate(dot( normalDirection, halfDirection ));
                float VdotH = saturate(dot( viewDirection, halfDirection ));
                float visTerm = SmithJointGGXVisibilityTerm( NdotL, NdotV, roughness );
                float normTerm = GGXTerm(NdotH, roughness);
                float specularPBL = (visTerm*normTerm) * UNITY_PI;
                #ifdef UNITY_COLORSPACE_GAMMA
                    specularPBL = sqrt(max(1e-4h, specularPBL));
                #endif
                specularPBL = max(0, specularPBL * NdotL);
                #if defined(_SPECULARHIGHLIGHTS_OFF)
                    specularPBL = 0.0;
                #endif
                specularPBL *= any(specularColor) ? 1.0 : 0.0;
                float3 directSpecular = attenColor*specularPBL*FresnelTerm(specularColor, LdotH);
                float3 specular = directSpecular;
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float nlPow5 = Pow5(1-NdotL);
                float nvPow5 = Pow5(1-NdotV);
                float3 directDiffuse = ((1 +(fd90 - 1)*nlPow5) * (1 + (fd90 - 1)*nvPow5) * NdotL) * attenColor;
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse + specular;
                fixed4 finalRGBA = fixed4(finalColor,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles n3ds wiiu 
            #pragma target 3.0
            struct VertexInput {
                float4 vertex : POSITION;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Standard (Specular setup)"
    CustomEditor "ShaderForgeMaterialInspector"
}
