/*
   RUBE weather module,
   particle definition library
   --
   Warning:
    Don't even think about editing this file unless you make your editor's window at leeeeeaaaasst thiiiiiiiissss wide.
   --                                                                                                                 ^
                                                                                                                      |
   
   -> These are no functions, but arrays we setup once. There
      is no real input, instead we will modify certain values
      as described (or so...), to continously create, redefine
      and delete our particles...
      
         ... also I really don't feel like putting this wall
      of comments into an fsm state... since there's still a
      memory/buffer overflow bug with the editor. :/
      
     (see http://forums.bistudio.com/showthread.php?t=105840 )
   
   -> Sorry for the mess, but editing particles is a dirty 
      business. ;)
*/



/*
   RUBE_weatherModuleP(article)D(efinition)Snow
   
   input:      snow-intensity [0,1]
   
   affected:   [1:1] width of the particle field -> density
               [3] drop interval
               [0:10] rubbing; fast/straight down or fluffy and gentle?
               [0:14] random dir period; ^^
               [0:15] random dir intensity; ^^
*/
RUBE_weatherPDSnow = [
   // 0: particle definition/parameters
   [
   /******/ /* GLOBAL PARAMETERS */ 
   /*  0 */ [
               "\Ca\Data\ParticleEffects\Universal\Universal",      // 0: ShapeName
               16,                                                  // 1: Anim Divisor (1 for a 1x1, 8 for a 8x8, etc)
               12,                                                  // 2: Anim Starting Row (index)
               8,                                                   // 3: Number of Frames to Play (count)
               1                                                    // 4: loop (bool)
            ],
   /*  1 */ "",                              // AnimationName (obsolete)
   /*  2 */ "Billboard",                     // Type ("Billboard" or "SpaceObject")
   /*  3 */ 1,                               // TimerPeriod: The period of calling the "OnTimer" event (in sec)
   /*  4 */ 9,                               // LifeTime: Life time of the particle (in sec)

   /******/ /* PHYSICAL PARAMETERS */
   /*  5 */ [0, 0, 17.0],                    // Position: Either 3D coordinate (x, y, z) or 
                                             //    name of the selection (Object property!)
   /*  6 */ [0, 0, 0],                       // MoveVelocity: 3D vector (x, y, z) which describes the velocity
                                             //    vector of the particle direction and speed in m/s
   /*  7 */ 1.0,                             // RotationVelocity: Float number which determines number of 
                                             //    rotations in one second
   /*  8 */ 0.000001,                        // Weight: Weight of the particle (kg).
   /*  9 */ 0.0000005,                       // Volume: Volume of the particle (m^3).
   /* 10 */ 1.2,                             // Rubbing: Float number without dimension which determines the
                                             //    impact of the density of the environment on this particle.
                                             //    0 - no impact (vacuum). --> wind/air fraction!

   /******/ /* RENDER PARAMETERS (array := development in time) */
   /* 11 */ [0.07,0.04],                     // Size: Size of the particle in time to render (m)
   /* 12 */ [                                // Colour of the particle in time to render (RGBA)
               [1.0,1.0,1.0,0.0],
               [1.0,1.0,1.0,1.0],
               [1.0,1.0,1.0,1.0]
            ],
   /* 13 */ [0, 1],                          // AnimationPhase: Phase of the animation in time. (play speed of
                                             //    the selected frames for the Number of Frames to Play;
                                             //    higher == faster
   /* 14 */ 0.4,                             // RandomDirectionPeriod: Period of change of the velocity vector (s)
   /* 15 */ 0.6,                             // RandomdirectionIntensity: Each MoveVelocity component will be
                                             //    changed with random value from interval <0,Rand.Dir.Int.>
   /* 16 */ "",                              // OnTimer: Name of the script to run every period determined by
                                             //    TimerPeriod property. (this == position)
   /* 17 */ "",                              // BeforeDestroy: Name of the script to run right before destroying
                                             //    the particle. (this == position)
   /* 18 */ ""                               // object: Object to bind this particle to.
   ],
   
   // 1: particle random definition
   [
   /*  0 */ 1,                               // lifeTime      
   /*  1 */ [12, 12, 10],                    // position
   /*  2 */ [0.0, 0.0, 0.0],                 // moveVelocity
   /*  3 */ 0.0,                             // rotationVelocity
   /*  4 */ 0.007,                           // size
   /*  5 */ [0.0, 0.0, 0.0, 0.0],            // color
   /*  6 */ 0,                               // randomDirectionPeriod
   /*  7 */ 0                                // angle
   ],
   
   // 2: particle circle definition
   [
   /*  0 */ 0,                               // radius 
   /*  1 */ [0.0, 0.0, 0.0]                  // velocity
   ],
   
   // 3: particle drop interval
   0.01
];



