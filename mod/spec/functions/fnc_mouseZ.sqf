
private ["_players", "_playerCount"];
_players		= call CBA_fnc_players;
_playerCount	= count _players;

if (_playerCount > 0) then {
	
	private ["_z", "_step", "_target"];
	
	_z				= _this select 1;
	_step			= if (_z < 0) then {-1} else {1};
	_target 		= ['gdtmod_cyclePlayers', [_step]] call CORE_fnc_callFunction;
	
	cutText [format['                   %1', (name gdtmod_seagull_target)], 'PLAIN DOWN'];
	
	if (['gdtmod_seagull_camera_on'] call CORE_fnc_getVariable) then {
		private ["_cam"];
		_cam = 'gdtmod_seagull_camera' call CORE_fnc_getVariable;
		['gdtmod_setCamPos', [_target, _cam]] call CORE_fnc_callFunction;
	} else {
		_target switchCamera cameraView;
	};
	
	['gdtmod_seagull_camera_help', false] call CORE_fnc_setVariable;
};