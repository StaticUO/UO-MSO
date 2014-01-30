/*
   Author:
    rübe
    
   Description:
    coeficient for the given unit/group beeing in a forest.
    
   Parameter(s):
    _this: unit or group (vehicle/group)
    
   Returns:
    scalar from 0.0 (not in forest)
             to 1.0 (totally in forest)
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
   "(forest - sea)", //expression
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