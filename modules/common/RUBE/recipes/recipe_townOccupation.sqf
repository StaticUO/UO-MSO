/*
   Author:
    rübe
    
   Description:
    occupies a town (spawning units, barricades, ...)
    
   Parameter(s):
    _this: parameters (array of array [key (string), value (any)])
    
           - required:
           
             - "location" (position OR location)
                  searches for the nearest location in case a 
               position is passed.
               
             - "faction" (string in ["USMC", "CDF", "RU", "INS", "GUE"]),
               - default = GUE
               
           - optional:
             
             - "side" (side)
                  if no side is passed, the groups will be created for the
                default fractions side.
                
             - "camouflage" (string in ["woodland", "desert"])
                  tries to spawn objects with suitable painting.
                - default = "woodland"
               
             - "onDefeat" (code)
                  code to run, once the occupation is all dead or gone. If
               No code is passed, no triggers will be setup...
             
             - "onAlarm" (code)
                  code to run on alarm 
             
             - "blacklist" (array of positions)
             - "blacklistDistance" (scalar)
             
             - "debug" (boolean)
               - default = false
               
             
             // groups config, all auto if not overwritten, or num = -1 //
             - "strength" (scalar)
               - strength multiplicater, default = 1.0;
               
             // will garrison buildings
             - "garrisonNum" (integer)
             - "garrisonType" (RUBE group type or array of ...)
             
             // center patrols, patrolling or hanging out   
             - "patrolNum" (integer)
             - "patrolCoef" (scalar from 0.0 (in-the-wings/hang out) to 1.0 (patrol))
             - "patrolType" (RUBE group type or array of ...)
                
             // perimeter patrols
             - "perimeterNum" (integer)
             - "perimeterType" (RUBE group type or array of ...)
             
             // motorized groups, hanging out (in the wings), engaging on alarm...
             - "motorizedNum" (integer)
             - "motorizedType" (RUBE group type or array of ...)
    
   
   Returns:
    array of groups that were created
*/

private ["_groups", "_triggers", "_location", "_locationTypes", "_faction", "_factionInfo", "_side", "_spawnCamp", "_spawnSupplies", "_spawnBarricades", "_barricades", "_spawnWrecks", "_wreckPool", "_camouflage", "_onDefeat", "_onAlarm", "_blacklist", "_blacklistDistance", "_debug", "_strengthMul", "_strengthPool", "_garrisonGrpNum", "_garrisonGrpPool", "_patrolGrpNum", "_patrolGrpPool", "_patrolCoef", "_perimeterGrpNum", "_perimeterGrpPool", "_motorizedGrpNum", "_motorizedGrpPool"];

_groups = [];
_triggers = [];
_location = [0, 0, 0];
_locationTypes = ["NameCityCapital", "NameCity", "NameVillage", "NameLocal"];
_faction = "GUE";
_side = false;
_spawnCamp = true;
_spawnSupplies = true;
_spawnBarricades = true;
_barricades = [];
_spawnWrecks = true;
_wreckPool = [
   "BMP2Wreck",
   "BRDMWreck",
   "HMMWVWreck",
   "T72Wreck",
   "SKODAWreck",
   "T72WreckTurret",
   "UralWreck",
   "UAZWreck",
   "hiluxWreck",
   "datsun01Wreck",
   "datsun02Wreck"
];
_camouflage = "woodland";
_onDefeat = false;
_onAlarm = false;

_blacklist = [];
_blacklistDistance = 500;

_debug = false;

// groups config (number & types)
_strengthMul = 1.0; 

// for random enemy type/strength distribution
_strengthPool = [1.0, 0.5, 0.25, 0.0]; 
switch ((floor (random 5))) do
{
   case 0: { _strengthPool = [0.5, 0.0, 0.5, 0.75];  };
   case 1: { _strengthPool = [1.0, 0.0, 0.0, 0.75];  };
   case 2: { _strengthPool = [1.0, 0.25, 0.25, 0.25];  };
};

_garrisonGrpNum = -1;
_garrisonGrpPool = ["fireteam", "fireteam", "fireteam", "engineer", "saboteur", "mg"];

_patrolGrpNum = -1;
_patrolGrpPool = ["fireteam", "fireteam", "assault", "aa", "engineer", "saboteur", "mg"];
_patrolCoef = 0.5; // patrol (1.0) vs. in-the-wings/hang out (0.0)

_perimeterGrpNum = -1;
_perimeterGrpPool = ["fireteam", "fireteam", "fireteam", "engineer", "saboteur", "mg"];

_motorizedGrpNum = -1;
_motorizedGrpPool = ["motInf", "motPatrol"];


