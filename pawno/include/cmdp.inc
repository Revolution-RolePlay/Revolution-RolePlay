/*
	Command Processor ~ Kevin-Reinke

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

#if defined _cmdp_included
	#endinput
#endif

#define _cmdp_included

#if !defined sscanf
	#error "SSCANF could not be found"
#endif

#if !defined isnull
	#define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

#if defined OnPlayerCommandReceived
	forward OnPlayerCommandReceived(playerid, cmd[], params[]);
#endif

#if defined OnPlayerCommandPerformed
	forward OnPlayerCommandPerformed(playerid, cmd[], params[], success);
#endif

// ** DEFINES

// *** FUNCTIONS

#define CMD:%1<%2> forward cmd_%1(%2); public cmd_%1(%2)
#define COMMAND:%1<%2> forward cmd_%1(%2); public cmd_%1(%2)
#define cmd<%1,%2> forward cmd_%1(%2); public cmd_%1(%2)
#define command<%1,%2> forward cmd_%1(%2); public cmd_%1(%2)

// ** CALLBACKS

public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmd[32] = "cmd_", params[126];
	sscanf(cmdtext[1], "s[28]s[126]", cmd[4], params);

	switch(strlen(cmd[4]))
	{
		case 27:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20,
			cmd[13] |= 0x20,
			cmd[14] |= 0x20,
			cmd[15] |= 0x20,
			cmd[16] |= 0x20,
			cmd[17] |= 0x20,
			cmd[18] |= 0x20,
			cmd[19] |= 0x20,
			cmd[20] |= 0x20,
			cmd[21] |= 0x20,
			cmd[22] |= 0x20,
			cmd[23] |= 0x20,
			cmd[24] |= 0x20,
			cmd[25] |= 0x20,
			cmd[26] |= 0x20,
			cmd[27] |= 0x20,
			cmd[28] |= 0x20,
			cmd[29] |= 0x20,
			cmd[30] |= 0x20;
		}
		case 26:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20,
			cmd[13] |= 0x20,
			cmd[14] |= 0x20,
			cmd[15] |= 0x20,
			cmd[16] |= 0x20,
			cmd[17] |= 0x20,
			cmd[18] |= 0x20,
			cmd[19] |= 0x20,
			cmd[20] |= 0x20,
			cmd[21] |= 0x20,
			cmd[22] |= 0x20,
			cmd[23] |= 0x20,
			cmd[24] |= 0x20,
			cmd[25] |= 0x20,
			cmd[26] |= 0x20,
			cmd[27] |= 0x20,
			cmd[28] |= 0x20,
			cmd[29] |= 0x20;
		}
		case 25:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20,
			cmd[13] |= 0x20,
			cmd[14] |= 0x20,
			cmd[15] |= 0x20,
			cmd[16] |= 0x20,
			cmd[17] |= 0x20,
			cmd[18] |= 0x20,
			cmd[19] |= 0x20,
			cmd[20] |= 0x20,
			cmd[21] |= 0x20,
			cmd[22] |= 0x20,
			cmd[23] |= 0x20,
			cmd[24] |= 0x20,
			cmd[25] |= 0x20,
			cmd[26] |= 0x20,
			cmd[27] |= 0x20,
			cmd[28] |= 0x20;
		}
		case 24:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20,
			cmd[13] |= 0x20,
			cmd[14] |= 0x20,
			cmd[15] |= 0x20,
			cmd[16] |= 0x20,
			cmd[17] |= 0x20,
			cmd[18] |= 0x20,
			cmd[19] |= 0x20,
			cmd[20] |= 0x20,
			cmd[21] |= 0x20,
			cmd[22] |= 0x20,
			cmd[23] |= 0x20,
			cmd[24] |= 0x20,
			cmd[25] |= 0x20,
			cmd[26] |= 0x20,
			cmd[27] |= 0x20;
		}
		case 23:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20,
			cmd[13] |= 0x20,
			cmd[14] |= 0x20,
			cmd[15] |= 0x20,
			cmd[16] |= 0x20,
			cmd[17] |= 0x20,
			cmd[18] |= 0x20,
			cmd[19] |= 0x20,
			cmd[20] |= 0x20,
			cmd[21] |= 0x20,
			cmd[22] |= 0x20,
			cmd[23] |= 0x20,
			cmd[24] |= 0x20,
			cmd[25] |= 0x20,
			cmd[26] |= 0x20;
		}
		case 22:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20,
			cmd[13] |= 0x20,
			cmd[14] |= 0x20,
			cmd[15] |= 0x20,
			cmd[16] |= 0x20,
			cmd[17] |= 0x20,
			cmd[18] |= 0x20,
			cmd[19] |= 0x20,
			cmd[20] |= 0x20,
			cmd[21] |= 0x20,
			cmd[22] |= 0x20,
			cmd[23] |= 0x20,
			cmd[24] |= 0x20,
			cmd[25] |= 0x20;
		}
		case 21:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20,
			cmd[13] |= 0x20,
			cmd[14] |= 0x20,
			cmd[15] |= 0x20,
			cmd[16] |= 0x20,
			cmd[17] |= 0x20,
			cmd[18] |= 0x20,
			cmd[19] |= 0x20,
			cmd[20] |= 0x20,
			cmd[21] |= 0x20,
			cmd[22] |= 0x20,
			cmd[23] |= 0x20,
			cmd[24] |= 0x20;
		}
		case 20:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20,
			cmd[13] |= 0x20,
			cmd[14] |= 0x20,
			cmd[15] |= 0x20,
			cmd[16] |= 0x20,
			cmd[17] |= 0x20,
			cmd[18] |= 0x20,
			cmd[19] |= 0x20,
			cmd[20] |= 0x20,
			cmd[21] |= 0x20,
			cmd[22] |= 0x20,
			cmd[23] |= 0x20;
		}
		case 19:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20,
			cmd[13] |= 0x20,
			cmd[14] |= 0x20,
			cmd[15] |= 0x20,
			cmd[16] |= 0x20,
			cmd[17] |= 0x20,
			cmd[18] |= 0x20,
			cmd[19] |= 0x20,
			cmd[20] |= 0x20,
			cmd[21] |= 0x20,
			cmd[22] |= 0x20;
		}
		case 18:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20,
			cmd[13] |= 0x20,
			cmd[14] |= 0x20,
			cmd[15] |= 0x20,
			cmd[16] |= 0x20,
			cmd[17] |= 0x20,
			cmd[18] |= 0x20,
			cmd[19] |= 0x20,
			cmd[20] |= 0x20,
			cmd[21] |= 0x20;
		}
		case 17:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20,
			cmd[13] |= 0x20,
			cmd[14] |= 0x20,
			cmd[15] |= 0x20,
			cmd[16] |= 0x20,
			cmd[17] |= 0x20,
			cmd[18] |= 0x20,
			cmd[19] |= 0x20,
			cmd[20] |= 0x20;
		}
		case 16:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20,
			cmd[13] |= 0x20,
			cmd[14] |= 0x20,
			cmd[15] |= 0x20,
			cmd[16] |= 0x20,
			cmd[17] |= 0x20,
			cmd[18] |= 0x20,
			cmd[19] |= 0x20;
		}
		case 15:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20,
			cmd[13] |= 0x20,
			cmd[14] |= 0x20,
			cmd[15] |= 0x20,
			cmd[16] |= 0x20,
			cmd[17] |= 0x20,
			cmd[18] |= 0x20;
		}
		case 14:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20,
			cmd[13] |= 0x20,
			cmd[14] |= 0x20,
			cmd[15] |= 0x20,
			cmd[16] |= 0x20,
			cmd[17] |= 0x20;
		}
		case 13:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20,
			cmd[13] |= 0x20,
			cmd[14] |= 0x20,
			cmd[15] |= 0x20,
			cmd[16] |= 0x20;
		}
		case 12:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20,
			cmd[13] |= 0x20,
			cmd[14] |= 0x20,
			cmd[15] |= 0x20;
		}
		case 11:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20,
			cmd[13] |= 0x20,
			cmd[14] |= 0x20;
		}
		case 10:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20,
			cmd[13] |= 0x20;
		}
		case 9:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20,
			cmd[12] |= 0x20;
		}
		case 8:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20,
			cmd[11] |= 0x20;
		}
		case 7:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20,
			cmd[10] |= 0x20;
		}
		case 6:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20,
			cmd[9] |= 0x20;
		}
		case 5:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20,
			cmd[8] |= 0x20;
		}
		case 4:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20,
			cmd[7] |= 0x20;
		}
		case 3:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20,
			cmd[6] |= 0x20;
		}
		case 2:
		{
			cmd[4] |= 0x20,
			cmd[5] |= 0x20;
		}
		case 1:
		{
			cmd[4] |= 0x20;
		}
	}

	#if defined OnPlayerCommandReceived
		if(!OnPlayerCommandReceived(playerid, cmd[4], params)) return 1;
	#endif

	#if defined OnPlayerCommandPerformed
		return OnPlayerCommandPerformed(playerid, cmd[4], params, CallLocalFunction(cmd, "is", playerid, params));
	#else
		return CallLocalFunction(cmd, "is", playerid, params);
	#endif
}