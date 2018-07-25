enum Weapon::enum
{
	Weapon::ID,
	Weapon::Damage
}

new WeaponD[40][Weapon::enum];

stock Weapon::SetDamage(weaponid, Float:damage)
{
	WeaponD[weaponid][Weapon::ID] = weaponid;
	WeaponD[weaponid][Weapon::Damage] = damage;
}


stock Weapon::GetDamage(weaponid)
{
	new wpn_dmg;
	wpn_dmg = floatround(WeaponD[weaponid][Weapon::Damage]);
	return wpn_dmg;
}

