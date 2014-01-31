
#define DFT_CLIENT_VD		3200
#define DFT_CLIENT_TG		25
#define DFT_CLIENT_ACEVD	1
#define DFT_CLIENT_ACETG	0

class ClientVD
{
	title = "Client View Distance";
	values[] = {1600, 2400, 3200, 4800, 6400};
	texts[] = {"1600 Meters", "2400 Meters", "3200 Meters (Recommended)", "4800 Meters", "6400 Meters"};
	default = DFT_CLIENT_VD;
};

class ClientTG
{
	title = "Terrain Grid";
	values[] = {50, 25, 12.5, 6.25, 3.125};
	texts[] = {"Very Low (No Grass)", "Low (Multiplayer Default)", "Normal (Singleplayer Default)", "High", "Very High"};
	default = DFT_CLIENT_TG;
};

class ACEVD
{
	title = "ACE Settings View Distance Change";
	values[] = {0, 1};
	texts[] = {"Block", "Allow"};
	toBool = 1;
	default = DFT_CLIENT_ACEVD;
};

class ACETG
{
	title = "ACE Settings Terrain Grid Change";
	values[] = {0, 1};
	texts[] = {"Block (Highly Recommended)", "Allow"};
	toBool = 1;
	default = DFT_CLIENT_ACETG;
};