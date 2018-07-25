

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{

	Weapon::GetDamage(weaponid);

	

    #if defined WeapDMG_OnPlayerTakeDamage
        WeapDMG_OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart);
    #else
   	 	return 1;
	#endif
}



#if defined _ALS_OnPlayerTakeDamage
    #undef OnPlayerTakeDamage
#else
    #define _ALS_OnPlayerTakeDamage
#endif
#define OnPlayerTakeDamage WeapDMG_OnPlayerTakeDamage
#if defined WeapDMG_OnPlayerTakeDamage
    forward WeapDMG_OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart);
#endif