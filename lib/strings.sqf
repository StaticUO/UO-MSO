
/*
	Title: String Shared Library
	File: strings.sqf
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

CORE_fnc_concatenateStrings = {
	private ["_array", "_code", "_ret"];
	_array = _this select 0;
	_code = if ((count _this) > 1) then {_this select 1} else {{_this}};
	_ret = "";
	{ // forEach
		_ret = _ret + (_x call _code);
	} forEach _array;
	_ret
};