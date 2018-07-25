#include <a_samp>


public OnPlayerDeath(playerid, killerid, reason)
{
	if(eventp_Joined[playerid])
	{
		Event[eventp_JoinedID[playerid]][event_LeftPlayers]--;	
		eventp_Joined[playerid] = false;
		eventp_Spawned[playerid] = false;
		eventp_JoinedID[playerid] = -1;
		KillTimer(eventp_IsInRangeChecker[playerid]);
	}

	#if defined Event_OnGameModeInit
	return Event_OnGameModeInit();
	#else
	return 1;
	#endif
}

#if defined _ALS_OnPlayerDeath
#undef OnPlayerDeath
#else
#define _ALS_OnPlayerDeath
#endif

#define OnPlayerDeath Event_OnPlayerDeath
#if defined Event_OnPlayerDeath
forward Event_OnPlayerDeath();
#endif