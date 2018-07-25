/*
	Door And Buttons Framework
	Last Update 8/28/2017
	Created By Amagida (Codeah)
*/


#include <YSI\y_iterate>
#include <YSI\y_timers>
#include <YSI\y_hooks>


// Maximum amount of buttons that can be created.
#if !defined btn_MAX
	#define btn_MAX (8192)
#endif

// Maximum string length for labels and action-text strings.
#if !defined btn_MAX_TEXT
	#define btn_MAX_TEXT (128)
#endif

// Default maximum stream range for button label text.
#if !defined btn_DEFAULT_STREAMDIST
	#define btn_DEFAULT_STREAMDIST (4.0)
#endif

// Maximum amount of buttons to record the player being near to.
#if !defined btn_MAX_INRANGE
	#define btn_MAX_INRANGE (8)
#endif

// A value to identify streamer object EXTRA_ID data array type.
#if !defined btn_STREAMER_AREA_IDENTIFIER
	#define btn_STREAMER_AREA_IDENTIFIER (100)
#endif

// Time in milliseconds to freeze a player upon using a linked teleport button.
#if !defined btn_TELEPORT_FREEZE_TIME
	#define btn_TELEPORT_FREEZE_TIME (1000)
#endif

// Validity check constant
#define INVALID_BUTTON_ID (-1)


DEFINE_HOOK_REPLACEMENT(Button , btn);


// Functions
forward Float:btn_Distance(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2);

forward Float:btn_absoluteangle(Float:angle);

forward Float:btn_GetAngleToPoint(Float:fPointX, Float:fPointY, Float:fDestX, Float:fDestY);