// read parameters
{
   switch (_x select 0) do
   {
      case "location": { _location = _x select 1; };
      case "faction": { _faction = _x select 1; };
      case "side": { _side = _x select 1; };
      case "onDefeat": { _onDefeat = _x select 1; };
      case "onAlarm": { _onAlarm = _x select 1; };
      case "debug": { _debug = _x select 1; };
      case "camouflage": { _camouflage = _x select 1; };

      case "strength": { _strengthMul = _x select 1; };
      case "garrisonNum": { _garrisonGrpNum = _x select 1; };
      case "garrisonType": 
      {
         if ((typeName (_x select 1)) == "ARRAY") then
         {
            _garrisonGrpPool = _x select 1;
         } else 
         {
            _garrisonGrpPool = [(_x select 1)];
         };
      };
      case "patrolNum": { _patrolGrpNum = _x select 1; };
      case "patrolCoef": { _patrolCoef = _x select 1; };
      case "patrolType": 
      {
         if ((typeName (_x select 1)) == "ARRAY") then
         {
            _patrolGrpPool = _x select 1;
         } else 
         {
            _patrolGrpPool = [(_x select 1)];
         };
      };
      case "perimeterNum": { _perimeterGrpNum = _x select 1; };
      case "perimeterType": 
      {
         if ((typeName (_x select 1)) == "ARRAY") then
         {
            _perimeterGrpPool = _x select 1;
         } else 
         {
            _perimeterGrpPool = [(_x select 1)];
         };
      };
      case "motorizedNum": { _motorizedGrpNum = _x select 1; };
      case "motorizedType": 
      {
         if ((typeName (_x select 1)) == "ARRAY") then
         {
            _motorizedGrpPool = _x select 1;
         } else 
         {
            _motorizedGrpPool = [(_x select 1)];
         };
      };
      case "blacklist": { _blacklist = _x select 1; };
      case "blacklistDistance": { _blacklistDistance = _x select 1; };
   };
} forEach _this;

// init parameters
// search nearest location if a position was given
if ((typeName _location) != "LOCATION") then
{
   private ["_locations"];
   _locations = nearestLocations [_location, _locationTypes, 2000];
   if ((count _locations) > 0) then
   {
      _location = _locations select 0;
   };
};

// abort if no location could be found...
if ((typeName _location) != "LOCATION") exitWith
{
   []
};

// default faction information
_factionInfo = _faction call RUBE_selectFactionInfo;

// auto. side
if ((typeName _side) != "SIDE") then
{
   _side = _factionInfo select 0;
};



private ["_position", "_locationName", "_locationSize", "_locationSizeExt", "_locationType", "_factionMG", "_factionCar", "_factionTruck", "_factionTruckReammo", "_factionTruckRefuel", "_factionTent", "_factionCamoNet1", "_factionCamoNet3", "_factionBarricade", "_factionWeaponMisc", "_factionTableItems", "_getFactionAmmoBox", "_factionTruckPool", "_factionTentCargoPool", "_factionSuppliesPool", "_strength", "_filterRoads", "_searchRoads", "_barricadeOrientation", "_toRoadDir", "_num"];

_position = position _location;
_locationName = text _location;
_locationSize = [(size _location)] call RUBE_average;
_locationSizeExt = _locationSize * 1.75;
_locationType = type _location;

_factionMG = ["static-mg", _faction] call RUBE_selectFactionVehicle;
_factionCar = ["mobile", _faction] call RUBE_selectFactionVehicle;
_factionTruck = ["truck-closed", _faction] call RUBE_selectFactionVehicle;
_factionTruckReammo = ["truck-reammo", _faction] call RUBE_selectFactionVehicle;
_factionTruckRefuel = ["truck-refuel", _faction] call RUBE_selectFactionVehicle;
_factionTent = ["tent", _faction] call RUBE_selectFactionBuilding;
_factionCamoNet1 = ["camoNet1", _faction] call RUBE_selectFactionBuilding;
_factionCamoNet3 = ["camoNet3", _faction] call RUBE_selectFactionBuilding;
_factionBarricade = "Fort_Barricade";
_factionWeaponMisc = [
   (["rifle", "rifle-scoped", "pistol", "mg"] call RUBE_randomSelect), 
   _faction
] call RUBE_selectFactionWeapon;

_factionTableItems = [_factionWeaponMisc, "EvMap", "EvMoney", "EvPhoto", "SatPhone", "Notebook"];
_getFactionAmmoBox = {
   ([
      (["weapons", "ammunition", "weapons", "ammunition", "weapons", "ordnance", "launcher", "special"] call RUBE_randomSelect),
      _faction
   ] call RUBE_selectFactionAmmobox)
};

