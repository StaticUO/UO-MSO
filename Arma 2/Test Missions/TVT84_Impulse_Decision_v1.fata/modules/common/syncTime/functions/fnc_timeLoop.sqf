
[] spawn {
	waitUntil {
		private ["_sleepTime"];
		_sleepTime = ['syncTime_syncLoop'] call CORE_fnc_getVariable;
		if (_sleepTime > 0) then {
			sleep _sleepTime;
			['syncTime', date] call CBA_fnc_remoteEvent;
		} else {
			sleep 60; // Hard-coded checking time
		};
		false;
	};
};
