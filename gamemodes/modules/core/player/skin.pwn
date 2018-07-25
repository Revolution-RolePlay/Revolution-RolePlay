#include <YSI\y_hooks>

static Player_Skin[MAX_PLAYERS];

hook OnGameModeInit()
{
    db_query(Users, "CREATE TABLE IF NOT EXISTS `skin` (\
        `username` VARCHAR(24) PRIMARY KEY, \
        `skinid` INT NOT NULL DEFAULT '0')");
    return 1;	
}


hook OnPlayerRegister(playerid)
{
	new Name[MAX_PLAYER_NAME], Query[164];
	GetPlayerName(playerid, Name, sizeof(Name));
    format(Query, sizeof(Query), "INSERT INTO `skin` (`username`, `skinid`) VALUES('%s',%d)", DB_Escape(Name), Player_Skin[playerid]);
    db_query(Users, Query);		
    SpawnPlayer(playerid);	 
    SetPlayerSkin(playerid, Player_Skin[playerid]);
    return 1;
}

hook OnPlayerSpawn(playerid)
{
	SetPlayerSkin(playerid, Player_Skin[playerid]);
	//ChatMsg(playerid, -1, "SET PLAYER SKIN %d", Player_Skin[playerid]);
	return 1;
}

hook OnPlayerLogin(playerid)
{
	new Name[MAX_PLAYER_NAME], DBResult:CheckSkin, Query[164];
	GetPlayerName(playerid, Name, sizeof(Name));
	format(Query, sizeof(Query), "SELECT * FROM `skin` WHERE `username` = '%s'", DB_Escape(Name));
	CheckSkin = db_query(Users, Query);
	if(db_num_rows(CheckSkin))
	{
		Player_Skin[playerid] = db_get_field_assoc_int(CheckSkin, "skinid");
	}
	db_free_result(CheckSkin);	
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	new Query[224], Name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, Name, MAX_PLAYER_NAME);
	format(Query,sizeof(Query),"UPDATE `skin` SET skinid = '%d' WHERE `username` = '%s'", Player_Skin[playerid], Name);
    db_query(Users, Query);
    return 1;
}

GetPlayerSkinEx(playerid)
{
	return Player_Skin[playerid];
}

SetPlayerSkinEx(playerid, idskin)
{
	Player_Skin[playerid] = idskin;
	SetPlayerSkin(playerid, idskin);
}