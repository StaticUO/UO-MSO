/*
   Author:
    rübe
   
   Description:
    spawns objects in waves (so first objects will be located in
    the center) around a given center, placing objects where the 
    terrain allows (thus chaos).
    
   Parameter(s):
    _this: parameters (array of array [key (string), value (any)])
    
           - required:
           
             - "position" (position)
               original center position (can be altered once to 
               the location of the first placed object, in case
               the terrain at the given position doesn't allow
               the object to be placed)
             
             - "objects" (array of waves) where
               - waves can be either:
                 - an array of class-strings
                 - an array of [class-string, code] where
                   the code get's passed the object, once
                   it's spawned in place. (e.g. to register
                   certain objects)
                 - an array of [code, radius] where
                   - code gets passed:
                     _this select 0: position
                     _this select 1: direction
                   and radius defines the needed area in meters.
                   Code of course is intended to spawn multiple
                   objects, thus it MUST return an array of 
                   objects (or an empty array).
                   
                   -> you may mix them all together in a single 
                      wave-array.. np.
                 
                   
           - optional:
           
             - "maxGradient" (scalar 0.0 - 1.0)
               maximal gradient for objects
               -> default = 0.3;
           
             - "orientation" (string, number OR array of number)
               - "random" orientation of objects
               - "center" objects "look at" the center
               - number: fixed direction (0-360)
               -> default = "random"
               
             - "rotation" (scalar)
               offset in degree applied to the objects direction
               if "orientation" is set to "center".
               - default = 0;
               
             - "measuring" (int 0 - 1)
               measuring method to retrieve the size of the objects
               - 0: bounding box of the object
               - 1: RUBE_getObjectDimensions (tightly measured)
               -> default = 0
             
             - "spacing" (scalar in m)
               additional spacing, added to the area an object
               occupies (think radius, not diameter).
               -> default = 0
               
             - "slide" (int 0 - 1)
               - 0: center gets only adjusted once, set to the
                    position of the first spawned object
               - 1: center gets updated to the position of the
                    last object in each wave
               -> default = 0
                   
             
   Returns:
    array of objects
*/

private ["_center", "_waves", "_orientation", "_centerRotation", "_spacing", "_slide", "_maxGradient", "_chaosDirection", "_chaosDimensions", "_chaosNextSpot"];

_center = [0,0,0];
_waves = [];
_orientation = "random";
_centerRotation = 0;
_spacing = 0;
_slide = 0;
_maxGradient = 0.3;
_chaosDirection = {
   (random 360)
};
_chaosDimensions = {
   private ["_center"];
   _center = boundingCenter _this;
   [(_this call RUBE_boundingBoxSize), [((_center select 0) * -1), ((_center select 1) * -1), 0]]
};

// read parameters
{
   switch (_x select 0) do
   {
      case "position": { _center = _x select 1; };
      case "objects": { _waves = _x select 1; };
      case "maxGradient": { _maxGradient = _x select 1; };
      case "rotation": { _centerRotation = _x select 1; };
      case "orientation": 
      { 
         switch (typeName (_x select 1)) do
         {
            case "STRING":
            {
               if ((_x select 1) == "center") then
               {
                  _orientation = "center";
                  _chaosDirection = {
                     (([_center, _this] call BIS_fnc_dirTo) + _centerRotation)
                  };
               };
            };
            case "ARRAY":
            {
               _orientation = _x select 1;
               _chaosDirection = {
                  (_orientation call RUBE_randomSelect)
               };
            };
            case "SCALAR":
            {
               _orientation = _x select 1;
               _chaosDirection = {
                  _orientation
               };
            };
         };
      };
      case "measuring": 
      {
         if ((_x select 1) > 0) then
         {
            _chaosDimensions = {
               ((typeOf _this) call RUBE_getObjectDimensions)
            };
         };
      };
      case "spacing": { _spacing = _x select 1; };
      case "slide": { _slide = _x select 1; };
   };
} forEach _this;



_chaosNextSpot = {
   private ["_dimensions", "_size", "_offset", "_distance", "_range", "_positions", "_pos", "_dir"];
   
   _distance = 0;
   _size = [0,0];
   _offset = [0,0,0];
   
   if ((typeName _this) == "ARRAY") then
   {
      _size = [(_this select 0), (_this select 0)];
      _distance = (_this select 0) + _spacing;
   } else {
      _dimensions = _this call _chaosDimensions;
      _size = _dimensions select 0;
      _offset = _dimensions select 1;   
      _distance = ((_size select 0) max (_size select 1)) + _spacing;
   };
   
   _range = _distance;
   _positions = [];
   while {(count _positions) == 0} do
   {
      _positions = [
         ["position", _center],
         ["number", 1],
         ["range", [0, _range]],
         ["objDistance", _distance],
         ["maxGradient", _maxGradient],
         ["adjustPos", (10 + (random 10))]
      ] call RUBE_randomCirclePositions;
      _range = _range * 1.5;
   };

   _pos = (_positions select 0);
   _dir = _pos call _chaosDirection;

   [([_pos, _offset, _dir] call RUBE_gridOffsetPosition), _dir]
};


private ["_objects", "_o", "_n", "_wave", "_objs", "_obj", "_spot", "_pos", "_dir"];

_objects = [];
_o = 0;


// waves
{
   // wave of objects
   {
      _objs = [];
      switch (typeName _x) do
      {
         case "STRING":
         {
            _obj = createVehicle [_x, [0,0,0], [], 0, "NONE"];
            _spot = _obj call _chaosNextSpot;  
                      
            _obj setDir (_spot select 1);
            _obj setPos (_spot select 0);
            
            _objs = [_obj];
         };
         case "ARRAY":
         {
            if ((typeName (_x select 0)) == "CODE") then
            {
               // code & area-radius
               _spot = [(_x select 1)] call _chaosNextSpot;
               _objs = [(_spot select 0), (_spot select 1)] call (_x select 0);
            } else {
               // string-class & post code
               _obj = createVehicle [(_x select 0), [0,0,0], [], 0, "NONE"];
               _spot = _obj call _chaosNextSpot;
               _obj setDir (_spot select 0);
               _obj setPos (_spot select 1);
            
               _obj call (_x select 1);
               _objs = [_obj];
            };
         };
      };
      
      if (_o == 0) then
      {
         _center = position (_objs select 0);
      };
      
      {
         _objects set [_o, _x];
         _o = _o + 1;
      } forEach _objs;
      
   } forEach _x;
   
   if (_slide > 0) then
   {
      _n = count _objects;
      if (_n > 0) then
      {
         _center = position (_objects select (_n - 1));
      };
   };
} forEach _waves;


// return objects
_objects