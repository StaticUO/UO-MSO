/*
   Author:
    rübe
    
   Description:
    returns a (hopefully) appropriate position for a military
    camp (enough flat-empty space, prefering forests, and hills, 
    distant from roads or locations => rear areas).
    
    search in detail:
     
     1) search an environment with selectBestPlaces and
        environment expressions favoring forests, hills 
        and/or meadows. 
        Request N positions, filter out bad ones,
        pick one randomly.
        
     2) search the nearest flat-empty space, distant from
        roads and locations. Back to step 1 on failure...
        
        if the env. expression pool is empty, we refill
        it with the original ones, weaken the search
        restrictions and start over again...
        
        .. which means that the returned position could 
        be easily out of the given range/radius, depending
        on the set restrictions (like setting the 
        locationDistance to 2km and similar stuff..)
    
   Parameter(s):
    _this: parameters (array of array [key (string), value (any)])
    
           - required:
           
             - "position" (position)
             
           - optional:
             
             - "radius" (scalar in m)
               - max. search radius; might not be respected since 
                 we're always gonna return a position (increasing 
                 the radius if needed).
               - default: 1000m
               
             - "area" (scalar in m)
               - min. radius for the main flat-empty camp area
                 (or sample radius if you will)
               - default: 8m
               
             - "gradient" (scalar from 0.0 to 1.0)
               - max. gradient for the main flat-empty camp area
               - default: 0.34
               
             - "roadDistance" (scalar)
               - 0: doesn't matter/no check
               - n > 0: minimal distance to any roads 
               - default: 200
               
             - "locationDistance" (scalar)
               - 0: doesn't matter/no check
               - n > 0: minimal distance to nearest location
               - default: 650
               
             - "locations" (array of strings)
               - define what is considered a location
               - affects "locationDistance"
               - default: ["NameCityCapital", "NameCity", "NameVillage"]
               
             - "blacklist" (array of positions)
             
             - "blacklistDistance" (scalar)
               
             - "expressions" (array of expressions)
               - overwrites the default expression pool.
   
   Returns:
    position
*/

private ["_searchCenter", "_searchRadius", "_sampleDistance", "_envRadius", "_envGradient", "_envFilter", "_sampleRadius", "_roadDistance", "_locationDistance", "_locationDefinition", "_expressionPool", "_expressions", "_iteration", "_blacklist", "_blacklistDistance"];

_searchCenter = [0,0,0];
_searchRadius = 1000;

_sampleRadius = 30;
_sampleDistance = 50;

_envRadius = 120;
_envGradient = 0.34;
_envFilter = {
   ((_this select 1) > 1.0)
};

_roadDistance = 200;
_locationDistance = 650;
_locationDefinition = [
   "NameCityCapital",
   "NameCity",
   "NameVillage"
];

_blacklist = [];
_blacklistDistance = 500;

_expressionPool = [
   "(2 * trees) - (1 * hills) - (1 * meadow) - (1 * houses) - (10 * sea)",
   "(3 * forest) - (2 * hills) - (2 * houses) - (10 * sea)",
   "(3 * forest) + (2 * trees) - (5 * meadow) + (3 * hills) - (5 * houses) - (10 * sea)",
   "(1 * forest) + (1 * trees) - (1 * meadow) + (5 * hills) - (5 * houses) - (10 * sea)",
   "(5 * forest) + (2 * trees) - (1 * meadow) - (5 * houses) - (10 * sea)"
];
_expressions = [];
_iteration = -1;

// read parameters
{
   switch (_x select 0) do
   {
      case "position": { _searchCenter = _x select 1; };
      case "radius": { _searchRadius = _x select 1; };
      case "area": { _sampleRadius = _x select 1; };
      case "gradient": { _envGradient = _x select 1; };
      case "roadDistance": { _roadDistance = _x select 1; }; 
      case "locationDistance": { _locationDistance = _x select 1; };
      case "locations": { _locationDefinition = _x select 1; };
      case "blacklist": { _blacklist = _x select 1; };
      case "blacklistDistance": { _blacklistDistance = _x select 1; };
      case "expressions": { _expressionPool = _x select 1; };
   };
} forEach _this;



private ["_findEnvironment", "_findCampPosition", "_theCampPosition", "_theCampEnvironment"];

// -> position OR empty array
_findEnvironment = {
   private ["_places"];
   
   // init/refill expression pool
   if ((count _expressions) == 0) then
   {
      _expressions = +_expressionPool;
      _iteration = _iteration + 1;
   };
   
   // weaken restrictions after expression pool
   // has been refilled 
   if (_iteration > 0) then
   {
      //_searchRadius = _searchRadius * 1.2;
      _envRadius = _envRadius * 1.5;
   };
   
   _places = selectBestPlaces [
      _searchCenter,
      _searchRadius,
      (_expressions call RUBE_randomPop),
      20, // precision
      30  // number of places
   ];
   
   _places = [_places, _envFilter] call RUBE_arrayFilter;
   
   /*
   diag_log "-----------------------";
   {
      diag_log _x;
   } forEach _places;
   */
   
   if ((count _places) > 0) exitWith
   {
      ((_places call RUBE_randomSelect) select 0)
   };
   
   []
};

// position -> position OR empty array
_findCampPosition = {
   private ["_positions"];
   _positions = [
      ["position", _this],
      ["number", 8],
      ["range", [0, _envRadius]],
      ["objDistance", _sampleRadius],
      ["posDistance", _sampleDistance],
      ["roadDistance", _roadDistance],
      ["locationDistance", _locationDistance],
      ["locations", _locationDefinition],
      ["blacklist", _blacklist],
      ["blacklistDistance", _blacklistDistance],
      ["maxGradient", _envGradient],
      ["adjustPos", (10 + (random 10))]
   ] call RUBE_randomCirclePositions;
   
   if ((count _positions) > 0) exitWith
   {
      (_positions call RUBE_randomSelect)
   };
   
   []
};

_theCampPosition = [];
_theCampEnvironment = [];

while {true} do
{
   while {((count _theCampEnvironment) == 0)} do
   {
      _theCampEnvironment = [] call _findEnvironment;
   };
   
   _theCampPosition = _theCampEnvironment call _findCampPosition;
   
   if ((count _theCampPosition) > 0) exitWith {}; 
   _theCampEnvironment = [];
};

_theCampPosition