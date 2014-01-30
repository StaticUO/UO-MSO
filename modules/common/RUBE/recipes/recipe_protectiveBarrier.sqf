/*
   Author:
    rübe
   
   Description:
    spawns a protective barrier/wall around a polygonal area, 
    defined implicitly as a cluster of objects (convex hull) 
    or explicitly as positions
    
   Parameter(s):
    _this: parameters (array of array [key (string), value (any)])
    
           - required:
           
             - "area" (array of objects OR 
                       array of [object, class-string] OR
                       array of [position, direction, class-string] OR
                       array of positions)
                  the definition of the area we're going to put the 
               protective barrier around. (see RUBE_convexHull for
               further details)
               
               
           - optional:
    
             - "entrances" (integer OR array of [scalar, integer])
                  defines the number of entrances, their orientation and
               size.
                Given
                 - an integer: N entrances; auto. orientation and 
                   size.
                 - an array of [dir, size]: N entrances with well 
                   defined orientation and size.
               
               > entrance "size" values:
                 - 1: person entrance ~1.5m
                 - 2: vehicle entrance ~5m
                 - 3: 2x vehicle entrance ~12m
                 
               - default = random amount, randomly defined (though
                 we try to do this somewhat reasonably, according to
                 the area of the given convex hull)
                 
                 
             - "orientation" (scalar)
                  in case we have automatic/random entrances, we still may
               define the orientation, aka the direction in which the
               main entrance should be build.
                     
                            
             - "spacing" (scalar)
                  spacing in meters, the calculated convex hull get's pushed
               outside/away from the centroid
               - default = 0
               
               
             - "facelength" (scalar)
                  minimal face-length of the area polygon/convex hull in 
               meter. Think of it like this: the higher the value, the 
               more the area polygon gets reduced, forming a simpler 
               shape... (see see RUBE_convexHull for further details)
               
               >> since RUBE_spawnObjectChain can't spawn objects in a 
                  straight line but has to deform it (joint) in order
                  to align the chain object most of the time, you will 
                  achieve nicer results with fairly simple area polygons
                  ... thus don't set this value too low or you'll get
                  very zigzag barrier which looks ugly.
               
               - default = 21
             
             
             - "barrier" (string or array of strings)
                  classes of objects to use as barrier/wall. If multiple
               classes are given, we use the one that fits best* (least
               deformation to line up) for each face. Though, we compare
               not the absolute error, but the relative one, or else
               smaller barrier objects would be favored too much..
               
               * we add a little random amount to the precision, so
                 objects of the same length will be choosen at random.
               
               - default = "Land_fort_bagfence_long"
                
                
             - "debug" (boolean)
                  prints debug information (map/diag_log)
                  
               - default = false   
                
                
                
               /// base entrance configuration  /// 
                  (see recipe_baseEntrance.sqf for more information)
                   
                   
             - "faction" (string in ["USMC", "CDF", "RU", "INS", "GUE"])
             
             - "camouflage" (string in ["woodland", "desert"])
             
             - "group" (group)
                  if a group is given, static gunners and guards are 
               automatically spawned and initialized.
               
               
             - "setup" (array of [key (string), factor (scalar)])
                  for: quality, camo, bunker, static, tower, gate, flag               
    
    
   Returns:
    array 
    [
       0: barrier objects (array of objects)
       1: entrances (array of BE-data-structure, which is the
          returned array from recepie_baseEntrance.sqf)
    ]
*/

private ["_area", "_barrier", "_orientation", "_entrances", "_entrancesN", "_entrancesMax", "_spacing", "_facelength", "_faction", "_camouflage", "_group", "_setup", "_debug", "_outerAlignmentObjects", "_getObjectAlignment", "_autoFlipObjects", "_autoFlip"];

_area = [];
_barrier = [];
_orientation = floor (random 360);
_entrances = []; // [dir, size]
_entrancesN = -1;
_entrancesMax = 5;
_spacing = 0;
_facelength = 21;

_faction = "GUE";
_camouflage = "woodland";
_group = grpNull;
_setup = [];
_debug = false;

