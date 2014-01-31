
private ["_unit"];
_unit	= _this select 0;

if ((count (weapons _unit)) > 0) then {
	private["_type", "_muzzles"];
	_type		= ((weapons _unit) select 0);
	_muzzles	= getArray (configFile >> "cfgWeapons" >> _type >> "muzzles");

	if ((count _muzzles) > 1) then {
		_unit selectWeapon (_muzzles select 0);
	} else {
		_unit selectWeapon _type;
	};
};
