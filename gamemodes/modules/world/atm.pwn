#include <YSI\y_hooks>


forward OnPlayerOpenATM(playerid);

#define MAX_ATM 150
#define ATM_STARTER_MONEY 100000
#define ATM_OBJECT 19324

enum E_ATM
{

Float:atmX,
Float:atmY,
Float:atmZ,
Float:atmA,
	  atmMoney,
	  atmObject,
Text3D:atmLabel	  
}

new 
	atm_Conf[MAX_ATM][E_ATM],
	Created_ATM = 0
;


hook OnGameModeInit()
{

	CreateATM(1194.4771,-1753.2928,13.5826,0.0,0.0,0.0, 100000); //TEST ATM

}

stock CreateATM(Float:posX, Float:posY, Float:posZ, Float:rotX, Float:rotY, Float:rotZ, atm_StarterMoney = ATM_STARTER_MONEY)
{

	atm_Conf[Created_ATM][atmX] = posX;
	atm_Conf[Created_ATM][atmY] = posY;
	atm_Conf[Created_ATM][atmZ] = posZ;
	atm_Conf[Created_ATM][atmA] = rotX;
	atm_Conf[Created_ATM][atmMoney] = atm_StarterMoney;
	atm_Conf[Created_ATM][atmObject] = CreateDynamicObject(ATM_OBJECT, posX, posY, posZ-0.4, rotX, rotY, rotZ);
	atm_Conf[Created_ATM][atmLabel] = CreateDynamic3DTextLabel("{68A533}CLICK\n{3FD580}ALT", -1, posX, posY, posZ, 6.0);

	return Created_ATM++;

}


stock IsPlayerNearATM(playerid)
{
	for(new i; i<Created_ATM; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, atm_Conf[i][atmX], atm_Conf[i][atmY], atm_Conf[i][atmZ]))
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	return false;
}


hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(IsPlayerNearATM(playerid) && newkeys == 1024)
	{
		if(funcidx("OnPlayerOpenATM") != -1) CallLocalFunction("OnPlayerOpenATM","d",playerid);
	}
}