
/*
	Title: Diagnostics Shared Library
	File: diag.sqf
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

/*
	Group: Variables
*/

LOG_NONE 	= 0;	// None
LOG_CRIT 	= 1;	// Critical
LOG_ERROR 	= 2;	// Error
LOG_WARN 	= 3;	// Warning
LOG_NOTICE 	= 4;	// Notice
LOG_INFO 	= 5;	// Info
LOG_ALL 	= 6;	// All

/*
	Group: Functions
*/

CORE_fnc_log = {
	private ["_level", "_component", "_message", "_params", "_file", "_line", "_levelTitle", "_output"];
	_level		= _this select 0;
	_component	= _this select 1;
	_message	= _this select 2;
	_params		= if ((count _this) > 3) then {_this select 3} else {[]};
	_file		= if ((count _this) > 4) then {_this select 4} else {'No File Specified'};
	_line		= if ((count _this) > 5) then {':' + str(_this select 5)} else {''};
	_levelTitle	= '';
	_output = format ["%1: %2 @ %3 [M: %4 | I: %5 | T: %6 | F: '%7%8'] %9",
		diag_tickTime,
		_levelTitle,
		_component,
		missionName,
		worldName,
		time,
		_file,
		_line,
		format ([_message] + _params)
	];
	diag_log text _output;
	if (CORE_logToDiary) then {
		_output spawn {
			waitUntil {!(isNull player) && {player diarySubjectExists "framework"}};
			player createDiaryRecord ["framework", ["Diagnostics Log", ("<font face='Zeppelin33' size='10'>" + ([_this, newLineChar, "<br/>"] call CBA_fnc_replace) + "</font>")]];
		};
	};
};

CORE_fnc_localMachineState = {
	private ["_machineState"];
	_machineState = 0;
	if (isServer) then {
		_machineState = _machineState + 32; // Server
	};
	if (isDedicated) then {
		_machineState = _machineState + 64; // Dedicated Server
	} else {
		_machineState = _machineState + 1; // Client
		if (hasInterface) then {
			_machineState = _machineState + 2; // Player
		} else {
			_machineState = _machineState + 4; // HC
		};
		
		if (isNull player) then {
			_machineState = _machineState + 16; // JIP
		} else {
			_machineState = _machineState + 8; // Non-JIP
		};
	};
	_machineState
};

CORE_fnc_isMachine = {
	private ["_localMachine", "_testMachines", "_return"];
	_localMachine	= _this select 0;
	_testMachines	= _this select 1;
	_return			= false;
	if (typeName(_testMachines) == typeName(2)) then {
		_testMachines = [_testMachines];
	};
	if (typeName(_testMachines) == typeName([])) then {
		{
			if ([_localMachine, _x] call CORE_fnc_decHasBin) exitWith {
				_return = true;
			};
		} forEach _testMachines;
	};
	_return
};
