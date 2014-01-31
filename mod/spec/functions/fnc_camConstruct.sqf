
if (((_this select 1) == 0) and !(['gdtmod_seagull_camera_on'] call CORE_fnc_getVariable)) then {
	
	private ["_cam"];
	_cam = 'gdtmod_seagull_camera' call CORE_fnc_getVariable;
	
	_cam cameraeffect ['internal', 'back'];
	['gdtmod_setCamPos', [gdtmod_seagull_target, _cam]] call CORE_fnc_callFunction;
	
	['gdtmod_seagull_camera_on', true] call CORE_fnc_setVariable;
};