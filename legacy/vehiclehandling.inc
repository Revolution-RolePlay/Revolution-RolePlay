/*
	Vehicle Handling
	Last Update 9/11/2017
	Author: Codeah/Amagida
*/
	
/*
FUNCTIONS:
native CreateVehicle(modelid, Float:x, Float:y, Float:z, Float:rotation, color1 = -1, color2 = -1, respawn_delay = -1, addsiren = 0, worldid = 0, interiorid = 0, bool:unoccupied_damage = false);
native GetVehicleInterior(vehicleid);
native GetVehicleColor(vehicleid, &color1, &color2);
native GetVehiclePaintjob(vehicleid);
native RemoveVehiclePaintjob(vehicleid);
native SetVehicleHorn(vehicleid, soundid);
native GetVehicleHorn(vehicleid);
native RestoreVehicleHorn(vehicleid);
native ToggleVehicleDamageUpdate(vehicleid, type, bool:toggle);
native IsVehicleDamageToggled(vehicleid, type);
native UpdateVehicleDamageStatusEx(vehicleid, type, update);
native GetVehicleDamageStatusEx(vehicleid, type);
native IsVehicleOccupied(vehicleid);
native GetVehicleDriverID(vehicleid);
native EditVehicle(playerid, vehicleid);
native IsValidVehicle(vehicleid);
native GetVehicleName(vehicleid, string[], len = sizeof(string));
native GetVehicleModelName(modelid, string[], len = sizeof(string));
native SetVehicleParams(vehicleid, type, set);
native GetVehicleParams(vehicleid, type);
native Float:GetVehicleSpeed(vehicleid, bool:kmh = true, Float:velx = 0.0, Float:vely = 0.0, Float:velz = 0.0);
native IsObjectAttachedToVehicle(objectid, vehicleid);
native GetVehicleSlotAttachedObject(vehicleid, slot);
native TeleportVehicle(vehicleid, Float:x, Float:y, Float:z, Float:rotation, worldid = -1, interiorid = -1);
native SetVehicleSpeedCap(vehicleid, Float:maxspeed);
native Float:GetVehicleSpeedCap(vehicleid);
native DisableVehicleSpeedCap(vehicleid);
native GetVehicleTopSpeed(vehicleid);
native GetVehicleModelTopSpeed(modelid);
native SetVehicleSpawnInfo(vehicleid, Float:x, Float:y, Float:z, Float:rotation, worldid, interiorid);
native GetVehicleSpawnInfo(vehicleid, &Float:x, &Float:y, &Float:z, &Float:rotation, &worldid, &interiorid);
native ToggleUnoccupiedVehicleDamage(vehicleid, bool:toggle);
native IsUnoccupiedDamageToggled(vehicleid);
native ToggleVehiclePetrolCapDestroy(vehicleid, bool:toggle);
native IsPetrolCapDestroyToggled(vehicleid);
native SetVehicleBomb(vehicleid, time = 1000);
native GetVehicleBomb(vehicleid);
native RemoveVehicleBomb(vehicleid);
native IsVehicleBombed(vehicleid);
native IsVehicleBombActivated(vehicleid);
native ToggleVehicleSticky(vehicleid, bool:toggle);
native IsVehicleSticky(vehicleid);
native CountAllVehicles();
native DestroyAllVehicles();

CALLBACKS:
public OnPlayerShotVehicle(playerid, vehicleid, weaponid, Float:amount, bodypart)
public OnPlayerEditVehicle(playerid, vehicleid, response, Float:fX, Float:fY, Float:fZ, Float:fRotZ)
public OnPlayerReachSpeedCapLimit(playerid, vehicleid, Float:speed)
public OnVehicleBombActivate(vehicleid)
public OnVehicleBombDeactivate(vehicleid)
public OnVehicleBombExplode(vehicleid)
public OnVehiclePosChange(vehicleid, Float:newx, Float:newy, Float:newz, Float:newrotation, Float:oldx, Float:oldy, Float:oldz, Float:oldrotation)
public OnVehicleVelocityChange(vehicleid, Float:newx, Float:newy, Float:newz, Float:oldx, Float:oldy, Float:oldz)
public OnVehicleHealthChange(vehicleid, Float:newhealth, Float:oldhealth)
*/

#define VEHICLE_DAMAGE_PANELS       			0
#define VEHICLE_DAMAGE_DOORS        			1
#define VEHICLE_DAMAGE_LIGHTS					2
#define VEHICLE_DAMAGE_TIRES  					3

#define VEHICLE_BODYPART_FRONT_LEFT_WHEEL   	0
#define VEHICLE_BODYPART_FRONT_RIGHT_WHEEL    	1
#define VEHICLE_BODYPART_BACK_LEFT_WHEEL   		2
#define VEHICLE_BODYPART_BACK_RIGHT_WHEEL    	3
#define VEHICLE_BODYPART_PETROLCAP      		4
#define VEHICLE_BODYPART_UNKNOWN                5

#define VEHICLE_PARAMS_ENGINE      				0
#define VEHICLE_PARAMS_LIGHTS      				1
#define VEHICLE_PARAMS_ALARM       				2
#define VEHICLE_PARAMS_DOORS       				3
#define VEHICLE_PARAMS_BONNET      				4
#define VEHICLE_PARAMS_BOOT       				5
#define VEHICLE_PARAMS_OBJECTIVE   				6

#if ! defined MAX_VEHICLE_ATTACHED_OBJECTS
	#define MAX_VEHICLE_ATTACHED_OBJECTS    	30
#endif

#define MAX_VEHICLE_MODELS              		212

#define VEHICLE_UPDATE_INTERVAL				250

static gPlayerEdit[MAX_PLAYERS] = INVALID_VEHICLE_ID;

static gVehicleAttachedObject[MAX_VEHICLES][MAX_VEHICLE_ATTACHED_OBJECTS];

static Float:gVehicleFloat[MAX_VEHICLES][4 + 3 + 1];

stock static const gVehicleNames[MAX_VEHICLE_MODELS][] =
{
	"Landstalker",
	"Bravura",
	"Buffalo",
	"Linerunner",
	"Perrenial",
	"Sentinel",
	"Dumper",
	"Firetruck",
	"Trashmaster",
	"Stretch",
	"Manana",
	"Infernus",
	"Voodoo",
	"Pony",
	"Mule",
	"Cheetah",
	"Ambulance",
	"Leviathan",
	"Moonbeam",
	"Esperanto",
	"Taxi",
	"Washington",
	"Bobcat",
	"Mr Whoopee",
	"BF Injection",
	"Hunter",
	"Premier",
	"Enforcer",
	"Securicar",
	"Banshee",
	"Predator",
	"Bus",
	"Rhino",
	"Barracks",
	"Hotknife",
	"Trailer 1",
	"Previon",
	"Coach",
	"Cabbie",
	"Stallion",
	"Rumpo",
	"RC Bandit",
	"Romero",
	"Packer",
	"Monster",
	"Admiral",
	"Squalo",
	"Seasparrow",
	"Pizzaboy",
	"Tram",
	"Trailer 2",
	"Turismo",
	"Speeder",
	"Reefer",
	"Tropic",
	"Flatbed",
	"Yankee",
	"Caddy",
	"Solair",
	"Berkley's RC Van",
	"Skimmer",
	"PCJ-600",
	"Faggio",
	"Freeway",
	"RC Baron",
	"RC Raider",
	"Glendale",
	"Oceanic",
	"Sanchez",
	"Sparrow",
	"Patriot",
	"Quad",
	"Coastguard",
	"Dinghy",
	"Hermes",
	"Sabre",
	"Rustler",
	"ZR-350",
	"Walton",
	"Regina",
	"Comet",
	"BMX",
	"Burrito",
	"Camper",
	"Marquis",
	"Baggage",
	"Dozer",
	"Maverick",
	"News Chopper",
	"Rancher",
	"FBI Rancher",
	"Virgo",
	"Greenwood",
	"Jetmax",
	"Hotring",
	"Sandking",
	"Blista Compact",
	"Police Maverick",
	"Boxville","Benson",
	"Mesa",
	"RC Goblin",
	"Hotring Racer A",
	"Hotring Racer B",
	"Bloodring Banger",
	"Rancher",
	"Super GT",
	"Elegant",
	"Journey",
	"Bike",
	"Mountain Bike",
	"Beagle",
	"Cropdust",
	"Stunt",
	"Tanker",
	"Roadtrain",
	"Nebula",
	"Majestic",
	"Buccaneer",
	"Shamal",
	"Hydra",
	"FCR-900",
	"NRG-500",
	"HPV1000",
	"Cement Truck",
	"Tow Truck",
	"Fortune",
	"Cadrona",
	"FBI Truck",
	"Willard",
	"Forklift",
	"Tractor",
	"Combine",
	"Feltzer",
	"Remington",
	"Slamvan",
	"Blade",
	"Freight",
	"Streak",
	"Vortex",
	"Vincent",
	"Bullet",
	"Clover",
	"Sadler",
	"Firetruck LA",
	"Hustler",
	"Intruder",
	"Primo",
	"Cargobob",
	"Tampa",
	"Sunrise",
	"Merit",
	"Utility",
	"Nevada",
	"Yosemite",
	"Windsor",
	"Monster A",
	"Monster B",
	"Uranus","Jester",
	"Sultan",
	"Stratum",
	"Elegy",
	"Raindance",
	"RC Tiger",
	"Flash",
	"Tahoma",
	"Savanna",
	"Bandito",
	"Freight Flat",
	"Streak Carriage",
	"Kart","Mower",
	"Duneride",
	"Sweeper",
	"Broadway",
	"Tornado",
	"AT-400",
	"DFT-30",
	"Huntley",
	"Stafford",
	"BF-400",
	"Newsvan",
	"Tug",
	"Trailer 3",
	"Emperor",
	"Wayfarer",
	"Euros",
	"Hotdog",
	"Club",
	"Freight Carriage",
	"Trailer 3",
	"Andromada",
	"Dodo",
	"RC Cam",
	"Launch",
	"Police Car (LSPD)",
	"Police Car (SFPD)",
	"Police Car (LVPD)",
	"Police Ranger",
	"Picador",
	"S.W.A.T. Van",
	"Alpha",
	"Phoenix",
	"Glendale",
	"Sadler",
	"Luggage Trailer A",
	"Luggage Trailer B",
	"Stair Trailer",
	"Boxville",
	"Farm Plow",
	"Utility Trailer"
};

