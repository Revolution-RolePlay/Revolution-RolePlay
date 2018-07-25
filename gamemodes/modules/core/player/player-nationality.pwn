#include <YSI\y_hooks>

#define MAX_NATIONALITY_NAME (24)
#define MAX_NATIONALITY_SKINS (21)

enum 
{
	NATIONALITY_AMERICAN,
	NATIONALITY_AFRO,
	NATIONALITY_CAUCASIAN
}

enum @@NationalitySkinInfo 
{
	Nat@@skinid,
	Nat@@nationality,
	Nat@@gender
}

static 
		National_Skin[MAX_NATIONALITY_SKINS][@@NationalitySkinInfo],
		National_Skin_Added = 0;

static
		Nationality_Name[3][24] = {
			"Amerikeli",
			"Afrikeli",
			"Evropeli"
		},
		Player_Nationality[MAX_PLAYERS];

static Nat_Skin_Ids_In_Dialog[MAX_PLAYERS][4], Nat_Skin_Ids_In_Dialog_Added[MAX_PLAYERS] = 0;


hook OnGameModeInit()
{
	//SETUP DATABASE
	db_query(Users, "CREATE TABLE IF NOT EXISTS `nationality` (\
        `username` VARCHAR(24) PRIMARY KEY, \
        `nationality` INT NOT NULL DEFAULT '1')");

	/******************** MALE ***************************/

	//American
	AddNationalSkin(73, NATIONALITY_AMERICAN, GENDER_MALE);
	AddNationalSkin(29, NATIONALITY_AMERICAN, GENDER_MALE);
	AddNationalSkin(35, NATIONALITY_AMERICAN, GENDER_MALE);
	AddNationalSkin(44, NATIONALITY_AMERICAN, GENDER_MALE);
	//Afro
	AddNationalSkin(24, NATIONALITY_AFRO, GENDER_MALE);
	AddNationalSkin(21, NATIONALITY_AFRO, GENDER_MALE);
	AddNationalSkin(22, NATIONALITY_AFRO, GENDER_MALE);
	AddNationalSkin(25, NATIONALITY_AFRO, GENDER_MALE);
	//Caucasian
	AddNationalSkin(37, NATIONALITY_CAUCASIAN, GENDER_MALE);
	AddNationalSkin(23, NATIONALITY_CAUCASIAN, GENDER_MALE);
	AddNationalSkin(96, NATIONALITY_CAUCASIAN, GENDER_MALE);
	AddNationalSkin(101, NATIONALITY_CAUCASIAN, GENDER_MALE);

	/******************** MALE ***************************/

	//American
	AddNationalSkin(13, NATIONALITY_AMERICAN, GENDER_FEMALE);
	AddNationalSkin(233, NATIONALITY_AMERICAN, GENDER_FEMALE);
	AddNationalSkin(69, NATIONALITY_AMERICAN, GENDER_FEMALE);
	//Afro
	AddNationalSkin(0, NATIONALITY_AFRO, GENDER_FEMALE);
	AddNationalSkin(9, NATIONALITY_AFRO, GENDER_FEMALE);
	AddNationalSkin(41, NATIONALITY_AFRO, GENDER_FEMALE);
	//Caucasian
	AddNationalSkin(93, NATIONALITY_CAUCASIAN, GENDER_FEMALE);
	AddNationalSkin(91, NATIONALITY_CAUCASIAN, GENDER_FEMALE);
	AddNationalSkin(90, NATIONALITY_CAUCASIAN, GENDER_FEMALE);
}

hook OnPlayerLogin(playerid)
{
	new Name[MAX_PLAYER_NAME], DBResult:GetNationality, Query[164];
	GetPlayerName(playerid, Name, sizeof(Name));
	format(Query, sizeof(Query), "SELECT * FROM `nationality` WHERE `username` = '%s'", DB_Escape(Name));
	GetNationality = db_query(Users, Query);
	if(db_num_rows(GetNationality))
	{
		SetPlayerNationality(playerid, db_get_field_assoc_int(GetNationality, "nationality"));
	}
	db_free_result(GetNationality);	
	return 1;
}


stock AddNationalSkin(skinid, nationality, gender)
{
	National_Skin[National_Skin_Added][Nat@@skinid] = skinid;
	National_Skin[National_Skin_Added][Nat@@nationality] = nationality;
	National_Skin[National_Skin_Added][Nat@@gender] = gender;
	return National_Skin_Added++;
}

