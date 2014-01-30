/*
   Author:
    rübe
    
   Description:
    AI group subroutine to wait/stop and regroup.
    
   Parameter(s):
    _this: group OR array [group, ...]
    
   Returns:
    script handle (subroutines have to be spawned)
*/

private ["_group", "_timeout", "_t0", "_leader", "_units", "_groupSize", "_hitTheDirt", "_dist", "_ready", "_r", "_pos"];

_group = _this;
_timeout = 60;

if ((typeName _this) == "ARRAY") then
{
   _group = _this select 0;
};

_leader = leader _group;
_units = units _group;
_groupSize = count _units;

if (_leader == player) exitWith {};
if (_groupSize < 1) exitWith {};

// some private functions
_hitTheDirt = {
   _this setUnitPos (["DOWN", "DOWN", "Middle", "Middle", "Middle"] call RUBE_randomSelect);
};


// halt leader/wait for others to regroup
_leader forceSpeed 0;
_leader call _hitTheDirt;
_units commandFollow _leader;

// filter units (no leader, no player, ...)
_units = [
   _units, 
   {
      if (_this == player) exitWith { false };
      if (_this == _leader) exitWith { false };
      if (!(canStand _this)) exitWith { false };
      true
   }
] call RUBE_arrayFilter;


// make them run, those lazy bones...
_dist = (ceil (_groupSize * 0.5)) * 7;
{
   //diag_log format["REGROUP: (unit %1) (leader: %2) (dist: %3)", _x, _leader, (_x distance _leader)];

   if ((_x distance _leader) > _dist) then
   {
      _pos = [(position _leader), [4,4], [12, 12]] call RUBE_randomizePos;
      _x doMove _pos;
   } else
   {
      _x call _hitTheDirt;
   };
} forEach _units;


// wait until every one is ready
_ready = false;
_t0 = time;
while {!_ready} do
{
   _ready = true;
   {
      _r = (unitReady _x) || !(alive _x);
      // change stance if ready
      if (_r) then
      {
         _x call _hitTheDirt;
      };
      if (!(canStand _x)) then
      {
         _r = true;
      };
      _ready = _ready && _r;
      sleep 0.25;
   } forEach _units;
   sleep (2 + (random 1));
   
   if ((time - _t0) > _timeout) exitWith {};
};


// proceed
_leader forceSpeed -1;
_units doFollow (leader _group);

{
   _x setUnitPos "AUTO";
} forEach (units _group);