stock static const Float:gVehiclePetrolCapOffsets[MAX_VEHICLE_MODELS][3] =
{
	{-1.06,		-2.07,		-0.03},
	{1.25,		-0.91,		0.05},
	{1.11,		-1.92,		0.17},
	{-1.46,		0.02,		-0.66},
	{-1.03,		-2.37,		0.06},
	{-0.86,		-2.16,		-0.08},
	{0.00,		0.00,		0.00},
	{-1.07,		-3.74,		-0.42},
	{-1.46,		1.24,		-0.57},
	{-1.04,		-2.82,		0.14},
	{-0.96,		-1.66,		0.23},
	{1.06,		-2.10,		0.09},
	{0.00,		0.00,		0.00},
	{-0.46,		0.53,		-0.79},
	{-0.66,		-0.71,		-0.70},
	{-1.07,		-2.06,		0.05},
	{-1.16,		-2.72,		-0.21},
	{0.00,		0.00,		0.00},
	{-1.24,		-1.76,		0.03},
	{-1.09,		-1.99,		0.06},
	{-1.03,		-2.14,		0.08},
	{-1.02,		-2.43,		-0.14},
	{-0.93,		-0.41,		-0.19},
	{-1.13,		-1.90,		-0.28},
	{-1.11,		-0.54,		-0.10},
	{0.00,		0.00,		0.00},
	{-1.00,		-2.16,		0.06},
	{-1.27,		-3.18,		-0.18},
	{-1.01,		-2.65,		-0.56},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{-1.32,		-5.47,		-0.12},
	{0.00,		0.00,		0.00},
	{-1.51,		0.15,		-0.67},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{-1.02,		-1.81,		0.16},
	{-1.24,		-4.98,		-0.51},
	{-1.06,		-1.93,		-0.00},
	{-1.07,		-1.50,		0.07},
	{-0.89,		-0.47,		-0.46},
	{0.00,		0.00,		0.00},
	{-1.17,		-2.20,		0.08},
	{-1.24,		1.25,		-0.91},
	{0.00,		0.00,		0.00},
	{-1.07,		-1.95,		0.13},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{1.08,		-1.21,		-0.03},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{-1.52,		0.00,		-0.74},
	{0.73,		-0.05,		-0.59},
	{0.00,		0.00,		0.00},
	{-1.11,		-2.04,		-0.09},
	{-0.97,		-2.30,		0.21},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{-0.25,		0.20,		-0.17},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{-0.92,		-2.30,		0.08},
	{-0.07,		0.17,		0.69},
	{0.00,		0.00,		0.00},
	{-1.17,		-2.37,		0.24},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{-1.09,		-1.60,		0.13},
	{0.00,		0.00,		0.00},
	{-1.03,		-1.52,		0.15},
	{1.01,		-0.33,		0.23},
	{-1.09,		-1.98,		0.09},
	{-1.12,		-0.88,		0.14},
	{0.00,		0.00,		0.00},
	{1.03,		-2.26,		0.00},
	{0.80,		-2.50,		-0.05},
	{0.00,		0.00,		0.00},
	{-0.88,		0.71,		0.03},
	{-0.66,		-3.17,		0.58},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{1.22,		-0.74,		0.02},
	{0.00,		0.00,		0.00},
	{-1.05,		-2.18,		0.02},
	{-1.07,		-2.09,		0.17},
	{0.00,		0.00,		0.00},
	{-1.00,		-2.20,		0.14},
	{1.16,		-1.91,		-0.11},
	{1.08,		-1.83,		0.15},
	{0.00,		0.00,		0.00},
	{-1.21,		-0.01,		0.09},
	{-1.19,		-1.09,		-0.31},
	{-0.91,		-1.70,		-0.06},
	{0.00,		0.00,		0.00},
	{-0.96,		-1.88,		0.13},
	{-0.98,		-2.03,		0.04},
	{-1.14,		-1.82,		0.13},
	{1.22,		-0.74,		0.00},
	{0.96,		-1.11,		-0.11},
	{-1.08,		-2.30,		0.08},
	{-1.35,		-3.05,		-0.67},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{-1.50,		-0.88,		-0.24},
	{-1.08,		0.51,		-1.43},
	{-1.13,		-2.44,		-0.01},
	{-1.11,		-1.95,		0.08},
	{1.09,		-2.19,		-0.08},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{-0.17,		0.13,		0.52},
	{-0.14,		0.18,		0.53},
	{-0.18,		0.24,		0.49},
	{1.24,		0.46,		-1.06},
	{-1.31,		-0.50,		-0.07},
	{-0.94,		-1.94,		0.05},
	{-1.13,		-1.70,		0.16},
	{-0.51,		-2.07,		0.01},
	{-1.15,		-2.20,		0.22},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		-2.43,		-0.91},
	{0.91,		-1.97,		0.11},
	{-1.01,		-0.83,		-0.20},
	{-1.13,		-0.55,		0.28},
	{-0.98,		-1.69,		0.06},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{-1.23,		-2.51,		-0.03},
	{0.00,		0.00,		0.00},
	{-0.97,		-1.92,		0.31},
	{-0.96,		-0.94,		-0.01},
	{-1.15,		2.04,		0.32},
	{0.00,		0.00,		0.00},
	{1.22,		-1.99,		0.16},
	{-1.09,		-2.00,		0.13},
	{0.00,		0.00,		0.00},
	{-0.89,		-1.14,		0.18},
	{-1.10,		-2.40,		-0.02},
	{-1.03,		-2.66,		0.07},
	{-0.95,		-0.94,		0.45},
	{0.00,		0.00,		0.00},
	{1.27,		-2.37,		0.13},
	{-0.80,		-1.47,		0.17},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{-0.84,		-1.92,		0.23},
	{-1.01,		-1.76,		0.25},
	{0.98,		-1.83,		0.20},
	{1.13,		-2.28,		0.11},
	{0.93,		-0.71,		0.05},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.95,		-0.86,		0.09},
	{1.18,		-2.26,		0.06},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.62,		-0.37,		0.46},
	{-0.35,		-1.03,		0.24},
	{0.00,		0.00,		0.00},
	{-0.59,		-0.94,		0.26},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{-1.33,		2.89,		-0.02},
	{1.13,		-2.29,		0.16},
	{1.23,		-1.77,		0.29},
	{-0.22,		0.01,		0.54},
	{-0.90,		0.15,		-0.32},
	{-0.62,		0.37,		-0.12},
	{0.00,		0.00,		0.00},
	{1.07,		-2.29,		0.20},
	{0.00,		0.00,		0.00},
	{-1.22,		-1.21,		0.12},
	{-1.20,		-2.12,		0.23},
	{0.98,		-0.89,		0.10},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{-0.97,		-2.16,		0.06},
	{-1.02,		-2.16,		0.07},
	{-1.08,		-1.95,		0.18},
	{0.00,		0.00,		0.00},
	{0.95,		-2.01,		0.06},
	{-1.36,		-1.69,		0.92},
	{0.97,		-1.95,		0.08},
	{1.24,		-2.20,		-0.04},
	{0.00,		0.00,		0.00},
	{-0.95,		-0.93,		-0.02},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00},
	{0.00,		0.00		,0.00},
	{-1.26,		-0.03,		0.09},
	{0.00,		0.00,		0.00},
	{0.00,		0.00,		0.00}
};

