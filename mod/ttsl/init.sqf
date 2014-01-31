
// Load Settings
#include "settings.sqf"

// Load Functions
private ["_functions"];
_functions = [
	["teleportToSL","modules\client\teleportToSL\functions\fnc_teleportToSL.sqf"],
	["ttSL_addToSelfInteract","modules\client\teleportToSL\functions\fnc_addToSelfInteract.sqf", false, true, [], CORE_LMS_player]
];

/*****************************/
/* Initialization Code Below */
/*        NO WAITING!        */
/*****************************/



/*****************************/
/*  End Initialization Code  */
/*****************************/

_functions