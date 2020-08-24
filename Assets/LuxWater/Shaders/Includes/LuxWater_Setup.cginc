
//  Define Fog Mode
//	Make sure ONLY ONE fog mode is defined.

//  Built in fog modes ------------------
//  #define FOG_LINEAR
//  #define FOG_EXP
    #define FOG_EXP2

//  Azure Fog ---------------------------
//  #define FOG_AZUR
//	#include "Assets/Azure[Sky] Dynamic Skybox/Shaders/Transparent/AzureFogCore.cginc"
        
//  Enviro Fog --------------------------
//  #define FOG_ENVIRO
//	#include "Assets/Enviro - Sky and Weather/Core/Resources/Shaders/Core/EnviroFogCore.cginc"
	// old path:
	// #include "Assets/Enviro - Dynamic Enviroment/Resources/Shaders/Core/EnviroFogCore.cginc"

//  Aura 2 Fog --------------------------
//  #define FOG_AURA
//  #include "UnityCG.cginc"
//	#include "Assets/Aura 2/Core/Code/Shaders/Aura.cginc"


//  Other features --------------------------

//	Uncomment to make the shader use disney diffuse lighting on foam. Otherwise it uses simple NdotL
//	#define DISNEYDIFFUSE