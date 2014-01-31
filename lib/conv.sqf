
/*
	Title: Conversion Shared Library
	File: conv.sqf
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

CORE_fnc_sideToText = {
	private ["_side", "_return"];
	_side = _this select 0;
	_return = switch (_side) do {
		case WEST: {'Blufor'};
		case EAST: {'Opfor'};
		case RESISTANCE: {'Independent'};
		case CIVILIAN: {'Civilian'};
		case SIDEENEMY: {'Renegade'};
		case SIDEFRIENDLY: {'Friendlies'};
		case default {'NULL'};
	};
	_return
};

CORE_fnc_toBool = {
	/* WARNING: Do not use this for raw input or persistant data */
	private ["_eval", "_params"];
	_eval		= _this select 0;
	_params		= if ((count _this) > 1) then {_this select 1} else {[]};
	if (typeName(_eval) == typeName("")) then {
		_eval = if (_eval == "") then {false} else {compile _eval};
	};
	if (typeName(_eval) == typeName({})) then {
		_eval = _params call _eval;
	};
	if (typeName(_eval) == typeName(1)) then {
		switch (_eval) do {
			case 0: {_eval = false;};
			case 1: {_eval = true;};
		};
	};
	if (typeName(_eval) != typeName(true)) then {
		_eval = false;
	};
	_eval
};
