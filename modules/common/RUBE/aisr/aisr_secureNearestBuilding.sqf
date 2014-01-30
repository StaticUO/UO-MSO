/*
   Author:
    rübe
    
   Description:
    AI group subroutine to secure/check nearby buildings (if
    there are any around). Keeps running until the job is done.
    
    note: if you're player in this group, you might need to reply
    with "READY" (radio 0-1) to make the group proceed/the script end.
     -> or make sure "_ready = _ready && (unitReady _x);" doesn't
        hit the/a player.
    
    TODO: clear building (make units walk to _every_ position in a 
          building).
          And maybe clear only one building..
    
   Parameter(s):
    _this: group OR array [group, ...]
    
   Returns:
    script handle (subroutines have to be spawned)
*/

private ["_group", "_leader", "_blockedBuildings", "_buildings", "_buildingPositions", "_bp", "_n", "_i", "_behaviour", "_secureBuildingPosition"];

_group = _this;
if ((typeName _this) == "ARRAY") then
{
   _group = _this select 0;
};

_leader = leader _group;

if (_leader == player) exitWith {};

_blockedBuildings = [
   "Land_vez"
];

// check if a buildings with more than one building position
// are in range and retrieve their building positions
_buildingPositions = [];
_buildings = nearestObjects [_leader, ["Building"], 75];
{
   if (!(_x in _blockedBuildings) && !([_x, "RUBE_isBurning"] call RUBE_isTrue)) then
   {
      _bp = _x call RUBE_getBuildingPositions;
      _n = count _bp;
      if (_n > 1) then
      {
         for "_i" from 1 to (_n - 1) do
         {
            _buildingPositions set [(count _buildingPositions), (_bp select _i)];
         };
      };
   };
} forEach _buildings;


// sends a guy to a given building position
// [unit, pos] => void
_secureBuildingPosition = {
   private ["_unit", "_pos"];
   _unit = _this select 0;
   _pos = _this select 1;
   
   _unit setUnitPos "AUTO";
   doStop _unit;
   _unit commandMove _pos;
   // but don't run there
   _unit forceSpeed 2.0;
   
   // register unit as engaged
   _engaged set [(count _engaged), _unit];
};


// start procedure
if ((count _buildingPositions) > 0) then
{
   private ["_units", "_engaged", "_pos"];
   _units = (units _group) - [_leader];
   _engaged = [];
   
   // upgrade behaviour if necessary
   _behaviour = behaviour _leader;
   if (_behaviour in ["CARELESS", "SAFE"]) then
   {
      _group setBehaviour "AWARE";
   };
   
   // halt
   _leader setUnitPos "Middle";
   commandStop _units;
   sleep (random 1);
   
   // hit the dirt!
   {
      _x setUnitPos (["DOWN", "Middle"] call RUBE_randomSelect);
      sleep (random 0.4);
   } forEach _units;
   
   sleep (2 + (random 4));
   
   // send units individually or in teams to building positions
   while {(((count _units) > 1) && ((count _buildingPositions) > 0))} do
   {
      if ((count _buildingPositions) > 0) then
      { 
         _pos = _buildingPositions call RUBE_randomPop;
         
         if (((count _units) > 3) && (50 call RUBE_chance)) then
         {
            // send in team
            {
               [_x, _pos] call _secureBuildingPosition;
               sleep 1;
            } forEach [
               (_units call RUBE_randomPop),
               (_units call RUBE_randomPop)
            ];
         } else 
         {
            // send a single guy
            [(_units call RUBE_randomPop), _pos] call _secureBuildingPosition;
            sleep 1;
         };
         sleep (1 + (random 3));
      };
   };
   
   // wait until everyone is done
   if ((count _engaged) > 0) then
   {
      private ["_success", "_ready"];
      _success = false;

      while {true} do
      {
         _ready = true;
         {
            _ready = _ready && ((unitReady _x) || !(alive _x) || (player == _x));
         } forEach _engaged;
         
         if (_ready) exitWith 
         { 
            _success = true; 
         };
         sleep 1;
         if (isNull _group) exitWith {};
         sleep 1;
         if ({alive _x} count (units _group) == 0) exitWith {};
         sleep 5;
      };
      
      if (_success) then
      {
         _units = units _group;
         {
            _x setUnitPos "AUTO";
            _unit forceSpeed -1;
         } forEach _units;
         _leader = leader _group;
         
         // fall back
         _leader doFollow _leader;
         _units commandFollow _leader;

         
         sleep 12;
      };
      
      // reset behaviour
      if (_behaviour in ["CARELESS", "SAFE"]) then
      {
         _group setBehaviour _behaviour;
      };
   };
};