/*
  Author:
   rübe
   
  Description
   building effect used to raise objects from the ground.
  
  Note
   Returned particlesources should be destroyed after building-action is done.
*/

private ["_obj", "_objDimensions", "_sizeFactor", "_objPos", "_a", "_b", "_c", "_d"];

_obj = _this select 0;
_objDimensions = [0, 0, 0];
if ((count _this) > 1) then
{
   _objDimensions = _this select 1;
};

// logarithmic growth, and we do not consider the z-axis, so this should keep things sane, hehe
_sizeFactor = log (((_objDimensions select 0) * (_objDimensions select 1) * 0.5) + 1);
_objPos = position _obj;

/*
   rocks :: falling away from _obj
*/

_a = "#particlesource" createVehicleLocal _objPos;
_a setParticleParams [
                                          // GLOBAL PARAMETERS 
   ["\Ca\Data\ParticleEffects\Pstone\Pstone.p3d",              // ShapeName
    8,                                    // - Anim Divisor (1 for a 1x1, 8 for a 8x8, etc) 
    1,                                    // - Anim Starting Row
    1],                                   // - Number of Frames to Play (speed controlled by animation phase below)
   "",                                    // AnimationName (obsolete)
   "SpaceObject",                         // Type ("Billboard" or "SpaceObject")
   1,                                     // TimerPeriod: The period of calling the "OnTimer" event (in sec).
   20,                                    // LifeTime: Life time of the particle (in sec).
   
                                          // PHYSICAL PARAMETERS 
   [0.23, 0.99, 0.05],                    // Position: Either 3D coordinate (x, y, z) or name of the selection (Object property!)
   [0.11, 0.09, 1.95],                    // MoveVelocity: 3D vector (x, y, z) which describes the velocity vector of the particle direction and speed in m/s.
   0.46,                                  // RotationVelocity: Float number which determines number of rotations in one second.
   96.0,                                  // Weight: Weight of the particle (kg).
   0.55,                                  // Volume: Volume of the particle (m^3).
   0.35,                                  // Rubbing: Float number without dimension which determines the impact of the density of the environment on this particle. 0 - no impact (vacuum). --> wind/air fraction!
   
                                          // RENDER PARAMETERS (array -> development in time) 
   [0.13,0.11],                           // Size: Size of the particle in time to render (m).
   [[0.91,0.90,0.56,1.0],                 // Colour of the particle in time to render (RGBA).
    [0.27,0.27,0.27,1.0], 
    [0.73,0.73,0.73,1.0]], 
   [0, 1],                                // AnimationPhase: Phase of the animation in time. (play speed of the selected frames for the Number of Frames to Play; higher == faster)
   0.0,                                   // RandomDirectionPeriod: Period of change of the velocity vector (s).
   0.15,                                  // RandomdirectionIntensity: Each MoveVelocity component will be changed with random value from interval <0, RandomDirectionIntensity>.
   "",                                    // OnTimer: Name of the script to run every period determined by TimerPeriod property. (this == position)
   "",                                    // BeforeDestroy: Name of the script to run right before destroying the particle. (this == position)
   _obj                                   // object: Object to bind this particle to.
]; 

// Set randomization of particle source parameters.
_a setParticleRandom [
   0,                                     // lifeTime      
   [0.25, 0.23, -0.58],                   // position
   [-1.715, -3.825, 2.814],               // moveVelocity
   0.25,                                  // rotationVelocity
   1.45,                                  // size
   [0.1, 0.1, 0.1, 0.1],                  // color
   0,                                     // randomDirectionPeriod
   55.5                                   // angle
];


// Update particle source to create particles on circle with given radius. Velocity is transformed and added to total velocity.
_a setParticleCircle [
   0,                                     // radius 
   [0.0, 0.0, 0.0]                        // velocity
];

// Set interval of emitting particles from particle source.
_a setDropInterval (4.14 + (random 3));


/*
   Sticks
*/

