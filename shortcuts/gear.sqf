/************************************************
*	Load Gear & Equipment
*
*	Description:
*		This File serves as an entry point to the
*		Gear Module. You may call it within the
*		mission editor text fields to load a
*		unit's gear easily.
*
*	Example:
*		[this, 'sl'] execVM 'shortcuts\gear.sqf';
*		[this, 'mtvr'] execVM 'shortcuts\gear.sqf';
*		[this, 'r', 'WEST'] execVM 'shortcuts\gear.sqf';
*
************************************************/

call compile preProcessFileLineNumbers "modules\common\gear\init.sqf";

private ["_unit", "_class"];
_unit		= _this select 0;
_class		= _this select 1;
_func		= nil;
if (local _unit) then {
	private ["_func", "_type", "_side"];
	_func	= nil;
	_type	= if ((count _this) > 2) then {_this select 2} else { // 0 = Man, 1 = Vehicle
		if (_unit isKindOf "Man") then {0} else {1};
	};
	switch (_type) do {
		case 0: { // Man
			_func = gear_setLoadout;
			_side = format["%1", (side _unit)];
		};
		case 1: { // Vehicle
			if (_unit isKindOf "AllVehicles") then { // Ensure Vehicle
				_func = gear_setVehLoadout;
				_side = "VEHICLES";
			};
		};
	};
	if ((count _this) > 3) then {_side = _this select 3};
	if !(isNil "_func") then {
		private ["_gear", "_file"];
		_file		= "modules\common\gear\loadouts\" + _side + "\" + _class + ".sqf";
		_gear		= [_unit, _class, _side] call compile preProcessFileLineNumbers _file;
		if ((_gear select 0) != _unit) then {
			_gear = [_unit] + _gear;
		};
		_gear call _func;
	};
};