stock ShowAmericanMaleSkins(playerid)
{
	static string[MAX_NATIONALITY_SKINS * 16], formattedone[16]; 
    
    for (new i; i < National_Skin_Added; i++) 
    {
    	if(National_Skin[i][Nat@@nationality] == NATIONALITY_AMERICAN && National_Skin[i][Nat@@gender] == GENDER_MALE) 
    	{
           	format(formattedone, sizeof formattedone, "%i\tID: %i\n", National_Skin[i][Nat@@skinid], National_Skin[i][Nat@@skinid]); 
           	strcat(string, formattedone);
           	Nat_Skin_Ids_In_Dialog[playerid][Nat_Skin_Ids_In_Dialog_Added[playerid]] = National_Skin[i][Nat@@skinid];
           	Nat_Skin_Ids_In_Dialog_Added[playerid]++;
    	}
    }
    ShowPlayerDialog(playerid, 991, DIALOG_STYLE_PREVIEW_MODEL, "Airchiet Tqveni Skini", string, "Archeva", "Gatishva");
    stringclear(string);
    stringclear(formattedone);
}

stock ShowAfroMaleSkins(playerid)
{
	static string[MAX_NATIONALITY_SKINS * 16], formattedone[16]; 
    
    for (new i; i < National_Skin_Added; i++) 
    {
    	if(National_Skin[i][Nat@@nationality] == NATIONALITY_AFRO && National_Skin[i][Nat@@gender] == GENDER_MALE) 
    	{
           	format(formattedone, sizeof formattedone, "%i\tID: %i\n", National_Skin[i][Nat@@skinid], National_Skin[i][Nat@@skinid]); 
           	strcat(string, formattedone);
    		Nat_Skin_Ids_In_Dialog[playerid][Nat_Skin_Ids_In_Dialog_Added[playerid]] = National_Skin[i][Nat@@skinid];
           	Nat_Skin_Ids_In_Dialog_Added[playerid]++;
    	}
    }
    ShowPlayerDialog(playerid, 991, DIALOG_STYLE_PREVIEW_MODEL, "Airchiet Tqveni Skini", string, "Archeva", "Gatishva");
    stringclear(string);
    stringclear(formattedone);
}

stock ShowCaucasianMaleSkins(playerid)
{
	static string[MAX_NATIONALITY_SKINS * 16], formattedone[16]; 
    
    for (new i; i < National_Skin_Added; i++) 
    {
    	if(National_Skin[i][Nat@@nationality] == NATIONALITY_CAUCASIAN && National_Skin[i][Nat@@gender] == GENDER_MALE) 
    	{
           	format(formattedone, sizeof formattedone, "%i\tID: %i\n", National_Skin[i][Nat@@skinid], National_Skin[i][Nat@@skinid]); 
           	strcat(string, formattedone);
           	Nat_Skin_Ids_In_Dialog[playerid][Nat_Skin_Ids_In_Dialog_Added[playerid]] = National_Skin[i][Nat@@skinid];
           	Nat_Skin_Ids_In_Dialog_Added[playerid]++;           	
    	}
    }
    ShowPlayerDialog(playerid, 991, DIALOG_STYLE_PREVIEW_MODEL, "Airchiet Tqveni Skini", string, "Archeva", "Gatishva");
    stringclear(string);
    stringclear(formattedone);
}

stock ShowAmericanFemaleSkins(playerid)
{
	static string[MAX_NATIONALITY_SKINS * 16], formattedone[16]; 
    
    for (new i; i < National_Skin_Added; i++) 
    {
    	if(National_Skin[i][Nat@@nationality] == NATIONALITY_AMERICAN && National_Skin[i][Nat@@gender] == GENDER_FEMALE) 
    	{
           	format(formattedone, sizeof formattedone, "%i\tID: %i\n", National_Skin[i][Nat@@skinid], National_Skin[i][Nat@@skinid]); 
           	strcat(string, formattedone);
           	Nat_Skin_Ids_In_Dialog[playerid][Nat_Skin_Ids_In_Dialog_Added[playerid]] = National_Skin[i][Nat@@skinid];
           	Nat_Skin_Ids_In_Dialog_Added[playerid]++;           	
    	}
    }
    ShowPlayerDialog(playerid, 991, DIALOG_STYLE_PREVIEW_MODEL, "Airchiet Tqveni Skini", string, "Archeva", "Gatishva");
    stringclear(string);
    stringclear(formattedone);
}

stock ShowAfroFemaleSkins(playerid)
{
	static string[MAX_NATIONALITY_SKINS * 16], formattedone[16]; 
    
    for (new i; i < National_Skin_Added; i++) 
    {
    	if(National_Skin[i][Nat@@nationality] == NATIONALITY_AFRO && National_Skin[i][Nat@@gender] == GENDER_FEMALE) 
    	{
           	format(formattedone, sizeof formattedone, "%i\tID: %i\n", National_Skin[i][Nat@@skinid], National_Skin[i][Nat@@skinid]); 
           	strcat(string, formattedone);
           	Nat_Skin_Ids_In_Dialog[playerid][Nat_Skin_Ids_In_Dialog_Added[playerid]] = National_Skin[i][Nat@@skinid];
           	Nat_Skin_Ids_In_Dialog_Added[playerid]++;           	
    	}
    }
    ShowPlayerDialog(playerid, 991, DIALOG_STYLE_PREVIEW_MODEL, "Airchiet Tqveni Skini", string, "Archeva", "Gatishva");
    stringclear(string);
    stringclear(formattedone);
}

