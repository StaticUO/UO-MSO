
// Defines
#define SET_INIT_DATE setDate [_initYear, _initMonth, _initDay, _initHour, _initMinute]

// Load Settings
#include "settings.sqf"

// Load Functions
private ["_functions"];
_functions = [];

if (_syncTime) then {_functions = _functions + [["syncTime_timeLoop", "modules\common\syncTime\functions\fnc_timeLoop.sqf", false, true, [], CORE_LMS_server]]};

/*****************************/
/* Initialization Code Below */
/*        NO WAITING!        */
/*****************************/

['syncTime_syncLoop', _syncLoop] call CORE_fnc_setVariable;

['syncTime', {setDate (_this select 1);}] call CBA_fnc_addEventHandler;

if (isServer) then {
	SET_INIT_DATE;
	['syncTime_forceSync', {['syncTime', [(_this select 0), date]] call CBA_fnc_remoteLocalEvent;}] call CBA_fnc_addEventHandler;
};

if (!isDedicated) then {
	if (time > 0) then {
		['syncTime_forceSync', [player]] call CBA_fnc_remoteEvent;
	} else {
		SET_INIT_DATE;
	};
};

/*****************************/
/*  End Initialization Code  */
/*****************************/

_functions