/*
   RUBE_weatherModuleP(article)D(efinition)Fog
*/
RUBE_weatherPDFog = [
   // 0: particle definition/parameters
   [
   /******/ /* GLOBAL PARAMETERS */ 
   /*  0 */ [
               "\Ca\Data\ParticleEffects\Universal\Universal",      // 0: ShapeName
               16,                                                  // 1: Anim Divisor (1 for a 1x1, 8 for a 8x8, etc)
               14,                                                  // 2: Anim Starting Row (index)
               5,                                                   // 3: Number of Frames to Play (count)
               1                                                    // 4: loop (bool)
               
               //"\Ca\Data\ParticleEffects\Universal\universal.p3d" , 16, 7, 48, 0
            ],
   /*  1 */ "",                              // AnimationName (obsolete)
   /*  2 */ "Billboard",                     // Type ("Billboard" or "SpaceObject")
   /*  3 */ 1,                               // TimerPeriod: The period of calling the "OnTimer" event (in sec)
   /*  4 */ 18,                              // LifeTime: Life time of the particle (in sec)

   /******/ /* PHYSICAL PARAMETERS */
   /*  5 */ [0, 0, -7],                      // Position: Either 3D coordinate (x, y, z) or 
                                             //    name of the selection (Object property!)
   /*  6 */ [0, 0, -0.01],                   // MoveVelocity: 3D vector (x, y, z) which describes the velocity
                                             //    vector of the particle direction and speed in m/s
   /*  7 */ 0.2,                             // RotationVelocity: Float number which determines number of 
                                             //    rotations in one second
   /*  8 */ 127.65,                          // Weight: Weight of the particle (kg).
   /*  9 */ 100,                             // Volume: Volume of the particle (m^3).
   /* 10 */ 1.2,                             // Rubbing: Float number without dimension which determines the
                                             //    impact of the density of the environment on this particle.
                                             //    0 - no impact (vacuum). --> wind/air fraction!

   /******/ /* RENDER PARAMETERS (array := development in time) */
   /* 11 */ [14,15.5,16],                    // Size: Size of the particle in time to render (m)
   /* 12 */ [                                // Colour of the particle in time to render (RGBA)
               [1.0,1.0,1.0,0.0],
               [1.0,1.0,1.0,0.12],
               [1.0,1.0,1.0,0.0]
            ],
   /* 13 */ [0, 0.1],                      // AnimationPhase: Phase of the animation in time. (play speed of
                                             //    the selected frames for the Number of Frames to Play;
                                             //    higher == faster
   /* 14 */ 0,                               // RandomDirectionPeriod: Period of change of the velocity vector (s)
   /* 15 */ 0,                               // RandomdirectionIntensity: Each MoveVelocity component will be
                                             //    changed with random value from interval <0,Rand.Dir.Int.>
   /* 16 */ "",                              // OnTimer: Name of the script to run every period determined by
                                             //    TimerPeriod property. (this == position)
   /* 17 */ "",                              // BeforeDestroy: Name of the script to run right before destroying
                                             //    the particle. (this == position)
   /* 18 */ ""                               // object: Object to bind this particle to.
   ],
   
   // 1: particle random definition
   [
   /*  0 */ 5,                               // lifeTime      
   /*  1 */ [300, 300, 0.52],                // position
   /*  2 */ [0.002, 0.002, -0.12],           // moveVelocity
   /*  3 */ 0.02,                            // rotationVelocity
   /*  4 */ 1.11,                            // size
   /*  5 */ [0.0, 0.0, 0.0, 0.02],           // color
   /*  6 */ 0,                               // randomDirectionPeriod
   /*  7 */ 0                                // angle
   ],
   
   // 2: particle circle definition
   [
   /*  0 */ 25.01,                           // radius 
   /*  1 */ [0, 0, -0.14]                    // velocity
   ],
   
   // 3: particle drop interval
   0.01
];


// done
RUBE_weatherModuleParticlesInit = true;