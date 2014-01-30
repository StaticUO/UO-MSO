/*
   Author:
    rübe
    
   Description:
    AI group subroutine to halt and watch the horizon for a bit.
    Keeps running until the job is done.
    
   Parameter(s):
    _this: group OR array [group, ...]
    
   Returns:
    script handle (subroutines have to be spawned)
*/

private ["_group", "_leader", "_formation", "_behaviour", "_observers", "_useBinocular", "_units", "_n", "_arc", "_offset", "_i", "_pos"];

_group = _this;
if ((typeName _this) == "ARRAY") then
{
   _group = _this select 0;
};

_leader = leader _group;
_formation = formation _group;
_behaviour = behaviour _leader;

if (_leader == player) exitWith {};

// private function to use binoculars
_observers = [];
_useBinocular = {
   if ((_this hasWeapon "Binocular") && (!(isPlayer _this))) then
   {
      _this playActionNow "BinocOn";
      _this disableAI "ANIM";
      _observers set [(count _observers), _this];
   };
};


// halt group leader
if (_behaviour in ["CARELESS", "SAFE"]) then
{
   _group setBehaviour "AWARE";
};
_leader forceSpeed 0;
_group setFormation (["DIAMOND", "DIAMOND", "DIAMOND", "FILE", "WEDGE", "VEE"] call RUBE_randomSelect);
sleep 1;


sleep (1 + (random 2));
_units = units _group;
// hit the dirt
{
   _x setUnitPos (["DOWN", "DOWN", "Middle", "Middle", "Middle"] call RUBE_randomSelect);
   sleep (random 0.4);
} forEach _units;
   
sleep (2 + (random 4));



// watch all directions
_units = units _group;
_n = count _units;
if (_n > 0) then
{
   _arc = 360 % _n;
   _offset = random 360;
   for "_i" from 0 to (_n - 1) do
   {
      _pos = [_leader, 200, (_offset + (_i * _arc) + (_arc * 0.5))] call BIS_fnc_relPos;
      (_units select _i) commandWatch _pos;
      sleep (1 + (random 1));
      (_units select _i) call _useBinocular;
   };
};


_leader call _useBinocular;

sleep (8 + (random 12));

{
   _x enableAI "ANIM";
   _x playActionNow "BinocOff";
   sleep (1 + (random 3));
} forEach _observers;

sleep (1 + (random 2));
_units = units _group;
{
   _x setUnitPos "AUTO";
   _x doWatch objNull;
   sleep (random 1);
} forEach _units;

// proceed
_leader forceSpeed -1;
_units commandFollow (leader _group);