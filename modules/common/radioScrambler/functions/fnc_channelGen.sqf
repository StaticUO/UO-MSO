
private ["_channelCount", "_base", "_seed", "_channelStep", "_seedStep",
		 "_startChannel", "_seedFunc", "_channels"];

_channelCount	= _this select 0;
_base			= _this select 1;
_seed 			= _this select 2;
_channelStep 	= _this select 3;
_seedStep		= _this select 4;

_startChannel	= if ((count _this) > 5) then {_this select 5} else {0};
_seedFunc		= if ((count _this) > 6) then {_this select 6} else {CORE_fnc_rand};

_channels = [];

for "_i" from _startChannel to (_channelCount - 1) do {
	
	private ["_freq"];
	
	_seed = [_seed, _base, _channelCount, _i] call _seedFunc;
	_freq = _base + (_i * _channelStep) + (round(_seed % (_channelStep / _seedStep)) * _seedStep);
	
	_channels set [(_i - _startChannel), _freq];
};

_channels
