/*
   RUBE weather report dialog
*/
#include "core.hpp"
#include "x-weatherReportIDC.hpp"
disableSerialization;

_obj = _this select 0;
_unit = _this select 1;
_forecastData = _obj getVariable "RUBE_forecastData";
_forecastIsOnline = _obj getVariable "RUBE_forecastIsOnline";
_forecastDays = _obj getVariable "RUBE_forecastDays";

_maxForecastDays = 6; // maximum number of days of forecast

// verify forecast days
_dataError = "dlg_weatherReport.sqf: invalid forecast report data";

if ((count _forecastData) < 2) exitWith { diag_log _dataError; };
if ((typeName (_forecastData select 2)) != "ARRAY") exitWith { diag_log _dataError; };
if ((count (_forecastData select 2)) < 1) exitWith { diag_log _dataError; };

_forecastSize = (count (_forecastData select 2)) - 1;
_forecastDays = _forecastSize min (_forecastDays max _maxForecastDays);




/*
   open forecast report,
   animation onto forecast report object
*/

// whether we look at the objects side or from above down onto it
_objMatrix = [];
_pos = [];

if ((typeOf _obj) in ["Notebook", "SmallTV", "SatPhone"]) then
{
   _objMatrix = [0, 0.175, -0.01];
   _pos = _unit modelToWorld[0, 0.45, 1.65];
} else
{
   _objMatrix = [0, -0.05, 0.2];
   _pos = _unit modelToWorld[0, 0.15, 1.75];
};

_cam = "camera" camCreate _pos;
_cam camSetTarget _obj;
_cam cameraEffect ["internal", "BACK"];
_cam camCommit 0;

_pos = _obj modelToWorld _objMatrix;

_cam camSetPos _pos;
_cam camCommit (0.4 + (random 0.4));

waitUntil {camCommitted _cam};






/*
   open and init forecast report dialog
*/

// open dialog
_dialog = createDialog "RUBE_WeatherReportDialog"; 

/******************************************************************/

// get dialog/idd
_idd = uiNamespace getVariable "RUBE_weatherReport";


if (_forecastIsOnline) then
{
   (_idd displayCtrl RUBE_IDC_WEATHERREPORT_bgPanel) ctrlSetBackgroundColor [0, 0, 0, 0];
};


/*
   TODO: adjust/set altitude - "callibrate barometer" if we're using the
         online version;
         Though the "print" version could maybe also need such a calibration
         ... set to the height of the capitol maybe.
*/

_date = _forecastData select 0;
_todayExt = _forecastData select 1;
_today = (_forecastData select 2) select 0;

// weather report: title
ctrlSetText [
   RUBE_IDC_WEATHERREPORT_reportT, 
   format[
      "%1: %2, %3-%4-%5", 
      RUBE_STR_weatherReport,
      (RUBE_STRSET_weekdays select (_today select 0)),
      ([(_date select 0), 4, 0] call RUBE_pad),
      ([(_date select 1), 2, 0] call RUBE_pad),
      ([(_date select 2), 2, 0] call RUBE_pad)
   ]
];

// weather report: temperature, low
ctrlSetText [RUBE_IDC_WEATHERREPORT_tlTitle, RUBE_STR_temperatureLow];
ctrlSetText [RUBE_IDC_WEATHERREPORT_tlText, format["%1' C", (_today select 1)]];

// weather report: temperature, hi
ctrlSetText [RUBE_IDC_WEATHERREPORT_thTitle, RUBE_STR_temperatureHigh];
ctrlSetText [RUBE_IDC_WEATHERREPORT_thText, format["%1' C", (_today select 2)]];

// weather report: wind speed
ctrlSetText [RUBE_IDC_WEATHERREPORT_wsTitle, RUBE_STR_windSpeed];
ctrlSetText [RUBE_IDC_WEATHERREPORT_wsText, format["%1 km/h", (_todayExt select 0)]];
ctrlSetText [RUBE_IDC_WEATHERREPORT_wsIcon, format["modules\common\RUBE\modules\weather\icons\%1.paa", (_todayExt select 1)]];

