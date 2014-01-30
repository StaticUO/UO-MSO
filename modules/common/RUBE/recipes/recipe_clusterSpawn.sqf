/*
   Author:
    rübe
    
   Description:
    spawns objects in clusters, first searching suitable areas for
    each cluster, keeping a min. distance to each other.
    
   Parameter(s):
    _this: parameters (array of array [key (string), value (any)])
    
           - required:
           
             - "position" (position)
               center position
             
             - "objects" (array of clusters) where
               - cluster can be either:
                 - an array of class-strings
                 - an array of [class-string, code]
                   - post-code gets passed the object
                 - an array of [code, radius]
                   - pre-code gets passed pos, dir
                     returns array of objects
                     
           - optional:
           
             - "maxGradient" (scalar 0.0 - 1.0)
               maximal gradient for objects
               -> default = 0.3;
               
             - "orientation" (string, number OR array of number)
               - "random" orientation of objects
               - "center" objects "look at" the center
               - number: fixed direction (0-360)
               -> default = "random"
               
             - "measuring" (int 0 - 1)
               measuring method to retrieve the size of the objects
               - 0: bounding box of the object
               - 1: RUBE_getObjectDimensions (tightly measured)
               -> default = 0
               
             - "spacing" (scalar in m)
               additional spacing, added to the area an object
               occupies (think radius, not diameter).
               -> default = 0
               
   Returns:
    array of objects
*/

private ["_position", "_clusters", "_objects", "_areas", "_maxGradient", "_spacing", "_objDimensions"];

_position = [0,0,0];
_clusters = [];
_objects = [];
_areas = [];

_maxGradient = 0.3;
_spacing = 0;

_objDimensions = {
   private ["_center"];
   _center = boundingCenter _this;
   [(_this call RUBE_boundingBoxSize), [((_center select 0) * -1), ((_center select 1) * -1), 0]]
};

// read parameters
{
   switch (_x select 0) do
   {
      case "position": { _position = _x select 1; };
      case "objects": { _clusters = _x select 1; };
      case "maxGradient": { _maxGradient = _x select 1; };
      case "orientation": {};
      case "spacing": { _spacing = _x select 1; };
      case "measuring": 
      {
         if ((_x select 1) > 0) then
         {
            _objDimensions = {
               ((typeOf _this) call RUBE_getObjectDimensions)
            };
         };
      };
   };
} forEach _this;

private ["_objArea", "_ccRadius", "_lastObj", "_area", "_a", "_x", "_i", "_j", "_o", "_obj", "_dim"];

// area of an object (incl. spacing)
_objArea = {
   (((_this select 0) + _spacing) * ((_this select 1) + _spacing))
};

// circumcircle radius of a square, given the area
_ccRadius = {
   ((sqrt _this) / (sqrt 2))
};

_lastObj = ["", [], 0];
_o = 0;

// calculate needed area for each cluster
for "_i" from 0 to ((count _clusters) - 1) do
{
   _area = 0;
   for "_j" from 0 to ((count (_clusters select _i)) - 1) do
   {
      _x = (_clusters select _i) select _j;
      switch (typeName _x) do
      {
         case "STRING":
         {
            if (_x == (_lastObj select 0)) then
            {
               _obj = createVehicle [_x, [0,0,0], [], 0, "NONE"];
               _objects set [_o, [_obj, (_lastObj select 1)]];
               _area = _area + (_lastObj select 2);
               _o = _o + 1;
            } else {
               _obj = createVehicle [_x, [0,0,0], [], 0, "NONE"];
               _dim = _obj call _objDimensions;
               _a = (_dim select 0) call _objArea;
               _objects set [_o, [_obj, _dim]];
               _area = _area + _a;
               _o = _o + 1;
               
               _lastObj set [1, _dim];
               _lastObj set [2, _a];
            };
         };
         case "ARRAY":
         {
            if ((typeName (_x select 0)) == "CODE") then
            {
               // code & area-radius
            } else {
               // string-class & post-code
            };
         };
      };
   };
   _areas set [_i, _area];
};


// find cluster positions
// _ccRadius



// fill clusters
