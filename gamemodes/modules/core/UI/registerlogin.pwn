#include <YSI\y_hooks>



static Text:RegisterLoginUI[22];



hook OnGameModeInit()
{
	CreateRegisterLoginUI("FEAR THE WALKING DEADS", "TRY TO SURVIVE !");
	return 1;
}



stock ShowPlayerRegisterLoginUI(playerid)
{

	for(new i; i< sizeof(RegisterLoginUI);i++)
	{
		TextDrawShowForPlayer(playerid, RegisterLoginUI[i]);
	}

}

stock HidePlayerRegisterLoginUI(playerid)
{

	for(new i; i < sizeof(RegisterLoginUI);i++)
	{
		TextDrawHideForPlayer(playerid, RegisterLoginUI[i]);
	}

}

CreateRegisterLoginUI(servername[], title[])
{
	RegisterLoginUI[0] = TextDrawCreate(1.859429, 5.666685, "box");
	TextDrawLetterSize(RegisterLoginUI[0], 0.000000, 48.746696);
	TextDrawTextSize(RegisterLoginUI[0], 639.000000, 0.000000);
	TextDrawAlignment(RegisterLoginUI[0], 1);
	TextDrawColor(RegisterLoginUI[0], -1);
	TextDrawUseBox(RegisterLoginUI[0], 1);
	TextDrawBoxColor(RegisterLoginUI[0], 215);
	TextDrawSetShadow(RegisterLoginUI[0], 0);
	TextDrawSetOutline(RegisterLoginUI[0], 0);
	TextDrawBackgroundColor(RegisterLoginUI[0], 215);
	TextDrawFont(RegisterLoginUI[0], 2);
	TextDrawSetProportional(RegisterLoginUI[0], 1);
	TextDrawSetShadow(RegisterLoginUI[0], 0);
	TextDrawSetSelectable(RegisterLoginUI[0], true);

	RegisterLoginUI[1] = TextDrawCreate(94.458297, 68.666656, "");
	TextDrawLetterSize(RegisterLoginUI[1], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[1], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[1], 1);
	TextDrawColor(RegisterLoginUI[1], -1);
	TextDrawSetShadow(RegisterLoginUI[1], 0);
	TextDrawSetOutline(RegisterLoginUI[1], 0);
	TextDrawBackgroundColor(RegisterLoginUI[1], 215);
	TextDrawFont(RegisterLoginUI[1], 5);
	TextDrawSetProportional(RegisterLoginUI[1], 0);
	TextDrawSetShadow(RegisterLoginUI[1], 0);
	TextDrawSetPreviewModel(RegisterLoginUI[1], 160);
	TextDrawSetPreviewRot(RegisterLoginUI[1], 0.000000, 0.000000, 0.000000, 1.000000);

	RegisterLoginUI[2] = TextDrawCreate(158.639572, 104.466674, "FEAR_THE_WALKING_DEADS");
	TextDrawLetterSize(RegisterLoginUI[2], 0.552738, 2.988332);
	TextDrawAlignment(RegisterLoginUI[2], 1);
	TextDrawColor(RegisterLoginUI[2], -607273761);
	TextDrawSetShadow(RegisterLoginUI[2], 0);
	TextDrawSetOutline(RegisterLoginUI[2], 0);
	TextDrawBackgroundColor(RegisterLoginUI[2], 215);
	TextDrawFont(RegisterLoginUI[2], 1);
	TextDrawSetProportional(RegisterLoginUI[2], 1);
	TextDrawSetShadow(RegisterLoginUI[2], 0);

	RegisterLoginUI[3] = TextDrawCreate(441.528381, 70.033332, "");
	TextDrawLetterSize(RegisterLoginUI[3], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[3], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[3], 1);
	TextDrawColor(RegisterLoginUI[3], -1);
	TextDrawSetShadow(RegisterLoginUI[3], 0);
	TextDrawSetOutline(RegisterLoginUI[3], 0);
	TextDrawBackgroundColor(RegisterLoginUI[3], 215);
	TextDrawFont(RegisterLoginUI[3], 5);
	TextDrawSetProportional(RegisterLoginUI[3], 0);
	TextDrawSetShadow(RegisterLoginUI[3], 0);
	TextDrawSetPreviewModel(RegisterLoginUI[3], 162);
	TextDrawSetPreviewRot(RegisterLoginUI[3], 0.000000, 0.000000, 0.000000, 1.000000);

	RegisterLoginUI[4] = TextDrawCreate(210.463186, 138.416305, "TRY_TO_SURVIVE_!");
	TextDrawLetterSize(RegisterLoginUI[4], 0.400000, 1.600000);
	TextDrawAlignment(RegisterLoginUI[4], 1);
	TextDrawColor(RegisterLoginUI[4], -16776961);
	TextDrawSetShadow(RegisterLoginUI[4], 0);
	TextDrawSetOutline(RegisterLoginUI[4], 0);
	TextDrawBackgroundColor(RegisterLoginUI[4], 215);
	TextDrawFont(RegisterLoginUI[4], 1);
	TextDrawSetProportional(RegisterLoginUI[4], 1);
	TextDrawSetShadow(RegisterLoginUI[4], 0);

	RegisterLoginUI[5] = TextDrawCreate(508.162780, 16.166679, "particle:bloodpool_64");
	TextDrawLetterSize(RegisterLoginUI[5], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[5], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[5], 1);
	TextDrawColor(RegisterLoginUI[5], -1);
	TextDrawSetShadow(RegisterLoginUI[5], 0);
	TextDrawSetOutline(RegisterLoginUI[5], 0);
	TextDrawBackgroundColor(RegisterLoginUI[5], 215);
	TextDrawFont(RegisterLoginUI[5], 4);
	TextDrawSetProportional(RegisterLoginUI[5], 0);
	TextDrawSetShadow(RegisterLoginUI[5], 0);

	RegisterLoginUI[6] = TextDrawCreate(546.113037, 304.333343, "particle:bloodpool_64");
	TextDrawLetterSize(RegisterLoginUI[6], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[6], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[6], 1);
	TextDrawColor(RegisterLoginUI[6], -1);
	TextDrawSetShadow(RegisterLoginUI[6], 0);
	TextDrawSetOutline(RegisterLoginUI[6], 0);
	TextDrawBackgroundColor(RegisterLoginUI[6], 215);
	TextDrawFont(RegisterLoginUI[6], 4);
	TextDrawSetProportional(RegisterLoginUI[6], 0);
	TextDrawSetShadow(RegisterLoginUI[6], 0);

	RegisterLoginUI[7] = TextDrawCreate(62.599159, 87.333316, "particle:bloodpool_64");
	TextDrawLetterSize(RegisterLoginUI[7], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[7], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[7], 1);
	TextDrawColor(RegisterLoginUI[7], -1);
	TextDrawSetShadow(RegisterLoginUI[7], 0);
	TextDrawSetOutline(RegisterLoginUI[7], 0);
	TextDrawBackgroundColor(RegisterLoginUI[7], 215);
	TextDrawFont(RegisterLoginUI[7], 4);
	TextDrawSetProportional(RegisterLoginUI[7], 0);
	TextDrawSetShadow(RegisterLoginUI[7], 0);

	RegisterLoginUI[8] = TextDrawCreate(368.075012, -5.999999, "particle:bloodpool_64");
	TextDrawLetterSize(RegisterLoginUI[8], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[8], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[8], 1);
	TextDrawColor(RegisterLoginUI[8], -1);
	TextDrawSetShadow(RegisterLoginUI[8], 0);
	TextDrawSetOutline(RegisterLoginUI[8], 0);
	TextDrawBackgroundColor(RegisterLoginUI[8], 215);
	TextDrawFont(RegisterLoginUI[8], 4);
	TextDrawSetProportional(RegisterLoginUI[8], 0);
	TextDrawSetShadow(RegisterLoginUI[8], 0);

	RegisterLoginUI[9] = TextDrawCreate(268.279937, -13.583332, "particle:bloodpool_64");
	TextDrawLetterSize(RegisterLoginUI[9], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[9], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[9], 1);
	TextDrawColor(RegisterLoginUI[9], -1);
	TextDrawSetShadow(RegisterLoginUI[9], 0);
	TextDrawSetOutline(RegisterLoginUI[9], 0);
	TextDrawBackgroundColor(RegisterLoginUI[9], 215);
	TextDrawFont(RegisterLoginUI[9], 4);
	TextDrawSetProportional(RegisterLoginUI[9], 0);
	TextDrawSetShadow(RegisterLoginUI[9], 0);

	RegisterLoginUI[10] = TextDrawCreate(133.638671, 12.083333, "particle:bloodpool_64");
	TextDrawLetterSize(RegisterLoginUI[10], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[10], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[10], 1);
	TextDrawColor(RegisterLoginUI[10], -1);
	TextDrawSetShadow(RegisterLoginUI[10], 0);
	TextDrawSetOutline(RegisterLoginUI[10], 0);
	TextDrawBackgroundColor(RegisterLoginUI[10], 215);
	TextDrawFont(RegisterLoginUI[10], 4);
	TextDrawSetProportional(RegisterLoginUI[10], 0);
	TextDrawSetShadow(RegisterLoginUI[10], 0);

	RegisterLoginUI[11] = TextDrawCreate(362.917352, 90.210007, "particle:bloodpool_64");
	TextDrawLetterSize(RegisterLoginUI[11], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[11], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[11], 1);
	TextDrawColor(RegisterLoginUI[11], -1);
	TextDrawSetShadow(RegisterLoginUI[11], 0);
	TextDrawSetOutline(RegisterLoginUI[11], 0);
	TextDrawBackgroundColor(RegisterLoginUI[11], 215);
	TextDrawFont(RegisterLoginUI[11], 4);
	TextDrawSetProportional(RegisterLoginUI[11], 0);
	TextDrawSetShadow(RegisterLoginUI[11], 0);

	RegisterLoginUI[12] = TextDrawCreate(260.783966, 98.416671, "particle:bloodpool_64");
	TextDrawLetterSize(RegisterLoginUI[12], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[12], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[12], 1);
	TextDrawColor(RegisterLoginUI[12], -1);
	TextDrawSetShadow(RegisterLoginUI[12], 0);
	TextDrawSetOutline(RegisterLoginUI[12], 0);
	TextDrawBackgroundColor(RegisterLoginUI[12], 215);
	TextDrawFont(RegisterLoginUI[12], 4);
	TextDrawSetProportional(RegisterLoginUI[12], 0);
	TextDrawSetShadow(RegisterLoginUI[12], 0);

	RegisterLoginUI[13] = TextDrawCreate(160.351543, 106.100006, "particle:bloodpool_64");
	TextDrawLetterSize(RegisterLoginUI[13], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[13], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[13], 1);
	TextDrawColor(RegisterLoginUI[13], -1);
	TextDrawSetShadow(RegisterLoginUI[13], 0);
	TextDrawSetOutline(RegisterLoginUI[13], 0);
	TextDrawBackgroundColor(RegisterLoginUI[13], 215);
	TextDrawFont(RegisterLoginUI[13], 4);
	TextDrawSetProportional(RegisterLoginUI[13], 0);
	TextDrawSetShadow(RegisterLoginUI[13], 0);

	RegisterLoginUI[14] = TextDrawCreate(408.159768, 300.933315, "particle:bloodpool_64");
	TextDrawLetterSize(RegisterLoginUI[14], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[14], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[14], 1);
	TextDrawColor(RegisterLoginUI[14], -1);
	TextDrawSetShadow(RegisterLoginUI[14], 0);
	TextDrawSetOutline(RegisterLoginUI[14], 0);
	TextDrawBackgroundColor(RegisterLoginUI[14], 215);
	TextDrawFont(RegisterLoginUI[14], 4);
	TextDrawSetProportional(RegisterLoginUI[14], 0);
	TextDrawSetShadow(RegisterLoginUI[14], 0);

	RegisterLoginUI[15] = TextDrawCreate(307.936147, 299.143315, "particle:bloodpool_64");
	TextDrawLetterSize(RegisterLoginUI[15], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[15], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[15], 1);
	TextDrawColor(RegisterLoginUI[15], -1);
	TextDrawSetShadow(RegisterLoginUI[15], 0);
	TextDrawSetOutline(RegisterLoginUI[15], 0);
	TextDrawBackgroundColor(RegisterLoginUI[15], 215);
	TextDrawFont(RegisterLoginUI[15], 4);
	TextDrawSetProportional(RegisterLoginUI[15], 0);
	TextDrawSetShadow(RegisterLoginUI[15], 0);

	RegisterLoginUI[16] = TextDrawCreate(136.281338, 302.100067, "particle:bloodpool_64");
	TextDrawLetterSize(RegisterLoginUI[16], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[16], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[16], 1);
	TextDrawColor(RegisterLoginUI[16], -1);
	TextDrawSetShadow(RegisterLoginUI[16], 0);
	TextDrawSetOutline(RegisterLoginUI[16], 0);
	TextDrawBackgroundColor(RegisterLoginUI[16], 215);
	TextDrawFont(RegisterLoginUI[16], 4);
	TextDrawSetProportional(RegisterLoginUI[16], 0);
	TextDrawSetShadow(RegisterLoginUI[16], 0);

	RegisterLoginUI[17] = TextDrawCreate(13.453052, 157.100097, "particle:bloodpool_64");
	TextDrawLetterSize(RegisterLoginUI[17], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[17], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[17], 1);
	TextDrawColor(RegisterLoginUI[17], -1);
	TextDrawSetShadow(RegisterLoginUI[17], 0);
	TextDrawSetOutline(RegisterLoginUI[17], 0);
	TextDrawBackgroundColor(RegisterLoginUI[17], 215);
	TextDrawFont(RegisterLoginUI[17], 4);
	TextDrawSetProportional(RegisterLoginUI[17], 0);
	TextDrawSetShadow(RegisterLoginUI[17], 0);

	RegisterLoginUI[18] = TextDrawCreate(159.707778, 164.683410, "particle:bloodpool_64");
	TextDrawLetterSize(RegisterLoginUI[18], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[18], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[18], 1);
	TextDrawColor(RegisterLoginUI[18], -1);
	TextDrawSetShadow(RegisterLoginUI[18], 0);
	TextDrawSetOutline(RegisterLoginUI[18], 0);
	TextDrawBackgroundColor(RegisterLoginUI[18], 215);
	TextDrawFont(RegisterLoginUI[18], 4);
	TextDrawSetProportional(RegisterLoginUI[18], 0);
	TextDrawSetShadow(RegisterLoginUI[18], 0);

	RegisterLoginUI[19] = TextDrawCreate(-1.756314, -0.649940, "particle:bloodpool_64");
	TextDrawLetterSize(RegisterLoginUI[19], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[19], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[19], 1);
	TextDrawColor(RegisterLoginUI[19], -1);
	TextDrawSetShadow(RegisterLoginUI[19], 0);
	TextDrawSetOutline(RegisterLoginUI[19], 0);
	TextDrawBackgroundColor(RegisterLoginUI[19], 215);
	TextDrawFont(RegisterLoginUI[19], 4);
	TextDrawSetProportional(RegisterLoginUI[19], 0);
	TextDrawSetShadow(RegisterLoginUI[19], 0);

	RegisterLoginUI[20] = TextDrawCreate(547.814969, 153.933441, "particle:bloodpool_64");
	TextDrawLetterSize(RegisterLoginUI[20], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[20], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[20], 1);
	TextDrawColor(RegisterLoginUI[20], -1);
	TextDrawSetShadow(RegisterLoginUI[20], 0);
	TextDrawSetOutline(RegisterLoginUI[20], 0);
	TextDrawBackgroundColor(RegisterLoginUI[20], 215);
	TextDrawFont(RegisterLoginUI[20], 4);
	TextDrawSetProportional(RegisterLoginUI[20], 0);
	TextDrawSetShadow(RegisterLoginUI[20], 0);

	RegisterLoginUI[21] = TextDrawCreate(265.000000, 155.000000, "particle:bloodpool_64");
	TextDrawLetterSize(RegisterLoginUI[21], 0.000000, 0.000000);
	TextDrawTextSize(RegisterLoginUI[21], 90.000000, 90.000000);
	TextDrawAlignment(RegisterLoginUI[21], 1);
	TextDrawColor(RegisterLoginUI[21], -1);
	TextDrawSetShadow(RegisterLoginUI[21], 0);
	TextDrawSetOutline(RegisterLoginUI[21], 0);
	TextDrawBackgroundColor(RegisterLoginUI[21], 215);
	TextDrawFont(RegisterLoginUI[21], 4);
	TextDrawSetProportional(RegisterLoginUI[21], 0);
	TextDrawSetShadow(RegisterLoginUI[21], 0);	

	//
	TextDrawSetString(RegisterLoginUI[2], servername);
	TextDrawSetString(RegisterLoginUI[4], title);
}