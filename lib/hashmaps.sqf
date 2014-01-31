
/*
	Title: Hashmap Shared Library
	File: hashmaps.sqf
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

CLASS("CORE_obj_hashMap") // Unique unordered map
	PRIVATE VARIABLE("array", "map");
	PUBLIC FUNCTION("","constructor") {
		#define DFT_MAP [[],[]]
		MEMBER("map",DFT_MAP);
	};
	PUBLIC FUNCTION("","deconstructor") {
		DELETE_VARIABLE("map");
	};
	PUBLIC FUNCTION("array","get") { // ["key", default], returns value (any)
		private ["_map", "_index"];
		_map = MEMBER("map",nil);
		_index = (_map select 0) find (_this select 0);
		if (_index >= 0) then {
			(_map select 1) select _index;
		} else {_this select 1};
	};
	PUBLIC FUNCTION("string","get") { // "key", returns value (any)
		private ["_args"];
		_args = [_this, nil];
		MEMBER("get",_args);
	};
	PUBLIC FUNCTION("array","insert") { // ["key", value], returns overwritten (bool)
		private ["_map", "_index"];
		_map = MEMBER("map",nil);
		_index = (_map select 0) find (_this select 0);
		if (_index >= 0) then {
			(_map select 1) set [_index, (_this select 1)];
			true;
		} else {
			_index = count (_map select 0);
			(_map select 0) set [_index, (_this select 0)];
			(_map select 1) set [_index, (_this select 1)];
			false;
		};
	};
	PUBLIC FUNCTION("string","erase") { // "key", returns success (bool)
		private ["_map", "_index"];
		_map = MEMBER("map",nil);
		_index = (_map select 0) find (_this select 0);
		if (_index >= 0) then {
			private ["_last"];
			_last = (count (_map select 0)) - 1;
			(_map select 0) set [_index, ((_map select 0) select _last)];
			(_map select 1) set [_index, ((_map select 1) select _last)];
			(_map select 0) resize _last;
			(_map select 1) resize _last;
			true;
		} else {
			false;
		};
	};
	PUBLIC FUNCTION("","copy") { // nil, returns hashmap (array)
		MEMBER("map",nil);
	};
	PUBLIC FUNCTION("array","copy") { // [hashMap], returns nothing (nil)
		MEMBER("map",_this);
	};
ENDCLASS;
