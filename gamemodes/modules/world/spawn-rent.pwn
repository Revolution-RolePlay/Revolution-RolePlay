#include <YSI\y_hooks>

#define MAX_SPAWN_RENT_CAR (90)

enum @@SpawnRentInfo 
{
	SRI@@vID,
	SRI@@vPrice
}


static 
		Spawn_Rent[MAX_SPAWN_RENT_CAR][@@SpawnRentInfo],
		Spawn_Rent_Car_Added = 0
;

new
		Player_RentCar[MAX_PLAYERS] = -1
;

static 
		bool:Opened_Rent_Car_Menu[MAX_PLAYERS] = false
;		

stock AddSpawnRentCar(carid, carprice)
{
	Spawn_Rent[Spawn_Rent_Car_Added][SRI@@vID] = carid;
	Spawn_Rent[Spawn_Rent_Car_Added][SRI@@vPrice] = carprice;
	return Spawn_Rent_Car_Added++;
}

stock ShowCarRentWindow(playerid)
{
	static string[MAX_SPAWN_RENT_CAR * 36], formattedone[36]; 
    
    for (new i; i < Spawn_Rent_Car_Added; i++) 
    {
        format(formattedone, sizeof formattedone, "%i\t%i$\n", Spawn_Rent[i][SRI@@vID], Spawn_Rent[i][SRI@@vPrice]); 
        strcat(string, formattedone);
    }	
	ShowPlayerDialog(playerid, 691, DIALOG_STYLE_PREVIEW_MODEL, "Airchiet Transporti Romlis Qiraobac Gsurt", string, "Archeva", "Gatishva");   
	stringclear(string);
    stringclear(formattedone); 
}

hook OnPlayerConnect(playerid)
{
	Player_RentCar[playerid] = -1;
	Opened_Rent_Car_Menu[playerid] = false;
}

hook OnPlayerDisconnect(playerid, reason)
{
	DestroyVehicle(Player_RentCar[playerid]);

	Player_RentCar[playerid] = -1;
	Opened_Rent_Car_Menu[playerid] = false;

}

hook OnGameModeInit()
{
	CreatePickUp(SPAWN_RENT_1, 19134, 23, 1142.6578, -1755.0271, 13.6136);
	CreatePickUp(SPAWN_RENT_2, 19134, 23, 1201.0621, -1732.4448, 13.5722);

	AddSpawnRentCar(462, 100);
	AddSpawnRentCar(481, 80);
	AddSpawnRentCar(509, 50);
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 691)
	{
		if(response)
		{
		
			if(CanPlayerBuy(playerid, Spawn_Rent[listitem][SRI@@vPrice]))
			{

				new
					Float:x,
					Float:y,
					Float:z,
					Float:a
				;
				
				GetPlayerPos(playerid, x, y, z);
				GetPlayerFacingAngle(playerid, a);
		
				Player_RentCar[playerid] = CreateVehicle(Spawn_Rent[listitem][SRI@@vID], x, y+3.0, z, a, 0, -1, 180);
				PutPlayerInVehicle(playerid, Player_RentCar[playerid], 0);
		
				SetPlayerCash(playerid, GetPlayerCash(playerid)-Spawn_Rent[listitem][SRI@@vPrice]);
	
				Opened_Rent_Car_Menu[playerid] = false;
			}	
			Opened_Rent_Car_Menu[playerid] = false;
		}	

	}
	return 1;
}

PickUp:SPAWN_RENT_1(playerid, pickupid)
{
	if(Player_RentCar[playerid] == -1)
	{
		if(Opened_Rent_Car_Menu[playerid] == false)
		{
			ShowCarRentWindow(playerid);

			Opened_Rent_Car_Menu[playerid] = true;
		}
	}
	else{
		ChatMsg(playerid, -1, "Tqven Ukve Gyavt Naqiravebi Transporti");
	}	
	return 1;	
}

PickUp:SPAWN_RENT_2(playerid, pickupid)
{
	if(Player_RentCar[playerid] == -1)
	{
		if(Opened_Rent_Car_Menu[playerid] == false)
		{
			ShowCarRentWindow(playerid);

			Opened_Rent_Car_Menu[playerid] = true;
		}
	}
	else{
		ChatMsg(playerid, -1, "Tqven Ukve Gyavt Naqiravebi Transporti");
	}	
	return 1;
}

CMD:rlock(playerid, params[])
{
	if(Player_RentCar[playerid] == -1) return ChatMsg(playerid, -1, "Tqven Ar Gyavt Naqiravebi Transporti!");

	static 
			Float:x,
			Float:y,
			Float:z
	;
	
	GetVehiclePos(Player_RentCar[playerid], x, y, z);

	if(IsPlayerInRangeOfPoint(playerid, 1.0, x,y,z))
	{
		if(IsVehicleLocked(Player_RentCar[playerid]))
		{
			GameTextForPlayer(playerid, "Unlocked!", 1500, 1);
			UnlockVehicleDoors(Player_RentCar[playerid]);
		}
		else
		{
			GameTextForPlayer(playerid, "Locked!", 1500, 1);
			LockVehicleDoors(Player_RentCar[playerid]);
		}
	}		
	else
	{
		ChatMsg(playerid, -1, "Tqven Ar Xart Tqvens Mier Naqiraveb Transporttan Axlos!");
	}
	return 1;
}

CMD:unrent(playerid, params[])
{
	if(Player_RentCar[playerid] == -1) return ChatMsg(playerid, -1, "Tqven Ar Gyavt Naqiravebi Transporti!");

	DestroyVehicle(Player_RentCar[playerid]);
	Player_RentCar[playerid] = -1;

	ChatMsg(playerid, -1, "Tqven Agar Gyavt Naqiravebi Transporti!");

	return 1;
}