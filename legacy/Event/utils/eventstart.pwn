#include <a_samp>

forward event_Start(eventid, intime);
forward event_OnStart(eventid, style);

new event_StartTime, event_StartCounterTimer, event_CheckWinerTimer;
forward event_StartCounter();

stock event_Start(eventid, intime)
{
	Event[eventid][event_Started] = true;
	event_StartTime = intime;
	#if defined event_OnStart
		CallLocalFunction("event_OnStart","dd", eventid, Event[eventid][event_Style]);
	#endif
	event_StartCounterTimer = SetTimer("event_StartCounter", 1000, true);
	return 1;
}

public event_StartCounter()
{
	if(event_StartTime == 0)
	{
		KillTimer(event_StartCounterTimer);
		for(new i; i<MAX_PLAYERS;i++)
		{
			if(eventp_Joined[i])
			{
				if(Event[eventp_JoinedID[i]][event_LeftPlayers] == 1)
				{
					SendClientMessage(i, -1, "You were the only one who joined event. Event Canceled");
					TogglePlayerControllable(i, true);
					Event[eventp_JoinedID[i]][event_Started] = false;
					SpawnPlayer(i);

				}
				else
				{
					TogglePlayerControllable(i, true);
					Event[eventp_JoinedID[i]][event_PlayerCantJoin] = true;
					event_CheckWinerTimer = SetTimer("event_CheckWinner", 100, true);
				}
			}
		}
	}
	for(new i; i<MAX_PLAYERS;i++)
	{
		if(eventp_Joined[i])
		{
			new string[120];
			format(string, sizeof(string), "EVENT STARING IN %d SECOND", event_StartTime);
			GameTextForPlayer(i, string, 1000, 1);
		}
	}
	event_StartTime--;
}