stock ShowCaucasianFemaleSkins(playerid)
{
	static string[MAX_NATIONALITY_SKINS * 16], formattedone[16]; 
    
    for (new i; i < National_Skin_Added; i++) 
    {
    	if(National_Skin[i][Nat@@nationality] == NATIONALITY_CAUCASIAN && National_Skin[i][Nat@@gender] == GENDER_FEMALE) 
    	{
           	format(formattedone, sizeof formattedone, "%i\tID: %i\n", National_Skin[i][Nat@@skinid], National_Skin[i][Nat@@skinid]); 
           	strcat(string, formattedone);
           	Nat_Skin_Ids_In_Dialog[playerid][Nat_Skin_Ids_In_Dialog_Added[playerid]] = National_Skin[i][Nat@@skinid];
           	Nat_Skin_Ids_In_Dialog_Added[playerid]++;           	
    	}
    }
    ShowPlayerDialog(playerid, 991, DIALOG_STYLE_PREVIEW_MODEL, "Airchiet Tqveni Skini", string, "Archeva", "Gatishva");
    stringclear(string);
    stringclear(formattedone);
}

hook Player_RegisterProcess4(playerid)
{
	ShowPlayerDialog(playerid, 990, DIALOG_STYLE_LIST, "Airchiet Tqveni Erovneba", "Amerikeli\nAfrikeli\nEvropeli", "Archeva", "Gasvla");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 990)
	{
		if(response)
		{
			new NationalityPlayer[MAX_PLAYERS], PlayerGender[MAX_PLAYERS], Name[MAX_PLAYER_NAME], Query[124];

			GetPlayerName(playerid, Name, sizeof(Name));
	
			SetPlayerNationality(playerid, listitem);
			GetPlayerNationality(playerid, NationalityPlayer[playerid]);
			GetPlayerGender(playerid, PlayerGender[playerid]);
	
			format(Query, sizeof(Query), "INSERT INTO `nationality` (`username`, `nationality`) VALUES('%s', %d)", DB_Escape(Name), NationalityPlayer[playerid]);
			db_query(Users, Query);	

			ChatMsg(playerid, COLOR<ORANGE>, "Tqveni Erovnebaa: %s%s", SCOLOR<GREEN>, Nationality_Name[NationalityPlayer[playerid]]);
	
			if(NationalityPlayer[playerid] == NATIONALITY_AMERICAN && PlayerGender[playerid] == GENDER_MALE)
			{
				ShowAmericanMaleSkins(playerid);
			}
			if(NationalityPlayer[playerid] == NATIONALITY_AFRO && PlayerGender[playerid] == GENDER_MALE)
			{
				ShowAfroMaleSkins(playerid);
			}
			if(NationalityPlayer[playerid] == NATIONALITY_CAUCASIAN && PlayerGender[playerid] == GENDER_MALE)
			{
				ShowCaucasianMaleSkins(playerid);
			}
			if(NationalityPlayer[playerid] == NATIONALITY_AMERICAN && PlayerGender[playerid] == GENDER_FEMALE)
			{
				ShowAmericanFemaleSkins(playerid);
			}
			if(NationalityPlayer[playerid] == NATIONALITY_AFRO && PlayerGender[playerid] == GENDER_FEMALE)
			{
				ShowAfroFemaleSkins(playerid);
			}
			if(NationalityPlayer[playerid] == NATIONALITY_CAUCASIAN && PlayerGender[playerid] == GENDER_FEMALE)
			{
				ShowCaucasianFemaleSkins(playerid);
			}
		} 
		else Kick(playerid);

	}
	if(dialogid == 991)
	{
		if(response)
		{
			SetPlayerSkinEx(playerid, Nat_Skin_Ids_In_Dialog[playerid][listitem]);
			if(funcidx("OnPlayerRegister") != -1) CallLocalFunction("OnPlayerRegister","d",playerid);	
		}
		else
		{
			Kick(playerid);
		}
	}
	return 1;
}

GetPlayerNationality(playerid, &nationality)
{
	nationality = Player_Nationality[playerid];
}

SetPlayerNationality(playerid, nationality)
{
	Player_Nationality[playerid] = nationality;
}