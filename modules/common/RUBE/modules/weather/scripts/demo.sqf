/*
   Author:
    rübe
    
   Description:
    RUBE weather module demo mission. Place down a player (and maybe some company)
    onto a map of your choice and execute this script.
    
   Parameter(s):
    _this select 0: season model (string, optional)
*/
finishMissionInit;

_seasonModel = "";
_daysOfForecast = 6;
_historySize = 3; // number (+1) of old journals/forecast reports, we'll keep

// read parameters
if ((typeName _this) == "ARRAY") then
{
   if ((count _this) > 0) then
   {
      _seasonModel = _this select 0;
   };
};



// make sure the RUBE function library is loaded
if (isnil "RUBE_fnc_init") then
{
   [] call (compile preprocessFileLineNumbers "modules\common\RUBE\init.sqf");
};
waitUntil{!(isnil "RUBE_fnc_init")};


/*
   setup scene: a camo-net with two tables; one with a laptop and one
   with a map-object representing a journal or somthing.
   
   The laptop will run the "digital" version of the forecast-report, the
   journal the "analogue" one.
*/
_pos = player modelToWorld [2.5, 4, 0];
_pos set [2, 0];

theWeatherReports = [];
theNotebook = objNull;
theJournals = [];

createForecastReport = {
   private ["_i", "_j", "_historySize", "_id"];
   
   _historySize = (count theJournals) - 1;
      
   // shift reports, trash last
   for "_i" from 0 to (_historySize - 1) do
   {
      _j = _historySize - _i;
      
      theWeatherReports set [
         _j,
         (theWeatherReports select (_j - 1))
      ];
   };
   
   // calculate latest forecast
   theWeatherReports set [
      0,
      ([
         (RUBE_weather getVariable "date"),
         (RUBE_weather getVariable "forecast")
      ] call RUBE_weatherCreateForecast)
   ];
   
   // refresh pointers to forecast data
   theNotebook setVariable ["RUBE_forecastData", (theWeatherReports select 0), true];
   
   for "_i" from 0 to _historySize do
   {
      _id = (theJournals select _i) getVariable "RUBE_actionId";
      
      if (!isnil "_id") then
      {
         if ((typeName _id) == "SCALAR") then
         {
            [
               (theJournals select _i),
               _id
            ] call RUBE_removeAction;
            
            (theJournals select _i) setVariable ["RUBE_actionId", nil];
         };
      };
      
      if ((count (theWeatherReports select _i)) > 0) then
      {
         [
            ["object", (theJournals select _i)],
            ["forecast", (theWeatherReports select _i)],
            ["online", false]
         ] execVM "modules\common\RUBE\modules\weather\dialogs\fn_weatherReport.sqf";
      };
   };
};

_maps = [];
for "_i" from 0 to _historySize do
{
   _maps set [_i, (["EvMap", "EvMap", "EvPhoto", "EvMoscow"] call RUBE_randomSelect)];
   theWeatherReports set [_i, []];
};

// 0: table, 1: chair, 2: map
_itemSetA = [
   ["position", _pos],
   ["direction", ((direction player) + 185)],
   ["table", "FoldTable"],
   ["chair", "FoldChair"],
   ["items", _maps]
] call RUBE_spawnTable;

_pos = player modelToWorld [-0.5, 4, 0];
_pos set [2, 0];

// 0: table, 1: chair, 2: notebook, 3: radio
_itemSetB = [
   ["position", _pos],
   ["direction", ((direction player) + 175)],
   ["table", "FoldTable"],
   ["chair", "FoldChair"],
   ["items", ["Notebook", "Radio"]],
   ["zerror", 0.2],
   ["enableSimulation", false]
] call RUBE_spawnTable;


theNotebook = (_itemSetB select 2);
theRadio = (_itemSetB select 3);
for "_i" from 2 to ((count _itemSetA) - 1) do
{
   _obj = _itemSetA select _i;
   theJournals set [
      (count theJournals),
      _obj
   ];
};


_pos = player modelToWorld [1.75, 1.6, 0];
_pos set [2, 0];

