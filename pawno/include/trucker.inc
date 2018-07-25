/*
	MINEING SYSTEM FRAMEWORK
	Last Update - 8/9/2017
	Include Version - 0.1
	Created By: Amagida (2017)
*/


// stuff
#include <a_samp>
#include <streamer>
#include <sscanf2>	
#include <YSI\y_hooks>

#define TruckerFuncs:: truckfuncs_

/* USED FUNCS */
stock TruckerFuncs::strmatch(const out1[], const out2[])
{
	if((strcmp(out1, out2, true, strlen(out2)) == 0) && (strlen(out2) == strlen(out1))) return true;
	else return false;
}	


#include "Trucker\utils\factory.pwn"
#include "Trucker\utils\warehouse.pwn"
#include "Trucker\utils\Multiplefuncs.pwn"