_b = "#particlesource" createVehicleLocal _objPos;
_b setParticleParams [
                                          // GLOBAL PARAMETERS 
   ["\Ca\Data\ParticleEffects\Hit_Leaves\Sticks.p3d",              // ShapeName
    8,                                    // - Anim Divisor (1 for a 1x1, 8 for a 8x8, etc) 
    1,                                    // - Anim Starting Row
    1],                                   // - Number of Frames to Play (speed controlled by animation phase below)
   "",                                    // AnimationName (obsolete)
   "SpaceObject",                         // Type ("Billboard" or "SpaceObject")
   1,                                     // TimerPeriod: The period of calling the "OnTimer" event (in sec).
   12,                                    // LifeTime: Life time of the particle (in sec).
   
                                          // PHYSICAL PARAMETERS
   [0.17, 0.85, 0.12],                    // Position: Either 3D coordinate (x, y, z) or name of the selection (Object property!)
   [-0.15, 0.54, 1.35],                   // MoveVelocity: 3D vector (x, y, z) which describes the velocity vector of the particle direction and speed in m/s.
   0.16,                                  // RotationVelocity: Float number which determines number of rotations in one second.
   182.0,                                 // Weight: Weight of the particle (kg).
   2.15,                                  // Volume: Volume of the particle (m^3).
   0.62,                                  // Rubbing: Float number without dimension which determines the impact of the density of the environment on this particle. 0 - no impact (vacuum). --> wind/air fraction!
   
                                          // RENDER PARAMETERS (array -> development in time) 
   [0.07,0.05],                           // Size: Size of the particle in time to render (m).
   [[0.91,0.90,0.56,1.0],                 // Colour of the particle in time to render (RGBA).
    [0.27,0.27,0.27,1.0], 
    [0.73,0.73,0.73,1.0]], 
   [0, 1],                                // AnimationPhase: Phase of the animation in time. (play speed of the selected frames for the Number of Frames to Play; higher == faster)
   0,                                     // RandomDirectionPeriod: Period of change of the velocity vector (s).
   0.25,                                  // RandomdirectionIntensity: Each MoveVelocity component will be changed with random value from interval <0, RandomDirectionIntensity>.
   "",                                    // OnTimer: Name of the script to run every period determined by TimerPeriod property. (this == position)
   "",                                    // BeforeDestroy: Name of the script to run right before destroying the particle. (this == position)
   _obj                                   // object: Object to bind this particle to.
]; 

// Set randomization of particle source parameters.
_b setParticleRandom [
   0,                                     // lifeTime      
   [-0.25, 0.83, -0.18],                  // position
   [4.415, 3.825, 3.534],                 // moveVelocity
   0.07,                                  // rotationVelocity
   0.45,                                  // size
   [0.1, 0.1, 0.1, 0.0],                  // color
   0,                                     // randomDirectionPeriod
   140.5                                  // angle
];


// Update particle source to create particles on circle with given radius. Velocity is transformed and added to total velocity.
_b setParticleCircle [
   0,                                     // radius 
   [0.0, 0.0, 0.0]                        // velocity
];

// Set interval of emitting particles from particle source.
_b setDropInterval (1.24 + (random 0.5));

/*
   random objects :: 
*/

private ["_shapes"];

_shapes = [
   "\Ca\Data\ParticleEffects\Shard\shard.p3d",
   "\Ca\Data\ParticleEffects\WallPart\WallPart.p3d",
   "\Ca\Data\ParticleEffects\Universal\WoodChippings.p3d",
   "\Ca\Data\ParticleEffects\Universal\GlassShards.p3d"
];

