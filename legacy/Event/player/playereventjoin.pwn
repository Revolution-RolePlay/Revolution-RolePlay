#include <a_samp>

forward eventp_OnPlayerJoin(playerid, eventid, style);

new bool: eventp_Joined[MAX_PLAYERS] = false, bool: eventp_Spawned[MAX_PLAYERS] = false, eventp_JoinedID[MAX_PLAYERS], eventp_IsInRangeChecker[MAX_PLAYERS];

stock eventp_Join(eventid, playerid)
{
	if(!Event[eventid][event_Started]) return printf("[EVENT ERROR] EVENT ID %d IS NOT STARTED! ",eventid);
	if(Event[eventid][event_PlayerCantJoin]) return SendClientMessage(playerid, -1, "Event-i Ukve Daiwyo!"); 
	eventp_Joined[playerid] = true;
	Event[eventid][event_LeftPlayers]++;
	eventp_JoinedID[playerid] = eventid;
	eventp_Spawn(eventid, playerid);
	eventp_IsInRangeChecker[playerid] = SetTimerEx("eventp_CheckPlayerInRange", 150, 1, "d", playerid);
	#if defined eventp_OnPlayerJoin
		CallLocalFunction("eventp_OnPlayerJoin", "ddd", playerid, eventid, Event[eventid][event_Style]); 
	#endif
	return 1;
}

stock eventp_Spawn(eventid, playerid)
{
	SetPlayerPos(playerid, Event[eventid][event_SpawnX], Event[eventid][event_SpawnY], Event[eventid][event_SpawnZ]);
	eventp_Spawned[playerid] = true;
	if(!Event[eventid][event_PlayerCantJoin])
	{
		TogglePlayerControllable(playerid, false);
	}
	return 1;
}	

