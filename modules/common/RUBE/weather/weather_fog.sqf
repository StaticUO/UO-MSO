/*
  Author:
   rübe (inspired by I3_DelayingTheBear.Chernarus)
  
  Description:
   some fog with a blue tint
   
  Parameters:
   _this select 0: particle source center (object; optional, default = player)
   _this select 1: while-condition (code; optional, default = {true})
   
*/

private ["_obj", "_pos", "_condition", "_fog1", "_fog2", "_r", "_g", "_b", "_alpha", "_di1", "_di2", "_n"];

_obj = player;
_condition = {true};
if ((typeName _this) == "ARRAY") then
{
   if ((count _this) > 0) then
   {
      _obj = _this select 0;
   };
   if ((count _this) > 1) then
   {
      _condition = _this select 1;
   };
};

_pos = position (vehicle _obj);

// drop intervals
_di1 = 0.006;
_di2 = 0.002;

// world dependend color variations/multipliers
_r = 1.0;
_g = 1.0;
_b = 1.0;
_alpha = 1.0;

switch (true) do
{
   // desert themed
   case (worldName in ["Takistan", "Zargabad"]):
   {
      _b = 0.92;
      _g = 0.83;
      _alpha = 0.94;
   };
   // woodland themed such as Chernarus, Utes, ...
   default
   {
      _b = 0.74;
      _g = 0.79;
      _alpha = 0.71;
   };
};


// ground fog
_fog1 = "#particlesource" createVehicleLocal _pos; 
_fog1 setParticleParams [
   ["\Ca\Data\ParticleEffects\Universal\universal.p3d" , 16, 12, 13, 0], "", 
   "Billboard", 1, 12, // type, timerperiod, lifetime
   [0, 0, -11], // position
   [0, 0, 0],  // move velocity
   0.01,  // rot. velocity
   1.281, 1, 0.002, // weight, volume, rubbing
   [7,9,8], // render size
   [
      [1, 1, 1, 0], 
      [1, 1, 1, 0.04*_alpha], 
      [1, 1, 1, 0.076*_alpha], 
      [1, 1, 1, 0.03*_alpha], 
      [1, 1, 1, 0]
   ], // render color
   [1000], // animation phase
   1, 0, "", "", _obj // randDir period, randDir Int., onTimer, beforeDestroy, obj
];
_fog1 setParticleRandom [
   5, // lifeTime 
   [97, 97, 0.0], // position
   [0, 0, -0.1], // moveVelocity
   0.02, // rotationVelocity
   0.35, // size
   [0.01, 0.01, 0.01, 0.1], // color
   0, // randomDirectionPeriod
   0 // angle
];
_fog1 setParticleCircle [
   32.1, // radius 
   [0.1, 0.1, -0.02] // velocity
];
_fog1 setDropInterval _di1;


// ground fog
_fog2 = "#particlesource" createVehicleLocal _pos; 
_fog2 setParticleParams [
   ["\Ca\Data\ParticleEffects\Universal\universal.p3d" , 16, 12, 13, 0], "", 
   "Billboard", 1, 12, // type, timerperiod, lifetime
   [0, 0, 0], // position
   [0, 0, 0],  // move velocity
   0.04,  // rot. velocity
   1.280, 1, 0.003, // weight, volume, rubbing
   [6,8,6,7], // render size
   [
      [1,       0.98,    0.97,    0], 
      [0.87*_r, 0.97*_g, 0.71*_b, 0.025*_alpha], 
      [0.34*_r, 0.96*_g, 0.99*_b, 0.047*_alpha], 
      [1*_r,    0.99*_g, 0.98*_b, 0.01*_alpha], 
      [1,       0.99,    0.98,    0]
   ], // render color
   [1000], // animation phase
   1, 0, "", "", _obj // randDir period, randDir Int., onTimer, beforeDestroy, obj
];
_fog2 setParticleRandom [
   3, // lifeTime 
   [72, 72, 0.0], // position
   [0.02, 0.02, -0.1], // moveVelocity
   0.024, // rotationVelocity
   0.4, // size
   [0, 0, 0.2, 0.1], // color
   0, // randomDirectionPeriod
   0 // angle
];
_fog2 setParticleCircle [
   21.0, // radius 
   [0.002, 0.002, -0.017] // velocity
];
_fog2 setDropInterval _di2;


while _condition do
{
   _pos = position (vehicle _obj);
   _fog1 setPos _pos;
   sleep (random 1.0);
   _fog2 setPos _pos;
   sleep 1.337;
};


// slowly fade away...
_n = floor (5 + (random 7));
for "_i" from 0 to _n do
{
   _di1 = _di1 + 0.006;
   _di2 = _di2 + 0.002;
   
   _fog1 setDropInterval _di1;
   _fog2 setDropInterval _di2;
   
   sleep (3 + (random 9));
};
deleteVehicle _fog1;

_n = floor (3 + (random 6));
for "_i" from 0 to _n do
{
   _di2 = _di2 + 0.002;
   _fog2 setDropInterval _di2;
   
   sleep (2 + (random 5));
};
deleteVehicle _fog2;
