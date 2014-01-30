
private ["_type", "_call", "_return"];

_type = _this select 0;
_call = _this select 1; // 0 - get, 1 - set
_data = if (_call == 1) then {_this select 2} else {[]};

_return = [];

switch (_call) do{ 
	case 0: {
		switch (_type) do {
			case "interaction": {
				_return = ["fmh_interactMenuDefs"] call CORE_fnc_getVariable;
			};
			case "selfInteraction": {
				_return = ["fmh_selfInteractMenuDefs"] call CORE_fnc_getVariable;
			};
		};
	};
	case 1: {
		switch (_type) do {
			case "interaction": {
				["fmh_interactMenuDefs", _data] call CORE_fnc_setVariable;
			};
			case "selfInteraction": {
				["fmh_selfInteractMenuDefs", _data] call CORE_fnc_setVariable;
			};
		};
	};
};

_return