stock Float:btn_Distance(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
	return floatsqroot((((x1-x2)*(x1-x2))+((y1-y2)*(y1-y2))+((z1-z2)*(z1-z2))));

stock Float:btn_GetAngleToPoint(Float:fPointX, Float:fPointY, Float:fDestX, Float:fDestY)
	return btn_absoluteangle(-(90-(atan2((fDestY - fPointY), (fDestX - fPointX)))));	

stock Float:btn_absoluteangle(Float:angle)
{
	while(angle < 0.0)angle += 360.0;
	while(angle > 360.0)angle -= 360.0;
	return angle;
}


forward CreateButton(Float:x, Float:y, Float:z, text[], world = 0, interior = 0, Float:areasize = 1.0, label = 0, labeltext[] = "", labelcolour = 0xFFFF00FF, Float:streamdist = btn_DEFAULT_STREAMDIST, testlos = true);

forward DestroyButton(buttonid);

forward LinkTP(buttonid1, buttonid2);

forward UnLinkTP(buttonid1, buttonid2);

forward IsValidButton(buttonid);

forward GetButtonArea(buttonid);

forward SetButtonArea(buttonid, areaid);

forward SetButtonLabel(buttonid, text[], colour = 0xFFFF00FF, Float:range = btn_DEFAULT_STREAMDIST, testlos = true);

forward DestroyButtonLabel(buttonid);

forward GetButtonPos(buttonid, &Float:x, &Float:y, &Float:z);

forward SetButtonPos(buttonid, Float:x, Float:y, Float:z);

forward Float:GetButtonSize(buttonid);

forward SetButtonSize(buttonid, Float:size);

forward GetButtonWorld(buttonid);

forward SetButtonWorld(buttonid, world);

forward GetButtonInterior(buttonid);

forward SetButtonInterior(buttonid, interior);

forward GetButtonLinkedID(buttonid);

forward GetButtonText(buttonid, text[]);

forward SetButtonText(buttonid, text[]);

forward SetButtonExtraData(buttonid, data);

forward GetButtonExtraData(buttonid);

forward GetPlayerPressingButton(playerid);

forward GetPlayerButtonID(playerid);

forward GetPlayerButtonList(playerid, list[], &size, bool:validate = false);

forward Float:GetPlayerAngleToButton(playerid, buttonid);

forward Float:GetButtonAngleToPlayer(playerid, buttonid);


forward OnButtonPress(playerid, buttonid);

forward OnButtonRelease(playerid, buttonid);

forward OnPlayerEnterButtonArea(playerid, buttonid);

forward OnPlayerLeaveButtonArea(playerid, buttonid);


enum E_btn_DATA
{
			btn_area,
Text3D:		btn_label,
Float:		btn_posX,
Float:		btn_posY,
Float:		btn_posZ,
Float:		btn_size,
			btn_world,
			btn_interior,
			btn_link,
			btn_text[btn_MAX_TEXT],

			btn_exData
}

enum e_button_range_data
{
			btn_buttonId,
Float:		btn_distance
}


new
			btn_Data[btn_MAX][E_btn_DATA],
   Iterator:btn_Index<btn_MAX>
		;

static
			btn_Near[MAX_PLAYERS][btn_MAX_INRANGE],
   Iterator:btn_NearIndex[MAX_PLAYERS]<btn_MAX_INRANGE>,
			btn_Pressing[MAX_PLAYERS];

hook OnScriptInit()
{

	Iter_Init(btn_NearIndex);

	for(new i; i < MAX_PLAYERS; i++)
	{
		btn_Pressing[i] = INVALID_BUTTON_ID;
	}

}

hook OnPlayerConnect(playerid)
{
	Iter_Clear(btn_NearIndex[playerid]);
	btn_Pressing[playerid] = INVALID_BUTTON_ID;
}


stock CreateButton(Float:x, Float:y, Float:z, text[], world = 0, interior = 0, Float:areasize = 1.0, label = 0, labeltext[] = "", labelcolour = 0xFFFF00FF, Float:streamdist = btn_DEFAULT_STREAMDIST, testlos = true)
{
	new id = Iter_Free(btn_Index);

	if(id == -1)
	{
		print("ERROR: btn_MAX reached, please increase this constant!");
		return INVALID_BUTTON_ID;
	}

	btn_Data[id][btn_area]				= CreateDynamicSphere(x, y, z, areasize, world, interior);

	strcpy(btn_Data[id][btn_text], text, btn_MAX_TEXT);
	btn_Data[id][btn_posX]				= x;
	btn_Data[id][btn_posY]				= y;
	btn_Data[id][btn_posZ]				= z;
	btn_Data[id][btn_size]				= areasize;
	btn_Data[id][btn_world]				= world;
	btn_Data[id][btn_interior]			= interior;
	btn_Data[id][btn_link]				= INVALID_BUTTON_ID;

	if(label)
		btn_Data[id][btn_label] = CreateDynamic3DTextLabel(labeltext, labelcolour, x, y, z, streamdist, .testlos = testlos, .worldid = world, .interiorid = interior, .streamdistance = streamdist);

	else
		btn_Data[id][btn_label] = Text3D:INVALID_3DTEXT_ID;

	new data[2];

	data[0] = btn_STREAMER_AREA_IDENTIFIER;
	data[1] = id;

	Streamer_SetArrayData(STREAMER_TYPE_AREA, btn_Data[id][btn_area], E_STREAMER_EXTRA_ID, data, 2);

	Iter_Add(btn_Index, id);

	#if defined DEBUG_LABELS_BUTTON
		btn_DebugLabelID[id] = CreateDebugLabel(btn_DebugLabelType, id, x, y, z);
		UpdateButtonDebugLabel(id);
	#endif

	return id;
}

stock DestroyButton(buttonid)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return 0;
	foreach(new i : Player)
	{
		if(IsPlayerInDynamicArea(i, btn_Data[buttonid][btn_area]))
			process_LeaveDynamicArea(i, btn_Data[buttonid][btn_area]);
	}

	DestroyDynamicArea(btn_Data[buttonid][btn_area]);

	if(IsValidDynamic3DTextLabel(btn_Data[buttonid][btn_label]))
		DestroyDynamic3DTextLabel(btn_Data[buttonid][btn_label]);

	btn_Data[buttonid][btn_area]		= -1;
	btn_Data[buttonid][btn_label]		= Text3D:INVALID_3DTEXT_ID;

	btn_Data[buttonid][btn_posX]		= 0.0;
	btn_Data[buttonid][btn_posY]		= 0.0;
	btn_Data[buttonid][btn_posZ]		= 0.0;
	btn_Data[buttonid][btn_size]		= 0.0;
	btn_Data[buttonid][btn_world]		= 0;
	btn_Data[buttonid][btn_interior]	= 0;
	btn_Data[buttonid][btn_link]		= INVALID_BUTTON_ID;
	btn_Data[buttonid][btn_text][0]		= EOS;
	Iter_Remove(btn_Index, buttonid);

	return 1;
}

