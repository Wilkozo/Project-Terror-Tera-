// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:Standard (Specular setup),iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:3,spmd:1,trmd:1,grmd:1,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:True,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:1,olmd:1,culm:2,bsrc:0,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:2865,x:32719,y:32712,varname:node_2865,prsc:2|diff-251-OUT,spec-7389-OUT,gloss-1956-OUT,normal-380-OUT,transm-9178-OUT,lwrap-9178-OUT,alpha-44-OUT,refract-3910-OUT,disp-6836-OUT,tess-2892-OUT;n:type:ShaderForge.SFN_Vector1,id:7389,x:32402,y:32748,varname:node_7389,prsc:2,v1:0;n:type:ShaderForge.SFN_Vector1,id:1956,x:32402,y:32806,varname:node_1956,prsc:2,v1:0.03;n:type:ShaderForge.SFN_Tex2d,id:8613,x:29966,y:36817,varname:node_8613,prsc:2,tex:5ba7e55a76e1c96429df464106c2eac1,ntxv:2,isnm:False|UVIN-493-OUT,TEX-348-TEX;n:type:ShaderForge.SFN_ValueProperty,id:1676,x:32232,y:33115,ptovrint:False,ptlb:Tesselation,ptin:_Tesselation,varname:_Tesselation,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_NormalVector,id:450,x:29966,y:36938,prsc:2,pt:False;n:type:ShaderForge.SFN_Multiply,id:4300,x:30126,y:36817,varname:node_4300,prsc:2|A-8613-RGB,B-450-OUT;n:type:ShaderForge.SFN_Multiply,id:3778,x:30294,y:36817,varname:node_3778,prsc:2|A-4300-OUT,B-4893-OUT;n:type:ShaderForge.SFN_ValueProperty,id:4893,x:28263,y:36986,ptovrint:False,ptlb:Small Wave Height,ptin:_SmallWaveHeight,varname:_SmallWaveHeight,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.5;n:type:ShaderForge.SFN_ValueProperty,id:6002,x:28263,y:36891,ptovrint:False,ptlb:Secondary Wave Height,ptin:_SecondaryWaveHeight,varname:_SecondaryWaveHeight,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.5;n:type:ShaderForge.SFN_Color,id:4476,x:29535,y:30225,ptovrint:False,ptlb:Fog Color,ptin:_FogColor,varname:_DepthColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.2666667,c2:0.4078432,c3:0.4196079,c4:1;n:type:ShaderForge.SFN_DepthBlend,id:8459,x:29431,y:30436,varname:node_8459,prsc:2|DIST-365-OUT;n:type:ShaderForge.SFN_Multiply,id:3422,x:29764,y:30315,varname:node_3422,prsc:2|A-4476-RGB,B-8459-OUT;n:type:ShaderForge.SFN_Tex2dAsset,id:348,x:28989,y:37286,ptovrint:False,ptlb:Water Height,ptin:_WaterHeight,varname:_WaterHeight,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:5ba7e55a76e1c96429df464106c2eac1,ntxv:2,isnm:False;n:type:ShaderForge.SFN_ValueProperty,id:9755,x:24703,y:35709,ptovrint:False,ptlb:U Speed,ptin:_USpeed,varname:_USpeed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_ValueProperty,id:8588,x:24703,y:35791,ptovrint:False,ptlb:V Speed,ptin:_VSpeed,varname:_VSpeed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.5;n:type:ShaderForge.SFN_Append,id:6552,x:25205,y:35720,varname:node_6552,prsc:2|A-7691-OUT,B-80-OUT;n:type:ShaderForge.SFN_Multiply,id:7614,x:25418,y:35720,varname:node_7614,prsc:2|A-6552-OUT,B-6908-T;n:type:ShaderForge.SFN_Time,id:6908,x:25205,y:35873,varname:node_6908,prsc:2;n:type:ShaderForge.SFN_TexCoord,id:142,x:26170,y:34416,varname:node_142,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Add,id:493,x:26972,y:34935,varname:node_493,prsc:2|A-8720-OUT,B-7614-OUT;n:type:ShaderForge.SFN_ValueProperty,id:2368,x:26170,y:34590,ptovrint:False,ptlb:Tiling,ptin:_Tiling,varname:_Tiling,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:8720,x:26343,y:34444,varname:node_8720,prsc:2|A-142-UVOUT,B-2368-OUT;n:type:ShaderForge.SFN_Tex2dAsset,id:3893,x:27938,y:32079,ptovrint:False,ptlb:Water Normal,ptin:_WaterNormal,varname:_WaterNormal,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:62d4b982696bb42478a854ec25d05508,ntxv:3,isnm:True;n:type:ShaderForge.SFN_Tex2d,id:1931,x:28856,y:31764,varname:node_1931,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-493-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_NormalVector,id:5422,x:29966,y:36587,prsc:2,pt:False;n:type:ShaderForge.SFN_Multiply,id:1753,x:30140,y:36471,varname:node_1753,prsc:2|A-5728-RGB,B-5422-OUT;n:type:ShaderForge.SFN_Multiply,id:2928,x:30313,y:36471,varname:node_2928,prsc:2|A-1753-OUT,B-6002-OUT;n:type:ShaderForge.SFN_Tex2d,id:5728,x:29966,y:36471,varname:node_5728,prsc:2,tex:5ba7e55a76e1c96429df464106c2eac1,ntxv:0,isnm:False|UVIN-8838-OUT,TEX-348-TEX;n:type:ShaderForge.SFN_Multiply,id:8838,x:29779,y:36471,varname:node_8838,prsc:2|A-493-OUT,B-3119-OUT;n:type:ShaderForge.SFN_Vector1,id:3119,x:29599,y:36505,varname:node_3119,prsc:2,v1:0.25;n:type:ShaderForge.SFN_Multiply,id:6101,x:28686,y:31594,varname:node_6101,prsc:2|A-493-OUT,B-2562-OUT;n:type:ShaderForge.SFN_Vector1,id:2562,x:28522,y:31628,varname:node_2562,prsc:2,v1:0.25;n:type:ShaderForge.SFN_Tex2d,id:2922,x:28856,y:31594,varname:node_2922,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-6101-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Tex2d,id:2609,x:28856,y:31961,varname:node_2609,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-7111-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Vector1,id:9807,x:28524,y:31995,varname:node_9807,prsc:2,v1:5;n:type:ShaderForge.SFN_Multiply,id:7111,x:28692,y:31961,varname:node_7111,prsc:2|A-4387-OUT,B-9807-OUT;n:type:ShaderForge.SFN_Add,id:4387,x:26972,y:35064,varname:node_4387,prsc:2|A-8720-OUT,B-3961-OUT;n:type:ShaderForge.SFN_Append,id:5448,x:25224,y:36347,varname:node_5448,prsc:2|A-7691-OUT,B-80-OUT;n:type:ShaderForge.SFN_Multiply,id:3961,x:25577,y:36347,varname:node_3961,prsc:2|A-1653-OUT,B-6908-T;n:type:ShaderForge.SFN_Multiply,id:1653,x:25404,y:36347,varname:node_1653,prsc:2|A-5448-OUT,B-4254-OUT;n:type:ShaderForge.SFN_Vector1,id:4254,x:25224,y:36507,varname:node_4254,prsc:2,v1:0.75;n:type:ShaderForge.SFN_Lerp,id:2011,x:30048,y:32595,varname:node_2011,prsc:2|A-9596-OUT,B-9728-OUT,T-4538-Z;n:type:ShaderForge.SFN_Vector4Property,id:4538,x:29752,y:32599,ptovrint:False,ptlb:Wave Scale,ptin:_WaveScale,varname:_WaveScale,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.1,v2:0.15,v3:0.25,v4:0.5;n:type:ShaderForge.SFN_Lerp,id:1495,x:30048,y:32725,varname:node_1495,prsc:2|A-2011-OUT,B-562-OUT,T-4538-Y;n:type:ShaderForge.SFN_Color,id:8149,x:28876,y:29942,ptovrint:False,ptlb:Shore Fog Color,ptin:_ShoreFogColor,varname:_ShallowDepthColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.3345588,c2:0.6691177,c3:0.5860549,c4:1;n:type:ShaderForge.SFN_Lerp,id:2907,x:31758,y:34774,varname:node_2907,prsc:2|A-1997-OUT,B-6809-OUT,T-4538-Z;n:type:ShaderForge.SFN_Multiply,id:4942,x:30143,y:37298,varname:node_4942,prsc:2|A-8403-RGB,B-450-OUT;n:type:ShaderForge.SFN_Multiply,id:4594,x:30315,y:37298,varname:node_4594,prsc:2|A-4942-OUT,B-1354-OUT;n:type:ShaderForge.SFN_Tex2d,id:8403,x:29954,y:37298,varname:node_8403,prsc:2,tex:5ba7e55a76e1c96429df464106c2eac1,ntxv:0,isnm:False|UVIN-3135-OUT,TEX-348-TEX;n:type:ShaderForge.SFN_Multiply,id:3135,x:29772,y:37306,varname:node_3135,prsc:2|A-4387-OUT,B-1516-OUT;n:type:ShaderForge.SFN_Vector1,id:1516,x:29587,y:37322,varname:node_1516,prsc:2,v1:5;n:type:ShaderForge.SFN_Lerp,id:6836,x:31758,y:34899,varname:node_6836,prsc:2|A-2907-OUT,B-2716-OUT,T-4538-Y;n:type:ShaderForge.SFN_Vector1,id:4014,x:29954,y:37431,varname:node_4014,prsc:2,v1:0.25;n:type:ShaderForge.SFN_Multiply,id:1354,x:30143,y:37431,varname:node_1354,prsc:2|A-4893-OUT,B-4014-OUT;n:type:ShaderForge.SFN_Normalize,id:380,x:30242,y:32847,varname:node_380,prsc:2|IN-8314-OUT;n:type:ShaderForge.SFN_Multiply,id:44,x:32402,y:32947,varname:node_44,prsc:2|A-4476-A,B-1600-OUT;n:type:ShaderForge.SFN_Vector1,id:2592,x:28522,y:31359,varname:node_2592,prsc:2,v1:0.05;n:type:ShaderForge.SFN_Multiply,id:1783,x:28689,y:31325,varname:node_1783,prsc:2|A-493-OUT,B-2592-OUT;n:type:ShaderForge.SFN_Tex2d,id:2649,x:28855,y:31325,varname:node_2649,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-1783-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Lerp,id:9596,x:30048,y:32466,varname:node_9596,prsc:2|A-7581-OUT,B-5117-OUT,T-4538-W;n:type:ShaderForge.SFN_NormalVector,id:9563,x:29955,y:36226,prsc:2,pt:False;n:type:ShaderForge.SFN_Multiply,id:3044,x:30119,y:36098,varname:node_3044,prsc:2|A-1917-RGB,B-9563-OUT;n:type:ShaderForge.SFN_Multiply,id:9956,x:30283,y:36098,varname:node_9956,prsc:2|A-3044-OUT,B-468-OUT;n:type:ShaderForge.SFN_Multiply,id:4972,x:29782,y:36098,varname:node_4972,prsc:2|A-493-OUT,B-6619-OUT;n:type:ShaderForge.SFN_Vector1,id:6619,x:29613,y:36132,varname:node_6619,prsc:2,v1:0.05;n:type:ShaderForge.SFN_Tex2d,id:1917,x:29955,y:36098,varname:node_1917,prsc:2,tex:5ba7e55a76e1c96429df464106c2eac1,ntxv:0,isnm:False|UVIN-4972-OUT,TEX-348-TEX;n:type:ShaderForge.SFN_Lerp,id:1997,x:31758,y:34636,varname:node_1997,prsc:2|A-9537-OUT,B-628-OUT,T-4538-W;n:type:ShaderForge.SFN_ValueProperty,id:468,x:28263,y:36819,ptovrint:False,ptlb:Main Wave Height,ptin:_MainWaveHeight,varname:_MainWaveHeight,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.1;n:type:ShaderForge.SFN_Multiply,id:7691,x:24945,y:35665,varname:node_7691,prsc:2|A-9755-OUT,B-8631-OUT;n:type:ShaderForge.SFN_Multiply,id:80,x:24945,y:35807,varname:node_80,prsc:2|A-8588-OUT,B-8631-OUT;n:type:ShaderForge.SFN_Vector1,id:8631,x:24685,y:35939,varname:node_8631,prsc:2,v1:0.2;n:type:ShaderForge.SFN_RemapRange,id:8449,x:25122,y:36689,varname:node_8449,prsc:2,frmn:0,frmx:1,tomn:1,tomx:-5|IN-9755-OUT;n:type:ShaderForge.SFN_Multiply,id:8891,x:25297,y:36689,varname:node_8891,prsc:2|A-8449-OUT,B-3599-OUT;n:type:ShaderForge.SFN_Vector1,id:3599,x:25122,y:36854,varname:node_3599,prsc:2,v1:0.03;n:type:ShaderForge.SFN_RemapRange,id:8173,x:25122,y:36916,varname:node_8173,prsc:2,frmn:0,frmx:1,tomn:0.5,tomx:-0.25|IN-8588-OUT;n:type:ShaderForge.SFN_Multiply,id:1782,x:25297,y:36916,varname:node_1782,prsc:2|A-8173-OUT,B-4064-OUT,C-5360-OUT;n:type:ShaderForge.SFN_Add,id:5804,x:26972,y:35198,varname:node_5804,prsc:2|A-4063-OUT,B-5716-OUT;n:type:ShaderForge.SFN_Add,id:4860,x:26972,y:35348,varname:node_4860,prsc:2|A-4063-OUT,B-7786-OUT;n:type:ShaderForge.SFN_Append,id:4310,x:25507,y:36800,varname:node_4310,prsc:2|A-8891-OUT,B-1782-OUT;n:type:ShaderForge.SFN_Multiply,id:5716,x:25840,y:36804,varname:node_5716,prsc:2|A-3509-OUT,B-6908-T;n:type:ShaderForge.SFN_NormalVector,id:820,x:30019,y:38213,prsc:2,pt:False;n:type:ShaderForge.SFN_Multiply,id:6471,x:30183,y:38085,varname:node_6471,prsc:2|A-53-RGB,B-820-OUT;n:type:ShaderForge.SFN_Multiply,id:6402,x:30361,y:38085,varname:node_6402,prsc:2|A-6471-OUT,B-468-OUT;n:type:ShaderForge.SFN_Multiply,id:7940,x:29837,y:38085,varname:node_7940,prsc:2|A-5804-OUT,B-8870-OUT;n:type:ShaderForge.SFN_Vector1,id:8870,x:29677,y:38119,varname:node_8870,prsc:2,v1:0.05;n:type:ShaderForge.SFN_Tex2d,id:53,x:30001,y:38085,varname:node_53,prsc:2,tex:5ba7e55a76e1c96429df464106c2eac1,ntxv:0,isnm:False|UVIN-7940-OUT,TEX-348-TEX;n:type:ShaderForge.SFN_NormalVector,id:8127,x:30001,y:38794,prsc:2,pt:False;n:type:ShaderForge.SFN_Multiply,id:2540,x:30175,y:38678,varname:node_2540,prsc:2|A-5672-RGB,B-8127-OUT;n:type:ShaderForge.SFN_Multiply,id:3965,x:30348,y:38678,varname:node_3965,prsc:2|A-2540-OUT,B-6002-OUT;n:type:ShaderForge.SFN_Multiply,id:8392,x:29814,y:38678,varname:node_8392,prsc:2|A-5804-OUT,B-8787-OUT;n:type:ShaderForge.SFN_Vector1,id:8787,x:29634,y:38712,varname:node_8787,prsc:2,v1:0.25;n:type:ShaderForge.SFN_Tex2d,id:5672,x:30001,y:38678,varname:node_5672,prsc:2,tex:5ba7e55a76e1c96429df464106c2eac1,ntxv:0,isnm:False|UVIN-8392-OUT,TEX-348-TEX;n:type:ShaderForge.SFN_Multiply,id:5532,x:25673,y:36966,varname:node_5532,prsc:2|A-4310-OUT,B-2243-OUT;n:type:ShaderForge.SFN_Vector1,id:2243,x:25507,y:37071,varname:node_2243,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Multiply,id:7786,x:25840,y:36966,varname:node_7786,prsc:2|A-5532-OUT,B-6908-T;n:type:ShaderForge.SFN_Lerp,id:9537,x:31099,y:36786,varname:node_9537,prsc:2|A-9956-OUT,B-6402-OUT,T-8544-OUT;n:type:ShaderForge.SFN_Vector1,id:8544,x:30852,y:36941,varname:node_8544,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Lerp,id:628,x:31099,y:36919,varname:node_628,prsc:2|A-2928-OUT,B-3965-OUT,T-8544-OUT;n:type:ShaderForge.SFN_Multiply,id:4063,x:26682,y:35350,varname:node_4063,prsc:2|A-142-UVOUT,B-8092-OUT;n:type:ShaderForge.SFN_Vector1,id:4064,x:25122,y:37087,varname:node_4064,prsc:2,v1:-1;n:type:ShaderForge.SFN_Multiply,id:8092,x:26448,y:35350,varname:node_8092,prsc:2|A-2368-OUT,B-7017-OUT;n:type:ShaderForge.SFN_Vector1,id:7017,x:26213,y:35426,varname:node_7017,prsc:2,v1:0.9;n:type:ShaderForge.SFN_Negate,id:3509,x:25673,y:36804,varname:node_3509,prsc:2|IN-4310-OUT;n:type:ShaderForge.SFN_Vector1,id:5360,x:25122,y:37145,varname:node_5360,prsc:2,v1:0.05;n:type:ShaderForge.SFN_Lerp,id:6809,x:31099,y:37044,varname:node_6809,prsc:2|A-3778-OUT,B-899-OUT,T-8544-OUT;n:type:ShaderForge.SFN_NormalVector,id:2326,x:29924,y:39239,prsc:2,pt:False;n:type:ShaderForge.SFN_Multiply,id:2610,x:30084,y:39118,varname:node_2610,prsc:2|A-4998-RGB,B-2326-OUT;n:type:ShaderForge.SFN_Multiply,id:899,x:30252,y:39118,varname:node_899,prsc:2|A-2610-OUT,B-4893-OUT;n:type:ShaderForge.SFN_Tex2d,id:4998,x:29924,y:39118,varname:node_4998,prsc:2,tex:5ba7e55a76e1c96429df464106c2eac1,ntxv:0,isnm:False|UVIN-5804-OUT,TEX-348-TEX;n:type:ShaderForge.SFN_Multiply,id:5949,x:30165,y:39624,varname:node_5949,prsc:2|A-5160-RGB,B-2326-OUT;n:type:ShaderForge.SFN_Multiply,id:7629,x:30337,y:39624,varname:node_7629,prsc:2|A-5949-OUT,B-9154-OUT;n:type:ShaderForge.SFN_Multiply,id:7618,x:29794,y:39632,varname:node_7618,prsc:2|A-4860-OUT,B-5300-OUT;n:type:ShaderForge.SFN_Vector1,id:5300,x:29609,y:39648,varname:node_5300,prsc:2,v1:5;n:type:ShaderForge.SFN_Multiply,id:9154,x:30165,y:39756,varname:node_9154,prsc:2|A-4893-OUT,B-9927-OUT;n:type:ShaderForge.SFN_Vector1,id:9927,x:29966,y:39756,varname:node_9927,prsc:2,v1:0.25;n:type:ShaderForge.SFN_Tex2d,id:5160,x:29966,y:39632,varname:node_5160,prsc:2,tex:5ba7e55a76e1c96429df464106c2eac1,ntxv:0,isnm:False|UVIN-7618-OUT,TEX-348-TEX;n:type:ShaderForge.SFN_Lerp,id:2716,x:31099,y:37179,varname:node_2716,prsc:2|A-4594-OUT,B-7629-OUT,T-8544-OUT;n:type:ShaderForge.SFN_Vector1,id:4887,x:28524,y:32218,varname:node_4887,prsc:2,v1:10;n:type:ShaderForge.SFN_Multiply,id:4966,x:28692,y:32184,varname:node_4966,prsc:2|A-4387-OUT,B-4887-OUT;n:type:ShaderForge.SFN_Lerp,id:8314,x:30048,y:32847,varname:node_8314,prsc:2|A-1495-OUT,B-5298-OUT,T-4538-X;n:type:ShaderForge.SFN_Tex2d,id:4345,x:28856,y:32184,varname:node_4345,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-4966-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Multiply,id:1725,x:28696,y:32680,varname:node_1725,prsc:2|A-5804-OUT,B-2473-OUT;n:type:ShaderForge.SFN_Vector1,id:2473,x:28532,y:32714,varname:node_2473,prsc:2,v1:0.25;n:type:ShaderForge.SFN_Vector1,id:6372,x:28534,y:33081,varname:node_6372,prsc:2,v1:5;n:type:ShaderForge.SFN_Multiply,id:8370,x:28702,y:33047,varname:node_8370,prsc:2|A-4860-OUT,B-6372-OUT;n:type:ShaderForge.SFN_Vector1,id:2958,x:28532,y:32445,varname:node_2958,prsc:2,v1:0.05;n:type:ShaderForge.SFN_Multiply,id:1506,x:28699,y:32411,varname:node_1506,prsc:2|A-5804-OUT,B-2958-OUT;n:type:ShaderForge.SFN_Vector1,id:8964,x:28534,y:33304,varname:node_8964,prsc:2,v1:10;n:type:ShaderForge.SFN_Multiply,id:525,x:28702,y:33270,varname:node_525,prsc:2|A-4797-OUT,B-8964-OUT;n:type:ShaderForge.SFN_Tex2d,id:5467,x:28871,y:32411,varname:node_5467,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-1506-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Tex2d,id:3704,x:28872,y:32693,varname:node_3704,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-1725-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Tex2d,id:9479,x:28872,y:32872,varname:node_9479,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-5804-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Tex2d,id:1345,x:28872,y:33063,varname:node_1345,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-8370-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Tex2d,id:1813,x:28872,y:33270,varname:node_1813,prsc:2,tex:62d4b982696bb42478a854ec25d05508,ntxv:0,isnm:False|UVIN-525-OUT,TEX-3893-TEX;n:type:ShaderForge.SFN_Lerp,id:7581,x:29333,y:32317,varname:node_7581,prsc:2|A-2649-RGB,B-5467-RGB,T-4262-OUT;n:type:ShaderForge.SFN_Vector1,id:4262,x:29111,y:32643,varname:node_4262,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Lerp,id:5117,x:29333,y:32466,varname:node_5117,prsc:2|A-2922-RGB,B-3704-RGB,T-4262-OUT;n:type:ShaderForge.SFN_Lerp,id:9728,x:29333,y:32596,varname:node_9728,prsc:2|A-1931-RGB,B-9479-RGB,T-4262-OUT;n:type:ShaderForge.SFN_Lerp,id:562,x:29333,y:32736,varname:node_562,prsc:2|A-2609-RGB,B-1345-RGB,T-4262-OUT;n:type:ShaderForge.SFN_Lerp,id:5298,x:29333,y:32906,varname:node_5298,prsc:2|A-4345-RGB,B-1813-RGB,T-4262-OUT;n:type:ShaderForge.SFN_Multiply,id:9209,x:25673,y:37139,varname:node_9209,prsc:2|A-4310-OUT,B-2913-OUT;n:type:ShaderForge.SFN_Multiply,id:684,x:25840,y:37139,varname:node_684,prsc:2|A-9209-OUT,B-6908-T;n:type:ShaderForge.SFN_Vector1,id:2913,x:25507,y:37205,varname:node_2913,prsc:2,v1:0.3;n:type:ShaderForge.SFN_Add,id:4797,x:26972,y:35482,varname:node_4797,prsc:2|A-4063-OUT,B-684-OUT;n:type:ShaderForge.SFN_ValueProperty,id:2013,x:28599,y:30197,ptovrint:False,ptlb:Shore Depth,ptin:_ShoreDepth,varname:_ShallowDepth,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:3;n:type:ShaderForge.SFN_DepthBlend,id:2434,x:28823,y:30197,varname:node_2434,prsc:2|DIST-2013-OUT;n:type:ShaderForge.SFN_Multiply,id:9225,x:29302,y:30067,varname:node_9225,prsc:2|A-8149-RGB,B-5391-OUT;n:type:ShaderForge.SFN_Multiply,id:813,x:28599,y:30355,varname:node_813,prsc:2|A-2013-OUT,B-7005-OUT;n:type:ShaderForge.SFN_Vector1,id:7005,x:28413,y:30431,varname:node_7005,prsc:2,v1:1;n:type:ShaderForge.SFN_DepthBlend,id:1600,x:28757,y:30355,varname:node_1600,prsc:2|DIST-813-OUT;n:type:ShaderForge.SFN_Relay,id:251,x:31227,y:30183,varname:node_251,prsc:2|IN-9772-OUT;n:type:ShaderForge.SFN_Relay,id:9178,x:32431,y:32864,varname:node_9178,prsc:2|IN-8149-RGB;n:type:ShaderForge.SFN_Blend,id:9772,x:30338,y:30124,varname:node_9772,prsc:2,blmd:6,clmp:True|SRC-3422-OUT,DST-9225-OUT;n:type:ShaderForge.SFN_Multiply,id:2892,x:32543,y:33106,varname:node_2892,prsc:2|A-1676-OUT,B-1431-OUT;n:type:ShaderForge.SFN_Vector1,id:1431,x:32339,y:33249,varname:node_1431,prsc:2,v1:30;n:type:ShaderForge.SFN_RemapRange,id:5391,x:29005,y:30197,varname:node_5391,prsc:2,frmn:0,frmx:1,tomn:1,tomx:0|IN-2434-OUT;n:type:ShaderForge.SFN_Multiply,id:715,x:28599,y:30561,varname:node_715,prsc:2|A-2013-OUT,B-501-OUT;n:type:ShaderForge.SFN_Vector1,id:501,x:28413,y:30637,varname:node_501,prsc:2,v1:0.5;n:type:ShaderForge.SFN_DepthBlend,id:1928,x:28757,y:30561,varname:node_1928,prsc:2|DIST-715-OUT;n:type:ShaderForge.SFN_RemapRange,id:5618,x:28959,y:30561,varname:node_5618,prsc:2,frmn:0,frmx:1,tomn:1,tomx:0|IN-1928-OUT;n:type:ShaderForge.SFN_Vector1,id:365,x:29211,y:30436,varname:node_365,prsc:2,v1:5;n:type:ShaderForge.SFN_ObjectPosition,id:3496,x:28360,y:36052,varname:node_3496,prsc:2;n:type:ShaderForge.SFN_RemapRange,id:4363,x:28923,y:36052,varname:node_4363,prsc:2,frmn:0,frmx:1E+10,tomn:10,tomx:100|IN-7344-OUT;n:type:ShaderForge.SFN_Round,id:7344,x:28742,y:36052,varname:node_7344,prsc:2|IN-4687-OUT;n:type:ShaderForge.SFN_Sin,id:6304,x:29098,y:36052,varname:node_6304,prsc:2|IN-4363-OUT;n:type:ShaderForge.SFN_Multiply,id:4687,x:28572,y:36052,varname:node_4687,prsc:2|A-3496-XYZ,B-5288-OUT;n:type:ShaderForge.SFN_Vector1,id:5288,x:28360,y:36205,varname:node_5288,prsc:2,v1:10000;n:type:ShaderForge.SFN_Set,id:2809,x:29280,y:36052,varname:node_2809,prsc:2|IN-6304-OUT;n:type:ShaderForge.SFN_ComponentMask,id:8121,x:30497,y:32892,varname:node_8121,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-380-OUT;n:type:ShaderForge.SFN_Multiply,id:3910,x:30759,y:32913,varname:node_3910,prsc:2|A-8121-OUT,B-1245-OUT;n:type:ShaderForge.SFN_Slider,id:1245,x:30444,y:33153,ptovrint:False,ptlb:Refraction,ptin:_Refraction,varname:node_1245,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:0.1;proporder:4476-2013-8149-348-3893-4538-468-6002-4893-9755-8588-2368-1676-1245;pass:END;sub:END;*/

