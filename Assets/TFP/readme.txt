Thank you for purchasing my Tropical Forest Pack! I hope that you thoruoghly enjoy it and that it makes a great addition to your project.

The folder system is setup 

_Standard folder has all the demo scenes, prefabs and materials. It includes:


0_Extra folder is filled with different things that are needed for the demo scenes. Includes Audio files, scripts, and shaders.
	
	
	
	CTI Runtime Components for the LOD Tree and Billboard shaders, their needed wind script, and Deferred shaders. Many thanks to Lars for his work on the Custom Tree Importer and the amazing shaders. 

	ScenePrefabs includes additional prefabs setup for the two demo scenes.

	Scripts includes a few scripts made for the demo scenes.

	Shaders has some custom shader made in Shader Forge for things like water, rain, and mist particles in the demo scenes.

	Water is a collection of materials for the water and waterfalls for the demo scenes.

At the momment all the water shaders are broken in LWRP, URP and HDRP so were removed. Will need to make new shaders using Amplify and will replace the shader forge shaders with them soon.

	There are also other small things for the demo scenes included in the Extra folder like 

		Directional light, FlyCamera prefab, Demo Scene terrain data and the windzone prefab.


1_Demo folder has the three demos for Tropical Forest Pack including:

Forgotten Ravine DemoScene- The main demo scene featuring many effects and a fully developed terrain.

PromotionTerrain- Large Island terrain to use with Vegetation Studio

TFP- The original demo scene from Tropical Forest Pack that is a larger densly populated terrain. Do not recommend using a higher LOD bias in this scene as it is pretty dense.

TFP_Showcase- A simple scene showing the primary prefabs all together


2_Prefabs folder. This is setup so you have your already setup prefabs for quick use. You have the GroundCover, Particles, Props, Rocks, Trees, & VS. 

	The GroundCover and Trees folder each have a Billboards folder and this is just to store the Billboards asset for each prefab that uses a billboard.

	In the Trees folder you have all the trees you can input right in the terrain system and an LODs folder. Each tree has an enabled capsule collider for collision 
	on the terrain. Most of the trees also have a disabled Mesh Collider that is setup with the imported collider mesh. So if you are placing them 
	manually and not on the terrain you can disable the capsule collider and enable the mesh collider. The KapokTree01 has its capsul collider disabled by default as it is 
	not a good collision meathod for this particular tree. If you want to use it as a terrain object than just disable the Mesh Collider and enable the Capsule Collider in the prefab under the LOD Group Component.

	The VS folder includes all the assets optimized for use with Vegetation Studio. It also includes the configured profiles for use with Vegetation Studio. 


3_Materials folder contains the materials for the main assets. Ground, GroundCover, Particle, Props, Rocks, and Trees.


Audio folder includes the Ausio files

The audio files are from Freesound.org. Edited by me in Audacity. All under the CC0 license //https://creativecommons.org/publicdomain/zero/1.0/
		
	Footstep_Sand: sand_step by pgi link- http://www.freesound.org/people/pgi/sounds/211457/
	jungle_ambience01: Tropical Birda by dubminister link- http://www.freesound.org/people/dubminister/sounds/214676/
	wind_in_trees: wind in trees from cover by strangy link- http://www.freesound.org/people/strangy/sounds/176253/

	Rest are different combinations of different audio files

	Many thanks to them for their amazing work.


Imports folder contains the different meshes. The Colliders, GroundCover, Particle, Props, Rocks, and Tree imports.


Textures folder. Contains all the textures for the pack.
	
	Some of the textures in this pack are from textures.com(formerly CGTextures)link- http://www.textures.com/
	The rest were made by me by either photography, photogrammetry, or modeled and rendered.

Included Unity Packages-

_SRP packages(_LWRP, _HDRP & _URP) are for loading in support for your needed SRP. Please read the _SRP Readme for more information

VSBiomes package includes biomes and baked billboards for Vegetation Studio Pro

VSPro_CTIShaderController package is for adding support when using Vegetation Studio with CTI Shader assets. Will enable billboard baking and CTI Shader Control

Important -- The shaders for Tropical Forest Pack support Fully Deferred Rendering and require the Deferred shaders inputed into Edit-Project Settings-Graphics. Towards the bottom under  
Built-in shader settings find the Deferred and Deferred Reflections tabs. Click the tab and select Custom Shader in the dropdown for both. Input CTI/Internal-DeferredShading for Deferred and 
CTI/Internal-DeferredReflections for Deferred Reflections. Now the trees should shade correctly in Deferred Rendering. 

For getting the package working in a SRP please read the _SRP Readme file

Video tutorials for both these processes will be linked on the thread and Asset Store page.

Thank you again for purchasing the Tropical Forest Pack! For any issues please contact me on the thread that is linked in the Asset Store page or email me at baldinoboy@gmail.com