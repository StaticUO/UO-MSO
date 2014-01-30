
private ["_initMinute", "_initHour", "_initDay", "_initMonth", "_initYear", "_syncTime", "_syncLoop"];

_initMinute		= PARAMS_Minute;
_initHour		= PARAMS_Hour;
_initDay		= PARAMS_Day;
_initMonth		= PARAMS_Month;
_initYear		= date select 0;

_syncTime		= true; // Whether or not to periodically sync server time to clients
_syncLoop		= 300; // Seconds
