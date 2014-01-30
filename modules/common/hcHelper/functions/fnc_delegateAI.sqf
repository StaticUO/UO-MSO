
if (CORE_machine in CORE_LMS_aiHost) then {
	
	private ["_startTime"];
	_startTime	= diag_tickTime;
	
	if (isServer) then {
		
		private ["_hcAvailable"];
		
		hcHelper_hcConnected = [false, []];
		hcHelper_hcCheckReturn = false;
		publicVariable "hcHelper_hcConnected";
		publicVariable "hcHelper_hcCheckReturn";
		
		waitUntil {
			uiSleep 0.1;
			private ["_endTime"];
			_endTime = _startTime + hcHelper_delAIBriefTimeOut;
			_hcAvailable = hcHelper_hcConnected select 0;
			(_hcAvailable) || (diag_tickTime > _endTime) || (time > hcHelper_delAIGameTimeOut);
		};
		
		if !(_hcAvailable) then {
			hcHelper_aiHandler = true;
		} else {
			hcHelper_aiHandler = false;
		};
		
		// HC Connection Check Thread
		['hcHelper_monitorHC'] call CORE_fnc_spawnFunction;
	};
	
	if ([CORE_machine, CORE_LMS_hc] call CORE_fnc_isMachine) then {
		['hcHelper_checkHC', {hcHelper_hcCheckReturn = true; publicVariable "hcHelper_hcCheckReturn";}] call CBA_fnc_addEventHandler;
		
		waitUntil {!(isNil "hcHelper_hcConnected")};
		uisleep random(1);
		
		hcHelper_hcConnected set [0, true];
		hcHelper_hcConnected set [1, ((hcHelper_hcConnected select 1) + [player])];
		publicVariable "hcHelper_hcConnected";
		
		hcHelper_aiHandler = true;
	};
	
	[LOG_NOTICE, 'hcHelper', "Check: Init. Machine: %1. AI Handler: %2. HC Available: %3. Delay: %4.", [CORE_machine, hcHelper_aiHandler, (count (hcHelper_hcConnected select 1)), (diag_tickTime - _startTime)], __FILE__, __LINE__] spawn CORE_fnc_log;
};
