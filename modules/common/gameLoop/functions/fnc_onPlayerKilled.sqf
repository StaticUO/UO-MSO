
private ["_unit", "_killer", "_lossVar"];

_unit		= _this select 0;
_killer		= _this select 1;
_lossVar	= "";

_lossVar = switch (_unit getVariable ['gameLoop_playerSide', (side player)]) do {
	case WEST: {'gameLoop_west_infLoss'};
	case EAST: {'gameLoop_east_infLoss'};
	case RESISTANCE: {'gameLoop_resistance_infLoss'};
	case CIVILIAN: {'gameLoop_civilian_infLoss'};
};

if (_lossVar != "") then {
	private ["_prevValue"];
	_prevValue = [_lossVar] call CORE_fnc_getVariable;
	[_lossVar, (_prevValue + 1), true] call CORE_fnc_setVariable;
};

waitUntil {!(isNull player) && (alive player)};

player setVariable ["gameLoop_playerSide", (side player)];