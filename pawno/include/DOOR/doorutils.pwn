/*
	Door And Buttons Framework
	Last Update 8/28/2017
	Created By Amagida (Codeah)
*/	

#include <YSI\y_iterate>
#include <YSI\y_timers>
#include <YSI\y_hooks>


#if !defined DR_MAX
	#define DR_MAX				(64)
#endif

#if !defined DR_MAX_BUTTONS_PER
	#define DR_MAX_BUTTONS_PER	(4)
#endif


#define INVALID_DOOR_ID			(-1)


#define DR_STATE_INVALID		(-1)

#define DR_STATE_OPEN			(0)


#define DR_STATE_CLOSED			(1)

#define DR_STATE_OPENING		(2)

#define DR_STATE_CLOSING		(3)


// Functions


forward CreateDoor(model, buttonids[], Float:px,  Float:py,  Float:pz,  Float:rx,  Float:ry,  Float:rz, Float:mpx, Float:mpy, Float:mpz, Float:mrx, Float:mry, Float:mrz, Float:movespeed = 1.0, closedelay = 3000, maxbuttons = sizeof(buttonids), movesound = 1186, stopsound = 1186, worldid = 0, interiorid = 0, initstate = DR_STATE_CLOSED);

forward DestroyDoor(doorid);

forward OpenDoor(doorid);

forward CloseDoor(doorid);

forward IsValidDOor(doorid);

forward GetDoorObjectID(doorid);

forward GetDoorModel(doorid);

forward SetDoorModel(doorid, model);

forward GetDoorButton(doorid, slot);

forward GetDoorButtonCount(doorid);

forward GetDoorCloseDelay(doorid);

forward SetDoorCloseDelay(doorid, closedelay);

forward GetDoorMoveSpeed(doorid);

forward SetDoorMoveSpeed(doorid, Float:movespeed);

forward GetDoorMoveSound(doorid);

forward SetDoorMoveSound(doorid, movesound);

forward GetDoorStopSound(doorid);

forward SetDoorStopSound(doorid, stopsound);

forward GetDoorPos(doorid, &Float:x, &Float:y, &Float:z);

forward SetDoorPos(doorid, Float:x, Float:y, Float:z);

forward GetDoorRot(doorid, &Float:rx, &Float:ry, &Float:rz);

forward SetDoorRot(doorid, Float:rx, Float:ry, Float:rz);

forward GetDoorMovePos(doorid, &Float:x, &Float:y, &Float:z);

forward SetDoorMovePos(doorid, Float:x, Float:y, Float:z);

forward GetDoorMoveRot(doorid, &Float:rx, &Float:ry, &Float:rz);

forward SetDoorMoveRot(doorid, Float:rx, Float:ry, Float:rz);

forward GetDoorState(doorid);

forward OnPlayerActivateDoor(playerid, doorid, newstate);

forward OnDoorStateChange(doorid, doorstate);



enum E_DOOR_DATA
{
			dr_objectid,
			dr_model,
			dr_buttonArray[DR_MAX_BUTTONS_PER],
			dr_buttonCount,
			dr_closeDelay,
Float:		dr_moveSpeed,
			dr_moveSound,
			dr_stopSound,

Float:		dr_posX,
Float:		dr_posY,
Float:		dr_posZ,
Float:		dr_rotX,
Float:		dr_rotY,
Float:		dr_rotZ,

Float:		dr_posMoveX,
Float:		dr_posMoveY,
Float:		dr_posMoveZ,
Float:		dr_rotMoveX,
Float:		dr_rotMoveY,
Float:		dr_rotMoveZ
}

static
			dr_Data[DR_MAX][E_DOOR_DATA],
			dr_State[DR_MAX char],
   Iterator:dr_Index<DR_MAX>;


