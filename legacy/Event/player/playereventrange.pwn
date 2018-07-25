#include <a_samp>

new eventp_RangeWarning[MAX_PLAYERS];

forward eventp_CheckPlayerInRange(playerid);
public eventp_CheckPlayerInRange(playerid)
{
	if(!IsPlayerInRangeOfPoint(playerid, Event[eventp_JoinedID[playerid]][event_Range], Event[eventp_JoinedID[playerid]][event_x], Event[eventp_JoinedID[playerid]][event_y], Event[eventp_JoinedID[playerid]][event_z]))
	{
		GameTextForPlayer(playerid, "Stay In Event Bounds Or You Will Be Kicked From Event!", 2000, 3);
//		eventp_Spawn(eventp_JoinedID[playerid], playerid);
		eventp_RangeWarning[playerid]++;
		eventp_Spawn(eventp_JoinedID[playerid], playerid);
		if(eventp_RangeWarning[playerid] == 1)
		{
			eventp_Spawn(eventp_JoinedID[playerid], playerid);
		}
		if(eventp_RangeWarning[playerid] >= 5)
		{
			eventp_JoinedID[playerid] = -1;
			eventp_Joined[playerid] = false; 
			eventp_Spawned[playerid] = false;
			Event[eventp_JoinedID[playerid]][event_LeftPlayers]--;
			KillTimer(eventp_IsInRangeChecker[playerid]);
		}
		//SetPlayerWorldBounds(playerid, Event[eventp_JoinedID[playerid]][event_x]+20, Event[eventp_JoinedID[playerid]][event_x]-20, Event[eventp_JoinedID[playerid]][event_y]+20, Event[eventp_JoinedID[playerid]][event_y]-20);
	}
}
