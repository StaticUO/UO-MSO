
/* Load Settings */
#include "settings.sqf"

/* Load Functions */
FMH_fnc_addFlexiButton = ["f\fnc_addFlexiButton.sqf"] call CORE_fnc_compileModFile;
FMH_fnc_addFlexiMenu = ["f\fnc_addFlexiMenu.sqf"] call CORE_fnc_compileModFile;
FMH_fnc_flexiMenuType = ["f\fnc_flexiMenuType.sqf"] call CORE_fnc_compileModFile;
FMH_fnc_loadFlexiMenu = ["f\fnc_loadFlexiMenu.sqf"] call CORE_fnc_compileModFile;
FMH_fnc_removeFlexiButton = ["f\fnc_removeFlexiButton.sqf"] call CORE_fnc_compileModFile;
FMH_fnc_removeFlexiEntry = ["f\fnc_removeFlexiEntry.sqf"] call CORE_fnc_compileModFile;
FMH_fnc_removeFlexiMenu = ["f\fnc_removeFlexiMenu.sqf"] call CORE_fnc_compileModFile;

/* Initialize Variables */
fmh_flexiMenuKeys = [];
fmh_interactMenuDefs = [];
fmh_selfInteractMenuDefs = [];
fmh_flexiMenuHelperSettings = [
	_selfInteractionClasses,
	_selfInteractionPriority,
	_interactionClasses,
	_interactionPriority
];

/* Initialize Module */
#define FLEXI_LOAD_FUNC "['fmh_loadFlexiMenu', _this] call CORE_fnc_callFunction;"
[_selfInteractionClasses, [ace_sys_interaction_key_self], _selfInteractionPriority, [FLEXI_LOAD_FUNC, "main"]] call CBA_ui_fnc_add;
[_interactionClasses, [ace_sys_interaction_key], _interactionPriority, [FLEXI_LOAD_FUNC, "main"]] call CBA_ui_fnc_add;
