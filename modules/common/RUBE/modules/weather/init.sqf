/*
   RUBE weather 
   --
   initialization script
*/

private ["_logic", "_season"];

if (isnil "RUBE_weather") then
{   
   // init weather logic
   _logic = _this call (compile preprocessFileLineNumbers "modules\common\RUBE\modules\weather\init-logic.sqf");
      
   // compile weather functions 
   [] call (compile preprocessFileLineNumbers "modules\common\RUBE\modules\weather\weather-functions.sqf");
   waitUntil{!(isnil "RUBE_weatherModuleWeatherFncInit")};
   
   // compile disturbance map functions 
   [] call (compile preprocessFileLineNumbers "modules\common\RUBE\modules\weather\weather-disturber.sqf");
   waitUntil{!(isnil "RUBE_weatherModuleDisturberFncInit")};

   // compile forecast functions
   [] call (compile preprocessFileLineNumbers "modules\common\RUBE\modules\weather\forecast-functions.sqf");
   waitUntil{!(isnil "RUBE_weatherModuleForecastFncInit")};
   
   // compile season function
   RUBE_weatherGetSeasonModel = compile preprocessFileLineNumbers "modules\common\RUBE\modules\weather\season.sqf";
   
   // load default season model
   _season = "" call RUBE_weatherGetSeasonModel;
   
   _logic setVariable [
      "season-model",
      (_season select 0),
      true
   ];
   
   _logic setVariable [
      "season",
      (_season select 1),
      true
   ];

   // compile generator function
   RUBE_weatherGenerator = compile preprocessFileLineNumbers "modules\common\RUBE\modules\weather\weather-generator.sqf";
   
   // load color filter
   [] call (compile preprocessFileLineNumbers "modules\common\RUBE\modules\weather\color.sqf");
   waitUntil{!(isnil "RUBE_weatherModuleColorFncInit")};
   
   // load particle definition library
   [] call (compile preprocessFileLineNumbers "modules\common\RUBE\modules\weather\particles.sqf");
   waitUntil{!(isnil "RUBE_weatherModuleParticlesInit")};
   
   // DONE (...and we need global access to it anyway)
   RUBE_weather = _logic;
};