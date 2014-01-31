if ((_this select 1) in (actionkeys 'NightVision')) then {
	if ('gdtmod_seagull_nvg' call CORE_fnc_getVariable) then {
		camUseNVG false;
		['gdtmod_seagull_nvg', false] call CORE_fnc_setVariable;
	} else {
		camUseNVG true;
		['gdtmod_seagull_nvg', true] call CORE_fnc_setVariable;
	};
};