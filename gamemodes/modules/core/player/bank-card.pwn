#include <YSI\y_hooks>

#define MAX_BANK_CARD (100)

enum b_card_e {b_c_id, cash, name}


new 
	p_bank_card[MAX_PLAYERS][MAX_BANK_CARD][b_card_e],
	p_bank_card_loaded[MAX_PLAYERS] = 0,
	p_choosed_card[MAX_PLAYERS]
;

hook OnGameModeInit()
{
	db_query(Users, "CREATE TABLE IF NOT EXISTS `bank-cards` (\
		`id` INTEGER PRIMARY KEY, \
        `username` VARCHAR(24), \
        `cardname` VARCHAR(64), \
        `cash` INT NOT NULL DEFAULT '0' )");	
}

hook OnPlayerOpenATM(playerid)
{
	LoadPlayerBankCards(playerid);
}

LoadPlayerBankCards(playerid)
{
	new p_name_inside_f[MAX_PLAYER_NAME], Query[164], DBResult:GetPlayerBankCards, Dialog_String[226];
	
	GetPlayerName(playerid, p_name_inside_f, sizeof(p_name_inside_f));

	format(Query, sizeof(Query), "SELECT * FROM `bank-cards` WHERE `username` = '%s'", DB_Escape(p_name_inside_f));

	format(Dialog_String, sizeof(Dialog_String), "\tBaratis Saxeli\tTanxa\n");

	GetPlayerBankCards = db_query(Users, Query);

	if(db_num_rows(GetPlayerBankCards))
	{

		for(new i; i<db_num_rows(GetPlayerBankCards); i++)
		{
			new card_name[64], card_cash, card_id, cards_info[64];

			db_get_field_assoc(GetPlayerBankCards, "cardname", card_name, sizeof(card_name));
			card_cash = db_get_field_assoc_int(GetPlayerBankCards, "cash");
			card_id = db_get_field_assoc_int(GetPlayerBankCards, "id");

			p_bank_card[playerid][p_bank_card_loaded[playerid]][cash] = card_cash;
			p_bank_card[playerid][p_bank_card_loaded[playerid]][b_c_id] = card_id;
			strcat(p_bank_card[playerid][p_bank_card_loaded[playerid]][name], card_name);
			p_bank_card_loaded[playerid]++;

			format(cards_info, sizeof(cards_info), "\t%s\t%d\n", card_name, card_cash);
			strcat(Dialog_String, cards_info);
			
			db_next_row(GetPlayerBankCards);
		}
	}
	else
	{
		SendClientMessage(playerid, -1, "Tqven Ar Gaqvt Sabanko Baratebi!");
	}
	db_free_result(GetPlayerBankCards);

	ShowPlayerDialog(playerid, 81, DIALOG_STYLE_TABLIST_HEADERS, "Sabanko Baratebi", Dialog_String, "Sworia", "Bugia");

	return 1;	
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 81)
	{
		if(response)
		{
			p_choosed_card[playerid] = listitem;

			ShowPlayerDialog(playerid, 82, DIALOG_STYLE_INPUT, "ATM", "Chaweret Tqventvis Sasurveli Tanxa", "Dadastureba", "Gauqmeba");

		}
	}
	if(dialogid == 82)
	{
		if(response)
		{
			if(strval(inputtext) > p_bank_card[playerid][p_choosed_card[playerid]][cash])
			{
				ShowPlayerDialog(playerid, 82, DIALOG_STYLE_INPUT, "ATM", "Baratze Ar Gaqvt Sakmarisi Tanxa!", "Dadastureba", "Gauqmeba");
			}
			else
			{
				p_bank_card[playerid][p_choosed_card[playerid]][cash] = p_bank_card[playerid][p_choosed_card[playerid]][cash]-strval(inputtext);
				SetPlayerCash(playerid, GetPlayerCash(playerid)+strval(inputtext));

				TakeMoneyFromBankCard(p_bank_card[playerid][p_choosed_card[playerid]][b_c_id], p_bank_card[playerid][p_choosed_card[playerid]][cash]);
			}
		}
	}
	return 1;
}

stock TakeMoneyFromBankCard(id, money)
{
	new Query[224];
	format(Query, sizeof(Query), "UPDATE `bank-cards` SET cash = %d WHERE `id` =  %d", money, id);
	db_query(Users, Query);
	return 1;
}


stock AddBankCard(username[], cardname[])
{
	new Query[124];
	format(Query, sizeof(Query), "INSERT INTO `bank-cards` (`username`, `cardname`) VALUES('%s', '%s')", DB_Escape(username), DB_Escape(cardname));
	db_query(Users, Query);	

	return 1;
}