_c = "#particlesource" createVehicleLocal _objPos;
_c setParticleParams [
                                          // GLOBAL PARAMETERS 
   [(_shapes call RUBE_randomSelect),              // ShapeName
    8,                                    // - Anim Divisor (1 for a 1x1, 8 for a 8x8, etc) 
    1,                                    // - Anim Starting Row
    1],                                   // - Number of Frames to Play (speed controlled by animation phase below)
   "",                                    // AnimationName (obsolete)
   "SpaceObject",                         // Type ("Billboard" or "SpaceObject")
   1,                                     // TimerPeriod: The period of calling the "OnTimer" event (in sec).
   9,                                     // LifeTime: Life time of the particle (in sec).
   
                                          // PHYSICAL PARAMETERS 
   [0.23, 0.99, 0.02],                    // Position: Either 3D coordinate (x, y, z) or name of the selection (Object property!)
   [0.11, 0.09, 1.95],                    // MoveVelocity: 3D vector (x, y, z) which describes the velocity vector of the particle direction and speed in m/s.
   0.96,                                  // RotationVelocity: Float number which determines number of rotations in one second.
   56.0,                                  // Weight: Weight of the particle (kg).
   0.05,                                  // Volume: Volume of the particle (m^3).
   0.48,                                  // Rubbing: Float number without dimension which determines the impact of the density of the environment on this particle. 0 - no impact (vacuum). --> wind/air fraction!
   
                                          // RENDER PARAMETERS (array -> development in time) 
   [0.15,0.15],                           // Size: Size of the particle in time to render (m).
   [[0.91,0.90,0.56,1.0],                 // Colour of the particle in time to render (RGBA).
    [0.27,0.27,0.27,1.0], 
    [0.73,0.73,0.73,1.0]], 
   [0, 1],                                // AnimationPhase: Phase of the animation in time. (play speed of the selected frames for the Number of Frames to Play; higher == faster)
   0.0,                                   // RandomDirectionPeriod: Period of change of the velocity vector (s).
   0.15,                                  // RandomdirectionIntensity: Each MoveVelocity component will be changed with random value from interval <0, RandomDirectionIntensity>.
   "",                                    // OnTimer: Name of the script to run every period determined by TimerPeriod property. (this == position)
   "",                                    // BeforeDestroy: Name of the script to run right before destroying the particle. (this == position)
   _obj                                   // object: Object to bind this particle to.
]; 

// Set randomization of particle source parameters.
_c setParticleRandom [
   0,                                     // lifeTime      
   [-0.25, 0.23, -0.58],                  // position
   [2.425, 2.375, 4.814],                 // moveVelocity
   1.25,                                  // rotationVelocity
   1.02,                                  // size
   [0.1, 0.1, 0.1, 0.0],                  // color
   0,                                     // randomDirectionPeriod
   360                                    // angle
];


// Update particle source to create particles on circle with given radius. Velocity is transformed and added to total velocity.
_c setParticleCircle [
   0,                                     // radius 
   [0.0, 0.0, 0.0]                        // velocity
];

// Set interval of emitting particles from particle source.
_c setDropInterval (1.54 + (random 0.75));


/*
   dust cloud :: 
*/

private ["_colors", "_sizes", "_billboard"];

_colors = [
   [
      [0.65,0.61,0.35,0.11],                
      [0.12,0.08,0.02,0.02],
      [0.42,0.39,0.21,0.18],
      [0.32,0.25,0.09,0.05], 
      [0.36,0.30,0.11,0.0]
   ],
   [
      [0.24,0.25,0.13,0.01],          
      [0.11,0.13,0.08,0.13],
      [0.29,0.28,0.21,0.04],
      [0.33,0.32,0.15,0.005], 
      [0.10,0.10,0.06,0.0]
   ],
   [
      [0.1, 0.095, 0.09, 0.7],
      [0.5, 0.45, 0.4, 0.4],
      [0.96, 0.931, 0.84, 0.2],
      [1.0, 0.95, 0.9, 0.1],
      [0.95, 0.91, 0.61, 0.05],
      [0.91, 0.85, 0.51, 0.0]
   ],
   [
      [1, 1, 1, 0],
      [0.6, 0.57, 0.21, -0.1],
      [1, 1, 1, -0.175],
      [1, 1, 1, 0]
   ]
];

