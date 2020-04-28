As you can see in the main folder we have the _LWRP .unitypackage. Double click this to unpack and replace the Standard package with the LWRP supported one.

LWRP package was setup and tested on Unity 2019.1.3 using LWRP 5.7.2

So when you load the package into an SRP everything will be pink and broken. What you need to do is double click on the SRP you are using. So if you are using HDRP you need to double click the _HDRP package and unpack it in your project. It should overwrite everything it needs and the demo scenes and assets should be working like they should. 

This is very new to me and there does not seem to be any ideal solution for converting environments to an SRP. So there will show errors because of broken shaders and what it thinks are missing prefabs. Also some prefabs might break and need some manual resetting of materials.

Will have a video up on the Asset Store Page and Thread to go over this process. If you have any questions though please email me at baldinoboy@gmail.com