stock CreateDoor(model, buttonids[], Float:px,  Float:py,  Float:pz,  Float:rx,  Float:ry,  Float:rz, Float:mpx, Float:mpy, Float:mpz, Float:mrx, Float:mry, Float:mrz, Float:movespeed = 1.0, closedelay = 3000, maxbuttons = sizeof(buttonids), movesound = 1186, stopsound = 1186, worldid = 0, interiorid = 0, initstate = DR_STATE_CLOSED)
{
	new id = Iter_Free(dr_Index);

	if(id == -1)
		return INVALID_DOOR_ID;

	if(initstate == DR_STATE_CLOSED)
		dr_Data[id][dr_objectid] = CreateDynamicObject(model, px, py, pz, rx, ry, rz, worldid, interiorid);

	else
		dr_Data[id][dr_objectid] = CreateDynamicObject(model, mpx, mpy, mpz, mrx, mry, mrz, worldid, interiorid);

	dr_Data[id][dr_model] = model;
	dr_Data[id][dr_buttonCount] = maxbuttons;
	dr_Data[id][dr_closeDelay] = closedelay;
	dr_Data[id][dr_moveSpeed] = movespeed;

	for(new i; i < maxbuttons; i++)
		dr_Data[id][dr_buttonArray][i] = buttonids[i];

	dr_Data[id][dr_moveSound] = movesound;
	dr_Data[id][dr_stopSound] = stopsound;

	dr_Data[id][dr_posX] = px;
	dr_Data[id][dr_posY] = py;
	dr_Data[id][dr_posZ] = pz;
	dr_Data[id][dr_rotX] = rx;
	dr_Data[id][dr_rotY] = ry;
	dr_Data[id][dr_rotZ] = rz;

	dr_Data[id][dr_posMoveX] = mpx;
	dr_Data[id][dr_posMoveY] = mpy;
	dr_Data[id][dr_posMoveZ] = mpz;
	dr_Data[id][dr_rotMoveX] = mrx;
	dr_Data[id][dr_rotMoveY] = mry;
	dr_Data[id][dr_rotMoveZ] = mrz;

	dr_State{id} = initstate;

	Iter_Add(dr_Index, id);
	return id;
}

stock DestroyDoor(doorid)
{
	if(!Iter_Contains(dr_Index, doorid))
		return 0;

	for(new i; i < dr_Data[id][dr_buttonCount]; i++)
		dr_Data[id][dr_buttonArray][i] = INVALID_BUTTON_ID;

	DestroyDynamicObject(dr_Data[id][dr_objectid]);
	dr_Data[id][dr_buttonCount] = 0;
	dr_Data[id][dr_closeDelay] = 0;
	dr_Data[id][dr_moveSpeed] = 0.0;

	dr_Data[id][dr_moveSound] = 0;
	dr_Data[id][dr_stopSound] = 0;

	dr_Data[id][dr_posX] = 0.0;
	dr_Data[id][dr_posY] = 0.0;
	dr_Data[id][dr_posZ] = 0.0;
	dr_Data[id][dr_rotX] = 0.0;
	dr_Data[id][dr_rotY] = 0.0;
	dr_Data[id][dr_rotZ] = 0.0;

	dr_Data[id][dr_posMoveX] = 0.0;
	dr_Data[id][dr_posMoveY] = 0.0;
	dr_Data[id][dr_posMoveZ] = 0.0;
	dr_Data[id][dr_rotMoveX] = 0.0;
	dr_Data[id][dr_rotMoveY] = 0.0;
	dr_Data[id][dr_rotMoveZ] = 0.0;

	dr_State{id} = 0;

	Iter_Remove(dr_Index, id);
	return 1;
}

stock OpenDoor(doorid)
{
	if(!Iter_Contains(dr_Index, doorid))return 0;

	MoveDynamicObject(dr_Data[doorid][dr_objectid],
		dr_Data[doorid][dr_posMoveX], dr_Data[doorid][dr_posMoveY], dr_Data[doorid][dr_posMoveZ], dr_Data[doorid][dr_moveSpeed],
		dr_Data[doorid][dr_rotMoveX], dr_Data[doorid][dr_rotMoveY], dr_Data[doorid][dr_rotMoveZ]);

	dr_State{doorid} = DR_STATE_OPENING;

	if(dr_Data[doorid][dr_moveSound] != -1)
		dr_PlaySoundForAll(dr_Data[doorid][dr_moveSound], dr_Data[doorid][dr_posX], dr_Data[doorid][dr_posY], dr_Data[doorid][dr_posZ]);

	CallLocalFunction("OnDoorStateChange", "dd", doorid, DR_STATE_OPENING);

	return 1;
}

stock CloseDoor(doorid)
{
	if(!Iter_Contains(dr_Index, doorid))return 0;

	MoveDynamicObject(dr_Data[doorid][dr_objectid],
		dr_Data[doorid][dr_posX], dr_Data[doorid][dr_posY], dr_Data[doorid][dr_posZ], dr_Data[doorid][dr_moveSpeed],
		dr_Data[doorid][dr_rotX], dr_Data[doorid][dr_rotY], dr_Data[doorid][dr_rotZ]);

	dr_State{doorid} = DR_STATE_CLOSING;

	if(dr_Data[doorid][dr_moveSound] != -1)
		dr_PlaySoundForAll(dr_Data[doorid][dr_moveSound], dr_Data[doorid][dr_posX], dr_Data[doorid][dr_posY], dr_Data[doorid][dr_posZ]);

	CallLocalFunction("OnDoorStateChange", "dd", doorid, DR_STATE_CLOSING);

	return 1;
}

