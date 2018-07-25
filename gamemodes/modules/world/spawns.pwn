
#define MAX_SPAWNS (2)


static
	Float:spawn_List[MAX_SPAWNS][4] =
	{
		{1154.4353,		-1769.2559,		16.5938269, 0.2440},
		{1204.6016,		-1755.3619,		13.5830,	75.1184}

	};



GenerateSpawnPoint(&Float:x, &Float:y, &Float:z, &Float:r)
{
	new index = random(sizeof(spawn_List));

	x = spawn_List[index][0];
	y = spawn_List[index][1];
	z = spawn_List[index][2];
	r = spawn_List[index][3];
}