#define MAX_SLOTS 50

enum Slots::enum
{
Float:Slots::X,
Float:Slots::Y,
Float:Slots::Z,
Float:Slots::RX,
Float:Slots::RY,
Float:Slots::RZ,
	Slots::VW,
	Slots::Int,
	Slots::MinBet,
	Slots::MaxBet,
Text3D:Slots::Label,
	Slots::Object
}

new Slots[MAX_SLOTS][Slots::enum];

new Iterator:Slots::Iter<MAX_SLOTS>;

stock Slots::Create(Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, VirtualWorld, Interior, MinBet, MaxBet)
{
	new firstfree = Iter_Free(Slots::Iter);
	if(firstfree == -1 ) return 0;
	Iter_Add(Slots::Iter, firstfree);
	Slots[firstfree][Slots::X] = x;
	Slots[firstfree][Slots::Y] = y;
	Slots[firstfree][Slots::Z] = z;
	Slots[firstfree][Slots::RX] = rx;
	Slots[firstfree][Slots::RY] = ry;
	Slots[firstfree][Slots::RZ] = rz;
	Slots[firstfree][Slots::VW] = VirtualWorld;
	Slots[firstfree][Slots::Int] = Interior;
	Slots[firstfree][Slots::MinBet] = MinBet;
	Slots[firstfree][Slots::MaxBet] = MaxBet;
	Slots[firstfree][Slots::Label] = CreateDynamic3DTextLabel("Click ALT", COLOR<GREEN>, x, y, z, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, VirtualWorld, Interior);
	Slots[firstfree][Slots::Object] = CreateDynamicObject(1838, x, y, z, rx, ry, rz, VirtualWorld, Interior);
	return 1;
}