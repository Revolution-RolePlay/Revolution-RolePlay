#include <YSI\y_hooks>


#define MAX_DEVBLOG (250)

enum d_blog_e {d_b_id, d_b_name, d_b_status}

new 
	admin_new_devblog_name[MAX_PLAYERS][64],
	admin_choosed_devblog_id[MAX_PLAYERS],
	d_b_loaded = 0,
	d_blog[MAX_DEVBLOG][d_blog_e]
;



hook OnGameModeInit()
{
	db_query(Users, "CREATE TABLE IF NOT EXISTS `devblog` (`id` INTEGER PRIMARY KEY,`name` VARCHAR(64), `status` INT NOT NULL DEFAULT '0')");	
}


stock ShowDevBlog(playerid)
{
	new DBResult:GetDevBlog, Dialog_String[226], d_b_extra_options_s[124];
	
	format(Dialog_String, sizeof(Dialog_String), "\tDasaxeleba\tStatusi\n%s", Dialog_String);

	GetDevBlog = db_query(Users, "SELECT * FROM `devblog`");	
	
	if(db_num_rows(GetDevBlog))
	{
		for(new i; i<db_num_rows(GetDevBlog); i++)
		{
			new devblog_name[64], devblog_status, devblog_id, devblog_info[124];

			db_get_field_assoc(GetDevBlog, "name", devblog_name, sizeof(devblog_name));
			devblog_status = db_get_field_assoc_int(GetDevBlog, "status");
			devblog_id = db_get_field_assoc_int(GetDevBlog, "id");

			d_blog[d_b_loaded][d_b_id] = devblog_id;
			strcat(d_blog[d_b_loaded][d_b_name], devblog_name);
			d_blog[d_b_loaded][d_b_status] = devblog_status;
			d_b_loaded++;

			format(devblog_info, sizeof(devblog_info), "\t%s\t%d#\n", devblog_name, devblog_status);
			strcat(Dialog_String, devblog_info);

			db_next_row(GetDevBlog);
		}
	}
	else
	{
		ChatMsg(playerid, -1, "[ERROR] Bazashi Ar Moidzebna Informacia. Mimartet Administracias!");
	}
	db_free_result(GetDevBlog);

	format(d_b_extra_options_s, sizeof(d_b_extra_options_s), "\t%sDamateba\n\t%sShecvla\n\t%sWashla\n", SCOLOR<RED>, SCOLOR<RED>, SCOLOR<RED>);
	strcat(Dialog_String, d_b_extra_options_s);

	if(GetPlayerAdminLevel(playerid) == 7)
		ShowPlayerDialog(playerid, 75, DIALOG_STYLE_TABLIST_HEADERS, "Development Blog", Dialog_String, "Damateba", "Daxurva");
	else
		ShowPlayerDialog(playerid, 75, DIALOG_STYLE_TABLIST_HEADERS, "Development Blog", Dialog_String, "Daxurva", "");
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 75)
	{
		if(response)
		{
			if(GetPlayerAdminLevel(playerid) == 7)
			{
				if(listitem >= 0)
				{
					//TODO ADD DEVBLOG ADD/ DELETE/ EDIT FUNCTIONS
				}
				else
				{
					ShowPlayerDialog(playerid, 76, DIALOG_STYLE_INPUT, "Chaweret Ganaxlebis Saxeli", "Chaweret Ganaxlebis Mokle Dasaxeleba", "Gagrdzeleba", "Gauqmeba");
				}
			}
		}
	}
	if(dialogid == 76)
	{
		if(response)
		{
			strcat(admin_new_devblog_name[playerid], inputtext);
			ShowPlayerDialog(playerid, 77, DIALOG_STYLE_INPUT, "Chaweret Ganaxlebis Statusi", "Chaweret Ganaxlebis Procentuli Machvenebeli, Romelic Miaxvedrebs Motamasheebs Ra Donemdea Ganaxleba Misuli", "Damateba", "Gauqmeba");
		}
	}
	if(dialogid == 77)
	{
		if(response)
		{
			AddDevBlog(admin_new_devblog_name[playerid], strval(inputtext));
			ShowDevBlog(playerid);
		}
	}
	return 1;
}

stock AddDevBlog(devb_name[], devb_status)
{
	new Query[124];
	format(Query, sizeof(Query), "INSERT INTO `devblog` (`name`, `status`) VALUES('%s', %d)", DB_Escape(devb_name), devb_status);
	db_query(Users, Query);	
}

CMD:devblog(playerid, params[])
{
	ShowDevBlog(playerid);
	return 1;
}

