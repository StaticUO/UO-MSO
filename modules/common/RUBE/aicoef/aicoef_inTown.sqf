/*
   Author:
    rübe
    
   Description:
    coeficient for the given unit/group beeing in a town/village 
    or simply near buildings.
    
   Parameter(s):
    _this: unit or group (vehicle/group)
    
   Returns:
    scalar from 0.0 (not in town/near buildings)
             to 1.0 (totally in town/near buildings)
*/

private ["_unit", "_sample"];

_unit = _this;
if ((typeName _unit) == "GROUP") then
{
   _unit = leader _this;
};

_sample = selectBestPlaces [
   (position _unit), // sample position
   6, // sample radius
   "((2 * houses) - forest - sea) * 0.5", //expression
   3, // precision
   1 // sourcesCount
];

// undefined
if ((count _sample) < 1) exitWith
{
   -1
};

// return coef
((_sample select 0) select 1)