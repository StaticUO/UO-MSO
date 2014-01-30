/*
   Author:
    rübe
    
   Description:
    recipe for a forest camp
    
   Parameter(s):
    _this: parameters (array of array [key (string), value (any)])
    
           - required:
           
             - "position" (position)
             
             - "size" (int OR array [occupied (int), capacity (int)])
                -> capacity is the number of units living in the camp
                -> occupied is the number of AI that will be created/spawned
                   e.g. [0/10] == empty 10-men camp
                        [4/4] == small camp, 4 units will be spawned
                        4 => [4/4] ^^
                        
             - "faction" (string in ["USMC", "CDF", "RU", "INS", "GUE"])
             
           - optional:
           
             - "buildings" (array of [string-class, init-code])
             
             - "vehicles" (array of [string-class, init-code])
             
             - "behaviour" (string in ["safe", "alert", "combat"]
               - initial behaviour/camp state
               - default = safe
               
             - "activities" (array of array [activity (string), priority (int)])
               - activities in: ["rest", "work", "patrol", "defend"]
               - priority: 0 (never) to 1 (always)
             
   Example:
    -
   
   Returns:
    array [???]
*/

private ["_pos", "_size", "_faction", "_buildings", "_vehicles", "_behaviour", "_activities"];

_pos = [0,0,0];
_size = [0,0];
_faction = "USMC";
_buildings = [];
_vehicles = [];
_behaviour = "safe";
_activities = [
   "rest",
   "work",
   "patrol",
   "defend"
];


// read parameters
{
   switch (_x select 0) do
   {
      case "position": { _pos = _x select 1; };
      case "faction": { _faction = _x select 1; };
      case "size": 
      { 
         if ((typeName (_x select 1)) == "ARRAY") then
         {
            _size = _x select 1;
         } else {
            _size = [(_x select 1), (_x select 1)];
         };
      };
      case "buildings":  { _buildings= _x select 1; };
      case "vehicles":  { _vehicles = _x select 1; };
      case "behaviour": { _behaviour = _x select 1; };
   };
} forEach _this;


private ["_infrastructure"];

// spacing (min dist to next object), 
_infrastructure = [];


/*
   LIVING QUARTERS: tents depending on the camp's capacity,
   min. 12 units needed to use regular tents.
   
    tent-lightweight (ACamp, 1; Land_A_tent, 1;) OR 
    tent (Camp, 4; CampEast, 6; Land_tent_east, 6)
*/

private ["_smallTents", "_smallTentType", "_regularTents", "_regularTentType", "_regularTentSize", "_barrelPool", "_barrels", "_backpacks"];

_smallTents = 0;
_smallTentType = ["tent-lightweight", _faction] call RUBE_selectFactionBuilding;

_regularTents = 0;
_regularTentType = ["tent", _faction] call RUBE_selectFactionBuilding;
_regularTentSize = 6;
if (_regularTentType == "Camp") then { _regularTentSize = 4; };

if ((_size select 1) > 11) then
{
   _smallTents = (_size select 1) % _regularTentSize;
   _regularTents = ((_size select 1) - _smallTents) / _regularTentSize;
} else {
   _smallTents = _size select 1;
};

_barrelPool = ["Land_Barrel_empty", "Land_Barrel_sand", "Land_Barrel_water"];
_barrels = ceil ((_size select 1) * (0.5 + (random 0.5)));

// backpack heaps only for small (less organized) camps
if ((_size select 1) < 7) then
{
   _backpacks = ceil ((_size select 1) * (0.5 + (random 0.5)));
   // Misc_Backpackheap
};



/*
   MEETING/SOCIAL RELAX-ZONE (campfire) 
*/
if ((_size select 1) > 6) then
{

};



/*
   ARMORY
    - random/standard based on capacity OR
    - well defined based on given weaponPool
*/




/*
   MEETING/STRATEGIC "ROOM"
    - Notice_board
     - FoldTable, FoldChair (USMC, RU)
     - SmallTable, WoodChair (CDF, INS, GUE)
*/

if ((_size select 1) > 10) then
{

};



/*
   STORAGE/BUILDING "ROOM"
   - Misc_cargo_cont_net1, Misc_cargo_cont_net2, Misc_cargo_cont_net3, 
     Misc_cargo_cont_small
   - Misc_cargo_cont_small2, Misc_cargo_cont_tiny 
   - Misc_concrete_High, Misc_palletsfoiled, Misc_palletsfoiled_heap
   - Fort_Crate_wood
   - Barrels
   
   - PowGen_Big
*/



/*
   VEHICLE SERVICE POINT
   - Misc_TyreHeap
*/

private ["_vehBarrelPool", "_vehBarrels"];

if ((count _vehicles) > 0) then
{
   _vehBarrelPool = ["Barrel1", "Barrel4", "Barrel5"];
   _vehBarrels = ceil ((count _vehicles) * (0.75 + (random 1.25)));
};


/*
   COMMUNICATIONS PLACE (search clearance)
   - Land_Antenna
*/



