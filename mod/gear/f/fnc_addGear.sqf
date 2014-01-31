
#define PARAM_OPTIONAL(index,dft) if ((count _this) > index) then {_this select index} else {dft}

private ["_object", "_className", "_classType", "_addType", "_gearCount", "_code", "_loop", "_return"];
_object			= _this select 0;			// Unit Object
_className		= _this select 1;			// Class Name
_addType		= PARAM_OPTIONAL(2,0);		// Addition Type: 0 = Gear, 1 = Ruck Sack (ACE), 2 = Object Cargo, 3 = Weapon On Back (ACE)
_gearCount		= PARAM_OPTIONAL(3,1);		// Gear Count
_code			= nil;
_loop			= nil;
_return			= false;

_classType = switch (true) do {
	case ((count _this) > 4): {_this select 4};
	case (isClass (configFile >> "cfgMagazines" >> _className)): {0};
	case (isClass (configFile >> "cfgWeapons" >> _className) || isClass (configFile >> "cfgBackpack" >> _className)): {1};
	default {-1};
};

switch (_classType) do {
	case 0: {					/* Magazine */
		switch (_addType) do {
			case 0: {
				_code = {(_this select 0) addMagazine (_this select 1)};
				_loop = true;
			};
			case 1: {
				_code = ACE_fnc_PackMagazine;
				_loop = false;
			};
			case 2: {
				_code = {(_this select 0) addMagazineCargoGlobal [(_this select 1), (_this select 2)]};
				_loop = false;
			};
		};
	};
	case 1: {					/* Weapon */
		switch (_addType) do {
			case 0: {
				_code = {(_this select 0) addWeapon (_this select 1)};
				_loop = true;
			};
			case 1: {
				_code = ACE_fnc_PackWeapon;
				_loop = false;
			};
			case 2: {
				_code = {(_this select 0) addWeaponCargoGlobal [(_this select 1), (_this select 2)]};
				_loop = false;
			};
			case 3: {
				_code = {(_this select 0) setVariable ["ACE_weapononback", (_this select 1), true]};
				_loop = false;
			};
		};
	};
};

if !(isNil "_code" || isNil "_loop") then {
	private ["_loopCount"];
	_loopCount	= if (_loop) then {_gearCount} else {1};
	_return		= true;
	
	for "_i" from 1 to _loopCount do {
		[_object, _className, _gearCount] call _code;
	};
};

_return