// objects in this list will get an outer alignment
// for object chains (automatic solutions didn't work
// too well, so we fine tune this... feel free to
// adapt this list -- as a hint: it's not really about
// the depth of the object but the asymmetry)
_outerAlignmentObjects = [
   "Land_fort_rampart"
];
// same for a 180 degree object flip
_autoFlipObjects = [
   "Fence_corrugated_plate"
];
// ... and the corresponding private functions
_getObjectAlignment = {
   if (_this in _outerAlignmentObjects) exitWith
   {
      true
   };
   
   false
};
//
_autoFlip = {
   if (_this in _autoFlipObjects) exitWith
   {
      true
   };
   
   false
};

// read parameters
{
   switch (_x select 0) do
   {
      case "area": { _area = _x select 1; };
      case "orientation": { _orientation = _x select 1; };
      case "entrances": 
      {
         if ((typeName (_x select 1)) == "ARRAY") then
         {
            // well defined entrances
            _entrances = _x select 1;
         } else
         {
            // N entrances; randomly defined
            _entrancesN = _x select 1;
         };
      };
      case "spacing": { _spacing = _x select 1; };
      case "facelength": { _facelength = _x select 1; };
      case "barrier": 
      {
         if ((typeName (_x select 1)) == "ARRAY") then
         {
            _barrier = _x select 1;
         } else 
         {
            _barrier = [(_x select 1)];
         };
      };
      // base entrance configuration
      case "faction": { _faction = _x select 1; };
      case "camouflage": { _camouflage = _x select 1; };
      case "group": { _group = _x select 1; };
      case "setup": { _setup = _x select 1; };
      //
      case "debug": { _debug = _x select 1; };
   };
} forEach _this;

// barrier default
_barrierN = count _barrier;
if (_barrierN == 0) then
{
   _barrier = ["Land_fort_bagfence_long"];
   _barrierN = 1;
};

// update barrier information
//  [class, length]
[
   _barrier,
   {
      private ["_d", "_length"];
      _d = _this call RUBE_getObjectDimensions;
      _length = (((_d select 0) select 0) max ((_d select 0) select 1));
      [_this, _length]
   }
] call RUBE_arrayMap;





private ["_convexHull", "_h", "_barrierPrecision", "_selectBarrier", "_convexHullCentroid", "_convexHullArea", "_builtEntrances", "_barrierObjects", "_b"];

// calculate the convex hull/area-polygon
_convexHull = [_area, _spacing, _facelength] call RUBE_convexHull;
_h = count _convexHull;

// abort if we don't have a valid convex hull
if (_h < 3) exitWith
{
   []
};

_convexHullCentroid = _convexHull call RUBE_polygonCentroid;
_convexHullArea = _convexHull call RUBE_polygonArea;

/*
// debug list convexhull face distance
//--
private ["_j", "_dist"];
diag_log format["CONVEX HULL N=%1", (_h - 1)];
for "_j" from 0 to (_h - 3) do
{
   _dist = (_convexHull select 0) distance (_convexHull select (_j + 1));
   diag_log format["   F%1: %2m", (_j + 1), _dist];
};
//--
*/

/*
//--
// debug list hullpoint degrees
for "_i" from 0 to (_h - 1) do
{
   diag_log format["P%1: %2°", _i, ([_convexHullCentroid, (_convexHull select _i)] call BIS_fnc_dirTo)];
};
//--
*/


// private function to calculate the barrier precision/closeness
//  [face-length, barrier-length] => dx (scalar; the smaller the better)
_barrierPrecision = {
   private ["_face", "_length", "_rest", "_rand"];
   _face = _this select 0;
   _length = _this select 1;
   
   // a single barrier element is longer than the needed face
   // which isn't ideal at all...
   if (_length > _face) exitWith
   {
      // penalty
      512
   };
   
   _rest = _face % _length;
   // a small random amount to randomly alternate 
   // between diff. objects of the same length.
   _rand = random 0.001;
   
   // perfect match
   if (_rest == 0) exitWith
   {
      _rand
   };
   
   // remainder leading to deformation
   //((_length - _rest) + _rand)             // ABS. BEST FIT (chance for small objects is too small)
   //(((_length - _rest) / _length) + _rand) // REL. BEST FIT
   // MIXED VALUE: TODO: maybe offer a parameter for this?
   ((((_length - _rest) + _rand) * 0.3) + ((((_length - _rest) / _length) + _rand) * 0.7))
};


