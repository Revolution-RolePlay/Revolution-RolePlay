/*
	Simple Checkpoints Streamer v1.0 by Arthur Kane
	Nov 8, 2017. 
*/

#include <a_samp>

#if defined _CPStreamer_Include
	#endinput
#endif
#define _CPStreamer_Include

#define MAX_CHECKPOINT_PER_PLAYER (3)
// The amount of checkpoints that an individual player will be able to receive. 

//Checkpoint types:
#define TYPE_PLAYER_CLEAR (1)
// The checkpoint can be cleared by the player.

#define TYPE_ENTER_CLEAR (2)
// The checkpoint is cleared when the player enters it.

#if defined _ALS_SetPlayerCheckpoint
	#undef SetPlayerCheckpoint
#else
#define _ALS_SetPlayerCheckpoint
#endif
#define SetPlayerCheckpoint MC_SetPlayerCheckpoint

#if defined _ALS_DisablePlayerCheckpoint
	#undef DisablePlayerCheckpoint
#else
#define _ALS_DisablePlayerCheckpoint
#endif
#define DisablePlayerCheckpoint MC_DisablePlayerCheckpoint

#if defined _ALS_OnPlayerEnterCheckpoint
	#undef OnPlayerEnterCheckpoint
#else
#define _ALS_OnPlayerEnterCheckpoint
#endif
#define OnPlayerEnterCheckpoint MC_OnPlayerEnterCheckpoint

#if defined _ALS_OnPlayerLeaveCheckpoint
	#undef OnPlayerLeaveCheckpoint
#else
#define _ALS_OnPlayerLeaveCheckpoint
#endif
#define OnPlayerLeaveCheckpoint MC_OnPlayerLeaveCheckpoint

forward MC_DrawCheckpointTimer();
forward MC_OnPlayerEnterCheckpoint(playerid, checkpoint_id);
forward MC_OnPlayerLeaveCheckpoint(playerid, checkpoint_id); 

enum M_CHECKPOINT_DATA
{
	CP_ICON_ID,
	bool:CP_EXISTS,
	
	Float: CP_POS_X,
	Float: CP_POS_Y,
	Float: CP_POS_Z,
	
	CP_INTERIOR,
	CP_WORLD,
	
	CP_COLOR, 
	CP_ENTER_TYPE,
	
	CP_PLAYER_INSIDE,	
	CP_VISIBLE
}
new MC_Checkpoints[ MAX_PLAYERS ][ MAX_CHECKPOINT_PER_PLAYER ][ M_CHECKPOINT_DATA ];

/*
	CP_ICON_ID - The player's map icon ID.
	CP_EXISTS - Internal use. 
	
	CP_POS_X-Z - The coordinates used for the checkpoint.
	CP_INTERIOR - The checkpoints interior ID.
	CP_WORLD - The checkpoints world ID.

	CP_COLOR - The color of the checkpoint rendered.
	CP_ENTER_TYPE - TYPE_ENTER_CLEAR (2) and TYPE_PLAYER_CLEAR (1)
	
	CP_PLAYER_INSIDE - Internal use.
	CP_VISIBLE - Internal use.
*/

public OnPlayerUpdate(playerid)
{
	return CallLocalFunction("MC_DrawCheckpointTimer", "", ""); 
}

#if defined _ALS_OnPlayerUpdate
#undef OnPlayerUpdate
#else
#define _ALS_OnPlayerUpdate
#endif
 
#define OnPlayerUpdate MC_OnPlayerUpdate
forward MC_OnPlayerUpdate(playerid);

stock MC_ReturnCheckpointID(playerid)
{
	for(new i; i < MAX_CHECKPOINT_PER_PLAYER; i++)
	{
		if( !MC_Checkpoints[ playerid ][ i ][ CP_EXISTS ] )
			return i;
	}
	return -1;
}

