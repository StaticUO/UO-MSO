
/*
	Title: CORE Mission Framework
	File: init.sqf
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

/* Start loading screen */
startLoadingScreen ["Loading CORE Mission Framework..."];

/* Load static definitions */
newLineChar = toString([10]);

/* Load standard headers */
#include "h\oop.h"

/* Load essential libraries */
#include "lib\arrays.sqf"
#include "lib\conv.sqf"
#include "lib\diag.sqf"
#include "lib\fs.sqf"
#include "lib\hashmaps.sqf"
#include "lib\math.sqf"
#include "lib\rve.sqf"
#include "lib\strings.sqf"
#include "lib\time.sqf"

/* Include settings */
#include "settings.sqf"

/* Start initialization */
private ["_startTime"];
_startTime = diag_tickTime;
[LOG_NOTICE, 'CORE', "Core Initialization Starting!", [], __FILE__, __LINE__] call CORE_fnc_log;

/* Set variables */
CORE_init = false;
if (isServer) then {
	CORE_serverInit = false;
	publicVariable "CORE_serverInit";
};

/* Load machine state */
CORE_machine = [] call CORE_fnc_localMachineState;

/* Wait for XEH post-init */
if (isClass(configFile >> "CfgPatches" >> "cba_xeh")) then {
	[[{!(isNil "SLX_XEH_MACHINE") && {SLX_XEH_MACHINE select 8}}], 'XEH Post Init', 0, LOG_NOTICE] call CORE_fnc_waitUntil;
};

/* Wait for server */
if (!isServer) then {
	[[{!(isNil "CORE_serverInit") && {CORE_serverInit}}], 'Server Init', 0, LOG_NOTICE] call CORE_fnc_waitUntil;
};

/* Load mission parameters */
private ["_paramCfg", "_params", "_paramDft"];
_paramCfg	= missionConfigFile >> "Params";
_params		= [];
_paramDft	= false;
if (isNil "paramsArray") then {
	_paramDft = true;
	paramsArray = [];
};
for "_i" from 0 to ((count _paramCfg) - 1) do {
	private ["_param", "_var", "_value"];
	_param = _paramCfg select _i;
	if (isText (_param >> "varName")) then {
		_var = getText (_param >> "varName");
	} else {
		_var = format["PARAMS_%1", (configName _param)];
	};
	if (_paramDft) then {
		_value = getNumber (_param >> "default");
		paramsArray set [_i, _value];
	} else {
		_value = paramsArray select _i;
	};
	if ((isNumber(_param >> "toBool")) && {(getNumber(_param >> "toBool")) == 1}) then {
		_value = [_value] call CORE_fnc_toBool;
	};
	if (isText (_param >> "executeCode")) then {
		_value = _value call compile (getText (_param >> "executeCode"));
	};
	if (isServer && {_var != ""}) then {
		missionNameSpace setVariable [_var, _value];
		publicVariable _var;
	};
	_params = _params + [[getText(_param >> "title"), _var, _value]];
};
CORE_params = _params;

/* Wait for player */
if (!isDedicated) then {
	waitUntil {!(isNull player)};
};

