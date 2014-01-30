/*
   Author:
    rübe
    
   Description:
    searches a good spot for a small camp (near world objects such as
    trees or rocks to spawn small tents nearby) 
    
   Parameter(s):
    _this: parameters (array of array [key (string), value (any)])
    
           - required:
           
             - "position" (position)
             - "size" (integer)
               - number of objects (trees, rocks, ...) in camp range
             
           - optional:
           
             - "range" (scalar or [min (scalar), max (scalar)])
             
             - "sector" (array of [minAngle (scalar), maxAngle (scalar)])
               - default: [0, 360]
           
             - "areas" (integer)
               - amount of flatEmpty areas in camp range
             - "areaRadius" (scalar)
               - radius of these areas
             
             - "gradient" (scalar from 0.0 to 1.0)
           
             - "blacklist" (array of positions)
             - "blacklistDistance" (scalar)
   
             - "locationDistance" (scalar)
             - "locations" (array of strings)
             
             - "roadDistance" (scalar)
             
             - "expressions" (array of expressions)
             - "threshold" (scalar)
             
             - "debug" (boolean)
   
   Returns:
    [
      campPosition,
      campWorldObjects (trees, stones, ...),
      campAreas (flat empty)   
    ]
*/

private ["_debug", "_searchCenter", "_searchRadius", "_searchSector", "_size", "_selectTree", "_selectBush", "_selectStone", "_roadDistance", "_locationDistance", "_locationDefinition", "_expressionPool", "_expressions", "_blacklist", "_blacklistDistance", "_numberOfAreas", "_spotRadius", "_areaRadius", "_areaGradient"];

_debug = false;

_searchCenter = [];
_searchRange = 1000;
_searchSector = [0, 360];

_size = [0, 0];

_selectTree = true;
_selectBush = true;
_selectStone = true;

_roadDistance = 150;
_locationDistance = 500;
_locationDefinition = [
   "NameCityCapital",
   "NameCity",
   "NameVillage"
];

_expressionPool = [
   "(5 * forest) + (3 * trees) - (10 * sea)",
   "(3 * forest) + (3 * trees) - (2 * meadow) - (2 * houses) - (10 * sea)",
   "(4 * forest) + (1 * trees) - (2 * hills) - (1 * meadow) - (1 * houses) - (10 * sea)",
   "(1 * forest) + (5 * trees) + (5 * meadow) - (2 * houses) - (10 * sea)",
   "(3 * forest) + (5 * trees) + (2 * hills) - (1 * meadow) - (1 * houses) - (10 * sea)",
   "(1 * forest) + (5 * trees) - (2 * hills) - (1 * meadow) + (2 * houses) - (10 * sea)"
];
_expressions = [];
_bestPlacesThreshold = 1.05;

_blacklist = [];
_blacklistDistance = 500;

_numberOfAreas = 0;
_spotRadius = 5.0; // for small tents
_areaRadius = 10.5; // for custom area objects (~ big tent)
_areaGradient = 0.15;


// read parameters
{
   switch (_x select 0) do
   {
      case "debug": { _debug = _x select 1; };
      case "position": { _searchCenter = _x select 1; };
      case "range": 
      { 
         if ((typeName (_x select 1)) == "ARRAY") then
         {
            _searchRange = _x select 1;
         } else
         {
            _searchRange = [0, (_x select 1)];
         };
      };
      case "sector": { _searchSector = _x select 1; };
      case "size": 
      { 
         if ((typeName (_x select 1)) == "ARRAY") then
         {
            _size = _x select 1;
         } else {
            _size = [(_x select 1), (_x select 1)];
         };
      };
      case "areas": { _numberOfAreas = _x select 1; };
      case "areaRadius": { _areaRadius = _x select 1; };    
      case "gradient": { _areaGradient = _x select 1; };
      case "blacklist": { _blacklist = _x select 1; };
      case "blacklistDistance": { _blacklistDistance = _x select 1; };
      case "roadDistance": { _roadDistance = _x select 1; }; 
      case "locationDistance": { _locationDistance = _x select 1; };
      case "locations": { _locationDefinition = _x select 1; };
      case "expressions": { _expressionPool = _x select 1; };
      case "threshold": { _bestPlacesThreshold = _x select 1; };
   };
} forEach _this;

// ... haha, very funny.... :|
if (!(_selectTree || _selectBush || _selectStone)) exitWith {
   []
};




// private functions
private ["_filter", "_scan", "_findObjects"];

// filtering an array of [position, bestPlacesValue]
_filter = {
   // bestPlacesValue threshold
   if ((_this select 1) < _bestPlacesThreshold) exitWith
   {
      false
   };
   // check road distance
   if ((count ((_this select 0) nearRoads _roadDistance)) > 0) exitWith
   {
      false
   };
   // check location distance
   if ((count (nearestLocations [(_this select 0), _locationDefinition, _locationDistance])) > 0) exitWith
   {
      false
   };
   // check against blacklist
   if (!([(_this select 0), _blacklist, {
      (((_this select 0) distance (_this select 1)) > _blacklistDistance)
   }] call RUBE_multipass)) exitWith
   {
      false
   };
   
   true
};

