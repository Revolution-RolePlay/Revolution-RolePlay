#include <a_samp>

forward eventp_OnPlayerWin(playerid, eventid);

forward event_CheckWinner();
public event_CheckWinner()
{
	for(new i; i<MAX_PLAYERS; i++)
	{
		if(Event[eventp_JoinedID[i]][event_LeftPlayers] == 1)
		{
			#if defined eventp_OnPlayerWin
				CallLocalFunction("eventp_OnPlayerWin","dd", i, eventp_JoinedID[i]);
			#endif
			Event[eventp_JoinedID[i]][event_Started] = false;
			Event[eventp_JoinedID[i]][event_PlayerCantJoin] = false;
			Event[eventp_JoinedID[i]][event_LeftPlayers] = 0;
			eventp_Joined[i] = false;
			eventp_Spawned[i] = false;
			eventp_JoinedID[i] = -1;			
			SpawnPlayer(i);
			KillTimer(event_CheckWinerTimer);
		}
	}
}