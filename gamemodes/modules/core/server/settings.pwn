#include <YSI\y_hooks>

#define MAX_MOTD_LEN				(128)
#define MAX_WEBSITE_NAME			(64)
#define MAX_RULE					(24)
#define MAX_RULE_LEN				(128)
#define MAX_STAFF					(24)
#define MAX_STAFF_LEN				(24)
#define MAX_PLAYER_FILE				(MAX_PLAYER_NAME+16)
#define MAX_ADMIN					(48)
#define MAX_PASSWORD_LEN			(129)
#define MAX_GPCI_LEN				(41)
#define MAX_HOST_LEN				(256)
#define DIRECTORY_SCRIPTFILES		"./scriptfiles/"
#define DIRECTORY_MAIN				"data/"
#define SETTINGS_FILE				DIRECTORY_MAIN"settings.ini"

new
		gMessageOfTheDay[MAX_MOTD_LEN],
		gWebsiteURL[MAX_WEBSITE_NAME],
		gRuleList[MAX_RULE][MAX_RULE_LEN],
		gStaffList[MAX_STAFF][MAX_STAFF_LEN],

bool:	gPauseMap,
bool:	gInteriorEntry,
bool:	gVehicleSurfing,
Float:	gNameTagDistance,
		gCombatLogWindow,
		gLoginFreezeTime,
		gMaxTaboutTime,
		gPingLimit,
		gTotalRules,
		gServerMaxUptime,
		gTotalStaff,
bool:	gEmailNeeded,		
		gCrashOnExit;


hook OnGameModeInit()
{
	LoadSettings();
	return 1;
}


LoadSettings()
{
	if(!fexist(SETTINGS_FILE))
	{
		err("Settings file '"SETTINGS_FILE"' not found. Creating and using default values.");

		fclose(fopen(SETTINGS_FILE, io_write));
	}

	GetSettingString("server/motd", "Please update the 'server/motd' string in "SETTINGS_FILE"", gMessageOfTheDay);
	GetSettingString("server/website", "Update website in the "SETTINGS_FILE"", gWebsiteURL);
	GetSettingInt("server/crash-on-exit", true, gCrashOnExit);

	GetSettingStringArray("server/rules", "Please update the 'server/rules' array in '"SETTINGS_FILE"'.", MAX_RULE, gRuleList, gTotalRules, MAX_RULE_LEN);
	GetSettingStringArray("server/staff", "StaffName", MAX_STAFF, gStaffList, gTotalStaff, MAX_STAFF_LEN);

	GetSettingInt("server/max-uptime", 18000, gServerMaxUptime);
	GetSettingInt("player/allow-pause-map", 0, gPauseMap);
	GetSettingInt("player/interior-entry", 0, gInteriorEntry);
	GetSettingInt("player/vehicle-surfing", 0, gVehicleSurfing);
	GetSettingFloat("player/nametag-distance", 3.0, gNameTagDistance);
	GetSettingInt("player/combat-log-window", 30, gCombatLogWindow);
	GetSettingInt("player/login-freeze-time", 8, gLoginFreezeTime);
	GetSettingInt("player/max-tab-out-time", 60, gMaxTaboutTime);
	GetSettingInt("player/ping-limit", 400, gPingLimit);
	GetSettingInt("player/email-needed", 0, gEmailNeeded);

	SetGameModeText("RRP 0.1.3");
}


stock GetSettingInt(path[], defaultvalue, &output, printsetting = true, openfile = true)
{
	if(openfile)
		file_Open(SETTINGS_FILE);

	if(!file_IsKey(path))
	{
		file_SetVal(path, defaultvalue);
		output = defaultvalue;
		file_Save(SETTINGS_FILE);

		if(printsetting)
			log("[DEFAULT] %s: %d", path, output);
	}
	else
	{
		output = file_GetVal(path);

		if(printsetting)
			log("[SETTING] %s: %d", path, output);
	}

	if(openfile)
		file_Close();
}

stock GetSettingFloat(path[], Float:defaultvalue, &Float:output, printsetting = true, openfile = true)
{
	if(openfile)
		file_Open(SETTINGS_FILE);

	if(!file_IsKey(path))
	{
		file_SetFloat(path, defaultvalue);
		output = defaultvalue;
		file_Save(SETTINGS_FILE);

		if(printsetting)
			log("[DEFAULT] %s: %f", path, output);
	}
	else
	{
		output = file_GetFloat(path);

		if(printsetting)
			log("[SETTING] %s: %f", path, output);
	}

	if(openfile)
		file_Close();
}