_sizes = [
   [0.21,0.28,0.38,0.61,0.64],
   [0.40,0.41,0.51,0.77,0.78],
   [0.51,0.45,0.36,0.32,0.25],
   [0.62,0.78,0.84,0.89,0.89],
   [0.76,0.61,0.34,0.29,0.09],
   [0.17,0.48,0.51,0.91,0.91]
];


_billboard = ["\Ca\Data\ParticleEffects\Universal\Universal", 16, 7, 48];
if ((random 100) > 50) then
{
   _billboard = ["\Ca\Data\ParticleEffects\Universal\Universal", 16, 12, 13];
};

_d = "#particlesource" createVehicleLocal _objPos;
_d setParticleParams [
                                          // GLOBAL PARAMETERS 
   [(_billboard select 0),                // ShapeName
    (_billboard select 1),                // - Anim Divisor (1 for a 1x1, 8 for a 8x8, etc) 
    (_billboard select 2),                // - Anim Starting Row
    (_billboard select 3)],               // - Number of Frames to Play (speed controlled by animation phase below)
   "",                                    // AnimationName (obsolete)
   "Billboard",                           // Type ("Billboard" or "SpaceObject")
   1,                                     // TimerPeriod: The period of calling the "OnTimer" event (in sec).
   6,                                    // LifeTime: Life time of the particle (in sec).
   
                                          // PHYSICAL PARAMETERS 
   [0.01, 0.32, 0.34],                    // Position: Either 3D coordinate (x, y, z) or name of the selection (Object property!)
   [0, 0, (-0.04 - (random 0.1))],                           // MoveVelocity: 3D vector (x, y, z) which describes the velocity vector of the particle direction and speed in m/s.
   (random 1),                                     // RotationVelocity: Float number which determines number of rotations in one second.
   (13.54 + (random 0.1)),                                 // Weight: Weight of the particle (kg).
   9.5,                                    // Volume: Volume of the particle (m^3).
   0.911,                                  // Rubbing: Float number without dimension which determines the impact of the density of the environment on this particle. 0 - no impact (vacuum). --> wind/air fraction!
   
                                          // RENDER PARAMETERS (array -> development in time) 
   (_sizes call RUBE_randomSelect),                           // Size: Size of the particle in time to render (m).
   (_colors call RUBE_randomSelect), 
   [0, 1],                                // AnimationPhase: Phase of the animation in time. (play speed of the selected frames for the Number of Frames to Play; higher == faster)
   0,                                     // RandomDirectionPeriod: Period of change of the velocity vector (s).
   0,                                     // RandomdirectionIntensity: Each MoveVelocity component will be changed with random value from interval <0, RandomDirectionIntensity>.
   "",                                    // OnTimer: Name of the script to run every period determined by TimerPeriod property. (this == position)
   "",                                    // BeforeDestroy: Name of the script to run right before destroying the particle. (this == position)
   _obj                                   // object: Object to bind this particle to.
]; 

// Set randomization of particle source parameters.
_d setParticleRandom [
   0,                                     // lifeTime      
   [0.02, 0.02, -0.04],                     // position
   [(0.75 + (random 1.5)), (0.75 + (random 1.5)), -0.2],                 // moveVelocity
   1,                                     // rotationVelocity
   //0.62,                                  // size
   (0.62 + _sizeFactor),
   [0, 0, 0, 0.25],                       // color
   0,                                     // randomDirectionPeriod
   0                                      // angle
];


// Update particle source to create particles on circle with given radius. Velocity is transformed and added to total velocity.
_d setParticleCircle [
   0,                                    // radius 
   [0, 0, 0]                   // velocity
];


// Set interval of emitting particles from particle source.
_d setDropInterval 0.03;


// we return an array of all particles, 
// so they can be deleted at the right time
[_a, _b, _c, _d]