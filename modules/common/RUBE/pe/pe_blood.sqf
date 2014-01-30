/*
  Author:
   rübe
   
  Description
   blood effect for fist fights 
  
  Note
   Returned particlesources should be quickly destroyed after emmitted.
   Attaching the particle to the head somehow doesn't work... or I'm simply too stupid once again :/
*/
private ["_obj", "_obj2", "_objPos", "_a", "_dir", "_speed", "_dv", "_sd", "_obj2Pos", "_diff"];

_obj = _this select 0;
_obj2 = _this select 1;
_objPos = position _obj;
_obj2Pos = position _obj2;

_diff = [
   ((_obj2Pos select 0) - (_objPos select 0)),
   ((_obj2Pos select 1) - (_objPos select 1)),
   ((_obj2Pos select 2) - (_objPos select 2))
];

_dir = (direction _obj) - (160 + random 40);
_speed = (10 + (random 20));
/*
_dv = [
   ((cos _dir) * _speed / 230),
   ((sin _dir) * _speed / 230),
   (- (random 0.3) * _speed / 230)
];
*/

_dv = [
   ((- (_diff select 0) * 12) * _speed),
   ((- (_diff select 1) * 12) * _speed),
   ((- (_diff select 2) * 12) * _speed)
];

_sd = 0.8 + (random 0.4);


// Name of the selection where the unit was damaged "nohy" - leg, "ruce" - hand, "hlava" - head, "telo" - body)



/*
   Blood
*/

_a = "#particlesource" createVehicleLocal _objPos;
_a setParticleParams [
                                          // GLOBAL PARAMETERS 
   ["\ca\Data\ParticleEffects\Universal\Universal",              // ShapeName
    16,                                    // - Anim Divisor (1 for a 1x1, 8 for a 8x8, etc) 
    13,                                    // - Anim Starting Row
    1],                                   // - Number of Frames to Play (speed controlled by animation phase below)
   "",                                    // AnimationName (obsolete)
   "Billboard",                         // Type ("Billboard" or "SpaceObject")
   1,                                     // TimerPeriod: The period of calling the "OnTimer" event (in sec).
   1.6,                                    // LifeTime: Life time of the particle (in sec).
   
                                          // PHYSICAL PARAMETERS
   [0,0,1.75],                    // Position: Either 3D coordinate (x, y, z) or name of the selection (Object property!)
   _dv,                   // MoveVelocity: 3D vector (x, y, z) which describes the velocity vector of the particle direction and speed in m/s.
   1.0,                                  // RotationVelocity: Float number which determines number of rotations in one second.
   0.24,                                 // Weight: Weight of the particle (kg).
   0.1,                                  // Volume: Volume of the particle (m^3).
   0.05,                                  // Rubbing: Float number without dimension which determines the impact of the density of the environment on this particle. 0 - no impact (vacuum). --> wind/air fraction!
   
                                          // RENDER PARAMETERS (array -> development in time) 
   [0.017 * _sd,0.022 * _sd],                           // Size: Size of the particle in time to render (m).
   [[0.5,0.5,0.5,1.0],                 // Colour of the particle in time to render (RGBA).
    [0.5,0.5,0.5,1.0]], 
   [0, 1],                                // AnimationPhase: Phase of the animation in time. (play speed of the selected frames for the Number of Frames to Play; higher == faster)
   0,                                     // RandomDirectionPeriod: Period of change of the velocity vector (s).
   0,                                  // RandomdirectionIntensity: Each MoveVelocity component will be changed with random value from interval <0, RandomDirectionIntensity>.
   "",                                    // OnTimer: Name of the script to run every period determined by TimerPeriod property. (this == position)
   "",                                    // BeforeDestroy: Name of the script to run right before destroying the particle. (this == position)
   _obj                                   // object: Object to bind this particle to.
]; 

// Set randomization of particle source parameters.
_a setParticleRandom [
   0.4,                                     // lifeTime      
   [0.05, 0.05, 0.05],                  // position
   [0.035, 0.035, 0.025],                 // moveVelocity
   1,                                  // rotationVelocity
   0.007,                                  // size
   [0.0, 0.0, 0.0, 0.2],                  // color
   0,                                     // randomDirectionPeriod
   0                                  // angle
];


// Update particle source to create particles on circle with given radius. Velocity is transformed and added to total velocity.
_a setParticleCircle [
   0,                                     // radius 
   [0.0, 0.0, 0.0]                        // velocity
];

// Set interval of emitting particles from particle source.
_a setDropInterval 0.012;


// we return an array of all particles, 
// so they can be deleted at the right time
[_a]