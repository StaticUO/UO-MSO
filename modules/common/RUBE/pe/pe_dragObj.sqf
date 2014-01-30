/*
  Author:
   rübe
   
  Description
   mud-smoke effect used to drag ammoboxes around.
  
  Note
   Returned particlesources should be destroyed after drag-action is done (most likely repeatedly).
*/

private ["_obj", "_objPos", "_a", "_b"];

_obj = _this select 0;
_objPos = position _obj;

/*
   WoodChippings
*/

_a = "#particlesource" createVehicleLocal _objPos;
_a setParticleParams [
                                          // GLOBAL PARAMETERS 
   ["\Ca\Data\ParticleEffects\Universal\WoodChippings.p3d",              // ShapeName
    8,                                    // - Anim Divisor (1 for a 1x1, 8 for a 8x8, etc) 
    1,                                    // - Anim Starting Row
    1],                                   // - Number of Frames to Play (speed controlled by animation phase below)
   "",                                    // AnimationName (obsolete)
   "SpaceObject",                         // Type ("Billboard" or "SpaceObject")
   1,                                     // TimerPeriod: The period of calling the "OnTimer" event (in sec).
   12,                                    // LifeTime: Life time of the particle (in sec).
   
                                          // PHYSICAL PARAMETERS
   [0.17, 0.85, 0.06],                    // Position: Either 3D coordinate (x, y, z) or name of the selection (Object property!)
   [-0.15, 0.54, 1.35],                   // MoveVelocity: 3D vector (x, y, z) which describes the velocity vector of the particle direction and speed in m/s.
   0.16,                                  // RotationVelocity: Float number which determines number of rotations in one second.
   182.0,                                 // Weight: Weight of the particle (kg).
   2.15,                                  // Volume: Volume of the particle (m^3).
   0.62,                                  // Rubbing: Float number without dimension which determines the impact of the density of the environment on this particle. 0 - no impact (vacuum). --> wind/air fraction!
   
                                          // RENDER PARAMETERS (array -> development in time) 
   [0.03,0.03],                           // Size: Size of the particle in time to render (m).
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
_a setParticleRandom [
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
_a setParticleCircle [
   0,                                     // radius 
   [0.0, 0.0, 0.0]                        // velocity
];

// Set interval of emitting particles from particle source.
_a setDropInterval (1.44 + (random 0.5));



private ["_colors", "_sizes"];

_colors = [
   [
      [0.98, 0.931, 0.84, 0.2],
      [1.0, 0.95, 0.78, 0.1],
      [0.99, 0.97, 0.89, 0.05],
      [0.95, 0.89, 0.81, 0.0]
   ],
   [
      [1, 0.97, 0.91, 0],
      [1.0, 0.95, 0.78, -0.1],
      [1, 0.96, 0.92, -0.175],
      [1, 0.97, 0.85, 0]
   ]
];

_sizes = [
   [0.21,0.28,0.38,0.61,0.64],
   [0.40,0.41,0.51,0.77,0.78],
   [0.51,0.45,0.36,0.32,0.25],
   [0.76,0.61,0.34,0.29,0.09]
];


_b = "#particlesource" createVehicleLocal _objPos;
_b setParticleParams [
                                          // GLOBAL PARAMETERS 
   ["\Ca\Data\ParticleEffects\Universal\Universal",                // ShapeName
    16,                // - Anim Divisor (1 for a 1x1, 8 for a 8x8, etc) 
    12,                // - Anim Starting Row
    13],               // - Number of Frames to Play (speed controlled by animation phase below)
   "",                                    // AnimationName (obsolete)
   "Billboard",                           // Type ("Billboard" or "SpaceObject")
   1,                                     // TimerPeriod: The period of calling the "OnTimer" event (in sec).
   6,                                    // LifeTime: Life time of the particle (in sec).
   
                                          // PHYSICAL PARAMETERS 
   [0, 0, -0.94],                    // Position: Either 3D coordinate (x, y, z) or name of the selection (Object property!)
   [0, 0, (-0.04 - (random 0.1))],                           // MoveVelocity: 3D vector (x, y, z) which describes the velocity vector of the particle direction and speed in m/s.
   (random 1),                                     // RotationVelocity: Float number which determines number of rotations in one second.
   (13.34 + (random 0.1)),                                 // Weight: Weight of the particle (kg).
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
_b setParticleRandom [
   0,                                     // lifeTime      
   [0.02, 0.02, -0.24],                     // position
   [((sin (random 1)) * 0.5), ((sin (random 1)) * 0.5), -0.2],                 // moveVelocity
   1,                                     // rotationVelocity
   (0.52 + (random 1.3)),                                  // size
   [0, 0, 0, 0.25],                       // color
   0,                                     // randomDirectionPeriod
   0                                      // angle
];


// Update particle source to create particles on circle with given radius. Velocity is transformed and added to total velocity.
_b setParticleCircle [
   0.75,                                    // radius 
   [0.4, 0.4, 0.2]                   // velocity
];


// Set interval of emitting particles from particle source.
_b setDropInterval 0.03;



// we return an array of all particles, 
// so they can be deleted at the right time
[_a, _b]