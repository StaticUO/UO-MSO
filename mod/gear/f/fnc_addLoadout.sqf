
#define PARAM_OPTIONAL(index,dft) if ((count _this) > index) then {_this select index} else {dft}

private ["_obj", "_weapons", "_magazines", "_i"];
_obj		= _this select 0;
_weapons	= PARAM_OPTIONAL(1,[]);
_magazines	= PARAM_OPTIONAL(2,[]);
_i			= 0;

{ // forEach
	{ // forEach
		[_obj, (_x select 0), (_x select 1), (_x select 2), _i] call GEAR_fnc_addGear;
	} forEach _x;
	_i = _i + 1;
} forEach [_magazines, _weapons];