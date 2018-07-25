#define MAX_SKINS (4)

#define MAX_MALE_REGISTRATION_SKINS (2)

#define MAX_FEMALE_REGISTRATION_SKINS (2)

static 
		Skin_RegistrationMale[MAX_MALE_REGISTRATION_SKINS][1] =
		{
			{25000},
			{25001}
		},
		Skin_RegistrationFemale[MAX_FEMALE_REGISTRATION_SKINS][1] =
		{
			{25002},
			{25003}
		}/*,
		Skin_List[MAX_SKINS][1] = 
		{
			{25000},
			{25001},
			{25002},
			{25003}
		}*/;	

GenerateSpawnSkin(sex, &skinid)
{
	switch(sex)
	{
		case 1:
		{
			new index = random(sizeof(Skin_RegistrationMale));

			skinid = Skin_RegistrationMale[index][0];
		}	
		case 2:
		{
			new index = random(sizeof(Skin_RegistrationFemale));

			skinid = Skin_RegistrationFemale[index][0];		
		}	
	}	
}