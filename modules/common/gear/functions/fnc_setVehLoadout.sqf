
#define PARAM_OPTIONAL(index,dft) if ((count _this) > index) then {_this select index} else {dft}

private ["_veh", "_weapons", "_magazines"];
_veh		= _this select 0;
_weapons	= PARAM_OPTIONAL(1,[]);
_magazines	= PARAM_OPTIONAL(2,[]);

clearMagazineCargoGlobal _veh;
clearWeaponCargoGlobal _veh;

[_veh, _weapons, _magazines] call gear_addLoadout;