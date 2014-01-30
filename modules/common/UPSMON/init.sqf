
// Load Settings
#include "settings.sqf"

// Load Functions
private ["_functions"];
_functions = [
	["upsmon_addArtillery", "modules\common\UPSMON\functions\fnc_addArtillery.sqf"],
	["upsmon_serverInit", "modules\common\UPSMON\functions\fnc_serverInit.sqf", false, true, [], CORE_LMS_server],
	["upsmon_spawnGroup", "modules\common\UPSMON\functions\fnc_spawnGroup.sqf"]
];

/*****************************/
/* Initialization Code Below */
/*        NO WAITING!        */
/*****************************/

"KRON_UPS_EAST_SURRENDED" addPublicVariableEventHandler { if (_this select 1) then { nul=[east] execvm "scripts\UPSMON\MON_surrended.sqf";};};
"KRON_UPS_WEST_SURRENDED" addPublicVariableEventHandler { if (_this select 1) then { nul=[west] execvm "scripts\UPSMON\MON_surrended.sqf";};};
"KRON_UPS_GUER_SURRENDED" addPublicVariableEventHandler { if (_this select 1) then { nul=[resistance] execvm "scripts\UPSMON\MON_surrended.sqf";};};
"MON_LOCAL_EXEC" addPublicVariableEventHandler {
	if (local ((_this select 1) select 0)) then {
		call (compile format[((_this select 1) select 1), ((_this select 1) select 0)]);
	};
};

R_GOTHIT_ARRAY =[0];
AcePresent = isClass(configFile/"CfgPatches"/"ace_main");
UPSMON_Version = "UPSMON 5.1.0 beta1";
KILLED_CIV_COUNTER = [0,0,0,0,0];
KRON_UPS_flankAngle = 45; //Angulo de flanqueo
KRON_UPS_INIT = 0;        //Variable que indica que ha sido inicializado
KRON_UPS_EAST_SURRENDED = false;
KRON_UPS_WEST_SURRENDED = false;
KRON_UPS_GUER_SURRENDED = false;
KRON_AllWest=[];	//All west AI 
KRON_AllEast=[];	//All east AI 
KRON_AllRes=[];		//All resistance AI 
KRON_UPS_East_enemies = [];
KRON_UPS_West_enemies = [];
KRON_UPS_Guer_enemies = [];
KRON_UPS_East_friends = [];
KRON_UPS_West_friends = [];
KRON_UPS_Guer_friends = [];
KRON_targets0 =[];//objetivos west
KRON_targets1 =[];//objetivos east
KRON_targets2 =[];//resistence	
KRON_targetsPos =[];//Posiciones de destino actuales.
KRON_NPCs = []; //Lideres de los grupos actuales	
KRON_UPS_Instances=0;
KRON_UPS_Total=0;
KRON_UPS_Exited=0;
KRON_UPS_East_Total = 0;
KRON_UPS_West_Total = 0;
KRON_UPS_Guer_Total = 0;	
KRON_UPS_ARTILLERY_UNITS = [];
KRON_UPS_ARTILLERY_WEST_TARGET = objnull;
KRON_UPS_ARTILLERY_EAST_TARGET = objnull;
KRON_UPS_ARTILLERY_GUER_TARGET = objnull;
KRON_UPS_TEMPLATES = [];
KRON_UPS_MG_WEAPONS = ["MG36","M249","M240","MK_48","PK","PKm","Pecheneg","M249 Para","M249 Para M145","M240G M145","M60"];

if (_markerAlpha) then {
	{_x setmarkeralpha 0} foreach ["area0", "area1", "area2","area3","area4","area5","area6","area7","area8","area9","area10","area11","area12","area13"];
};

/*****************************/
/*  End Initialization Code  */
/*****************************/

_functions
