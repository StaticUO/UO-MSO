/*
   Author:
    rübe
    
   Description:
    spawns a base/fortification entrance, returning all objects,
    static weapons to be manned, positions for guards and two joint
    points for the surrounding wall/protective barrier.
    
    The actual size of the spawned entrance will be random. While 
    the length/width is implicitly defined through the returned joint 
    points (up to 30m), the depth is unknown (up to 10m forward from 
    the center position)
    
       example blueprint:
    
                                      ^
                                      ^
                               ____   ^   ____
                              /##T#\  ^  /#T##\
              joint point -> |- ----| . |---- -| <- joint point
                                    center     
    
    
   Parameter(s):
    _this: parameters (array of array [key (string), value (any)])
    
           - required:
           
             - "position" (position)
                  Center position of the entrance, so that each returned joint 
               point should be more or less equally distant from it.

             - "direction" (scalar)
                  Entrance orientation.
             
             
           - optional:
           
             - "size" (integer from 0 to 2)
               - 0: random (default)
               - 1: infantery entrance (small)
               - 2: vehicle entrance (medium)
               - 3: special or unique vehicle entrance (don't use more than 
                    one of them for a single base, since they feature unique 
                    stuff like castle-walls, ruins, etc.)
             
             - "faction" (string in ["USMC", "CDF", "RU", "INS", "GUE"])
                   used for some side/faction variants of objects such as 
                barriers or camo nets and for static weapons of course.
                - default = GUE
                
             - "camouflage" (string in ["woodland", "desert"])
                   tries to spawn objects with suitable painting.
                - default = "woodland"
                
             - "group" (group)
                  if a group is given, static gunners and guards are 
               automatically spawned and initialized.
               
             - "setup" (array of [key (string), factor (scalar)])
                  Definition of the used building elements/objects. The outcome
               is not determined (random), unless you give boolean factors (0.0 
               or 1.0). These values are used twice: 1) for the selection of the
               blueprint to use and 2) for the selection of blueprint options.
                  Use a similar setup definition for entrances of the same base 
               and faction. And try to make up a different setup definition for 
               other factions. "quality" is particularly faction/side sensitive.
                  
               - keys in: [
                   "quality", (quality of material from cheap (0.0 for mud, rocks and wood) 
                               to exquisite (1.0 for Hbarriers and metal))
                   "camo",    (useage of camouflage/camo-nets)
                   "bunker",  (useage of strong fortifications/bunkers)
                   "static",  (useage of static weapons)
                   "tower",   (useage of watchtowers)
                   "gate",    (useage of gates/barriers for veh.-entrances)
                   "flag"     (useage of faction flag)
                ]
               - factor from 0.0 (never/not) 
                          to 1.0 (matters/preferred)
               - default: random/don't care
               
             - "select" (key (int)
                  direct access to specific blueprints
               
   Returns:
    array [
       0: "joints"  (array of two positions/joints),
       1: "objects" (array of spawned objects; not including static weapons),
       2: "static"  (array of spawned static weapons),
       3: "guards"  (array of [position, direction, duty*]; positions to spawn standing guards)
       4: "gates"   (array of gates)
    ]
    
    *duty is a string-key to run the desired initialization script or fsm for units.
       Returned string keys are:
       - "nothing" (intention: doStop, doWatch)
       - "stand" (intention: doStop, doWatch, setUnitPos "UP")
       - "crouch" (intention: doStop, doWatch, setUnitPos "Middle")
       - "down" (intention: doStop, doWatch, setUnitPos "DOWN")
       - "gatekeeper" (intention: operate the gate(s))
*/

private ["_theBlueprint", "_theWeapons", "_theGates", "_theEntrance", "_position", "_direction", "_faction", "_camouflage", "_group", "_choice", "_size", "_fQuality", "_fCamo", "_fBunker", "_fStatic", "_fTower", "_fGate", "_fFlag", "_blueprints"];

_theBlueprint = [];
_theWeapons = [];
_theGates = [];
_theEntrance = [
   [],
   [],
   [],
   [],
   []
];

_position = [0,0,0];
_direction = 0;
_faction = "GUE";
_camouflage = "woodland";
_group = grpNull;
_choice = -1;
_size = 1;

// setup
_fQuality = 0.5;
_fCamo = 0.5;
_fBunker = 0.5;
_fStatic = 0.5;
_fTower = 0.5;
_fGate = 0.5;
_fFlag = 0.5;

// read parameters
{
   switch (_x select 0) do
   {
      case "position": { _position = _x select 1; };
      case "direction": { _direction = _x select 1; };
      case "faction": { _faction = _x select 1; };
      case "camouflage": { _camouflage = _x select 1; };
      case "group": { _group = _x select 1; };
      case "select": { _choice = _x select 1; };
      case "size": { _size = _x select 1; };

      case "setup": 
      {
         {
            switch (_x select 0) do
            {
               case "quality": { _fQuality = _x select 1; };
               case "camo":    { _fCamo = _x select 1; };
               case "bunker":  { _fBunker = _x select 1; };
               case "static":   { _fStatic = _x select 1; };
               case "tower":   { _fTower = _x select 1; };
               case "gate":    { _fGate = _x select 1; };
               case "flag":    { _fFlag = _x select 1; };
            };
         } forEach (_x select 1);
      };
   };
} forEach _this;


// faction/object camouflage configuration //
private ["_factionMG", "_factionMGmini", "_factionAGS", "_factionFlag", "_factionCamoNet1", "_factionCamoNet2", "_factionCamoNet3", "_factionBarrier10x", "_factionBarrier10xTall"];

_factionMG = ["static-mg", theEntranceFaction] call RUBE_selectFactionVehicle;
_factionMGmini = ["static-mg-mini", theEntranceFaction] call RUBE_selectFactionVehicle;
_factionAGS = ["static-ags", theEntranceFaction] call RUBE_selectFactionVehicle;

_factionFlag = ["flag", _faction] call RUBE_selectFactionBuilding;
_factionCamoNet1 = ["camoNet1", _faction] call RUBE_selectFactionBuilding;
_factionCamoNet2 = ["camoNet2", _faction] call RUBE_selectFactionBuilding;
_factionCamoNet3 = ["camoNet3", _faction] call RUBE_selectFactionBuilding;
_factionBarrier10x = ["barrier10x", _faction] call RUBE_selectFactionBuilding;
_factionBarrier10xTall = ["barrier10xTall", _faction] call RUBE_selectFactionBuilding;
_factionGateIndL = ["gateIndL", _faction] call RUBE_selectFactionBuilding;