Shader "TFP/TFP_Water_DepthTessellated" {
    Properties {
        _FogColor ("Fog Color", Color) = (0.2666667,0.4078432,0.4196079,1)
        _ShoreDepth ("Shore Depth", Float ) = 3
        _ShoreFogColor ("Shore Fog Color", Color) = (0.3345588,0.6691177,0.5860549,1)
        _WaterHeight ("Water Height", 2D) = "black" {}
        _WaterNormal ("Water Normal", 2D) = "bump" {}
        _WaveScale ("Wave Scale", Vector) = (0.1,0.15,0.25,0.5)
        _MainWaveHeight ("Main Wave Height", Float ) = 0.1
        _SecondaryWaveHeight ("Secondary Wave Height", Float ) = 0.5
        _SmallWaveHeight ("Small Wave Height", Float ) = 0.5
        _USpeed ("U Speed", Float ) = 1
        _VSpeed ("V Speed", Float ) = 0.5
        _Tiling ("Tiling", Float ) = 1
        _Tesselation ("Tesselation", Float ) = 1
        _Refraction ("Refraction", Range(0, 0.1)) = 0
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 3000
        GrabPass{ "Refraction" }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma hull hull
            #pragma domain domain
            #pragma vertex tessvert
            #pragma fragment frag
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "Tessellation.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles n3ds wiiu 
            #pragma target 5.0
            uniform sampler2D Refraction;
            uniform sampler2D _CameraDepthTexture;
            uniform float _Tesselation;
            uniform float _SmallWaveHeight;
            uniform float _SecondaryWaveHeight;
            uniform float4 _FogColor;
            uniform sampler2D _WaterHeight; uniform float4 _WaterHeight_ST;
            uniform float _USpeed;
            uniform float _VSpeed;
            uniform float _Tiling;
            uniform sampler2D _WaterNormal; uniform float4 _WaterNormal_ST;
            uniform float4 _WaveScale;
            uniform float4 _ShoreFogColor;
            uniform float _MainWaveHeight;
            uniform float _ShoreDepth;
            uniform float _Refraction;
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
                float4 projPos : TEXCOORD5;
                UNITY_FOG_COORDS(6)
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
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            #ifdef UNITY_CAN_COMPILE_TESSELLATION
                struct TessVertex {
                    float4 vertex : INTERNALTESSPOS;
                    float3 normal : NORMAL;
                    float4 tangent : TANGENT;
                    float2 texcoord0 : TEXCOORD0;
                };
                struct OutputPatchConstant {
                    float edge[3]         : SV_TessFactor;
                    float inside          : SV_InsideTessFactor;
                    float3 vTangent[4]    : TANGENT;
                    float2 vUV[4]         : TEXCOORD;
                    float3 vTanUCorner[4] : TANUCORNER;
                    float3 vTanVCorner[4] : TANVCORNER;
                    float4 vCWts          : TANWEIGHTS;
                };
                TessVertex tessvert (VertexInput v) {
                    TessVertex o;
                    o.vertex = v.vertex;
                    o.normal = v.normal;
                    o.tangent = v.tangent;
                    o.texcoord0 = v.texcoord0;
                    return o;
                }
                void displacement (inout VertexInput v){
                    float2 node_8720 = (v.texcoord0*_Tiling);
                    float node_8631 = 0.2;
                    float node_7691 = (_USpeed*node_8631);
                    float node_80 = (_VSpeed*node_8631);
                    float4 node_6908 = _Time;
                    float2 node_493 = (node_8720+(float2(node_7691,node_80)*node_6908.g));
                    float2 node_4972 = (node_493*0.05);
                    float4 node_1917 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_4972, _WaterHeight),0.0,0));
                    float2 node_4063 = (v.texcoord0*(_Tiling*0.9));
                    float2 node_4310 = float2(((_USpeed*-6.0+1.0)*0.03),((_VSpeed*-0.75+0.5)*(-1.0)*0.05));
                    float2 node_5804 = (node_4063+((-1*node_4310)*node_6908.g));
                    float2 node_7940 = (node_5804*0.05);
                    float4 node_53 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_7940, _WaterHeight),0.0,0));
                    float node_8544 = 0.5;
                    float2 node_8838 = (node_493*0.25);
                    float4 node_5728 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_8838, _WaterHeight),0.0,0));
                    float2 node_8392 = (node_5804*0.25);
                    float4 node_5672 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_8392, _WaterHeight),0.0,0));
                    float4 node_8613 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_493, _WaterHeight),0.0,0));
                    float4 node_4998 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_5804, _WaterHeight),0.0,0));
                    float2 node_4387 = (node_8720+((float2(node_7691,node_80)*0.75)*node_6908.g));
                    float2 node_3135 = (node_4387*5.0);
                    float4 node_8403 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_3135, _WaterHeight),0.0,0));
                    float2 node_4860 = (node_4063+((node_4310*0.5)*node_6908.g));
                    float2 node_7618 = (node_4860*5.0);
                    float4 node_5160 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_7618, _WaterHeight),0.0,0));
                    v.vertex.xyz += lerp(lerp(lerp(lerp(((node_1917.rgb*v.normal)*_MainWaveHeight),((node_53.rgb*v.normal)*_MainWaveHeight),node_8544),lerp(((node_5728.rgb*v.normal)*_SecondaryWaveHeight),((node_5672.rgb*v.normal)*_SecondaryWaveHeight),node_8544),_WaveScale.a),lerp(((node_8613.rgb*v.normal)*_SmallWaveHeight),((node_4998.rgb*v.normal)*_SmallWaveHeight),node_8544),_WaveScale.b),lerp(((node_8403.rgb*v.normal)*(_SmallWaveHeight*0.25)),((node_5160.rgb*v.normal)*(_SmallWaveHeight*0.25)),node_8544),_WaveScale.g);
                }
                float4 Tessellation(TessVertex v, TessVertex v1, TessVertex v2){
                    return UnityEdgeLengthBasedTess(v.vertex, v1.vertex, v2.vertex, (_Tesselation*30.0));
                }
                OutputPatchConstant hullconst (InputPatch<TessVertex,3> v) {
                    OutputPatchConstant o = (OutputPatchConstant)0;
                    float4 ts = Tessellation( v[0], v[1], v[2] );
                    o.edge[0] = ts.x;
                    o.edge[1] = ts.y;
                    o.edge[2] = ts.z;
                    o.inside = ts.w;
                    return o;
                }
                [domain("tri")]
                [partitioning("fractional_odd")]
                [outputtopology("triangle_cw")]
                [patchconstantfunc("hullconst")]
                [outputcontrolpoints(3)]
                TessVertex hull (InputPatch<TessVertex,3> v, uint id : SV_OutputControlPointID) {
                    return v[id];
                }
                [domain("tri")]
                VertexOutput domain (OutputPatchConstant tessFactors, const OutputPatch<TessVertex,3> vi, float3 bary : SV_DomainLocation) {
                    VertexInput v = (VertexInput)0;
                    v.vertex = vi[0].vertex*bary.x + vi[1].vertex*bary.y + vi[2].vertex*bary.z;
                    v.normal = vi[0].normal*bary.x + vi[1].normal*bary.y + vi[2].normal*bary.z;
                    v.tangent = vi[0].tangent*bary.x + vi[1].tangent*bary.y + vi[2].tangent*bary.z;
                    v.texcoord0 = vi[0].texcoord0*bary.x + vi[1].texcoord0*bary.y + vi[2].texcoord0*bary.z;
                    displacement(v);
                    VertexOutput o = vert(v);
                    return o;
                }
            #endif
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
                float2 node_4860 = (node_4063+((node_4310*0.5)*node_6908.g));
                float2 node_8370 = (node_4860*5.0);
                float3 node_1345 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_8370, _WaterNormal)));
                float2 node_4966 = (node_4387*10.0);
                float3 node_4345 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_4966, _WaterNormal)));
                float2 node_525 = ((node_4063+((node_4310*0.3)*node_6908.g))*10.0);
                float3 node_1813 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_525, _WaterNormal)));
                float3 node_380 = normalize(lerp(lerp(lerp(lerp(lerp(node_2649.rgb,node_5467.rgb,node_4262),lerp(node_2922.rgb,node_3704.rgb,node_4262),_WaveScale.a),lerp(node_1931.rgb,node_9479.rgb,node_4262),_WaveScale.b),lerp(node_2609.rgb,node_1345.rgb,node_4262),_WaveScale.g),lerp(node_4345.rgb,node_1813.rgb,node_4262),_WaveScale.r));
                float3 normalLocal = node_380;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                float2 sceneUVs = (i.projPos.xy / i.projPos.w) + (node_380.rg*_Refraction);
                float4 sceneColor = tex2D(Refraction, sceneUVs);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = 1;
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float gloss = 1.0 - 0.03; // Convert roughness to gloss
                float perceptualRoughness = 0.03;
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
                float3 diffuseColor = saturate((1.0-(1.0-(_FogColor.rgb*saturate((sceneZ-partZ)/5.0)))*(1.0-(_ShoreFogColor.rgb*(saturate((sceneZ-partZ)/_ShoreDepth)*-1.0+1.0))))); // Need this for specular when using metallic
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
                NdotL = dot( normalDirection, lightDirection );
                float3 node_9178 = _ShoreFogColor.rgb;
                float3 w = node_9178*0.5; // Light wrapping
                float3 NdotLWrap = NdotL * ( 1.0 - w );
                float3 forwardLight = max(float3(0.0,0.0,0.0), NdotLWrap + w );
                float3 backLight = max(float3(0.0,0.0,0.0), -NdotLWrap + w ) * node_9178;
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float nlPow5 = Pow5(1-NdotLWrap);
                float nvPow5 = Pow5(1-NdotV);
                float3 directDiffuse = ((forwardLight+backLight) + ((1 +(fd90 - 1)*nlPow5) * (1 + (fd90 - 1)*nvPow5) * NdotL)) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse * (_FogColor.a*saturate((sceneZ-partZ)/(_ShoreDepth*1.0))) + specular;
                fixed4 finalRGBA = fixed4(lerp(sceneColor.rgb, finalColor,(_FogColor.a*saturate((sceneZ-partZ)/(_ShoreDepth*1.0)))),1);
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
            ZWrite Off
            
            CGPROGRAM
            #pragma hull hull
            #pragma domain domain
            #pragma vertex tessvert
            #pragma fragment frag
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Tessellation.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdadd
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles n3ds wiiu 
            #pragma target 5.0
            uniform sampler2D Refraction;
            uniform sampler2D _CameraDepthTexture;
            uniform float _Tesselation;
            uniform float _SmallWaveHeight;
            uniform float _SecondaryWaveHeight;
            uniform float4 _FogColor;
            uniform sampler2D _WaterHeight; uniform float4 _WaterHeight_ST;
            uniform float _USpeed;
            uniform float _VSpeed;
            uniform float _Tiling;
            uniform sampler2D _WaterNormal; uniform float4 _WaterNormal_ST;
            uniform float4 _WaveScale;
            uniform float4 _ShoreFogColor;
            uniform float _MainWaveHeight;
            uniform float _ShoreDepth;
            uniform float _Refraction;
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
                float4 projPos : TEXCOORD5;
                LIGHTING_COORDS(6,7)
                UNITY_FOG_COORDS(8)
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
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            #ifdef UNITY_CAN_COMPILE_TESSELLATION
                struct TessVertex {
                    float4 vertex : INTERNALTESSPOS;
                    float3 normal : NORMAL;
                    float4 tangent : TANGENT;
                    float2 texcoord0 : TEXCOORD0;
                };
                struct OutputPatchConstant {
                    float edge[3]         : SV_TessFactor;
                    float inside          : SV_InsideTessFactor;
                    float3 vTangent[4]    : TANGENT;
                    float2 vUV[4]         : TEXCOORD;
                    float3 vTanUCorner[4] : TANUCORNER;
                    float3 vTanVCorner[4] : TANVCORNER;
                    float4 vCWts          : TANWEIGHTS;
                };
                TessVertex tessvert (VertexInput v) {
                    TessVertex o;
                    o.vertex = v.vertex;
                    o.normal = v.normal;
                    o.tangent = v.tangent;
                    o.texcoord0 = v.texcoord0;
                    return o;
                }
                void displacement (inout VertexInput v){
                    float2 node_8720 = (v.texcoord0*_Tiling);
                    float node_8631 = 0.2;
                    float node_7691 = (_USpeed*node_8631);
                    float node_80 = (_VSpeed*node_8631);
                    float4 node_6908 = _Time;
                    float2 node_493 = (node_8720+(float2(node_7691,node_80)*node_6908.g));
                    float2 node_4972 = (node_493*0.05);
                    float4 node_1917 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_4972, _WaterHeight),0.0,0));
                    float2 node_4063 = (v.texcoord0*(_Tiling*0.9));
                    float2 node_4310 = float2(((_USpeed*-6.0+1.0)*0.03),((_VSpeed*-0.75+0.5)*(-1.0)*0.05));
                    float2 node_5804 = (node_4063+((-1*node_4310)*node_6908.g));
                    float2 node_7940 = (node_5804*0.05);
                    float4 node_53 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_7940, _WaterHeight),0.0,0));
                    float node_8544 = 0.5;
                    float2 node_8838 = (node_493*0.25);
                    float4 node_5728 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_8838, _WaterHeight),0.0,0));
                    float2 node_8392 = (node_5804*0.25);
                    float4 node_5672 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_8392, _WaterHeight),0.0,0));
                    float4 node_8613 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_493, _WaterHeight),0.0,0));
                    float4 node_4998 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_5804, _WaterHeight),0.0,0));
                    float2 node_4387 = (node_8720+((float2(node_7691,node_80)*0.75)*node_6908.g));
                    float2 node_3135 = (node_4387*5.0);
                    float4 node_8403 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_3135, _WaterHeight),0.0,0));
                    float2 node_4860 = (node_4063+((node_4310*0.5)*node_6908.g));
                    float2 node_7618 = (node_4860*5.0);
                    float4 node_5160 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_7618, _WaterHeight),0.0,0));
                    v.vertex.xyz += lerp(lerp(lerp(lerp(((node_1917.rgb*v.normal)*_MainWaveHeight),((node_53.rgb*v.normal)*_MainWaveHeight),node_8544),lerp(((node_5728.rgb*v.normal)*_SecondaryWaveHeight),((node_5672.rgb*v.normal)*_SecondaryWaveHeight),node_8544),_WaveScale.a),lerp(((node_8613.rgb*v.normal)*_SmallWaveHeight),((node_4998.rgb*v.normal)*_SmallWaveHeight),node_8544),_WaveScale.b),lerp(((node_8403.rgb*v.normal)*(_SmallWaveHeight*0.25)),((node_5160.rgb*v.normal)*(_SmallWaveHeight*0.25)),node_8544),_WaveScale.g);
                }
                float4 Tessellation(TessVertex v, TessVertex v1, TessVertex v2){
                    return UnityEdgeLengthBasedTess(v.vertex, v1.vertex, v2.vertex, (_Tesselation*30.0));
                }
                OutputPatchConstant hullconst (InputPatch<TessVertex,3> v) {
                    OutputPatchConstant o = (OutputPatchConstant)0;
                    float4 ts = Tessellation( v[0], v[1], v[2] );
                    o.edge[0] = ts.x;
                    o.edge[1] = ts.y;
                    o.edge[2] = ts.z;
                    o.inside = ts.w;
                    return o;
                }
                [domain("tri")]
                [partitioning("fractional_odd")]
                [outputtopology("triangle_cw")]
                [patchconstantfunc("hullconst")]
                [outputcontrolpoints(3)]
                TessVertex hull (InputPatch<TessVertex,3> v, uint id : SV_OutputControlPointID) {
                    return v[id];
                }
                [domain("tri")]
                VertexOutput domain (OutputPatchConstant tessFactors, const OutputPatch<TessVertex,3> vi, float3 bary : SV_DomainLocation) {
                    VertexInput v = (VertexInput)0;
                    v.vertex = vi[0].vertex*bary.x + vi[1].vertex*bary.y + vi[2].vertex*bary.z;
                    v.normal = vi[0].normal*bary.x + vi[1].normal*bary.y + vi[2].normal*bary.z;
                    v.tangent = vi[0].tangent*bary.x + vi[1].tangent*bary.y + vi[2].tangent*bary.z;
                    v.texcoord0 = vi[0].texcoord0*bary.x + vi[1].texcoord0*bary.y + vi[2].texcoord0*bary.z;
                    displacement(v);
                    VertexOutput o = vert(v);
                    return o;
                }
            #endif
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
                float2 node_4860 = (node_4063+((node_4310*0.5)*node_6908.g));
                float2 node_8370 = (node_4860*5.0);
                float3 node_1345 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_8370, _WaterNormal)));
                float2 node_4966 = (node_4387*10.0);
                float3 node_4345 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_4966, _WaterNormal)));
                float2 node_525 = ((node_4063+((node_4310*0.3)*node_6908.g))*10.0);
                float3 node_1813 = UnpackNormal(tex2D(_WaterNormal,TRANSFORM_TEX(node_525, _WaterNormal)));
                float3 node_380 = normalize(lerp(lerp(lerp(lerp(lerp(node_2649.rgb,node_5467.rgb,node_4262),lerp(node_2922.rgb,node_3704.rgb,node_4262),_WaveScale.a),lerp(node_1931.rgb,node_9479.rgb,node_4262),_WaveScale.b),lerp(node_2609.rgb,node_1345.rgb,node_4262),_WaveScale.g),lerp(node_4345.rgb,node_1813.rgb,node_4262),_WaveScale.r));
                float3 normalLocal = node_380;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                float2 sceneUVs = (i.projPos.xy / i.projPos.w) + (node_380.rg*_Refraction);
                float4 sceneColor = tex2D(Refraction, sceneUVs);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                UNITY_LIGHT_ATTENUATION(attenuation,i, i.posWorld.xyz);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float gloss = 1.0 - 0.03; // Convert roughness to gloss
                float perceptualRoughness = 0.03;
                float roughness = perceptualRoughness * perceptualRoughness;
                float specPow = exp2( gloss * 10.0 + 1.0 );
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float LdotH = saturate(dot(lightDirection, halfDirection));
                float3 specularColor = 0.0;
                float specularMonochrome;
                float3 diffuseColor = saturate((1.0-(1.0-(_FogColor.rgb*saturate((sceneZ-partZ)/5.0)))*(1.0-(_ShoreFogColor.rgb*(saturate((sceneZ-partZ)/_ShoreDepth)*-1.0+1.0))))); // Need this for specular when using metallic
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
                NdotL = dot( normalDirection, lightDirection );
                float3 node_9178 = _ShoreFogColor.rgb;
                float3 w = node_9178*0.5; // Light wrapping
                float3 NdotLWrap = NdotL * ( 1.0 - w );
                float3 forwardLight = max(float3(0.0,0.0,0.0), NdotLWrap + w );
                float3 backLight = max(float3(0.0,0.0,0.0), -NdotLWrap + w ) * node_9178;
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float nlPow5 = Pow5(1-NdotLWrap);
                float nvPow5 = Pow5(1-NdotV);
                float3 directDiffuse = ((forwardLight+backLight) + ((1 +(fd90 - 1)*nlPow5) * (1 + (fd90 - 1)*nvPow5) * NdotL)) * attenColor;
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse * (_FogColor.a*saturate((sceneZ-partZ)/(_ShoreDepth*1.0))) + specular;
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
            #pragma hull hull
            #pragma domain domain
            #pragma vertex tessvert
            #pragma fragment frag
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "Tessellation.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles n3ds wiiu 
            #pragma target 5.0
            uniform float _Tesselation;
            uniform float _SmallWaveHeight;
            uniform float _SecondaryWaveHeight;
            uniform sampler2D _WaterHeight; uniform float4 _WaterHeight_ST;
            uniform float _USpeed;
            uniform float _VSpeed;
            uniform float _Tiling;
            uniform float4 _WaveScale;
            uniform float _MainWaveHeight;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float4 posWorld : TEXCOORD2;
                float3 normalDir : TEXCOORD3;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            #ifdef UNITY_CAN_COMPILE_TESSELLATION
                struct TessVertex {
                    float4 vertex : INTERNALTESSPOS;
                    float3 normal : NORMAL;
                    float4 tangent : TANGENT;
                    float2 texcoord0 : TEXCOORD0;
                };
                struct OutputPatchConstant {
                    float edge[3]         : SV_TessFactor;
                    float inside          : SV_InsideTessFactor;
                    float3 vTangent[4]    : TANGENT;
                    float2 vUV[4]         : TEXCOORD;
                    float3 vTanUCorner[4] : TANUCORNER;
                    float3 vTanVCorner[4] : TANVCORNER;
                    float4 vCWts          : TANWEIGHTS;
                };
                TessVertex tessvert (VertexInput v) {
                    TessVertex o;
                    o.vertex = v.vertex;
                    o.normal = v.normal;
                    o.tangent = v.tangent;
                    o.texcoord0 = v.texcoord0;
                    return o;
                }
                void displacement (inout VertexInput v){
                    float2 node_8720 = (v.texcoord0*_Tiling);
                    float node_8631 = 0.2;
                    float node_7691 = (_USpeed*node_8631);
                    float node_80 = (_VSpeed*node_8631);
                    float4 node_6908 = _Time;
                    float2 node_493 = (node_8720+(float2(node_7691,node_80)*node_6908.g));
                    float2 node_4972 = (node_493*0.05);
                    float4 node_1917 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_4972, _WaterHeight),0.0,0));
                    float2 node_4063 = (v.texcoord0*(_Tiling*0.9));
                    float2 node_4310 = float2(((_USpeed*-6.0+1.0)*0.03),((_VSpeed*-0.75+0.5)*(-1.0)*0.05));
                    float2 node_5804 = (node_4063+((-1*node_4310)*node_6908.g));
                    float2 node_7940 = (node_5804*0.05);
                    float4 node_53 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_7940, _WaterHeight),0.0,0));
                    float node_8544 = 0.5;
                    float2 node_8838 = (node_493*0.25);
                    float4 node_5728 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_8838, _WaterHeight),0.0,0));
                    float2 node_8392 = (node_5804*0.25);
                    float4 node_5672 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_8392, _WaterHeight),0.0,0));
                    float4 node_8613 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_493, _WaterHeight),0.0,0));
                    float4 node_4998 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_5804, _WaterHeight),0.0,0));
                    float2 node_4387 = (node_8720+((float2(node_7691,node_80)*0.75)*node_6908.g));
                    float2 node_3135 = (node_4387*5.0);
                    float4 node_8403 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_3135, _WaterHeight),0.0,0));
                    float2 node_4860 = (node_4063+((node_4310*0.5)*node_6908.g));
                    float2 node_7618 = (node_4860*5.0);
                    float4 node_5160 = tex2Dlod(_WaterHeight,float4(TRANSFORM_TEX(node_7618, _WaterHeight),0.0,0));
                    v.vertex.xyz += lerp(lerp(lerp(lerp(((node_1917.rgb*v.normal)*_MainWaveHeight),((node_53.rgb*v.normal)*_MainWaveHeight),node_8544),lerp(((node_5728.rgb*v.normal)*_SecondaryWaveHeight),((node_5672.rgb*v.normal)*_SecondaryWaveHeight),node_8544),_WaveScale.a),lerp(((node_8613.rgb*v.normal)*_SmallWaveHeight),((node_4998.rgb*v.normal)*_SmallWaveHeight),node_8544),_WaveScale.b),lerp(((node_8403.rgb*v.normal)*(_SmallWaveHeight*0.25)),((node_5160.rgb*v.normal)*(_SmallWaveHeight*0.25)),node_8544),_WaveScale.g);
                }
                float4 Tessellation(TessVertex v, TessVertex v1, TessVertex v2){
                    return UnityEdgeLengthBasedTess(v.vertex, v1.vertex, v2.vertex, (_Tesselation*30.0));
                }
                OutputPatchConstant hullconst (InputPatch<TessVertex,3> v) {
                    OutputPatchConstant o = (OutputPatchConstant)0;
                    float4 ts = Tessellation( v[0], v[1], v[2] );
                    o.edge[0] = ts.x;
                    o.edge[1] = ts.y;
                    o.edge[2] = ts.z;
                    o.inside = ts.w;
                    return o;
                }
                [domain("tri")]
                [partitioning("fractional_odd")]
                [outputtopology("triangle_cw")]
                [patchconstantfunc("hullconst")]
                [outputcontrolpoints(3)]
                TessVertex hull (InputPatch<TessVertex,3> v, uint id : SV_OutputControlPointID) {
                    return v[id];
                }
                [domain("tri")]
                VertexOutput domain (OutputPatchConstant tessFactors, const OutputPatch<TessVertex,3> vi, float3 bary : SV_DomainLocation) {
                    VertexInput v = (VertexInput)0;
                    v.vertex = vi[0].vertex*bary.x + vi[1].vertex*bary.y + vi[2].vertex*bary.z;
                    v.normal = vi[0].normal*bary.x + vi[1].normal*bary.y + vi[2].normal*bary.z;
                    v.tangent = vi[0].tangent*bary.x + vi[1].tangent*bary.y + vi[2].tangent*bary.z;
                    v.texcoord0 = vi[0].texcoord0*bary.x + vi[1].texcoord0*bary.y + vi[2].texcoord0*bary.z;
                    displacement(v);
                    VertexOutput o = vert(v);
                    return o;
                }
            #endif
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Standard (Specular setup)"
    CustomEditor "ShaderForgeMaterialInspector"
}
