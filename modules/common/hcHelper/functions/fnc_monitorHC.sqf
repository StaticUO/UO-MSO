
waitUntil {
	{
		private ["_startTime"];
		_startTime	= diag_tickTime;
		
		['hcHelper_checkHC', [_x]] call CBA_fnc_remoteLocalEvent;
		
		waitUntil {
			uiSleep 0.1;
			private ["_endTime"];
			_endTime = _startTime + hcHelper_delAIGameTimeOut;
			((hcHelper_hcCheckReturn) || (diag_tickTime > _endTime));
		};
		
		if !(hcHelper_hcCheckReturn) then {
			
			hcHelper_hcConnected set [1, ((hcHelper_hcConnected select 1) - [_x])];
			
			if ((count (hcHelper_hcConnected select 1)) < 1) then {
				hcHelper_hcConnected set [0, false];
				hcHelper_aiHandler = true;
			} else {
				hcHelper_hcConnected set [0, true];
				hcHelper_aiHandler = false;
			};
			
			publicVariable "hcHelper_hcConnected";
			
			[LOG_WARN, 'hcHelper', "HC '%1' Disconnected. HC Left: %2. AI Handler: %3.", [_x, (count (hcHelper_hcConnected select 1)), hcHelper_aiHandler], __FILE__, __LINE__] call CORE_fnc_log;
		};
		
		hcHelper_hcCheckReturn = false;
		publicVariable "hcHelper_hcCheckReturn";
		
	} forEach (hcHelper_hcConnected select 1);
	
	uisleep hcHelper_hcCheckFreq;
	false;
};
