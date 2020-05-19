// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:32716,y:32678,varname:node_4795,prsc:2|alpha-7425-OUT,refract-1686-OUT;n:type:ShaderForge.SFN_Tex2d,id:6074,x:31991,y:32649,ptovrint:False,ptlb:Normal,ptin:_Normal,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:875500ca4a52a0840a1058bc943e6489,ntxv:3,isnm:True|UVIN-7504-UVOUT;n:type:ShaderForge.SFN_ComponentMask,id:7380,x:32311,y:32819,varname:node_7380,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-6074-RGB;n:type:ShaderForge.SFN_Multiply,id:1686,x:32524,y:32936,varname:node_1686,prsc:2|A-7380-OUT,B-4087-OUT;n:type:ShaderForge.SFN_Slider,id:4087,x:32174,y:33017,ptovrint:False,ptlb:Refraction Amount,ptin:_RefractionAmount,varname:node_4087,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.01,max:0.025;n:type:ShaderForge.SFN_Vector1,id:7425,x:32378,y:33226,varname:node_7425,prsc:2,v1:0;n:type:ShaderForge.SFN_Rotator,id:7504,x:31763,y:32649,varname:node_7504,prsc:2|UVIN-8518-UVOUT,SPD-5127-OUT;n:type:ShaderForge.SFN_Vector1,id:5127,x:31482,y:32783,varname:node_5127,prsc:2,v1:0.1;n:type:ShaderForge.SFN_TexCoord,id:8518,x:31445,y:32526,varname:node_8518,prsc:2,uv:0,uaff:False;proporder:6074-4087;pass:END;sub:END;*/

Shader "Shader Forge/TFP_Particle_Displace" {
    Properties {
        _Normal ("Normal", 2D) = "bump" {}
        _RefractionAmount ("Refraction Amount", Range(0, 0.025)) = 0.01
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        GrabPass{ }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles n3ds wiiu 
            #pragma target 3.0
            uniform sampler2D _GrabTexture;
            uniform sampler2D _Normal; uniform float4 _Normal_ST;
            uniform float _RefractionAmount;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 projPos : TEXCOORD1;
                UNITY_FOG_COORDS(2)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float4 node_5738 = _Time;
                float node_7504_ang = node_5738.g;
                float node_7504_spd = 0.1;
                float node_7504_cos = cos(node_7504_spd*node_7504_ang);
                float node_7504_sin = sin(node_7504_spd*node_7504_ang);
                float2 node_7504_piv = float2(0.5,0.5);
                float2 node_7504 = (mul(i.uv0-node_7504_piv,float2x2( node_7504_cos, -node_7504_sin, node_7504_sin, node_7504_cos))+node_7504_piv);
                float3 _Normal_var = UnpackNormal(tex2D(_Normal,TRANSFORM_TEX(node_7504, _Normal)));
                float2 sceneUVs = (i.projPos.xy / i.projPos.w) + (_Normal_var.rgb.rg*_RefractionAmount);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
////// Lighting:
                float3 finalColor = 0;
                fixed4 finalRGBA = fixed4(lerp(sceneColor.rgb, finalColor,0.0),1);
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
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
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
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
