
private ["_unit", "_leader", "_return"];

#define POS_OFFSET 3	// How far behind the teleport will put the unit

_unit = _this select 0;
_leader = leader _unit;
_return = false;

if (_leader != _unit) then {
	private ["_leaderVeh"];
	_leaderVeh = vehicle _leader;
	
	if (_leaderVeh == _leader) then {
		private ["_pos", "_x", "_y", "_z"];
		_pos = getPosATL _leader;
		_x = (_pos select 0) + (POS_OFFSET * sin((getDir _leader) - 180));
		_y = (_pos select 1) + (POS_OFFSET * cos((getDir _leader) - 180));
		_z = _pos select 2;
		_unit setPosATL [_x, _y, _z];
		hint format["Teleported behind %1", (name _leader)];
	} else {
		if ((_leaderVeh emptyPositions "cargo") == 0) then {
			hint format["Cannot Teleport to SL:\nNo room in %1's vehicle.", (name _leader)];
		} else {
			_unit moveincargo _leaderVeh;
			hint format["Teleported into %1's vehicle", (name _leader)];
		};
	};
} else {
	hint "Cannot Teleport to SL:\nYou ARE the SL!";
};

_return