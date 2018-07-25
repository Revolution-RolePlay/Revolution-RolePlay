#include <YSI\y_hooks>
#include <YSI\y_va>

#define ALL_TAGS _,Float,Timer,ItemType


#define MAX_LOG_HANDLER				(128)
#define MAX_LOG_HANDLER_NAME		(32)


enum
{
	NONE,
	CORE,
	DEEP,
	LOOP
}

enum e_DEBUG_HANDLER
{
	log_name[MAX_LOG_HANDLER_NAME],
	log_level
}

static
		log_Table[MAX_LOG_HANDLER][e_DEBUG_HANDLER],
		log_Total;


stock log(text[], {ALL_TAGS}:...)
{
	new buffer[256];
	va_format(buffer, sizeof(buffer), text, va_start<1>);
	print(buffer);
}

stock dbg(handler[], level, text[], {ALL_TAGS}:...)
{
	new
		idx = _debug_get_handler_index(handler),
		bt[412];
	if(idx == -1) {
		return;
	}

	if(!GetBacktrace(bt)) {
		print("ERROR GETTING BACKTRACE");
	}

	if(level > log_Table[idx][log_level]) {
		return;
	}

	new buffer[256];
	va_format(buffer, sizeof(buffer), text, va_start<3>);
	print(buffer);
}

stock err(text[], {ALL_TAGS}:...)
{
	new buffer[256];
	va_format(buffer, sizeof(buffer), text, va_start<1>);
	print(buffer);
	PrintAmxBacktrace();
}

stock fatal(text[], {ALL_TAGS}:...)
{
	new buffer[256];
	va_format(buffer, sizeof(buffer), text, va_start<1>);
	print(buffer);
	PrintAmxBacktrace();

	new File:f = fopen("nonexistentfile", io_read), _s[1];
	fread(f, _s);
	fclose(f);
}

_debug_get_handler_index(handler[])
{
	for(new i; i < log_Total; ++i)
	{
		if(!strcmp(handler, log_Table[i][log_name]))
			return i;
	}

	return -1;
}

stock debug_set_level(handler[], level)
{
	new idx = _debug_get_handler_index(handler);

	if(idx == -1)
	{
		log_Table[log_Total][log_level] = level;
		log_Total++;
	}
	else
	{
		log_Table[idx][log_level] = level;
	}

	return 1;
}

stock debug_conditional(handler[], level)
{
	new idx = _debug_get_handler_index(handler);

	if(idx != -1)
		return log_Table[idx][log_level] >= level;

	return 0;
}