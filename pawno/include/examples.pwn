#include <a_samp>
#include <messages.pwn>

public OnGameModeInit()
{
	IM::Print("GameMode", "GameMode Loaded Successfully. GameModeVersion: %d", 5);
	return 1;
}



public OnPlayerConnect(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	IM::SendClientMessage(playerid, -1, "Welcome To The Server %s. Have a fun!", "NameServer");
	IM::SendClientMessageToAll(color, "%s Connected To The Server!", name);
	return 1;
}


