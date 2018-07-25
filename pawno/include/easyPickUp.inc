#include <map>

#define CreatePickUp(%1,%2) \
	CreateEasyPickUp(#%1, %2)

#define PickUp:%0(%1) \
	forward EPU@%0(%1); public EPU@%0(%1)	

#define EASY_PICKUP_LEN   27

// Easy checkpoint functions
static Map:easyPUFunctions;

// Create easy checkpoint
stock CreateEasyPickUp(fname[], modelid, type, Float:x, Float:y, Float:z, Float:visibledistance = STREAMER_PICKUP_SD, playerid = -1, worldid = -1, interiorid = -1)
{
	if(strlen(fname) > EASY_PICKUP_LEN) return print("[easyPickUp Error] function name can't be more than "#EASY_PICKUP_LEN" characters.");
    new ret =  CreateDynamicPickup(modelid, type, Float:x, Float:y, Float:z, .playerid = playerid, .streamdistance = visibledistance, .worldid = worldid, .interiorid = interiorid);
    new fn[EASY_PICKUP_LEN + 11] = "EPU@";
    strcat(fn, fname);
    MAP_insert_val_str(easyPUFunctions, ret, fn);
    Streamer_Update(playerid, STREAMER_TYPE_PICKUP);
    return ret;
}

stock HidePickUp(playerid, pickupid)
{
	Streamer_RemoveArrayData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_PLAYER_ID, playerid);
	Streamer_Update(playerid, STREAMER_TYPE_PICKUP);
}

stock ShowPickUp(playerid, pickupid)
{
	Streamer_AppendArrayData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_PLAYER_ID, playerid);
	Streamer_Update(playerid, STREAMER_TYPE_PICKUP);
}


// Destroy easy checkpoint
stock DestroyPickUp(pickupid)
{
    if (MAP_remove_val(easyPUFunctions, pickupid))
        return DestroyDynamicPickup(pickupid);

    return 0;
}

// On player enter dynamic checkpoint
public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    if (MAP_contains_val(easyPUFunctions, pickupid))
    {
        new fname[EASY_PICKUP_LEN + 11];
        MAP_get_val_arr(easyPUFunctions, pickupid, fname);
        CallLocalFunction(fname, "dd", playerid, pickupid);
    }
    return 0;    
}
#if defined _ALSOnPlayerPickUpDynamicPickup
    #undef OnPlayerPickUpDynamicPickup
#else
    #define _ALSOnPlayerPickUpDynamicPickup
#endif
#define OnPlayerPickUpDynamicPickup EasyPU_OnPlayerPickUpDynamicPickup
