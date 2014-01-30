
// Load Settings
#include "settings.sqf"

// Load Functions
private ["_functions"];
_functions = [
	["gameLoop_endMission", 	"modules\common\gameLoop\functions\fnc_endMission.sqf"],
	["gameLoop_onPlayerKilled", "modules\common\gameLoop\functions\fnc_onPlayerKilled.sqf"],
	["gameLoop_playerInit", 	"modules\common\gameLoop\functions\fnc_playerInit.sqf", false, true, [], CORE_LMS_player],
	["gameLoop_serverLoop", 	"modules\common\gameLoop\functions\fnc_serverLoop.sqf", false, true, [], CORE_LMS_server]
];

/*****************************/
/* Initialization Code Below */
/*        NO WAITING!        */
/*****************************/

['gameLoop_missionObjCheck', _missionObjCheckFunc] call CORE_fnc_saveFunction;

['gameLoop_timeLimit', _timeLimit] call CORE_fnc_setVariable;
['gameLoop_glCheckFreq', _glCheckFreq] call CORE_fnc_setVariable;
['gameLoop_endScreenTimeOut', _endTimeOut] call CORE_fnc_setVariable;

['gameLoop_west_infPercentLoss', _westPercLoss] call CORE_fnc_setVariable;
['gameLoop_east_infPercentLoss', _eastPercLoss] call CORE_fnc_setVariable;
['gameLoop_resistance_infPercentLoss', _guerPercLoss] call CORE_fnc_setVariable;
['gameLoop_civilian_infPercentLoss', _civPercLoss] call CORE_fnc_setVariable;

if (isServer) then {
	['gameLoop_startTime', serverTime, true] call CORE_fnc_setVariable;
	['gameLoop_enabled', true, true] call CORE_fnc_setVariable;
	['gameLoop_west_infLoss', 0, true] call CORE_fnc_setVariable;
	['gameLoop_east_infLoss', 0, true] call CORE_fnc_setVariable;
	['gameLoop_resistance_infLoss', 0, true] call CORE_fnc_setVariable;
	['gameLoop_civilian_infLoss', 0, true] call CORE_fnc_setVariable;
};

['gameLoop_endMission', _endMissionFunc] call CBA_fnc_addEventHandler;

/*****************************/
/*  End Initialization Code  */
/*****************************/

_functions