// weighted truck pool to select randomly from
_factionTruckPool = [
   _factionTruck, 
   _factionTruck,
   _factionTruck,
   _factionTruckReammo,
   _factionTruckRefuel
];

_factionTentCargoPool = [
   "Barrels", "Barrel5", "Land_Barrel_empty", "Land_Barrel_sand", 
   "Land_Barrel_water", "SmallTable"
]; 

// pool of supply objects (again weighted)
_factionSuppliesPool = [
   (["weapons", _faction] call RUBE_selectFactionAmmobox),
   (["ammunition", _faction] call RUBE_selectFactionAmmobox),
   (["vehicle", _faction] call RUBE_selectFactionAmmobox),
   "Misc_cargo_cont_net1", "Misc_cargo_cont_net1",
   "Misc_cargo_cont_net2", "Misc_cargo_cont_net2",
   "Misc_cargo_cont_net3",
   "Barrels", "Barrels", "Barrels",
   "Barrel5", "Barrel5", "Barrel5",
   "Barrel4", "Barrel4", "Barrel4",
   "Misc_palletsfoiled_heap", "Paleta1", "Paleta2", "PowerGenerator",
   "Barrels", "Misc_concrete_High", "Misc_palletsfoiled", "Fort_Crate_wood"
];

// ... and for the correct painting...
switch (_camouflage) do
{
   case "desert":
   {
      _factionCamoNet1 = _factionCamoNet1 call RUBE_objectInDesert;
      _factionCamoNet3 = _factionCamoNet3 call RUBE_objectInDesert;
      _factionBarricade = _factionBarricade call RUBE_objectInDesert;
   };
};

// calculate strengh of occupation
_strength = 0;

switch (true) do
{
   case (_locationSize > 299): { _strength = 0.75 + (random 0.75); };
   case (_locationSize > 199): { _strength = 0.5 + (random 0.5); };
   case (_locationSize > 99): { _strength = 0.25 + (random 0.25); };
   default {
      _strength = 0.25;
   };
};

switch (true) do
{
   case (_locationType == "NameCityCapital"): { _strength = _strength + 0.5 + (random 0.5); };
   case (_locationType == "NameCity"): { _strength = _strength + 0.25 + (random 0.5); };
   case (_locationType == "NameVillage"): { _strength = _strength + (random 0.5); };
};

_strength = ceil (_strength * _strengthMul);

if (_debug) then
{
   [
      ["position", [(_position select 0), ((_position select 1) - 50)]],
      ["type", "Warning"],
      ["color", "ColorBlack"],
      ["text", format["occ: %1", _strength]]
   ] call RUBE_mapDrawMarker;
};

// filters out roads too near to each other
_filterRoads = {
   private ["_roads", "_min", "_accepted", "_passed", "_obj"];
   _roads = _this select 0;
   _min = _this select 1;
   _accepted = [];
   
   {
      _passed = true;
      _obj = _x;
      {
         if ((_x distance _obj) < _min) exitWith 
         {
            _passed = false;
         };
      } forEach _accepted;
      if (_passed) then
      {
         _accepted set [(count _accepted), _obj];
      };
   } forEach _roads;
   
   _accepted
};

// searches roads in a given range, keeping a min. distance to each other
_searchRoads = {
   private ["_base", "_rand", "_minDist", "_offset", "_step", "_radius", "_i", "_pos", "_roads", "_sample"];
   // base and random amount of locationSize for relPos
   _base = _this select 0;
   _rand = _this select 1;
   _minDist = _this select 2;
   
   _offset = random 360;
   _step = 10;
   _radius = (_locationSize * (sin (_step * 0.5)));
   _roads = [];
   
   for "_i" from 0 to (360 - _step) step _step do
   {
      _pos = [_position, (_locationSize * (_base + (random _rand))), ((_i + _offset) % 360)] call BIS_fnc_relPos;
      _pos set [2, 0];
      _sample = _pos nearRoads _radius;
      if ((count _sample) > 0) then
      {
         _roads set [(count _roads), (_sample call RUBE_randomSelect)];
      };
   };
   
   _roads = [_roads, _minDist] call _filterRoads;
   
   _roads
};

// assures that barricades are orientet outwards/away from the location
_barricadeOrientation = {
   private ["_obj", "_dir", "_rel"];
   _obj = _this select 0;
   _dir = _this select 1;
   _rel = ([_position, (position _obj)] call BIS_fnc_dirTo) call RUBE_normalizeDirection;
   
   if ([_dir, (_rel + 90), (_rel + 270)] call RUBE_dirInArc) then
   {
      _dir = _dir - 180;
   };
   _dir
};


