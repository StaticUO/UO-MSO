
/*
	Title: Time Shared Library
	File: time.sqf
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

CORE_fnc_timeOut = {
	private ["_variable", "_timeOut", "_varCheck", "_startTime", "_endTime"];
	_func		= _this select 0;
	_timeOut	= _this select 1;
	_varCheck	= nil;
	_startTime	= diag_tickTime;
	_endTime	= _startTime + _timeOut;
	if (typeName(_func) == typeName("")) then {
		_func = compile _func;
	};
	if (typeName(_func) == typeName({})) then {
		waitUntil {
			_varCheck = [_startTime, _timeOut, _endTime] call _func;
			((!isNil "_varCheck") OR (diag_tickTime > _endTime));
		};
	};
	if (isNil "_varCheck") then {
		[LOG_INFO, 'CORE', "Function Check timed-out after %1 seconds.", [round(diag_tickTime - _startTime)], __FILE__, __LINE__] call CORE_fnc_log;
	};
	_varCheck
};

CORE_fnc_waitUntil = {
	private ["_code", "_component", "_timeOut", "_logLevel", "_startTime", "_timeOutEnabled", "_textArray"];
	_code			= _this select 0;
	_component		= if ((count _this) > 1) then {_this select 1} else {""};
	_timeOut		= if ((count _this) > 2) then {_this select 2} else {0};
	_logLevel		= if ((count _this) > 3) then {_this select 3} else {LOG_INFO};
	_startTime		= diag_tickTime;
	_timeOutEnabled	= _timeOut > 0;
	if (typeName(_code) != typeName([])) then {_code = [_code]};
	_textArray = if (_component == "") then {
		["Waiting...", "Waiting"];
	} else {
		["Waiting for " + _component + "...", _component];
	};
	[_logLevel, 'CORE_WAIT_UNTIL', (_textArray select 0), [], __FILE__, __LINE__] call CORE_fnc_log;
	{
		if (typeName(_x) == typeName("")) then {_x = compile _x};
		waitUntil {(call _x) || (_timeOutEnabled && (_timeOut < diag_tickTime))};
	} forEach (+_code);
	[_logLevel, 'CORE_WAIT_UNTIL', ((_textArray select 1) + " done! Delay: %1 seconds. Proceeding."), [(diag_tickTime - _startTime)], __FILE__, __LINE__] call CORE_fnc_log;
	true
};