_factionWatchtower = "Land_Fort_Watchtower";
_factionArtilleryNest = "Land_fort_artillery_nest";
_factionRampart = "Land_fort_rampart";
_factionNestBig = "Land_fortified_nest_big";
_factionNestSmall = "Land_fortified_nest_small";

// ... and for the correct painting...
switch (_camouflage) do
{
   case "desert":
   {
      _factionCamoNet1 = _factionCamoNet1 call RUBE_objectInDesert;
      _factionCamoNet2 = _factionCamoNet2 call RUBE_objectInDesert;
      _factionCamoNet3 = _factionCamoNet3 call RUBE_objectInDesert;
      
      _factionWatchtower = _factionWatchtower call RUBE_objectInDesert;
      _factionArtilleryNest = _factionArtilleryNest call RUBE_objectInDesert;
      _factionRampart = _factionRampart call RUBE_objectInDesert;
      _factionNestBig = _factionNestBig call RUBE_objectInDesert;
      _factionNestSmall = _factionNestSmall call RUBE_objectInDesert;
   };
};

// some private functions... //
private ["_comboChoice", "_registerGate", "_popGate", "_specScore", "_blueprintScore", "_selectBlueprint", "_blueprints", "_i"];

// select the better set of options
// [array1, array2] => true (select 0), false (select 1)
_comboChoice = {
   private ["_avg1", "_avg2"];
   _avg1 = [(_this select 0)] call RUBE_average;
   _avg2 = [(_this select 0)] call RUBE_average;
   
   ((_avg1 + (random _avg1)) > (_avg2 + (random _avg2)))
};

// saves the last used index as a gate
// void => void
_registerGate = {
   _theGates set [(count _theGates), ((count _theBlueprint) - 1)];
   true
};

// [] => objNull or Gate
_popGate = {
   private ["_gate", "_c", "_i"];
   _gate = objNull;
   _c = count _theGates;
   if (_c > 0) then
   {
      _i = _theGates select 0;
      _theGates = _theGates - [_i];
      _gate = (_theEntrance select 1) select _i;
   };
   _gate
};

// [spec-key, value, spec] => score
_specScore = {
   private ["_r"];
   // small random amount to randomize what would
   // score equal
   _r = random 0.05;
   if ((_this select 0) in (_this select 2)) exitWith
   {
      ((_this select 1) + _r)
   };
   
   ((1 - (_this select 1)) + _r)
};

// index => score
_blueprintScore = {
   private ["_bp"];
   _bp = _blueprints select _this;
   
   ( 
      ((abs (_size - (_bp select 0))) * -10) + // critical penalty for wrong size 
      ((abs (_fQuality - (_bp select 1))) * (0.5 + (random 0.2))) + 
      (["camo", _fCamo, (_bp select 2)] call _specScore) +
      (["bunker", _fBunker, (_bp select 2)] call _specScore) +
      (["static", _fStatic, (_bp select 2)] call _specScore) +
      (["tower", _fTower, (_bp select 2)] call _specScore) +
      (["gate", _fGate, (_bp select 2)] call _specScore)
   )
};

// returns the index of the blueprint best fit according to
// the given setup criteria
_selectBlueprint = {
   private ["_index", "_score", "_i", "_s"];
   _index = 0;
   _score = -9999;
   
   for "_i" from 0 to ((count _blueprints) - 1) do
   {
      _s = _i call _blueprintScore;
      if (_s > _score) then
      {
         _index = _i;
         _score = _s;
      };
   };
   
   _index
};


// list of entrance blueprints/prototypes and their classification
// feel free to add new compositions in case you're funny...
/*
   [
      0: size,
      1: quality, 
      2: features, 
      3: blueprint-function (with side-effects/returns nothing, 
         working on _theBlueprint and _theEntrance)
   ]
*/

