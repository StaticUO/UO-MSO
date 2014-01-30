/*
   RUBE weather module,
   color filter
   --
   
   - the color filter is influenced by three factors:
     - season; day/days-in-year [0, 361/361]
     - temperature; degree celsius [-50, 50]
     - daytime; [0, 24]
     
     
   - feel free to overwrite the color filter's function
     as desired
     
   - while the current RUBE_weatherColorFnc might look a
     bit expensive/wasteful with all these bézier-functions,
     we only call that function twice every full weather
     module cycle -- which is about once every other minute
     or so...
*/

// color filter DATA (will be continously modified)
RUBE_weatherColorData = [
/*  0 */ 1.0,        // brightness
/*  1 */ 1.0,        // contrast
/*  2 */ 0.0,        // offset/gamma
/*  3 */ [           // blend color (R,G,B,A)
            0.5, 
            0.5, 
            0.5, 
            0.0
         ],
/*  4 */ [           // colorize color I (R,G,B,A)
            0.5, 
            0.5, 
            0.5, 
            0.0
         ],
/*  5 */ [           // colorize color II (R,G,B,A)
            0.5, 
            0.5, 
            0.5, 
            0.0
         ]
];

// color filter FUNCTION
RUBE_weatherColorFnc = {
   private ["_date", "_day", "_temperature", "_latitude", "_season", "_temp", "_time"];
   
   _date = _this select 0; // [0:year, 1:month, 2:day, 3:hour, 4:minute]
   _temperature = _this select 1;
   _latitude = RUBE_weather getVariable "latitude";
   
   if ((count _this) > 2) then
   {
      _latitude = _this select 2;
   };
   
   
   // coefficients
   
   //_season = (((_date select 1) * 30) + (_date select 2)) / 361;
   _day = ((_date select 1) * 30) + (_date select 2);
   _season = ((361 + (_day - 354)) % 361) / 361;
   
   if (_latitude < 0) then
   {
      _season = 1 - _season;
   };
   
   switch (true) do
   {
      case (_temperature > 50):  { _temperature = 50;  };
      case (_temperature < -50): { _temperature = -50; };
   };
   _temp = (1 + (_temperature / 50)) * 0.5;
   _time = ((_date select 3) + ((_date select 4) / 60)) / 24;

   // update color filter data: colorize color I (R,G,B,A)
   RUBE_weatherColorData set [
      4,
      [
         // red
         ([[0.05, 0.05, 0.2, 0.4, 0.55, 0.05], _season] call RUBE_bezier)
            - ([[1.8, 1.0, -0.1, -0.2], _temp] call RUBE_bezier)
            + ([[0, 0, 1.95, -1.3, -1.0, 2.05, 0, 0], _time] call RUBE_bezier)
         ,
         
         // green
         ([[0.1, 0.5, 0.5, 0.2, 0.1], _season] call RUBE_bezier)
            - ([[1.3, 0.7, -0.3, -0.1], _temp] call RUBE_bezier)
         ,
         
         // blue
         ([[-0.01, -0.1, -0.25, -0.01], _season] call RUBE_bezier)
            + ([[2.5, 0.3, 0, 0], _temp] call RUBE_bezier)
         ,
         
         // saturation-something
         ([[0.985, 0.98, 0.91, 0.90], _temp] call RUBE_bezier)
            + ([[0, 0, 0, -0.85, 0.55, -0.1, 0.55, -0.95, 0, 0, 0], _time] call RUBE_bezier)
      ]
   ];
   
   // update color filter data: colorize color II (R,G,B,A)
   RUBE_weatherColorData set [
      5,
      [
         // red
         ([[1.4, 1.0, 2.3, 2.3, 2.3], _temp] call RUBE_bezier) +
            ([[0, 0, 2.25, -1.4, -1.0, 2.92, 0, 0], _time] call RUBE_bezier)
         ,
            
         // green
         ([[0.7, 0.5, 1.0, 1.44], _temp] call RUBE_bezier)
         ,
         
         // blue
         ([[-0.91, -0.5, 2, 2, 1], _temp] call RUBE_bezier)
         ,
         
         0
      ]
   ];
   
   /*
   diag_log format["RUBE_weatherColorFnc (d): %1", _date];
   diag_log format["RUBE_weatherColorFnc (t): %1", _temperature];
   
   for "_i" from 0 to ((count RUBE_weatherColorData) - 1) do
   {
      diag_log format[" - [%1]: %2", _i, (RUBE_weatherColorData select _i)];
   };
   
   diag_log format["RUBE_weatherColorFnc (c1): %1", _season];
   diag_log format["RUBE_weatherColorFnc (c2): %1", _temp];
   diag_log format["RUBE_weatherColorFnc (c3): %1", _time]; 
   */  
};


// done
RUBE_weatherModuleColorFncInit = true;