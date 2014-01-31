
/*
	Title: Array Shared Library
	File: arrays.sqf
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

CORE_fnc_push = {
	private ["_obj", "_var", "_val", "_arr"];
	_obj = _this select 0;
	_var = _this select 1;
	_val = _this select 2;
	_arr = _obj getVariable _var;
	if (isNil "_arr" || {typeName(_arr) != "ARRAY"}) then {
		_obj setVariable [_var, []];
		_arr = _obj getVariable _var;
	};
	_arr set [(count _arr), _val];
};

CORE_fnc_uErase = { // Unordered erase function
	private ["_arr", "_idx", "_last"];
	_arr = _this select 0;
	_idx = _this select 1;
	_last = (count _arr) - 1;
	_arr set [_idx, (_arr select _last)];
	_arr resize _last;
};

CORE_fnc_heapSort = {
	private ["_fnc_swap", "_fnc_siftDown"];
	_fnc_swap = {
		private ["_array", "_pos1", "_pos2", "_temp"];
		_array = _this select 0;
		_pos1 = _this select 1;
		_pos2 = _this select 2;
		_temp = _array select _pos1;
		_array set [_pos1, (_array select _pos2)];
		_array set [_pos2, _temp];
	};
	_fnc_siftDown = {
		private ["_array", "_start", "_end", "_compFunc", "_root"];
		_array = _this select 0;
		_start = _this select 1;
		_end = _this select 2;
		_compFunc = _this select 3;
		_root = _start;
		while {((_root * 2) + 1) <= _end} do {
			private ["_child", "_swap"];
			_child = (_root * 2) + 1;
			_swap = _root;
			if (((_array select _swap) call _compFunc) < ((_array select _child) call _compFunc)) then {
				_swap = _child;
			};
			if (((_child + 1) <= _end) && ((_array select _swap) < (_array select (_child + 1)))) then {
				_swap = _child + 1;
			};
			if (_swap != _root) then {
				[_array, _root, _swap] call _fnc_swap;
				_root = _swap;
			};
		};
	};
	private ["_array", "_compFunc", "_start", "_end"];
	_array = _this select 0;
	_compFunc = DEFAULT_PARAM(1,{_this});
	_start = ((count _array) - 2) / 2;
	_end = (count _array) - 1;
	if ((count _array) > 1) then {
		while {_start >= 0} do {
			[_array, _start, _end, _compFunc] call _fnc_siftDown;
			_start = _start - 1;
		};
		while {_end > 0} do {
			[_array, _end, 0] call _fnc_swap;
			_end = _end - 1;
			[_array, 0, _end, _compFunc] call _fnc_siftDown;
		};
	};
	_array
};

CORE_fnc_shellSort = {
	/*
	   Author:
		rübe
		
	   Description:
		generic shell sort implementation. The original list does 
		NOT get altered.
		
		Shellsort is not sensitive to the initial ordering of the
		given list. Hard to compare to other sorting methods but
		shellsort is often the method of choice for many sorting
		applications:
		
		 - acceptable runtime even for moderately large lists,
		   (Sedgewick says up to "five thousand elements")
		 - yet very easy algorithm.
		
	   Parameter(s):
		_this select 0: the list to be sorted (array of any)
		_this select 1: sort value selector/calculator (string or code; optional)
						- gets passed a list item, must return scalar
						- if a string gets passed, we compile it first
						
						-> if the list does not consist of numbers but a complex 
						   data structure (like arrays), you may pass a simple
						   function, that accesses (or calculate) the "value" 
						   in this structure the list will be sorted on.
						   
						-> to simply invert the sort order, pass {_this * -1} as
						   second parameter (for numbers).
						   
						   default sorting order is ASCENDING

	   Returns:
		sorted list
	*/

	private ["_list", "_selectSortValue", "_n", "_cols", "_j", "_k", "_h", "_t", "_i"];

	_list = +(_this select 0);
	_selectSortValue = { _this };

	if ((count _this) > 1) then
	{
	   if ((typeName (_this select 1)) == "CODE") then
	   {
		  _selectSortValue = _this select 1;
	   } else {
		  _selectSortValue = compile (_this select 1);
	   };
	};

	// shell sort
	_n = count _list;
	// we take the increment sequence (3 * h + 1), which has been shown
	// empirically to do well... 
	_cols = [3501671, 1355339, 543749, 213331, 84801, 27901, 11969, 4711, 1968, 815, 271, 111, 41, 13, 4, 1];

	for "_k" from 0 to ((count _cols) - 1) do
	{
	   _h = _cols select _k;
	   for [{_i = _h}, {_i < _n}, {_i = _i + 1}] do
	   {
		  _t = _list select _i;
		  _j = _i;

		  while {(_j >= _h)} do
		  {
			 if (!(((_list select (_j - _h)) call _selectSortValue) > 
				   (_t call _selectSortValue))) exitWith {};
			 _list set [_j, (_list select (_j - _h))];
			 _j = _j - _h;
		  };
		  
		  
		  _list set [_j, _t];
	   };
	};

	_list
};