// try to find the direction to the nearest road
_toRoadDir = {
   private ["_pos", "_dir", "_dist", "_roads"];
   _pos = _this select 0;
   _dir = _this select 1;
   _dist = 20;
   _pos set [2, 0];
   _roads = [];
   
   while {(((count _roads) == 0) && (_dist < 300))} do
   {
      _roads = _pos nearRoads _dist;
      _dist = _dist + 20;
   };
   
   if ((count _roads) > 0) then
   {
      _dir = [_pos, (_roads select 0)] call BIS_fnc_dirTo;
   };
   
   _dir
};



// create main group
_groups set [0, (createGroup _side)];

//(_groups select 0) setCombatMode (["YELLOW", "RED"] call RUBE_randomSelect);
[
   ["type", "HOLD"],
   ["behaviour", (["CARELESS", "SAFE", "AWARE"] call RUBE_randomSelect)],
   ["combatMode", (["YELLOW", "RED"] call RUBE_randomSelect)]
] call RUBE_updateWaypoint;


// retrieve main areas
private ["_areas", "_areaRadius", "_areaDist", "_areaMaxGradient", "_pointsOfInterest", "_buildings", "_getPatrolPoints", "_getPerimeterPoints", "_i", "_j", "_pos"];
_areas = [];
_areaRadius = (14 + (random 8));
_areaDist = (_locationSize * (0.25 + (random 0.3)));
_areaMaxGradient = 0.1;
_pointsOfInterest = [];

_buildings = nearestObjects [_position, ["Building"], (_locationSize * 1.5)];

// points for a random center/town patrol
_getPatrolPoints = {
   private ["_points", "_i"];
   _points = [];
   if ((count _buildings) > 10) then
   {
      _points = [_buildings, 0.5] call RUBE_randomSubSet;
   } else 
   {
      for "_i" from 0 to (7 + (floor (random 9))) do
      {
         _points set [
            _i, 
            ([_position, [0, 0], [_locationSize, _locationSize]] call RUBE_randomizePos)
         ];
      };
   };
   _points
};

// points for a random perimeter patrol
_getPerimeterPoints = {
   private ["_points", "_step", "_offset", "_i"];
   _points = [];
   _step = ([36, 45, 60] call RUBE_randomSelect);
   _offset = random 360;
   
   for "_i" from 0 to 360 step _step do
   {
      _points set [
         (count _points),
         ([
             _position, 
             (_locationSize * (0.75 + (random 1.0))), 
             (_offset + _i)
          ] call BIS_fnc_relPos)
      ];
   };

   _points
};


while {((count _areas) < 4)} do
{
   _areas = [
      ["position", _position],
      ["number", 7],
      ["range", [0, _areaDist]],
      ["objDistance", _areaRadius],
      ["posDistance", (_areaRadius * (1.25 + (random 0.75)))],
      ["maxGradient", _areaMaxGradient],
      ["roadDistance", (_areaRadius + (4 + (random 5)))],
      ["adjustPos", (5 + (random 10))],
      ["blacklist", _blacklist],
      ["blacklistDistance", _blacklistDistance]
   ] call RUBE_randomCirclePositions;
   
   _areaDist = _areaDist * 1.05;
   _areaMaxGradient = _areaMaxGradient + 0.01;
};

// sort list, neareast positions at the end, so they can be easily popped
_areas = [
   _areas,
   {
      ((_this distance _position) * -1)
   }
] call RUBE_shellSort;

if (_debug) then
{
   {
      [
         ["position", _x],
         ["type", "ELLIPSE"],
         ["size", [_areaRadius, _areaRadius]],
         ["color", "ColorRed"]
      ] call RUBE_mapDrawMarker;
   } forEach _areas;
};


