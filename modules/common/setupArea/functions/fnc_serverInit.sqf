
private ["_handle"];

_handle = [] spawn {
	waitUntil {!(isNil "sa_setupAreas")};
	sleep 0.5;
	
	private ["_startTime"];
	_startTime = time;
	
	while {true} do {
		private ["_setupsDone"];
		_setupsDone	= 0;
		
		for "_i" from 0 to ((count sa_setupAreas) - 1) do {
			private ["_sa", "_marker", "_delay", "_enabled"];
			_sa			= sa_setupAreas select _i;
			_marker		= _sa select 0;
			_delay		= _sa select 1;
			_enabled	= _sa select 2;
			
			if (_enabled && {(_startTime + _delay) < time}) then {
				_enabled = false;
				_sa set [2, _enabled];
				sa_setupAreas set [_i, _sa];
				publicVariable "sa_setupAreas";
			};
			
			if !(_enabled) then {
				_setupsDone = _setupsDone + 1;
			};
		};
		
		if (_setupsDone >= (count sa_setupAreas)) exitWith {
			[LOG_INFO, 'SETUP_AREA', "All setup areas have finished.", [], __FILE__, __LINE__] call CORE_fnc_log;
		};
		
		sleep 1;
	};
};

['sa_serverLoopSpawnHandle', _handle] call CORE_fnc_setVariable;