stock static const gVehicleColors[MAX_VEHICLE_MODELS][] =
{
    {16, 004, 001, 123, 001, 113, 001, 101, 001, 075, 001, 062, 001, 040, 001, 036, 001},
    {16, 041, 041, 047, 047, 052, 052, 066, 066, 074, 074, 087, 087, 091, 091, 113, 113},
    {16, 010, 010, 013, 013, 022, 022, 030, 030, 039, 039, 090, 090, 098, 098, 110, 110},
    {16, 036, 001, 037, 001, 030, 001, 028, 001, 025, 001, 040, 001, 101, 001, 113, 001},
    {16, 113, 039, 119, 050, 123, 092, 109, 100, 101, 101, 095, 105, 083, 110, 066, 025},
    {16, 011, 001, 024, 001, 036, 001, 040, 001, 075, 001, 091, 001, 123, 001, 004, 001},
    {2,  001, 001},
    {2,  003, 001},
    {2,  026, 026},
    {2,  001, 001},
    {16, 004, 001, 009, 001, 010, 001, 025, 001, 036, 001, 040, 001, 045, 001, 084, 001},
    {16, 012, 001, 064, 001, 123, 001, 116, 001, 112, 001, 106, 001, 080, 001, 075, 001},
    {16, 009, 001, 010, 008, 011, 001, 025, 008, 027, 001, 029, 008, 030, 001, 037, 008},
    {16, 087, 001, 088, 001, 091, 001, 105, 001, 109, 001, 119, 001, 004, 001, 025, 001},
    {16, 025, 001, 028, 001, 043, 001, 067, 001, 072, 001, 009, 001, 095, 001, 024, 001},
    {16, 020, 001, 025, 001, 036, 001, 040, 001, 062, 001, 075, 001, 092, 001, 000, 001},
    {2,  001, 003},
    {0,  000, 000},
    {16, 119, 119, 117, 227, 114, 114, 108, 108, 095, 095, 081, 081, 061, 061, 041, 041},
    {16, 045, 075, 047, 076, 033, 075, 013, 076, 054, 075, 069, 076, 059, 075, 087, 076},
    {2,  006, 001},
    {16, 004, 001, 013, 001, 025, 001, 030, 001, 036, 001, 040, 001, 075, 001, 095, 001},
    {14, 096, 025, 097, 025, 101, 025, 111, 031, 113, 036, 083, 057, 067, 059},
    {12, 001, 016, 001, 056, 001, 017, 001, 053, 001, 005, 001, 035},
    {16, 001, 000, 002, 002, 003, 002, 003, 006, 006, 016, 015, 030, 024, 053, 035, 061},
    {2,  043, 000},
    {16, 037, 037, 042, 042, 053, 053, 062, 062, 007, 007, 010, 010, 011, 011, 015, 015},
    {2,  000, 001},
    {2,  004, 075},
    {16, 012, 012, 013, 013, 014, 014, 001, 002, 002, 001, 001, 003, 003, 001, 010, 010},
    {2,  046, 026},
    {16, 071, 059, 075, 059, 092, 072, 047, 074, 055, 083, 059, 083, 071, 087, 082, 087},
    {2,  043, 000},
    {2,  043, 000},
    {14, 001, 001, 012, 012, 002, 002, 006, 006, 004, 004, 046, 046, 053, 053},
    {2,  001, 001},
    {14, 083, 001, 087, 001, 092, 001, 095, 001, 109, 001, 119, 045, 011, 001},
    {16, 054, 007, 079, 007, 087, 007, 095, 016, 098, 020, 105, 020, 123, 020, 125, 021},
    {2,  006, 076},
    {16, 057, 008, 008, 017, 043, 021, 054, 038, 067, 008, 037, 078, 065, 079, 025, 078},
    {16, 034, 034, 032, 032, 020, 020, 110, 110, 066, 066, 084, 084, 118, 118, 121, 121},
    {16, 002, 096, 079, 042, 082, 054, 067, 086, 126, 096, 070, 096, 110, 054, 067, 098},
    {16, 000, 000, 011, 105, 025, 109, 036, 000, 040, 036, 075, 036, 000, 036, 000, 109},
    {16, 004, 001, 020, 001, 024, 001, 025, 001, 036, 001, 040, 001, 054, 001, 084, 001},
    {12, 032, 036, 032, 042, 032, 053, 032, 066, 032, 014, 032, 032},
    {16, 034, 034, 035, 035, 037, 037, 039, 039, 041, 041, 043, 043, 045, 045, 047, 047},
    {32, 000, 000, 000, 001, 001, 005, 001, 001, 003, 003, 000, 001, 001, 022, 001, 001, 001, 035, 001, 001, 001, 044, 001, 001, 001, 053, 001, 001, 001, 057, 001, 001},
    {2,  075, 002},
    {2,  001, 003},
    {2,  001, 074},
    {2,  001, 001},
    {16, 123, 123, 125, 125, 036, 036, 016, 016, 018, 018, 046, 046, 061, 061, 075, 075},
    {16, 001, 003, 001, 005, 001, 016, 001, 022, 001, 035, 001, 044, 001, 053, 001, 057},
    {2,  056, 056},
    {2,  026, 026},
    {16, 084, 015, 084, 058, 084, 031, 032, 074, 043, 031, 001, 031, 077, 031, 032, 074},
    {16, 084, 063, 091, 063, 102, 065, 105, 072, 110, 093, 121, 093, 012, 095, 023, 001},
    {16, 058, 001, 002, 001, 063, 001, 018, 001, 032, 001, 045, 001, 013, 001, 034, 001},
    {16, 091, 001, 101, 001, 109, 001, 113, 001, 004, 001, 025, 001, 030, 001, 036, 001},
    {16, 026, 026, 028, 028, 044, 044, 051, 051, 057, 057, 072, 072, 106, 106, 112, 112},
    {16, 001, 003, 001, 009, 001, 018, 001, 030, 017, 023, 046, 023, 046, 032, 057, 034},
    {16, 036, 001, 037, 001, 043, 001, 053, 001, 061, 001, 075, 001, 079, 001, 088, 001},
    {16, 012, 012, 013, 013, 014, 014, 001, 002, 002, 001, 001, 003, 003, 001, 010, 010},
    {16, 079, 079, 084, 084, 007, 007, 011, 011, 019, 019, 022, 022, 036, 036, 053, 053},
    {2,  014, 075},
    {2,  014, 075},
    {16, 067, 076, 068, 076, 078, 076, 002, 076, 016, 076, 018, 076, 025, 076, 045, 088},
    {16, 051, 001, 058, 008, 060, 001, 068, 008, 002, 001, 013, 008, 022, 001, 036, 008},
    {8,  006, 006, 046, 046, 053, 053, 003, 003},
    {0,  000, 000},
    {2,  043, 000},
    {16, 120, 117, 103, 111, 120, 114, 074, 091, 120, 112, 074, 083, 120, 113, 066, 071},
    {4,  056, 015, 056, 053},
    {4,  056, 015, 056, 053},
    {16, 097, 001, 081, 001, 105, 001, 110, 001, 091, 001, 074, 001, 084, 001, 083, 001},
    {16, 002, 039, 009, 039, 017, 001, 021, 001, 033, 000, 037, 000, 041, 029, 056, 029},
    {16, 006, 007, 007, 006, 001, 006, 089, 091, 119, 117, 103, 102, 077, 087, 071, 077},
    {16, 092, 001, 094, 001, 101, 001, 121, 001, 000, 001, 022, 001, 036, 001, 075, 001},
    {16, 072, 001, 066, 001, 059, 001, 045, 001, 040, 001, 039, 001, 035, 001, 020, 001},
    {16, 027, 036, 059, 036, 060, 035, 055, 041, 054, 031, 049, 023, 045, 032, 040, 029},
    {14, 073, 045, 012, 012, 002, 002, 006, 006, 004, 004, 046, 046, 053, 053},
    {16, 001, 001, 003, 003, 006, 006, 046, 046, 065, 009, 014, 001, 012, 009, 026, 001},
    {16, 041, 041, 048, 048, 052, 052, 064, 064, 071, 071, 085, 085, 010, 010, 062, 062},
    {32, 001, 031, 001, 000, 001, 031, 001, 000, 001, 020, 003, 000, 001, 005, 000, 000, 000, 006, 003, 000, 003, 006, 003, 000, 016, 000, 008, 000, 017, 000, 120, 000},
    {8,  012, 035, 050, 032, 040, 026, 066, 036},
    {14, 001, 073, 001, 074, 001, 075, 001, 076, 001, 077, 001, 078, 001, 079},
    {2,  001, 001},
    {16, 026, 014, 029, 042, 026, 057, 054, 029, 026, 003, 003, 029, 012, 039, 074, 035},
    {4,  002, 026, 002, 029},
    {12, 013, 118, 014, 123, 120, 123, 112, 120, 084, 110, 076, 102},
    {2,  000, 000},
    {12, 040, 065, 071, 072, 052, 066, 064, 072, 030, 072, 060, 072},
    {16, 030, 026, 077, 026, 081, 027, 024, 055, 028, 056, 049, 059, 052, 069, 071, 107},
    {2,  036, 013},
    {16, 007, 094, 036, 088, 051, 075, 053, 075, 058, 067, 075, 067, 075, 061, 079, 062},
    {16, 123, 124, 119, 122, 118, 117, 116, 115, 114, 108, 101, 106, 088, 099, 005, 006},
    {16, 074, 072, 066, 072, 053, 056, 037, 019, 022, 022, 020, 020, 009, 014, 000, 000},
    {2,  000, 001},
    {16, 011, 123, 013, 120, 020, 117, 024, 112, 027, 107, 036, 105, 037, 107, 043, 093},
    {16, 109, 025, 109, 032, 112, 032, 010, 032, 030, 044, 032, 052, 084, 066, 084, 069},
    {16, 075, 084, 040, 084, 040, 110, 028, 119, 025, 119, 021, 119, 013, 119, 004, 119},
    {2,  014, 075},
    {16, 083, 066, 087, 074, 087, 075, 098, 083, 101, 100, 103, 101, 117, 116, 123, 036},
    {16, 036, 117, 036, 013, 042, 030, 042, 033, 054, 036, 075, 079, 092, 101, 098, 109},
    {16, 051, 039, 057, 038, 045, 029, 034, 009, 065, 009, 014, 001, 012, 009, 026, 001},
    {12, 013, 118, 014, 123, 120, 123, 112, 120, 084, 110, 076, 102},
    {10, 003, 003, 006, 006, 007, 007, 052, 052, 076, 076},
    {16, 037, 037, 042, 042, 053, 053, 062, 062, 007, 007, 010, 010, 011, 011, 015, 015},
    {2,  001, 001},
    {16, 007, 001, 074, 001, 061, 001, 016, 001, 025, 001, 030, 001, 036, 001, 053, 001},
    {16, 043, 043, 046, 046, 039, 039, 028, 028, 016, 016, 006, 006, 005, 005, 002, 002},
    {16, 003, 090, 004, 090, 007, 068, 008, 066, 012, 060, 027, 097, 034, 051, 037, 051},
    {16, 017, 039, 015, 123, 032, 112, 045, 088, 052, 071, 057, 067, 061, 096, 096, 096},
    {16, 038, 051, 021, 036, 021, 034, 030, 034, 054, 034, 055, 020, 048, 018, 051, 006},
    {16, 010, 001, 025, 001, 028, 001, 036, 001, 040, 001, 054, 001, 075, 001, 113, 001},
    {16, 013, 076, 024, 077, 063, 078, 042, 076, 054, 077, 039, 078, 011, 076, 062, 077},
    {16, 116, 001, 119, 001, 122, 001, 004, 001, 009, 001, 024, 001, 027, 001, 036, 001},
    {16, 037, 036, 036, 036, 040, 036, 043, 041, 047, 041, 051, 072, 054, 075, 055, 084},
    {16, 002, 039, 009, 039, 017, 001, 021, 001, 033, 000, 037, 000, 041, 029, 056, 029},
    {2,  001, 001},
    {0,  000, 000},
    {16, 074, 074, 075, 013, 087, 118, 092, 003, 115, 118, 025, 118, 036, 000, 118, 118},
    {16, 003, 003, 003, 008, 006, 025, 007, 079, 008, 082, 036, 105, 039, 106, 051, 118},
    {0,  000, 000},
    {32, 060, 024, 023, 000, 061, 027, 123, 000, 065, 031, 031, 000, 061, 061, 030, 000, 081, 035, 023, 000, 062, 061, 062, 000, 083, 066, 064, 000, 083, 064, 064, 000},
    {14, 001, 001, 017, 020, 018, 020, 022, 030, 036, 043, 044, 051, 052, 054},
    {16, 002, 039, 009, 039, 017, 001, 021, 001, 033, 000, 037, 000, 041, 029, 056, 029},
    {16, 052, 001, 053, 001, 066, 001, 075, 001, 076, 001, 081, 001, 095, 001, 109, 001},
    {0,  000, 000},
    {16, 037, 037, 042, 042, 053, 053, 062, 062, 007, 007, 010, 010, 011, 011, 015, 015},
    {16, 110, 001, 111, 001, 112, 001, 114, 001, 119, 001, 122, 001, 004, 001, 013, 001},
    {12, 002, 035, 036, 002, 051, 053, 091, 002, 011, 022, 040, 035},
    {0,  000, 000},
    {16, 073, 001, 074, 001, 075, 001, 077, 001, 079, 001, 083, 001, 084, 001, 091, 001},
    {16, 037, 037, 042, 042, 053, 053, 062, 062, 007, 007, 010, 010, 011, 011, 015, 015},
    {16, 003, 001, 028, 001, 031, 001, 055, 001, 066, 001, 097, 001, 123, 001, 118, 001},
    {16, 009, 001, 012, 001, 026, 096, 030, 096, 032, 001, 037, 001, 057, 096, 071, 096},
    {2,  001, 001},
    {2,  001, 001},
    {14, 096, 067, 086, 070, 079, 074, 070, 086, 061, 098, 075, 075, 075, 091},
    {16, 037, 037, 042, 042, 053, 053, 062, 062, 007, 007, 010, 010, 011, 011, 015, 015},
    {16, 051, 001, 058, 008, 060, 001, 068, 008, 002, 001, 013, 008, 022, 001, 036, 008},
    {16, 013, 118, 024, 118, 031, 093, 032, 092, 045, 092, 113, 092, 119, 113, 122, 113},
    {16, 076, 008, 032, 008, 043, 008, 067, 008, 011, 011, 008, 090, 002, 002, 083, 013},
    {2,  003, 001},
    {16, 050, 001, 047, 001, 044, 096, 040, 096, 039, 001, 030, 001, 028, 096, 009, 096},
    {16, 062, 037, 078, 038, 002, 062, 003, 087, 002, 078, 113, 078, 119, 062, 007, 078},
    {16, 122, 001, 123, 001, 125, 001, 010, 001, 024, 001, 037, 001, 055, 001, 066, 001},
    {2,  001, 001},
    {16, 074, 039, 072, 039, 075, 039, 079, 039, 083, 036, 084, 036, 089, 035, 091, 035},
    {16, 037, 037, 042, 042, 053, 053, 062, 062, 007, 007, 010, 010, 011, 011, 015, 015},
    {16, 067, 001, 072, 001, 075, 001, 083, 001, 091, 001, 101, 001, 109, 001, 020, 001},
    {6,  056, 056, 049, 049, 026, 124},
    {16, 038, 009, 055, 023, 061, 074, 071, 087, 091, 087, 098, 114, 102, 119, 111, 003},
    {16, 053, 032, 015, 032, 045, 032, 034, 030, 065, 032, 014, 032, 012, 032, 043, 032},
    {16, 051, 001, 058, 001, 060, 001, 068, 001, 002, 001, 013, 001, 022, 001, 036, 001},
    {2,  001, 001},
    {2,  001, 001},
    {16, 112, 001, 116, 001, 117, 001, 024, 001, 030, 001, 035, 001, 036, 001, 040, 001},
    {16, 051, 001, 058, 008, 060, 001, 068, 008, 002, 001, 013, 008, 022, 001, 036, 008},
    {16, 052, 039, 009, 039, 017, 001, 021, 001, 033, 000, 037, 000, 041, 029, 056, 029},
    {16, 057, 008, 008, 017, 043, 021, 054, 038, 067, 008, 037, 078, 065, 079, 025, 078},
    {16, 036, 001, 035, 001, 017, 001, 011, 001, 116, 001, 113, 001, 101, 001, 092, 001},
    {2,  001, 006},
    {0,  000, 000},
    {16, 037, 037, 042, 042, 053, 053, 062, 062, 007, 007, 010, 010, 011, 011, 015, 015},
    {16, 109, 001, 030, 008, 095, 001, 084, 008, 083, 001, 072, 008, 071, 001, 052, 008},
    {16, 097, 096, 088, 064, 090, 096, 093, 064, 097, 096, 099, 081, 102, 114, 114, 001},
    {16, 002, 039, 009, 039, 017, 001, 021, 001, 033, 000, 037, 000, 041, 029, 056, 029},
    {0,  000, 000},
    {2,  001, 001},
    {12, 002, 035, 036, 002, 051, 053, 091, 002, 011, 022, 040, 035},
    {16, 094, 001, 101, 001, 116, 001, 117, 001, 004, 001, 025, 001, 030, 001, 037, 001},
    {16, 091, 038, 115, 043, 085, 006, 079, 007, 078, 008, 077, 018, 079, 018, 086, 024},
    {2,  026, 026},
    {16, 012, 001, 019, 096, 031, 064, 025, 096, 038, 001, 051, 096, 057, 001, 066, 096},
    {16, 067, 001, 068, 096, 072, 001, 074, 008, 075, 096, 076, 008, 079, 001, 084, 096},
    {12, 001, 003, 008, 007, 008, 010, 008, 016, 023, 031, 040, 044},
    {2,  001, 001},
    {16, 037, 037, 042, 042, 053, 053, 062, 062, 007, 007, 010, 010, 011, 011, 015, 015},
    {18, 092, 092, 081, 081, 067, 067, 066, 066, 061, 061, 053, 053, 051, 051, 047, 047, 043, 043},
    {16, 054, 001, 058, 001, 066, 001, 072, 001, 075, 001, 087, 001, 101, 001, 036, 001},
    {16, 041, 010, 041, 020, 049, 011, 056, 123, 110, 113, 112, 116, 114, 118, 119, 101},
    {2,  001, 001},
    {2,  001, 001},
    {16, 037, 037, 042, 042, 053, 053, 062, 062, 007, 007, 010, 010, 011, 011, 015, 015},
    {16, 119, 001, 122, 001, 008, 001, 010, 001, 013, 001, 025, 001, 027, 001, 032, 001},
    {16, 036, 001, 040, 001, 043, 001, 053, 001, 072, 001, 075, 001, 095, 001, 101, 001},
    {2,  001, 001},
    {16, 037, 037, 031, 031, 023, 023, 022, 022, 007, 007, 124, 124, 114, 114, 112, 112},
    {0,  000, 000},
    {2,  001, 001},
    {2,  001, 001},
    {16, 051, 001, 058, 008, 060, 001, 068, 008, 002, 001, 013, 008, 022, 001, 036, 008},
    {0,  000, 000},
    {2,  112, 020},
    {2,  000, 001},
    {2,  000, 001},
    {2,  000, 001},
    {2,  000, 001},
    {16, 081, 008, 032, 008, 043, 008, 067, 008, 011, 011, 008, 090, 002, 002, 083, 013},
    {2,  001, 001},
    {16, 058, 001, 069, 001, 075, 077, 018, 001, 032, 001, 045, 045, 013, 001, 034, 001},
    {16, 058, 001, 069, 001, 075, 077, 018, 001, 032, 001, 045, 045, 013, 001, 034, 001},
    {16, 067, 076, 068, 076, 078, 076, 002, 076, 016, 076, 018, 076, 025, 076, 045, 088},
    {16, 061, 008, 032, 008, 043, 008, 067, 008, 011, 011, 008, 090, 002, 002, 083, 013},
    {0,  000, 000},
    {0,  000, 000},
    {2,  001, 001},
    {2,  036, 036},
    {0,  000, 000},
    {0,  000, 000}
};

