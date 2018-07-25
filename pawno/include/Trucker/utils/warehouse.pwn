/*
	Trucker Job Framework
	Warehouse Functions
	Last Update 8/31/2017
	Created By Codeah
*/

#include <YSI\y_hooks>

#define Warehouse:: warehouse_

#define MAX_WAREHOUSE 15

forward Warehouse::Create(name[], Float:outx, Float:outy, Float:outz, Float:insx, Float:insy, Float:insz, Float:whx, Float:why, Float:whz, storage); 
forward Warehouse::AddProducts(factoryid, productsvalue);

enum Warehouse::warehouse
{
		Warehouse::id,
		Warehouse::name[64],
Float:	Warehouse::outX,
Float:	Warehouse::outY,
Float:	Warehouse::outZ,
Float:	Warehouse::insX,
Float:	Warehouse::insY,
Float:	Warehouse::insZ,
Float:	Warehouse::whX,
Float:	Warehouse::whY,
Float:	Warehouse::whZ,
		Warehouse::CP,
		Warehouse::Storage,
		Warehouse::LinkedTo,
		Warehouse::outPickup,
Text3D: 	Warehouse::outLabel,
		Warehouse::insPickup,
		Warehouse::storageLabel
}

new Warehouse[MAX_WAREHOUSE][Warehouse::warehouse];

new Warehouse::Created = 0;

stock Warehouse::Create(name[], Float:outx, Float:outy, Float:outz, Float:insx, Float:insy, Float:insz, Float:whx, Float:why, Float:whz, storage)
{
	Warehouse::Created++;
	Warehouse[Warehouse::Created][Warehouse::id] = Warehouse::Created;
	strcat(Warehouse[Warehouse::Created][Warehouse::name], name, 64);
	Warehouse[Warehouse::Created][Warehouse::outX] = outx;
	Warehouse[Warehouse::Created][Warehouse::outY] = outy;
	Warehouse[Warehouse::Created][Warehouse::outZ] = outz;
	Warehouse[Warehouse::Created][Warehouse::insX] = insx;
	Warehouse[Warehouse::Created][Warehouse::insY] = insy;
	Warehouse[Warehouse::Created][Warehouse::insZ] = insz;
	Warehouse[Warehouse::Created][Warehouse::whX] = whx;
	Warehouse[Warehouse::Created][Warehouse::whY] = why;
	Warehouse[Warehouse::Created][Warehouse::whZ] = whz;
	Warehouse[Warehouse::Created][Warehouse::Storage] = storage;
	Warehouse[Warehouse::Created][Warehouse::outPickup] = CreateDynamicPickup(1318, 23, outx, outy, outz);	
	Warehouse[Warehouse::Created][Warehouse::insPickup] = CreateDynamicPickup(1318, 23, insx, insy, insz);		
	Warehouse[Warehouse::Created][Warehouse::outLabel] = CreateDynamic3DTextLabelEx(name, 0xFFFF00FF, outx, outy, outz, 5.5);					 
	return 1;
}


stock Warehouse::AddProducts(factoryid, productsvalue)
{
	Warehouse[factoryid][Warehouse::Storage] += productsvalue;
	return 1;
}

stock Warehouse::RemoveProducts(factoryid, productsvalue)
{
	Warehouse[factoryid][Warehouse::Storage] -= productsvalue;
	return 1;
}

stock Warehouse::Destroy(factoryid)
{
	Warehouse::Created--;
	Warehouse[factoryid][Warehouse::outX] = 0.0;
	Warehouse[factoryid][Warehouse::outY] = 0.0;
	Warehouse[factoryid][Warehouse::outZ] = 0.0;
	Warehouse[factoryid][Warehouse::insX] = 0.0;
	Warehouse[factoryid][Warehouse::insY] = 0.0;
	Warehouse[factoryid][Warehouse::insZ] = 0.0;
	Warehouse[factoryid][Warehouse::productsX] = 0.0;
	Warehouse[factoryid][Warehouse::productsY] = 0.0;
	Warehouse[factoryid][Warehouse::productsZ] = 0.0;
	Warehouse[factoryid][Warehouse::products] = 0;
	DestroyDynamicPickup(Warehouse[factoryid][Warehouse::outPickup]);
	DestroyDynamicPickup(Warehouse[factoryid][Warehouse::insPickup]);
	DestroyDynamic3DTextLabel(Warehouse[factoryid][Warehouse::outLabel]);	
	return 1;
}