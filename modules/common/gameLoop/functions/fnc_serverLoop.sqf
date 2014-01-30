
if (isServer) then {
	sleep 5; // Wait Until Mission Start
	private ["_startTime", "_initPlayers", "_infVars"];
	_startTime		= diag_tickTime;
	_initPlayers	= call CBA_fnc_players;
	_infVars		= [
		[WEST, (WEST countSide _initPlayers), 'gameLoop_west_infLoss', 'gameLoop_west_infPercentLoss'],
		[EAST, (EAST countSide _initPlayers), 'gameLoop_east_infLoss', 'gameLoop_east_infPercentLoss'],
		[RESISTANCE, (RESISTANCE countSide _initPlayers), 'gameLoop_resistance_infLoss', 'gameLoop_resistance_infPercentLoss'],
		[CIVILIAN, (CIVILIAN countSide _initPlayers), 'gameLoop_civilian_infLoss', 'gameLoop_civilian_infPercentLoss']
	];
	
	while {(['gameLoop_enabled'] call CORE_fnc_getVariable)} do {
		private ["_endTime", "_missionTime", "_missionObj", "_endMission", "_infLoss"];
		_endTime = _startTime + (['gameLoop_timeLimit'] call CORE_fnc_getVariable);
		_missionTime = diag_tickTime - _startTime;
		_missionObj = ['gameLoop_missionObjCheck'] call CORE_fnc_callFunction;
		_endMission = nil;
		_infLoss = nil;
		
		/****************************************
		*	End Conditions Checking (Ordered)
		****************************************/
		
		if (_missionObj select 0) then {
			_endMission = ['objective', (_missionObj select 1)];
		};
		
		{ // forEach
			private ["_side", "_startCount", "_lossVar", "_percVar", "_deadCount", "_percLoss"];
			_side = _x select 0;
			_startCount = _x select 1;
			_lossVar = _x select 2;
			_percVar = _x select 3;
			_deadCount = [_lossVar] call CORE_fnc_getVariable;
			_percLoss = [_percVar] call CORE_fnc_getVariable;
			if ((_deadCount > (_startCount * (_percLoss / 100))) && (_percLoss <= 100)) exitWith {
				_infLoss = [_side, _startCount, _deadCount];
			};
		} forEach _infVars;
		
		if (!(isNil '_infLoss')) then {
			_endMission = ['infLoss', _infLoss];
		};
		
		if ((diag_tickTime > _endTime) && (_endTime != _startTime)) then {
			_endMission = ['time', [_missionTime]];
		};
		
		/***************************************/
		
		if (!(isNil "_endMission")) exitWith {
			['gameLoop_endMission', _endMission] call CBA_fnc_globalEvent;
		};
		
		sleep (['gameLoop_glCheckFreq', 30] call CORE_fnc_getVariable);
	};
};
