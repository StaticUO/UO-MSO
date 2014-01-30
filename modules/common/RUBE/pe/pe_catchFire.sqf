/*
   Auhtor:
    rübe
   
   Description:
    starts a fire at the given units named selection
    (used in catchFire.fsm)
    
   Parameter(s):
    _this select 0: unit (object)
    _this select 1: named selection (string)
    
   Returns:
    particle-source
*/

private ["_unit", "_pos", "_selection", "_fire"];

_unit = _this select 0;
_pos = position _unit;
_selection = _this select 1;


_fire = "#particlesource" createVehicleLocal _pos;

_fire setdropinterval 0.05;

_fire setParticleParams [
   ["\Ca\Data\ParticleEffects\Universal\Universal", 16, 10, 32],
   "", "Billboard", 1, 0.5, // obsolete, type, timerperiod, lifetime
   _selection, // position
   [0.04, 0.04, 0.21], // velocity
   0.78, 10, 7.9, 1, // rot, weight, vol., rubbing
   [0.27, 0.47, 0.34], // render size
   [[1,1,1,0], [1,1,0.67,-9], [1,1,0,-2], [1,1,0.31,-1], [1,1,1,-0.71], [1,1,1,0]], // render color
   [1], 1, 0, "", "", _unit
];

_fire setParticleRandom [
   (0.1 + (random 0.15)),           // lifeTime      
   [0.1, 0.1, 0.1],  // position
   [0.15, 0.15, 1.97], // moveVelocity
   2.0,             // rotationVelocity
   0.5,           // size
   [0, 0, 0, 0],  // color
   0,             // randomDirectionPeriod
   0              // angle
];

// return particle source
_fire