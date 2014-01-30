
private ["_playerDead", "_deathMessage", "_seagullPlayers", "_specStartPos", "_seagullCamera"];

_playerDead = if ((count _this) > 0) then {
	if (typeName(_this select 0) == typeName(true)) then {_this select 0} else {true};
} else {false};

waitUntil {!(isNull player) && {alive player}};

player setPos (getPos ('gdtmod_specPen' call CORE_fnc_getVariable));
sleep 0.01;
[player] join grpNull;

private ["_hdEH"];
_hdEH = player addEventHandler ["HandleDamage", {false}];
['gdtmod_hdEH', _hdEH] call CORE_fnc_setVariable;

player setCaptive true;
removeAllWeapons player;
removeAllItems player;
removebackpack player;
[true] call acre_api_fnc_setSpectator;

player setVariable ['gdtmod_isSpectating', true, true];

['gdtmod_seagull_nvg', false] call CORE_fnc_setVariable;
['gdtmod_seagull_camera_on', true] call CORE_fnc_setVariable;
['gdtmod_seagull_camera_help', false] call CORE_fnc_setVariable;

if (_playerDead) then {
	private ["_deathMessage"];
	_deathMessage = 'gdtmod_deathMessage' call CORE_fnc_getVariable;
	titleText [_deathMessage, "BLACK", 0.2];
	sleep 3;
	titleText [_deathMessage, "BLACK FADED", 10];
};

cutText ["SPECTATOR\n----------------------------------------------------------------------------------------------\n\nPress your help button (Standard: H) for instructions","PLAIN"];
setAperture -1;
sleep 0.1;

/* Volatile Global Variables - NO DB SAVE */
gdtmod_seagull_players_select = 0;
['gdtmod_cyclePlayers', [1]] call CORE_fnc_callFunction;

_specStartPos = getPos gdtmod_seagull_target;

_seagullCamera = "camconstruct" camcreate [(_specStartPos select 0), (_specStartPos select 1), ((_specStartPos select 2) + 1.75)];
_seagullCamera setdir (getdir gdtmod_seagull_target);	
_seagullCamera camConstuctionSetParams [_specStartPos, 50000, 10000];
_seagullCamera cameraeffect ["internal","back"];
titleText ["", "BLACK IN", 0.2];
gdtmod_seagull_target switchCamera "EXTERNAL";

['gdtmod_seagull_camera', _seagullCamera] call CORE_fnc_setVariable;

private ["_seagull_keys"];
_seagull_keys = 'gdtmod_seagull_keys' call CORE_fnc_getVariable;

if (isNil "_seagull_keys") then {
	['gdtmod_seagull_keys', [
		((finddisplay 46) displayaddeventhandler ["keydown",		"['gdtmod_help', _this] call CORE_fnc_callFunction;"]),			// Help
		((finddisplay 46) displayaddeventhandler ["keydown",		"['gdtmod_nightVision', _this] call CORE_fnc_callFunction;"]),	// Night Vision
		((finddisplay 46) displayaddeventhandler ["MouseButtonDown","['gdtmod_camConstruct', _this] call CORE_fnc_callFunction;"]),	// Camera Construct
		((finddisplay 46) displayaddeventhandler ["MouseButtonDown","['gdtmod_switchCamera', _this] call CORE_fnc_callFunction;"]),	// Switch Camera
		((findDisplay 46) displayAddEventHandler ["mousezchanged",	"['gdtmod_mouseZ', _this] call CORE_fnc_callFunction;"])		// Mouse Scroll
	]] call CORE_fnc_setVariable;
};