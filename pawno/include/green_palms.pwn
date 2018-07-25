// Southern Bone County

//Color tags for textdraw use
#define FIRST_TEAM_COLOR_TAG "{EDC9AF}DESERT"
#define SECOND_TEAM_COLOR_TAG "{FFA500}ORANGE"
#define THIRD_TEAM_COLOR_TAG "{CCCCFF}PERIWINKLE"

#define FIRST_TEAM_NAME_TAG "DESERT"
#define SECOND_TEAM_NAME_TAG "ORANGE"
#define THIRD_TEAM_NAME_TAG "PERIWINKLE"


#define TEAM_ONE_SEL_INTERIOR 0
#define TEAM_TWO_SEL_INTERIOR 0
#define TEAM_THREE_SEL_INTERIOR 0

#define TEAM_ONE_INTERIOR 0
#define TEAM_TWO_INTERIOR 0
#define TEAM_THREE_INTERIOR 0


// Team colors
#define COLOR_TEAM_ONE 0xEDC9AF55 //Desert
#define COLOR_TEAM_TWO 0xFFA50055 //Orange
#define COLOR_TEAM_THREE 0xCCCCFF55 //Periwinkle

// TD Colors
#define COLOR_TEAM_ONE_TD 0xEDC9AFFF //Desert
#define COLOR_TEAM_TWO_TD 0xFFA500FF //Orange
#define COLOR_TEAM_THREE_TD 0xCCCCFFFF //Periwinkle

#define COLOR_TEAM_ONE_STEALTH 0xEDC9AF00 //Desert
#define COLOR_TEAM_TWO_STEALTH 0xFFA50000 //Orange
#define COLOR_TEAM_THREE_STEALTH 0xCCCCFF00 //Periwinkle



//Where the teams are located..
#define FIRST_TEAM_LOCATION "Green Palms Launchpad"
#define SECOND_TEAM_LOCATION "Hunter Quarry"
#define THIRD_TEAM_LOCATION "Big Ear Telescope"

#define TEAMSIZE 3


stock const Float:Center[][]={
{-142.2778,1123.0687,19.7500}	
};

stock const Float:GlobalActors[][]={
	{341.8353,843.2407,20.0347,13.3214}, // shoporange1
	{601.1827,867.0878,-42.9609,83.1954}, // shoporange2
	{817.0895,856.3974,12.7891,199.7799}, // shoporange3
	{-329.4089,1536.4227,76.6117,181.4897}, // shop periwinkle
	{213.6636,1427.2020,10.6250,88.1620}//shop Desert
};

stock const Float:GlobalZones[][]={
	{93.423, 1307.922, 280.269, 1518.124},//Desert
	{338.6584, 700.6725, 852.4849, 1051.009},//Orange
	{-420.4035, 1377.989, -175.1681, 1681.614}//Periwinkle
};

stock const Float:PlayerInfoPickups[][]={
	{0.0,0.0,0.0}

};


stock const Float:MoneySpawns[][]={	
	{231.0089,224.0765,1436.6581,1434.9581,46.2940,46.0940},//Desert
	{338.4234,330.5255,839.4213,836.9364,20.0940,19.7940},//Orange
	{-339.6529,-346.6533,1548.5590,1535.3082,75.5625,74.9625},//Periwinkle
	{-134.4305,-149.6918,1137.0719,1109.1409,19.7422,19.5422}//Main
};


stock const Float:MAP_WORLDBOUNDS[][]={
	{934.23, -513.8265, 1810.071, 607.2495}
};

stock const Float:ClassSel_SetupTeamTEAM_POS[][]={
	{248.9369,1411.4631,126.4180},//Desert
	{709.4109,916.1399,53.6736},//Orange
	{-305.0680,1552.4607,167.9536}//Periwinkle
};

stock const Float:ClassSel_SetupTeamTEAM_LOOK_AT[][]={
	{205.9405,1437.0804,98.4145},//Desert
	{485.8182,810.5039,18.3920},//Orange
	{-343.7542,1593.1016,138.3667}//Periwinkle
};


stock const Float:beds[][] = {
	{214.2851,1417.9414,128.0661},//Desert
	{-955.2665,1867.7350,5.6661},//Orange
	{-347.4075,1588.5675,103.6661}//Periwinkle
};

stock const Float:gSpawnsTeam_TEAM_ONE[][] = {//Desert
	{220.6359,1424.8153,127.3000,268.9338}, // desert1
	{224.2167,1436.7289,62.7250,175.2462}, // desert2
	{228.9318,1435.5918,46.2940,87.4886}, // desert3
	{209.8716,1444.1925,10.5859,182.1162}, // desert4
	{193.2301,1449.8594,10.5859,270.8137}, // desert5
	{123.5041,1375.7120,10.5925,269.2469}, // desert6
	{217.7420,1418.4012,39.3234,90.9820}, // desert7
	{209.8729,1427.2366,10.5859,87.8487}, // desert8
	{262.1546,1456.8375,10.5859,177.1261} // desert9
};

stock const Float:gSpawnsTeam_TEAM_TWO[][] = {//Orange
	{333.4372,847.0017,20.2599,20.4581}, // orange1
	{405.1378,839.9724,18.8076,102.5288}, // orange2
	{351.8017,857.3542,20.4063,7.2020}, // orange3
	{335.2296,837.8307,20.0940,283.3004}, // orange4
	{306.1212,872.1361,20.4063,241.3134}, // orange5
	{291.1563,914.8307,20.3990,272.6470}, // orange6
	{424.8465,859.2374,6.5921,290.8205} // orange7
};

stock const Float:gSpawnsTeam_TEAM_THREE[][] = {//Periwinkle
	{-345.6883,1582.0767,76.2671,265.1504}, // dark1
	{-331.3752,1557.8754,75.5625,278.6239}, // dark2
	{-300.2899,1530.4225,75.3594,272.3572}, // dark3
	{-332.6735,1513.9828,75.3594,91.5621}, // dark4
	{-345.0571,1543.1832,75.5625,327.7943}, // dark5
	{-365.9820,1510.3535,75.5625,270.7671} // dark6
};