
private ["_type", "_menu", "_caption", "_buttonName", "_buttonAction", "_icon", "_toolTip",
		"_shortcut", "_enabled", "_visible", "_subMenu", "_parentMenuCap", "_buttonArray",
		"_menuDefs", "_menuDefIndex", "_buttonIndex", "_keyIndex", "_flexiMenu", "_button"];

_type			= _this select 0;	// 'interaction' or 'selfInteraction'
_buttonName		= _this select 1;
_buttonAction	= _this select 2;
_menu			= if ((count _this) > 3) then {_this select 3} else {"main"};
_enabled		= if ((count _this) > 4) then {_this select 4} else {true};
_visible		= if ((count _this) > 5) then {_this select 5} else {true};
_icon			= if ((count _this) > 6) then {_this select 6} else {""};
_toolTip		= if ((count _this) > 7) then {_this select 7} else {""};
_shortcut		= if ((count _this) > 8) then {_this select 8} else {-1};

/* ONLY FOR addFlexiMenu */
_subMenuEntry	= if ((count _this) > 9) then {_this select 9} else {""};
_parentMenuCap	= if ((count _this) > 10) then {_this select 10} else {"Main Menu"};

_button = [_buttonName, _buttonAction, _icon, _toolTip, _subMenuEntry, _shortcut, _enabled, _visible];
_menuDefs = [_type, 0] call FMH_fnc_flexiMenuType;
_menuDefIndex = -1;

for "_i" from 0 to ((count _menuDefs) - 1) do {
	private ["_menuDef"];
	_menuDef = _menuDefs select _i;
	if (((_menuDef select 0) select 0) == _menu) exitWith {_menuDefIndex = _i};
};

if (_menuDefIndex < 0) then {
	_flexiMenu = [[_menu, _parentMenuCap], []];
	_menuDefIndex = count _menuDefs;
} else {
	_flexiMenu = _menuDefs select _menuDefIndex;
};

_buttonArray = _flexiMenu select 1;
_buttonIndex = count _buttonArray;

_buttonArray set [_buttonIndex, _button];
_flexiMenu set [1, _buttonArray];
_menuDefs set [_menuDefIndex, _flexiMenu];
[_type, 1, _menuDefs] call FMH_fnc_flexiMenuType;

_keyIndex = count fmh_flexiMenuKeys;
fmh_flexiMenuKeys set [_keyIndex, [_type, _menuDefIndex, _buttonIndex]];

_keyIndex
