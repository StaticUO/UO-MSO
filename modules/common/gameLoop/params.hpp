
#define DFT_TIME_LIMIT		90		// Minutes

class TimeLimit
{
	title = "Mission Time Limit";
	values[] = {    0,          30,      60,                 90,      120,                 150,      180,                 210,      240};
	texts[] = {"None","30 Minutes","1 Hour","1 Hour 30 Minutes","2 Hours","2 Hours 30 Minutes","3 Hours","3 Hours 30 Minutes","4 Hours"};
	default = DFT_TIME_LIMIT;
};