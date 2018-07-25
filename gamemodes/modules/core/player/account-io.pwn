#include <YSI\y_hooks>

hook OnScriptInit()
{
	debug_set_level("modules/core/player/account-io", 1);   
	return 1;	
}

stock DB_SetFieldInt(DB:database, table[], field[], where[], forr[], value)
{
	new Query[164];
	format(Query, sizeof(Query), "UPDATE `%s` SET %s = '%d' WHERE `%s` = '%s'", table, field, value, where, forr);
	db_query(database, Query);
	dbg("modules/core/player/account-io", 1, Query);
}

stock DB_SetFieldFloat(DB:database, table[], field[], where[], forr[], Float:value)
{
	new Query[164];
	format(Query, sizeof(Query), "UPDATE `%s` SET %s = '%f' WHERE `%s` = '%s'", table, field, value, where, forr);
	db_query(database, Query);
	dbg("modules/core/player/account-io", 1, Query);
}

stock DB_SetFieldString(DB:database, table[], field[], where[], forr[], value[])
{
	new Query[164];
	format(Query, sizeof(Query), "UPDATE `%s` SET %s = '%s' WHERE `%s` = '%s'", table, field, value, where, forr);
	db_query(database, Query);
	dbg("modules/core/player/account-io", 1, Query);
}