/* Create framework statistics pages */
#define MOD_CONFIG (missionConfigFile >> "CfgModules")
if (hasInterface && {[["frameworkStats"] call CORE_fnc_getSetting] call CORE_fnc_toBool}) then {
	private ["_params", "_modules"];
	_params = "";
	_modules = "";
	{ // forEach
		_params = _params + ("<br/>" + (_x select 0) + ": " + str(_x select 2));
	} forEach CORE_params;
	for "_i" from 0 to (count MOD_CONFIG) do {
		private ["_mod"];
		_mod = MOD_CONFIG select _i;
		_modules = _modules + format["<br/>%1 (%2): %3",
			className(_mod),
			getText(_mod >> "identifier"),
			[(_mod >> "enabled")] call CORE_fnc_toBool
		];
	};
	player createDiarySubject ["framework","CORE Framework"];
	player createDiaryRecord ["framework", ["About", format[
		"<br />CORE Mission Framework<br />    Version: %1<br />    Authors: %2",
		getText(missionConfigFile >> "CORE_Framework" >> "version"),
		[getArray(missionConfigFile >> "CORE_Framework" >> "authors")] call CORE_fnc_concatenateStrings
	]]];
	player createDiaryRecord ["framework", ["Modules", ("<br/>Framework Modules:<br/>" + _modules)]];
	player createDiaryRecord ["framework", ["Parameters", ("<br/>Mission Parameters:<br/>" + _params)]];
	player createDiaryRecord ["framework", ["Diagnostics Log", ""]; // Reserved for logging uses
};

/* Load modules */
private ["_modules"];
_modules = [];
for "_i" from 0 to (count MOD_CONFIG) do {
	private ["_mod"];
	_mod = MOD_CONFIG select _i;
	if (!(isNumber(_mod >> "enabled")) || {[(_mod >> "enabled")] call CORE_fnc_toBool}) then {
		private ["_id"];
		_id = getText(_mod >> "identifier");
		if (isServer && {isClass(_mod >> "params")}) then {
			for "_j" from 0 to (count(_mod >> "params")) do {
				private ["_param", "_var"];
				_param = (_mod >> "params") select _j;
				_var = _id + "_" + className(_param);
				missionNamespace setVariable [_var, [_param] call CORE_fnc_getConfigValue];
				publicVariable _var;
			};
		};
		if (!(isArray(_mod >> "machines")) || {[CORE_machine, getArray(_mod >> "machines")] call CORE_fnc_isMachine}) then {
			_modules set [(count _modules), [
				(if (isNumber(_mod >> "priority")) then {getNumber(_mod >> "priority")} else {100}),
				_id,
				(if (isText(_mod >> "init")) then {getText(_mod >> "init")} else {"init.sqf"}),
				(if (isArray(_mod >> "dependencies")) then {getArray(_mod >> "dependencies")} else {[]})
			]];
		};
	};
};

/* Execute modules by priority */
private ["_loadedModules"];
_loadedModules = [];
{ // forEach
	private ["_id", "_exec"];
	_id = _x select 1;
	_exec = true;
	if ((count (_x select 2)) > 0) then {
		{ // forEach
			if (!(_x in _loadedModules)) exitWith {
				[LOG_ERROR, 'CORE', "Module execution failed, dependency not loaded. Module: '%1'. Failed Dependency: '%2'. Loaded Modules: %3.",
					[_id, _x, _loadedModules],
					__FILE__, __LINE__
				] call CORE_fnc_log;
				_exec = false;
			};
		} forEach (_x select 3);
	};
	if (_exec) then {
		if ((_x select 2) != "") then {
			private ["_file"];
			_file = preprocessFileLineNumbers ("mod\" + (_x select 1) + "\" + (_x select 2));
			if (_file != "") then {
				[] call compile _file;
			} else {
				[LOG_INFO, 'CORE', "Module init.sqf file returned nothing. Module: %1.", [_id], __FILE__, __LINE__] call CORE_fnc_log;
			};
		};
		_loadedModules set [(count _loadedModules), _id];
	};
} forEach ([_modules, {(_this select 0) * -1}] call CORE_fnc_shellSort);

/* Process setVehicleInit code */
processInitCommands;

/* Finish world initialization*/
finishMissionInit;

/* Finalize initialization */
CORE_init = true;
if (isServer) then {
	CORE_serverInit = true;
	publicVariable "CORE_serverInit";
};

/* End initialization */
[LOG_NOTICE, 'CORE', "Core Initialization Finished! STATS: Machine=%1, Benchmark=%2", [
	CORE_machine,
	(diag_tickTime - _startTime)
], __FILE__, __LINE__] call CORE_fnc_log;

/* End loading screen */
endLoadingScreen;
