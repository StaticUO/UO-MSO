
/*
	Title: Math Shared Library
	File: math.sqf
	Author(s): Naught
	
	License:
		Copyright 2014 Dylan Plecki.
		
		Licensed under the Apache License, Version 2.0 (the "License");
		you may not use this file except in compliance with the License.
		You may obtain a copy of the License at
		
		http://www.apache.org/licenses/LICENSE-2.0
		
		Unless required by applicable law or agreed to in writing, software
		distributed under the License is distributed on an "AS IS" BASIS,
		WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
		See the License for the specific language governing permissions and
		limitations under the License.
*/

CORE_fnc_decHasBin = {
	/* Checks to see if decimal number contains binary number */
	private ["_decimal", "_binary", "_return"];
	_decimal	= _this select 0;
	_binary		= _this select 1;
	_return		= false;
	if (_binary != 0) then {
		if (_decimal == _binary) then {_return = true};
		if (_decimal > _binary) then {
			if (((log(_binary) / log(2)) % 1) == 0) then {
				if (floor((_decimal / _binary) % 2) == 1) then {
					_return = true;
				};
			} else {
				if (((_binary % 1) == 0) && ((_decimal % 1) == 0)) then {
					private ["_i"];
					_i = 0;
					_return = true;
					while {_binary > 0} do {
						if (((_binary mod 2) == 1) && ((_decimal mod 2) != 1)) exitWith {_return = false};
						_binary = floor(_binary / 2);
						_decimal = floor(_decimal / 2);
						_i = _i + 1;
					};
				};
			};
		};
	};
	_return
};

CORE_fnc_decToBin = {
	/* Converts a decimal number to a binary array */
	private ["_decimal", "_return", "_base"];
	_decimal	= _this select 0;
	_return		= [];
	_base 		= 2;
	if ((_decimal % 1) == 0) then { // Needs to be a whole number 
		private ["_i"];
		_i = 0;
		while {_decimal > 0} do {
			_return set [_i, (_decimal mod _base)];
			_decimal = floor(_decimal / _base);		// (_decimal - _rem) / _base
			_i = _i + 1;
		};
	};
	_return
};

CORE_fnc_rand = {
	private ["_seed"];
	if (typeName(_this) == typeName(1)) then {_this = [_this]};
	if (typeName(_this) != typeName([])) then {_this = []};
	_seed = if ((count _this) > 0) then {_this select 0} else {random(2^16)};
	_seed = (((2^8) + 1) * _seed + ((2^11) + 1)) mod (2^16);
	_seed
};