_camoNet = createVehicle ["Land_CamoNet_NATO", _pos, [], 0, "NONE"];
_camoNet setDir (direction player);
_camoNet setPos _pos;

_pos = player modelToWorld [13.7, -2.5, 0];
_pos set [2, 0];

_campfire = createVehicle ["Land_Campfire_burning", _pos, [], 0, "NONE"];





/*
   init weather module
*/

_engineAlreadyLoaded = false;

if (!isnil "RUBE_weather_loading") then
{
   waitUntil{!isnil "RUBE_weather"};
   _engineAlreadyLoaded = true;
} else
{
   RUBE_weather_loading = true;

   [] execVM "modules\common\RUBE\modules\weather\init.sqf";
   waitUntil{!(isnil "RUBE_weather")};
};


// debug 
//RUBE_weather setVariable ["debug-generator", false, true];
//RUBE_weather setVariable ["debug-engine", false, true];

// select season model
if (_seasonModel != "") then
{
   _seasonModel call (RUBE_weather getVariable "set-season-model");
};

// set forecast size (not counting the previous and the current day)
RUBE_weather setVariable ["forecast-days", _daysOfForecast, true];

// disable auto-advance forecast (we will advance the forecast manually)
RUBE_weather setVariable ["enable-auto-advance-forecast", false, true];

// init some weather
if (!_engineAlreadyLoaded) then
{
   [] call (RUBE_weather getVariable "generate-weather");
} else
{
   //waitUntil{((count (RUBE_weather getVariable "forecast")) > 0)};
   waitUntil{!isnil "RUBE_weatherEngine"};
};

[] call createForecastReport;

// advance one day per journal/historySize (so the're not empty to begin with...)
for "_i" from 1 to _historySize do
{
   skipTime 24;
   RUBE_weather setVariable ["date", date, true];
   [] call (RUBE_weather getVariable "generate-next-day");
   [] call createForecastReport;
};




/*
   attach forecast-report to notebook
*/
[
   ["object", theNotebook],
   ["forecast", (theWeatherReports select 0)],
   ["online", true]
] execVM "modules\common\RUBE\modules\weather\dialogs\fn_weatherReport.sqf";

{
   player reveal [_x, 4.0];
} forEach _itemSetA;

{
   player reveal [_x, 4.0];
} forEach _itemSetB;





/*
   skip time functions attached to the radio
*/
SKIP_TIME = {
   private ["_day", "_s"];
   
   _day = date select 2;
   skipTime _this;
   
   _s = format["%1 hours skipped...\ncurrent time: %2", _this, daytime];
   
   if (_day != (date select 2)) then
   {
      _s = _s + format["\n\n - a new day has been (auto-)generated"];
      
      // manually advance forecast/weather data
      RUBE_weather setVariable ["date", date, true];
      [] call (RUBE_weather getVariable "generate-next-day");
      
      // create new forecast report
      [] call createForecastReport;
   };
   
   _s = _s + format["\n - resetting weather engine now"];
   hint _s;
   
   [] call (RUBE_weather getVariable "reset-weather-engine");
};

{
   _actionId = [
      ["object", (_itemSetB select 3)],
      ["title", (_x select 1)],
      ["hideOnUse", true],
      ["callback", {
         (_this select 3) spawn SKIP_TIME;
         true
      }],
      ["arguments", (_x select 0)],
      ["condition", "true"]
   ] call RUBE_addAction;
   
} forEach [
   [1/6, "skip 10 min"],
   [0.5, "skip 30 min"],
   [  1, "skip 1 h"],
   [  6, "skip 6 h"],
   [ 12, "skip 12 h"],
   [ 24, "skip 24 h"]
];



/*
   show inside the weather engine
*/

