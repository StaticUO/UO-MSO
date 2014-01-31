
private ["_type", "_call", "_data"];

_type = _this select 0;
_call = _this select 1; // 0 - get, 1 - set
_data = if (_call == 1) then {_this select 2} else {[]};

switch (_call) do{ 
	case 0: {
		switch (_type) do {
			case "interaction": {
				fmh_interactMenuDefs
			};
			case "selfInteraction": {
				fmh_selfInteractMenuDefs;
			};
		};
	};
	case 1: {
		switch (_type) do {
			case "interaction": {
				fmh_interactMenuDefs = _data;
			};
			case "selfInteraction": {
				fmh_selfInteractMenuDefs = _data;
			};
		};
	};
};
