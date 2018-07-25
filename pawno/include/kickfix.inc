/*
	Script: Kickfix v1.1
	Create by: MacMailler
*/
#if !defined _samp_included
	#error Please include 'a_samp.inc'
#endif
#if defined KICKFIX_INC
	#endinput
#endif
#define KICKFIX_INC

static KickedPlayer[MAX_PLAYERS char]={0, ...};
static BannedReason[MAX_PLAYERS][64];

stock fix_Kick(playerid, delay=100) {
	if(0 <= playerid < MAX_PLAYERS) {
		if(!KickedPlayer{playerid}) {
			KickedPlayer{playerid} = 1;
			return SetTimerEx("onKicked", delay, false, "i", playerid);
		}
	}
	return 0;
}

stock fix_Ban(playerid, delay=100)  {
	if(0 <= playerid < MAX_PLAYERS) {
		if(!KickedPlayer{playerid}) {
			KickedPlayer{playerid} = 2;
			return SetTimerEx("onKicked", delay, false, "i", playerid);
		}
	}
	return 0;
}

stock fix_BanEx(playerid, reason[], delay=100) {
	if(0 <= playerid < MAX_PLAYERS) {
		if(!KickedPlayer{playerid}) {
			KickedPlayer{playerid} = 3;
			strmid(BannedReason[playerid], reason, 0, strlen(reason), 64);
			return SetTimerEx("onKicked", delay, false, "i", playerid);
		}
	}
	return 0;
}

forward onKicked(playerid);
public  onKicked(playerid) {
	switch(KickedPlayer{playerid}) {
		case 1 : Kick(playerid);
		case 2 : Ban(playerid);
		case 3 : BanEx(playerid, BannedReason[playerid]);
	}
	KickedPlayer{playerid} = 0;
	BannedReason[playerid][0] = '\0';
}

#define Ban		fix_Ban
#define Kick	fix_Kick
#define BanEx	fix_BanEx