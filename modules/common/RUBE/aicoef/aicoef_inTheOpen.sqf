/*
   Author:
    rübe
    
   Description:
    coeficient for openness/emptyness/wideness of the current
    terrain the given unit/group is in.
    
   Parameter(s):
    _this: unit or group (vehicle/group)
    
   Returns:
    scalar from 0.0 (not open/empty/wide)
             to 1.0 (totally open/empty/wide)
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
   "((2 * meadow) + (1 - houses) + (1 - forest)) * 0.25", //expression
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