stock LinkTP(buttonid1, buttonid2)
{
	if(!Iter_Contains(btn_Index, buttonid1) || !Iter_Contains(btn_Index, buttonid2))
		return 0;

	btn_Data[buttonid1][btn_link] = buttonid2;
	btn_Data[buttonid2][btn_link] = buttonid1;

	return 1;
}

stock UnLinkTP(buttonid1, buttonid2)
{
	if(!Iter_Contains(btn_Index, buttonid1) || !Iter_Contains(btn_Index, buttonid2))
		return 0;

	if(btn_Data[buttonid1][btn_link] == INVALID_BUTTON_ID || btn_Data[buttonid1][btn_link] == INVALID_BUTTON_ID)
		return -1;

	if(btn_Data[buttonid1][btn_link] != buttonid2 || btn_Data[buttonid2][btn_link] != buttonid1)
		return -2;

	btn_Data[buttonid1][btn_link] = INVALID_BUTTON_ID;
	btn_Data[buttonid2][btn_link] = INVALID_BUTTON_ID;

	return 1;
}

stock IsValidButton(buttonid)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return 0;

	return 1;
}
// btn_area
stock GetButtonArea(buttonid)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return -1;

	return btn_Data[buttonid][btn_area];
}
stock SetButtonArea(buttonid, areaid)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return 0;

	btn_Data[buttonid][btn_area] = areaid;

	return 1;
}


// btn_label
stock SetButtonLabel(buttonid, text[], colour = 0xFFFF00FF, Float:range = btn_DEFAULT_STREAMDIST, testlos = true)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return 0;

	if(IsValidDynamic3DTextLabel(btn_Data[buttonid][btn_label]))
	{
		UpdateDynamic3DTextLabelText(btn_Data[buttonid][btn_label], colour, text);
		return 2;
	}

	btn_Data[buttonid][btn_label] = CreateDynamic3DTextLabel(text, colour,
		btn_Data[buttonid][btn_posX],
		btn_Data[buttonid][btn_posY],
		btn_Data[buttonid][btn_posZ],
		range, _, _, testlos,
		btn_Data[buttonid][btn_world], btn_Data[buttonid][btn_interior], _, range);

	return 1;
}
stock DestroyButtonLabel(buttonid)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return 0;

	if(!IsValidDynamic3DTextLabel(btn_Data[buttonid][btn_label]))
		return -1;

	DestroyDynamic3DTextLabel(btn_Data[buttonid][btn_label]);
	btn_Data[buttonid][btn_label] = Text3D:INVALID_3DTEXT_ID;

	return 1;
}

// btn_posX
// btn_posY
// btn_posZ
stock GetButtonPos(buttonid, &Float:x, &Float:y, &Float:z)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return 0;

	x = btn_Data[buttonid][btn_posX];
	y = btn_Data[buttonid][btn_posY];
	z = btn_Data[buttonid][btn_posZ];

	return 1;
}
stock SetButtonPos(buttonid, Float:x, Float:y, Float:z)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return 0;

	Streamer_SetFloatData(STREAMER_TYPE_AREA, btn_Data[buttonid][btn_area], E_STREAMER_X, x);
	Streamer_SetFloatData(STREAMER_TYPE_AREA, btn_Data[buttonid][btn_area], E_STREAMER_Y, y);
	Streamer_SetFloatData(STREAMER_TYPE_AREA, btn_Data[buttonid][btn_area], E_STREAMER_Z, z);

	if(IsValidDynamic3DTextLabel(btn_Data[buttonid][btn_label]))
	{
		Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, btn_Data[buttonid][btn_label], E_STREAMER_X, x);
		Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, btn_Data[buttonid][btn_label], E_STREAMER_Y, y);
		Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, btn_Data[buttonid][btn_label], E_STREAMER_Z, z);
	}

	btn_Data[buttonid][btn_posX] = x;
	btn_Data[buttonid][btn_posY] = y;
	btn_Data[buttonid][btn_posZ] = z;

	return 1;
}

