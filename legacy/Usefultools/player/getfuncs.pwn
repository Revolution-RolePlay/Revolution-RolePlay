

#include <a_samp>

forward GetP::Pos(playerid, Float:x, Float:y, Float:z, Float:a);
forward GetP::HP(playerid, Float:hp);
forward GetP::Vehicle(playerid);

stock GetP::Pos(playerid, Float:x, Float:y, Float:z, Float:a)
{
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
}

stock GetP::HP(playerid, Float:hp)
{
	GetPlayerHealth(playerid, hp);
}

stock GetP::Vehicle(playerid)
{
	static vehicleid;
	vehicleid = GetPlayerVehicleID(playerid);
	return vehicleid;
}