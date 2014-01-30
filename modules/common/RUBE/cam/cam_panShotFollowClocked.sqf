/*
  Author:
   rübe
   
  Description:
   camera script. Follow vehicle script, that is a little less static than an attached camera.
   
   <>> CLOCKED VERSION <<
   
   we exit this cam script after _clockTime, while the single pan shots are a multiple
   of _clockTick. _clickTime should be a multiple of _clockTick (so we can divide _clickTime 
   by _clockTime without rest).
   
   This comes in handy if we need to synchronize follow-shots to something else (eg. music)
   Though, you may still exit with exitCamScript (see cam_panShotFollow.sqf)
   
   -> also note that we can interpolate from a start to an end distance|height|dirOffset,
      which is not possible in the non-clocked version! (only linear so far..)
      
      .. though, thanks to the `follow-adjust-logic` you may not exactly get what you're after.
       In that case either use cam_panShot.sqf or adapt this script to your needs...
   
  Offset-Matrix ([x, y, z] OR [x, y, z, memPoint])
   if you use an offset-matrix (attachTo actual target), camTarget will return a fake target.
   You can find the actual target again with ((camTarget _cam) getVariable "originalCamTarget");
   If there is no fake target, "originalCamTarget" will be objNull.
   
  Parameters:
   _this select 0: camera (object)
   _this select 1: clock (array: [_clockTime, _clockTick])
   _this select 2: target-vehicle (object OR array [object, offsetMatrix])
   _this select 3: ~distance (number OR array [dist tStart, dist tEnd, f])
   _this select 4: ~rel. height above target-vehicle (number OR array [height tStart, height tEnd, f]) 
   _this select 5: target direction offset (number OR array [dir tStart, dir tEnd, f], optional; default = 180)
                   - 0:   translates to a front shot
                   - 180: translates to a view from behind
   _this select 6: max. pan multiplier (number, optional; default = 1.0)
   
   
  Requisites:
   - cam_panShot.sqf
   
*/   

private ["_cam", "_clockTime", "_clockTick", "_target", "_offsetMatrix", "_memPoint", "_originalTarget", "_fakeTarget", "_mfs", "_distance", "_distShift", "_height", "_heightShift", "_dirOffset", "_dirShift", "_panMul", "_exitOnDeath", "_copy"];

_cam = _this select 0;
_clockTime = (_this select 1) select 0;
_clockTick = (_this select 1) select 1;
_target = _this select 2;
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

_mfs = ["%1", "%1", "%1"];

_distance = _this select 3;
_distShift = 0;
if ((typeName _distance) == "ARRAY") then
{
   _distance = (_this select 3) select 0;
   _distShift = ((_this select 3) select 1) - _distance;
   if ((count (_this select 3)) > 2) then
   {
      _mfs set [0, ((_this select 3) select 2)];
   };
};

_height = _this select 4;
_heightShift = 0;
if ((typeName _height) == "ARRAY") then
{
   _height = (_this select 4) select 0;
   _heightShift = ((_this select 4) select 1) - _height;
   if ((count (_this select 4)) > 2) then
   {
      _mfs set [1, ((_this select 4) select 2)];
   };
};

_dirOffset = 180;
_dirShift = 0;
if ((count _this) > 5) then
{
   _dirOffset = _this select 5;
   if ((typeName _dirOffset) == "ARRAY") then 
   {
      _dirOffset = (_this select 5) select 0;
      _dirShift = ((_this select 5) select 1) - _dirOffset;
      if ((count (_this select 5)) > 2) then
      {
         _mfs set [2, ((_this select 5) select 2)];
      };
   };
};
_panMul = 1.0;
if ((count _this) > 6) then
{
   _panMul = _this select 6;
};
_exitOnDeath = false;


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



// vehicle/speed dependend adjustments
private [
   "_hWeight", "_dWeight", "_camScript", "_camScriptRun", "_camScriptRuntime",
   "_d0", "_d1", "_h0", "_h1", "_a0", "_a1", "_s0", "_s1",
   "_sDiff", "_t", "_timeLeft", "_ticksLeft", "_INT", 
   "_ds", "_hs", "_as", "_a"
];

_hWeight = 0.003;
_dWeight = 0.01;

if (_target isKindOf "Man") then
{
   _hWeight = 0.016;
   _dWeight = 0.048;
};
if (_target isKindOf "Air") then
{
   _hWeight = -0.012;
   _dWeight = 0.006;
};

_hWeight = _hWeight * _panMul;
_dWeight = _dWeight * _panMul;

_target setVariable ["exitCamScript", false];
_camScriptRun = true;
_camScriptRuntime = 0;

_d0 = _distance;
_d1 = _distance + (_panMul * ((_distance * 0.1) + (random _distance)));


_h0 = _height;
_h1 = _height + (_panMul * ((_height * 0.5) + (random _height)));

_a0 = (direction _target) - (_dirOffset - (5 * _panMul)) + (_panMul * (random 10));
_a1 = (direction _target) - _dirOffset;

_s0 = speed _target;
_s1 = speed _target;

while {_camScriptRun && ((_clockTime - _camScriptRuntime) > 0)} do
{
   _s0 = _s1;
   _s1 = speed _target;
   _sDiff = (abs (_s1 - _s0));

   // THE CLOCK
   _t = 0;
   _timeLeft = _clockTime - _camScriptRuntime;
   _ticksLeft = (_timeLeft / _clockTick);
   if (_ticksLeft < 4) then
   {
      _t = _ticksLeft * _clockTick;
   } else {
      _t = 2 + floor (random ((_ticksLeft - 2) * (0.33 + (random 0.33))));
   };
   _camScriptRuntime = _camScriptRuntime + _t;
   _INT = (_camScriptRuntime / _clockTime);
   
   _d0 = _d1;
   _ds = _INT * _distShift;
   if (_s1 > _s0) then
   {
      _d1 = _distance + _ds + ((random ((_sDiff + _s1) * _distance)) * _dWeight);
   } else {
      _d1 = _distance + _ds - ((random (_sDiff * _distance)) * _dWeight);
   };

   _h0 = _h1;
   _hs = _INT * _heightShift;
   if (_s1 > _s0) then
   {
      _h1 = _height + _hs + ((random ((_sDiff - _s1) * _height)) * _hWeight);
   } else {
      _h1 = _height + _hs - ((random (_sDiff * _height)) * _hWeight);
   };

   _a0 = _a1;
   _as = _INT * _dirShift;
   _a = ((direction _target) - _dirOffset + _as);
   if (_a > _a1) then 
   {
      _a1 = (_a + _as - (random ((abs (_a - _a1)) * _panMul)));
   } else {
      _a1 = (_a + _as + (random ((abs (_a - _a1)) * _panMul)));
   };
   
   _camScript = [_cam, _target, [_d0, _d1, (_mfs select 0)], [_h0, _h1, (_mfs select 1), 0], [_a0, _a1, (_mfs select 2)], _t] execVM "modules\common\RUBE\cam\cam_panShot.sqf";
   sleep _t;
   
   // the target may have been replaced (eg. for a fake target, see cam_panShot.sqf)
   _target = camTarget _cam;
   
   // exit?
   if (_target getVariable "exitCamScript") exitWith { _camScriptRun = false; };
   if (_originalTarget getVariable "exitCamScript") exitWith { _camScriptRun = false; };
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