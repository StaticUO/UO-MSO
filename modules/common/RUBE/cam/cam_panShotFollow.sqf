/*
  Author:
   rübe
   
  Description:
   camera script. Follow vehicle script, that is a little less static than an attached camera.
   
  How to quit this script:
   to exit this script (without destroying the camera) you have to: 
    veh setVariable ["exitCamScript", true]
   where veh is the vehicle to be followed (2nd parameter). This allows you to end the script
   after an exact duration or at an exact point in time (maybe from within another script)...
   
   (I would have attached this variable to the camera, but unfortunately set- and getVariable 
    still don't work with anything except vehicles)
    
  Offset-Matrix ([x, y, z] OR [x, y, z, memPoint])
   if you use an offset-matrix (attachTo actual target), camTarget will return a fake target.
   You can find the actual target again with ((camTarget _cam) getVariable "originalCamTarget");
   If there is no fake target, "originalCamTarget" will be objNull.

   
  Parameters:
   _this select 0: camera (object)
   _this select 1: target-vehicle (object OR array [object, offsetMatrix])
   _this select 2: ~distance (number)
   _this select 3: ~rel. height above target-vehicle (number) 
   _this select 4: target direction offset (number, optional; default = 180)
                   - 0:   translates to a front shot
                   - 180: translates to a view from behind
   _this select 5: max. pan multiplier (number, optional; default = 1.0)
   _this select 6: exit on target-vehicle death (boolean, optional: default = false)
   
  Requisites:
   - cam_panShot.sqf
   
  Examples:
   // create camera
   _cam = "camera" camCreate [0, 0, 0]; 
   _cam cameraEffect ["internal","back"];
   _cam camSetFOV 0.7;
   
   // run cam script on _avenger
   _camScript = [_cam, _avenger, 12, 4, 1.0] execVM "cam_panShotFollow.sqf";
   
   // force exit after 10 seconds
   _t = 10;
   // we can safely/need to set the exit variable early, because the script will finish the last pan shot
   // needed time depends on your shots time...
   sleep (_t * 0.6);
   _avenger setVariable ["exitCamScript", true];
   // we have to wait until the last pan shot has finished! (which could easily take up to ~4 seconds)
   waitUntil{scriptDone _camScript};
   
   // delete camera
   _cam cameraEffect["terminate", "back"];
   camDestroy _cam;
   
*/   

private ["_cam", "_target", "_offsetMatrix", "_memPoint", "_originalTarget", "_fakeTarget", "_distance", "_height", "_panMul", "_exitOnDeath", "_copy", "_dirOffset"];

_cam = _this select 0;
_target = _this select 1;
_offsetMatrix = [];
_memPoint = "";
if ((typeName _target) == "ARRAY") then
{
   _copy = + _target;
   _target = _copy select 0;
   _offsetMatrix = _copy select 1;
   // do we have a mempoint?
   if ((count (_copy select 1)) > 3) then
   {
      _offsetMatrix = [((_copy select 1) select 0), ((_copy select 1) select 1), ((_copy select 1) select 2)];
      _memPoint = ((_copy select 1) select 3);
   } else {
      _offsetMatrix = _copy select 1;
   };
};

_originalTarget = objNull;
_fakeTarget = [];

_distance = _this select 2;
_height = _this select 3;
_dirOffset = 180;
if ((count _this) > 4) then
{
   _dirOffset = _this select 4;
};
_panMul = 1.0;
if ((count _this) > 5) then
{
   _panMul = _this select 5;
};
_exitOnDeath = false;
if ((count _this) > 6) then
{
   _exitOnDeath = _this select 6;
};

// vehicle/speed dependend adjustments
private [
   "_tBase", "_hWeight", "_dWeight",
   "_d0", "_d1", "_h0", "_h1", "_a0", "_a1", "_s0", "_s1",
   "_dir", "_camScript", "_camScriptRun", "_sDiff", "_t", "_a"
];

_tBase = [1.2, 3.0];
_hWeight = 0.003;
_dWeight = 0.01;

if (_target isKindOf "Man") then
{
   _tBase = [1.0, 2.4];
   _hWeight = 0.016;
   _dWeight = 0.048;
};
if (_target isKindOf "Air") then
{
   _tBase = [1.4, 2.6];
   _hWeight = -0.012;
   _dWeight = 0.006;
};


