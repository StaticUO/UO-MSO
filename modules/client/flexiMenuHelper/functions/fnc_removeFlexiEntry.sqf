
private ["_keyIdx", "_key", "_keys", "_call", "_result"];

_keyIdx = _this select 0;
_call = _this select 1;

_result = false;
_keys = ["fmh_flexiMenuKeys"] call CORE_fnc_getVariable;

if !((_keyIdx >= 0) && (_keyIdx < (count _keys))) exitWith {_result = false};

_key = _keys select _keyIdx;

if ((count _key) > 2) then {
	private ["_type", "_menuDefIndex", "_buttonIndex", "_menuDefs"];
	
	_type = _key select 0;
	_menuDefIndex = _key select 1;
	_buttonIndex = _key select 2;

	_menuDefs = ["fmh_flexiMenuType", [_type, 0]] call CORE_fnc_callFunction;
	_menuCount = count _menuDefs;

	if (_menuCount > _menuDefIndex) then {
		switch (_call) do {
			case 0: { // Remove Menu
				_menuDefs set [_menuDefIndex, (_menuDefs select (_menuCount - 1))];
				_menuDefs resize (_menuCount - 1);
				_result = true;
			};
			case 1: { // Remove Button
				if (_buttonIndex > 0) then {
					private ["_menuDef", "_menuDefCount"];
					_menuDef = _menuDefs select _menuDefIndex;
					_menuDefCount = count _menuDef;
					if (_buttonIndex < _menuDefCount) then {
						_menuDef set [_buttonIndex, (_menuDef select (_menuDefCount - 1))];
						_menuDef resize (_menuDefCount - 1);
						_menuDefs set [_menuDefIndex, _menuDef];
						_result = true;
					};
				};
			};
		};
	};

	["fmh_flexiMenuType", [_type, 1, _menuDefs]] call CORE_fnc_callFunction;
};

_result
