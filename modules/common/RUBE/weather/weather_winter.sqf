/*
  Author:
   rübe (inspired by I3_DelayingTheBear.Chernarus)
  
  Description:
   weather script: winter
   color filter, light snow particles and ground fog around the player (or given obj)
   
  Parameters:
   _this select 0: particle source center (object; optional, default = player)
   
*/
private ["_obj", "_pos", "_snow", "_fog"];

"colorCorrections" ppEffectAdjust [1, 1, 0, [0.01, 0.02, 0.04, 0.01], [0.87, 1.08, 1.196, 0.3], [0.399, 0.287, 0.014, 0.0]]; 
"colorCorrections" ppEffectCommit 0; 
"colorCorrections" ppEffectEnable TRUE;

setWind [2.342, 3.108, true];

_obj = player;
if ((count _this) > 0) then
{
   _obj = _this select 0;
};
_pos = position (vehicle _obj);

// snow
_snow = "#particlesource" createVehicleLocal _pos; 
_snow setParticleParams [
                                          // GLOBAL PARAMETERS 
   ["\Ca\Data\cl_water.p3d",              // ShapeName
    1,                                    // - Anim Divisor (1 for a 1x1, 8 for a 8x8, etc) 
    1,                                    // - Anim Starting Row
    1],                                   // - Number of Frames to Play (speed controlled by animation phase below)
   "",                                    // AnimationName (obsolete)
   "Billboard",                           // Type ("Billboard" or "SpaceObject")
   1,                                     // TimerPeriod: The period of calling the "OnTimer" event (in sec).
   7,                                     // LifeTime: Life time of the particle (in sec).
   
                                          // PHYSICAL PARAMETERS
   [0, 0, 20.0],                          // Position: Either 3D coordinate (x, y, z) or name of the selection (Object property!)
   [0, 0, -0.35],                         // MoveVelocity: 3D vector (x, y, z) which describes the velocity vector of the particle direction and speed in m/s.
   1.0,                                  // RotationVelocity: Float number which determines number of rotations in one second.
   0.000001,                                  // Weight: Weight of the particle (kg).
   0.0,                                  // Volume: Volume of the particle (m^3).
   0.4,                                  // Rubbing: Float number without dimension which determines the impact of the density of the environment on this particle. 0 - no impact (vacuum). --> wind/air fraction!
   
                                          // RENDER PARAMETERS (array -> development in time) 
   [0.17,0.05],                           // Size: Size of the particle in time to render (m).
   [[1.0,1.0,1.0,1.0],                    // Colour of the particle in time to render (RGBA).
    [0.94,0.94,0.96,1.0], 
    [1.0,1.0,1.0,1.0]], 
   [0, 1],                                // AnimationPhase: Phase of the animation in time. (play speed of the selected frames for the Number of Frames to Play; higher == faster)
   0,                                     // RandomDirectionPeriod: Period of change of the velocity vector (s).
   0.01,                                  // RandomdirectionIntensity: Each MoveVelocity component will be changed with random value from interval <0, RandomDirectionIntensity>.
   "",                                    // OnTimer: Name of the script to run every period determined by TimerPeriod property. (this == position)
   "",                                    // BeforeDestroy: Name of the script to run right before destroying the particle. (this == position)
   _obj                                   // object: Object to bind this particle to.
];
_snow setParticleRandom [
   2,                                     // lifeTime      
   [35, 35, 10],                          // position
   [0.0, 0.0, -0.1],                    // moveVelocity
   0.001,                                  // rotationVelocity
   0.05,                                  // size
   [0.01, 0.01, 0.01, 0.02],              // color
   0.002,                                  // randomDirectionPeriod
   360                                    // angle
];
_snow setParticleCircle [
   0,                                     // radius 
   [0.0, 0.0, -0.1]                     // velocity
];
_snow setDropInterval 0.01;


// ground fog
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
   _pos = position (vehicle _obj);
   _snow setpos _pos;
   _fog setpos _pos;
   sleep 1;
};