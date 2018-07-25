#include <YSI\y_hooks>



static
		Player_Cash[MAX_PLAYERS]
;

hook OnGameModeInit()
{
	db_query(Users, "CREATE TABLE IF NOT EXISTS `cash` (\
        `username` VARCHAR(24) PRIMARY KEY, \
        `cash` INT NOT NULL DEFAULT '150' )");
}		


hook OnPlayerRegister(playerid)
{
	new
		Name[MAX_PLAYER_NAME],
		Query[124]
	;
	GetPlayerName(playerid, Name, MAX_PLAYER_NAME);

	format(Query, sizeof(Query), "INSERT INTO `cash` (`username`, `cash`) VALUES('%s', %d)", DB_Escape(Name), 150);
	db_query(Users, Query);	

	SetPlayerCash(playerid, 150);
}


hook OnPlayerLogin(playerid)
{
	new Name[MAX_PLAYER_NAME], DBResult:GetMoney, Query[124];
	GetPlayerName(playerid, Name, sizeof(Name));
	format(Query, sizeof(Query), "SELECT * FROM `cash` WHERE `username` = '%s'", DB_Escape(Name));
	GetMoney = db_query(Users, Query);
	if(db_num_rows(GetMoney))
	{
		SetPlayerCash(playerid, db_get_field_assoc_int(GetMoney, "cash"));
	}
	db_free_result(GetMoney);
}


hook OnPlayerDisconnect(playerid, reason)
{
	new Query[224], Name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, Name, MAX_PLAYER_NAME);
	format(Query,sizeof(Query),"UPDATE `cash` SET cash = %d WHERE `username` = '%s'", GetPlayerCash(playerid), Name);
    db_query(Users, Query);
}


SetPlayerCash(playerid, amount)
{
	Player_Cash[playerid] = amount;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, Player_Cash[playerid]);
}

CanPlayerBuy(playerid, amount)
{
	if(GetPlayerCash(playerid) < amount) 
	{
		ChatMsg(playerid, -1, "Tqven Ar Gaqvt Sakmarisi Tanxa!");
		return false;
	}
	else
	{
		return true;
	}	 
}

GetPlayerCash(playerid)
{
	return Player_Cash[playerid];
}