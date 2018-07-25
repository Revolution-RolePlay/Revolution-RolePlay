#include <YSI\y_hooks>
#include <YSI\y_groups>

#define MAX_ADMIN_LEVELS			(7)


enum
{
	STAFF_LEVEL_NONE,
	STAFF_LEVEL_GAME_MASTER,
	STAFF_LEVEL_MODERATOR,
	STAFF_LEVEL_ADMINISTRATOR,
	STAFF_LEVEL_LEAD,
	STAFF_LEVEL_DEVELOPER,
	STAFF_LEVEL_SECRET
}

new 			
				Group:admin_GameMaster,
				Group:admin_Moderator,
				Group:admin_Administrator,
				Group:admin_Overseer,
				Group:admin_Developer;

static
				admin_Names[MAX_ADMIN_LEVELS][15] =
				{
					"Player",			// 0 (Unused)
					"Game Master",		// 1
					"Moderator",		// 2
					"Administrator",	// 3
					"Overseer",			// 4
					"Developer",		// 5
					""					// 6
				},
				admin_Colours[MAX_ADMIN_LEVELS] =
				{
					0xFFFFFFFF,			// 0 (Unused)
					0x5DFC0AFF,			// 1
					0x33CCFFFF,			// 2
					0x6600FFFF,			// 3
					0xFF0000FF,			// 4
					0xFF3200FF,			// 5
					0x00000000			// 6
				},
				admin_Commands[4][512];

static
				admin_Level[MAX_PLAYERS],
				admin_OnDuty[MAX_PLAYERS],
				admin_PlayerKicked[MAX_PLAYERS];


hook OnGameModeInit()
{
    db_query(Users, "CREATE TABLE IF NOT EXISTS `admins` (\
        `username` VARCHAR(24) PRIMARY KEY, \
        `level` INT NOT NULL DEFAULT '0')");
	admin_GameMaster = Group_Create("Game Master");
	admin_Moderator = Group_Create("Moderator");
	admin_Administrator = Group_Create("Administrator");
	admin_Overseer = Group_Create("Overseer");
	admin_Developer = Group_Create("Developer");
	return 1;
}


hook OnPlayerLogin(playerid)
{
	new Name[MAX_PLAYER_NAME], DBResult:CheckAdmin, Query[164];
	GetPlayerName(playerid, Name, sizeof(Name));
	format(Query, sizeof(Query), "SELECT * FROM `admins` WHERE `username` = '%s'", DB_Escape(Name));
	CheckAdmin = db_query(Users, Query);
	if(db_num_rows(CheckAdmin))
	{
		SetPlayerAdminLevel(playerid, db_get_field_assoc_int(CheckAdmin, "level"));
	}
	db_free_result(CheckAdmin);
	return 1;
}

stock MakePlayerAdmin(playerid)
{
	new Name[MAX_PLAYER_NAME], Query[164];
	GetPlayerName(playerid, Name, sizeof(Name));
	format(Query, sizeof(Query), "INSERT INTO `admins` (`username`, `level`) VALUES('%s', %d)", DB_Escape(Name), STAFF_LEVEL_GAME_MASTER);
	db_query(Users, Query);
	dbg("modules/core/player/admin.pwn", 1, Query);
}

SetPlayerAdminLevel(playerid, level)
{
	new Name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, Name, sizeof(Name));
	admin_Level[playerid] = level;
	SetAccountAdminLevel(Name, level);
	PlayerRemoveFromAllAG(playerid);
	switch(level)
	{
		case 1: Group_SetPlayer(admin_GameMaster, playerid, true);
		case 2: Group_SetPlayer(admin_Moderator, playerid, true);
		case 3: Group_SetPlayer(admin_Administrator, playerid, true);
		case 4: Group_SetPlayer(admin_Overseer, playerid, true);
		case 5: Group_SetPlayer(admin_Developer, playerid, true);
	}
}

PlayerRemoveFromAllAG(playerid)
{
	Group_SetPlayer(admin_GameMaster, playerid, false);
	Group_SetPlayer(admin_Moderator, playerid, false);
	Group_SetPlayer(admin_Administrator, playerid, false);
	Group_SetPlayer(admin_Overseer, playerid, false);
	Group_SetPlayer(admin_Developer, playerid, false);	
}

SetAccountAdminLevel(name[MAX_PLAYER_NAME], value)
{
	DB_SetFieldInt(Users, "admins", "level", "username", name, value);
}

GetPlayerAdminLevel(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 0;
	return admin_Level[playerid];
}

GetAdminLevelName(out[], level, len = sizeof(out))
{
	format(out, len, "%s", admin_Names[level]);
}