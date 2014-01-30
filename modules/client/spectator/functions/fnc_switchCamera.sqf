
if (((_this select 1) == 1) && (['gdtmod_seagull_camera_on'] call CORE_fnc_getVariable)) then {
	
	private ['_target', '_cam', '_view'];
	_target 		= gdtmod_seagull_target;
	_cam			= 'gdtmod_seagull_camera' call CORE_fnc_getVariable;
	
	if !(['gdtmod_isValidTarget', [_target]] call CORE_fnc_callFunction) then {
		_target = ['gdtmod_cyclePlayers', [1]] call CORE_fnc_callFunction;
	};
	
	_cam cameraeffect ['Terminate', 'back'];
	cutText [(format['                   %1', (name gdtmod_seagull_target)]),'PLAIN DOWN'];
	
	_view = switch (cameraView) do {
		case "INTERNAL":	{"EXTERNAL"};
		case "EXTERNAL":	{"GUNNER"};
		case "GUNNER":		{"GROUP"};
		case "GROUP":		{"INTERNAL"};
	};
	_target switchCamera _view;
	
	['gdtmod_seagull_camera_on', false] call CORE_fnc_setVariable;
	['gdtmod_seagull_camera_help', false] call CORE_fnc_setVariable;
};