_d0 = _distance;
_d1 = _distance - (_distance * 0.1) + (random _distance);


_h0 = _height;
_h1 = _height - (_height * 0.5) + (random _height);

_a0 = (direction _target) - (_dirOffset - 10) + (random 20);
_a1 = (direction _target) - _dirOffset;

_s0 = speed _target;
_s1 = speed _target;

// we may need to setup a fake target if we use an offset-matrix
// (and we shouldn't rely on the same mechanism in cam_panShot.sqf
//  since this would delete the fake target after every call to it!)
if ((count _offsetMatrix) > 0) then
{
   _fakeTarget set [0, (createGroup sideLogic)];
   _fakeTarget set [1, ((_fakeTarget select 0) createUnit ["Logic", (position _target), [], 0, "NONE"])];
   _target setVariable ["exitCamScript", false];
   (_fakeTarget select 1) setVariable ["originalCamTarget", _target];
   (_fakeTarget select 1) setDir _dir;
   if (_memPoint != "") then
   {
      (_fakeTarget select 1) attachTo [_target, _offsetMatrix, _memPoint];
   } else {
      (_fakeTarget select 1) attachTo [_target, _offsetMatrix];
   };
   _originalTarget = _target;
   // ... so we simply remove the matrix offset once applied (once the fake 
   // target is attached) and will pass on only the fake target
   _target = (_fakeTarget select 1);
   // z-correction
   _height = _height - (_offsetMatrix select 2);
};

_target setVariable ["exitCamScript", false];
_camScriptRun = true;



while {_camScriptRun} do
{
   _s0 = _s1;
   _s1 = speed _target;
   _sDiff = (abs (_s1 - _s0));
   
   _t = (_tBase select 0) + (random (_tBase select 1));
   
   _d0 = _d1;
   if (_s1 > _s0) then
   {
      _d1 = _distance + ((random ((_sDiff + _s1) * _distance)) * _dWeight);
   } else {
      _d1 = _distance - ((random (_sDiff * _distance)) * _dWeight);
   };

   _h0 = _h1;
   if (_s1 > _s0) then
   {
      _h1 = _height + ((random ((_sDiff - _s1) * _height)) * _hWeight);
   } else {
      _h1 = _height - ((random (_sDiff * _height)) * _hWeight);
   };

   _a0 = _a1;
   _a = ((direction _target) - _dirOffset) % 360;
   if (_a > _a1) then 
   {
      _a1 = (_a - (random ((abs (_a - _a1)) * _panMul)));
   } else {
      _a1 = (_a + (random ((abs (_a - _a1)) * _panMul)));
   };
   
   _camScript = [_cam, [_target, _offsetMatrix], [_d0, _d1], [_h0, _h1, "%1^2", 0], [_a0, _a1], _t] execVM "modules\common\RUBE\cam\cam_panShot.sqf";
   sleep _t;
   
   // the target may have been replaced (eg. for a fake target, see cam_panShot.sqf)
   _target = camTarget _cam;
   
   // exit?
   if (_target getVariable "exitCamScript") exitWith { _camScriptRun = false; };
   if (_exitOnDeath && !(alive _target)) exitWith { _camScriptRun = false; };
   if (!(isNull _originalTarget)) then
   {      
      if (_originalTarget getVariable "exitCamScript") then { _camScriptRun = false; };
      if (_exitOnDeath && !(alive _originalTarget)) then { _camScriptRun = false; };
   };
};

// we may need to clean up our fakeTarget, though we shouldn't 
// delete it immediately provoking another ugly jump to 0-0-0 
// we wanna prevent in the first place.. haha 
//  it doesn't hurry anyway so...
if ((count _fakeTarget) > 0) then
{
   [_fakeTarget, _cam] spawn {
      private ["_fakeVeh", "_fakeGrp", "_cam"];
      
      _fakeVeh = (_this select 0) select 1;
      _fakeGrp = (_this select 0) select 0;
      _cam = _this select 1;
      
      while {!(isNull _fakeVeh)} do
      {
         // we can safely delete the fake target, once it isn't  
         // the target of the cam anymore.
         if ((camTarget _cam) != _fakeVeh) exitWith
         {
            sleep 2;
            deleteVehicle _fakeVeh;
            deleteGroup _fakeGrp;
         };
         sleep 3;
      };
   };
};