// private function to select best fitting barrier object
//  face-length => barrier-index 
_selectBarrier = {
   private ["_index", "_dx", "_idx", "_i"];
   // no alternative barrier
   if (_barrierN == 1) exitWith
   {
      0
   };
   // search
   _index = 0;
   _dx = 1024;

   for [{_i = 0}, {_i < _barrierN}, {_i = _i + 1}] do
   {
      _idx = [_this, ((_barrier select _i) select 1)] call _barrierPrecision;
  
      if (_idx < _dx) then
      {
         _index = _i;
         _dx = _idx;
      };
   };

   _index
};



// auto entrance layout?
if ((count _entrances) == 0) then
{
   // we skip this part if explicitly set to zero ^^
   if (_entrancesN < 0) then
   {
      // auto. amount of entrances
      _entrancesN = 1; // TODO: reasonable amount based on convex hull area
      
      // + max. 1 entrance per 1000m^2
      _entrancesN = _entrancesN + (floor (random (ceil (_convexHullArea * 0.001))));
      
      // cap
      if (_entrancesN > _entrancesMax) then
      {
         _entrancesN = _entrancesMax;
      };
   };
   
   // auto. entrance design
   if (_entrancesN > 0) then
   {
      private ["_balancedLayout", "_d", "_i", "_n", "_front", "_back", "_dStart"];
      // _orientation == _startDir
      // _entrances :: [dir (scalar), size (integer; 1-3)]
      // size: 2 or 3 as major; one or two of them
      
      // chance for an inbalanced layout for even number of entrances 
      _balancedLayout = true;
      if ((_entrancesN % 2) == 0) then
      {
         if (50 call RUBE_chance) then
         {
            _balancedLayout = false;
         };
      };
      
      if (_balancedLayout) then
      {
         _d = 360 / _entrancesN;
         for "_i" from 0 to (_entrancesN - 1) do
         {
            _entrances set [_i, [(_orientation + (_i * _d)), 1]];
         };
      } else 
      {
         _front = ceil ((_entrancesN * 0.5) + 1);
         _back = _entrancesN - _front;
         
         {
            _n = _x select 0;
            if ((_n > 0) && ((_n % 2) == 0)) then
            {
               _d = 180 / (_n * 2);
               _dStart = _orientation + _d + (_x select 1);
               for "_i" from 0 to (_n - 1) do
               {
                  _entrances set [(count _entrances), [(_dStart + (_i * (_d * 2))), 1]];
               };
            } else 
            {
               _d = 180 / (_n + 1);
               _dStart = _orientation + _d + (_x select 1);
               for "_i" from 0 to (_n - 1) do
               {
                  _entrances set [(count _entrances), [(_dStart + (_i * _d)), 1]];
               };
            };
         } forEach [
            [_front, -90], 
            [_back, 90]
         ];
      };
      
      // just in case...
      _entrancesN = count _entrances;
      
      // entrances are all at size 1 (person) at this point,
      // so let's see if we need size 2 (vehicle) or even 
      // size 3 (double vehicle) entrances...
      private ["_areaCoeff", "_newSize"];
      // area coefficient based on ~6000m^2 as large base threshold
      // thus > 1 == large base; > 0.5 medium base; < 0.5 small base
      _areaCoeff = _convexHullArea * (0.000013 + (random 0.000007));
      switch (true) do
      {
         case (_areaCoeff > 1):
         {
            for "_i" from 0 to (_entrancesN - 1) do
            {
               _c = 100 - ((_i / _entrancesN) * 95);
               _newSize = 1;
               if (_c > 67) then
               {
                  if (_c call RUBE_chance) then
                  {
                     _newSize = 3;
                  } else 
                  {
                     _newSize = 2;
                  };
               } else
               {
                  if (_c call RUBE_chance) then
                  {
                     _newSize = 2;
                  } else 
                  {
                     _newSize = 1;
                  };
               };
               if (_newSize > 1) then
               {
                  (_entrances select _i) set [1, _newSize];
               };
            };
         };
         case (_areaCoeff > 0.4):
         {
            for "_i" from 0 to (_entrancesN - 1) do
            {
               _c = 100 - ((_i / _entrancesN) * 95);
               _newSize = 1;
               if (_c > 95) then
               {
                  if (36 call RUBE_chance) then
                  {
                     _newSize = 3;
                  } else {
                     _newSize = 2;
                  };
               } else 
               {
                  if (_c call RUBE_chance) then
                  {
                     _newSize = 2;
                  };
               };
               if (_newSize > 1) then
               {
                  (_entrances select _i) set [1, _newSize];
               };
            };
         };
         default
         {
            for "_i" from 0 to (_entrancesN - 1) do
            {
               _c = (100 - ((_i / _entrancesN) * 95)) * 0.3;
               _newSize = 1;
               if (_c call RUBE_chance) then
               {
                  _newSize = 2;
               };
               if (_newSize > 1) then
               {
                  (_entrances select _i) set [1, _newSize];
               };
            };
         };
      };
   };
};



