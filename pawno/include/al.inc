#if !defined __AL_INC__
	#define __AL_INC__


enum E_LOGLEVEL
{
	NONE = 0,
	DEBUG = 1,
	INFO = 2,
	WARNING = 4,
	ERROR = 8,
	
	ALL = ERROR | WARNING | INFO | DEBUG
};

static logLevel;

native SetLogPluginLogLevel(E_LOGLEVEL:level);


native Logger:CreateLog(const name[], E_LOGLEVEL:level = INFO | WARNING | ERROR, bool:debuginfo = true);
native DestroyLog(Logger:logger);

native SetLogLevel(Logger:logger, E_LOGLEVEL:level);
native bool:IsLogLevel(Logger:logger, E_LOGLEVEL:level);

native Log(Logger:logger, E_LOGLEVEL:level, const msg[], {Float,_}:...);



stock SetLogPluginLogLevel(E_LOGLEVEL:level)
{
	logLevel = level; 
}

stock CreateLog(const name[], E_LOGLEVEL:level = INFO | WARNING | ERROR, bool:debuginfo = true)
{

}














#endif

