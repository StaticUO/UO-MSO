/*
  Author:
   rübe (inspired by I3_DelayingTheBear.Chernarus)
  
  Description:
   weather script: autumn
   color filter and ground fog around the player (or given obj)
   
  Parameters:
   _this select 0: particle source center (object; optional, default = player)
   
*/
private ["_obj", "_pos", "_fog"];

"colorCorrections" ppEffectAdjust [1, 1, 0.001, [0.01, 0.02, 0.04, 0.01], [1.22, 0.92, 0.996, 0.4], [0.299, 0.287, 0.414, 0.0]]; 
"colorCorrections" ppEffectCommit 0; 
"colorCorrections" ppEffectEnable TRUE;

setWind [4.342, 5.108, true];

_obj = player;
if ((count _this) > 0) then
{
   _obj = _this select 0;
};
_pos = position (vehicle _obj);

_fog = "#particlesource" createVehicleLocal _pos; 
_fog setParticleParams [
   ["\Ca\Data\ParticleEffects\Universal\universal.p3d" , 16, 12, 13, 0], "", "Billboard", 1, 10, 
   [0, 0, -6], [0, 0, 0], 1, 1.275, 1, 0, 
   [7,6], [[1, 1, 1, 0], [1, 1, 1, 0.04], [1, 1, 1, 0]], [1000], 1, 0, "", "", _obj
];
_fog setParticleRandom [3, [55, 55, 0.2], [0, 0, -0.1], 2, 0.45, [0, 0, 0, 0.1], 0, 0];
_fog setParticleCircle [0.1, [0, 0, -0.12]];
_fog setDropInterval 0.01;


while {true} do 
{
   _fog setpos (position (vehicle _obj));
   sleep 1;
};