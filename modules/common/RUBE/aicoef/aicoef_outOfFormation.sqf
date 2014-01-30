/*
   Author:
    rübe
    
   Description:
    coeficient for the given group beeing out of formation.
    (ignores players or units that can't stand/walk anymore)
    
   Parameter(s):
    _this: unit or group (vehicle/group)
    
   Returns:
    scalar from 0.0 (in formation/no need to regroup)
             to 1.0 (out of formation)
*/

private ["_unit", "_units", "_group", "_vehicles", "_n", "_distances", "_expectedAvg", "_avgDist"];

_unit = _this;
if ((typeName _unit) == "GROUP") then
{
   _unit = leader _this;
} else 
{
   // make sure we have the leader
   _unit = leader (group _unit);
};

_group = group _unit;
_units = units _group;
_n = count _units;

if (_n < 1) exitWith
{
   -1
};

_vehicles = _group call RUBE_getGroupVehicles;

// 9m as average distance between units in formation (without vehicles in group),
_avgDist = 9;
if ((count _vehicles) > 0) then
{
   _avgDist = 20;
};

// assuming line formation...
_expectedAvg = (ceil (_n * 0.5)) * _avgDist;

_distances = [];
{
   if ((_x != player) && (canStand _x)) then
   {
      _distances set [(count _distances), (_x distance _unit)];
   };
} forEach (_units - [_unit]);

_avgDist = [_distances] call RUBE_average;

//diag_log format["AICOEF_OOF: (units: %1) (expected avg. %2) (avg. dist. %3) >> COEF == %4", (count _units), _expectedAvg, _avgDist, ((_avgDist / _expectedAvg) * 0.5)];

// tight formation, no need to regroup
if (_avgDist < _expectedAvg) exitWith
{
   -1
};

// return approx. coef
((_avgDist / _expectedAvg) * 0.5)