CORE_fnc_insertSort = {
	/*
	   Author:
		rübe
		
	   Description:
		generic implementation of the insertion sorting algorithm (that's one 
		of the simplest there is). The original list does NOT get altered.
		
		This sorting algorithm is very sensitive to the initial ordering of 
		the given list and thus only efficient for small/mostly-sorted 
		lists (we swap only adjacent elements!). Use another one for 
		large/totally unsorted lists. (e.g. CORE_fnc_shellSort)
		
		>> Sedgewick says: "In short, insertion sort is the method of choice
		   for `almost sorted` files with few inversions: for such files, it
		   will outperform even the sophisticated methods [...]" 
		   
		   (e.g. if you have an already sorted list and you wanna add some 
		   more to it...)
		
		 - best case: O(n)
		 - worst case: O(n^2)
		
	   Parameter(s):
		_this select 0: the list to be sorted (array of any)
		_this select 1: sort value selector/calculator (string or code; optional)
						- gets passed a list item, must return scalar
						- if a string gets passed, we compile it first
						
						-> if the list does not consist of numbers but a complex 
						   data structure (like arrays), you may pass a simple
						   function, that accesses (or calculates) the "value" 
						   in this structure the list will be sorted on.
						   
						-> to simply invert the sort order, pass {_this * -1} as
						   second parameter (for numbers).
						   
						   default sorting order is ASCENDING
				   
	   Example(s):
	   
		// 1) sorting numbers

		_numbers = [8, 12, 1, 7, 8, 5];
		_sortedNumbers = [_numbers] call CORE_fnc_insertSort
		
		// result: [1, 5, 7, 8, 8, 12]
		
		
		// 2) sorting data structures, calculating comp.-value
		//    and save the result in the given data structure too!

		_players = [
		   // player, points, kills, killed
		   [player1, 650, 5, 12],
		   [player2, 40, 45, 27],
		   [player3, 500, 19, 2],
		   [player4, 370, 9, 1]
		];
		// sort function
		_calculatePlayerTable = {
		   private ["_points", "_kills", "_killed", "_score"];
		   _points = _this select 1;
		   _kills = _this select 2;
		   _killed = _this select 3;
	   
		   _score = ((_points + (_kills * 5) - (_killed * 10)) * -1);
		   _this set [4, (abs _score)];
	   
		   _score
		};
		_sortedPlayers = [_list, _calculatePlayerTable] call CORE_fnc_insertSort;
		
		// result: [[player3, ..., 575], [player1, ..., 555], [player4, ..., 405], [player2, ..., 5]]
		  
						   
	   Returns:
		sorted list
	*/

	private ["_list", "_selectSortValue", "_item", "_i", "_j"];

	_list = +(_this select 0);
	_selectSortValue = { _this };

	if ((count _this) > 1) then
	{
	   if ((typeName (_this select 1)) == "CODE") then
	   {
		  _selectSortValue = _this select 1;
	   } else {
		  _selectSortValue = compile (_this select 1);
	   };
	};

	// insert sort
	for "_i" from 1 to ((count _list) - 1) do
	{
	   _item = +(_list select _i);
	   _j = 0;
	   for [{_j = _i}, {_j > 0}, {_j = _j - 1}] do
	   {
		  if (((_list select (_j - 1)) call _selectSortValue) < (_item call _selectSortValue)) exitWith {};
		  _list set [_j, (_list select (_j - 1))];
	   };
	   _list set [_j, _item];
	};

	_list
};

CORE_fnc_sortObjectDistance = {
	private ["_array", "_object"];
	_array = _this select 0;
	_object = _this select 1; // Can use in compFunc b/c of SQF scoping
	[_array, {_this distance _object}] call CORE_fnc_heapSort;
};