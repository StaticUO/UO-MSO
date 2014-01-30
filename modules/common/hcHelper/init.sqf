
// Load Settings
#include "settings.sqf"

// Load Functions
private ["_functions"];
_functions = [
	["hcHelper_delegateAI", 	"modules\common\hcHelper\functions\fnc_delegateAI.sqf", false, true, [], CORE_LMS_aiHost, CORE_priority_immediate],
	["hcHelper_monitorHC", 		"modules\common\hcHelper\functions\fnc_monitorHC.sqf"]
];

/*****************************/
/* Initialization Code Below */
/*        NO WAITING!        */
/*****************************/



/*****************************/
/*  End Initialization Code  */
/*****************************/

_functions
