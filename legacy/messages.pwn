/*
	Improved Messages
	Developer: Amagida
	Version: 0.1
*/	


#include <YSI\y_hooks>
#include <YSI\y_va>

#define IM:: IM_

forward IM::SendClientMessage(playerid, color, const message[], va_args<>);

stock IM::SendClientMessage(playerid, color, const message[], va_args<>)	
{
	return SendClientMessage(playerid, color, va_return(message, va_start<3>));
}

forward IM::SendClientMessageToAll(color, const message[], va_args<>);

stock IM::SendClientMessageToAll(color, const message[], va_args<>)
{
	return SendClientMessageToAll(color, va_return(message, va_start<2>));
}

forward IM::Print(const title[], const text[], va_args<>);

stock IM::Print(const title[], const text[], va_args<>)
{
	new string[265];
	format(string, sizeof(string), "[%s] %s", title, text);
	return print(va_return(string, va_start<2>));
}

forward IM::PrintF(File:file, const title, const text[], va_args<>);

stock IM::PrintF(File:file, const title, const text[], va_args<>)
{
	new test
	new string[265];
	format(string, sizeof(string), "[%s] %s", title, text);
	return fwrite(file, va_return(string, va_start<3>)
}