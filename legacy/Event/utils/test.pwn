/*
	Example Script For EVENT System FrameWork
	Created By Amagida
*/	
#include <a_samp>
#include <zcmd> //https://pastebin.com/SbJc7iXa
#include <event> //https://github.com/Amagida/EVENT-FRAMEWORK

new DeagleEvent;

public Event::OnCreate(eventid, Float:x, Float:y, Float:z, Float:SpawnX, Float:SpawnY, Float:SpawnZ, Float:range, vw, int, style, MaxPlayers)
{
	printf("TEST DEBUG FOR EVENT ID %d", eventid);
	printf("%f", x);
	printf("%f", y);
	printf("%f", z);
	printf("%f", SpawnX);
	printf("%f", SpawnY);
	printf("%f", SpawnZ);
	printf("%d", vw);
	printf("%d", int);
	printf("%d", style);
	printf("%d", MaxPlayers);
	return 1;
}

public Event::OnStart(eventid, style)
{
	new eventname[126], string[126];
    Event::GetInfo(eventid, "name", eventname);
    format(string, sizeof(string), "%s Started! For Joining Event Write /joindglevent!", eventname);
	SendClientMessageToAll(-1, string);
	return 1;
}

public EVENTP::OnPlayerJoin(playerid, eventid, style)
{
	new eventname[126], string[126];
    Event::GetInfo(eventid, "name", eventname);
    format(string, sizeof(string), "You Joined Event: %s! You got desert eagle for playing on event!",eventname);
	SendClientMessage(playerid, -1, string);
	GivePlayerWeapon(playerid, 24, 9999);
	return 1;
}

public EVENTP::OnPlayerWin(playerid, eventid)
{
	SendClientMessage(playerid, 64, "You won event!");
	return 1;
}

public OnGameModeInit()
{
	DeagleEvent = Event::Create("Deagle Event", 837.5248, -2011.0693 ,12.8672, 837.5248, -2011.0693, 12.8672, 30.0, 0, 0, 1, 2);
	return 1;
}	

CMD:startdeaglevent(playerid, params[])
{
	Event::Start(DeagleEvent, 5);
	return 1;
}

CMD:joindglevent(playerid, params[])
{
	EVENTP::Join(DeagleEvent, playerid);
	return 1;
}