stock IsValidDOor(doorid)
{
	if(!Iter_Contains(dr_Index, doorid))
		return 0;

	return 1;
}

// dr_objectid
stock GetDoorObjectID(doorid)
{
	if(!Iter_Contains(dr_Index, doorid))
		return -1;

	return dr_Data[doorid][dr_objectid];
}

// dr_model
stock GetDoorModel(doorid)
{
	if(!Iter_Contains(dr_Index, doorid))
		return -1;

	return dr_Data[doorid][dr_model];
}
stock SetDoorModel(doorid, model)
{
	if(!Iter_Contains(dr_Index, doorid))
		return 0;

	Streamer_SetIntData(STREAMER_TYPE_OBJECT, dr_Data[doorid][dr_objectid], E_STREAMER_MODEL_ID, model);
	dr_Data[doorid][dr_model] = model;

	return 1;
}

// dr_buttonArray[DR_MAX_BUTTONS_PER]
stock GetDoorButton(doorid, slot)
{
	if(!Iter_Contains(dr_Index, doorid))
		return -1;

	if(!(0 <= slot < dr_Data[doorid][dr_buttonCount]))
		return -2;

	return dr_Data[doorid][dr_buttonArray][slot];
}

// dr_buttonCount
stock GetDoorButtonCount(doorid)
{
	if(!Iter_Contains(dr_Index, doorid))
		return -1;

	return dr_Data[doorid][dr_buttonCount];
}

// dr_closeDelay
stock GetDoorCloseDelay(doorid)
{
	if(!Iter_Contains(dr_Index, doorid))
		return -1;

	return dr_Data[doorid][dr_closeDelay];
}
stock SetDoorCloseDelay(doorid, closedelay)
{
	if(!Iter_Contains(dr_Index, doorid))
		return -1;

	dr_Data[doorid][dr_closeDelay] = closedelay;

	return 1;
}

// dr_moveSpeed
stock GetDoorMoveSpeed(doorid)
{
	if(!Iter_Contains(dr_Index, doorid))
		return -1;

	return dr_Data[doorid][dr_moveSpeed];
}
stock SetDoorMoveSpeed(doorid, Float:movespeed)
{
	if(!Iter_Contains(dr_Index, doorid))
		return -1;

	dr_Data[doorid][dr_moveSpeed] = movespeed;

	return 1;
}

// dr_moveSound
stock GetDoorMoveSound(doorid)
{
	if(!Iter_Contains(dr_Index, doorid))
		return -1;

	return dr_Data[doorid][dr_moveSound];
}
stock SetDoorMoveSound(doorid, movesound)
{
	if(!Iter_Contains(dr_Index, doorid))
		return -1;

	dr_Data[doorid][dr_moveSound] = movesound;

	return 1;
}

// dr_stopSound
stock GetDoorStopSound(doorid)
{
	if(!Iter_Contains(dr_Index, doorid))
		return -1;

	return dr_Data[doorid][dr_stopSound];
}
stock SetDoorStopSound(doorid, stopsound)
{
	if(!Iter_Contains(dr_Index, doorid))
		return -1;

	dr_Data[doorid][dr_stopSound] = stopsound;

	return 1;
}

// dr_posX
// dr_posY
// dr_posZ
stock GetDoorPos(doorid, &Float:x, &Float:y, &Float:z)
{
	if(!Iter_Contains(dr_Index, doorid))
		return 0;

	x = dr_Data[doorid][dr_posX];
	y = dr_Data[doorid][dr_posY];
	z = dr_Data[doorid][dr_posZ];
	
	return 1;
}
stock SetDoorPos(doorid, Float:x, Float:y, Float:z)
{
	if(!Iter_Contains(dr_Index, doorid))
		return 0;

	dr_Data[doorid][dr_posX] = x;
	dr_Data[doorid][dr_posY] = y;
	dr_Data[doorid][dr_posZ] = z;

	SetDynamicObjectPos(dr_Data[doorid][dr_objectid], x, y, z);
	
	return 1;
}

// dr_rotX
// dr_rotY
// dr_rotZ
stock GetDoorRot(doorid, &Float:rx, &Float:ry, &Float:rz)
{
	if(!Iter_Contains(dr_Index, doorid))
		return 0;

	rx = dr_Data[doorid][dr_rotX];
	ry = dr_Data[doorid][dr_rotY];
	rz = dr_Data[doorid][dr_rotZ];
	
	return 1;
}
stock SetDoorRot(doorid, Float:rx, Float:ry, Float:rz)
{
	if(!Iter_Contains(dr_Index, doorid))
		return 0;

	dr_Data[doorid][dr_rotX] = rx;
	dr_Data[doorid][dr_rotY] = ry;
	dr_Data[doorid][dr_rotZ] = rz;

	SetDynamicObjectRot(dr_Data[doorid][dr_objectid], rx, ry, rz);
	
	return 1;
}

