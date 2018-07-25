#include <YSI\y_hooks>


forward OnPlayerLogin(playerid);
forward Player_RegisterProcess2(playerid);
forward Player_RegisterProcess3(playerid);
enum _user
{
	SQLID,
	Password[64 + 1],
	VIP_Level,
	Admin_Level,
	IP[18 + 1]
}

new uInfo[MAX_PLAYERS][_user];

new DB:Users;

new bool:LoggedIn[MAX_PLAYERS];

hook OnGameModeInit()
{
	db_debug_openresults();
    Users = db_open("Users.db");
	db_query(Users, "PRAGMA synchronous = NORMAL");
 	db_query(Users, "PRAGMA journal_mode = WAL");


	new string[364];
	string = "CREATE TABLE IF NOT EXISTS `users`(\
		`id` INTEGER PRIMARY KEY, \
		`name` VARCHAR(24) NOT NULL DEFAULT '', \
		`password` VARCHAR(64) NOT NULL DEFAULT '', \
		`ip` VARCHAR(18) NOT NULL DEFAULT '')";
	db_query(Users, string);

    db_query(Users, "CREATE TABLE IF NOT EXISTS `savedpos` (\
        `username` VARCHAR(24) PRIMARY KEY, \
        `posx` FLOAT, \
        `posy` FLOAT, \
        `posz` FLOAT, \
        `posr` FLOAT)");
	DisableInteriorEnterExits();
 	return 1;
}

hook OnGameModeExit()
{
	db_close(Users);
	return 1;
}

hook OnPlayerRegister(playerid)
{
    ChatMsg(playerid, -1, "Tqven Warmatebit Gaiaret Registracia!");
    return 1; 
}

hook OnPlayerConnect(playerid)
{
    new Query[260], DBResult:Result, name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    //ShowPlayerRegisterLoginUI(playerid);
    if(IsRPName(name) == false)
    {
        ChatMsg(playerid, -1, "Tqveni Saxeli Ar Aris Swor Format-shi[Saxeli_Gvari]!");
        Kick(playerid);
    }
   // ChatMsg(playerid, COLOR<RED>, gMessageOfTheDay);
    format(Query, sizeof(Query), "SELECT `name` FROM `users` WHERE `name` = '%s'", DB_Escape(name));
    Result = db_query(Users, Query);
    if(db_num_rows(Result))
    {
        format(Query, sizeof(Query), "{FFFFFF}Mogesalmebit %s(%d){FFFFFF} -ze, Tqven xart registrirebuli chvens serverze\n\nAvtorizaciistvis gtxovt chawerot paroli mocemul grafashi", name, playerid);
        ShowPlayerDialog(playerid, 1, DIALOG_STYLE_INPUT, "{FFFFFF}Avtorizacia", Query, "Login", "Gasvla");
    }
    else
    {
        format(Query, sizeof(Query), "{FFFFFF}Mogesalmebit %s(%d){FFFFFF} -ze, Tqven ar xart registrirebuli chvens serverze\n\nServerze satamashod aucilebelia daregistrireba\nGtxovt sheiyvanot paroli mocemul grafashi", name, playerid);
        ShowPlayerDialog(playerid, 0, DIALOG_STYLE_INPUT, "{FFFFFF}Registracia", Query, "Register", "Gasvla");
    }
    db_free_result(Result);
    return 1;
}    

hook OnPlayerDisconnect(playerid, reason)
{
    new Query[200], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name)); 
    if(LoggedIn{playerid})
    {
        new Float:x, Float:y, Float:z, Float:r;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, r);
        format(Query,sizeof(Query),"UPDATE `users` SET Admin_Level = '%d', VIP_Level = '%d' WHERE `name` = '%s'", uInfo[playerid][Admin_Level], uInfo[playerid][VIP_Level], name);
        db_query(Users, Query); 
        LoggedIn{playerid} = false;
  	}
    return 1;
}

/*hook OnPlayerSpawn(playerid)
{
    HidePlayerRegisterLoginUI(playerid);
}*/

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
        new Query[256], DBResult: Account, name[MAX_PLAYER_NAME], ip[16];
        GetPlayerName(playerid, name, sizeof(name));
        GetPlayerIp(playerid, ip, sizeof(ip));
        if(dialogid == 1)
        {
            if(response)
            {
                format(Query, sizeof(Query), "SELECT * FROM `users` WHERE `name` = '%s' AND `password` = '%s'", DB_Escape(name), DB_Escape(inputtext));
                Account = db_query(Users, Query);
             
                if(db_num_rows(Account))
                {
                    uInfo[playerid][SQLID] = db_get_field_assoc_int(Account, "id");
                    db_get_field_assoc(Account, "ip", uInfo[playerid][IP], 64+1);
                    LoggedIn{playerid} = true;
                    ChatMsg(playerid, -1, "%s %s %s You have successfully logged in!", SCOLOR<GREEN>, name, SCOLOR<WHITE>);
                    if(funcidx("OnPlayerLogin") != -1) CallLocalFunction("OnPlayerLogin","d",playerid);
                }
                else
                {
                    format(Query, sizeof(Query), "{FFFFFF}Mogesalmebit%s(%d){FFFFFF} -ze, Tqven xart registrilebuli chvens serverze\n\nAvtorizaciistvis gtxovt chawerot paroli mocemul grafashi", name, playerid);
                    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_INPUT, "{FFFFFF}Register System", Query, "Login", "Leave");
                    ChatMsg(playerid, -1, "Paroli Arasworia, Scadet Axlidan!");
                }
                db_free_result(Account);
            }
            else return Kick(playerid);
        }
        if(dialogid == 0)
        {
            if(response)
            {
                if(strlen(inputtext) > 24 || strlen(inputtext) < 3)
                {
                    format(Query, sizeof(Query), "{FFFFFF}Welcome %s(%d){FFFFFF} to the server, you're not{FFFFFF} registered\n\nPlease log in by inputting your password.", name, playerid);
                    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_INPUT, "{FFFFFF}Register System", Query, "Register", "Leave");
                    ChatMsg(playerid, -1, "Your password length must be from 3 - 24 characters!");
                }
                else
                {
                    //new
                      //  Float:x,
                        //Float:y,
                        //Float:z,
                        //Float:r;
                    format(Query, sizeof(Query), "INSERT INTO `users` (`name`, `password`, `ip`) VALUES('%s','%s','%s')", DB_Escape(name), DB_Escape(inputtext), DB_Escape(ip));
                    db_query(Users, Query);
        			LoggedIn{playerid} = true;
                    SetPlayerScore(playerid, 0);
                    //GenerateSpawnPoint(x, y, z, r);    
                //    SetSpawnInfo(playerid, NO_TEAM, 0, x, y, z, r, 0, 0, 0, 0, 0, 0);
//                    format(Query, sizeof(Query), "INSERT INTO `savedpos` (`username`, `posx`, `posy`, `posz`, `posr`) VALUES('%s', %f, %f, %f, %f)", DB_Escape(name), x, y, z, r);   
  //                  db_query(Users, Query);
                  //  SpawnPlayer(playerid);
                    if(funcidx("Player_RegisterProcess2") != -1) CallLocalFunction("Player_RegisterProcess2","d",playerid);
                    ChatMsg(playerid, -1, "%s %s %s You have successfully %s registered! %s You have been automatically logged in!", SCOLOR<GREEN>, name, SCOLOR<WHITE>, SCOLOR<BLUE>, SCOLOR<WHITE>);
                }
            }
            else return Kick(playerid); // Kick the player if he selected 'Leave'
        }
        return 1;
}