stock MC_SetPlayerCheckpoint(playerid, Float:x, Float:y, Float:z, type = TYPE_ENTER_CLEAR, interior = -1, world = -1, color = 0xFF0000FF)
{
	new mc_checkpoint_id = MC_ReturnCheckpointID(playerid);
	
	if( mc_checkpoint_id == -1 )
		return -1;
		
	if( type <= 0 || type >= 3 )
		type = TYPE_ENTER_CLEAR; 
	
	MC_Checkpoints[ playerid ][ mc_checkpoint_id ][ CP_EXISTS ] = true;
	MC_Checkpoints[ playerid ][ mc_checkpoint_id ][ CP_ICON_ID ] = 60 + mc_checkpoint_id; 
	
	MC_Checkpoints[ playerid ][ mc_checkpoint_id ][ CP_POS_X ] = x;
	MC_Checkpoints[ playerid ][ mc_checkpoint_id ][ CP_POS_Y ] = y;
	MC_Checkpoints[ playerid ][ mc_checkpoint_id ][ CP_POS_Z ] = z;
	
	MC_Checkpoints[ playerid ][ mc_checkpoint_id ][ CP_INTERIOR ] = interior;
	MC_Checkpoints[ playerid ][ mc_checkpoint_id ][ CP_WORLD ] = world;
	
	MC_Checkpoints[ playerid ][ mc_checkpoint_id ][ CP_COLOR ] = color; 
	
	MC_Checkpoints[ playerid ][ mc_checkpoint_id ][ CP_ENTER_TYPE ] = type;
	MC_Checkpoints[ playerid ][ mc_checkpoint_id ][ CP_PLAYER_INSIDE ] = 0; 
	
	return mc_checkpoint_id; 
}

stock MC_DisablePlayerCheckpoint(playerid, checkpoint_id = -1)
{
	if( checkpoint_id == -1 )
	{
		for(new i; i < MAX_CHECKPOINT_PER_PLAYER; i++)
		{
			if( MC_Checkpoints[ playerid ][ i ][ CP_EXISTS ])
			{
				MC_ClearPlayerCheckpoint(playerid, i);
			}
		}
	}
	else
	{
		MC_ClearPlayerCheckpoint(playerid, checkpoint_id); 
	}
	return 1;
}

stock MC_ClearPlayerCheckpoint(playerid, checkpoint_id)
{
	if( !MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_EXISTS ] )
		return -1; 
		
	MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_EXISTS ] = false;
	
	if( MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_VISIBLE ] )
		RemovePlayerMapIcon( playerid, MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_ICON_ID ] );
	
	MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_ICON_ID ] = 0; 
	MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_VISIBLE ] = 0; 
	
	MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_POS_X ] = 0.0;
	MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_POS_Y ] = 0.0;
	MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_POS_Z ] = 0.0;
	return 1;
}

public MC_DrawCheckpointTimer()
{	
	for(new playerid = 0, j = GetPlayerPoolSize(); playerid <= j; playerid++)
	{
		for(new checkpoint_id = 0; checkpoint_id < MAX_CHECKPOINT_PER_PLAYER; checkpoint_id++)
		{
			if( MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_EXISTS ])
			{
				if( MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_VISIBLE ] )
				{
					if( (GetPlayerInterior( playerid ) != MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_INTERIOR ] && MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_INTERIOR ] != -1) || (GetPlayerVirtualWorld( playerid ) != MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_WORLD ] && MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_WORLD ] != -1))
					{
						RemovePlayerMapIcon( playerid, MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_ICON_ID ] );
						MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_VISIBLE ] = 0; 
					}
					
					if( !MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_PLAYER_INSIDE ])
					{
						if( IsPlayerInRangeOfPoint( playerid, 1.0, MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_POS_X ], MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_POS_Y ], MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_POS_Z ]))
						{
							MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_PLAYER_INSIDE ] = 1;
							
							if( MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_ENTER_TYPE ] == TYPE_ENTER_CLEAR )
								MC_ClearPlayerCheckpoint( playerid, checkpoint_id ); 
							
							CallLocalFunction( "MC_OnPlayerEnterCheckpoint", "ii", playerid, checkpoint_id );
						}
					}
					else
					{
						if( !IsPlayerInRangeOfPoint( playerid, 1.0, MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_POS_X ], MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_POS_Y ], MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_POS_Z ]) )
						{
							MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_PLAYER_INSIDE ] = 0;
							CallLocalFunction( "MC_OnPlayerLeaveCheckpoint", "ii", playerid, checkpoint_id );
						}
					}
				}
				else
				{
					if( (GetPlayerVirtualWorld( playerid ) == MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_WORLD ] || MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_WORLD ] == -1) && (GetPlayerInterior( playerid ) == MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_INTERIOR ] || MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_INTERIOR ] == -1))
					{
						MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_VISIBLE ] = 1; 
						SetPlayerMapIcon( playerid, MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_ICON_ID ], MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_POS_X ], MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_POS_Y ], MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_POS_Z ], 0, MC_Checkpoints[ playerid ][ checkpoint_id ][ CP_COLOR ], MAPICON_GLOBAL_CHECKPOINT ); 
					}
				}
			}
		}
	}
	return 1;
}
