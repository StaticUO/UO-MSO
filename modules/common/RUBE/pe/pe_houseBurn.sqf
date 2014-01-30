/*
   From the Harvest Red Campaign, C4_BitterChill
    "slightly" enhanced by rübe
    
   Description:
    put's a building on fire in the easiest case (timeout = 0). However if
    a timeout is given, the building will catch and spread fire to it's 
    building positions, a light will flicker and sound will crackle as 
    long as flames are flaming, the building takes damage and will
    collapse eventually, the ruin will be detected, particle/sound/light-
    sources replaced and attached to the new ruin/object, again fire and
    smokes, fires will erase, and finally the smokes too. The end. :)
    
    >> units near particle sources (flames) eventually catch fire and die.
       players may try to put the flames out again through rolling on the floor. 
       
                                                              good luck, XD
    
   Parameter(s):
    _this: building
    
    OR
    
    _this select 0: building
    _this select 1: Chance for additional (initial) building position fires (scalar from 0.0 to 1.0)
                    - default = 0.01
                    - remainding building positions will catch fire eventually 
                      if a timeout is set (see burnDownBuilding.fsm)
                    
    _this select 2: average timeout in seconds (scalar)
                    - default = 0
                    - if higher than 0, the fire, illumination and soundsources
                      will be deleted after the given time (+/- 50%). Only the 
                      smokes will be left then, until this one too gets deleted
                      roughly after 3x the given time.
                      
                      Also the building will be destroyed in the process if
                      not destroyed earlier (for unknown/external reasons):
                       -> flames spreading
                       -> collapsing
                       -> detect ruin, new sources
                       -> kill flames, spread smokes
                       -> last single smokes ...
                       -> exit
    
    _this select 3: flames/burn (boolean)
                    - default = true
    _this select 4: illumination/lightsources (boolean)
                    - default = true
                    - works only if flames = true
    _this select 5: soundscape/soundsources (boolean)
                    - default = true
                    - works only if flames = true
                    
   Returns:
    [particlesources, lightsources, soundsources] 
*/

private [
   "_building", "_buildingPosition", "_remainingPositions",
   "_addPosCoef", "_timeout",
   "_burning", "_illumination", "_soundscape", 
   "_flames", "_smokes", "_lights", "_sounds", 
   "_makeFire", "_makeSmoke", "_makeSound", "_makeLight", "_getOffset", "_burnBaby"
];

_building = _this;

_addPosCoef = 0.01;
_timeout = 0;

_burning = true;
_illumination = true;
_soundscape = true;

if ((typeName _this) == "ARRAY") then
{
   _building = _this select 0;
   
   if ((count _this) > 1) then
   {
      _addPosCoef = _this select 1;
   };
   if ((count _this) > 2) then
   {
      _timeout = _this select 2;
   };
   
   if ((count _this) > 3) then
   {
      _burning = _this select 3;
   };
   if ((count _this) > 4) then
   {
      _illumination = _this select 4;
   };
   if ((count _this) > 5) then
   {
      _soundscape = _this select 5;
   };
};


_buildingPosition = position _building;
_remainingPositions = [];

_flames = []; 
_smokes = []; 
_lights = []; 
_sounds = [];

// [object, position, offset] => source-object
_makeFire = {
   private ["_flame"];
   
   (_this select 2) set [2, (((_this select 2) select 2) - (0.4 + (random 0.25)))];
   
   _flame = "#particlesource" createVehicleLocal (_this select 1);
   _flame setdropinterval 0.05;
   _flame setParticleParams [
      ["\Ca\Data\ParticleEffects\Universal\Universal", 16, 10, 32],
      "", "Billboard", 1, 0.6, // obsolete, type, timerperiod, lifetime
      (_this select 2), // position
      [0.1, 0.1, 0.31], // velocity
      0.7, 10, 7.9, 1, // rot, weight, vol., rubbing
      [1.4, 0.8, 0.5], // render size
      [[1,1,0,0], [1,1,0.67,-9], [1,1,0,-2], [1,1,0.31,-1], [1,1,1,-0.5], [1,1,1,0]], // render color
      [1], 1, 0, "", "", (_this select 0)
   ];
   _flame setParticleRandom [
      (0.2 + (random 0.15)),           // lifeTime      
      [0.6, 0.6, 0.45],  // position
      [0.15, 0.15, 3.85], // moveVelocity
      1.2,             // rotationVelocity
      0.7,           // size
      [0, 0, 0, 0],  // color
      0.02,             // randomDirectionPeriod
      0              // angle
   ];
   
   //diag_log format[" - flame: %1", _flame];
   //diag_log format["   %1", _this];   
   _flame
};