private ["_pointThreshold", "_extrudeEntrance", "_nextPoint", "_prevPoint", "_untaggedPos", "_getJointPoints", "_isBarrierFace", "_buildEntranceInFace", "_buildEntranceAtPoint"];

// minimal distance of faces to insert an entrance (entrance size == index)
// half this length is used for snap-to-point decisions
_pointThreshold = [
   0,
   40,
   50,
   60
];

// this is the distance the entrance gets extruded/pushed outside in meters, 
// depending on entrance size, so that there is some buffer/room behind the entrance
_extrudeEntrance = [
   0,
   5,
   8,
   10
];

// current index => next points index
_nextPoint = {
   ((_this + 1) % (count _convexHull))
};

// current index => previous points index
_prevPoint = {
   private ["_j"];
   _j = _this - 1;
   if (_j > -1) exitWith
   {
      _j
   };
   ((count _convexHull) - 1)
};

// some BIS functions do not fancy tagged positions,
// so we need to strip them off again...
//  (type checks and stuff can really be overdone if you ask me..)
//  anyway:
// index => untagged convex hull position
_untaggedPos = {
   [
      ((_convexHull select _this) select 0),
      ((_convexHull select _this) select 1),
      0
   ]
};

// returns the joint-points from the last built entrance
// in reversed order (since we sweep counter-clockwise...) 
_getJointPoints = {
   [
      (((_builtEntrances select ((count _builtEntrances) - 1)) select 0) select 1),
      (((_builtEntrances select ((count _builtEntrances) - 1)) select 0) select 0)
   ]
};

// we spawn barriers for all faces, unless both face points
// are tagged identically (we may still need to connect two 
// tagged points from different entrances)
_isBarrierFace = {
   if (((count (_this select 0)) + (count (_this select 1))) < 8) exitWith
   {
      true
   };
   if (((_this select 0) select 3) != ((_this select 1) select 3)) exitWith
   {
      true
   };
   
   false
};

// we have two methods of inserting/integrating an entrance:
// 1) if a face is long enough, we inject the entrances
//    jointpoints simply between the faces points.
// 2) if the face is not long enough or the entrance direction
//    snaps to a point, we replace this point by the two entrances
//    joint points.