// btn_size
stock Float:GetButtonSize(buttonid)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return 0.0;

	return btn_Data[buttonid][btn_size];
}
stock SetButtonSize(buttonid, Float:size)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return 0;

	Streamer_SetFloatData(STREAMER_TYPE_AREA, btn_Data[buttonid][btn_area], E_STREAMER_SIZE, size);
	btn_Data[buttonid][btn_size] = size;

	return 1;
}

// btn_world
stock GetButtonWorld(buttonid)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return -1;

	return btn_Data[buttonid][btn_world];
}
stock SetButtonWorld(buttonid, world)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return 0;

	if(btn_Data[buttonid][btn_world] != world)
	{
		Streamer_SetIntData(STREAMER_TYPE_AREA, btn_Data[buttonid][btn_area], E_STREAMER_WORLD_ID, world);

		if(IsValidDynamic3DTextLabel(btn_Data[buttonid][btn_label]))
		{
			Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, btn_Data[buttonid][btn_label], E_STREAMER_WORLD_ID, world);
		}

		btn_Data[buttonid][btn_world] = world;
	}

	return 1;
}

// btn_interior
stock GetButtonInterior(buttonid)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return -1;

	return btn_Data[buttonid][btn_interior];
}
stock SetButtonInterior(buttonid, interior)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return 0;

	if(btn_Data[buttonid][btn_interior] != interior)
	{
		Streamer_SetIntData(STREAMER_TYPE_AREA, btn_Data[buttonid][btn_area], E_STREAMER_INTERIOR_ID, interior);

		if(IsValidDynamic3DTextLabel(btn_Data[buttonid][btn_label]))
		{
			Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, btn_Data[buttonid][btn_label], E_STREAMER_INTERIOR_ID, interior);
		}

		btn_Data[buttonid][btn_interior] = interior;
	}

	return 1;
}

// btn_link
stock GetButtonLinkedID(buttonid)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return INVALID_BUTTON_ID;

	return btn_Data[buttonid][btn_link];
}

// btn_text
stock GetButtonText(buttonid, text[])
{
	if(!Iter_Contains(btn_Index, buttonid))
		return 0;

	text[0] = EOS;
	strcat(text, btn_Data[buttonid][btn_text], btn_MAX_TEXT);

	return 1;
}
stock SetButtonText(buttonid, text[])
{
	if(!Iter_Contains(btn_Index, buttonid))
		return 0;

	btn_Data[buttonid][btn_text][0] = EOS;
	strcat(btn_Data[buttonid][btn_text], text, btn_MAX_TEXT);

	return 1;
}

// btn_exData
stock SetButtonExtraData(buttonid, data)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return 0;

	btn_Data[buttonid][btn_exData] = data;

	#if defined DEBUG_LABELS_BUTTON
		UpdateButtonDebugLabel(buttonid);
	#endif

	return 1;
}
stock GetButtonExtraData(buttonid)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return 0;

	return btn_Data[buttonid][btn_exData];
}

// btn_Pressing
stock GetPlayerPressingButton(playerid)
{
	if(!(0 <= playerid < MAX_PLAYERS))
		return -1;

	return btn_Pressing[playerid];
}

stock GetPlayerButtonID(playerid)
{

	if(!IsPlayerConnected(playerid))
		return INVALID_BUTTON_ID;

	if(Iter_Count(btn_NearIndex[playerid]) == 0)
		return INVALID_BUTTON_ID;

	new
		Float:x,
		Float:y,
		Float:z,
		curid,
		closestid,
		Float:curdistance,
		Float:closetsdistance = 99999.9;

	GetPlayerPos(playerid, x, y, z);

	foreach(new i : btn_NearIndex[playerid])
	{
		curid = btn_Near[playerid][i];

		curdistance = btn_Distance(x, y, z, btn_Data[curid][btn_posX], btn_Data[curid][btn_posY], btn_Data[curid][btn_posZ]);

		if(curdistance < closetsdistance)
		{
			closetsdistance = curdistance;
			closestid = curid;
		}
	}

	return closestid;
}

