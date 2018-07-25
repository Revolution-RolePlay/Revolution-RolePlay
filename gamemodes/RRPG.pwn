#include <a_samp>

//
native gpci (playerid, serial [], len); 
//CLIENT CHECKER
native SendClientCheck(playerid, type, arg, offset, size);
forward OnClientCheckResponse(playerid, type, arg, response);
//

#include <crashdetect>
	
#include <sscanf2>
#include <streamer>
#include <FileManager>
/* YSI INCLUDES */
#include <YSI\y_hooks>
#include <YSI\y_va>
#include <YSI\y_iterate>
#include <YSI\y_groups>
//
#include <kickfix>
#include <simpleINI>
#include <newdialogstyle>
//
#include <easyPickUp>
#include <tdw_vylock>
/* COLORS */
#include <colors>
#include <colorlist>    
/* MAILER */
#define MAILER_URL "revolutionrpgg.000webhostapp.com/mailer.php"
#include <mailer>
/* MODULES */

//#include <cpstreamer>

main(){}

public OnGameModeInit()
{
	CreatePickUp(LSPD_Enter, 1318,23,1555.5056,-1675.6571,16.1953);//
	CreatePickUp(LSPD_Exit, 1318,23,246.8040,62.3258,1003.6406);//
	CreatePickUp(LSPD_Garage, 1318,23,246.4328,87.9121,1003.6406);
	CreatePickUp(LSPD_Garage2, 1318,23,1568.6288,-1689.9702,6.2188);
	EnableStuntBonusForAll(0);
}


//Utils
#include "modules/utils/messages.pwn"
#include "modules/utils/commandprocessor.pwn"
#include "modules/utils/player.pwn"
#include "modules/utils/debug.pwn"
#include "modules/utils/string.pwn"
#include "modules/utils/math.pwn"
#include "modules/utils/object-load.pwn"
//Core
#include "modules/core/server/settings.pwn"
//World
#include "modules/world/spawns.pwn"
#include "modules/world/spawn-rent.pwn"
#include "modules/world/atm.pwn"
//#include "modules/world/skin.pwn"
//Player
#include "modules/core/player/account-io.pwn"
#include "modules/core/player/main.pwn"
#include "modules/core/player/admin.pwn"
#include "modules/core/player/gpci.pwn"
#include "modules/core/player/email.pwn"
#include "modules/core/player/skin.pwn"
#include "modules/core/player/spawn.pwn"
#include "modules/core/player/gender.pwn"
#include "modules/core/player/player-nationality.pwn"
#include "modules/core/player/player-colour.pwn"
#include "modules/core/player/chat.pwn"
#include "modules/core/player/cash.pwn"
#include "modules/core/player/level-exp.pwn"
#include "modules/core/player/bank-card.pwn"
#include "modules/core/server/devblog.pwn"

PickUp:LSPD_Enter(playerid, pickupid)
{
    SetPlayerPos(playerid, 246.783996,63.900199,1003.640625); 
    SetPlayerInterior(playerid, 6);
    SetCameraBehindPlayer(playerid);
    SetPlayerFacingAngle(playerid, 0.3515);
    return 1;
}
PickUp:LSPD_Exit(playerid, pickupid)
{
    SetPlayerPos(playerid, 1552.5774,-1675.2703,16.1953); 
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetCameraBehindPlayer(playerid);
    SetPlayerFacingAngle(playerid, 89.0312);
    return 1;
}

PickUp:LSPD_Garage(playerid, pickupid)
{
    SetPlayerPos(playerid, 1569.1660,-1693.7256,5.8906); 
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetCameraBehindPlayer(playerid);
    SetPlayerFacingAngle(playerid, 179.2717);
    return 1;
}

PickUp:LSPD_Garage2(playerid, pickupid)
{
    SetPlayerPos(playerid, 246.2459,86.1815,1003.6406); 
    SetPlayerInterior(playerid, 6);
    SetCameraBehindPlayer(playerid);
    SetPlayerFacingAngle(playerid, 181.1754);
    return 1;
}
CMD:skin(playerid, params[])
{
	SetPlayerSkin(playerid, strval(params));
	return 1;
}


CMD:test(playerid, params[])
{
	Group_SetPlayer(admin_GameMaster, playerid, true);
	new Name[MAX_PLAYERS];
	foreach(new i : GroupMember(admin_GameMaster))
	{
		GetPlayerName(i, Name, MAX_PLAYERS);
		ChatMsg(playerid, -1, "%s", Name);
	}
	return 1;
}
CMD:testcash(playerid, params[])
{
	SetPlayerCash(playerid, strval(params));
	return 1;
}


