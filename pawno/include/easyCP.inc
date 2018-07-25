#include <map>

#define CreateCheckPoint(%0,%1) \
    CreateEasyCP(#%0, %1)
#define CreateRaceCheckPoint(%0,%1,%2) \
    CreateEasyRaceCP(%0, #%1, %2)


#define CheckPoint:%0(%1) \
    forward ECP@%0(%1); public ECP@%0(%1)   
#define RaceCheckPoint:%0(%1) \
    forward RCP@%0(%1); public RCP@%0(%1)

#define EASY_CP_FNAME_LEN   27

// Easy checkpoint functions
static Map:easyCPFunctions;

// Create easy checkpoint Normal CP-s
stock CreateEasyCP(fname[], Float:x, Float:y, Float:z, Float:size, playerid = -1, Float:visibledistance = STREAMER_CP_SD)
{
    if(strlen(fname) > EASY_CP_FNAME_LEN) return print("[easyCP Error] function name can't be more than "#EASY_CP_FNAME_LEN" characters.");
    new ret = CreateDynamicCP(Float:x, Float:y, Float:z, Float:size, .playerid = playerid, .streamdistance = visibledistance);
    new fn[EASY_CP_FNAME_LEN + 11] = "ECP@";
    strcat(fn, fname);
    MAP_insert_val_str(easyCPFunctions, ret, fn);
    Streamer_Update(playerid, STREAMER_TYPE_CP);
    return ret;
}

stock HideCheckPoint(playerid, checkpointid)
{
    Streamer_RemoveArrayData(STREAMER_TYPE_CP, checkpointid, E_STREAMER_PLAYER_ID, playerid);
    Streamer_Update(playerid, STREAMER_TYPE_CP);
}

stock ShowCheckPoint(playerid, checkpointid)
{
    Streamer_AppendArrayData(STREAMER_TYPE_CP, checkpointid, E_STREAMER_PLAYER_ID, playerid);
    Streamer_Update(playerid, STREAMER_TYPE_CP);
}


// Destroy easy checkpoint
stock DestroyCheckPoint(checkpointid)
{
    if (MAP_remove_val(easyCPFunctions, checkpointid))
        return DestroyDynamicCP(checkpointid);

    return 0;
}

//Create easy checkpoint Race CP-s.
stock CreateEasyRaceCP(playerid, fname[], type, Float:x, Float:y, Float:z, Float:nextx, Float:nexty, Float:nextz, Float:size, Float:visibledistance = STREAMER_RACE_CP_SD)
{
    if(strlen(fname) > EASY_CP_FNAME_LEN) return print("[easyCP Error] function name can't be more than "#EASY_CP_FNAME_LEN" characters.");
    new ret = CreateDynamicRaceCP(type, x, y, z, nextx, nexty, nextz, size, .playerid = playerid, .streamdistance = visibledistance);
    new fn[EASY_CP_FNAME_LEN + 11] = "RCP@";
    strcat(fn, fname);
    MAP_insert_val_str(easyCPFunctions, ret, fn);
    Streamer_Update(playerid, STREAMER_TYPE_RACE_CP);
    return ret;
}

stock HideRaceCheckPoint(playerid, checkpointid)
{
    Streamer_RemoveArrayData(STREAMER_TYPE_RACE_CP, checkpointid, E_STREAMER_PLAYER_ID, playerid);
    Streamer_Update(playerid, STREAMER_TYPE_RACE_CP);
}

stock ShowRaceCheckPoint(playerid, checkpointid)
{
    Streamer_AppendArrayData(STREAMER_TYPE_RACE_CP, checkpointid, E_STREAMER_PLAYER_ID, playerid);
    Streamer_Update(playerid, STREAMER_TYPE_RACE_CP);
}

// Destroy easy checkpoint
stock DestroyRaceCheckPoint(checkpointid)
{
    if (MAP_remove_val(easyCPFunctions, checkpointid))
        return DestroyDynamicRaceCP(checkpointid);

    return 0;
}

// On player enter dynamic checkpoint
public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if (MAP_contains_val(easyCPFunctions, checkpointid))
    {
        new fname[EASY_CP_FNAME_LEN + 11];
        MAP_get_val_arr(easyCPFunctions, checkpointid, fname);
        CallLocalFunction(fname, "dd", playerid, checkpointid);
    }
    return 0;    
}

#if defined _ALS_OnPlayerEnterDynamicCP
    #undef OnPlayerEnterDynamicCP
#else
    #define _ALS_OnPlayerEnterDynamicCP
#endif
#define OnPlayerEnterDynamicCP EasyCP_OnPlayerEnterDynamicCP
#if defined EasyCP_OnPlayerEnterDynamicCP
    forward EasyCP_OnPlayerEnterDynamicCP(playerid, checkpointid);
#endif

public OnPlayerEnterDynamicRaceCP(playerid, checkpointid)
{
    if (MAP_contains_val(easyCPFunctions, checkpointid))
    {
        new fname[EASY_CP_FNAME_LEN + 11];
        MAP_get_val_arr(easyCPFunctions, checkpointid, fname);
        CallLocalFunction(fname, "dd", playerid, checkpointid);
    }
    return 0;
}

#if defined _ALS_OnPlayerEnterDynamicRaceCP
    #undef OnPlayerEnterDynamicRaceCP
#else
    #define _ALS_OnPlayerEnterDynamicRaceCP
#endif
#define OnPlayerEnterDynamicRaceCP EasyCP_OnPlayerEnterRace
#if defined EasyCP_OnPlayerEnterRace
    forward EasyCP_OnPlayerEnterRace(playerid, checkpointid);
#endif