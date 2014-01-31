
if (isServer) then {
	private ["_unit"];
	_unit = _this select 0;
	if (!(isNull _unit) && {alive _unit}) then {
		private ["_kEH"];
		_kEH = _unit addEventHandler ["killed", {
			private ["_unit", "_killer"];
			_unit = _this select 0;
			_killer = _this select 1;
			[
				_unit,
				_killer,
				(_unit getVariable ["gloop_unitSide", (side _unit)]),
				(_unit getVariable ["gloop_player", (isPlayer _unit)]),
				(_killer getVariable ["gloop_unitSide", (side _killer)]),
				(_killer getVariable ["gloop_player", (isPlayer _killer)])
			] spawn GLOOP_fnc_onKilled;
		}];
		_unit setVariable ["gloop_player", (isPlayer _unit)];
		_unit setVariable ["gloop_unitSide", (side _unit)];
		_unit setVariable ["gloop_killedEH", _kEH];
	};
};
