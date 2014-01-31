
private ["_unit"];
_unit = _this select 0;
if (local _unit) then {
	private ["_class", "_player"];
	_class = _unit getVariable ["gear_class", nil];
	_player = _unit getVariable ["gear_player", nil];
	if (!isNil "_class") then {
		private ["_side", "_gear"];
		_side = if (!isNil {_unit getVariable ["gear_side", nil]}) then {_unit getVariable "gear_side"} else {
			if (_unit isKindOf "Man") then {format["%1", (side _unit)]} else {"VEHICLES"};
		};
		_gear = [_unit, _class, _side] call compile preProcessFileLineNumbers ("mod\gear\loadouts\" + _side + "\" + _class + ".sqf");
		if ((_gear select 0) != _unit) then {
			_gear = [_unit] + _gear;
		};
		_gear call GEAR_fnc_setLoadout;
	};
	if (!isNil "_player") then {
		/*
			Player Unit Naming Scheme:
			All playable/player units which call this
			file must utilize this naming scheme:
				side_pltNum_squadNum_fireTeamNum_class
			An example for a CO player unit:
				blu_1_6_0_sl
		*/
		_unitParams = [(format["%1", _unit]), '_'] call CBA_fnc_split;
		_team = if ((count _this) > 1) then {_this select 1} else {
			switch (parseNumber(_unitParams select 3)) do {
				case 1: {"BLUE"};
				case 2: {"RED"};
				case 3: {"GREEN"};
				case 4: {"YELLOW"};
				default {"MAIN"};
			};
		};
		_class		= if ((count _this) > 3) then {_this select 3} else {_unitParams select 4};
		_platoon	= if ((count _this) > 4) then {_this select 4} else {parseNumber(_unitParams select 1)};
		_squad		= if ((count _this) > 5) then {_this select 5} else {parseNumber(_unitParams select 2)};
		_squadName	= if ((count _this) > 2) then {_this select 2} else {format["%1 %2'%3", ([_unitParams select 0] call CBA_fnc_capitalize), _platoon, _squad]};
		{ // forEach
			_unit disableAI _x;
		} forEach ["TARGET", "AUTOTARGET", "MOVE", "ANIM", "FSM"];
		if ((leader (group _unit)) == _unit) then {
			(group _unit) setGroupId [_squadName, "GroupColor0"];
		};
		_unit assignTeam _team;
		_unit setVariable ["ST_FTHud_assignedTeam", _team, true];
	};
};