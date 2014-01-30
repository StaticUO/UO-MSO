/*
   Author:
    r�be
    
   Description:
    attaches the weather report interface to an object, preferably
    something like a journal or a map, such that one will be able
    to "look at" that object, while opening the weather report
    dialog on top of it.
    
   Parameter(s):
    _this: parameters (array of array [key (string), value (any)])
    
      - required:
        
        - "object" (object)
          The object to which the forecast report action get's attached
          to. If "online"/digital, this is usually a notebook, a tv or
          similar. If it shall represent a "journal" (analogue version),
          then map/journal-like objects such as "EvMap", "EvMoscow" et.
          al. will do.
          
        - "forecast" (array)
          The forecast report data generated by RUBE_weatherCreateForecast
          (in forecast-functions.sqf)
          
          While this data is fixed for the analogue version anyways, you
          have to keep it up-to-date for the digital version by youself 
          by overwriting the forecast data which (saved on the object):
          
            _obj setVariable ["RUBE_forecastData", _forecast, true];
            
          or directly manipulating that data.

      - optional:
      
        - "online" (boolean)
          Whether it shall be a digital/online or a analogue report. The
          digital version is bright on dark background, while the analogue
          version is black on "white".
          
          Default depends on the supplied object (see code below).
          
        - "title" (string)
          Title of the forecast reports action. Default depends on the
          version: short/without date for the digital one, and with a
          date (postfix) for the analogue version.
        
        - "limit" (integer)
          Number of days of forecast (not counting today). Defaults to
          maximum; either max. days that can be represented on the dialogue,
          which would be 6 or the given number of forecast days in the 
          supplied forecast data.
    
   Returns:
    void
*/

private ["_obj", "_forecast", "_isOnline", "_limit", "_title"];

_obj = objNull;
_forecast = [];
_isOnline = -1;
_limit = 6;
_title = "";

// read parameters
{
   switch (_x select 0) do
   {
      case "object": { _obj = _x select 1; };
      case "forecast": { _forecast = _x select 1; };
      case "online": { _isOnline = _x select 1; };
      case "limit": { _limit = _x select 1; };
      case "title": { _title = _x select 1; };
   };
} forEach _this;

// no object supplied
if (isNull _obj) exitWith {};

// invalid forecast data
if ((typeName _forecast) != "ARRAY") exitWith {};
if ((count _forecast) < 3) exitWith {};

// auto-version
if ((typeName _isOnline) != "BOOL") then
{
   if ((typeOf _obj) in ["Notebook", "SmallTV", "SatPhone"]) then
   {
      _isOnline = true;
   } else
   {
      _isOnline = false;
   };
};

// auto-title
if (_title == "") then
{
   _title = RUBE_STR_weatherReport;
   
   // "journals" come with a date (which is especially usefull if there
   // are a bunch of "journals" from different dates around...)
   if (!_isOnline) then
   {
      _title = format[
         "%1 %2-%3%-%4", 
         RUBE_STR_weatherReport,
         ([((_forecast select 0) select 0), 4, 0] call RUBE_pad),
         ([((_forecast select 0) select 1), 2, 0] call RUBE_pad),
         ([((_forecast select 0) select 2), 2, 0] call RUBE_pad)
      ];
   };
};


_actionId = [
   ["object", _obj],
   ["title", _title], 
   ["hideOnUse", true],
   ["callback", {
      _this execVM "modules\common\RUBE\modules\weather\dialogs\dlg_weatherReport.sqf";
      true
   }],
   ["condition", "true"]
] call RUBE_addAction;

_obj setVariable ["RUBE_actionId", _actionId, true];
_obj setVariable ["RUBE_forecastData", _forecast, true];
_obj setVariable ["RUBE_forecastIsOnline", _isOnline, true];
_obj setVariable ["RUBE_forecastDays", _limit, true];