stock static const gVehicleTopSpeed[MAX_VEHICLE_MODELS] =
{
	157,
	147,
	186,
	110,
	133,
	164,
	110,
	148,
	100,
	158,
	129,
	221,
	168,
	110,
	105,
	192,
	154,
	270,
    115,
	149,
	145,
	154,
	140,
	99,
	135,
	270,
	173,
	165,
	157,
	201,
	190,
	130,
	94,
	110,
	167,
	0,
	149,
    158,
	142,
	168,
	136,
	145,
	139,
	126,
	110,
	164,
	270,
	270,
	111,
	0,
	0,
	193,
	270,
	60,
	135,
	157,
    106,
	95,
	157,
	136,
	270,
	160,
	111,
	142,
	145,
	145,
	147,
	140,
	144,
	270,
	157,
	110,
	190,
	190,
    149,
	173,
	270,
	186,
	117,
	140,
	184,
	73,
	156,
	122,
	190,
	99,
	64,
	270,
	270,
	139,
	157,
	149,
	140,
    270,
	214,
	176,
	162,
	270,
	108,
	123,
	140,
	145,
	216,
	216,
	173,
	140,
	179,
	166,
	108,
	79,
	101,
	270,
    270,
	270,
	120,
	142,
	157,
	157,
	164,
	270,
	270,
	160,
	176,
	151,
	130,
	160,
	158,
	149,
	176,
	149,
	60,
    70,
	110,
	167,
	168,
	158,
	173,
	0,
	0,
	270,
	149,
	203,
	164,
	151,
	150,
	147,
	149,
	142,
	270,
	153,
	145,
    157,
	121,
	270,
	144,
	158,
	113,
	113,
	156,
	178,
	169,
	154,
	178,
	270,
	145,
	165,
	160,
	173,
	146,
	0,
	0,
    93,
	60,
	110,
	60,
	158,
	158,
	270,
	130,
	158,
	153,
	151,
	136,
	85,
	0,
	153,
	142,
	165,
	108,
	162,
	0,
	0,
    270,
	270,
	130,
	190,
	175,
	175,
	175,
	158,
	151,
	110,
	169,
	171,
	148,
	152,
	0,
	0,
	0,
	108,
	0,
	0
};

#define v_interior      	0
#define v_color<%1>     	(%1 + 1)
#define v_paintjob      	3
#define v_horn      		4
#define v_damage<%1>    	(%1 + 5)
#define v_editor      		9
#define v_speedcap      	10
#define v_spawn<%1>     	(%1 + 11)
#define v_spawn_interiorid  15
#define v_spawn_worldid  	16
#define v_spawn_uno_damage  17
#define v_petrolcap			18
#define v_bomb			    19
#define v_bomb_timer        20
#define v_sticky            21
#define v_update_timer      22

stock static Vehicle_SetPropertyInt(vehicleid, type, set)
{
	new string[35];
	switch(type)
	{
		case v_interior: 		format(string, sizeof(string), "%i_v_interior", vehicleid);
		case v_color<0>: 		format(string, sizeof(string), "%i_v_color_1", vehicleid);
		case v_color<1>: 		format(string, sizeof(string), "%i_v_color_2", vehicleid);
		case v_paintjob: 		format(string, sizeof(string), "%i_v_paintjob", vehicleid);
		case v_horn: 			format(string, sizeof(string), "%i_v_horn", vehicleid);
		case v_damage<0>:		format(string, sizeof(string), "%i_v_damage_1", vehicleid);
		case v_damage<1>: 		format(string, sizeof(string), "%i_v_damage_2", vehicleid);
		case v_damage<2>: 		format(string, sizeof(string), "%i_v_damage_3", vehicleid);
		case v_damage<3>: 		format(string, sizeof(string), "%i_v_damage_4", vehicleid);
		case v_editor: 			format(string, sizeof(string), "%i_v_editor", vehicleid);
		case v_spawn_interiorid:format(string, sizeof(string), "%i_v_spawn_interiorid", vehicleid);
		case v_spawn_worldid: 	format(string, sizeof(string), "%i_v_spawn_worldid", vehicleid);
		case v_spawn_uno_damage:format(string, sizeof(string), "%i_v_spawn_uno_damage", vehicleid);
		case v_petrolcap:		format(string, sizeof(string), "%i_v_petrolcap", vehicleid);
		case v_bomb:			format(string, sizeof(string), "%i_v_bomb", vehicleid);
		case v_bomb_timer:		format(string, sizeof(string), "%i_v_bomb_timer", vehicleid);
		case v_sticky:			format(string, sizeof(string), "%i_v_sticky", vehicleid);
		case v_update_timer:	format(string, sizeof(string), "%i_v_update_timer", vehicleid);
	}

	return setproperty(.name = string, .value = set);
}

stock static Vehicle_GetPropertyInt(vehicleid, type)
{
	new string[35];
	switch(type)
	{
		case v_interior: 		format(string, sizeof(string), "%i_v_interior", vehicleid);
		case v_color<0>: 		format(string, sizeof(string), "%i_v_color_1", vehicleid);
		case v_color<1>: 		format(string, sizeof(string), "%i_v_color_2", vehicleid);
		case v_paintjob: 		format(string, sizeof(string), "%i_v_paintjob", vehicleid);
		case v_horn: 			format(string, sizeof(string), "%i_v_horn", vehicleid);
		case v_damage<0>:		format(string, sizeof(string), "%i_v_damage_1", vehicleid);
		case v_damage<1>: 		format(string, sizeof(string), "%i_v_damage_2", vehicleid);
		case v_damage<2>: 		format(string, sizeof(string), "%i_v_damage_3", vehicleid);
		case v_damage<3>: 		format(string, sizeof(string), "%i_v_damage_4", vehicleid);
		case v_editor: 			format(string, sizeof(string), "%i_v_editor", vehicleid);
		case v_spawn_interiorid:format(string, sizeof(string), "%i_v_spawn_interiorid", vehicleid);
		case v_spawn_worldid: 	format(string, sizeof(string), "%i_v_spawn_worldid", vehicleid);
		case v_spawn_uno_damage:format(string, sizeof(string), "%i_v_spawn_uno_damage", vehicleid);
		case v_petrolcap:		format(string, sizeof(string), "%i_v_petrolcap", vehicleid);
		case v_bomb:			format(string, sizeof(string), "%i_v_bomb", vehicleid);
		case v_bomb_timer:		format(string, sizeof(string), "%i_v_bomb_timer", vehicleid);
		case v_sticky:			format(string, sizeof(string), "%i_v_sticky", vehicleid);
		case v_update_timer:	format(string, sizeof(string), "%i_v_update_timer", vehicleid);
	}

	return getproperty(.name = string);
}

stock static Vehicle_EncodeString(string[])
{
	new source[2];
    for(new i, j = strlen(string); i < j; i++)
    {
       source[0] = (source[0] + string[i]) 		% 65521;
       source[1] = (source[1] + source[0])     	% 65521;
    }
    return (source[1] << 16) + source[0];
}

stock static Vehicle_SetPropertyFloat(vehicleid, type, Float:set)
{
	new string[35];
	switch(type)
	{
		case v_speedcap: 	format(string, sizeof(string), "%i_v_speedcap", vehicleid);
		case v_spawn<0>: 	format(string, sizeof(string), "%i_v_spawn_x", vehicleid);
		case v_spawn<1>: 	format(string, sizeof(string), "%i_v_spawn_y", vehicleid);
		case v_spawn<2>: 	format(string, sizeof(string), "%i_v_spawn_z", vehicleid);
		case v_spawn<3>: 	format(string, sizeof(string), "%i_v_spawn_rotation", vehicleid);
	}

	new value[8];
	format(value, sizeof(value), "%f", set);

	return setproperty(.value = Vehicle_EncodeString(string), .string = value);
}

stock static Float:Vehicle_GetPropertyFloat(vehicleid, type)
{
	new string[35];
	switch(type)
	{
		case v_speedcap: 	format(string, sizeof(string), "%i_v_speedcap", vehicleid);
		case v_spawn<0>: 	format(string, sizeof(string), "%i_v_spawn_x", vehicleid);
		case v_spawn<1>: 	format(string, sizeof(string), "%i_v_spawn_y", vehicleid);
		case v_spawn<2>: 	format(string, sizeof(string), "%i_v_spawn_z", vehicleid);
		case v_spawn<3>: 	format(string, sizeof(string), "%i_v_spawn_rotation", vehicleid);
	}

	new value[8];
	getproperty(.value = Vehicle_EncodeString(string), .string = value);

	return floatstr(value);
}

stock static Vehicle_DeleteProperty(vehicleid, type)
{
	new string[35];
	switch(type)
	{
		case v_interior: 	format(string, sizeof(string), "%i_v_interior", vehicleid);
		case v_color<0>: 	format(string, sizeof(string), "%i_v_color_1", vehicleid);
		case v_color<1>: 	format(string, sizeof(string), "%i_v_color_2", vehicleid);
		case v_paintjob: 	format(string, sizeof(string), "%i_v_paintjob", vehicleid);
		case v_horn: 		format(string, sizeof(string), "%i_v_horn", vehicleid);
		case v_damage<0>:	format(string, sizeof(string), "%i_v_damage_1", vehicleid);
		case v_damage<1>: 	format(string, sizeof(string), "%i_v_damage_2", vehicleid);
		case v_damage<2>: 	format(string, sizeof(string), "%i_v_damage_3", vehicleid);
		case v_damage<3>: 	format(string, sizeof(string), "%i_v_damage_4", vehicleid);
		case v_editor: 		format(string, sizeof(string), "%i_v_editor", vehicleid);
		case v_speedcap: 	format(string, sizeof(string), "%i_v_speedcap", vehicleid);
		case v_spawn<0>:
		{
			format(string, sizeof(string), "%i_v_spawn_x", vehicleid);
			return deleteproperty(.value = Vehicle_EncodeString(string));
		}
		case v_spawn<1>:
		{
			format(string, sizeof(string), "%i_v_spawn_y", vehicleid);
			return deleteproperty(.value = Vehicle_EncodeString(string));
		}
		case v_spawn<2>:
		{
			format(string, sizeof(string), "%i_v_spawn_z", vehicleid);
			return deleteproperty(.value = Vehicle_EncodeString(string));
		}
		case v_spawn<3>:
		{
			format(string, sizeof(string), "%i_v_spawn_rotation", vehicleid);
			return deleteproperty(.value = Vehicle_EncodeString(string));
		}
		case v_spawn<4>: 	format(string, sizeof(string), "%i_v_spawn_interiorid", vehicleid);
		case v_spawn<5>: 	format(string, sizeof(string), "%i_v_spawn_worldid", vehicleid);
		case v_spawn_uno_damage:format(string, sizeof(string), "%i_v_spawn_uno_damage", vehicleid);
		case v_petrolcap:	format(string, sizeof(string), "%i_v_petrolcap", vehicleid);
		case v_bomb:		format(string, sizeof(string), "%i_v_bomb", vehicleid);
		case v_bomb_timer:	format(string, sizeof(string), "%i_v_bomb_timer", vehicleid);
		case v_sticky:		format(string, sizeof(string), "%i_v_sticky", vehicleid);
		case v_update_timer:format(string, sizeof(string), "%i_v_update_timer", vehicleid);
	}

	return deleteproperty(.name = string);
}

stock Vehicle_CreateVehicle(modelid, Float:x, Float:y, Float:z, Float:rotation, color1 = -1, color2 = -1, respawn_delay = -1, addsiren = 0, worldid = 0, interiorid = 0, bool:unoccupied_damage = false)
{
	if(modelid < 400 || modelid > 610) return false;

	if(	(color1 == -1 || color2 == -1) &&
		gVehicleColors[(modelid - 400)][0])
	{
		if(gVehicleColors[(modelid - 400)][0] == 2)
		{
		    color1 = gVehicleColors[(modelid - 400)][1];
		    color2 = gVehicleColors[(modelid - 400)][2];
		}
		else
		{
			new index = random(gVehicleColors[(modelid - 400)][0]) & -2;

			color1 = gVehicleColors[(modelid - 400)][++index];
			color2 = gVehicleColors[(modelid - 400)][++index];
		}
	}

	new vehicleid;
	switch(modelid)
	{
		case 569, 570, 537, 538: 	vehicleid = AddStaticVehicleEx(modelid, x, y, z, rotation, color1, color2, respawn_delay, addsiren);
		default: 					vehicleid = CreateVehicle(modelid, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren);
	}

	LinkVehicleToInterior(vehicleid, interiorid);
	SetVehicleVirtualWorld(vehicleid, worldid);

    Vehicle_SetPropertyInt(vehicleid, v_interior, interiorid);

    Vehicle_SetPropertyInt(vehicleid, v_color<0>, color1);
    Vehicle_SetPropertyInt(vehicleid, v_color<1>, color2);

    Vehicle_SetPropertyInt(vehicleid, v_paintjob, 3);

    Vehicle_SetPropertyInt(vehicleid, v_horn, 0);

	for(new i; i < 4; i++)
	{
    	Vehicle_SetPropertyInt(vehicleid, v_damage<i>, 1);
	}

	Vehicle_SetPropertyInt(vehicleid, v_editor, INVALID_OBJECT_ID);

	for(new i; i < MAX_VEHICLE_ATTACHED_OBJECTS; i++)
	{
	    gVehicleAttachedObject[vehicleid][i] = INVALID_OBJECT_ID;
	}

	Vehicle_SetPropertyFloat(vehicleid, v_speedcap, 0.0);

	Vehicle_SetPropertyFloat(vehicleid, v_spawn<0>, x);
	Vehicle_SetPropertyFloat(vehicleid, v_spawn<1>, y);
	Vehicle_SetPropertyFloat(vehicleid, v_spawn<2>, z);
	Vehicle_SetPropertyFloat(vehicleid, v_spawn<3>, rotation);

	Vehicle_SetPropertyInt(vehicleid, v_spawn_worldid, worldid);
	Vehicle_SetPropertyInt(vehicleid, v_spawn_interiorid, interiorid);

	Vehicle_SetPropertyInt(vehicleid, v_spawn_uno_damage, _:unoccupied_damage);

	Vehicle_SetPropertyInt(vehicleid, v_petrolcap, 0);

	Vehicle_SetPropertyInt(vehicleid, v_bomb, 0);
	Vehicle_SetPropertyInt(vehicleid, v_bomb_timer, -1);

	Vehicle_SetPropertyInt(vehicleid, v_sticky, 0);

	Vehicle_SetPropertyInt(vehicleid, v_update_timer, -1);

	gVehicleFloat[vehicleid][0] = x;
	gVehicleFloat[vehicleid][1] = y;
	gVehicleFloat[vehicleid][2] = z;
	gVehicleFloat[vehicleid][3] = rotation;

	gVehicleFloat[vehicleid][4] = 0.0;
	gVehicleFloat[vehicleid][5] = 0.0;
	gVehicleFloat[vehicleid][6] = 0.0;

	gVehicleFloat[vehicleid][7] = 1000.0;

	return vehicleid;
}
#if defined _ALS_CreateVehicle
	#undef CreateVehicle
