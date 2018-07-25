/*
	Event Framework
	Event Create Functions
	Author: Amagida
*/	

#include <a_samp>

/* FORWARDS */
forward event_OnCreate(eventid, Float:x, Float:y, Float:z, Float:SpawnX, Float:SpawnY, Float:SpawnZ, Float:range, vw, int, style, MaxPlayers);
forward event_Create(Name[], Float:x, Float:y, Float:z, Float:SpawnX, Float:SpawnY, Float:SpawnZ, Float:range, vw, int, style, MaxPlayers);

#define MAX_EVENT 20

enum event_createEnum 
{
	   event_id,
	   event_Name[164],	
Float: event_x,
Float: event_y,
Float: event_z,
Float: event_SpawnX,
Float: event_SpawnY,
Float: event_SpawnZ,
Float: event_Range,
	   event_vw,
bool:  event_Started,
       event_int,
	   event_Style,
	   event_MaxPlayers,
	   event_LeftPlayers,
bool:  event_PlayerCantJoin	
}

new Event[MAX_EVENT][event_createEnum];

new event_Created = 0;

stock event_Create(Name[], Float:x, Float:y, Float:z, Float:SpawnX, Float:SpawnY, Float:SpawnZ, Float:range, vw, int, style, MaxPlayers)
{

	event_Created++;
	Event[event_Created][event_id] = event_Created;
	strcat(Event[event_Created][event_Name], Name);
	Event[event_Created][event_x] = x;
	Event[event_Created][event_y] = y;
	Event[event_Created][event_z] = z;
	Event[event_Created][event_SpawnX] = SpawnX;
	Event[event_Created][event_SpawnY] = SpawnY;
	Event[event_Created][event_SpawnZ] = SpawnZ;
	Event[event_Created][event_Range] = range;
	Event[event_Created][event_vw] = vw;
	Event[event_Created][event_Started] = false;
	Event[event_Created][event_int] = int;
	Event[event_Created][event_Style] = style;
	Event[event_Created][event_MaxPlayers] = MaxPlayers;
	Event[event_Created][event_LeftPlayers] = 0;
	Event[event_Created][event_PlayerCantJoin] = false;
	#if defined event_OnCreate
		CallLocalFunction("event_OnCreate","dfffffffdddd", event_Created,x,y,z,SpawnX,SpawnY,SpawnZ,range,vw,int,style,MaxPlayers);
	#endif
	return 1;

}	