// [object, position, offset] => source-object
_makeSmoke = {
   private ["_smoke"];
   
   _smoke = "#particlesource" createVehicleLocal (_this select 1);
   _smoke setDropInterval 0.15;
   _smoke setParticleParams [
      ["\Ca\Data\ParticleEffects\Universal\Universal", 16, 7, 48], 
      "","Billboard",1, (12 + (random 11)), // obsolete, type, timerperiod, lifetime
      (_this select 2), // position
      [0, 0, 0.65],  // velocity
      0.04, 0.05, 0.04, 0.05, // rot, weight, vol., rubbing
      [0.75, 3, 5, 3], // render size
      [[0.54, 0.52, 0.5, 0.1],[0.5, 0.37, 0.3, 0.37],[0.1, 0.1, 0.1, 0.31],[0.7, 0.7, 0.7, 0.11],[1,1,1, 0]], // render color
      [0.8,0.3,0.25], 1, 0, "", "", (_this select 0)
   ];
   _smoke setParticleRandom [
      (0.75 + (random 0.5)),   // lifeTime      
      [2,2,0.3],              // position
      [0.12, 0.12, 0.52],        // moveVelocity
      0,                      // rotationVelocity
      0.7,                    // size
      [0.07, 0.06, 0.05, 0],  // color
      0,                      // randomDirectionPeriod   
      0                       // angle         
   ];
   
   //diag_log format[" - smoke: %1", _smoke];
   //diag_log format["   %1", _this];
   _smoke
};

// [object, position, offset] => source-object
_makeLight = {
   private ["_light", "_fsm"];
   
   _light = "#lightpoint" createVehicleLocal (_this select 1);
   
   _light setLightBrightness 0.02;
   _light setLightAmbient[0.8, 0.6, 0.2];
   _light setLightColor[1, 0.5, 0.4];
   _light lightAttachObject [(_this select 0), [0,0,0]];
         
   // will terminate once the light is no more...
   _fsm = [
      ["light", _light]
   ] execFSM "modules\common\RUBE\pe\lightsourceFlicker.fsm";
   
   //diag_log format[" - light: %1", _light];
   //diag_log format["   %1", _this];
   _light
};

// [object, position, offset] => source-object
_makeSound = {
   (createSoundSource ["Sound_Fire", (_this select 1), [], 0])
};


// some building-position => offset (array)
_getOffset = {
   private ["_pos"];
   _pos = [0,0,0];
   _pos set [0, ((_this select 0) - (_buildingPosition select 0))];
   _pos set [1, ((_this select 1) - (_buildingPosition select 1))];
   _pos set [2, ((_this select 2) - (_buildingPosition select 2))];
   
   _pos
};


// [object, position] => void
_burnBaby = {
   private ["_index", "_pos"];
   
   _pos = [0,0,0];
   if (isNull (_this select 0)) then
   {
      _pos = (_this select 1) call _getOffset;
   };
   
   if (_burning) then
   {      
      // flames
      _index = count _flames;
      _flames set [_index, ([_building, (_this select 1), _pos] call _makeFire)];
                  
      // only for main source
      if (_illumination && !(isNull (_this select 0))) then
      {
         _index = count _lights;
         _lights set [_index, ([_building, (_this select 1), _pos] call _makeLight)];
      };
      
      if (_soundscape) then
      {
         _index = count _sounds;
         _sounds set [_index, ([_building, (_this select 1), _pos] call _makeSound)];
      };
   };
   
   // smoke
   _index = count _smokes;
   _smokes set [_index, ([_building, (_this select 1), _pos] call _makeSmoke)];
};

// main source
[_building, (position _building)] call _burnBaby;

// additional sources
if ((_addPosCoef > 0) || (_timeout > 0)) then
{
   private ["_buildingPositions", "_n", "_i"];
   _buildingPositions = _building call RUBE_getBuildingPositions;
   _n = count _buildingPositions;
   if (_n > 1) then
   {
      for "_i" from 1 to (_n - 1) do
      {
         if ((random 1.0) < _addPosCoef) then
         {
            [objNull, (_buildingPositions select _i)] call _burnBaby;
         } else
         {
            _remainingPositions set [(count _remainingPositions), (_buildingPositions select _i)];
         };
      };
   };
};



// burn down building
if (_timeout > 0) then
{
   [
      _building,
      _timeout,
      _flames,
      _smokes,
      _lights,
      _sounds,
      _remainingPositions,
      [_makeFire, _makeSmoke, _makeSound, _makeLight]
   ] execFSM "modules\common\RUBE\pe\burnDownBuilding.fsm";
};



// return
[_flames, _smokes, _lights, _sounds]