
// Load Settings
#include "settings.sqf"

// Load Functions
private ["_functions"];
_functions = [
	["sa_containUnit", 	"modules\common\setupArea\functions\fnc_containUnit.sqf"],
	["sa_playerInit", 	"modules\common\setupArea\functions\fnc_playerInit.sqf", false, true, [], CORE_LMS_player],
	["sa_serverInit", 	"modules\common\setupArea\functions\fnc_serverInit.sqf", false, true, [], CORE_LMS_server]
];

/*****************************/
/* Initialization Code Below */
/*        NO WAITING!        */
/*****************************/

if (isServer) then {
	sa_setupAreas = _setupAreas;
	sa_exemptUnits = _exemptUnits;
	publicVariable "sa_setupAreas";
	publicVariable "sa_exemptUnits";
};

/*****************************/
/*  End Initialization Code  */
/*****************************/

_functions