#else
	#define _ALS_CreateVehicle
#endif
#define CreateVehicle Vehicle_CreateVehicle
//
#if defined _ALS_AddStaticVehicleEx
	#undef AddStaticVehicleEx
#else
	#define _ALS_AddStaticVehicleEx
#endif
#define AddStaticVehicleEx Vehicle_CreateVehicle
//
#if defined _ALS_AddStaticVehicle
	#undef AddStaticVehicle
#else
	#define _ALS_AddStaticVehicle
#endif
#define AddStaticVehicle Vehicle_CreateVehicle
//

stock Vehicle_SetVehiclePos(vehicleid, Float:x, Float:y, Float:z)
{
	if(SetVehiclePos(vehicleid, Float:x, Float:y, Float:z))
	{
		gVehicleFloat[vehicleid][0] = x;
		gVehicleFloat[vehicleid][1] = y;
		gVehicleFloat[vehicleid][2] = z;
		return true;
	}
	return false;
}
#if defined _ALS_SetVehiclePos
	#undef SetVehiclePos
#else
	#define _ALS_SetVehiclePos
#endif
#define SetVehiclePos Vehicle_SetVehiclePos

stock Vehicle_SetVehicleZAngle(vehicleid, Float:angle)
{
	if(SetVehicleZAngle(vehicleid, angle))
	{
		gVehicleFloat[vehicleid][3] = angle;
		return true;
	}
	return false;
}
#if defined _ALS_SetVehicleZAngle
	#undef SetVehicleZAngle
#else
	#define _ALS_SetVehicleZAngle
#endif
#define SetVehicleZAngle Vehicle_SetVehicleZAngle

stock Vehicle_DestroyVehicle(vehicleid)
{
	if(DestroyVehicle(vehicleid))
	{
		for(new i; i <= GetPlayerPoolSize(); i++)
		{
			if(IsPlayerConnected(i))
			{
				if(gPlayerEdit[i] == Vehicle_GetPropertyInt(vehicleid, v_editor))
				{
				    CancelEdit(i);
				}
			}
		}
		DestroyObject(Vehicle_GetPropertyInt(vehicleid, v_editor));

		Vehicle_DeleteProperty(vehicleid, v_interior);

		Vehicle_DeleteProperty(vehicleid, v_color<0>);
		Vehicle_DeleteProperty(vehicleid, v_color<1>);

		Vehicle_DeleteProperty(vehicleid, v_paintjob);

		Vehicle_DeleteProperty(vehicleid, v_horn);

		Vehicle_DeleteProperty(vehicleid, v_damage<0>);
		Vehicle_DeleteProperty(vehicleid, v_damage<1>);
		Vehicle_DeleteProperty(vehicleid, v_damage<2>);
		Vehicle_DeleteProperty(vehicleid, v_damage<3>);

		Vehicle_DeleteProperty(vehicleid, v_editor);

		for(new i; i < MAX_VEHICLE_ATTACHED_OBJECTS; i++)
		{
  			if(IsValidObject(gVehicleAttachedObject[vehicleid][i]))
			{
			    DestroyObject(gVehicleAttachedObject[vehicleid][i]);
			 	gVehicleAttachedObject[vehicleid][i] = INVALID_OBJECT_ID;
		 	}
		}

		Vehicle_DeleteProperty(vehicleid, v_speedcap);

		Vehicle_DeleteProperty(vehicleid, v_spawn<0>);
		Vehicle_DeleteProperty(vehicleid, v_spawn<1>);
		Vehicle_DeleteProperty(vehicleid, v_spawn<2>);
		Vehicle_DeleteProperty(vehicleid, v_spawn<3>);

		Vehicle_DeleteProperty(vehicleid, v_spawn_worldid);
		Vehicle_DeleteProperty(vehicleid, v_spawn_interiorid);

		Vehicle_DeleteProperty(vehicleid, v_spawn_uno_damage);

		Vehicle_DeleteProperty(vehicleid, v_petrolcap);

		Vehicle_DeleteProperty(vehicleid, v_bomb);
		Vehicle_DeleteProperty(vehicleid, v_bomb_timer);

		Vehicle_DeleteProperty(vehicleid, v_sticky);

		Vehicle_DeleteProperty(vehicleid, v_update_timer);

		vehicleid = INVALID_VEHICLE_ID;
	}
	return true;
}
#if defined _ALS_DestroyVehicle
	#undef DestroyVehicle
#else
	#define _ALS_DestroyVehicle
#endif
#define DestroyVehicle Vehicle_DestroyVehicle

stock Vehicle_LinkVehicleToInterior(vehicleid, interiorid)
{
	if(LinkVehicleToInterior(vehicleid, interiorid))
	{
	    Vehicle_SetPropertyInt(vehicleid, v_interior, interiorid);
		return true;
	}
	return false;
}
#if defined _ALS_LinkVehicleToInterior
	#undef LinkVehicleToInterior
#else
	#define _ALS_LinkVehicleToInterior
#endif
#define LinkVehicleToInterior Vehicle_LinkVehicleToInterior
//
#if ! defined SetVehicleInterior
	#define SetVehicleInterior Vehicle_LinkVehicleToInterior
#endif
//

stock GetVehicleInterior(vehicleid)
{
	return Vehicle_GetPropertyInt(vehicleid, v_interior);
}

stock Vehicle_ChangeVehicleColor(vehicleid, color1, color2)
{
	new modelid = GetVehicleModel(vehicleid);

	if(	(color1 == -1 || color2 == -1) &&
		gVehicleColors[(modelid - 400)][0])
	{
		if(gVehicleColors[(modelid - 400)][0] == 2)
		{
		    color1 = gVehicleColors[(modelid - 400)][1];
		    color2 = gVehicleColors[(modelid - 400)][2];
		}
		else
		{
			new index = random(gVehicleColors[(modelid - 400)][0]) & -2;

			color1 = gVehicleColors[(modelid - 400)][++index];
			color2 = gVehicleColors[(modelid - 400)][++index];
		}
	}

	if(ChangeVehicleColor(vehicleid, color1, color2))
	{
	    Vehicle_SetPropertyInt(vehicleid, v_color<0>, color1);
	    Vehicle_SetPropertyInt(vehicleid, v_color<1>, color2);
		return true;
	}
	return false;
}
#if defined _ALS_ChangeVehicleColor
	#undef ChangeVehicleColor
#else
	#define _ALS_ChangeVehicleColor
#endif
#define ChangeVehicleColor Vehicle_ChangeVehicleColor

#if ! defined SetVehicleColor
	#define SetVehicleColor ChangeVehicleColor
#endif

stock GetVehicleColor(vehicleid, &color1, &color2)
{
	color1 = Vehicle_GetPropertyInt(vehicleid, v_color<0>);
	color2 = Vehicle_GetPropertyInt(vehicleid, v_color<1>);
	return true;
}

stock Vehicle_ChangeVehiclePaintjob(vehicleid, paintjobid)
{
	if(ChangeVehiclePaintjob(vehicleid, paintjobid))
	{
	    Vehicle_SetPropertyInt(vehicleid, v_paintjob, paintjobid);

		if(paintjobid == 3)
		{
			new colors[2];
			GetVehicleColor(vehicleid, colors[0], colors[1]);
			ChangeVehicleColor(vehicleid, colors[0], colors[1]);
		}
		return true;
	}
	return false;
}
#if defined _ALS_ChangeVehiclePaintjob
	#undef ChangeVehiclePaintjob
#else
	#define _ALS_ChangeVehiclePaintjob
#endif
#define ChangeVehiclePaintjob Vehicle_ChangeVehiclePaintjob

stock GetVehiclePaintjob(vehicleid)
{
	return Vehicle_GetPropertyInt(vehicleid, v_paintjob);
}

stock RemoveVehiclePaintjob(vehicleid)
{
	return ChangeVehiclePaintjob(vehicleid, 3);
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	Vehicle_SetPropertyInt(vehicleid, v_paintjob, paintjobid);

    #if defined Vehicle_OnVehiclePaintjob
        return Vehicle_OnVehiclePaintjob(playerid, vehicleid, paintjobid);
    #else
        return 1;
    #endif
}
#if defined Vehicle_OnVehiclePaintjob
    forward Vehicle_OnVehiclePaintjob(playerid, vehicleid, paintjobid);
#endif
#if defined _ALS_OnVehiclePaintjob
    #undef OnVehiclePaintjob
#else
    #define _ALS_OnVehiclePaintjob
#endif
#define OnVehiclePaintjob Vehicle_OnVehiclePaintjob

public OnVehicleSpawn(vehicleid)
{
	Vehicle_SetPropertyInt(vehicleid, v_paintjob, 3);

	new colors[2];
	colors[0] = Vehicle_GetPropertyInt(vehicleid, v_color<0>);
	colors[1] = Vehicle_GetPropertyInt(vehicleid, v_color<1>);
	ChangeVehicleColor(vehicleid, colors[0], colors[1]);

	new Float:pos[3];
	GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);

	new Float:angle;
	GetVehicleZAngle(vehicleid, angle);

	new Float:vehicle_pos[3], Float:vehicle_angle, vehicle_worldid, vehicle_interiorid;
	GetVehicleSpawnInfo(vehicleid, vehicle_pos[0], vehicle_pos[1], vehicle_pos[2], vehicle_angle, vehicle_worldid, vehicle_interiorid);

 	if( pos[0] != vehicle_pos[0] ||
		pos[1] != vehicle_pos[1] ||
		pos[2] != vehicle_pos[2] ||
		angle != vehicle_angle ||
		vehicle_worldid != GetVehicleVirtualWorld(vehicleid) ||
		vehicle_interiorid != GetVehicleInterior(vehicleid))
	{
	    TeleportVehicle(vehicleid, vehicle_pos[0], vehicle_pos[1], vehicle_pos[2], vehicle_angle, vehicle_worldid, vehicle_interiorid);
	}

    #if defined Vehicle_OnVehicleSpawn
        return Vehicle_OnVehicleSpawn(vehicleid);
    #else
        return 1;
    #endif
}
#if defined Vehicle_OnVehicleSpawn
    forward Vehicle_OnVehicleSpawn(vehicleid);
#endif
#if defined _ALS_OnVehicleSpawn
    #undef OnVehicleSpawn
#else
    #define _ALS_OnVehicleSpawn
#endif
#define OnVehicleSpawn Vehicle_OnVehicleSpawn

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	Vehicle_SetPropertyInt(vehicleid, v_color<0>, color1);
	Vehicle_SetPropertyInt(vehicleid, v_color<1>, color2);

    #if defined Vehicle_OnVehicleRespray
        return Vehicle_OnVehicleRespray(playerid, vehicleid, color1, color2);
    #else
        return 1;
    #endif
}
#if defined Vehicle_OnVehicleRespray
    forward Vehicle_OnVehicleRespray(playerid, vehicleid, color1, color2);
#endif
#if defined _ALS_OnVehicleRespray
    #undef OnVehicleRespray
#else
    #define _ALS_OnVehicleRespray
#endif
#define OnVehicleRespray Vehicle_OnVehicleRespray

stock SetVehicleHorn(vehicleid, soundid)
{
	Vehicle_SetPropertyInt(vehicleid, v_horn, soundid);
	return true;
}

