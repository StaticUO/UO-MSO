/*
   RUBE inspect/open supplies dialog
*/
#include "core.hpp"
#include "x-supplyScreenIDC.hpp"
disableSerialization;

_obj = _this select 0;
_unit = _this select 1;
_height = 1.75;

_pos = position _unit;
_pos set [2, _height];

_cam = "camera" camCreate _pos;
_cam camSetTarget _obj;
_cam cameraEffect ["internal", "BACK"];
_cam camCommit 0;

//_pos = position _obj;
_pos = [
	(position _unit), 
	((_unit distance _obj) * 0.85), 
	([_unit, _obj] call BIS_fnc_dirTo)
] call BIS_fnc_relPos;

_pos set [2, _height];

_cam camSetPos _pos;
_cam camCommit (1.2 + (random 0.8));

waitUntil {camCommitted _cam};

// open dialog
_dialog = createDialog "RUBE_SupplyScreen"; 

ctrlSetText [RUBE_IDC_SUPPLYSCREEN_close, format["< %1 >", RUBE_STR_dialogClose]];

_p1 = (findDisplay RUBE_IDC_SUPPLYSCREEN_dialog) displayCtrl RUBE_IDC_SUPPLYSCREEN_p1;
_p2 = (findDisplay RUBE_IDC_SUPPLYSCREEN_dialog) displayCtrl RUBE_IDC_SUPPLYSCREEN_p2;

// small info line
_p1 ctrlSetStructuredText parseText format[
	"<t size='1.0'>%1 %2<br />%3: %4%5</t>",
	_obj,
	(typeOf _obj),
	RUBE_STR_capacity,
	(_obj getVariable "RUBE_capacity"),
	RUBE_suppliesUnit
];

// big supplies line
_p2 ctrlSetStructuredText parseText format[
	"<t size='3.16' align='center'>%1: %2%3</t>",
	RUBE_STR_supplies,
	(_obj getVariable "RUBE_supplies"),
	RUBE_suppliesUnit
];

waitUntil { !dialog };

// destroy cam and quit
_unit cameraEffect ["terminate", "BACK"];
camDestroy _cam;