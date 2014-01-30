/*
   Auhtor:
    rübe
   
   Description:
    starts a fire at the given units named selection
    (used in catchFire.fsm)
    
   Parameter(s):
    _this select 0: unit (object)
    _this select 1: named selection (string, optional)
    
   Returns:
    particle-source
*/

private ["_unit", "_pos", "_selection", "_smoke"];

_unit = _this select 0;
_pos = position _unit;
_selection = "Pelvis";
if ((count _this) > 1) then
{
   _selection = _this select 1;
};

_smoke = "#particlesource" createVehicleLocal _pos;

_smoke setDropInterval 0.15;

_smoke setParticleParams [
   ["\Ca\Data\ParticleEffects\Universal\Universal", 16, 7, 48], 
   "","Billboard",1, (3 + (random 3)), // obsolete, type, timerperiod, lifetime
   _selection, // position
   [0, 0, 0.65],  // velocity
   0, 0.05, 0.04, 0.05, // rot, weight, vol., rubbing
   [0.15, 1.2, 1.8, 0.3], // render size
   [[0.5, 0.5, 0.5, 0.1],[0.3, 0.3, 0.3, 0.27],[0.1, 0.1, 0.1, 0.31],[0.7, 0.7, 0.7, 0.11],[1,1,1, 0]], // render color
   [0.8,0.3,0.25], 1, 0, "", "", _unit
];

_smoke setParticleRandom [
   (0.75 + (random 0.5)),   // lifeTime      
   [0.3,0.3,0.2],              // position
   [0.12, 0.12, 0.52],        // moveVelocity
   0,                      // rotationVelocity
   0.3,                    // size
   [0.05, 0.05, 0.05, 0],  // color
   0,                      // randomDirectionPeriod   
   0                       // angle         
];

// return particle source
_smoke