stock GetVehicleHorn(vehicleid)
{
	return Vehicle_GetPropertyInt(vehicleid, v_horn);
}

stock RestoreVehicleHorn(vehicleid)
{
	return SetVehicleHorn(vehicleid, 0);
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_CROUCH)
	{
	    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	    {
	        new horn = Vehicle_GetPropertyInt(GetPlayerVehicleID(playerid), v_horn);
	        if(horn != 0)
	        {
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

			    for(new i; i < MAX_PLAYERS; i++)
			    {
			        if(IsPlayerInRangeOfPoint(i, 35.0, pos[0], pos[1], pos[2]))
					{
					    PlayerPlaySound(playerid, horn, pos[0], pos[1], pos[2]);
					}
			    }
		    }
		}
	}

	#if defined Vehicle_OnPlayerKeyStateChange
        return Vehicle_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #else
        return 1;
    #endif
}
#if defined Vehicle_OnPlayerKeyStateChange
    forward Vehicle_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif
#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange Vehicle_OnPlayerKeyStateChange

stock ToggleVehicleDamageUpdate(vehicleid, type, bool:toggle)
{
	if(! toggle)
	{
	    if(GetVehicleParams(vehicleid, VEHICLE_PARAMS_ENGINE) == VEHICLE_PARAMS_ON)
	    {
	        SetVehicleParams(vehicleid, VEHICLE_PARAMS_ENGINE, VEHICLE_PARAMS_OFF);
	    }
	}
    return Vehicle_SetPropertyInt(vehicleid, v_damage<type>, _:toggle);
}

stock IsVehicleDamageToggled(vehicleid, type)
{
	return Vehicle_GetPropertyInt(vehicleid, v_damage<type>);
}

stock Vehicle_SetVehicleHealth(vehicleid, Float:health)
{
    if(SetVehicleHealth(vehicleid, health))
	{
		gVehicleFloat[vehicleid][7] = health;
		return true;
	}
	return false;
}
#if defined _ALS_SetVehicleHealth
    #undef SetVehicleHealth
#else
    #define _ALS_SetVehicleHealth
#endif
#define SetVehicleHealth Vehicle_SetVehicleHealth

stock UpdateVehicleDamageStatusEx(vehicleid, type, update)
{
	new panels, doors, lights, tires;
	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

    switch(type)
	{
		case VEHICLE_DAMAGE_PANELS: return UpdateVehicleDamageStatus(vehicleid, update, doors, lights, tires);
		case VEHICLE_DAMAGE_DOORS: return UpdateVehicleDamageStatus(vehicleid, panels, update, lights, tires);
		case VEHICLE_DAMAGE_LIGHTS: return UpdateVehicleDamageStatus(vehicleid, panels, doors, update, tires);
		case VEHICLE_DAMAGE_TIRES: return UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, update);
	}
	return false;
}

stock GetVehicleDamageStatusEx(vehicleid, type)
{
	new panels, doors, lights, tires;
	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

	switch(type)
	{
		case VEHICLE_DAMAGE_PANELS: return panels;
		case VEHICLE_DAMAGE_DOORS: return doors;
		case VEHICLE_DAMAGE_LIGHTS: return lights;
		case VEHICLE_DAMAGE_TIRES: return tires;
	}
	return -1;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
	new panels, doors, lights, tires;
	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

	if(! IsVehicleDamageToggled(vehicleid, VEHICLE_DAMAGE_PANELS)) UpdateVehicleDamageStatusEx(vehicleid, VEHICLE_DAMAGE_PANELS, 0);
	if(! IsVehicleDamageToggled(vehicleid, VEHICLE_DAMAGE_DOORS)) UpdateVehicleDamageStatusEx(vehicleid, VEHICLE_DAMAGE_DOORS, 0);
	if(! IsVehicleDamageToggled(vehicleid, VEHICLE_DAMAGE_LIGHTS)) UpdateVehicleDamageStatusEx(vehicleid, VEHICLE_DAMAGE_LIGHTS, 0);
	if(! IsVehicleDamageToggled(vehicleid, VEHICLE_DAMAGE_TIRES)) UpdateVehicleDamageStatusEx(vehicleid, VEHICLE_DAMAGE_TIRES, 0);

	#if defined V_OnVehicleDamageStatusUpdate
        return V_OnVehicleDamageStatusUpdate(vehicleid, playerid);
    #else
        return 1;
    #endif
}
#if defined V_OnVehicleDamageStatusUpdate
    forward V_OnVehicleDamageStatusUpdate(vehicleid, playerid);
#endif
#if defined _ALS_OnVehicleDamageStatusU
    #undef OnVehicleDamageStatusUpdate
#else
    #define _ALS_OnVehicleDamageStatusU
#endif
#define OnVehicleDamageStatusUpdate V_OnVehicleDamageStatusUpdate

stock static encode_lights(light1, light2, light3, light4)
{
	return light1 | (light2 << 1) | (light3 << 2) | (light4 << 3);
}
stock static encode_panels(flp, frp, rlp, rrp, windshield, front_bumper, rear_bumper)
{
	return flp | (frp << 4) | (rlp << 8) | (rrp << 12) | (windshield << 16) | (front_bumper << 20) | (rear_bumper << 24);
}

stock static encode_doors(bonnet, boot, driver_door, passenger_door, behind_driver_door, behind_passenger_door)
{
    #pragma unused behind_driver_door
    #pragma unused behind_passenger_door
    return bonnet | (boot << 8) | (driver_door << 16) | (passenger_door << 24);
}

stock static Vehicle_UpdateVehicleDamage(vehicleid, type)
{
    new panels, doors, lights, tires;
    GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
    switch(type)
	{
 		case VEHICLE_DAMAGE_PANELS: panels = encode_panels(1, 1, 1, 1, 3, 3, 3);
   		case VEHICLE_DAMAGE_DOORS: doors = encode_doors(4, 4, 4, 4, 0, 0);
        case VEHICLE_DAMAGE_LIGHTS: lights = encode_lights(1, 1, 1, 1);
    }
    UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if(hittype == BULLET_HIT_TYPE_VEHICLE)
    {
        new Float:fHealth;
        GetVehicleHealth(hitid, fHealth);

		if(fHealth > (250 - 1))
		{
			new
				fModelid = GetVehicleModel(hitid),
				Float:fOffSet[3],
				Float:fDamage
			;

			switch(GetPlayerWeapon(playerid))
			{
				case 22: fDamage = 40.0;
				case 23: fDamage = 40.0;
    			case 24: fDamage = 140.0;
       			case 25: fDamage = 80.0;
                case 26: fDamage = 80.0;
                case 27: fDamage = 80.0;
                case 28: fDamage = 25.0;
                case 29: fDamage = 25.0;
                case 30: fDamage = 30.0;
                case 31: fDamage = 30.0;
                case 32: fDamage = 25.0;
                case 33: fDamage = 75.0;
                case 34: fDamage = 125.0;
                case 35: fDamage = 751.0;
                case 36: fDamage = 751.0;
                case 38: fDamage = 50.0;
            }

			//front wheels
			GetVehicleModelInfo(fModelid, VEHICLE_MODEL_INFO_WHEELSFRONT, fOffSet[0], fOffSet[1], fOffSet[2]);
   			//left
			if(	fX >= fOffSet[0] - 2.4 &&
				fX <= fOffSet[0] &&
				fY >= fOffSet[1] - 0.4 &&
				fY <= fOffSet[1] + 0.4 &&
				fZ >= fOffSet[2] - 0.4 &&
				fZ <= fOffSet[2] + 0.4)
			{
				if(	CallLocalFunction("OnPlayerShotVehicle", "iiifi", playerid, hitid, weaponid, fDamage, VEHICLE_BODYPART_FRONT_LEFT_WHEEL) ||
					funcidx("OnPlayerShotVehicle") == -1)
				{
					if(IsUnoccupiedDamageToggled(hitid))
					{
						switch(GetVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES))
						{
						    case 0: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 8);
						    case 1: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 9);
						    case 2: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 10);
						    case 3: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 11);
						    case 4: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 12);
						    case 5: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 13);
						    case 6: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 14);
						    case 7: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 15);
						}
						return 1;
					}
				}
				else return 0;
			}
			//right
			if(	fX >= fOffSet[0] - 0.4 &&
				fX <= fOffSet[0] + 0.4 &&
				fY >= fOffSet[1] - 0.4 &&
				fY <= fOffSet[1] + 0.4 &&
				fZ >= fOffSet[2] - 0.4 &&
				fZ <= fOffSet[2] + 0.4)
			{
				if(	CallLocalFunction("OnPlayerShotVehicle", "iiifi", playerid, hitid, weaponid, fDamage, VEHICLE_BODYPART_FRONT_RIGHT_WHEEL)  ||
					funcidx("OnPlayerShotVehicle") == -1)
				{
					if(IsUnoccupiedDamageToggled(hitid))
					{
						switch(GetVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES))
						{
						    case 0: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 2);
						    case 1: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 3);
						    case 4: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 6);
						    case 5: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 7);
						    case 8: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 10);
						    case 9: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 11);
						    case 12: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 14);
						    case 13: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 15);
						}
						return 1;
					}
				}
				else return 0;
			}

			//back wheels
			GetVehicleModelInfo(fModelid, VEHICLE_MODEL_INFO_WHEELSREAR, fOffSet[0], fOffSet[1], fOffSet[2]);
			//left
			if(	fX >= fOffSet[0] - 2.4 &&
				fX <= fOffSet[0] &&
				fY >= fOffSet[1] - 0.4 &&
				fY <= fOffSet[1] + 0.4 &&
				fZ >= fOffSet[2] - 0.4 &&
				fZ <= fOffSet[2] + 0.4)
			{
				if(	CallLocalFunction("OnPlayerShotVehicle", "iiifi", playerid, hitid, weaponid, fDamage, VEHICLE_BODYPART_BACK_LEFT_WHEEL) ||
					funcidx("OnPlayerShotVehicle") == -1)
				{
					if(IsUnoccupiedDamageToggled(hitid))
					{
						switch(GetVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES))
						{
						    case 0: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 4);
						    case 1: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 5);
						    case 2: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 6);
						    case 3: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 7);
						    case 8: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 12);
						    case 9: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 13);
						    case 10: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 14);
						    case 11: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 15);
						}
						return 1;
					}
				}
				else return 0;
			}
			//right
			if(	fX >= fOffSet[0] - 0.4 &&
				fX <= fOffSet[0] + 0.4 &&
				fY >= fOffSet[1] - 0.4 &&
				fY <= fOffSet[1] + 0.4 &&
				fZ >= fOffSet[2] - 0.4 &&
				fZ <= fOffSet[2] + 0.4)
			{
				if(	CallLocalFunction("OnPlayerShotVehicle", "iiifi", playerid, hitid, weaponid, fDamage, VEHICLE_BODYPART_BACK_RIGHT_WHEEL) ||
					funcidx("OnPlayerShotVehicle") == -1)
				{
					if(IsUnoccupiedDamageToggled(hitid))
					{
						switch(GetVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES))
						{
						    case 0: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 1);
						    case 2: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 3);
						    case 4: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 5);
						    case 6: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 7);
						    case 8: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 9);
						    case 10: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 11);
						    case 12: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 13);
						    case 14: UpdateVehicleDamageStatusEx(hitid, VEHICLE_DAMAGE_TIRES, 15);
						}
						return 1;
					}
				}
				else return 0;
			}

			//petrol cap
			fModelid -= 400;
			if(	fX >= gVehiclePetrolCapOffsets[fModelid][0] - 0.15 &&
				fX <= gVehiclePetrolCapOffsets[fModelid][0] + 0.15 &&
				fY >= gVehiclePetrolCapOffsets[fModelid][1] - 0.15 &&
				fY <= gVehiclePetrolCapOffsets[fModelid][1] + 0.15 &&
				fZ >= gVehiclePetrolCapOffsets[fModelid][2] - 0.15 &&
				fZ <= gVehiclePetrolCapOffsets[fModelid][2] + 0.15)
			{
				if(	CallLocalFunction("OnPlayerShotVehicle", "iiifi", playerid, hitid, weaponid, fDamage, VEHICLE_BODYPART_PETROLCAP) ||
					funcidx("OnPlayerShotVehicle") == -1)
				{
					if(IsPetrolCapDestroyToggled(hitid))
	    			{
						if(	IsUnoccupiedDamageToggled(hitid) ||
							IsVehicleOccupied(hitid))
						{
					        new Float:pos[3];
	                        GetVehiclePos(hitid, pos[0], pos[1], pos[2]);
	                        CreateExplosion(pos[0], pos[1], pos[2], 3, 25.0);
	                        return SetVehicleToRespawn(hitid);
					    }
					}
					else
					{
						fHealth -= fDamage;
						SetVehicleHealth(hitid, fHealth);

						switch(fHealth)
						{
						    case 251..399: return Vehicle_UpdateVehicleDamage(hitid, VEHICLE_DAMAGE_DOORS);
						    case 400..599: return Vehicle_UpdateVehicleDamage(hitid, VEHICLE_DAMAGE_PANELS);
						    case 600..700: return Vehicle_UpdateVehicleDamage(hitid, VEHICLE_DAMAGE_LIGHTS);
						}
					}
				}
				else return 0;
			}

			if(	CallLocalFunction("OnPlayerShotVehicle", "iiifi", playerid, hitid, weaponid, fDamage, VEHICLE_BODYPART_UNKNOWN) ||
				funcidx("OnPlayerShotVehicle") == -1)
			{
			    if(IsUnoccupiedDamageToggled(hitid))
			    {
					fHealth -= fDamage;
					SetVehicleHealth(hitid, fHealth);

					switch(floatround(fHealth))
					{
					    case 251..399: return Vehicle_UpdateVehicleDamage(hitid, VEHICLE_DAMAGE_DOORS);
					    case 400..599: return Vehicle_UpdateVehicleDamage(hitid, VEHICLE_DAMAGE_PANELS);
					    case 600..700: return Vehicle_UpdateVehicleDamage(hitid, VEHICLE_DAMAGE_LIGHTS);
					}
				}
			}
			else return 0;
		}
	}

	#if defined Vehicle_OnPlayerWeaponShot
        return Vehicle_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
    #else
        return 1;
    #endif
}
#if defined Vehicle_OnPlayerWeaponShot
    forward Vehicle_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
