

#define DFT_START_HOUR		2
#define DFT_START_MINUTE	0
#define DFT_START_DAY		10
#define DFT_START_MONTH		3

class Hour
{
	title = "Hour";
	values[]	= {  0,    1,    2,    3,    4,    5,    6,    7,    8,    9,   10,   11,   12,   13,   14,   15,   16,   17,   18,   19,   20,   21,   22,   23 };
	texts[]		= {"00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"};
	default		= DFT_START_HOUR;
};

class Minute
{
	title = "Minute";
	values[]	= {  0,    5,   10,   15,   20,   25,   30,   35,   40,   45,   50,   55 };
	texts[]		= {"00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"};
	default		= DFT_START_MINUTE;
};

class Day
{
	title = "Day";
	values[]	= { 0,   1,   2,   3,   4,   5,   6,   7,   8,   9,   10,   11,   12,   13,   14,   15,   16,   17,   18,   19,   20,   21,   22,   23,   24,   25,   26,   27,   28,   29,   30 };
	texts[]		= {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"};
	default		= DFT_START_DAY;
};

class Month
{
	title = "Month";
	values[]	= {        1,          2,       3,       4,     5,      6,      7,        8,           9,        10,         11,         12};
	texts[]		= {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
	default		= DFT_START_MONTH;
};