PRINT_WEATHER_ENGINE = {
   private ["_lines", "_s", "_w1", "_w2", "_p", "_pc1", "_pc2",
            "_wind", "_speed", "_dir", "_date",
            "_center", "_height", "_temp", 
            "_ocOSC", "_ocReal",
            "_precOSC", "_precReal", "_precRealR", "_snow", "_rain", "_fogOSC", "_fog",
            "_paLoc", "_paEnv", "_paCI", "_paCII", "_paSys", "_paSysL", "_paOffset"];
            
   // width
   _w2 = 11;
   _w1 = _w2 * 2;
   
   // pad filler
   _p = " ";
   
   // fill prefix?
   _pc1 = false;
   _pc2 = false;
   
   _date = date;
   
   _lines = [
      "RUBE weather engine",
      format[
         "%1-%2-%3, %4", 
         (_date select 0),
         ([(_date select 1), 2, "0", true] call RUBE_pad),
         ([(_date select 2), 2, "0", true] call RUBE_pad),
         daytime
      ],
      "",
      "ArmA Engine Data:",
      ""
   ];
   
   _wind = wind;
   _speed = sqrt((_wind select 0)^2 + (_wind select 1)^2 + (_wind select 2)^2) * 3.6;
   _dir = ((_wind select 0) atan2 (_wind select 1)) call RUBE_normalizeDirection;
   
   _lines set [(count _lines), format[
      "%1%2", 
      (["overcast:", _w1, _p, _pc1] call RUBE_pad),
      ([([overcast, 0.01] call RUBE_roundTo), _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   _lines set [(count _lines), format[
      "%1%2", 
      (["rain:", _w1, _p, _pc1] call RUBE_pad),
      ([([rain, 0.01] call RUBE_roundTo), _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   _lines set [(count _lines), format[
      "%1%2", 
      (["fog:", _w1, _p, _pc1] call RUBE_pad),
      ([([fog, 0.01] call RUBE_roundTo), _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   _lines set [(count _lines), format[
      "%1%2", 
      (["wind speed:", _w1, _p, _pc1] call RUBE_pad),
      ([format["%1 km/h", ([_speed, 0.01] call RUBE_roundTo)], _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   _lines set [(count _lines), format[
      "%1%2", 
      (["wind dir:", _w1, _p, _pc1] call RUBE_pad),
      ([format["%1'", ([_dir, 0.1] call RUBE_roundTo)], _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   _lines set [(count _lines), ""];
   _lines set [(count _lines), format["Weather Engine Data:"]];
   _lines set [(count _lines), ""];
   
   
   _center = (RUBE_weatherEngine getFSMVariable "_weatherObject");
   _height = (getPosASL _center) select 2;
   _temp = (RUBE_weatherEngine getFSMVariable "_temperature");
   
   _lines set [(count _lines), format[
      "%1%2", 
      (["center:", _w1, _p, _pc1] call RUBE_pad),
      ([format["%1 (%2)", _center, (typeOf _center)], _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   _lines set [(count _lines), format[
      "%1%2", 
      (["height:", _w1, _p, _pc1] call RUBE_pad),
      ([format["%1m", ([_height, 0.01] call RUBE_roundTo)], _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   _lines set [(count _lines), format[
      "%1%2", 
      (["temperature:", _w1, _p, _pc1] call RUBE_pad),
      ([format["%1'C", ([_temp, 0.01] call RUBE_roundTo)], _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   _lines set [(count _lines), ""];
   
   _ocOSC = (RUBE_weatherEngine getFSMVariable "_overcast") select 0;
   _ocReal = (RUBE_weatherEngine getFSMVariable "_overcastReal");
   _precOSC = (RUBE_weatherEngine getFSMVariable "_precipitation") select 0;
   _precReal = (RUBE_weatherEngine getFSMVariable "_precipitationReal");
   _precRealR = ([_precReal, 0.01] call RUBE_roundTo);
   _snow = (RUBE_weatherEngine getFSMVariable "_snowReal");
   _rain = (RUBE_weatherEngine getFSMVariable "_rainReal");
   
   _fogOSC = (RUBE_weatherEngine getFSMVariable "_fog") select 0;
   _fog = (RUBE_weatherEngine getFSMVariable "_fogReal");
   
   _lines set [(count _lines), format[
      "%1%2%3", 
      (["overcast:", _w2, _p, _pc1] call RUBE_pad),
      
      ([format["%1 (OSC)", ([_ocOSC, 0.01] call RUBE_roundTo)], _w2, _p, _pc2] call RUBE_pad),
      ([format["%1 (MSK)", ([_ocReal, 0.01] call RUBE_roundTo)], _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   _lines set [(count _lines), format[
      "%1%2%3", 
      (["prec.:", _w2, _p, _pc1] call RUBE_pad),
      
      ([format["%1 (OSC)", ([_precOSC, 0.01] call RUBE_roundTo)], _w2, _p, _pc2] call RUBE_pad),
      ([format["%1 (MSK)", _precRealR], _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   _lines set [(count _lines), format[
      "%1%2", 
      (["rain:", _w1, _p, _pc1] call RUBE_pad),
      ([format["%1/%2", ([_rain, 0.01] call RUBE_roundTo), _precRealR], _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   _lines set [(count _lines), format[
      "%1%2", 
      (["snow:", _w1, _p, _pc1] call RUBE_pad),
      ([format["%1/%2", ([_snow, 0.01] call RUBE_roundTo), _precRealR], _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   _speed = (RUBE_weatherEngine getFSMVariable "_windSpeedRealUC") * 3.6;
   
   _lines set [(count _lines), format[
      "%1%2", 
      (["wind speed:", _w1, _p, _pc1] call RUBE_pad),
      ([format["%1 km/h", ([_speed, 0.01] call RUBE_roundTo)], _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   /*
   _lines set [(count _lines), format[
      "%1%2", 
      (["fog intensity:", _w1, _p, _pc1] call RUBE_pad),
      ([format["%2 (%1 OSC)", 
         ([_fogOSC, 0.01] call RUBE_roundTo),
         ([(_fog select 0), 0.01] call RUBE_roundTo)
      ], _w2, _p, _pc2] call RUBE_pad)
   ]];
   */
   _lines set [(count _lines), format[
      "%1%2%3", 
      (["fog int.:", _w2, _p, _pc1] call RUBE_pad),
      
      ([format["%1 (OSC)", ([_fogOSC, 0.01] call RUBE_roundTo)], _w2, _p, _pc2] call RUBE_pad),
      ([format["%1 (MSK)", ([(_fog select 0), 0.01] call RUBE_roundTo)], _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   
   
   _lines set [(count _lines), format[
      "%1%2", 
      (["fog (rad/particles):", _w1, _p, _pc1] call RUBE_pad),
      ([format["%1", ([(_fog select 1), 0.01] call RUBE_roundTo)], _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   _paLoc = ((RUBE_weatherEngine getFSMVariable "_pressureLocalOSC") select 0);
   _paEnv = ((RUBE_weatherEngine getFSMVariable "_pressureEnvOSC") select 0);
   _paCI = _paLoc call RUBE_atmosphericPressureCoeff;
   _paCII = [_paLoc, _paEnv] call RUBE_atmosphericPressureCoeffII;
   _paSys = [_paCI, _paCII] call RUBE_atmosphericPressureSystem;
   _paSysL = "";
   _paOffset = (RUBE_weatherEngine getFSMVariable "_pressureLocalOffset");
   
   switch (_paSys) do
   {
      case 0: { _paSysL = "LOW+ (L|L)"; };
      case 1: { _paSysL = "LOW (L|S)"; };
      case 2: { _paSysL = "LOW- (L|H)"; };
      case 3: { _paSysL = "STABLE (S|L)"; };
      case 4: { _paSysL = "STABLE+ (S|S)"; };
      case 5: { _paSysL = "STABLE (S|H)"; };
      case 6: { _paSysL = "HIGH- (H|L)"; };
      case 7: { _paSysL = "HIGH (H|S)"; };
      case 8: { _paSysL = "HIGH+ (H|H)"; };
   };
      
   _lines set [(count _lines), format[
      "%1%2", 
      (["pressure (local):", _w1, _p, _pc1] call RUBE_pad),
      ([format["%1 Pa", _paLoc], _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   _lines set [(count _lines), format[
      "%1%2", 
      (["pressure (env.):", _w1, _p, _pc1] call RUBE_pad),
      ([format["%1 Pa", _paEnv], _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   _lines set [(count _lines), format[
      "%1%2", 
      (["pr. dist.mask offset:", _w1, _p, _pc1] call RUBE_pad),
      ([format["%1 Pa", ([_paOffset, 0.1] call RUBE_roundTo)], _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   _lines set [(count _lines), format[
      "%1%2", 
      (["pr. sys.:", _w2, _p, _pc1] call RUBE_pad),
      ([_paSysL, _w1, _p, _pc2] call RUBE_pad)
   ]];
   
   _lines set [(count _lines), format[
      "%1%2", 
      (["pressure coeff.I:", _w1, _p, _pc1] call RUBE_pad),
      ([format["%1", ([_paCI, 0.001] call RUBE_roundTo)], _w2, _p, _pc2] call RUBE_pad)
   ]];
   _lines set [(count _lines), format[
      "%1%2", 
      (["pressure coeff.II:", _w1, _p, _pc1] call RUBE_pad),
      ([format["%1", ([_paCII, 0.001] call RUBE_roundTo)], _w2, _p, _pc2] call RUBE_pad)
   ]];
   
   _s = "";
   {
      _s = _s + format["<t font='Bitstream' size='0.78' align='left'>%1</t><br />", _x];
   } forEach _lines;
   
   hintSilent (parseText _s);
};


// enable radio commands
enableRadio true;

AUTO_REFRESH_LOOP = {
   while {AUTO_REFRESH_INFO} do
   {
      [] spawn PRINT_WEATHER_ENGINE;
      sleep 2;
   };
};
AUTO_REFRESH_INFO = false;
TOGGLE_REFRESH_INFO = {
   AUTO_REFRESH_INFO = !AUTO_REFRESH_INFO;
   
   if (AUTO_REFRESH_INFO) then
   {
      [] spawn AUTO_REFRESH_LOOP;
   };
};

TOGGLE_COLOR_FILTER = {
   RUBE_weather setVariable ["enable-color-filter", !(RUBE_weather getVariable "enable-color-filter"), true];
   [] call (RUBE_weather getVariable "reset-weather-engine");
   
   PAUSE_PROBES = 3;
   hint format["color filter enabled: %1\n(this may take a few moments...)", (RUBE_weather getVariable "enable-color-filter")];
};

HARD_RESET_ENGINE = {
   [] call (RUBE_weather getVariable "hard-reset-weather-engine");
   hint format["weather engine has been hard resetted."];
};

{
   _t = createTrigger["EmptyDetector", position player];
   _t setTriggerActivation[(_x select 0), "PRESENT", true];
   _t setTriggerText (_x select 1);
   _t setTriggerStatements["true", (_x select 2), ""];
} forEach [
   ["ALPHA", "weather engine info", "[] spawn PRINT_WEATHER_ENGINE;"],
   ["BRAVO", "toggle w.e. info auto refresh", "[] spawn TOGGLE_REFRESH_INFO;"],
   ["CHARLIE", "toggle color filter", "[] spawn TOGGLE_COLOR_FILTER;"],
   ["DELTA", "hard reset weather engine", "[] spawn HARD_RESET_ENGINE;"],
   ["JULIET", "teleport", "[] spawn { player onMapSingleClick { _this setPos _pos; true }; };"]
];



/*
   and finally...
   launch the weather engine
*/

// ready? set, go!
if (_engineAlreadyLoaded) then
{
   waitUntil{(!isnil "RUBE_weatherEngine")};
   [] call (RUBE_weather getVariable "hard-reset-weather-engine");
} else
{
   [] call (RUBE_weather getVariable "start-weather-engine");
};



[] spawn {
   _s = format["RUBE weather module\ndemo mission\n\n"];
   _s = _s + format["1) Please note the stuff on the tables in front of you. Actions are attached to them.\n\n"];
   _s = _s + format["2) You may teleport, toggle on/off the color filter and stuff with radio calls. So check the menu\n\n"];
   _s = _s + format["3) In case you don't understand what the hell is going on here... read the code.\n   BWAHAHAHA.\n\n"];
   _s = _s + format["Ready? Go!"];

   hintSilent _s;
   
   sleep 5;
   
   [] spawn TOGGLE_REFRESH_INFO;
};