_blueprints = [
   //** basic bagfence entrance **//
   [
      1,
      0.05, 
      ["static", "camo"],
      {
         // joints
         _theEntrance set [0, [[-3.65, -0.51], [4.4, -0.35]]];
         // base
         [
            _theBlueprint, 
            [
               ["Land_fort_bagfence_corner", [-3.05, 1.28, 0], 90],
               ["Land_fort_bagfence_corner", [3.05, 1.55, 0], 180]
            ]
         ] call RUBE_arrayAppend;
         // optional flag
         if ((_fFlag * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionFlag, [4.85, -3.1, 0], 180]]] call RUBE_arrayAppend;
         };
         // camo option
         if ((_fCamo * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionCamoNet1, [-0.95, -0.67, -0.5], 184]]] call RUBE_arrayAppend;
         };
         // optional rampart
         if (67 call RUBE_chance) then
         {
            [_theBlueprint, [[_factionRampart, [0, 6.95, -0.55], 180]]] call RUBE_arrayAppend;
         };
         // static or guard
         if ((_fStatic * 100) call RUBE_chance) then
         {
            [_theWeapons, [[_factionMG, [-2.05, 1.25, 0], -45]]] call RUBE_arrayAppend;
         } else 
         {
            [(_theEntrance select 3), [[[-2.35, 1.25, 0], (_direction - 57), "stand"]]] call RUBE_arrayAppend;
         };
         // static or guard
         if ((_fStatic * 100) call RUBE_chance) then
         {
            [_theWeapons, [[_factionMG, [3.05 , 0.75, 0], 45]]] call RUBE_arrayAppend;
         } else 
         {
            [(_theEntrance select 3), [[[3.05, 0.75, 0], (_direction + 42), "stand"]]] call RUBE_arrayAppend;
         };
      }
   ],
   //** bunker **//
   [
      1,
      0.72,
      ["static", "bunker"],
      {
         // joints
         _theEntrance set [0, [[-8.1,0], [7.8,0]]];
         // base
         [
            _theBlueprint, 
            [
               ["Land_HBarrier3", [-7.4, 12 , 0], 0],
               ["Land_HBarrier3", [5.1, 12, 0], 0],
               ["Land_HBarrier5", [-7.3, 10.5, 0], 90],
               ["Land_HBarrier5", [7.0, 10.5, 0], 90],
               ["Land_HBarrier5", [-7.3, 4.9, 0], 90],
               ["Land_HBarrier5", [7.0, 4.9, 0], 90],
               [_factionNestBig, [0.2, 7.25, 0], 180]
            ]
         ] call RUBE_arrayAppend;
         // optional flag
         if ((_fFlag * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionFlag, [-4.2, 0.1, 0], 90]]] call RUBE_arrayAppend;
         };
         // optional bunker roof installation
         if (50 call RUBE_chance) then
         {
            [
               _theBlueprint, 
               [
                  // ramp-to-bunker-roof
                  ["Land_WoodenRamp", [-3.0, -1.43, 0.79], 180],
                  ["Land_HBarrier3", [-2.8, -1.25, -0.34], 90],
                  ["Land_WoodenRamp", [-0.2, -2.1, -0.265], 90],
                  // roof installation (left corner)
                  ["Land_BagFenceCorner", [-4.35, 9, 2.0], 270],
                  ["Land_BagFenceLong", [-2.5, 9.4, 2.0], 0],
                  ["Land_BagFenceLong", [-4.6, 7.0, 2.0], 90],
                  // roof installation (right corner)
                  ["Land_BagFenceCorner", [3.6, 9.2, 2.0], 0],
                  ["Land_BagFenceLong", [1.75, 9.4, 2.0], 0],
                  ["Land_BagFenceLong", [3.98, 7.3, 2.0], 90]
               ]
            ] call RUBE_arrayAppend;
            // bunker roof guards
            [(_theEntrance select 3), [
               [[-3.85, 8.5, 2.0], (_direction - 45), "crouch"],
               [[3.1, 8.7, 2.0], (_direction + 45), "crouch"]
            ]] call RUBE_arrayAppend;
         };
         // optional static
         if ((_fStatic * 100) call RUBE_chance) then
         {
            [_theBlueprint, [["Land_fort_bagfence_round", [0, 15, 0], 0]]] call RUBE_arrayAppend;
            [_theWeapons, [[_factionMG, [0, 13.75, 0], 0]]] call RUBE_arrayAppend;
         } else 
         {
            [_theBlueprint, [[_factionRampart, [0, 17, -0.15], 180]]] call RUBE_arrayAppend;
         };
         // bunker guard
         [(_theEntrance select 3), [
            [[-2.9, 7.6, 0], ((_direction - 10) + (random 20)), "stand"],
            [[2.13, 1.58, 0.18], ((_direction + 187) + (random 20)), "stand"]
         ]] call RUBE_arrayAppend;
      }
   ],
   //** vehicle entrance, tower/gate **//
   [
      2,
      0.78,
      ["tower", "gate", "camo", "static"],
      {
         // joints
         _theEntrance set [0, [[-9.0, -0.3], [13.45, 0.3]]];
         // base
         [
            _theBlueprint, 
            [
               ["Land_HBarrier5", [-8.65, 4.2, 0], 0],
               ["Land_HBarrier3", [-8.5, 2.7, 0], 90],
               ["Land_GuardShed", [-4.6, 1.95, 0], 270],
               [_factionWatchtower, [8.05, 3.0, 0], 90]
            ]
         ] call RUBE_arrayAppend;
         // tower guard
         [(_theEntrance select 3), [
            [[6.0, 3.4, 2.78143], _direction, "stand"]
         ]] call RUBE_arrayAppend;
         // optional flag
         if ((_fFlag * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionFlag, [11.9, -0.35, 0], 90]]] call RUBE_arrayAppend;
         };
         // optional gate
         if ((_fGate * 100) call RUBE_chance) then
         {
            [_theBlueprint, [["ZavoraAnim", [-3.65, 0.2, 0], 180]]] call RUBE_arrayAppend;
            [] call _registerGate;
            [(_theEntrance select 3), [
               [[-4.6, 1.95, 0], (_direction + 90), "gatekeeper"]
            ]] call RUBE_arrayAppend;
         } else
         {
            [(_theEntrance select 3), [
               [[-4.6, 1.95, 0], (_direction + 90), "stand"]
            ]] call RUBE_arrayAppend;         
         };
         // optional camo
         if ((_fCamo * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionCamoNet1, [-7.3, 0.6, 0], 269]]] call RUBE_arrayAppend;
         };
         // optional/variable static (on tower)
         if ((_fStatic * 100) call RUBE_chance) then
         {
            [_theWeapons, [
               [([_factionMGmini, _factionAGS] call RUBE_randomSelect), [10.65, 3.57, 2.778], 15]
            ]] call RUBE_arrayAppend;
         } else
         {
            [(_theEntrance select 3), [
               [[10.4, 3.17, 2.78143], (_direction + 35), "crouch"]
            ]] call RUBE_arrayAppend;  
         };
      }
   ],
   //** guer vehicle entrance, static/camo OR tower, gate **//
   [
      2,
      0.21,
      ["tower", "gate", "camo", "static"],
      {
         // joints
         _theEntrance set [0, [[-13.55, -4.25], [13.55, -4.25]]];
         // base
         [
            _theBlueprint, 
            [
               ["Land_fort_bagfence_long", [-3.8, 4.0, 0], 90],
               ["Land_fort_bagfence_long", [3.9, 4.0, 0], 270],
               ["Land_fort_bagfence_long", [-3.8, 1.0, 0], 90],
               ["Land_fort_bagfence_long", [3.9, 1.0, 0], 270],
               [_factionRampart, [-8.6, 3.1, -0.27], 0],
               [_factionRampart, [8.6, 3.1, -0.27], 0],
               [_factionRampart, [-11.1, 0.57, -0.27], 270],
               [_factionRampart, [11.1, 0.57, -0.27], 90]
            ]
         ] call RUBE_arrayAppend;
         // optional gate
         if ((_fGate * 100) call RUBE_chance) then
         {
            [_theBlueprint, [["ZavoraAnim", [-3.65, -0.8, 0], 180]]] call RUBE_arrayAppend;
            [] call _registerGate;
            [(_theEntrance select 3), [
               [[-4.75, 0.12, 0], (_direction + 81), "gatekeeper"]
            ]] call RUBE_arrayAppend;
         };
         // optional flag
         if ((_fFlag * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionFlag, [3.9, 5.25, 0], 0]]] call RUBE_arrayAppend;
         };
         // tower OR static/camo (left)
         if ([[_fTower], [_fStatic, _fCamo]] call _comboChoice) then
         {
            [_theBlueprint, [["Land_Misc_deerstand", [-8.5, 1.2, 0], 180]]] call RUBE_arrayAppend;
            [(_theEntrance select 3), [
               [[-8.5, 1.2, 3.1], (_direction - 21), "stand"]
            ]] call RUBE_arrayAppend;
         } else
         {
            // static OR guard
            if ((_fStatic * 100) call RUBE_chance) then
            {
               [_theWeapons, [[_factionMG, [-8.0, 2.5, 0], -15]]] call RUBE_arrayAppend;
            } else
            {
               [(_theEntrance select 3), [
                  [[-8.0, 1.74, 0], (_direction - 11), "stand"]
               ]] call RUBE_arrayAppend;
            };
            // optional camo
            if ((_fCamo * 100) call RUBE_chance) then
            {
               [_theBlueprint, [[_factionCamoNet3, [-9.64, 1.35, 0], -27]]] call RUBE_arrayAppend;
            };
         };
         // tower OR static/camo (right)
         if ([[_fTower], [_fStatic, _fCamo]] call _comboChoice) then
         {
            [_theBlueprint, [["Land_Misc_deerstand", [8.0, 1.2, 0], 180]]] call RUBE_arrayAppend;
            [(_theEntrance select 3), [
               [[8.8, 1.2, 3.1], (_direction + 19), "stand"]
            ]] call RUBE_arrayAppend;
         } else
         {
            // static OR guard
            if ((_fStatic * 100) call RUBE_chance) then
            {
               [_theWeapons, [[_factionMG, [8.0, 2.5, 0], 15]]] call RUBE_arrayAppend;
            } else
            {
               [(_theEntrance select 3), [
                  [[8.0, 1.64, 0], (_direction + 9), "stand"]
               ]] call RUBE_arrayAppend;
            };
            // optional camo
            if ((_fCamo * 100) call RUBE_chance) then
            {
               [_theBlueprint, [[_factionCamoNet3, [10.16, 1.9, 0], 209]]] call RUBE_arrayAppend;
            };
         };
         // optional side guard (left)
         if (66 call RUBE_chance) then
         {
            [(_theEntrance select 3), [
               [[-12.85, (-1.5 + (random 4)), 0.57], (_direction - 81), "crouch"]
            ]] call RUBE_arrayAppend;
         };
         
         // optional side guard (right)
         if (66 call RUBE_chance) then
         {
            [(_theEntrance select 3), [
               [[12.5, (-1.1 + (random 4)), 0.54], (_direction + 87), "crouch"]
            ]] call RUBE_arrayAppend;
         };
      }
   ],
   //** guer big vehicle entrance, tower, camo-"bunker" **//
   [
      3,
      0.2,
      ["tower", "static", "camo"],
      {
         // joints
         _theEntrance set [0, [[-27.8, -2.5], [27.8, -2.5]]];
         // base
         [
            _theBlueprint, 
            [
               [_factionRampart, [-23.1, 7.25, 0], 0],
               [_factionRampart, [23.1, 7.25, 0], 0],
               [_factionRampart, [-27.85, 2.55, 0], 270],
               [_factionRampart, [27.85, 2.55, 0], 90],
               ["Land_fort_bagfence_round", [-12.45, 10.52, 0], 0], 
               ["Land_fort_bagfence_round", [12.45, 10.52, 0], 0],
               ["Land_fort_bagfence_long", [-16.7, 7.65, 0], 335],
               ["Land_fort_bagfence_long", [16.7, 7.65, 0], 25],
               [_factionArtilleryNest, [-11.5, 0.5, 0], 175],
               [_factionArtilleryNest, [11.5, 0.5, 0], 185]
            ]
         ] call RUBE_arrayAppend;
         // optional flag
         if ((_fFlag * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionFlag, [-19.7, 3.6, 0], 90]]] call RUBE_arrayAppend;
         };
         // optional flag
         if ((_fFlag * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionFlag, [19.7, 3.6, 0], 90]]] call RUBE_arrayAppend;
         };
         // static OR guard (left)
         if ((_fStatic * 100) call RUBE_chance) then
         {
            [_theWeapons, [[_factionMG, [-12.45, 8.5, 0], -5]]] call RUBE_arrayAppend;
         } else
         {
            [(_theEntrance select 3), [
               [[-12.45, 8.1, 0], (_direction - 9), "stand"]
            ]] call RUBE_arrayAppend;
         };
         // static OR guard (right)
         if ((_fStatic * 100) call RUBE_chance) then
         {
            [_theWeapons, [[_factionMG, [12.45, 8.5, 0], 5]]] call RUBE_arrayAppend;
         } else
         {
            [(_theEntrance select 3), [[[12.45, 8.1, 0], (_direction + 4), "stand"]]] call RUBE_arrayAppend;
         };
         // optional tower (left)
         if ((_fTower * 100) call RUBE_chance) then
         {
            [_theBlueprint, [["Land_Misc_deerstand", [-23.75, 2.2, 0], 180]]] call RUBE_arrayAppend;
            [(_theEntrance select 3), [
               [[-24.0, 2.2, 3.1], (_direction - 35), "stand"]
            ]] call RUBE_arrayAppend;
         };
         // optional tower (right)
         if ((_fTower * 100) call RUBE_chance) then
         {
            [_theBlueprint, [["Land_Misc_deerstand", [23.05, 2.2, 0], 180]]] call RUBE_arrayAppend;
            [(_theEntrance select 3), [
               [[23.85, 2.2, 3.1], (_direction + 35), "stand"]
            ]] call RUBE_arrayAppend;
         };
         // optional camo; we really want this, so we mess with chances here
         if (_fCamo > 0.1) then
         {
            [_theBlueprint, [
               [_factionCamoNet2, [-11.5, 4.25, -1.0], 197],
               [_factionCamoNet2, [11.5, 4.25, -1.0], 195]
            ]] call RUBE_arrayAppend;
         };
         // main guards (or backup gunner for static)
         [(_theEntrance select 3), [
            [[-14.75, 3.5, 0], (_direction + 15), "stand"],
            [[14.75, 3.5, 0], (_direction - 15), "stand"]
         ]] call RUBE_arrayAppend;
         // optional side guards
         if (50 call RUBE_chance) then
         {
            [(_theEntrance select 3), [[[-25.3, (6.5 - (random 2)), 0.81], (_direction - 9), "crouch"]]] call RUBE_arrayAppend;
         };
         if (50 call RUBE_chance) then
         {
            [(_theEntrance select 3), [[[-27.1, (2.4 + (random 3)), 0.83], (_direction - 79), "crouch"]]] call RUBE_arrayAppend;
         };
         if (50 call RUBE_chance) then
         {
            [(_theEntrance select 3), [[[25.6, (6.5 - (random 2)), 0.81], (_direction + 7), "crouch"]]] call RUBE_arrayAppend;
         };
         if (50 call RUBE_chance) then
         {
            [(_theEntrance select 3), [[[27.1, (2.1 + (random 3)), 0.83], (_direction + 84), "crouch"]]] call RUBE_arrayAppend;
         };
      }
   ],
   //** guer small/cheap camo **//
   [
      1,
      0.05,
      ["camo"],
      {
         // joints
         _theEntrance set [0, [[-8.52, 0.2], [9.0, 0.0]]];
         // base
         [
            _theBlueprint, 
            [
               ["Land_fort_bagfence_corner", [-0.75, 6.84, 0], 270],
               ["Land_fort_bagfence_long", [-1.28, 8.97, 0], 180],
               ["Land_fort_bagfence_corner", [-5.0, 7.9, 0], 90],
               ["Land_fort_bagfence_corner", [5.0, 7.9, 0], 180],
               ["Land_fort_bagfence_long", [-5.59, 4.65, 0], 90],
               ["Land_fort_bagfence_long", [6.1, 4.2, 0], 270],
               ["Land_fort_bagfence_corner", [-6.16, 1.34, 0], 270],
               ["Land_fort_bagfence_corner", [7.2, 0.55, 0], 0]
            ]
         ] call RUBE_arrayAppend;
         // guard
         [(_theEntrance select 3), [
            [[-1.35, 6.5, 0], (_direction + 21), "stand"]
         ]] call RUBE_arrayAppend;
         // optional guard
         if (67 call RUBE_chance) then
         {
            [(_theEntrance select 3), [[[-4.25, 7.2, 0], (_direction - (90 - (random 35))), "stand"]]] call RUBE_arrayAppend;
         };
         // optional flag
         if ((_fFlag * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionFlag, [6.1, 8.4, 0], 135]]] call RUBE_arrayAppend;
         };
         // optional camo
         if ((_fCamo * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionCamoNet3, [0, 3.94, 0], 2]]] call RUBE_arrayAppend;
         };
      }
   ],
   //** guer vehicle entrance **//
   [
      2,
      0.20,
      ["camo", "tower", "static"],
      {
         // joints
         _theEntrance set [0, [[-17.44, -2.4], [13.5, -0.6]]];
         // base
         [
            _theBlueprint, 
            [
               ["Land_Ind_Timbers", [-4.1, 5.0, 0], 90],
               ["Land_Ind_Timbers", [13.21, 5.0, 0], 90],
               ["Fort_RazorWire", [-8.45, 6.7, -0.2], 0],
               ["Fort_RazorWire", [8.51, 6.7, -0.2], 0],
               ["Land_fort_bagfence_long", [-3.7, 1.2, 0], 90],
               ["Land_fort_bagfence_long", [3.9, 1.2, 0], 270],
               ["Land_fort_bagfence_long", [-3.7, 4.2, 0], 90],
               ["Land_fort_bagfence_long", [3.9, 4.2, 0], 270],
               ["Land_fort_bagfence_long", [13.7, 1.2, 0], 270],
               ["Land_fort_bagfence_long", [13.7, 4.2, 0], 270],
               ["Land_fort_bagfence_long", [-17.47, -0.7, 0], 90],
               ["Land_fort_bagfence_long", [-16.35, 2.05, 0], 135],
               ["Land_fort_bagfence_long", [-14.2, 4.2, 0], 135]
            ]
         ] call RUBE_arrayAppend;
         // guard
         [(_theEntrance select 3), [
            [[-9.7, 2.35, 0.73], (_direction - 21), "stand"]
         ]] call RUBE_arrayAppend;
         // optional gate
         if ((_fGate * 100) call RUBE_chance) then
         {
            [_theBlueprint, [["ZavoraAnim", [-3.65, -0.4, 0], 180]]] call RUBE_arrayAppend;
            [] call _registerGate;
            [(_theEntrance select 3), [
               [[-5.3, 0.45, 0], (_direction + 77), "gatekeeper"]
            ]] call RUBE_arrayAppend;
         };
         // optional flag
         if ((_fFlag * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionFlag, [6.1, 0.4, 0], 90]]] call RUBE_arrayAppend;
         };
         // optional camo
         if ((_fCamo * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionCamoNet3, [-10.01, 2.64, 0], 193]]] call RUBE_arrayAppend;
         };
         // optional tower
         if ((_fTower * 100) call RUBE_chance) then
         {
            [_theBlueprint, [["Land_Misc_deerstand", [8.05, 1.2, 0], 180]]] call RUBE_arrayAppend;
            [(_theEntrance select 3), [
               [[8.85, 1.6, 3.1], (_direction + 35), "stand"]
            ]] call RUBE_arrayAppend;
         } else
         {
            [(_theEntrance select 3), [
               [[8.85, 1.6, 0], (_direction + 35), "stand"]
            ]] call RUBE_arrayAppend;         
         };
         // optional side guards
         if (67 call RUBE_chance) then
         {
            [(_theEntrance select 3), [[[11.8, 3.99, 0.71], (_direction + 85), "crouch"]]] call RUBE_arrayAppend;  
         };
         if (67 call RUBE_chance) then
         {
            [(_theEntrance select 3), [[[5.4, 3.95, 0.7], (_direction - 12), "crouch"]]] call RUBE_arrayAppend;  
         };
         // optional static
         if ((_fStatic * 100) call RUBE_chance) then
         {
            [_theWeapons, [[_factionMG, [-13.2, 1.3, 0], -45]]] call RUBE_arrayAppend;
         };
      }
   ],
   //**  medium non-vehicle (infantery gate), tower and camo **//
   [
      1,
      0.82,
      ["camo", "tower"],
      {
         // joints
         _theEntrance set [0, [[-17.93, -0.55], [17.93, -0.35]]];
         // base 
         [
            _theBlueprint, 
            [
               ["Land_fort_bagfence_long", [-12.05, 7.28, 0], 0],
               ["Land_fort_bagfence_long", [12.04, 7.44, 0], 180],
               ["Land_fort_bagfence_round", [-16.85, 5.66, 0], 295],
               ["Land_fort_bagfence_round", [16.84, 5.82, 0], 65],
               ["Land_HBarrier3", [-15.64, 1.35, 0], 135],
               ["Land_HBarrier3", [15.64, 1.5, 0], 45],
               ["Land_HBarrier_large", [-6.35, 6.72, 0], 0],
               ["Land_HBarrier_large", [6.47, 6.72, 0], 0],
               ["Land_fort_bagfence_long", [-2.47, 4.42, 0], 90],
               ["Land_fort_bagfence_long", [2.65, 4.08, 0], 270],
               [_factionGateIndL, [-1.92, 6, 0], 180]
            ]
         ] call RUBE_arrayAppend;
         // guards
         [(_theEntrance select 3), [
            [[-12.05, 6.24, 0], (_direction + 5), "crouch"],
            [[12.04, 6.25, 0], (_direction - 7), "crouch"]
         ]] call RUBE_arrayAppend;
         // optional flag
         if ((_fFlag * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionFlag, [-15.64, 1.35, 0], 45]]] call RUBE_arrayAppend;
         };
         // optional flag
         if ((_fFlag * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionFlag, [15.64, 1.5, 0], 135]]] call RUBE_arrayAppend;
         };
         // optional tower (both or none)
         if ((_fTower * 100) call RUBE_chance) then
         {
            [_theBlueprint, [
               ["Land_vez", [-6.5, 7.15, 0], 0],
               ["Land_vez", [0.75, 7.15, 0], 0]
            ]] call RUBE_arrayAppend;
            [(_theEntrance select 3), [
               [[-3.5, 6.67, 5.05], (_direction - 20), "stand"],
               [[3.75, 6.67, 5.05], (_direction + 30), "stand"]
            ]] call RUBE_arrayAppend;
         };
         // optional static (both or none)
         if ((_fStatic * 100) call RUBE_chance) then
         {
            [_theWeapons, [
               [_factionMG, [-13.5, 4.6, 0], -45],
               [_factionMG, [13.9, 4.76, 0], 45]
            ]] call RUBE_arrayAppend;
         } else
         {
            [(_theEntrance select 3), [
               [[-13.5, 4.4, 0], (_direction - 52), "stand"],
               [[13.9, 4.56, 0], (_direction + 49), "stand"]
            ]] call RUBE_arrayAppend;
         };
         // optional camo (both or none)
         if ((_fCamo * 100) call RUBE_chance) then
         {
            [_theBlueprint, [
               [_factionCamoNet1, [-10.25, 3.58, -0.35], 181],
               [_factionCamoNet1, [10.1, 3.3, -0.35], 180]
            ]] call RUBE_arrayAppend;
         };
      }
   ],
   //** ruins/guer non-vehicle **//
   [
      1,
      0.12,
      ["camo", "static"],
      {
         // joints
         _theEntrance set [0, [[-12.2, -1.35], [11.9, -0.75]]];
         // base 
         [
            _theBlueprint, 
            [
               [_factionRampart, [-6.5, 8.12, -0.37], 180],
               [_factionRampart, [6.5, 8.14, -0.34], 180],
               ["Land_ruin_wall", [1.04, 1.5, -0.1], 90],
               ["Land_ruin_corner_2", [-9.4, 1.7, -0.15], 90],
               ["Land_ruin_walldoor", [0.0, 5.4, -0.15], 0], 
               ["Land_ruin_corner_1", [9.15, 1.7, -0.15], 270]
            ]
         ] call RUBE_arrayAppend;
         // optional flag
         if ((_fFlag * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionFlag, [11.9, -2.15, 0], 180]]] call RUBE_arrayAppend;
         };
         // optional camo
         if ((_fCamo * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionCamoNet3, [-6.24, 1.95, -0.18], 4]]] call RUBE_arrayAppend;
         };
         if ((_fCamo * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionCamoNet3, [6.0, 1.9, -0.24], 180]]] call RUBE_arrayAppend;
         };
         // static OR guard (left)
         if ((_fStatic * 100) call RUBE_chance) then
         {
            [_theWeapons, [[_factionMG, [-6.1, 4.11, 0], 0]]] call RUBE_arrayAppend;
         } else
         {
            [(_theEntrance select 3), [[[-6.1, 3.8, 0], (_direction + 4), "stand"]]] call RUBE_arrayAppend;
         };
         // static OR guard (right)
         if ((_fStatic * 100) call RUBE_chance) then
         {
            [_theWeapons, [[_factionMG, [6.75, 4.11, 0], 0]]] call RUBE_arrayAppend;
         } else
         {
            [(_theEntrance select 3), [[[6.75, 3.8, 0], (_direction + 4), "stand"]]] call RUBE_arrayAppend;
         };
         // optional guards
         if (47 call RUBE_chance) then
         {
            [(_theEntrance select 3), [[[-11.05, 1.38, 0], (_direction - 90), "stand"]]] call RUBE_arrayAppend;
         };
         if (47 call RUBE_chance) then
         {
            [(_theEntrance select 3), [[[10.89, 1.26, 0], (_direction + 90), "stand"]]] call RUBE_arrayAppend;
         };
         if (47 call RUBE_chance) then
         {
            [(_theEntrance select 3), [[[-3.39, 4.35, 0], (_direction + 5), "stand"]]] call RUBE_arrayAppend;
         };
      }
   ],
   //** massive castle wall vehicle entrance **//
   [
      3,
      0.49,
      ["camo", "tower", "bunker", "static"],
      {
         // joints
         _theEntrance set [0, [[-17.93, -0.55], [17.93, -0.35]]];
         // base 
         [
            _theBlueprint, 
            [
               ["Land_HBarrier_large", [-14.7, 2.9, 0], 90],
               ["Land_HBarrier_large", [17.3, 2.9, 0], 270],
               ["Land_A_Castle_Wall1_20", [-5.7, 8.85, -7.5], 180],
               ["Land_A_Castle_Wall1_End_2", [9.45, 8.85, -7.5], 180],
               ["Land_fort_bagfence_long", [4.15, 5.57, 0], 90],
               ["Land_fort_bagfence_long", [11.85, 5.57, 0], 270]
            ]
         ] call RUBE_arrayAppend;
         // optional flag
         if ((_fFlag * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionFlag, [3.0, 6.2, 0], 90]]] call RUBE_arrayAppend;
         };
         // optional gate
         if ((_fGate * 100) call RUBE_chance) then
         {
            [_theBlueprint, [["ZavoraAnim", [4.25, 3.58, 0], 180]]] call RUBE_arrayAppend;
            [] call _registerGate;
            [(_theEntrance select 3), [
               [[3.7, 4.8, 0], (_direction + 87), "gatekeeper"]
            ]] call RUBE_arrayAppend;
         };
         // optional tower (both or none)
         if ((_fTower * 100) call RUBE_chance) then
         {
            [_theBlueprint, [
               ["Land_vez", [-15.2, 7.0, 0], 0],
               ["Land_vez", [11.75, 7.0, 0], 0]
            ]] call RUBE_arrayAppend;
            [(_theEntrance select 3), [
               [[-12.2, 6.52, 5.05], (_direction - 20), "stand"],
               [[14.75, 6.52, 5.05], (_direction + 30), "stand"]
            ]] call RUBE_arrayAppend;
         };
         // optional camo
         if ((_fCamo * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionCamoNet2, [-7.25, 0.6, -0.65], 279]]] call RUBE_arrayAppend;
         };
         // optional bunker (though pretty important, soo...)
         if (_fBunker > 0.1) then
         {
            [_theBlueprint, [
               [_factionNestSmall, [2.75, 13.45, 0], 180],
               [_factionNestSmall, [14.25, 13.35, 0], 180],
               ["Land_fort_bagfence_long", [0.45, 10.5, 0], 90],
               ["Land_fort_bagfence_long", [15.45, 10.4, 0], 270]
            ]] call RUBE_arrayAppend;
            // static or guards
            if ((_fStatic * 100) call RUBE_chance) then
            {
               [_theWeapons, [
                  [_factionMG, [2.36, 13.4, -0.15], 0],
                  [_factionMG, [13.86, 13.4, -0.15], 0]
               ]] call RUBE_arrayAppend;
            } else
            {
               [(_theEntrance select 3), [
                  [[2.36, 13.1, 0], (_direction - 5), "none"],
                  [[13.86, 13.0, 0], (_direction + 7), "none"]
               ]] call RUBE_arrayAppend;
            };
         };
      }
   ],
   /** 10: camo-bunker-tower-extra-static vehicle entrance **/
   [
      3, 
      0.94, 
      ["bunker", "tower", "static", "camo"], 
      {
         private ["_useCamo"];
         // joints
         _theEntrance set [0, [[-19.9, -4.0], [19.8, -3.6]]];
         // base 
         [
            _theBlueprint, 
            [
               ["Land_HBarrier_large", [-19.3, 0.0, 0], 90],
               ["Land_HBarrier_large", [18.7, 0.2, 0], 270],
               ["Land_HBarrier3", [-17.0, 5.16, -0.34], 135],
               ["Land_HBarrier3", [16.44, 5.82, -0.34], 225],
               ["Land_HBarrier_large", [-8.0, 1.45, 0], 0],
               ["Land_HBarrier_large", [7.48, 1.85, 0], 180],
               ["Land_GuardShed", [4.3, -0.9, 0], 90],
               ["Land_fort_bagfence_long", [-4.17, -0.9, 0], 90],
               ["Land_fort_bagfence_long", [-4.17, 7.2, 0], 90],
               ["Land_fort_bagfence_long", [3.54, 7.2, 0], 270],
               ["Land_fort_bagfence_long", [-4.17, 4.2, 0], 90],
               ["Land_fort_bagfence_long", [3.54, 4.2, 0], 270],
               [_factionNestSmall, [-5.4, 10.2, 0], 180],
               [_factionNestSmall, [5.8, 10.2, 0], 180],
               ["Land_HBarrier_large", [-11.82, 7.64, 0], 0],
               ["Land_HBarrier_large", [11.12, 8.0, 0], 180]
            ]
         ] call RUBE_arrayAppend;
         // optional flag
         if ((_fFlag * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionFlag, [-5.3, -0.4, 0], 90]]] call RUBE_arrayAppend;
         };
         // optional gate
         if ((_fGate * 100) call RUBE_chance) then
         {
            [_theBlueprint, [["ZavoraAnim", [3.4, -2.8, 0], 0.01]]] call RUBE_arrayAppend;
            [] call _registerGate;
            [(_theEntrance select 3), [[[4.18, -1.24, 0], (_direction - 81), "gatekeeper"]]] call RUBE_arrayAppend;
         } else
         {
            [(_theEntrance select 3), [[[4.18, -1.24, 0], (_direction - 81), "stand"]]] call RUBE_arrayAppend;
         };
         // optional camo (though really cool, so...)
         _useCamo = false;
         if (_fCamo > 0.1) then
         {
            _useCamo = true;
         };
         if (_useCamo) then
         {
            [_theBlueprint, [
               [_factionCamoNet3, [-12.02, 3.5, -0.17], 187],
               [_factionCamoNet3, [11.0, 3.1, -0.17], 171],
               [_factionCamoNet1, [12.7, -4.34, -0.17], 174]
            ]] call RUBE_arrayAppend;
         };
         // optional tower
         if ((_fTower * 100) call RUBE_chance) then
         {
            [_theBlueprint, [
               [_factionWatchtower, [-9.3, -5.1, 0], 0],
               ["Land_BagFenceCorner", [-10.7, -1.74, 2.78], 270],
               ["Land_BagFenceShort", [-9.37, -1.36, 2.78], 0],
               ["Land_BagFenceCorner", [-7.9, -1.58, 2.78], 0],
               ["Land_BagFenceShort", [-10.97, -3.18, 2.78], 270],
               ["Land_BagFenceShort", [-7.52, -2.9, 2.78], 90],
               ["Land_BagFenceShort", [-10.97, -4.96, 2.78], 270],
               ["Land_BagFenceShort", [-7.52, -4.66, 2.78], 90]
            ]] call RUBE_arrayAppend;
            if (_useCamo) then
            {
               [_theBlueprint, [[_factionCamoNet3, [-15.8, -3.4, 0], 266]]] call RUBE_arrayAppend;
            };
            // tower guards
            [(_theEntrance select 3), [
               [[(-10.0 + (random 2)), -2.2, 2.78], (_direction - 33), "crouch"],
               [[-9.97, -6.56, 2.78], (_direction - 81), "stand"]
            ]] call RUBE_arrayAppend;
         };
         // must have static
         if (_fStatic > 0.1) then
         {
            [_theWeapons, [
               [_factionMG, [-5.79, 10.195, -0.15], 0],
               [_factionMG, [5.41, 10.195, -0.15], 0]
            ]] call RUBE_arrayAppend;
         } else
         {
            [(_theEntrance select 3), [
               [[-5.79, 10.195, 0], (_direction - 2), "stand"],
               [[5.41, 10.195, 0], (_direction + 4), "stand"]
            ]] call RUBE_arrayAppend;
         };
         // optional bonus side static
         if ((_fTower * 100) call RUBE_chance) then
         {
            [_theWeapons, [
               [_factionMG, [-15.6, 4.26, 0], -45],
               [_factionMG, [15.36, 4.42, 0], 45]
            ]] call RUBE_arrayAppend;
         } else
         {
            [(_theEntrance select 3), [
               [[-15.6, 4.26, 0], (_direction - 50), "stand"],
               [[15.36, 4.64, 0], (_direction + 47), "stand"]
            ]] call RUBE_arrayAppend;
         };
      }  
   ],
   /** 11: small bunker non-vehicle entrance **/
   [
      1, 
      0.44,
      ["bunker", "static", "camo"],
      {
         // joints
         _theEntrance set [0, [[-8.67, 2.9], [8.12, -2.62]]];
         // base 
         [
            _theBlueprint, 
            [
               [_factionNestSmall, [4.0, 1.5, 0], 180],
               ["Land_fort_bagfence_corner", [6.37, -2.1, 0], 0],
               ["Land_fort_bagfence_corner", [-4.0, 2.3, 0], 180],
               ["Land_fort_bagfence_long", [-7.28, 2.9, 0], 0]
            ]
         ] call RUBE_arrayAppend;
         // optional flag
         if ((_fFlag * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionFlag, [-7.5, 1.4, 0], 90]]] call RUBE_arrayAppend;
         };
         // optional camo
         if ((_fCamo * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionCamoNet3, [1.4, -0.4, -0.11], 187]]] call RUBE_arrayAppend;
         };
         // static OR guard
         if ((_fStatic * 100) call RUBE_chance) then
         {
            [_theWeapons, [[_factionMG, [3.61, 1.45, -0.15], 0]]] call RUBE_arrayAppend;
         } else
         {
            [(_theEntrance select 3), [[[3.61, 1.45, 0], (_direction + 2), "stand"]]] call RUBE_arrayAppend;
         };
         // second guard
         [(_theEntrance select 3), [[[-4.0, 1.4, 0], (_direction - 7), "stand"]]] call RUBE_arrayAppend;
      }
   ],
   /** 12: small bunker vehicle entrance **/
   [
      2,
      0.4,
      ["bunker", "static", "camo"],
      {
         // joints
         _theEntrance set [0, [[-10.67, 2.9], [10.12, -2.62]]];
         // base 
         [
            _theBlueprint, 
            [
               ["SmallTable", [-6.5, -1.7, 0], 185],
               ["Land_fort_bagfence_long", [-5.0, -1.38, 0], 90],
               ["Land_fort_bagfence_long", [3.66, -1.5, 0], 270],
               [_factionNestSmall, [6.0, 1.5, 0], 180],
               ["Land_fort_bagfence_corner", [8.37, -2.1, 0], 0],
               ["Land_fort_bagfence_corner", [-6.0, 2.3, 0], 180],
               ["Land_fort_bagfence_long", [-9.28, 2.9, 0], 0]
            ]
         ] call RUBE_arrayAppend;
         // optional flag
         if ((_fFlag * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionFlag, [7.3, -1.7, 0], 180]]] call RUBE_arrayAppend;
         };
         // optional camo
         if ((_fCamo * 100) call RUBE_chance) then
         {
            [_theBlueprint, [[_factionCamoNet3, [-11.2, 0.0, -0.11], -25]]] call RUBE_arrayAppend;
         };
         // static OR guard
         if ((_fStatic * 100) call RUBE_chance) then
         {
            [_theWeapons, [[_factionMG, [5.61, 1.45, -0.15], 0]]] call RUBE_arrayAppend;
         } else
         {
            [(_theEntrance select 3), [[[5.61, 1.45, 0], (_direction + 2), "stand"]]] call RUBE_arrayAppend;
         };
         // guards
         [(_theEntrance select 3), [
            [[-7.7, 1.4, 0], (_direction - 4), "crouch"],
            [[-6.5, -2.1, 0], (_direction + 19), "stand"]
         ]] call RUBE_arrayAppend;
      }
   ]
   /*
   [
      1,
      0.5,
      [],
      {}
   ]
   */
];
/********************[END BLUEPRINTS]************************************/



