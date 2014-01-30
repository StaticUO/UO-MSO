
waitUntil {!(isNil "sa_setupAreas") && !(isNil "sa_exemptUnits")};

#define WAIT_TIME	3	// Wait (Seconds)

if !(player in sa_exemptUnits) then {
	for "_i" from 0 to ((count sa_setupAreas) - 1) do {
		private ["_sa", "_marker", "_delay", "_enabled"];
		_sa			= sa_setupAreas select _i;
		_marker		= _sa select 0;
		_delay		= _sa select 1;
		_enabled	= _sa select 2;
		_inArea		= [player, _marker] call CBA_fnc_inArea;
		
		if (_inArea && _enabled) then {
			_marker setMarkerAlphaLocal 1;
			['sa_containUnit', [player, _i, WAIT_TIME]] call CORE_fnc_spawnFunction;
		} else {
			_marker setMarkerAlphaLocal 0;
		};
	};
};
