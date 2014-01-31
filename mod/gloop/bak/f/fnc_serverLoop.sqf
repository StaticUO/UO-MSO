
if (isServer) then {
	sleep 5; // Wait Until Mission Start
	private ["_startTime"];
	_startTime = diag_tickTime;
	
	while {gloop_enabled} do {
		private ["_endTime", "_missionTime", "_missionObj", "_endMission"];
		_endTime = _startTime + gloop_timeLimit;
		_missionTime = diag_tickTime - _startTime;
		_missionObj = [] call gloop_fnc_missionObjCheck;
		_endMission = [];
		
		switch (true) do {
			case (_missionObj select 0): {
				_endMission = ['objective', (_missionObj select 1)];
			};
			case ((diag_tickTime > _endTime) && (_endTime != _startTime)): {
				_endMission = ['time', [_missionTime]];
			};
		};
		
		if ((count _endMission) > 0) exitWith {
			['gloop_event_endMission', _endMission] call CBA_fnc_globalEvent;
		};
		
		uiSleep gloop_glCheckFreq;
	};
};
