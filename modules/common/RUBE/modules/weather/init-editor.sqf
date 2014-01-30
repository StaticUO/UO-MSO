/*
   RUBE weather (editor init)
   --
   quick setup for drop'n'fuck it from the editor.
*/

// there can be only one weather module
if ((!isnil "RUBE_weather_loading") || (!isnil "RUBE_weather")) exitWith 
{ 
   diag_log format["init-editor.sqf: RUBE weather module already loaded"]; 
};

// flag loading process
RUBE_weather_loading = true;


// make sure the RUBE function library is loaded
if (isnil "RUBE_fnc_init") then
{
   [] call (compile preprocessFileLineNumbers "modules\common\RUBE\init.sqf");
};
waitUntil{!(isnil "RUBE_fnc_init")};

// init weather module
_this execVM "modules\common\RUBE\modules\weather\init.sqf";
waitUntil{!(isnil "RUBE_weather")};


/*
   we could offer a second weather-module drop'in which would
   respect the 4 slider's set in the editor: 
   
      overcast, 
      overcastForecast,
      fog and 
      fogForecast
      
   ... init some random weather and then overwrite the forecast
   data according to these sliders, such that non-"Forecast" sliders
   overwrite the data for the previous (0) and the current (1) day,
   while the "Forecast" sliders would set the next (2) and following
   days...
   
   Though, rain would still be random. One could also use the 4 sliders
   for 4 different things, but nonone would understand such a mess...
   so I guess the best option is to not offer such a version at all -
   only a random/seasonal drop'in - and if anyone wants more control,
   he needs to do it by himself. :P
   
   Yeah.
*/


// and start right away with default settings
[] call (RUBE_weather getVariable "start-weather-engine");
