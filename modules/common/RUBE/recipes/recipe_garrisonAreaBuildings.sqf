/*
   Author:
    rübe
    
   Description:
    searches military objects/strategic buildings (such as bunkers, towers, ...) 
    in a given area, to garrision them with units from a given faction.
    
   Parameter(s):
    _this: parameters (array of array [key (string), value (any)])
    
           - required:   
           
             - "position" (position)
             
             - "faction" (string)
             
           - optional:  
             
             - "radius" (scalar in meter)
               - default = 1000
               
             - "chance" (scalar from 0.0 to 1.0)
                  chance that a units gets spawned.
               - default = 1.0;
             
             - "group" (group)
               - join spawned units to an already existing group.
               - default = new group
             
             - "side" (side)
                  if no side is passed, the groups will be created for the
                default fractions side.
   
   Returns:
    group OR grpNull (if no objects where found to spawn units in)
*/

private ["_position", "_radius", "_chance", "_faction", "_group", "_newGroup", "_classes", "_objects", "_factionInfo", "_garrisonObject"];

_position = [];
_radius = 1000;
_chance = 1.0;

_faction = "";
_side = "";
_group = grpNull;
_newGroup = false;

// classes of static objects to search for in the given area...
_classes = [
   "Land_Fort_Watchtower", "Land_Fort_Watchtower_EP1",
   "Land_fortified_nest_big", "Land_fortified_nest_big_EP1",
   "Land_fortified_nest_small", "Land_fortified_nest_small_EP1",
   "Land_vez"
];

{
   switch (_x select 0) do
   {
      case "position": { _position = _x select 1; };
      case "radius": { _radius = _x select 1; };
      case "faction": { _faction = _x select 1; };
      case "group": { _group = _x select 1; };
      case "chance": { _chance = _x select 1; };
   };
} forEach _this;

// map/scale chance for RUBE_chance
_chance = _chance * 100;

// function to garrison the objects
_garrisonObject = {
   private ["_class", "_unit", "_pos", "_dir", "_offset"];
   _class = typeOf _this;
   
   if (_chance call RUBE_chance) then
   {
      switch (true) do
      {
         case (_class in ["Land_Fort_Watchtower", "Land_Fort_Watchtower_EP1"]): 
         {
            _pos = _this modelToWorld [(1.0 - (random 2)), -1.75, 1.08];
            _dir = (direction _this) + 190 - (random 20);
            _unit = [_group, _faction, _pos, _dir, "stand"] call RUBE_AI_spawnGuard;
            
            if (37 call RUBE_chance) then
            {
               _pos = _this modelToWorld [(1.0 - (random 2)), (2 - (random 4)), -1.78];
               _dir = random 360;
               _unit = [_group, _faction, _pos, _dir, "stand"] call RUBE_AI_spawnGuard;
            };
            
            if (37 call RUBE_chance) then
            {
               _pos = _this modelToWorld [(1.0 - (random 2)), (1.05 + (random 1.5)), 1.08];
               _dir = (direction _this) - 25 + (random 50);
               _unit = [_group, _faction, _pos, _dir, "crouch"] call RUBE_AI_spawnGuard;
            };
         };
         case (_class in ["Land_fortified_nest_big", "Land_fortified_nest_big_EP1"]): 
         {
            _offset = [
               [3.0, (-3.25 - (random 0.3)), 0],
               [-2.0 - (random 1.25), -3.55, 0]
            ];
            _pos = _this modelToWorld (_offset call RUBE_randomPop);
            _dir = (direction _this) - 190 + (random 20);
            _unit = [_group, _faction, _pos, _dir, "stand"] call RUBE_AI_spawnGuard;
            
            if (37 call RUBE_chance) then
            {
               _pos = _this modelToWorld (_offset call RUBE_randomPop);
               _dir = (direction _this) - 190 + (random 20);
               _unit = [_group, _faction, _pos, _dir, "stand"] call RUBE_AI_spawnGuard;
            };
            
            if (37 call RUBE_chance) then
            {
               _pos = _this modelToWorld [1.9 - (random 3.4), 2.85, 0];
               _dir = (direction _this) - 20 + (random 40);
               _unit = [_group, _faction, _pos, _dir, "crouch"] call RUBE_AI_spawnGuard;
            };
         };
         case (_class in ["Land_fortified_nest_small", "Land_fortified_nest_small_EP1"]): 
         {
            _pos = _this modelToWorld [(0.5 - (random 1)), -0.85, -0.78];
            _dir = (direction _this) - 185 + (random 10);
            _unit = [_group, _faction, _pos, _dir, "crouch"] call RUBE_AI_spawnGuard;
         };
         case (_class == "Land_vez"): 
         {
            _pos = _this modelToWorld [0, 1.2, 3.0];
            _dir = (direction _this) + 10 - (random 20);
            _unit = [_group, _faction, _pos, _dir, "stand"] call RUBE_AI_spawnGuard;
         };
      };
   };
};


// retrieve objects in area
_objects = nearestObjects [_position, _classes, _radius];

if ((count _objects) > 0) then
{
   // init side
   _factionInfo = _faction call RUBE_selectFactionInfo;
   if ((typeName _side) != "SIDE") then
   {
      _side = _factionInfo select 0;
   };
   
   // create group if non is given already
   if (isNull _group) then
   {
      _group = (createGroup _side);
      _newGroup = true;
   };
   
   // garrison buildings/objects
   {
      _x call _garrisonObject;
   } forEach _objects;
};

// delete group if no units were spawned...
if (_newGroup && !(isNull _group)) then
{
   if ((count (units _group)) == 0) then
   {
      deleteGroup _group;
      _group = grpNull;
   };
};

// return group
_group