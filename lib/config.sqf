
/*
	Title: RVE Config Shared Library
	File: config.sqf
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

CORE_fnc_getSetting = {
	private ["_setting"];
	_setting = _this select 0;
	[missionConfigFile >> "CORE_Framework" >> _setting] call CORE_fnc_getConfigValue;
};

CORE_fnc_getConfigValue = {
	private ["_cfg"];
	_cfg = _this select 0;
	switch (true) do {
		case (isText(_cfg)): {
			getText(_cfg);
		};
		case (isNumber(_cfg)): {
			getNumber(_cfg);
		};
		case (isArray(_cfg)): {
			getArray(_cfg);
		};
		case (isClass(_cfg)): {
			_cfg;
		};
		default {
			nil;
		};
	};
};