//
_buildEntranceInFace = {
   private ["_dir", "_pos", "_jointPoints", "_j"];
   
   // normal on original face direction
   _dir = ([(_convexHull select _i2), (_convexHull select _i1)] call BIS_fnc_dirTo) - 90;
   
   // extrude entrance-face/position
   _pos = [
      _intersection, 
      (_extrudeEntrance select _entranceSize),
      _dir
   ] call BIS_fnc_relPos;
      
   // build entrance
   _builtEntrances set [
      (count _builtEntrances), 
      ([
         ["size", _entranceSize],
         ["position", _pos],
         ["direction", _dir],
         ["setup", _setup],
         ["faction", _faction],
         ["camouflage", _camouflage],
         ["group", _group]
      ] call RUBE_RECIPE_baseEntrance)
   ];
   
   // insert joint-points into convex hull
   _jointPoints = [] call _getJointPoints;
   // tag joint points in convex hull as "fixed" to prevent
   // further modification of these points aswell as the
   // superfluous connection of two joint points of one and the
   // same entrance
   for "_j" from 0 to 1 do
   {
      (_jointPoints select _j) set [2, 0];
      (_jointPoints select _j) set [3, format["fixed%1", (count _builtEntrances)]];
   };
   
   _convexHull = [
      _jointPoints,
      _convexHull,
      _i2
   ] call RUBE_arrayInsert;
   
   true
};

//
_buildEntranceAtPoint = {
   private ["_i", "_dir", "_pos"];
   _i = _this select 0;
   _dir = _this select 1;
   
   // we can not modify as fixed tagged points
   if ((count (_convexHull select _i)) > 3) exitWith
   {
      false
   };
   
   // extrude entrance-point/position
   _pos = [
      _intersection, 
      (_extrudeEntrance select _entranceSize),
      _dir
   ] call BIS_fnc_relPos;
   
   // build entrance
   _builtEntrances set [
      (count _builtEntrances), 
      ([
         ["size", _entranceSize],
         ["position", _pos],
         ["direction", _dir],
         ["setup", _setup],
         ["faction", _faction],
         ["camouflage", _camouflage],
         ["group", _group]
      ] call RUBE_RECIPE_baseEntrance)
   ];
   
   // remove original convex hull point
   _convexHull = [_convexHull, _i] call RUBE_arrayDropIndex;
   
   // insert joint-points into convex hull
   _jointPoints = [] call _getJointPoints;
   // tag joint points in convex hull as "fixed" to prevent
   // further modification of these points aswell as the
   // superfluous connection of two joint points of one and the
   // same entrance
   for "_j" from 0 to 1 do
   {
      (_jointPoints select _j) set [2, 0];
      (_jointPoints select _j) set [3, format["fixed%1", (count _builtEntrances)]];
   };
   
   _convexHull = [
      _jointPoints,
      _convexHull,
      _i
   ] call RUBE_arrayInsert;
   
   true
};



// building entrances by modifying the faces (and maybe
// points) of the convex hull, [dir, size]
_builtEntrances = [];
if (_entrancesN > 0) then
{
   //--
   format["%1 entrances:", _entrancesN] call RUBE_debugLog;
   
   // open convexhull polygon
   _convexHull resize ((count _convexHull) - 1);
   
   {
      private ["_entranceSize", "_entranceDir", "_snap", "_i1", "_i2", "_p1Dir", "_p2Dir"];
      _entranceSize = _x select 1;
      _entranceDir = ((_x select 0) + 180) call RUBE_normalizeDirection;
      _entranceProj = [_convexHullCentroid, 10, _entranceDir] call BIS_fnc_relPos;
      _snap = (_pointThreshold select _entranceSize) * 0.5;
      
      // sweep through the convexHull faces...
      // (we go out of bounds to close the polygon)
      for "_i1" from 0 to ((count _convexHull) - 1) do
      {
         // face point indices
         // close polygon/out of bounds fix
         _i1 = _i1 % (count _convexHull); 
         _i2 = _i1 call _nextPoint;
         
         // check if the projected/infinite entrance line 
         // intersects the current face
         _p1Dir = ([_convexHullCentroid, (_convexHull select _i1)] call BIS_fnc_dirTo) call RUBE_normalizeDirection;
         _p2Dir = ([_convexHullCentroid, (_convexHull select _i2)] call BIS_fnc_dirTo) call RUBE_normalizeDirection;

         if ([_entranceDir, _p2Dir, _p1Dir] call RUBE_dirInArc) exitWith
         {
            private ["_intersection"];
            
            _intersection = [
               (_convexHull select _i1),
               (_convexHull select _i2),
               _convexHullCentroid, 
               _entranceProj
            ] call RUBE_lineSegmentIntersection;
            
            switch (true) do
            {
               // snap to p1
               case (((_i1 call _untaggedPos) distance _intersection) < _snap):
               {
                  format["SNAP TO P1: (p1: %1) (dir: %2) (p2: %3)", _p1Dir, _entranceDir, _p2Dir] call RUBE_debugLog;
                  if (_debug) then
                  {
                     [
                        ["position", _intersection],
                        ["type", "Artillery"],
                        ["color", "ColorOrange"]
                     ] call RUBE_mapDrawMarker;
                  };
                  
                  [_i1, _p1Dir] call _buildEntranceAtPoint;
               };
               // snap to p2
               case (((_i2 call _untaggedPos) distance _intersection) < _snap):
               {
                  format["SNAP TO P2: (p1: %1) (dir: %2) (p2: %3)", _p1Dir, _entranceDir, _p2Dir] call RUBE_debugLog;
                  if (_debug) then
                  {
                     [
                        ["position", _intersection],
                        ["type", "Artillery"],
                        ["color", "ColorOrange"]
                     ] call RUBE_mapDrawMarker;
                  };
                  
                  [_i2, _p2Dir] call _buildEntranceAtPoint;
               };
               // face
               default
               {
                  format["FACE: (p1: %1) (dir: %2) (p2: %3)", _p1Dir, _entranceDir, _p2Dir] call RUBE_debugLog;
                  if (_debug) then
                  {
                     [
                        ["position", _intersection],
                        ["type", "Artillery"],
                        ["color", "ColorRed"]
                     ] call RUBE_mapDrawMarker;
                  };
                  
                  [] call _buildEntranceInFace;
               };
            };
         };
      };
   } forEach _entrances;
   
   // close convexHull polygon again
   _convexHull set [(count _convexHull), (+(_convexHull select 0))];
};