// dr_posMoveX
// dr_posMoveY
// dr_posMoveZ
stock GetDoorMovePos(doorid, &Float:x, &Float:y, &Float:z)
{
	if(!Iter_Contains(dr_Index, doorid))
		return 0;

	x = dr_Data[doorid][dr_posMoveX];
	y = dr_Data[doorid][dr_posMoveY];
	z = dr_Data[doorid][dr_posMoveZ];
	
	return 1;
}
stock SetDoorMovePos(doorid, Float:x, Float:y, Float:z)
{
	if(!Iter_Contains(dr_Index, doorid))
		return 0;

	dr_Data[doorid][dr_posMoveX] = x;
	dr_Data[doorid][dr_posMoveY] = y;
	dr_Data[doorid][dr_posMoveZ] = z;

	return 1;
}

// dr_rotMoveX
// dr_rotMoveY
// dr_rotMoveZ
stock GetDoorMoveRot(doorid, &Float:rx, &Float:ry, &Float:rz)
{
	if(!Iter_Contains(dr_Index, doorid))
		return 0;

	rx = dr_Data[doorid][dr_rotMoveX];
	ry = dr_Data[doorid][dr_rotMoveY];
	rz = dr_Data[doorid][dr_rotMoveZ];
	
	return 1;
}
stock SetDoorMoveRot(doorid, Float:rx, Float:ry, Float:rz)
{
	if(!Iter_Contains(dr_Index, doorid))
		return 0;

	dr_Data[doorid][dr_rotMoveX] = rx;
	dr_Data[doorid][dr_rotMoveY] = ry;
	dr_Data[doorid][dr_rotMoveZ] = rz;
	
	return 1;
}

// dr_State
stock GetDoorState(doorid)
{
	if(!Iter_Contains(dr_Index, doorid))
		return DR_STATE_INVALID;

	return dr_State{doorid};
}

hook OnButtonPress(playerid, buttonid)
{
	foreach(new i : dr_Index)
	{
		for(new j; j < dr_Data[i][dr_buttonCount]; j++)
		{
			if(buttonid == dr_Data[i][dr_buttonArray][j])
			{
				if(dr_State{i} == DR_STATE_CLOSED || dr_State{i} == DR_STATE_CLOSING)
				{
					if(CallLocalFunction("OnPlayerActivateDoor", "ddd", playerid, i, DR_STATE_OPENING))
						return 0;

					OpenDoor(i);
				}
				else if(dr_State{i} == DR_STATE_OPEN || dr_State{i} == DR_STATE_OPENING)
				{
					if(CallLocalFunction("OnPlayerActivateDoor", "ddd", playerid, i, DR_STATE_CLOSING))
						return 0;

					CloseDoor(i);
				}
			}
		}
	}

	return 1;
}

timer _CloseDoorTimer[ dr_Data[doorid][dr_closeDelay] ](doorid)
{
	CloseDoor(doorid);
}

dr_PlaySoundForAll(sound, Float:x, Float:y, Float:z)
{
	foreach(new i : Player)
	{
		PlayerPlaySound(i, sound, x, y, z);
	}
	return 1;
}

hook OnDynamicObjectMoved(objectid)
{
	foreach(new i : dr_Index)
	{
		if(objectid == dr_Data[i][dr_objectid] && dr_State{i} == DR_STATE_OPENING)
		{
			dr_State{i} = DR_STATE_OPEN;
			if(dr_Data[i][dr_closeDelay] >= 0)
				defer _CloseDoorTimer(i);

			if(dr_Data[i][dr_stopSound] != -1)
				dr_PlaySoundForAll(dr_Data[i][dr_stopSound], dr_Data[i][dr_posX], dr_Data[i][dr_posY], dr_Data[i][dr_posZ]);

			CallLocalFunction("OnDoorStateChange", "dd", i, DR_STATE_OPEN);
		}
		if(objectid == dr_Data[i][dr_objectid] && dr_State{i} == DR_STATE_CLOSING)
		{
			dr_State{i} = DR_STATE_CLOSED;

			if(dr_Data[i][dr_stopSound] != -1)
				dr_PlaySoundForAll(dr_Data[i][dr_stopSound], dr_Data[i][dr_posX], dr_Data[i][dr_posY], dr_Data[i][dr_posZ]);

			CallLocalFunction("OnDoorStateChange", "dd", i, DR_STATE_CLOSED);
		}
	}
}
