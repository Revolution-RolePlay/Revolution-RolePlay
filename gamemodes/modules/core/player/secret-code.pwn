#include <YSI\y_hooks>

#define MAX_PLAYER_SECRET_CODE 64

static Player_SecretCode[MAX_PLAYERS][MAX_PLAYER_SECRET_CODE];

hook OnPlayerLogin()
{
	new Name[MAX_PLAYERS_NAME], GPCI[64], AccGPCI[64];
	GetPlayerName(playerid, Name, sizeof(Name));
	gpci(playerid, GPCI, sizeof(GPCI));
	GetPlayerGPCI(playerid, AccGPCI);
	if(!strmatch(GPCI, AccGPCI))
	{

	}

}

GenerateSecretCode(result[], len = sizeof(result))
{
	format(result, len, "%d%d%d%d", random(10), random(20), random(30), random(40));
}