/* CMD */
#define CMD:%1(%2)					forward cmd_%1(%2);\
									public cmd_%1(%2)

#define ACMD:%1[%2](%3)				forward acmd_%1_%2(%3);\
									public acmd_%1_%2(%3)

#define SCMD:%1(%2)					forward scmd_%1(%2);\
									public scmd_%1(%2)


public OnPlayerCommandText(playerid, cmdtext[])
{
	new
		cmd[30],
		params[127],
		cmdfunction[64],
		result = 1;

	sscanf(cmdtext, "s[30]s[127]", cmd, params);

	for (new i, j = strlen(cmd); i < j; i++)
		cmd[i] = tolower(cmd[i]);

	format(cmdfunction, 64, "cmd_%s", cmd[1]); 

	if(funcidx(cmdfunction) == -1)
	{
		new
			iLvl = GetPlayerAdminLevel(playerid), 
			iLoop = 5;

		while(iLoop > 0) 
		{
			format(cmdfunction, 64, "acmd_%s_%d", cmd[1], iLoop);

			if(funcidx(cmdfunction) != -1)
				break;

			iLoop--;
		}

		if(iLoop == 0)
			result = 0;
		if(iLvl < iLoop)
			result = 5;
	}
	if(result == 1)
	{
		if(isnull(params))result = CallLocalFunction(cmdfunction, "is", playerid, "\1");
		else result = CallLocalFunction(cmdfunction, "is", playerid, params);
	}

	if(0 < result < 7)
		printf("[COMMAND] [%d]: %s", playerid, cmdtext);

	if		(result == 0) ChatMsg(playerid, COLOR<ORANGE>, "That is not a recognized command. Check the %s/help %sdialog.", SCOLOR<BLUE>, SCOLOR<ORANGE>);
	else if	(result == 1) return 1; // valid command, do nothing.
	else if	(result == 2) ChatMsg(playerid, COLOR<ORANGE>, "You cannot use that command right now.");
	else if	(result == 3) ChatMsg(playerid, COLOR<RED>, "You cannot use that command on that player right now.");
	else if	(result == 4) ChatMsg(playerid, COLOR<RED>, "Invalid ID");
	else if	(result == 5) ChatMsg(playerid, COLOR<RED>, "You have insufficient authority to use that command.");
	else if	(result == 6) ChatMsg(playerid, COLOR<RED>, "You can only use that command while on %s administrator duty %s.", SCOLOR<BLUE>, SCOLOR<RED>);

	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	if(!success)
	{
		new ipstring[16];

		printf("[RCON] Failed login by %s password: %s", ip, password);

		foreach(new i : Player)
		{
			GetPlayerIp(i, ipstring, sizeof(ipstring));

			if(!strcmp(ip, ipstring, true))
				printf(" >  Failed login by %p password: %s", i, password);
		}
	}
	return 1;
}