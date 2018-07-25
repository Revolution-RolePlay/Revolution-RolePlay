#include <YSI\y_hooks>

static Player_EmailAcceptCode[MAX_PLAYERS][64],
	   Player_Email[MAX_PLAYERS][64],
bool:  Player_HaveEmail[MAX_PLAYERS];

hook OnGameModeInit()
{
	db_query(Users, "CREATE TABLE IF NOT EXISTS `email` (\
        `username` VARCHAR(24) PRIMARY KEY, \
        `email` VARCHAR(64), \
        `emailverifycode` VARCHAR(64) )");
}


hook Player_RegisterProcess2(playerid)
{
	if(gEmailNeeded)
	{
		ShowPlayerDialog(playerid, 2, DIALOG_STYLE_INPUT, "Chaweret Tqveni Aqtiuri Eleqtronuli Fosta", "Registraciis Dasasruleblad Sachiroa Sheiyvanot Tqveni E-Mail-i.\nE-mail is sheyvanistanave tqven mogivat fostaze 4 simboloiani kodi\nKodis chaweris shemdeg tqveni accounti gaxdeba verificirebuli", "Continue", "");
	}
	return 1;
}

hook OnPlayerLogin(playerid)
{
	new Name[MAX_PLAYER_NAME], DBResult:CheckEmail, Query[164];
	GetPlayerName(playerid, Name, sizeof(Name));
	format(Query, sizeof(Query), "SELECT * FROM `email` WHERE `username` = '%s'", DB_Escape(Name));
	CheckEmail = db_query(Users, Query);
	if(db_num_rows(CheckEmail))
	{
		db_get_field_assoc(CheckEmail, "email", Player_Email[playerid], 64);
		db_get_field_assoc(CheckEmail, "emailverifycode", Player_EmailAcceptCode[playerid], 64);
		Player_HaveEmail[playerid] = true;
	}
	else
	{
		if(gEmailNeeded)
		{
			ShowPlayerDialog(playerid, 2, DIALOG_STYLE_INPUT, "Chaweret Tqveni Aqtiuri Eleqtronuli Fosta", "Registraciis Dasasruleblad Sachiroa Sheiyvanot Tqveni E-Mail-i.\nE-mail is sheyvanistanave tqven mogivat fostaze 4 simboloiani kodi\nKodis chaweris shemdeg tqveni accounti gaxdeba verificirebuli", "Continue", "");			
		}
	}
	db_free_result(CheckEmail);	
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 2)
	{
		if(response)
		{
			new string[64];
			GenerateEmailAcceptCode(Player_EmailAcceptCode[playerid]);
			format(string, sizeof(string), "Kodi Tqveni Aqauntis Verifikaciistvis: %s", Player_EmailAcceptCode[playerid]);
			strcat(Player_Email[playerid], inputtext, 64);
			ChatMsg(playerid, -1, string);
			SendMail(Player_Email[playerid], "medzvel@gmail.com", "Ragaca Yleoba RPG - Registracia", "Kodi Verifikaciistvis", string);
			//ChatMsg(playerid, COLOR<WHITE>, "Insert the code which you received.");
			ShowPlayerDialog(playerid, 3, DIALOG_STYLE_INPUT, "Verifikacia", "Sheiyvanet fostaze gamogzavnili kodi", "Continue", "Cancel");
			//ShowKeypad(playerid, strval(Player_EmailAcceptCode[playerid]) );
		}
		else
		{
			Kick(playerid);
		}
	}
	if(dialogid == 3)
	{
		if(response)
		{
			if(strmatch(inputtext, Player_EmailAcceptCode[playerid]))
			{
				new Query[164], Name[MAX_PLAYER_NAME];
				GetPlayerName(playerid, Name, sizeof(Name));
				format(Query, sizeof(Query), "INSERT INTO `email` (`username`, `email`, `emailverifycode`) VALUES('%s', '%s', '%s')", DB_Escape(Name), DB_Escape(Player_Email[playerid]), DB_Escape(Player_EmailAcceptCode[playerid]));
				db_query(Users, Query);
				//ChatMsg(playerid, COLOR<GREEN>, "You have finished registration!");
				if(funcidx("Player_RegisterProcess3") != -1) CallLocalFunction("Player_RegisterProcess3","d",playerid);
				Player_HaveEmail[playerid] = true;
			}
			else
			{
				ChatMsg(playerid, COLOR<RED>, "Kodi Arasworia!");
				ShowPlayerDialog(playerid, 3, DIALOG_STYLE_INPUT, "Verifikacia", "Sheiyvanet fostaze gamogzavnili kodi", "Continue", "Cancel");
			}
		}
		else
		{
			Kick(playerid);
		}
	}
	return 1;
}


GenerateEmailAcceptCode(result[], len = sizeof(result))
{
	format(result, len, "%d%s%d%s", random(10), LetterList[random(sizeof(LetterList))], random(20), LetterList[random(sizeof(LetterList))]); 
}


GetPlayerEmail(playerid, result[], len = sizeof(result))
{
	format(result, sizeof(result), "%s", Player_Email[playerid]);
}

GetPlayerEmailVerifyCode(playerid, result[], len = sizeof(result))
{
	format(result, sizeof(result), "%s", Player_EmailAcceptCode[playerid]);
}

/*hook OnPlayerKeypadEnter(playerid, success)
{
	if(success == 1)
	{
		new Query[164], Name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, Name, sizeof(Name));
		format(Query, sizeof(Query), "INSERT INTO `email` (`username`, `email`, `emailverifycode`) VALUES('%s', '%s', '%s')", DB_Escape(Name), DB_Escape(Player_Email[playerid]), DB_Escape(Player_EmailAcceptCode[playerid]));
		db_query(Users, Query);
		ChatMsg(playerid, COLOR<GREEN>, "You have finished registration!");
		Player_HaveEmail[playerid] = true;		
	}
	else
	{
		ChatMsg(playerid, COLOR<RED>, "WRONG CODE!");
		ShowKeypad(playerid, strval(Player_EmailAcceptCode[playerid]));
		ShowPlayerDialog(playerid, 3, DIALOG_STYLE_INPUT, "Write Your Secret Code", "Write The Code Which We Sent You On Your E-Mail!", "Continue", "Cancel");		
	}
}

hook OnPlayerCancelKP(playerid)
{
	Kick(playerid);
}*/