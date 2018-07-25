/*
	Trucker Job Framework
	Factory Functions
	Last Update 8/31/2017
	Created By Codeah
*/
#include <YSI\y_hooks>

/* FACTORY DEFINES, ENAMATORS, VARIABLES AND FUNCTIONS */

/* DATABASE VARIABLES, DEFINES ENUMATORS */

#define Factory:: Fact_
//

#define MAX_FACTORY 15

/* FACTORY FORWARDS */
forward Factory::Create(name[], Float:outX, Float:outY, Float:outZ, Float:insX, Float:insY, Float:insZ, Float:prodX, Float:prodY, Float:prodZ, products);
forward Factory::OnCreate(factoryid);
forward Factory::GetInfo(factoryid, argument[], out[]);
forward Factory::GetInfoWithReturn(factoryid, argument[]);
forward Factory::Destroy(id);

enum Factory::Factory
{
Float:	Factory::id,
		Factory::Name[164],
Float:	Factory::outsideX,
Float:	Factory::outsideY,
Float:	Factory::outsideZ,
Float:	Factory::insideX,
Float:	Factory::insideY,
Float:	Factory::insideZ,
Float:	Factory::productsX,
Float:	Factory::productsY,
Float:	Factory::productsZ,
		Factory::products,
		Factory::outPickup,
		Factory::insPickup,
		Factory::LinkedTo,
Text3D:	Factory::outLabel				
}

new Factory[MAX_FACTORY][Factory::Factory];

new Factory::Created = 0;

stock Factory::Create(name[], Float:outX, Float:outY, Float:outZ, Float:insX, Float:insY, Float:insZ, Float:prodX, Float:prodY, Float:prodZ, products)
{
	Factory::Created++;
	Factory[Factory::Created][Factory::id] = Factory::Created;
	strcat(Factory[Factory::Created][Factory::Name],  name, 164);
	Factory[Factory::Created][Factory::outsideX] = outX;
	Factory[Factory::Created][Factory::outsideY] = outY;
	Factory[Factory::Created][Factory::outsideZ] = outZ;
	Factory[Factory::Created][Factory::insideX] = insX;
	Factory[Factory::Created][Factory::insideY] = insY;
	Factory[Factory::Created][Factory::insideZ] = insZ;
	Factory[Factory::Created][Factory::productsX] = prodX;
	Factory[Factory::Created][Factory::productsY] = prodY;
	Factory[Factory::Created][Factory::productsZ] = prodZ;
	Factory[Factory::Created][Factory::products] = products;
	Factory[Factory::Created][Factory::outPickup] = CreateDynamicPickup(1318, 23, outX, outY, outZ);
	Factory[Factory::Created][Factory::insPickup] = CreateDynamicPickup(1318, 23, insX, insY, insZ);
	Factory[Factory::Created][Factory::outLabel] = CreateDynamic3DTextLabel(name, 0xFFFF00FF, outX, outY, outZ, 5.0);
	if(funcidx("Fact_OnCreate") != -1) CallLocalFunction("Fact_OnCreate","d",Factory::Created);
	return 1;
}

stock Factory::Destroy(id)
{
	Factory::Created--;
	Factory[id][Factory::outsideX] = 0.0;
	Factory[id][Factory::outsideY] = 0.0;
	Factory[id][Factory::outsideZ] = 0.0;
	Factory[id][Factory::insideX] = 0.0;
	Factory[id][Factory::insideY] = 0.0;
	Factory[id][Factory::insideZ] = 0.0;
	Factory[id][Factory::productsX] = 0.0;
	Factory[id][Factory::productsY] = 0.0;
	Factory[id][Factory::productsZ] = 0.0;
	Factory[id][Factory::products] = 0;
	DestroyDynamicPickup(Factory[id][Factory::outPickup]);
	DestroyDynamicPickup(Factory[id][Facto34ry::insPickup]);
	DestroyDynamic3DTextLabel(Factory[id][Factory::outLabel]);
	return 1;
}

