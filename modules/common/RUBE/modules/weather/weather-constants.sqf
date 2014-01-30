/*
   RUBE weather module,
   weather constants
   --
   
   This "function" simply returns an array of definitions (array [0: key, 1: value]),
   which, once and on init, will be put into the global weather logic for further
   useage.
   
*/

[
   /**********************************************************************************
    * weather module defaults
    */
   
   // enables/disables the (seasonal/daytime/temperature) color filter
   ["enable-color-filter", true],
   
   // enables/disables radiation/ground-fog particles
   ["enable-particles-fog", true],
   
   // enables/disables snow particles
   ["enable-particles-snow", true],
   
   // Switches on and of diag_log messages produced by the weather generator
   ["debug-generator", false],
   
   // Switches on and of diag_log messages produced by the weather engine (fsm)
   ["debug-engine", false],
   
   // whether the weather engine shall auto advance the forecast/weather at 24:00
   ["enable-auto-advance-forecast", true],
   
   // The date, the weather generator will work with to select data from the season
   // model. 
   ["date", date],
   
   // Number of future days, the weather generator will work with. This is not only 
   // about having these extra forecast days: the more days the weather generator can
   // work with, the more evolution, mutation and number crunching is going on, while
   // calculating the actual, respectievly todays weather.
   //    Minimum number of forecast-days is 1, s.t. we have at least a next day.
   ["forecast-days", 6],
   
   // This is the weather data, produced by the weather generator. Can be manipulated
   // before the weather engine (fsm) is launched, in case you don't like surprises...
   ["forecast", []],
      
   // The (currently active) season model's name/identifier
   ["season-model", ""],
   
   // This is the season model's data; the recepie for the weather generator. Either 
   // choosen by default, depeding on the world/map, manually chosen from the different 
   // season models... manipulated or supplied from scratch. Your choice.
   ["season", []],
      
   
   /**********************************************************************************
    * world configuration
    */
   
   // latitude, since corrected:  [North +90, ..., 0, ..., -90 South]
   ["latitude",  (getNumber(configFile >> "CfgWorlds" >> worldName >> "latitude") * -1)],
   
   // longitude:  [West +180, ..., 0, ..., -180 East]
   ["longitude", (getNumber(configFile >> "CfgWorlds" >> worldName >> "longitude"))],
   
   
   /**********************************************************************************
    * physical constants 
    *
    * note: we only keep a list of physical constants that are used in multiple places
    *       and which are not _that_ constant; i.e. they might get tweaked.
    */
    
   // average of atmospheric pressure at sea-level in Pa
   ["pressure-mean", 101325],
   
   // average standard deviation, used to calculate local and environmental atmospheric
   // pressure values; chosen with a minimum around 98000 Pa and maximum around 104000 Pa
   // at sea level.
   ["pressure-sd", 831.25],
   
   // critical pressure difference threshold in Pa. Differences below this measure are 
   // considered "Stable", such equal to or above will be considered as "Low" or "High". 
   //    Avg. difference for a L-H is about 10 hPa or so, so we go with 2/3 of that.
   ["pressure-threshold", 666] // :P
   
]