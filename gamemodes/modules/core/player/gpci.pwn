#include <YSI\y_hooks>

static Player_GPCI[MAX_PLAYERS][128]; 

hook OnGameModeInit()
{
	db_query(Users, "CREATE TABLE IF NOT EXISTS `gpci` (\
		`username` VARCHAR(24) PRIMARY KEY, \
		`gpci` VARCHAR(128) )");
}


hook OnPlayerRegister(playerid)
{
	new Name[MAX_PLAYER_NAME], Query[164], pgpci[128];
	GetPlayerName(playerid, Name, sizeof(Name));
	gpci(playerid, pgpci, sizeof(pgpci)); 
	format(Query, sizeof(Query), "INSERT INTO `gpci` (`username`, `gpci`) VALUES('%s', '%s')", DB_Escape(Name), pgpci);
	db_query(Users, Query);
	return 1;
}

hook OnPlayerLogin(playerid)
{
	new Name[MAX_PLAYER_NAME], DBResult:GetGPCI, Query[164];
	GetPlayerName(playerid, Name, sizeof(Name));
	format(Query, sizeof(Query), "SELECT * FROM `gpci` WHERE `username` = '%s'", DB_Escape(Name));
	GetGPCI = db_query(Users, Query);
	if(db_num_rows(GetGPCI))
	{
		new tookgpci[128];
		db_get_field_assoc(GetGPCI, "gpci", tookgpci, sizeof(tookgpci));
		SetPlayerGPCI(playerid, tookgpci);
	}
	db_free_result(GetGPCI);	
}


SetPlayerGPCI(playerid, pgpci[])
{
	//strcat(Player_GPCI[playerid], pgpci, sizeof(Player_GPCI[playerid]));
//	format(Player_GPCI[playerid], sizeof(Player_GPCI[playerid]), "%s", pgpci);
	format(Player_GPCI[playerid], 128, "%s", pgpci);
}

GetPlayerGPCI(playerid, result[], len = sizeof(result))
{
	format(result, len, "%s", Player_GPCI[playerid]);
}