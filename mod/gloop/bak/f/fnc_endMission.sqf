
private ["_call", "_params", "_endTitle", "_endDesc", "_controls"];

if (typeName(_this) != typeName([])) then {_this = [_this]};

_call		= if ((count _this) > 0) then {_this select 0} else {"null"};
_params		= if ((count _this) > 1) then {_this select 1} else {[]};
_endTitle	= "NIL";
_endDesc	= "NIL";

if (!isDedicated) then {
	gameLoop_endMissionParams = _this;
	
	switch (_call) do {
		
		case 'objective': {
			_endTitle	= _params select 0;
			_endDesc	= _params select 1;
		};
		
		case 'infLoss': {
			private ["_side", "_startCount", "_deadCount", "_lossPerc", "_sideName"];
			_side		= _params select 0;
			_startCount	= _params select 1;
			_deadCount	= _params select 2;
			_lossPerc	= round((_deadCount / _startCount) * 100);
			_sideName	= [_side] call CORE_fnc_sideToText;
			_endTitle	= format["%1 has Lost", _sideName];
			_endDesc	= format["%1 has taken too many casualties. They have lost %2 percent of their starting force.", _sideName, _lossPerc];
		};
		
		default {
			private ["_endTime"];
			_endTime	= if ((count _params) > 1) then {_params select 0} else {time};
			_endTitle	= "Draw";
			_endDesc	= format["The time limit of %1 minutes has been reached.", round(_endTime / 60)];
		};
		
	};
	
	private ["_totalTime", "_gameTime", "_briefTime"];
	_totalTime		= serverTime - (['gameLoop_startTime'] call CORE_fnc_getVariable);
	_gameTime		= time;
	_briefTime		= _totalTime - _gameTime;

	createDialog "cm_missionEndScreen";

	_controls = [
		[1001, _endTitle],
		[1100, _endDesc],
		[1021, str(['gameLoop_west_infLoss'] call CORE_fnc_getVariable)],
		[1022, str(['gameLoop_east_infLoss'] call CORE_fnc_getVariable)],
		[1023, str(['gameLoop_resistance_infLoss'] call CORE_fnc_getVariable)],
		[1024, str(['gameLoop_civilian_infLoss'] call CORE_fnc_getVariable)],
		[1041, str(round(_briefTime / 60)) + " Minutes"],
		[1042, str(round(_gameTime / 60)) + " Minutes"],
		[1043, str(round(_totalTime / 60)) + " Minutes"],
		[1044, str(score player)]
	];
	
	{
		ctrlSetText _x;
	} forEach _controls;
};

if (isServer) then {
	[] spawn {
		uiSleep (['gameLoop_endScreenTimeOut'] call CORE_fnc_getVariable);
		[-2, {endMission "END1"; forceEnd;}] call CBA_fnc_globalExecute;
	};
};