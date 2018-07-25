#include <YSI\y_hooks>

forward UpdateP(playerid);
forward PayDay(playerid);
forward ScoreUpdate(playerid);

static 
		Player_Level[MAX_PLAYERS],
		Player_Exp[MAX_PLAYERS],
	bool:Player_TookPayDay[MAX_PLAYERS] = false
;


static 
		LevelOld, 
		levelexp = 4
; 


hook OnGameModeInit()
{
	db_query(Users, "CREATE TABLE IF NOT EXISTS `level-exp` (\
        `username` VARCHAR(24) PRIMARY KEY, \
        `level` INT NOT NULL DEFAULT '1', \
        `exp` INT NOT NULL DEFAULT '4' )");

	SetTimer("UpdateP", 100, 1);
	SetTimer("ScoreUpdate", 1000, 1);
	//SetTimer("ScoreUpdate", 1000, 1);
}

public UpdateP()
{
	new
		hour = 0,
		minute = 0,
		second = 0
	;	 
	gettime(hour, minute, second);

	if(minute == 0)
	{
		foreach(new i : Player)
		{
			if(Player_TookPayDay[i] == false)
			{
				PayDay(i);
				Player_TookPayDay[i] = true;
			}
			if(minute == 1)
			{	
				Player_TookPayDay[i] = false;
			}
		}
	}
	return 1;
}

public ScoreUpdate()
{
	new Level;
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
   			Level = GetPlayerLevel(i);
			SetPlayerLevel(i, Level);
			if (Level > LevelOld)
			{
				LevelOld = Level;
			}
		}
	}
}

public PayDay(playerid)
{
	SetPlayerExp(playerid, GetPlayerExp(playerid)+1);
 	/* CHECKING IF PLAYER WOULD LEVEL UP */
    new nxtlevel = GetPlayerLevel(playerid)+1; 
 	new expamount = nxtlevel*levelexp;
	if(GetPlayerExp(playerid) < expamount)
	{
		ChatMsg(playerid,COLOR<LIME>,"Tqven Gchirdebat %s[%d]%s EXP Rata Gadaxvidet Axal Level-ze. Mimdinare EXP %s[%d]",SCOLOR<LIGHTGREEN>,expamount,SCOLOR<LIME>,SCOLOR<LIGHTGREEN>,GetPlayerExp(playerid));
	}
	else
	{
		SetPlayerExp(playerid, 0); 
		SetPlayerLevel(playerid, GetPlayerLevel(playerid)+1); 
		ChatMsg(playerid, COLOR<LIME>, "Tqveni Leveli Gaxda [%d]", GetPlayerLevel(playerid));
	}	
	return 1;
}

hook OnPlayerRegister(playerid)
{
	new Name[MAX_PLAYER_NAME], Query[164];
	GetPlayerName(playerid, Name, MAX_PLAYER_NAME);

	SetPlayerLevel(playerid, 1);
	SetPlayerExp(playerid, 4);

	format(Query, sizeof(Query), "INSERT INTO `level-exp` (`username`, `level`, `exp`) VALUES('%s', %d, %d)", DB_Escape(Name), GetPlayerLevel(playerid), GetPlayerExp(playerid));
	db_query(Users, Query);	
}

hook OnPlayerLogin(playerid)
{
	new Name[MAX_PLAYER_NAME], DBResult:GetLevelExp, Query[164];
	GetPlayerName(playerid, Name, sizeof(Name));
	format(Query, sizeof(Query), "SELECT * FROM `level-exp` WHERE `username` = '%s'", DB_Escape(Name));
	GetLevelExp = db_query(Users, Query);
	if(db_num_rows(GetLevelExp))
	{
		SetPlayerLevel(playerid, db_get_field_assoc_int(GetLevelExp, "level"));
		SetPlayerExp(playerid, db_get_field_assoc_int(GetLevelExp, "exp"));
	}
	db_free_result(GetLevelExp);
}

hook OnPlayerDisconnect(playerid, reason)
{
	new Query[224], Name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, Name, MAX_PLAYER_NAME);
	format(Query,sizeof(Query),"UPDATE `level-exp` SET level = %d, exp = %d WHERE `username` = '%s'", GetPlayerLevel(playerid), GetPlayerExp(playerid), DB_Escape(Name));
    db_query(Users, Query);
}

SetPlayerLevel(playerid, level)
{
	SetPlayerScore(playerid, level);

	Player_Level[playerid] = level;
}

SetPlayerExp(playerid, exp)
{
	Player_Exp[playerid] = exp;
}

GetPlayerLevel(playerid)
{
	return Player_Level[playerid];
}

GetPlayerExp(playerid)
{
	return Player_Exp[playerid];
}