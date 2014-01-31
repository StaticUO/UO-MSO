if ((_this select 1) in (actionkeys 'Help')) then {
	private ["_type"];
	
	if !(['gdtmod_seagull_camera_help'] call CORE_fnc_getVariable) then {
		_type = "BLACK OUT";
		['gdtmod_seagull_camera_help', true] call CORE_fnc_setVariable;
	} else {
		_type = "BLACK IN";
		['gdtmod_seagull_camera_help', false] call CORE_fnc_setVariable;
	};
	
	cutText [
		'Mousewheel:                     Camera jumps to player positions\nLeft mouse button:                                     Freelock\nRight mouse button:                     Camera locked on Player\nMovement keys and mouse:                          Move camera\n\nQ:                                              Move camera up\nY or Z:                                      Move camera down\nSHIFT Left:                                      Slow movement\n\nNightvision key:                              Nightvision On/Off\n\nWhile the camera is locked on a player you can change between\n1st/3rd person, optics and group view.\nPress the help button to exit the help screen.',
		_type
	];
};