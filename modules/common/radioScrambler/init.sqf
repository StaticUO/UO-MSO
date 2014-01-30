
// Load Settings
#include "settings.sqf"

// Load Functions
private ["_functions"];
_functions = [
	["rs_channelGen", "modules\common\radioScrambler\functions\fnc_channelGen.sqf"],
	["rs_scramblePlayerRadios", "modules\common\radioScrambler\functions\fnc_scramblePlayerRadios.sqf", false, true, [_timeOut], CORE_LMS_player],
	["rs_setChannels", "modules\common\radioScrambler\functions\fnc_setChannels.sqf"]
];

/*****************************/
/* Initialization Code Below */
/*        NO WAITING!        */
/*****************************/

if ([CORE_machine, CORE_LMS_server] call CORE_fnc_isMachine) then {
	["rs_radio_seeds", _radioSeeds, true] call CORE_fnc_setVariable;
};

/*****************************/
/*  End Initialization Code  */
/*****************************/

_functions
