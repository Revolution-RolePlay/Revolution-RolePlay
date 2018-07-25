/*
	Trucker Job Framework
	Multiple Functions
	Last Update 8/31/2017
	Created By Codeah
*/

#include <YSI\y_hooks>

#define MultipleFuncs:: MultipleF_

stock LinkFactoryToWarehouse(factoryid, warehouseid)
{
	Factory[Factory::factoryid][Factory::LinkedTo] = warehouseid;
	Warehouse[Warehouse::warehouseid][Warehouse::LinkedTo] = factoryid;
	return 1;
}	