// weather report: wind direction
ctrlSetText [RUBE_IDC_WEATHERREPORT_wdTitle, RUBE_STR_windDirection];
ctrlSetText [RUBE_IDC_WEATHERREPORT_wdText, format["%1", (_todayExt select 3)]];
ctrlSetText [RUBE_IDC_WEATHERREPORT_wdIcon, format["modules\common\RUBE\modules\weather\icons\%1.paa", (_todayExt select 4)]];

// weather report: temperature, sunrise
ctrlSetText [RUBE_IDC_WEATHERREPORT_srTitle, RUBE_STR_sunrise];
ctrlSetText [RUBE_IDC_WEATHERREPORT_srText, (_todayExt select 5)];

// weather report: temperature, sunset
ctrlSetText [RUBE_IDC_WEATHERREPORT_ssTitle, RUBE_STR_sunset];
ctrlSetText [RUBE_IDC_WEATHERREPORT_ssText, (_todayExt select 6)];


if (_forecastSize > 0) then
{
   // forecast (sub-)title
   ctrlSetText [RUBE_IDC_WEATHERREPORT_forecastT, RUBE_STR_forecast];
};

if (_forecastIsOnline) then
{
   {
      (_idd displayCtrl _x) ctrlSetTextColor [1, 1, 1, 1];
   } forEach [
      RUBE_IDC_WEATHERREPORT_reportT,
      RUBE_IDC_WEATHERREPORT_tlTitle,
      RUBE_IDC_WEATHERREPORT_tlText,
      RUBE_IDC_WEATHERREPORT_thTitle,
      RUBE_IDC_WEATHERREPORT_thText,
      RUBE_IDC_WEATHERREPORT_wsTitle,
      RUBE_IDC_WEATHERREPORT_wsText,
      RUBE_IDC_WEATHERREPORT_wdTitle,
      RUBE_IDC_WEATHERREPORT_wdText,
      RUBE_IDC_WEATHERREPORT_srTitle,
      RUBE_IDC_WEATHERREPORT_srText,
      RUBE_IDC_WEATHERREPORT_ssTitle,
      RUBE_IDC_WEATHERREPORT_ssText,
      RUBE_IDC_WEATHERREPORT_forecastT
   ];
};


// freaky iteration over ALL the idc's.
_idcStart = RUBE_IDC_WEATHERREPORT_S1L0;
_idcOffset = 10;

for "_i" from 0 to _forecastSize do
{
   _offset = _i * _idcOffset;
   
   // symbol layers
   _idc0 = _idcStart + _offset;
   _idc1 = _idcStart + _offset + 1;
   _idc2 = _idcStart + _offset + 2;
   _idc3 = _idcStart + _offset + 3;
   
   // title and label (only for forecast; not todays weather)
   _idc4 = _idcStart + _offset + 4;
   _idc5 = _idcStart + _offset + 5;
   
   _data = (_forecastData select 2) select _i;
   _symbols = _data select 3;
   
   // set layers of the weather symbol
   ctrlSetText [_idc0, format["modules\common\RUBE\modules\weather\icons\%1.paa", (_symbols select 0)]];
   ctrlSetText [_idc1, format["modules\common\RUBE\modules\weather\icons\%1.paa", (_symbols select 1)]];
   ctrlSetText [_idc2, format["modules\common\RUBE\modules\weather\icons\%1.paa", (_symbols select 2)]];
   ctrlSetText [_idc3, format["modules\common\RUBE\modules\weather\icons\%1.paa", (_symbols select 3)]];
   
   // set forecast labels
   if (_i > 0) then
   {         
      // title
      ctrlSetText[_idc4, (RUBE_STRSET_weekdays select (_data select 0))];
      
      // label
      ctrlSetText[_idc5, format["%1'C / %2'C", (_data select 1), (_data select 2)]]; 
      
      if (_forecastIsOnline) then
      {
         (_idd displayCtrl _idc4) ctrlSetTextColor [1, 1, 1, 1];
         (_idd displayCtrl _idc5) ctrlSetTextColor [1, 1, 1, 1];
      };
   };
};





waitUntil { !dialog };

// destroy cam and quit
_unit cameraEffect ["terminate", "BACK"];
camDestroy _cam;