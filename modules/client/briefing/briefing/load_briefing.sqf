
private ["_man", "_forceSide", "_side"];

if (typeName(_this) != typeName([])) then {_this = []};

_man		= if ((count _this) > 0) then {_this select 0} else {player};
_forceSide	= if ((count _this) > 1) then {_this select 1} else {nil};
_side		= CIVILIAN;

/* Macros */
#define LOAD_BRIEF(file) call compile str(preProcessFile ("modules\client\briefing\briefing\" + file))

if !(isNil "_forceSide") then {
	_side = _forceSide;
} else {
	_side = side _man;
};

[LOG_INFO, 'briefing_init', "Loading Briefing. Unit: '%1'. Side: %2.", [_man, _side], __FILE__, __LINE__] spawn CORE_fnc_log;

/* Load Common Diary Records */
_man createDiaryRecord ["Diary", ["PARAMETERS", LOAD_BRIEF("common\parameters.html")]];
_man createDiaryRecord ["Diary", ["MISSION NOTES", LOAD_BRIEF("common\mission_notes.html")]];

/* Load Side-Specific Diary Records */
switch (_side) do {
	case WEST: {
		#include "west\x_load.sqf";
	};
	case EAST: {
		#include "east\x_load.sqf";
	};
	case RESISTANCE: {
		#include "resistance\x_load.sqf";
	};
	case CIVILIAN: {
		#include "civilian\x_load.sqf";
	};
};

/* Add any code to load custom briefings below */