// spawn camp
if (_spawnCamp && ((count _areas) > 0)) then
{
   private ["_pos", "_p", "_relDir", "_arc", "_tentOffset", "_tents", "_tent", "_mainTent", "_dim", "_n", "_tRad", "_tGrad", "_tDist", "_tentSize", "_tps", "_tp", "_iClasses", "_items", "_ltClasses", "_unit", "_obj"];
   //_pos = _areas call RUBE_randomPop;   
   _pos = _areas call BIS_fnc_arrayPop;
   _pointsOfInterest set [(count _pointsOfInterest), _pos];
   
   // guarded by trigger
   _triggers set [(count _triggers), ([
      ["position", _pos],
      ["type", [_side, "GUARDED"]]
   ] call RUBE_createTrigger)];
   
   _relDir = [_pos, _position] call BIS_fnc_dirTo;
   _arc = 115 + ((_strength + (random _strength)) * 16);
   if (_arc > 270) then
   {
      _arc = 270;
   };
   // tents
   _tentOffset = 90;
   switch (true) do
   {
      case (_factionTent in ["Camp", "MASH", "MASH_EP1"]): 
      { 
         _tentOffset = _tentOffset + 90;
      };
      case (_factionTent in ["CampEast", "CampEast_EP1"]): 
      { 
         _tentOffset = _tentOffset - 90;
      };
   };

   // single/random or circle spawn
   _tents = [];
   
   if (50 call RUBE_chance) then
   {
      _dim = _factionTent call RUBE_getObjectDimensions;
      _tRad = (((_dim select 0) select 0) max ((_dim select 0) select 1)) + 2;
      _tDist = 50;
      _tGrad = 0.1;
      _n = 2 + (floor (random _strength));
      _tps = [];
      while {((count _tps) < _n)} do
      {
         _tps = [
            ["position", _pos],
            ["number", (_n + 3)],
            ["range", [0, _tDist]],
            ["objDistance", _tRad],
            ["posDistance", (_tRad + 2.5)],
            ["maxGradient", _tGrad],
            ["roadDistance", (_tRad + (4 + (random 5)))],
            ["adjustPos", (5 + (random 10))],
            ["blacklist", _blacklist],
            ["blacklistDistance", _blacklistDistance]
         ] call RUBE_randomCirclePositions;
         _tDist = _tDist * 1.1;
         _tGrad = _tGrad + 0.05;
      };
      
      {
         _n = count _tents;
         _tents set [_n, (_factionTent createVehicle _x)];
         (_tents select _n) setDir (random 360);
         (_tents select _n) setPos _x;
         /*
         [
            ["position", _x],
            ["type", "mil_dot"],
            ["color", "ColorRed"]
         ] call RUBE_mapDrawMarker;
         */
      } forEach _tps;

   } else
   {
      _tents = [
         [[_factionTent, [0, 0, 0], _tentOffset]],
         [],
         _pos,
         [_areaRadius, 0],
         12,
         3,
         [(_relDir - (_arc * 0.5)), _arc]
      ] call RUBE_spawnObjectCircle;
   };
      
      
   // fill tents
   if ((count _tents) > 0) then
   {
      _mainTent = floor (random (count _tents));
      
      for "_i" from 0 to ((count _tents) - 1) do
      {
         _tent = _tents select _i;
         _tent setVariable ["RUBE_isOccupied", true, true];
         
         switch (true) do
         {
            // the tent of L.T. Nut Case
            case (_i == _mainTent):
            {
               _tps = [_tent, "table"] call RUBE_getTentPositions;
               _tp = _tps call RUBE_randomPop;
               
               // table (and some item)
               _iClasses = [(_factionTableItems call RUBE_randomSelect)];
               if (50 call RUBE_chance) then
               {
                  _iClasses set [(count _iClasses), (_factionTableItems call RUBE_randomSelect)];
               };
               _items = [
                  ["position", (_tp select 0)],
                  ["direction", (_tp select 1)],
                  ["table", "FoldTable"],
                  ["chair", "FoldChair"],
                  ["zerror", -0.04],
                  ["items", _iClasses]
               ] call RUBE_spawnTable;
               
               if ((count _tps) > 0) then
               {
                  // Notice_board
                  _tp = _tps call RUBE_randomPop;
                  _obj = "Notice_board" createVehicle (_tp select 0);
                  _obj setDir (((_tp select 1) + 15 - (random 30)) - 180);
                  _obj setPos (_tp select 0);
               };
               
               // L.T. Nut Case
               _p = (_items select 0) modelToWorld [(1 - (random 2)), 0.95, 0];
               _p set [2, 0];
      
               _ltClasses = ["tl"];
               if (_strength > 1) then { _ltClasses set [(count _ltClasses), "sl"]; };
               if (_strength > 2) then { _ltClasses set [(count _ltClasses), "officer"]; };
               
               _unit = [
                  (_ltClasses call RUBE_randomSelect),
                  _faction,
                  (_groups select 0),
                  _p
               ] call RUBE_spawnFactionUnit;
               _unit setDir ((_tp select 1) + (195 - (random 30)));
               _unit doWatch (_items select 0);
               _unit setPos _p;
               
               // and some guards
               for "_i" from 1 to (2 + (floor (random 3))) do
               {
                  _unit = [
                     (_groups select 0),
                     _faction,
                     ([_pos, [_i, _i], [_areaRadius, _areaRadius]] call RUBE_randomizePos),
                     ((direction (_tents call RUBE_randomSelect)) - 180),
                     "nothing"
                  ] call RUBE_AI_spawnGuard;
               };
            };
            // misc tents
            case (35 call RUBE_chance):
            {
               _tps = [_tent, "cargo"] call RUBE_getTentPositions;
               {
                  if (70 call RUBE_chance) then
                  {
                     _obj = (_factionTentCargoPool call RUBE_randomSelect) createVehicle (_x select 0);
                     _obj setDir (_x select 1);
                     _obj setPos (_x select 0);
                  };
               } forEach _tps;
            };
            // ammo tents
            default
            {
               _tps = [_tent, "cargo"] call RUBE_getTentPositions;
               {
                  if (60 call RUBE_chance) then
                  {
                     _obj = ([] call _getFactionAmmoBox) createVehicle (_x select 0);
                     _obj setDir (_x select 1);
                     _obj setPos (_x select 0);
                  };
               } forEach _tps;
            };
         };
      }
   };   

      
   if (_debug) then
   {
      [
         ["position", _pos],
         ["type", "Camp"],
         ["color", "ColorBlue"]
      ] call RUBE_mapDrawMarker;
   };
};


