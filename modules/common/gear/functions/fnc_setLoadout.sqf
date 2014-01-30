
#define PARAM_OPTIONAL(index,dft) if ((count _this) > index) then {_this select index} else {dft}

private ["_unit", "_weapons", "_magazines", "_ifak"];
_unit		= _this select 0;
_weapons	= PARAM_OPTIONAL(1,[]);
_magazines	= PARAM_OPTIONAL(2,[]);
_ifak		= PARAM_OPTIONAL(3,[]);

removeAllWeapons _unit;
removeAllItems _unit;
removeBackpack _unit;
{_unit removeMagazine _x} forEach (magazines _unit);
[_unit, "ALL"] call ACE_fnc_RemoveGear;

[_unit, _weapons, _magazines] call gear_addLoadout;

if ((count _ifak) > 0) then {
	([_unit] + _ifak) call ACE_fnc_PackIFAK;
};

// Select Primary Weapon
[_unit] call gear_selectWeapon;