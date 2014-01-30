
private ["_selfInteractionClasses", "_selfInteractionPriority",
		"_interactionClasses", "_interactionPriority", "_function"];

_params = ["fmh_flexiMenuHelperSettings"] call CORE_fnc_getVariable;

_selfInteractionClasses		= _params select 0;
_selfInteractionPriority	= _params select 1;
_interactionClasses			= _params select 2;
_interactionPriority		= _params select 3;

_function = "['fmh_loadFlexiMenu', _this] call CORE_fnc_callFunction;";
[_selfInteractionClasses, [ace_sys_interaction_key_self], _selfInteractionPriority, [_function, "main"]] call CBA_ui_fnc_add;
[_interactionClasses, [ace_sys_interaction_key], _interactionPriority, [_function, "main"]] call CBA_ui_fnc_add;
