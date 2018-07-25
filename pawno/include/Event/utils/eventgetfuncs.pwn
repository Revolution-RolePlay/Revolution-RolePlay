#include <a_samp>

static stock strmatch(const out1[], const out2[])
{
	if((strcmp(out1, out2, true, strlen(out2)) == 0) && (strlen(out2) == strlen(out1))) return true;
	else return false;
}	

stock event_GetInfo(eventid, argument[], out[])
{
	if(strmatch(argument, "name"))
	{
		format(out, 64, "%s", Event[eventid][event_Name]);
	}
	if(strmatch(argument, "x"))
	{
		format(out, 64, "%f", Event[eventid][event_x]);
	}
	if(strmatch(argument, "y"))
	{
		format(out, 64, "%f", Event[eventid][event_y]);
	}
	if(strmatch(argument, "z"))
	{
		format(out, 64, "%f", Event[eventid][event_z]);
	}
	if(strmatch(argument, "range"))
	{
		format(out, 64, "%f", Event[eventid][event_Range]);
	}
	if(strmatch(argument, "SpawnX"))
	{
		format(out, 64, "%f", Event[eventid][event_SpawnX]);
	}
	if(strmatch(argument, "SpawnY"))
	{
		format(out, 64, "%f", Event[eventid][event_SpawnY]);
	}
	if(strmatch(argument, "SpawnZ"))
	{
		format(out, 64, "%f", Event[eventid][event_SpawnZ]);
	}
	if(strmatch(argument, "int"))
	{
		format(out, 64, "%d", Event[eventid][event_int]);
	}
	if(strmatch(argument, "vw"))
	{
		format(out, 64, "%d", Event[eventid][event_vw]);
	}
	if(strmatch(argument, "maxplayers"))
	{
		format(out, 64, "%d", Event[eventid][event_MaxPlayers]);
	}
}