
// Load Settings
#include "settings.sqf"

// Load Functions
private ["_functions"];
_functions = [
	["gear_addGear", "modules\common\gear\functions\fnc_addGear.sqf"],
	["gear_addLoadout", "modules\common\gear\functions\fnc_addLoadout.sqf"],
	["gear_selectWeapon", "modules\common\gear\functions\fnc_selectWeapon.sqf"],
	["gear_setLoadout", "modules\common\gear\functions\fnc_setLoadout.sqf"],
	["gear_setVehLoadout", "modules\common\gear\functions\fnc_setVehLoadout.sqf"]
];

/*****************************/
/* Initialization Code Below */
/*        NO WAITING!        */
/*****************************/

/* Ensure Global Variables are loaded for pre-init execution */
{
	private ["_var", "_file"];
	_var	= _x select 0;
	_file	= _x select 1;
	
	if (isNil _var) then {
		call compile format ["%1 = compile preProcessFileLineNumbers '%2';", _var, _file];
	};
} forEach _functions;

/*****************************/
/*  End Initialization Code  */
/*****************************/

_functions
