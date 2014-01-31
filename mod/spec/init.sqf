
// Load Settings
#include "settings.sqf"

// Load Functions
private ["_functions"];
_functions = [
	["gdtmod_camConstruct","modules\client\spectator\functions\fnc_camConstruct.sqf"],
	["gdtmod_cyclePlayers","modules\client\spectator\functions\fnc_cyclePlayers.sqf"],
	["gdtmod_help","modules\client\spectator\functions\fnc_help.sqf"],
	["gdtmod_isValidTarget","modules\client\spectator\functions\fnc_isValidTarget.sqf"],
	["gdtmod_mouseZ","modules\client\spectator\functions\fnc_mouseZ.sqf"],
	["gdtmod_nightVision","modules\client\spectator\functions\fnc_nightVision.sqf"],
	["gdtmod_setCamPos","modules\client\spectator\functions\fnc_setCamPos.sqf"],
	["gdtmod_startSpectator","modules\client\spectator\functions\fnc_startSpectator.sqf"],
	["gdtmod_switchCamera","modules\client\spectator\functions\fnc_switchCamera.sqf"]
];

/*****************************/
/* Initialization Code Below */
/*        NO WAITING!        */
/*****************************/

if (!isDedicated && _autoStartSpectator) then {
	player addEventHandler ["killed", {['gdtmod_startSpectator', [true]] call CORE_fnc_spawnFunction;}];
};

/*****************************/
/*  End Initialization Code  */
/*****************************/

_functions