#endif
#if defined _ALS_OnPlayerWeaponShot
    #undef OnPlayerWeaponShot
#else
    #define _ALS_OnPlayerWeaponShot
#endif
#define OnPlayerWeaponShot Vehicle_OnPlayerWeaponShot

forward OnPlayerShotVehicle(playerid, vehicleid, weaponid, Float:amount, bodypart);

stock IsVehicleOccupied(vehicleid)
{
    for(new i; i < MAX_PLAYERS; i++)
    {
        if(	IsPlayerConnected(i) &&
			IsPlayerInVehicle(i, vehicleid))
		{
			return true;
        }
    }
    return false;
}

stock GetVehicleDriverID(vehicleid)
{
	for(new i; i <= GetPlayerPoolSize(); i++)
    {
        if(	GetPlayerVehicleID(i) == vehicleid &&
			GetPlayerVehicleSeat(i) == 0)
		{
			return i
        }
    }
	return INVALID_PLAYER_ID;
}

stock EditVehicle(playerid, vehicleid)
{
	if(IsValidObject(Vehicle_GetPropertyInt(vehicleid, v_editor))) return false;

	new Float:pos[3];
	GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
	Vehicle_SetPropertyInt(vehicleid, v_editor, CreateObject(19300, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0));

	EditObject(playerid, Vehicle_GetPropertyInt(vehicleid, v_editor));

	gPlayerEdit[playerid] = vehicleid;
	return true;
}

#if ! defined IsValidVehicle
	native IsValidVehicle(vehicleid);
#endif

public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	if(IsValidVehicle(gPlayerEdit[playerid]))
	{
	    if(Vehicle_GetPropertyInt(gPlayerEdit[playerid], v_editor) == objectid)
	    {
	        SetVehiclePos(gPlayerEdit[playerid], fX, fY, fZ);
			SetVehicleZAngle(gPlayerEdit[playerid], fRotZ);

			CallLocalFunction("OnPlayerEditVehicle", "iiiffff", playerid, gPlayerEdit[playerid], response, fX, fY, fZ, fRotZ);

	        switch(response)
	        {
	            case EDIT_RESPONSE_CANCEL, EDIT_RESPONSE_FINAL:
	            {
					DestroyObject(objectid);
					Vehicle_SetPropertyInt(gPlayerEdit[playerid], v_editor, INVALID_OBJECT_ID);

					SetVehicleVelocity(gPlayerEdit[playerid], 0.0, 0.0, 0.0);

					gPlayerEdit[playerid] = INVALID_VEHICLE_ID;
	            }
	        }
	    }
	}

	#if defined Vehicle_OnPlayerEditObject
        return Vehicle_OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ);
    #else
        return 1;
    #endif
}
#if defined Vehicle_OnPlayerEditObject
    forward Vehicle_OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ);
#endif
#if defined _ALS_OnPlayerEditObject
    #undef OnPlayerEditObject
#else
    #define _ALS_OnPlayerEditObject
#endif
#define OnPlayerEditObject Vehicle_OnPlayerEditObject

forward OnPlayerEditVehicle(playerid, vehicleid, response, Float:fX, Float:fY, Float:fZ, Float:fRotZ);

stock GetVehicleName(vehicleid, string[], len = sizeof(string))
{
	strcat(string, gVehicleNames[GetVehicleModel(vehicleid) - 400], len);
	return true;
}

stock GetVehicleModelName(modelid, string[], len = sizeof(string))
{
	strcat(string, gVehicleNames[modelid - 400], len);
	return true;
}

stock SetVehicleParams(vehicleid, type, set)
{
	new params[7];

    if(GetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]))
	{
		params[type] = set;
		SetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
		return true;
	}
	return false;
}

stock GetVehicleParams(vehicleid, type)
{
	new params[7];
	GetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
	return params[type];
}

stock Float:GetVehicleSpeed(vehicleid, bool:kmh = true, Float:velx = 0.0, Float:vely = 0.0, Float:velz = 0.0)
{
	if(	velx == 0.0 &&
		vely == 0.0 &&
		velz == 0.0)
 	{
		GetVehicleVelocity(vehicleid, velx, vely, velz);
	}

	new Float:speed;

	if(kmh) speed = floatsqroot(((velx * velx) + (vely * vely)) + (velz * velz)) * 136.666667;
	else 	speed = floatsqroot(((velx * velx) + (vely * vely)) + (velz * velz)) * 85.4166672;

	floatround(speed, floatround_round);
	return speed;
}

stock Vehicle_AttachObjectToVehicle(objectid, vehicleid, Float:OffsetX, Float:OffsetY, Float:OffsetZ, Float:RotX, Float:RotY, Float:RotZ)
{
    for(new i; i < MAX_VEHICLE_ATTACHED_OBJECTS; i++)
	{
  		if(! IsValidObject(gVehicleAttachedObject[vehicleid][i]))
		{
		    if(AttachObjectToVehicle(objectid, vehicleid, OffsetX, OffsetY, OffsetZ, RotX, RotY, RotZ))
			{
				gVehicleAttachedObject[vehicleid][i] = objectid;
		    	return true;
		    }
		}
	}

	printf("WARNING: The object wasn't attached to the vehicle (id: %i), This may occur because the MAX_VEHICLE_ATTACHED_OBJECT limit was exceeded or the vehicle wasn't created. <vehicleplus.inc>", vehicleid);
	return false;
}
#if defined _ALS_AttachObjectToVehicle
    #undef AttachObjectToVehicle
#else
    #define _ALS_AttachObjectToVehicle
#endif
#define AttachObjectToVehicle Vehicle_AttachObjectToVehicle

stock IsObjectAttachedToVehicle(objectid, vehicleid)
{
	for(new i; i < MAX_VEHICLE_ATTACHED_OBJECTS; i++)
	{
  		if(IsValidObject(gVehicleAttachedObject[vehicleid][i]))
		{
		    if(gVehicleAttachedObject[vehicleid][i] == objectid) return true;
		}
	}
	return false;
}

stock GetVehicleSlotAttachedObject(vehicleid, slot)
{
	if(! IsValidObject(gVehicleAttachedObject[vehicleid][slot])) return -1;

	return gVehicleAttachedObject[vehicleid][slot];

}

stock TeleportVehicle(vehicleid, Float:x, Float:y, Float:z, Float:rotation, worldid = -1, interiorid = -1)
{
	for(new i; i <= GetPlayerPoolSize(); i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(GetPlayerVehicleID(i) == vehicleid)
	        {
	            if(worldid != -1)
				{
					SetPlayerVirtualWorld(i, worldid);
				}
				else
				{
					SetPlayerVirtualWorld(i, GetVehicleVirtualWorld(vehicleid));
				}
	            if(interiorid != -1)
				{
					SetPlayerInterior(i, interiorid);
				}
				else
				{
					SetPlayerInterior(i, GetVehicleInterior(vehicleid));
				}
	        }
	    }
	}

 	if(worldid != -1)
	{
		SetVehicleVirtualWorld(vehicleid, worldid);
	}
	if(interiorid != -1)
	{
		SetVehicleInterior(vehicleid, interiorid);
	}

	SetVehiclePos(vehicleid, x, y, z);
	SetVehicleZAngle(vehicleid, rotation);
	return true;
}

stock SetVehicleSpeedCap(vehicleid, Float:maxspeed)
{
    return Vehicle_SetPropertyFloat(vehicleid, v_speedcap, maxspeed);
}

stock Float:GetVehicleSpeedCap(vehicleid)
{
    return Vehicle_GetPropertyFloat(vehicleid, v_speedcap);
}

stock DisableVehicleSpeedCap(vehicleid)
{
	return SetVehicleSpeedCap(vehicleid, 0);
}

public OnPlayerUpdate(playerid)
{
 	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new vehicleid;
		vehicleid = GetPlayerVehicleID(playerid);

		new Float:speedcap;
		speedcap = GetVehicleSpeedCap(vehicleid);

		new Float:vel[3];
		GetVehicleVelocity(vehicleid, vel[0], vel[1], vel[2]);

		new Float:speed;
		speed = GetVehicleSpeed(vehicleid, true, vel[0], vel[1], vel[2]);

		if(speedcap != 0.0)
		{
			if(speed > speedcap)
			{
			    if(	funcidx("OnPlayerReachSpeedCapLimit") == -1 ||
					CallLocalFunction("OnPlayerReachSpeedCapLimit", "iif", playerid, vehicleid, speed))
			    {
					vel[0] = (vel[0] / speed) * speedcap;
					vel[1] = (vel[1] / speed) * speedcap;
					vel[2] = (vel[2] / speed) * speedcap;

					SetVehicleVelocity(vehicleid, vel[0], vel[1], vel[2]);
				}
			}
		}
	}

	#if defined Vehicle_OnPlayerUpdate
        return Vehicle_OnPlayerUpdate(playerid);
    #else
        return 1;
    #endif
}
#if defined Vehicle_OnPlayerUpdate
    forward Vehicle_OnPlayerUpdate(playerid);
#endif
#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate Vehicle_OnPlayerUpdate

forward OnPlayerReachSpeedCapLimit(playerid, vehicleid, Float:speed);

stock GetVehicleTopSpeed(vehicleid)
{
	return gVehicleTopSpeed[GetVehicleModel(vehicleid) - 400];
}

stock GetVehicleModelTopSpeed(modelid)
{
	return gVehicleTopSpeed[modelid - 400];
}

stock SetVehicleSpawnInfo(vehicleid, Float:x, Float:y, Float:z, Float:rotation, worldid, interiorid)
{
	Vehicle_SetPropertyFloat(vehicleid, v_spawn<0>, x);
	Vehicle_SetPropertyFloat(vehicleid, v_spawn<1>, y);
	Vehicle_SetPropertyFloat(vehicleid, v_spawn<2>, z);
	Vehicle_SetPropertyFloat(vehicleid, v_spawn<3>, rotation);

	Vehicle_SetPropertyInt(vehicleid, v_spawn_worldid, worldid);
	Vehicle_SetPropertyInt(vehicleid, v_spawn_interiorid, interiorid);
	return true;
}

stock GetVehicleSpawnInfo(vehicleid, &Float:x, &Float:y, &Float:z, &Float:rotation, &worldid, &interiorid)
{
	x = Vehicle_GetPropertyFloat(vehicleid, v_spawn<0>);
	y = Vehicle_GetPropertyFloat(vehicleid, v_spawn<1>);
	z = Vehicle_GetPropertyFloat(vehicleid, v_spawn<2>);
	rotation = Vehicle_GetPropertyFloat(vehicleid, v_spawn<3>);

	worldid = Vehicle_GetPropertyInt(vehicleid, v_spawn_worldid);
	interiorid = Vehicle_GetPropertyInt(vehicleid, v_spawn_interiorid);
	return true;
}

stock ToggleUnoccupiedVehicleDamage(vehicleid, bool:toggle)
{
	return Vehicle_SetPropertyInt(vehicleid, v_spawn_uno_damage, _:toggle);
}

stock IsUnoccupiedDamageToggled(vehicleid)
{
	return Vehicle_GetPropertyInt(vehicleid, v_spawn_uno_damage);
}

stock ToggleVehiclePetrolCapDestroy(vehicleid, bool:toggle)
{
	return Vehicle_SetPropertyInt(vehicleid, v_petrolcap, _:toggle);
}

