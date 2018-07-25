#include <YSI\y_hooks>

enum
{
	GENDER_NONE,
	GENDER_MALE,
	GENDER_FEMALE
}

static 
		Gender_Name[3][15] = {
			"",
			"Male",
			"Female"
		},
		Player_Gender[MAX_PLAYERS];


hook OnGameModeInit()
{
    db_query(Users, "CREATE TABLE IF NOT EXISTS `gender` (\
        `username` VARCHAR(24) PRIMARY KEY, \
        `genderid` INT NOT NULL DEFAULT '1')");
    return 1;
}

hook OnPlayerLogin(playerid)
{
	new Name[MAX_PLAYER_NAME], DBResult:GetGender, Query[164];
	GetPlayerName(playerid, Name, sizeof(Name));
	format(Query, sizeof(Query), "SELECT * FROM `gender` WHERE `username` = '%s'", DB_Escape(Name));
	GetGender = db_query(Users, Query);
	if(db_num_rows(GetGender))
	{
		SetPlayerGender(playerid, db_get_field_assoc_int(GetGender, "genderid"));
	}
	db_free_result(GetGender);	
	return 1;
}

hook Player_RegisterProcess3(playerid)
{
	ShowPlayerDialog(playerid, 4, DIALOG_STYLE_MSGBOX, "Gender", "Choose your gender!", "Male", "Female");
	return 1;
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new Query[164], Name[MAX_PLAYERS];
	GetPlayerName(playerid, Name, MAX_PLAYERS);
	if(dialogid == 4)
	{
		if(response)
		{
			ChatMsg(playerid, -1, "Your character gender is %s. ",Gender_Name[1]);
			Player_Gender[playerid] = 1;
			format(Query, sizeof(Query), "INSERT INTO `gender` (`username`, `genderid`) VALUES('%s',%d)", DB_Escape(Name), Player_Gender[playerid]);
    		db_query(Users, Query);		
    		if(funcidx("Player_RegisterProcess4") != -1) CallLocalFunction("Player_RegisterProcess4","d",playerid);
		}
		else
		{
			ChatMsg(playerid, -1, "Your character gender is %s. ",Gender_Name[2]);
			Player_Gender[playerid] = 2;
			format(Query, sizeof(Query), "INSERT INTO `gender` (`username`, `genderid`) VALUES('%s',%d)", DB_Escape(Name), Player_Gender[playerid]);
    		db_query(Users, Query);
    		if(funcidx("Player_RegisterProcess4") != -1) CallLocalFunction("Player_RegisterProcess4","d",playerid);				
		}
	}
}

GetPlayerGender(playerid, &gender)
{
	gender = Player_Gender[playerid];
}

GetGenderName(out[], gender, len = sizeof(out))
{
	format(out, len, "%s", Gender_Name[gender]);
}

SetPlayerGender(playerid, genderid)
{
	return Player_Gender[playerid] = genderid;
}