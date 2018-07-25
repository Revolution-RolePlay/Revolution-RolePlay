#include <YSI\y_hooks>


//hook OnGameModeInit()
//{
//	ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);
//}

#define RGBAtoARGB(%0)				(((%0) >>> 8) & 0xFFFFFF)

stock ConvertToARGB(const gColor[], bool:ARGB = true, alpha = 0xFF)
{
	new color[11],color_int;
	color = "0x";
	strcat(color, gColor);
	sscanf(color, "x", color_int);
	color_int = (color_int * 256) + alpha;
	return ARGB ? RGBAtoARGB(color_int) : color_int;
}

hook OnPlayerSpawn(playerid)
{
	SetPlayerColor(playerid, 0xFFFFFF00);
	return 1;
}