
/* Load Settings */
#include "settings.sqf"

/* Load Functions */
GLOOP_fnc_endMission = ["f\fnc_endMission.sqf"] call CORE_fnc_compileModFile;
GLOOP_fnc_serverLoop = ["f\fnc_serverLoop.sqf"] call CORE_fnc_compileModFile;

/* Initialize Variables */
if (isServer) then {
	gloop_startTime = serverTime;
	gloop_enabled = true;
	gloop_west_infLoss = 0;
	gloop_east_infLoss = 0;
	gloop_resistance_infLoss = 0;
	gloop_civilian_infLoss = 0;
};

/* Initialize Module */
['gloop_event_endMission', _endMissionFunc] call CBA_fnc_addEventHandler;
