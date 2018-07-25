#include <YSI\y_hooks>



hook OnGameModeInit()
{
	LoadMap("scriptfiles/Maps/testmap.map");
	return 1;
}