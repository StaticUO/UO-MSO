
// Load Settings
#include "settings.sqf"

// Load Functions
private ["_functions"];
_functions = [
	["fmh_addFlexiButton","modules\client\flexiMenuHelper\functions\fnc_addFlexiButton.sqf"],
	["fmh_addFlexiMenu","modules\client\flexiMenuHelper\functions\fnc_addFlexiMenu.sqf"],
	["fmh_flexiMenuType","modules\client\flexiMenuHelper\functions\fnc_flexiMenuType.sqf"],
	["fmh_loadFlexiMenu","modules\client\flexiMenuHelper\functions\fnc_loadFlexiMenu.sqf"],
	["fmh_loadToCBA","modules\client\flexiMenuHelper\functions\fnc_loadToCBA.sqf", false, true, [], CORE_LMS_player],
	["fmh_removeFlexiButton","modules\client\flexiMenuHelper\functions\fnc_removeFlexiButton.sqf"],
	["fmh_removeFlexiEntry","modules\client\flexiMenuHelper\functions\fnc_removeFlexiEntry.sqf"],
	["fmh_removeFlexiMenu","modules\client\flexiMenuHelper\functions\fnc_removeFlexiMenu.sqf"]
];

/*****************************/
/* Initialization Code Below */
/*        NO WAITING!        */
/*****************************/

msc_takenExtractIntel = false;

["fmh_flexiMenuHelperSettings",
	[
		_selfInteractionClasses,
		_selfInteractionPriority,
		_interactionClasses,
		_interactionPriority
	]
] call CORE_fnc_setVariable;

["fmh_flexiMenuKeys", []] call CORE_fnc_setVariable;
["fmh_interactMenuDefs", []] call CORE_fnc_setVariable;
["fmh_selfInteractMenuDefs", []] call CORE_fnc_setVariable;

/*****************************/
/*  End Initialization Code  */
/*****************************/

_functions