// debug print convex hull point markers
if (_debug) then
{
   private ["_i"];
   for "_i" from 0 to ((count _convexHull) - 1) do
   {
      private ["_color", "_type", "_label", "_tagged"];
      _tagged = "";
      if ((count (_convexHull select _i)) > 3) then
      {
         _tagged = " (f)";
      };

      _color = "ColorBlue";
      _type = "mil_dot";
      _label = format["p%1%2", _i, _tagged];
      
      if (_i == ((count _convexHull) - 1)) then
      {
         _color = "ColorGreen";
         _type = "mil_circle";
         _label = format["   p%1%2", _i, _tagged];
      };

      [
         ["position", (_i call _untaggedPos)],
         ["color", _color],
         ["type", _type],
         ["text", _label]
      ] call RUBE_mapDrawMarker;
   };
};



// spawning the barrier, one face after the other
_barrierObjects = [];
_b = 0;

for [{_i = 1}, {_i < (count _convexHull)}, {_i = _i + 1}] do
{
   private ["_p1", "_p2", "_index"];
   
   // we need to make a copy to savely/temporarily 
   // untag "fixed" positions; we do not connect
   // two "fixed" positions (with the same tag!), since these are
   // two joint points of a single entrance (== already connected)
   _p1 = + (_convexHull select (_i - 1));
   _p2 = + (_convexHull select _i);

   if ([_p1, _p2] call _isBarrierFace) then { //--
      // remove "fixed" tags
      if ((count _p1) > 3) then { _p1 resize 3; };
      if ((count _p2) > 3) then { _p2 resize 3; };
   
      // debug print faces/spawned barriers
      if (_debug) then
      {
         [
            ["start", _p1],
            ["end", _p2],
            ["color", "ColorOrange"],
            ["size", 1]
         ] call RUBE_mapDrawLine;
      };
   
      _index = (_p1 distance _p2) call _selectBarrier;
      {
         _barrierObjects set [_b, _x];
         _b = _b + 1;
      } forEach ([
         ((_barrier select _index) select 0),
         [_p1, _p2],
         0, // spacing
         "concave",
         (((_barrier select _index) select 0) call _autoFlip), // 180-flip?
         (((_barrier select _index) select 0) call _getObjectAlignment)
      ] call RUBE_spawnObjectChain);
   
   };
};

// return spawned objects
[_barrierObjects, _builtEntrances]