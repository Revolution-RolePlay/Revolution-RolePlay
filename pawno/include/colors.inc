/* 
	Colors Dynamic Library
	Last Update : 9/4/2017
	Created By Amagida
*/	


#if defined _inc_RGB_color
	#undef _inc_RGB_color
#endif

#if defined _RGB_CLLIB__COLOR
	#endinput
#endif

#define _RGB_CLLIB__COLOR

#define RGB%0(%1,%2,%3) ((((%1) & 0xff) << 16) | (((%2) & 0xff) << 8) | ((%3) & 0xff))
#define RGBA%0(%1,%2,%3,%4) ((RGB(%1,%2,%3) << 8) | ((%4) & 0xff))
#define ARGB%0(%1,%2,%3,%4) ((RGB(%1,%2,%3)) | (((%4) & 0xff) << 24))

#define RGBA2ARGB%0(%1) ((((%1) & 0xffffff00) >>> 8) | (((%1) & 0x000000ff) << 24))
#define RGBA2RGB%0(%1) (((%1) & 0xffffff00) >>> 8)
#define ARGB2RGBA%0(%1) ((((%1) & 0x000000ff) << 8) | (((%1) & 0xff000000) >>> 24))
#define ARGB2RGB%0(%1) (((%1) & 0x00ffffff))