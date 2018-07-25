#include <YSI\y_va>




/*===============================================================================

					Main Chat Function

===============================================================================*/


stock ChatMsg(playerid, colour, fmat[], va_args<>)
{
	ChatMsgFlat(playerid, colour, va_return(fmat, va_start<3>));

	return 1;
}

stock ChatMsgAll(colour, fmat[], va_args<>)
{
	ChatMsgAllFlat(colour, va_return(fmat, va_start<2>));

	return 1;
}



/*================================================================================

	Chat Functions Without Formatting No need to use this in sending messages

=================================================================================*/


stock ChatMsgFlat(playerid, colour, string[])
{
	if(strlen(string) > 127)
	{
		new
			string2[128],
			splitpos;

		for(new c = 128; c > 0; c--)
		{
			if(string[c] == ' ' || string[c] ==  ',' || string[c] ==  '.')
			{
				splitpos = c;
				break;
			}
		}

		strcat(string2, string[splitpos]);
		string[splitpos] = EOS;
		
		SendClientMessage(playerid, colour, string);
		SendClientMessage(playerid, colour, string2);
	}
	else
	{
		SendClientMessage(playerid, colour, string);
	}
	
	return 1;
}

stock ChatMsgAllFlat(colour, string[])
{
	if(strlen(string) > 127)
	{
		new
			string2[128],
			splitpos;

		for(new c = 128; c>0; c--)
		{
			if(string[c] == ' ' || string[c] ==  ',' || string[c] ==  '.')
			{
				splitpos = c;
				break;
			}
		}

		strcat(string2, string[splitpos]);
		string[splitpos] = EOS;

		SendClientMessageToAll(colour, string);
		SendClientMessageToAll(colour, string2);
	}
	else
	{
		SendClientMessageToAll(colour, string);
	}

	return 1;
}