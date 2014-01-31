
private ["_menuDefs", "_target", "_params", "_menuName", "_menuRsc", "_menus", "_menuDef"];

#define ENABLED_INDEX	6
#define VISIBLE_INDEX	7

// _this==[_target, _menuNameOrParams]
_target = _this select 0;
_params = _this select 1;

_menuName = "";
_menuRsc = "popup";
_menus = [];
_menuDef = [];

switch (typeName(_params)) do {
	case (typeName([])): {
		if (count _params < 1) exitWith {diag_log format["Error: Invalid params: %1, %2", _this, __FILE__];};
		_menuName = _params select 0;
		_menuRsc = if (count _params > 1) then {_params select 1} else {_menuRsc};
	};
	case (typeName("")): {
		_menuName = _params;
	};
};

if (_target == player) then {
	_menuDefs =+ fmh_selfInteractMenuDefs;
} else {
	_menuDefs =+ fmh_interactMenuDefs;
};

/*
	_menuDefs = [
		[
			["menu", "Menu Name"],
			[
				"Button Name",
				{Button_Code},
				"icon",
				"toolTip",
				[SubMenuEntry | ""],
				-1 (DIK shortcut),
				Bool (enabled),
				Bool (visible)
			], ...
		], ...
	];
*/

{
	
	private ["_menu"];
	
	_menu = (_x select 0) select 0;
	
	if (_menu == _menuName) exitWith {
		_menuDef = _x;
	};
} forEach _menuDefs;

if ((count _menuDef) > 0) then {
	
	private ["_menuArray", "_buttonArray"];
	_menuArray		= _menuDef select 0;
	_buttonArray	= _menuDef select 1;
	
	_menuArray set [2, _menuRsc];
	_menuDef set [0, _menuArray];
	
	if ((count _buttonArray) > 0) then {
		for "_i" from 0 to ((count _buttonArray) - 1) do {
			
			private ["_selection", "_enabled", "_visible"];
			
			_selection = _buttonArray select _i;
			_enabled = _selection select ENABLED_INDEX;
			_visible = _selection select VISIBLE_INDEX;
			
			_enabled = [_enabled, _this] call CORE_fnc_toBool;
			_visible = [_visible, _this] call CORE_fnc_toBool;
			
			_selection set [ENABLED_INDEX, _enabled];
			_selection set [VISIBLE_INDEX, _visible];
			_buttonArray set [_i, _selection];
		};
		_menuDef set [1, _buttonArray];
	};
};

fmh_target = _target;

_menuDef