// spawn supplies
if (_spawnSupplies && ((count _areas) > 0)) then
{
   private ["_pos", "_relDir", "_roadDir", "_n", "_offset", "_start", "_blueprint", "_trucks", "_p", "_supplies", "_obj", "_dir", "_camo", "_dim"];
   //_pos = _areas call RUBE_randomPop;  
   _pos = _areas call BIS_fnc_arrayPop;
   _pointsOfInterest set [(count _pointsOfInterest), _pos]; 
   
   // guarded by trigger
   _triggers set [(count _triggers), ([
      ["position", _pos],
      ["type", _side]
   ] call RUBE_createTrigger)];
   
   _relDir = [_pos, _position] call BIS_fnc_dirTo;
   _roadDir = [_pos, _relDir] call _toRoadDir;
   
   // trucks/supplies
   _n = 1 + (round (random (_strength * 0.6)));
   if (_n > 4) then
   {
      _n = 4;
   };
   _offset = 6;
   _start = ((round (_n * 0.5)) * _offset) * -1;
   // (trucks)
   _blueprint = [];
   for "_i" from 0 to (_n - 1) do
   {
      _blueprint set [
         _i, 
         [
            (_factionTruckPool call RUBE_randomSelect),
            [(_start + (_offset * _i)), (0.5 - (random 1)), 0],
            (10 - (random 20))
         ]
      ];
   };
   _trucks = [
      ([_pos, 3, _roadDir] call BIS_fnc_relPos), 
      _roadDir, 
      _blueprint
   ] call RUBE_spawnObjects;
   
   // (supplies)
   _dir = (_roadDir - (135 + (random 90)));
   _p = [_pos, 7, _dir] call BIS_fnc_relPos;
   _camo = [_factionCamoNet1, _factionCamoNet3] call RUBE_randomSelect;
   _dim = _camo call RUBE_getObjectDimensions;

   _supplies = [
      _p,
      [
         (((_dim select 0) select 0) - 2.0),
         (((_dim select 0) select 1) - 2.0)
      ],
      _dir,
      0.5, // margin
      _factionSuppliesPool
   ] call RUBE_spawnPackedArea;
   // camo net for supplies
   _obj = _camo createVehicle _p;
   _obj setDir _dir;
   _obj setPos _p;

   
   if (_debug) then
   {
      [
         ["position", _pos],
         ["type", "SupplyVehicle"],
         ["color", "ColorBlue"]
      ] call RUBE_mapDrawMarker;
   };
};


// building garrison groups
_num = floor (random (_strength + (_strengthPool call RUBE_randomPop)));
// from parameter?
if (_garrisonGrpNum > -1) then
{
   _num = _garrisonGrpNum;
};
for "_i" from 0 to _num do
{
   _j = (count _groups);
   _pos = [_position, [10, 10], [_locationSize, _locationSize]] call RUBE_randomizePos;
   
   // create group
   _groups set [_j, ([
      ["position", _pos],
      ["type", (_garrisonGrpPool call RUBE_randomSelect)],
      ["faction", _faction]
   ] call RUBE_spawnFactionGroup)];
   
   // run fsm
   [
      ["group", (_groups select _j)],
      ["position", _pos],
      ["radius", (_locationSize * (1 + (random 3)))]
   ] execFSM "modules\common\RUBE\ai\inf\ai_garrisonBuildings.fsm";
};