// void => positions (with bestPlaces value!)
_scan = {
   private ["_center", "_min", "_max", "_r", "_d", "_alpha", "_i", "_start", "_arc", "_pos", "_positions"];
   
   _center = _searchCenter;
   _min = _searchRange select 0;
   _max = _searchRange select 1;
   
   _r = (_max - _min) * 0.5;
   _d = _r + _min;
   _alpha = (_d atan2 _r) * 1.0;
   _i = 0;
   
   _start = _searchSector select 0;
   _arc = (_searchSector select 1) - _start;
   
   if (_arc == 360) then
   {
      _start = (random 360);
   };
   
   _positions = [];
   
   while {(_i < _arc)} do
   {
      // refill expression pool
      if ((count _expressions) == 0) then
      {
         _expressions = +_expressionPool;
      };
      
      _pos = [_center, _d, (_start + _i)] call BIS_fnc_relPos;
      // append the...
      _positions = [
         _positions,
         // ... filtered ...
         ([
            // ... selected places
            (selectBestPlaces [
               _pos,
               _r,
               (_expressions call RUBE_randomPop),
               ((sqrt _r) * 0.5), // precision
               (2 + (floor (random 5))) // number of places
            ]), 
            _filter
         ] call RUBE_arrayFilter)
      ] call RUBE_arrayAppend;
      
      if (_debug) then
      {
         [
            ["position", _pos],
            ["type", "ELLIPSE"],
            ["color", "ColorBlue"],
            ["size", [_r, _r]],
            ["alpha", 0.5]
         ] call RUBE_mapDrawMarker;
      };
      
      _i = _i + _alpha;
   };
   
   _positions
};

// [number, pos, start, max] => objects
_findObjects = {
   private ["_n", "_pos", "_start", "_max", "_delta", "_objects"];
   _n = _this select 0;
   _pos = _this select 1;
   _radius = _this select 2;
   _max = _this select 3;
   
   _delta = (_max - _radius) * 0.2; // 5 steps
   _objects = [];
   
   while {(_radius <= _max)} do
   {
      _objects = [
         (nearestObjects [_pos, [], _radius]),
         {
            // distance check to main areas
            if (!([(position _this), _campAreas, {
               (((_this select 0) distance (_this select 1)) > (_areaRadius * 2.5))
            }] call RUBE_multipass)) exitWith { false };
            // object type checks
            if (_selectTree && (_this call RUBE_WORLD_isTree)) exitWith { true };
            if (_selectBush && (_this call RUBE_WORLD_isBush)) exitWith { true };
            if (_selectStone && (_this call RUBE_WORLD_isStone)) exitWith { true };
            false
         }
      ] call RUBE_arrayFilter;
      
      _objects = [_objects, (_spotRadius * 2.5)] call RUBE_distanceFilter;
      
      if ((count _objects) >= _n) exitWith {};
      _radius = _radius + _delta;
   };
   
   _objects
};



// search
private ["_campPosition", "_campWorldObjects", "_campAreas", "_n1", "_n2", "_campRadiusAreaStart", "_campRadiusAreaMax", "_campRadiusAreaMax2", "_bestPlaces", "_place", "_pass"];

_campPosition = [];
_campWorldObjects = [];
_campAreas = [];
_n1 = _size select 1; // number of objects to find
_n2 = _numberOfAreas; // number of areas to find

// n tents * (x * y) = Arect;
// Acircle = pi * r^2 
// => Arect = Acircle 
_campRadiusAreaStart = (sqrt ((_n1 * (_spotRadius * _spotRadius)) / pi));
_campRadiusAreaMax = _campRadiusAreaStart * 2.5;
_campRadiusAreaMax2 = _campRadiusAreaStart * (2 + _numberOfAreas);
//diag_log format["radius for %1: %2m to %3m", _n1, _campRadiusAreaStart, _campRadiusAreaMax];


while {((count _campPosition) == 0)} do
{
   _bestPlaces = [] call _scan;

   if (_debug) then
   {
      {
         [
            ["position", (_x select 0)],
            ["type", "mil_dot"],
            ["color", "ColorBlue"],
            ["text", format["%1", (_x select 1)]]
         ] call RUBE_mapDrawMarker;
      } forEach _bestPlaces;   
   };

   while {((count _bestPlaces) > 0)} do
   {
      _place = _bestPlaces call RUBE_randomPop;
      _pass = true;
      
      if (_debug) then
      {
         [
            ["position", (_place select 0)],
            ["type", "mil_circle"],
            ["color", "ColorBlue"],
            ["alpha", 0.5]
         ] call RUBE_mapDrawMarker;
      };
      
      // check 1: areas
      if (_pass && (_n2 > 0)) then
      {
         _campAreas = [
            ["position", (_place select 0)],
            ["number", _n2],
            ["range", [0, _campRadiusAreaMax2]],
            ["objDistance", _areaRadius],
            ["maxGradient", _areaGradient],
            ["adjustPos", (5 + (random 10))]
         ] call RUBE_randomCirclePositions;
                  
         if ((count _campAreas) < _n2) then
         {
            _pass = false;
         };
      };
      
      // check 2: objects
      if (_pass) then
      {
         _campWorldObjects = [_n1, (_place select 0), _campRadiusAreaStart, _campRadiusAreaMax] call _findObjects;
         
         if ((count _campWorldObjects) < _n1) then
         {
            _pass = false;
         };
      };

      // exit
      if (_pass) exitWith 
      {
         _campPosition = (_place select 0);
      };
   };
   
   // weaken restrictions
   _searchRange set [1, ((_searchRange select 1) + 250)];
   _campRadiusAreaMax = _campRadiusAreaMax * 1.25;
   _campRadiusAreaMax2 = _campRadiusAreaMax2 * 1.25;
   _areaGradient = _areaGradient + 0.01;
};



// return
[
   _campPosition,
   _campWorldObjects,
   _campAreas
]