stock GetPlayerButtonList(playerid, list[], &size, bool:validate = false)
{
	if(!IsPlayerConnected(playerid))
		return 0;

	if(Iter_Count(btn_NearIndex[playerid]) == 0)
		return 0;

	// Validate whether or not the player is actually inside the areas.
	// Caused by a bug that hasn't been found yet, this is the quick workaround.
	if(validate)
	{
		foreach(new i : btn_NearIndex[playerid])
		{
			if(!IsPlayerInDynamicArea(playerid, btn_Data[btn_Near[playerid][i]][btn_area]))
			{
				printf("ERROR: Player %d incorrectly flagged as inside button %d area, removing.", playerid, btn_Near[playerid][i]);
				Iter_SafeRemove(btn_NearIndex[playerid], i, i);
				continue;
			}

			list[size++] = btn_Near[playerid][i];
		}
	}
	else
	{
		foreach(new i : btn_NearIndex[playerid])
			list[size++] = btn_Near[playerid][i];
	}
	return 1;
}

stock Float:GetPlayerAngleToButton(playerid, buttonid)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return 0.0;

	if(!IsPlayerConnected(playerid))
		return 0.0;

	new
		Float:x,
		Float:y,
		Float:z;

	GetPlayerPos(playerid, x, y, z);

	return btn_GetAngleToPoint(x, y, btn_Data[buttonid][btn_posX], btn_Data[buttonid][btn_posY]);
}

stock Float:GetButtonAngleToPlayer(playerid, buttonid)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return 0.0;

	if(!IsPlayerConnected(playerid))
		return 0.0;

	new
		Float:x,
		Float:y,
		Float:z;

	GetPlayerPos(playerid, x, y, z);

	return btn_GetAngleToPoint(btn_Data[buttonid][btn_posX], btn_Data[buttonid][btn_posY], x, y);
}


/*==============================================================================

	Internal Functions and Hooks

==============================================================================*/


hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & 16)
	{
		if(!IsPlayerInAnyVehicle(playerid) && Iter_Count(btn_NearIndex[playerid]) > 0)
		{
			if(!IsPlayerInAnyDynamicArea(playerid))
			{
				printf("[WARNING] Player %d is not in areas but list isn't empty. Purging list.", playerid);
				Iter_Clear(btn_NearIndex[playerid]);
			}

			new
				id,
				Float:x,
				Float:y,
				Float:z,
				Float:distance,
				list[btn_MAX_INRANGE][e_button_range_data],
				index;

			GetPlayerPos(playerid, x, y, z);

			foreach(new i : btn_NearIndex[playerid])
			{
				if(index >= btn_MAX_INRANGE - 1)
					break;

				id = btn_Near[playerid][i];

				distance = btn_Distance(x, y, z, btn_Data[id][btn_posX], btn_Data[id][btn_posY], btn_Data[id][btn_posZ]);

				if(distance > btn_Data[id][btn_size])
					continue;

				if(!(btn_Data[id][btn_posZ] - btn_Data[id][btn_size] <= z <= btn_Data[id][btn_posZ] + btn_Data[id][btn_size]))
					continue;


				list[index][btn_buttonId] = id;
				list[index][btn_distance] = distance;

				index++;
			}

			_btn_SortButtons(list, 0, index);

			for(new i = index - 1; i >= 0; i--)
			{
				if(Internal_OnButtonPress(playerid, list[i][btn_buttonId]))
					break;
			}
		}

		if(oldkeys & 16)
		{
			if(btn_Pressing[playerid] != INVALID_BUTTON_ID)
			{
				CallLocalFunction("OnButtonRelease", "dd", playerid, btn_Pressing[playerid]);
				btn_Pressing[playerid] = INVALID_BUTTON_ID;
			}
		}
	}
	return 1;
}

_btn_SortButtons(array[][e_button_range_data], left, right)
{
	new
		tmp_left = left,
		tmp_right = right,
		Float:pivot = array[(left + right) / 2][btn_distance],
		buttonid,
		Float:distance;

	while(tmp_left <= tmp_right)
	{
		while(array[tmp_left][btn_distance] > pivot)
			tmp_left++;

		while(array[tmp_right][btn_distance] < pivot)
			tmp_right--;

		if(tmp_left <= tmp_right)
		{
			buttonid = array[tmp_left][btn_buttonId];
			array[tmp_left][btn_buttonId] = array[tmp_right][btn_buttonId];
			array[tmp_right][btn_buttonId] = buttonid;

			distance = array[tmp_left][btn_distance];
			array[tmp_left][btn_distance] = array[tmp_right][btn_distance];
			array[tmp_right][btn_distance] = distance;

			tmp_left++;
			tmp_right--;
		}
	}

	if(left < tmp_right)
		_btn_SortButtons(array, left, tmp_right);

	if(tmp_left < right)
		_btn_SortButtons(array, tmp_left, right);
}

