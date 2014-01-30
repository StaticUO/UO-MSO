/*
   RUBE weather module,
   weather interface (public functions)
   --

   This "function" simply returns the weather interface, which is a set of functions
   (array [0: function-name (key), 1: function (code)]), whcih, once on init, will be 
   put into the global weather logic for further useage.
   
   
   Interface function: calls
   ------------------------
      So a call to these functions then looks something like this:
      
         >
         >  [] call (RUBE_weather getVariable "function-name");
         >
         
      This might feel a bit funny at first, but you'll eventually get used to it.
   
   
   
   Interface function: parameters
   ------------------------------
      If not stated otherwise in the function's comments, interface functions usually 
      don't require any parameters (mostly because we don't have getters and setters 
      for most of the stuff; just use set-/getVariable).
      Likewise nothing is returned by most functions - unless stated otherwise.
   
*/

[
   /**********************************************************************************
    * weather generator interface
    */
   
   // selects a different season model
   /*
      Parameter(s):
         _this: season model (string) OR 
                season data  (array)
   */
   ["set-season-model",
   {
      private ["_season"];
      
      _season = _this call RUBE_weatherGetSeasonModel;
      
      RUBE_weather setVariable [
         "season-model",
         (_season select 0),
         true
      ];
      
      RUBE_weather setVariable [
         "season",
         (_season select 1),
         true
      ];
   }],
   
   // generate forecast from scratch
   ["generate-weather", 
   {
      RUBE_weather setVariable [
         "forecast",
         ([
            ["date", (RUBE_weather getVariable "date")],
            ["init", ((RUBE_weather getVariable "forecast-days") + 2)], // + previous and today
            ["debug", (RUBE_weather getVariable "debug-generator")]
         ] call RUBE_weatherGenerator),
         true
      ];
   }],
   
   // advances the forecast by one day; make sure to update the variable "date"
   // on RUBE_weather first.
   ["generate-next-day", 
   {
      ([
         ["date", (RUBE_weather getVariable "date")],
         ["weather", (RUBE_weather getVariable "forecast")], 
         ["debug", (RUBE_weather getVariable "debug-generator")]
      ] call RUBE_weatherGenerator);
   }],
   

   /**********************************************************************************
    * weather engine (fsm) interface
    */
    
   // starts the weather engine (fsm)
   ["start-weather-engine", 
   {
      private ["_forecast", "_valid"];
      
      // make sure we have some weather
      _forecast = RUBE_weather getVariable "forecast";
      _valid = false;
      
      if ((typeName _forecast) == "ARRAY") then 
      { 
         _valid = ((count _forecast) > 2); 
      };
      
      if (!_valid) then
      {
         [] call (RUBE_weather getVariable "generate-weather");
      };
      
      // kick some ass
      RUBE_weatherEngine = RUBE_weather execFSM "modules\common\RUBE\modules\weather\weather.fsm";
   }],
   
   // resets the weather engine (fsm): the current weather transition cycle get's aborted
   // and the forecast data will be re-read. Smooth transition to new values within next cycle.
   ["reset-weather-engine", 
   {
      [] spawn {
         waitUntil{((typeName (RUBE_weatherEngine getFSMVariable "_reset")) == "BOOL")};
         RUBE_weatherEngine setFSMVariable ["_reset", true];
      };
   }],
   
   // resets the weather engine (fsm) without transition
   ["hard-reset-weather-engine", 
   {
      [] spawn {
         waitUntil{((typeName (RUBE_weatherEngine getFSMVariable "_reset")) == "BOOL")};
         RUBE_weatherEngine setFSMVariable ["_hardReset", true];
         RUBE_weatherEngine setFSMVariable ["_reset", true];
      };
   }]
   
   
]