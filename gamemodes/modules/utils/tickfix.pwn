stock GetTickCountDifference(newtick, oldtick)
{
	if (oldtick < 0 && newtick >= 0)
		return newtick - oldtick;

	else if (oldtick >= 0 && newtick < 0 || oldtick > newtick)
		return (cellmax - oldtick + 1) - (cellmin - newtick);

	return newtick - oldtick;
}