// center patrols/in the wings
_num = floor (_strength + (random (_strengthPool call RUBE_randomPop)));
if (_patrolGrpNum > -1) then
{
   _num = _patrolGrpNum;
};
for "_i" from 0 to _num do 
{
   _j = (count _groups);
   _pos = [_position, [10, 10], [_locationSize, _locationSize]] call RUBE_randomizePos;
   
   // create group
   _groups set [_j, ([
      ["position", _pos],
      ["type", (_patrolGrpPool call RUBE_randomSelect)],
      ["faction", _faction]
   ] call RUBE_spawnFactionGroup)];
   
   if ((random 1.0) < _patrolCoef) then
   {
      // run patrol fsm
      [
         ["group", (_groups select _j)],
         ["pointsOfInterest", _pointsOfInterest],
         ["perimeter", ([] call _getPatrolPoints)],
         ["patrolCoef", 0.15],
         ["distance", (90 + (random 60))],
         ["deviance", (7 + (random 20))],
         ["dutyCoef", (0.2 + (random 0.6))]
      ] call RUBE_AI_taskPatrol;
   } else
   {
      // run in the wings
      [
         ["group", (_groups select _j)]
      ] call RUBE_AI_waitingInTheWings;
   };
};

// perimeter patrols
_num = floor (_strength + (random (_strengthPool call RUBE_randomPop)));
if (_perimeterGrpNum > -1) then
{
   _num = _perimeterGrpNum;
};
for "_i" from 0 to _num do 
{
   _j = (count _groups);
   _pos = [_position, [10, 10], [_locationSize, _locationSize]] call RUBE_randomizePos;
   
   // create group
   _groups set [_j, ([
      ["position", _pos],
      ["type", (_perimeterGrpPool call RUBE_randomSelect)],
      ["faction", _faction]
   ] call RUBE_spawnFactionGroup)];
   
   // run patrol fsm
   [
      ["group", (_groups select _j)],
      ["pointsOfInterest", _pointsOfInterest],
      ["perimeter", ([] call _getPerimeterPoints)],
      ["patrolCoef", 0.05],
      ["distance", (100 + (random 200))],
      ["deviance", (7 + (random 20))],
      ["dutyCoef", (0.15 + (random 0.6))]
   ] call RUBE_AI_taskPatrol;
};

// motorized guards
_num = floor ((_strengthPool call RUBE_randomPop) + (random (_strength - 2)));
if (_motorizedGrpNum > -1) then
{
   _num = _motorizedGrpNum;
};
for "_i" from 0 to _num do
{
   _j = (count _groups);
   _pos = [];
   if ((count _areas) > 0) then
   {
      _pos = _areas call RUBE_randomPop; 
   } else 
   {
      _pos = [_position, [10, 10], [_locationSize, _locationSize]] call RUBE_randomizePos;
   };
   
   
   // create group
   _groups set [_j, ([
      ["position", _pos],
      ["type", (_motorizedGrpPool call RUBE_randomSelect)],
      ["faction", _faction]
   ] call RUBE_spawnFactionGroup)];
   
   // run in the wings
   [
      ["group", (_groups select _j)]
   ] call RUBE_AI_waitingInTheWings;
   
   if (_debug) then
   {
      [
         ["position", _pos],
         ["type", "o_motor_inf"],
         ["color", "ColorBlue"]
      ] call RUBE_mapDrawMarker;
   };
};




// create alarm ON triggers for all enemy sides
private ["_onAlarmCodeIndex", "_alarmIndex", "_groupsIndex", "_alarmCondDetected", "_alarmCondNotPresent", "_alarmOn", "_alarmOff"];


_onAlarmCodeIndex = -1;
if ((typeName _onAlarm) == "CODE") then
{
   _onAlarmCodeIndex = _onAlarm call RUBE_saveData;
} else 
{
   _onAlarmCodeIndex = {} call RUBE_saveData;
};




_alarmIndex = false call RUBE_saveData;
_groupsIndex = _groups call RUBE_saveData;
_alarmCondDetected = format["((!(%1 call RUBE_getData)) && this)", _alarmIndex];
_alarmCondNotPresent = format["((%1 call RUBE_getData) && this)", _alarmIndex];
_alarmOn = format[
   "{ [[""group"", _x], [""behaviour"", ""COMBAT""]] call RUBE_updateWaypoint; } forEach (%1 call RUBE_getData); [%2, true] call RUBE_setData; [] call (%3 call RUBE_getData);", 
   _groupsIndex,
   _alarmIndex,
   _onAlarmCodeIndex
];
_alarmOff = format[
   "{ [[""group"", _x], [""behaviour"", ""SAFE""]] call RUBE_updateWaypoint; } forEach (%1 call RUBE_getData); [%2, false] call RUBE_setData;",
   _groupsIndex,
   _alarmIndex
];

