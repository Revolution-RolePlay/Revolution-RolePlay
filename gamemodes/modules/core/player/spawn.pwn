#include <YSI\y_hooks>

hook OnPlayerLogin(playerid)
{
	SetSpawnInfo(playerid, NO_TEAM, 0, 0.0, 0.0, 0.0, 0.0, 0,0,0,0,0,0);
	SpawnPlayer(playerid);
	return 1;
}

hook OnPlayerSpawn(playerid)
{
	new
		Float:x,
		Float:y,
		Float:z,
		Float:a
	;
	GenerateSpawnPoint(x,y,z,a);

	SetPlayerPos(playerid, x, y, z);
	SetPlayerFacingAngle(playerid, a);

	return 1;	
}