stock IsPetrolCapDestroyToggled(vehicleid)
{
	return Vehicle_GetPropertyInt(vehicleid, v_petrolcap);
}

stock SetVehicleBomb(vehicleid, time = 1000)
{
	if(IsVehicleBombed(vehicleid))
	{
	    SetVehicleParams(vehicleid, VEHICLE_PARAMS_ALARM, VEHICLE_PARAMS_OFF);
		if(Vehicle_GetPropertyInt(vehicleid, v_bomb_timer) != -1)
		{
		    KillTimer(Vehicle_GetPropertyInt(vehicleid, v_bomb_timer));
		    Vehicle_SetPropertyInt(vehicleid, v_bomb_timer, -1);
		}
	}
	return Vehicle_SetPropertyInt(vehicleid, v_bomb, time);
}

stock GetVehicleBomb(vehicleid)
{
	return Vehicle_GetPropertyInt(vehicleid, v_bomb);
}

stock RemoveVehicleBomb(vehicleid)
{
	return SetVehicleBomb(vehicleid, 0);
}

stock IsVehicleBombed(vehicleid)
{
	if(GetVehicleBomb(vehicleid)) return true;
	return false;
}

stock IsVehicleBombActivated(vehicleid)
{
    if(IsVehicleBombed(vehicleid))
    {
        if(Vehicle_GetPropertyInt(vehicleid, v_bomb_timer) != -1)
        {
            return true;
        }
    }
    return false;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);

		if(IsVehicleBombed(vehicleid))
		{
		    if(! IsVehicleBombActivated(vehicleid))
		    {
		        if(	CallLocalFunction("OnVehicleBombActivate", "i", vehicleid) ||
					funcidx("OnVehicleBombActivate") == -1)
		        {
		            new interval = (GetVehicleBomb(vehicleid) - 1750);
		            if(interval < 1750)
		            {
    					SetVehicleParams(vehicleid, VEHICLE_PARAMS_ALARM, VEHICLE_PARAMS_ON);
		            	Vehicle_SetPropertyInt(vehicleid, v_bomb_timer, SetTimerEx("Vehicle_OnVehicleBombExplode", GetVehicleBomb(vehicleid), false, "ii", playerid, vehicleid));
					}
		            else
		            {
		        		Vehicle_SetPropertyInt(vehicleid, v_bomb_timer, SetTimerEx("Vehicle_OnVehicleBombActivate", interval, false, "ii", playerid, vehicleid));
					}
				}
		    }
		}

		if(IsVehicleSticky(vehicleid))
		{
		    SetVehicleParams(vehicleid, VEHICLE_PARAMS_ENGINE, VEHICLE_PARAMS_OFF);
		}
	}

	if(oldstate == PLAYER_STATE_DRIVER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);

		if(IsVehicleSticky(vehicleid))
		{
		    SetVehicleParams(vehicleid, VEHICLE_PARAMS_ENGINE, VEHICLE_PARAMS_ON);
		}
	}

	#if defined Vehicle_OnPlayerStateChange
        return Vehicle_OnPlayerStateChange(playerid, newstate, oldstate);
    #else
        return 1;
    #endif
}
#if defined Vehicle_OnPlayerStateChange
    forward Vehicle_OnPlayerStateChange(playerid, newstate, oldstate);
#endif
#if defined _ALS_OnPlayerStateChange
    #undef OnPlayerStateChange
#else
    #define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange Vehicle_OnPlayerStateChange

forward OnVehicleBombActivate(vehicleid);

forward Vehicle_OnVehicleBombActivate(playerid, vehicleid);
public Vehicle_OnVehicleBombActivate(playerid, vehicleid)
{
    SetVehicleParams(vehicleid, VEHICLE_PARAMS_ALARM, VEHICLE_PARAMS_ON);
    Vehicle_SetPropertyInt(vehicleid, v_bomb_timer, SetTimerEx("Vehicle_OnVehicleBombExplode", 1750, false, "ii", playerid, vehicleid));
	return 1;
}

forward Vehicle_OnVehicleBombExplode(playerid, vehicleid);
public Vehicle_OnVehicleBombExplode(playerid, vehicleid)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    if(	! CallLocalFunction("OnVehicleBombDeactivate", "i", vehicleid) ||
			funcidx("OnVehicleBombDeactivate") == -1)
		{
    		return SetVehicleParams(vehicleid, VEHICLE_PARAMS_ALARM, VEHICLE_PARAMS_OFF);
		}
	}

	CallLocalFunction("OnVehicleBombExplode", "i", vehicleid);

	SetVehicleParams(vehicleid, VEHICLE_PARAMS_ALARM, VEHICLE_PARAMS_OFF);

	new Float:pos[3];
    GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
   	CreateExplosion(pos[0], pos[1], pos[2], 3, 30.0);
   	SetVehicleToRespawn(vehicleid);

   	if(GetPlayerVehicleID(playerid) == vehicleid)
   	{
   		SetPlayerHealth(playerid, 0.0);
   		GameTextForPlayer(playerid, "~r~Bombed !", 3500, 3);
   	}

    Vehicle_SetPropertyInt(vehicleid, v_bomb_timer, -1);
	return 1;
}

forward OnVehicleBombDeactivate(vehicleid);
forward OnVehicleBombExplode(vehicleid);

stock ToggleVehicleSticky(vehicleid, bool:toggle)
{
    return Vehicle_SetPropertyInt(vehicleid, v_sticky, _:toggle);
}

stock IsVehicleSticky(vehicleid)
{
	return Vehicle_GetPropertyInt(vehicleid, v_sticky);
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	if(Vehicle_GetPropertyInt(vehicleid, v_update_timer) == -1)
	{
		Vehicle_SetPropertyInt(vehicleid, v_update_timer, SetTimerEx("OnVehicleTimeUpdate", VEHICLE_UPDATE_INTERVAL, true, "i", vehicleid));
	}

	#if defined Vehicle_OnVehicleStreamIn
        return Vehicle_OnVehicleStreamIn(vehicleid, forplayerid);
    #else
        return 1;
    #endif
}
#if defined Vehicle_OnVehicleStreamIn
    forward Vehicle_OnVehicleStreamIn(vehicleid, forplayerid);
#endif
#if defined _ALS_OnVehicleStreamIn
    #undef OnVehicleStreamIn
#else
    #define _ALS_OnVehicleStreamIn
#endif
#define OnVehicleStreamIn Vehicle_OnVehicleStreamIn

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	if(Vehicle_GetPropertyInt(vehicleid, v_update_timer) != -1)
	{
	    for(new i; i <= GetPlayerPoolSize(); i++)
	    {
	        if(IsPlayerStreamedIn(vehicleid, i)) break;

			if(i == GetPlayerPoolSize())
			{
				KillTimer(Vehicle_GetPropertyInt(vehicleid, v_update_timer));
				Vehicle_SetPropertyInt(vehicleid, v_update_timer, -1);
			}
		}
	}

	#if defined Vehicle_OnVehicleStreamOut
        return Vehicle_OnVehicleStreamOut(vehicleid, forplayerid);
    #else
        return 1;
    #endif
}
#if defined Vehicle_OnVehicleStreamOut
    forward Vehicle_OnVehicleStreamOut(vehicleid, forplayerid);
#endif
#if defined _ALS_OnVehicleStreamOut
    #undef OnVehicleStreamOut
#else
    #define _ALS_OnVehicleStreamOut
#endif
#define OnVehicleStreamOut Vehicle_OnVehicleStreamOut

forward OnVehicleTimeUpdate(vehicleid);
public OnVehicleTimeUpdate(vehicleid)
{
	new Float:FloatData[4];

	GetVehiclePos(vehicleid, FloatData[0], FloatData[1], FloatData[2]);
	GetVehicleZAngle(vehicleid, FloatData[3]);
	if(IsVehicleSticky(vehicleid))
	{
	 	if(	(FloatData[0] > gVehicleFloat[vehicleid][0] + 0.5 || FloatData[0] < gVehicleFloat[vehicleid][0] - 0.5) ||
			(FloatData[1] > gVehicleFloat[vehicleid][1] + 0.5 || FloatData[1] < gVehicleFloat[vehicleid][1] - 0.5) ||
			(FloatData[2] > gVehicleFloat[vehicleid][2] + 0.5 || FloatData[2] < gVehicleFloat[vehicleid][2] - 0.5) ||
			(FloatData[3] > gVehicleFloat[vehicleid][3] + 0.5 || FloatData[3] < gVehicleFloat[vehicleid][3] - 0.5))
		{
			return TeleportVehicle(vehicleid, gVehicleFloat[vehicleid][0], gVehicleFloat[vehicleid][1], gVehicleFloat[vehicleid][2], gVehicleFloat[vehicleid][3], GetVehicleInterior(vehicleid), GetVehicleVirtualWorld(vehicleid));
 	 	}
    }
	if(funcidx("OnVehiclePosChange") != -1)
	{
		if(	FloatData[0] != gVehicleFloat[vehicleid][0] ||
		    FloatData[1] != gVehicleFloat[vehicleid][1] ||
		    FloatData[2] != gVehicleFloat[vehicleid][2] ||
		    FloatData[3] != gVehicleFloat[vehicleid][3])
	 	{
	 	    if(CallLocalFunction("OnVehiclePosChange", "iffffffff", vehicleid, FloatData[0], FloatData[1], FloatData[2], FloatData[3], gVehicleFloat[vehicleid][0], gVehicleFloat[vehicleid][1], gVehicleFloat[vehicleid][2], gVehicleFloat[vehicleid][3]))
	 	    {
	 	        gVehicleFloat[vehicleid][0] = FloatData[0];
			    gVehicleFloat[vehicleid][1] = FloatData[1];
			    gVehicleFloat[vehicleid][2] = FloatData[2];
			   	gVehicleFloat[vehicleid][3] = FloatData[3];
	 	    }
	 	    else
	 	    {
	 	        return TeleportVehicle(vehicleid, gVehicleFloat[vehicleid][0], gVehicleFloat[vehicleid][1], gVehicleFloat[vehicleid][2], gVehicleFloat[vehicleid][3], GetVehicleInterior(vehicleid), GetVehicleVirtualWorld(vehicleid));
	 	    }
		}
 	}

	GetVehicleVelocity(vehicleid, FloatData[0], FloatData[1], FloatData[2]);
	if(funcidx("OnVehicleVelocityChange") != -1)
 	{
	 	if(	FloatData[0] != gVehicleFloat[vehicleid][4] ||
		    FloatData[1] != gVehicleFloat[vehicleid][5] ||
		    FloatData[2] != gVehicleFloat[vehicleid][6])
 		{
	 	    if(CallLocalFunction("OnVehicleVelocityChange", "iffffff", vehicleid, FloatData[0], FloatData[1], FloatData[2], gVehicleFloat[vehicleid][4], gVehicleFloat[vehicleid][5], gVehicleFloat[vehicleid][6]))
	 	    {
		 	    gVehicleFloat[vehicleid][4] = FloatData[0];
				gVehicleFloat[vehicleid][5] = FloatData[1];
				gVehicleFloat[vehicleid][6] = FloatData[2];
	 	    }
	 	    else
	 	    {
	 	        return SetVehicleVelocity(vehicleid, gVehicleFloat[vehicleid][4], gVehicleFloat[vehicleid][5], gVehicleFloat[vehicleid][6]);
	 	    }
		}
	}

	GetVehicleHealth(vehicleid, FloatData[0]);
 	if(funcidx("OnVehicleHealthChange") != -1)
 	{
	 	if(FloatData[0] != gVehicleFloat[vehicleid][7])
	 	{
	 	    if(CallLocalFunction("OnVehicleHealthChange", "iff", vehicleid, FloatData[0], gVehicleFloat[vehicleid][7]))
	 	    {
				gVehicleFloat[vehicleid][7] = FloatData[0];
	 	    }
	 	    else
	 	    {
				return SetVehicleHealth(vehicleid, gVehicleFloat[vehicleid][7]);
	 	    }
	 	}
	}
	return 1;
}

forward OnVehiclePosChange(vehicleid, Float:newx, Float:newy, Float:newz, Float:newrotation, Float:oldx, Float:oldy, Float:oldz, Float:oldrotation);
forward OnVehicleVelocityChange(vehicleid, Float:newx, Float:newy, Float:newz, Float:oldx, Float:oldy, Float:oldz);
forward OnVehicleHealthChange(vehicleid, Float:newhealth, Float:oldhealth);

stock CountAllVehicles()
{
	new count;
	for(new i; i <= GetVehiclePoolSize(); i++)
	{
		if(IsValidVehicle(i))
		{
			count += 1;
		}
	}
	return count;
}

stock DestroyAllVehicles()
{
	for(new i; i <= GetVehiclePoolSize(); i++)
	{
		if(IsValidVehicle(i))
		{
			DestroyVehicle(i);
		}
	}
	return true;
}