stock Factory::GetInfoWithReturn(factoryid, argument[])
{
	new returnvalue[126];
	if(TruckerFuncs::strmatch(argument, "outX"))
	{
		format(returnvalue, 64, "%f", Factory[factoryid][Factory::outsideX]);
		//strcat(out, out, length);
	}
	if(TruckerFuncs::strmatch(argument, "outY"))
	{
		format(returnvalue, 64, "%f", Factory[factoryid][Factory::outsideY]);
		//strcat(out, out, length);
	}
	if(TruckerFuncs::strmatch(argument, "outZ"))
	{
		format(returnvalue, 64, "%f", Factory[factoryid][Factory::outsideZ]);
		//strcat(out, out, length);
	}		

	if(TruckerFuncs::strmatch(argument, "insX"))
	{
		format(returnvalue, 64, "%f", Factory[factoryid][Factory::insideX]);
		//strcat(out, out, length);
	}
	if(TruckerFuncs::strmatch(argument, "insY"))
	{
		format(returnvalue, 64, "%f", Factory[factoryid][Factory::insideY]);
		//strcat(out, out, length);
	}
	if(TruckerFuncs::strmatch(argument, "insZ"))
	{
		format(returnvalue, 64, "%f", Factory[factoryid][Factory::insideZ]);
		//strcat(out, out, length);
	}
	if(TruckerFuncs::strmatch(argument, "prodX"))
	{
		format(returnvalue, 64, "%f", Factory[factoryid][Factory::productsX]);
		//strcat(out, out, length);
	}
	if(TruckerFuncs::strmatch(argument, "prodY"))
	{
		format(returnvalue, 64, "%f", Factory[factoryid][Factory::productsY]);
		//strcat(out, out, length);
	}
	if(TruckerFuncs::strmatch(argument, "prodZ"))
	{
		format(returnvalue, 64, "%f", Factory[factoryid][Factory::productsZ]);
		//strcat(out, out, length);
	}	
	if(TruckerFuncs::strmatch(argument, "products"))
	{
		format(returnvalue, 64, "%d", Factory[factoryid][Factory::products]);
		//strcat(out, out, length);
	}
	if(TruckerFuncs::strmatch(argument, "name"))
	{
		format(returnvalue, 64, "%s", Factory[factoryid][Factory::Name]);
		//strcat(out, out, length);
	}
	return returnvalue;	
}

stock Factory::GetInfo(factoryid, argument[], out[])
{

	if(TruckerFuncs::strmatch(argument, "outX"))
	{
		format(out, 64, "%f", Factory[factoryid][Factory::outsideX]);
		//strcat(out, out, length);
	}
	if(TruckerFuncs::strmatch(argument, "outY"))
	{
		format(out, 64, "%f", Factory[factoryid][Factory::outsideY]);
		//strcat(out, out, length);
	}
	if(TruckerFuncs::strmatch(argument, "outZ"))
	{
		format(out, 64, "%f", Factory[factoryid][Factory::outsideZ]);
		//strcat(out, out, length);
	}		

	if(TruckerFuncs::strmatch(argument, "insX"))
	{
		format(out, 64, "%f", Factory[factoryid][Factory::insideX]);
		//strcat(out, out, length);
	}
	if(TruckerFuncs::strmatch(argument, "insY"))
	{
		format(out, 64, "%f", Factory[factoryid][Factory::insideY]);
		//strcat(out, out, length);
	}
	if(TruckerFuncs::strmatch(argument, "insZ"))
	{
		format(out, 64, "%f", Factory[factoryid][Factory::insideZ]);
		//strcat(out, out, length);
	}
	if(TruckerFuncs::strmatch(argument, "prodX"))
	{
		format(out, 64, "%f", Factory[factoryid][Factory::productsX]);
		//strcat(out, out, length);
	}
	if(TruckerFuncs::strmatch(argument, "prodY"))
	{
		format(out, 64, "%f", Factory[factoryid][Factory::productsY]);
		//strcat(out, out, length);
	}
	if(TruckerFuncs::strmatch(argument, "prodZ"))
	{
		format(out, 64, "%f", Factory[factoryid][Factory::productsZ]);
		//strcat(out, out, length);
	}	
	if(TruckerFuncs::strmatch(argument, "products"))
	{
		format(out, 64, "%d", Factory[factoryid][Factory::products]);
		//strcat(out, out, length);
	}
	if(TruckerFuncs::strmatch(argument, "name"))
	{
		format(out, 64, "%s", Factory[factoryid][Factory::Name]);
		//strcat(out, out, length);
	}			
}