Internal_OnButtonPress(playerid, buttonid)
{
	if(!Iter_Contains(btn_Index, buttonid))
		return 0;

	new id = btn_Data[buttonid][btn_link];

	if(Iter_Contains(btn_Index, id))
	{
		if(CallLocalFunction("OnButtonPress", "dd", playerid, buttonid))
			return 1;

		TogglePlayerControllable(playerid, false);
		defer btn_Unfreeze(playerid);

		Streamer_UpdateEx(playerid,
			btn_Data[id][btn_posX], btn_Data[id][btn_posY], btn_Data[id][btn_posZ],
			btn_Data[id][btn_world], btn_Data[id][btn_interior]);

		SetPlayerVirtualWorld(playerid, btn_Data[id][btn_world]);
		SetPlayerInterior(playerid, btn_Data[id][btn_interior]);
		SetPlayerPos(playerid, btn_Data[id][btn_posX], btn_Data[id][btn_posY], btn_Data[id][btn_posZ]);
	}
	else
	{
		btn_Pressing[playerid] = buttonid;

		if(CallLocalFunction("OnButtonPress", "dd", playerid, buttonid))
			return 1;
	}

	return 0;
}

timer btn_Unfreeze[btn_TELEPORT_FREEZE_TIME](playerid)
{
	TogglePlayerControllable(playerid, true);
}

hook OnPlayerEnterDynArea(playerid, areaid)
{
	if(!IsPlayerInAnyVehicle(playerid) && Iter_Count(btn_NearIndex[playerid]) < btn_MAX_INRANGE)
	{
		new data[2];

		Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID, data, 2);

		if(data[0] == btn_STREAMER_AREA_IDENTIFIER)
		{
			if(Iter_Contains(btn_Index, data[1]))
			{
				new cell = Iter_Free(btn_NearIndex[playerid]);

				btn_Near[playerid][cell] = data[1];
				Iter_Add(btn_NearIndex[playerid], cell);

				SendClientMessage(playerid, -1, btn_Data[data[1]][btn_text]);
				CallLocalFunction("OnPlayerEnterButtonArea", "dd", playerid, data[1]);
			}
		}
	}

}

hook OnPlayerLeaveDynArea(playerid, areaid)
{
	process_LeaveDynamicArea(playerid, areaid);
}

process_LeaveDynamicArea(playerid, areaid)
{
	printf("[OnPlayerLeaveDynamicArea]", playerid);

	if(!IsValidDynamicArea(areaid))
	{
		printf("[OnPlayerLeaveDynamicArea] area ID is invalid", playerid);
		return 1;
	}

	if(IsPlayerInAnyVehicle(playerid))
	{
		printf("[OnPlayerLeaveDynamicArea] player is in vehicle", playerid);
		return 1;
	}

	if(Iter_Count(btn_NearIndex[playerid]) == 0)
	{
		printf("[OnPlayerLeaveDynamicArea] player nearindex is empty",playerid);
		return 2;
	}

	new data[2];

	Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID, data, 2);

	if(data[0] != btn_STREAMER_AREA_IDENTIFIER)
	{
		printf("[OnPlayerLeaveDynamicArea] area is not a button area", playerid);
		return 3;
	}

	if(!Iter_Contains(btn_Index, data[1]))
	{
		printf("[OnPlayerLeaveDynamicArea] button ID is invalid", playerid);
		return 4;
	}

	CallLocalFunction("OnPlayerLeaveButtonArea", "dd", playerid, data[1]);

	foreach(new i : btn_NearIndex[playerid])
	{
		printf("[OnPlayerLeaveDynamicArea] looping player list", playerid);

		if(btn_Near[playerid][i] == data[1])
		{
			printf("[OnPlayerLeaveDynamicArea] removing from player list",playerid);
			Iter_Remove(btn_NearIndex[playerid], i);
			break;
		}
	}

	return 0;
}