{
   if ((_side getFriend _x) < 0.6) then
   {         
      // detected -> alarm on
      _triggers set [(count _triggers), ([
         ["position", _position],
         ["radius", _locationSizeExt],
         ["activation", [[_x, "SIDE"], [_side, "DETECT"]]],
         ["repeat", true],
         ["condition", _alarmCondDetected],
         ["onActivation", _alarmOn],
         //["onDeactivation", _alarmOff],
         ["timeout", [7, 11, 17, true]]
      ] call RUBE_createTrigger)];
      
      // not present -> alarm off
      _triggers set [(count _triggers), ([
         ["position", _position],
         ["radius", _locationSizeExt],
         ["activation", [[_x, "SIDE"], "NOT PRESENT"]],
         ["repeat", true],
         ["condition", _alarmCondNotPresent],
         ["onActivation", _alarmOff],
         ["timeout", [15, 30, 60, true]]
      ] call RUBE_createTrigger)];
   };
} forEach ([West, East, Resistance, Civilian] - [_side]);







// spawn some wrecks
if (_spawnWrecks) then
{
   private ["_roads", "_n", "_i", "_obj"];
   _roads = [0.0, 0.5, 16] call _searchRoads;
   // map roads to positions
   [
      _roads,
      {
         (position _this)
      }
   ] call RUBE_arrayMap;
   // add some non-road positions
   for "_i" from 0 to (3 + (floor (random 4))) do
   {
      [_roads, ([
         ["position", _position],
         ["number", 2],
         ["range", [5, _locationSizeExt]],
         ["objDistance", 4],
         ["adjustPos", 3.0],
         ["maxGradient", 0.3],
         ["blacklist", _blacklist],
         ["blacklistDistance", _blacklistDistance]
      ]call RUBE_randomCirclePositions)] call RUBE_arrayAppend;
   };
   
   
   _n = 2 + (ceil (random _strength));
   if (_n > (count _roads)) then
   {
      _n = count _roads;
   };
   if (_n > (count _wreckPool)) then
   {
      _n = count _wreckPool;
   };
   for "_i" from 1 to _n do
   {
      _road = _roads call RUBE_randomPop;
      _obj = (_wreckPool call RUBE_randomPop) createVehicle _road;
      _obj setDir (random 360);
      if (_debug) then
      {
         [
            ["position", (position _obj)],
            ["direction", (direction _obj)],
            ["type", "mil_triangle"],
            ["color", "ColorBlack"]
         ] call RUBE_mapDrawMarker;
      };
   };
};



// spawn barricades
if (_spawnBarricades) then
{
   private ["_roads", "_road", "_obj", "_static", "_pos", "_dir"];
   
   _roads = [0.5, 0.9, 42] call _searchRoads;

   _n = 3 + (ceil (random _strength));
   if (_n > (count _roads)) then
   {
      _n = count _roads;
   };
   for "_i" from 1 to _n do
   {
      _road = _roads call RUBE_randomPop;
      _obj = _factionBarricade createVehicle (position _road);
      _obj setDir ([_obj, (direction _road)] call _barricadeOrientation);
      
      _barricades set [(count _barricades), _obj];
      
      // create static (optional)
      if (52 call RUBE_chance) then
      {
         _pos = position _obj;
         _obj setPos [(_pos select 0), (_pos select 1), (-0.15 - (random 0.1))];
         
         _pos = _obj modelToWorld [(-3 + (random 4)), -2.1, 0];
         _pos set [2, 0];
         _dir = direction _obj;
         _static = _factionMG createVehicle _pos;
         _static setDir _dir;
         _static setPos _pos;
         [(_groups select 0), _faction, _pos, _dir, "static", _static] call RUBE_AI_spawnGuard;
      };
      
      // create guards (optional)
      for "_g" from 1 to (floor (random 3)) do
      {
         _pos = _obj modelToWorld [(-4 + (random 8)), (-2.0 - (random 3.5)), 0];
         _dir = (direction _obj) + (20 - (random 40));
         [(_groups select 0), _faction, _pos, _dir, "UP"] call RUBE_AI_spawnGuard;
      };
      
      if (_debug) then
      {
         [
            ["position", (position _obj)],
            ["direction", (direction _obj)],
            ["type", "mil_arrow"],
            ["color", "ColorBlack"]
         ] call RUBE_mapDrawMarker;
      };
   };
};





// execute code if occupation is defeated
if ((typeName _onDefeat) == "CODE") then
{

};


// return??
_groups