/*
//--
// debug list blueprints joint-distance
private ["_i", "_bp"];
for "_i" from 0 to ((count _blueprints) - 1) do
{
   _bp = _blueprints select _i;
   [] call (_bp select 3);

   diag_log format["BP%1: (size: %2)", _i, (_bp select 0)];
   diag_log format["  %1: (dist: %2)", _i, (((_theEntrance select 0) select 0) distance ((_theEntrance select 0) select 1))];
   
   // reset blueprint
   _theEntrance = [[],[],[],[],[]];
   _theBlueprint = [];
   _theWeapons = [];
};
//--
*/




// select blueprint ...
if ((_choice < 0) || (_choice > ((count _blueprints) - 1))) then
{
   _choice = [] call _selectBlueprint;
};

// prepare ...
[] call ((_blueprints select _choice) select 3);

// spawn the entrance
_theEntrance set [1, ([
   _position,
   _direction,
   _theBlueprint
] call RUBE_spawnObjects)];

// spawn static weapons
if ((count _theWeapons) > 0) then
{
   _theEntrance set [2, ([
      _position,
      _direction,
      _theWeapons
   ] call RUBE_spawnObjects)];
};

// translate joint points
for "_i" from 0 to ((count (_theEntrance select 0)) - 1) do
{
   (_theEntrance select 0) set [
      _i,
      ([
         _position, 
         ((_theEntrance select 0) select _i),
         _direction
      ] call RUBE_gridOffsetPosition)
   ];
};



// spawn gunners and guards (if a group is given)
if (!(isNull _group)) then
{
   private ["_pos", "_gate"];
   
   // spawn guards
   {
      _pos = [_position, (_x select 0), _direction] call RUBE_gridOffsetPosition;
      switch ((_x select 2)) do
      {
         case "gatekeeper":
         {
            [_group, _faction, _pos, (_x select 1), (_x select 2), ([] call _popGate)] call RUBE_AI_spawnGuard;
         };
         default
         {
            [_group, _faction, _pos, (_x select 1), (_x select 2)] call RUBE_AI_spawnGuard;
         };
      };
   } forEach (_theEntrance select 3);
   
   // man static weapons
   {
      [_group, _faction, [], 0, "static", _x] call RUBE_AI_spawnGuard;
   } forEach (_theEntrance select 2);
};

// return the entrance
_theEntrance