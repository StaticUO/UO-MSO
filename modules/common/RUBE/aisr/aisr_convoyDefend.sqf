/*
   Author:
    rübe
    
   Description:
    AI convoy group routine to react to attacks/ambushes.
    That is, halt, fight and hopefully survive... 
    
     - the convoy consists of a single group with multiple
       vehicles.
       
     - vehicles without gunner will stop on enemy contact
     
     - cargo units disembark (cargo units from vehicles with
       gunners aren't forced to though)
       
     - the convoy proceeds (or the script terminates) as soon
       as all known enemies are either dead or far enough away
    
    
    Convoy Tips:
     
     - initial vehicle placement is absolutely crucial. I suggest
       to use RUBE_findRoute and place the vehicles at every 9th
       road-object along the route. The direction can be easily
       computed (from the current to the next road element).
       
     - also make sure the first waypoint is not at the inital
       convoy position for this will easily cause a massive
       chaos since the leader might command to reorganize for
       some reason.
     
     - lets have some spare cargo room in case a vehicle can't
        move anymore. Aslong as that crew will fit into some 
        other vehicle, everything will be fine and the damaged
        vehicle simply will be abandoned.
     
     - make sure unit transports have medics on board, so possibly
       injured units may be heald (AI leader will command them to 
       do so). This might speed up the convoy a lot after contact.
    
    
   Parameter(s):
    _this: group or array [group, ...]
    
   Returns:
    script handle (subroutines have to be spawned)
*/

private ["_group", "_vehicleData", "_vehicles", "_roles", "_currentTargets", "_trigger"];

_group = _this;

if ((typeName _this) == "ARRAY") then
{
   _group = _this select 0;
};

_vehicleData = _group call RUBE_getGroupVehicles;
_vehicles = _vehicleData select 0;
_roles = _vehicleData select 1;

_currentTargets = [];

_trigger = objNull;


// configuration
private["_timeoutTargets", "_timeoutGetIn", "_t0", "_safetyDistance"];

_timeoutTargets = 90; // refresh currentTargets timeout
_timeoutGetIn = 180; // get-in again timeout after targets are eliminated
_t0 = time;
_safetyDistance = 0;


// private functions
private ["_refreshTargets", "_stillInDanger"];

_refreshTargets = {
   _currentTargets = _group call RUBE_getEnemyContact;
   
   if ((count _currentTargets) == 0) exitWith {};
   
   // set safety distance based on threat
   //  4: men, 5: cars, 6: tanks, 7: air, 8: other
   switch (true) do
   {
      case ((count (_currentTargets select 7)) > 0):
      {
         _safetyDistance = 1000;
      };
      case ((count (_currentTargets select 6)) > 0):
      {
         _safetyDistance = 500;
      };
      case ((count (_currentTargets select 5)) > 0):
      {
         _safetyDistance = 300;
      };
      default
      {
         _safetyDistance = 200;
      };
   };
};

_stillInDanger = {
   private ["_inDanger", "_danger", "_contact"];

   _inDanger = false;
   
   if ((count _currentTargets) == 0) exitWith { _inDanger };
   
   {
      _contact = _x select 4;
      _danger = false;
      
      if (alive _contact) then
      {
         {
            if ((_contact distance _x) < _safetyDistance) exitWith
            {
               _danger = true;
            };
         } forEach _vehicles;
      };
      
      if (_danger) exitWith 
      {
         _inDanger = true;
      };
   } forEach (_currentTargets select 1);
   
   _inDanger
};



[] call _refreshTargets;
sleep 0.05;

// quit if all enemy contacts are already dead!
if (!([] call _stillInDanger)) exitWith {};

/*************************************************/
// initial reaction
_trigger = [
   ["position", (position (_vehicles call RUBE_randomSelect))],
   ["type", [(side _group), "GUARDED"]]
] call RUBE_createTrigger;

[
   ["group", _group],
   ["type", "HOLD"],
   ["behaviour", "COMBAT"],
   ["combatMode", "YELLOW"],
   ["speed", "LIMITED"]
] call RUBE_updateWaypoint;

{
   private ["_veh"];
   _veh = _x;
   
   // halt all vehicles without gunner
   // TODO: maybe react differently if tanks/air
   // is in currentTargets... move aside/away from the road?
   if (isNull (gunner _veh)) then
   {
      _x forceSpeed 0;
      
      // disembark all units in cargo
      /*
      _veh spawn {
         waitUntil{((speed _this) < 5)};
         (assignedCargo _this) orderGetIn false;
      };
      */
      
      { 
         commandGetOut _x;
         (assignedCargo _x) orderGetIn false;
      } forEach (assignedCargo _veh);      
   };
} forEach _vehicles;








/*************************************************/
// dealing with the threat
//  _currentTargets: 
//  0: sum, 1: contacts (0: pos, 1: type, 2: side, 3: cost, 4: object, 5: pos accuracy), 
//  2: dist, 3: knowsAbout, 
//  4: men, 5: cars, 6: tanks, 7: air, 8: other
while {([] call _stillInDanger)} do
{
   // refresh currentTargets
   if ((time - _t0) > _timeoutTargets) then
   {
      [] call _refreshTargets;
   };
   
   // TODO: something? for now we have the
   // default AI fighting behaviour...
   // maybe we should assign currentTargets as targets
   // maybe not.. :/ to be observed :|
   //
   // -> seems quite fine with the guard-trigger/hold-waypoint
   
   sleep (5 + (random 5));
};


/*************************************************/
// clean up/ready up
deleteVehicle _trigger;

(units _group) allowGetIn true;
(units _group) orderGetIn true;

// stop ALL vehicles now, until everyone is on board again
// otherwise lead vehicles might just drive away (since most
// likely have no cargo and thus are much faster/ready again)
{
   _x forceSpeed 0;
} forEach _vehicles;

[
   ["group", _group],
   ["type", "MOVE"],
   ["combatMode", "GREEN"],
   ["behaviour", "SAFE"],
   ["speed", "FULL"]
] call RUBE_updateWaypoint;

_t0 = time;

while {true} do
{   
   // EXIT: all are in a vehicle again
   if (({!((!(alive _x)) || ((alive _x) && ((vehicle _x) != _x)))} count (units _group)) == 0) exitWith {};
   sleep 1;
   
   //diag_log format[" - %1 units still out there", ({!((!(alive _x)) || ((alive _x) && ((vehicle _x) != _x)))} count (units _group))];
   
   // EXIT: all vehicles have been destroyed
   if (({(alive _x)} count _vehicles) == 0) exitWith {};
   sleep 1;
   
   // EXIT: timeout to catch all sort of things 
   // (like not enough cargo left, stuck AI, or whatever...)
   if ((time - _t0) > _timeoutGetIn) exitWith {};
   
   sleep (10 + (random 4));
   
   [
      ["group", _group],
      ["type", "MOVE"],
      ["combatMode", "GREEN"],
      ["behaviour", "SAFE"],
      ["speed", "FULL"]
   ] call RUBE_updateWaypoint;
   
   sleep 0.5;
   
   (units _group) allowGetIn true;
   (units _group) orderGetIn true;
};


{
   _x forceSpeed -1;
} forEach _vehicles;

[
   ["group", _group],
   ["type", "MOVE"],
   ["behaviour", "AWARE"],
   ["combatMode", "GREEN"],
   ["speed", "LIMITED"]
] call RUBE_updateWaypoint;