stock GetSettingString(path[], defaultvalue[], output[], maxsize = sizeof(output), printsetting = true, openfile = true)
{
	if(openfile)
		file_Open(SETTINGS_FILE);

	if(!file_IsKey(path))
	{
		file_SetStr(path, defaultvalue);
		output[0] = EOS;
		strcat(output, defaultvalue, maxsize);
		file_Save(SETTINGS_FILE);

		if(printsetting)
			log("[DEFAULT] %s: %s", path, output);
	}
	else
	{
		file_GetStr(path, output, maxsize);

		if(printsetting)
			log("[SETTING] %s: %s", path, output);
	}

	if(openfile)
		file_Close();
}


/*
	Arrays
*/

stock GetSettingIntArray(path[], defaultvalue, max, output[], &outputtotal, printsetting = true)
{
	file_Open(SETTINGS_FILE);

	new tmpkey[MAX_KEY_LENGTH];

	while(outputtotal < max)
	{
		format(tmpkey, sizeof(tmpkey), "%s/%d", path, outputtotal);

		if(!file_IsKey(tmpkey))
		{
			if(outputtotal == 0)
			{
				file_SetInt(tmpkey, defaultvalue);
				file_Save(SETTINGS_FILE);
				output[0] = defaultvalue;

				if(printsetting)
					log("[DEFAULT] %s: %d", tmpkey, output[0]);
			}

			break;
		}

		GetSettingInt(tmpkey, defaultvalue, output[outputtotal], printsetting, false);

		outputtotal++;
	}

	file_Close();
}

stock GetSettingFloatArray(path[], Float:defaultvalue, max, Float:output[], &outputtotal, printsetting = true)
{
	file_Open(SETTINGS_FILE);

	new tmpkey[MAX_KEY_LENGTH];

	while(outputtotal < max)
	{
		format(tmpkey, sizeof(tmpkey), "%s/%d", path, outputtotal);

		if(!file_IsKey(tmpkey))
		{
			if(outputtotal == 0)
			{
				file_SetFloat(tmpkey, defaultvalue);
				file_Save(SETTINGS_FILE);
				output[0] = defaultvalue;

				if(printsetting)
					log("[DEFAULT] %s: %f", tmpkey, output[0]);
			}

			break;
		}

		GetSettingFloat(tmpkey, defaultvalue, output[outputtotal], printsetting, false);

		outputtotal++;
	}

	file_Close();
}

stock GetSettingStringArray(path[], defaultvalue[], max, output[][], &outputtotal, outputmaxsize, printsetting = true)
{
	file_Open(SETTINGS_FILE);

	new tmpkey[MAX_KEY_LENGTH];

	while(outputtotal < max)
	{
		format(tmpkey, sizeof(tmpkey), "%s/%d", path, outputtotal);

		if(!file_IsKey(tmpkey))
		{
			if(outputtotal == 0)
			{
				file_SetStr(tmpkey, defaultvalue);
				file_Save(SETTINGS_FILE);
				output[0][0] = EOS;
				strcat(output[0], defaultvalue, outputmaxsize);

				if(printsetting)
					log("[DEFAULT] %s: %s", tmpkey, output[0]);
			}

			break;
		}

		GetSettingString(tmpkey, defaultvalue, output[outputtotal], outputmaxsize, printsetting, false);

		outputtotal++;
	}

	file_Close();
}

stock UpdateSettingInt(path[], value)
{
	file_Open(SETTINGS_FILE);
	file_SetVal(path, value);
	file_Save(SETTINGS_FILE);
	file_Close();
}

stock UpdateSettingFloat(path[], Float:value)
{
	file_Open(SETTINGS_FILE);
	file_SetFloat(path, value);
	file_Save(SETTINGS_FILE);
	file_Close();
}

stock UpdateSettingString(path[], value[])
{
	file_Open(SETTINGS_FILE);
	file_SetStr(path, value);
	file_Save(SETTINGS_FILE);
	file_Close();
}