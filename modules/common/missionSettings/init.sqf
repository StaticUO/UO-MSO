
// Load Settings
#include "settings.sqf"

// Load Functions
private ["_functions"];
_functions = [];

/*****************************/
/* Initialization Code Below */
/*        NO WAITING!        */
/*****************************/

/* Servers */
if ([CORE_machine, CORE_LMS_aiHost] call CORE_fnc_isMachine) then {
	setViewDistance _serverVD;
	setTerrainGrid	_serverTG;
};

/* Players */
if ([CORE_machine, CORE_LMS_player] call CORE_fnc_isMachine) then {
	setViewDistance _clientVD;
	setTerrainGrid	_clientTG;
	missionNamespace setVariable ["ace_viewdistance_limit", _ace_settings_max_vd];
	player setVariable ["BIS_noCoreConversations", _clientDisableGreetingMenu];
	0 fadeRadio _clientRadioVolume;
	if (_playerSafetyWeapon) then {
		[] spawn {
			waitUntil {CORE_init};
			sleep 0.1;
			player playMove "aidlpknlmstpslowwrfldnon_idlesteady02";
			sleep 1;
			player addWeapon "ACE_Safe";
			sleep 1;
			player selectWeapon "ACE_Safe";
		};
	};
};

/*****************************/
/*  End Initialization Code  */
/*****************************/
