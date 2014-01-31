
private ["_timeOut", "_endTime", "_radioSeeds", "_radioSeed", "_seed", "_freqStep", "_seedStep", "_base", "_channelCount", "_channels"];

_timeOut = _this select 0;

_radioSeeds = [{["rs_radio_seeds"] call CORE_fnc_getVariable}, _timeOut] call CORE_fnc_timeOut;

if !(isNil "_radioSeeds") then {
	
	switch (side player) do {
		case WEST: {
			_radioSeed = _radioSeeds select 0;
		};
		case EAST: {
			_radioSeed = _radioSeeds select 1;
		};
		case RESISTANCE: {
			_radioSeed = _radioSeeds select 2;
		};
		default {
			_radioSeed = _radioSeeds select 3;
		};
	};
	
	_seed			= _radioSeed select 0;
	_freqStep		= _radioSeed select 1;
	_seedStep		= _radioSeed select 2;
	
	// Long Range Radios
	_base			= 30;
	_channelCount	= 100;
	_channels		= ["rs_channelGen", [_channelCount, _base, _seed, _freqStep, _seedStep]] call CORE_fnc_callFunction;
	
	["rs_setChannels", ["ACRE_PRC148", _channels]] call CORE_fnc_callFunction;
	["rs_setChannels", ["ACRE_PRC148_UHF", _channels]] call CORE_fnc_callFunction;
	["rs_setChannels", ["ACRE_PRC152", _channels]] call CORE_fnc_callFunction;
	["rs_setChannels", ["ACRE_PRC117F", _channels]] call CORE_fnc_callFunction;
	
	// PRC119 Work-Around
	_channels resize 6;
	
	["rs_setChannels", ["ACRE_PRC119", _channels]] call CORE_fnc_callFunction;
	
	// Long Range Radios
	_base			= 2400;
	_channelCount	= 16;
	_channels		= ["rs_channelGen", [_channelCount, _base, _seed, _freqStep, _seedStep]] call CORE_fnc_callFunction;
	
	["rs_setChannels", ["ACRE_PRC343", _channels]] call CORE_fnc_callFunction;
	
} else {
	[LOG_WARN, 'RADIO_SCRAMBLER', "Radio scrambler timed-out while waiting for radio seeds (global variable).", [], __FILE__, __LINE__] call CORE_fnc_log;
};
