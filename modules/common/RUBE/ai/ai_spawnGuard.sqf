/*
   Author:
    rübe
    
   Description:
    spawns a basic soldier to do guard duty, standing, crouching, lying 
    down or behind a static weapon...
    
   Parameter(s):
    _this select 0: group (group)
    _this select 1: faction (string)
    _this select 2: position (array)
    _this select 3: direction (scalar)
    _this select 4: duty-key (string, optional)
                    - duty-keys:
                      - "nothing" (no watch direction "lock", random stance/posture)
                      - "stand" 
                      - "crouch"
                      - "down" 
                      - "static"
                      - "gatekeeper"
    _this select 5: static weapon or gate (object, optional)
                    - has to be indicated with the correct
                      duty-key
               
   Returns:
    unit
*/

private ["_group", "_faction", "_position", "_direction", "_roles", "_class", "_unit", "_default", "_posture", "_target"];

_group = _this select 0;
_faction = _this select 1;
_position = _this select 2;
if ((count _position) == 0) then
{
   _position = [0, 0, 0];
};
_direction = _this select 3;

// pool of roles to randomly pick from...
_roles = ["r"];
if ((count _this) > 4) then
{
   if (!((_this select 4) in ["static", "gatekeeper"])) then
   {
      [_roles, ["r", "r", "ar", "grenadier", "mg", "lat"]] call RUBE_arrayAppend;
   };
};
_class = _roles call RUBE_randomSelect;

_unit = [_class, _faction, _group, _position] call RUBE_spawnFactionUnit;

if ((count _this) > 4) then
{
   _default = true;
   _posture = "";
   _target = true;
   
   switch (_this select 4) do
   {
      case "stand": { _posture = "UP"; };
      case "crouch": { _posture = "Middle"; };
      case "down": { _posture = "DOWN"; };
      case "static": 
      {
         _default = false;
         _target = [(position (_this select 5)), 50, (direction (_this select 5))] call BIS_fnc_relPos;
         doStop _unit;
         _unit moveInGunner (_this select 5);
         _unit doWatch _target;
         _target = false;
      };
      case "gatekeeper":
      {
         // TODO: open gate for friendlies, close it again fsm
         // also the selection might have another name...
         (_this select 5) animate ["Bargate", 1.0];
      };
      case "nothing":
      {
         _target = false;
         if (40 call RUBE_chance) then
         {
            _posture = "Middle";
         };
      };
   };
   
   // default watch
   if (_default) then
   {
      doStop _unit;
      _unit setDir _direction;
      _unit setPos _position;
      if (_target) then
      {
         _target = [_position, 50, _direction] call BIS_fnc_relPos;
         _unit doWatch _target;
      };
   };
   // posture
   if (_posture != "") then
   {
      _unit setUnitPos _posture;
   };
} else 
{
   // no duty
   _unit setDir _direction;
   _unit setPos _position;
};

_unit