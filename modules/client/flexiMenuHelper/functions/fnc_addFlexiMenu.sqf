
private ["_type", "_menu", "_caption", "_buttonName", "_buttonAction", "_icon", "_toolTip",
		"_shortcut", "_enabled", "_visible", "_subMenu", "_parentMenu", "_parentMenuCap",
		"_embeddedMenu", "_subMenu", "_keyIndex"];

_type			= _this select 0;	// 'interaction' or 'selfInteraction'
_menu			= _this select 1;
_caption		= _this select 2;
_enabled		= if ((count _this) > 3) then {_this select 3} else {true};
_visible		= if ((count _this) > 4) then {_this select 4} else {true};
_buttonName		= if ((count _this) > 5) then {_this select 5} else {format["%1 >", _caption]};
_buttonAction	= if ((count _this) > 6) then {_this select 6} else {""};
_icon			= if ((count _this) > 7) then {_this select 7} else {""};
_toolTip		= if ((count _this) > 8) then {_this select 8} else {""};
_shortcut		= if ((count _this) > 9) then {_this select 9} else {-1};
_parentMenu		= if ((count _this) > 10) then {_this select 10} else {"main"};
_parentMenuCap	= if ((count _this) > 11) then {_this select 11} else {"Main Menu"};
_embeddedMenu	= if ((count _this) > 12) then {_this select 12} else {1};

_subMenu = ["['fmh_loadFlexiMenu', _this] call CORE_fnc_callFunction;", _menu, _embeddedMenu];

_keyIndex = ["fmh_addFlexiButton",
	[
		_type,
		_buttonName,
		_buttonAction,
		_parentMenu,
		_enabled,
		_visible,
		_icon,
		_toolTip,
		_shortcut,
		_subMenu,
		_parentMenuCap
	]
] call CORE_fnc_callFunction;

_keyIndex
