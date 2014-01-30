/*
   RUBE weather module,
   weather logic
   --
*/

private ["_logic", "_isLogic", "_alreadyInitialized"];

_logic = _this;
_isLogic = false;

if ((typeName _logic) == "ARRAY") then
{
   if ((count _logic) > 0) then
   {
      _logic = _logic select 0;
   };
};

if ((typeName _logic) == "OBJECT") then
{
   if (_logic isKindOf "Logic") then
   {
      _isLogic = true;
   };
};


if (!_isLogic) then
{
   _logic = RUBE_GroupLogic CreateUnit ["Logic",[0,0,0],[],0,"NONE"];
};

_alreadyInitialized = _logic getVariable "RUBE_weatherLogic";
if (!(isnil "_alreadyInitialized")) exitWith {
   _logic
};

/*
   INIT WEATHER LOGIC
*/

// put logic aside
_logic setpos [1,1,1];

// load weather constants
{
   _logic setVariable [(_x select 0), (_x select 1), true];
} forEach ([] call (compile preprocessFileLineNumbers "modules\common\RUBE\modules\weather\weather-constants.sqf"));

// load weather module interface
{
   _logic setVariable [(_x select 0), (_x select 1), true];
} forEach ([] call (compile preprocessFileLineNumbers "modules\common\RUBE\modules\weather\weather-interface.sqf"));

/*
   DONE
*/

// mark/label logic
_logic setVariable ["RUBE_weatherLogic", true, true];


// return
_logic