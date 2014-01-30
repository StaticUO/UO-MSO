
private ["_structures"];
_structures		= _this select 0;

['fmh_addFlexiMenu', [
	'selfInteraction',
	'deployMenu',
	'Build Menu',
	true,
	"['building_buildMenuCondition', _this] call CORE_fnc_callFunction;",
	'Build Menu >',
	"",
	"",
	"Building / Deploy Menu for Base Construction"
]] call CORE_fnc_callFunction;

{
	private ["_name", "_action", "_toolTip"];
	_name			= _x select 0;
	_action			= compile format['["building_buildStruct",[player,%1]] call CORE_fnc_spawnFunction;', str(_x)];
	_toolTip		= format["Build '%1' in front of your player", _name];
	
	['fmh_addFlexiButton', [
		'selfInteraction',
		_name,
		_action,
		'deployMenu',
		true,
		true,
		"",
		_toolTip
	]] call CORE_fnc_callFunction;
} forEach _structures;