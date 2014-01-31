
/*
	Title: File System Shared Library
	File: fs.sqf
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

CORE_fnc_compileModFile = {
	private ["_relPath"];
	_relPath = _this select 0;
	// _id is local to about +3 scopes, in main 'init.sqf' file
	compile preprocessFileLineNumbers ("mod\" + _id + "\" + _relPath);
};

CORE_fnc_checkAddon = {
	private ["_addon", "_result"];
	_addon	= _this select 0;
	_suffix	= if ((count _this) > 1) then {_this select 1} else {true};
	_result	= nil;
	if (!isNil "_addon") then {
		if (_suffix) then {_addon = _addon + "_main"};
		_result = isClass(configFile >> "CfgPatches" >> _addon);
	};
	_result
};

CORE_fnc_isFilePath = {
	if (typeName(_this) != typeName([])) then {_this = [_this]};
	private ["_stringArray"];
	_stringArray = toArray(_this select 0);
	((_stringArray find 46) >= 0) && ((_stringArray find 34) < 0) && ((_stringArray find 39) < 0) // 46='.', 34=("), 39=(') (ie: 'path\file.sqf')
};

