/*
   RUBE weather module,
   forecast function library
   --
   
   The forecast functions often operate on weather data of 
   3 days, namely the data from: the previous, the current and
   the next day. 
   
   While the current day's data is certainly weighted more, this
   allows for way better forecast results, due to the nature of
   our "micro"-weather system, i.e. the use of random walkers/
   oscillators.
   
*/


/*
   RUBE_weatherCreateForecast
   
   Description:
      Creates the data needed for the forecast report dialog.
      
   TODO: new parameter to calibrate temperatures/wind speeds and
         stuff according to a given height/location/position.
   
   Parameters:
      _this select 0: date (array, optional)
      _this select 1: weather data (array, optional)
      _this select 2: maximum days of forecast including today (integer, optional)
   
   Returns:
      array [
         0: today's data   (elaborate/extended)
         1: today+1's data (minimal)
         ...
         n: today+n's data (minimal)
      ]
      
      where the data structure is as follows:
      
      [
         0: date,
         
         1: today/extended forecast
            [
               0: wind speed
               1: wind speed symbol
               2: wind direction
               3: wind direction label
               4: wind direction symbol
               5: sunrise
               6: sunset
            ],
            
         2: forecast days (including today)
            n array's of 
            [
               0: weekday,
               1: temperature lo,
               2: temperature hi,
               3: weather symbols
                  [
                     0: sun
                     1: overcast/fog
                     2: precipitation
                     3: special (thunder, ...)
                  ]
            ]
      ]
*/
RUBE_weatherCreateForecast = {
   private ["_data", "_date", "_dateDIY", "_day", "_weekday", "_latitude", 
            "_weather", "_weatherSize", "_limit",
            "_wind", "_windSpeed", "_windSpeedSymbol", "_windDir",
            "_windDirLabel", "_windDirSymbol", "_windSector",
            "_formatSun", "_sun", "_sunrise", "_sunset",
            "_i", "_t", "_lo", "_hi",
            "_layer0", "_layer1", "_layer2", "_layer3",
            "_precipitation", "_precLevel", "_precType", "_overcast", "_fog"];
      
   _latitude = RUBE_weather getVariable "latitude";   
   _date = RUBE_weather getVariable "date";
   
   if ((count _this) > 0) then 
   { 
      _date = _this select 0;
   };
   
   _dateDIY = (((_date select 1) - 1) * 30) + (_date select 2);
   _weekday = _date call RUBE_weekday;
     
   _weather = (RUBE_weather getVariable "forecast");
   if ((count _this) > 1) then 
   { 
      _weather = _this select 1; 
   };
   
   _weatherSize = (count _weather) - 1;
   
   _limit = _weatherSize;
   if ((count _this) > 2) then 
   { 
      _limit = (_this select 2) min _limit; 
   };
   
   // calculate todays/extended forecast
   _wind = (_weather select 0) select 4;
   _windSpeed = [((_wind select 0) * 3.6), 0.1] call RUBE_roundTo; 
   _windDir = [(_wind select 1), 0.1] call RUBE_roundTo; 
   
   _windSpeedSymbol = "wind1";
   _windDirSymbol = "dir0";
   _windDirLabel = "N";
   
   if (_windSpeed > 12) then { _windSpeedSymbol = "wind2"; };
   if (_windSpeed > 30) then { _windSpeedSymbol = "wind3"; };
   
   _windSector = _windDir call RUBE_weatherForecastWindDirection;
   _windDirSymbol = format["dir%1", (_windSector select 0)];
   _windDirLabel = _windSector select 1;
   
   _formatSun = {      
      (format[
         "%1:%2", 
         ([(_this select 0), 2, 0] call RUBE_pad), 
         ([(_this select 1), 2, 0] call RUBE_pad)
      ])
   };
   _sun = _date call RUBE_sun;
   _sunrise = (_sun select 0) call _formatSun;
   _sunset = (_sun select 1) call _formatSun;
   
   // init forecast
   _data = [
      // 0: date
      _date,
            
      // 1: today/extended forecast
      [
         /* 0 */ _windSpeed,
         /* 1 */ _windSpeedSymbol,
         /* 2 */ _windDir,
         /* 3 */ _windDirLabel,
         /* 4 */ _windDirSymbol,
         /* 5 */ _sunrise,
         /* 6 */ _sunset
      ],
      
      // 2: forecast (including today)
      []  
   ];

   // calculate forecast days
   for "_i" from 1 to _limit do
   {
      _day = _dateDIY + (_i - 1);
      
      // weather symbols
      _layer0 = "empty";
      _layer1 = "empty";
      _layer2 = "empty";
      _layer3 = "empty";
      
      _precipitation = (_weather select _i) select 1; // 0:intensity, 1: disturbance mask
      _precLevel = 0;
      _precType = "";
      _overcast = (_weather select _i) select 2;      // 0:intensity
      _fog = (_weather select _i) select 3;           // 0:intensity, 1:d1, 2:d2, 3:d3
      _wind = (_weather select _i) select 4;          // 0:speed, 1:dir
      
      // layer0: sun
      if ([
            _day,
            _latitude,
            (_overcast select 0), 
            _fog,
            (_precipitation select 1),
            (_wind select 0)
         ] call RUBE_weatherForecastDaylight) then
      {
         _layer0 = "sun";
      };
      
      // layer1: overcast or fog
      if (((_fog select 0) > 0.575) && // fog intensity
          ((_fog select 2) > 0.55) && // fog duration/level during day
          ((_precipitation select 0) < 0.4) &&
          ((_overcast select 0) < 0.7)) then
      {
         // fog
         _layer1 = "fog";

         // if we have fog, there's no precipitation or specials
         // ... so that's it.
      } else
      {
         // overcast
         switch (true) do
         {
            case ((_overcast select 0) >= 0.7):   { _layer1 = "cloud3"; };
            case ((_overcast select 0) >= 0.4):   { _layer1 = "cloud2"; };
            case ((_overcast select 0) >= 0.1):   { _layer1 = "cloud1"; };
            case ((_precipitation select 0) > 0): { _layer1 = "cloud1"; };
         };
         
         // layer2: precipitation
         switch ((_weather select _i) call RUBE_weatherForecastPrecType) do
         {
            case 0: { _precType = "rain"; };
            case 1: { _precType = "prec"; }; /* has only 2 levels! */
            case 2: { _precType = "snow"; };
         };
         
         switch (true) do
         {
            case ( ((_precipitation select 0) > 0.66) &&
                   (_precType != "prec")):                  { _precLevel = 3; };
            case ((_precipitation select 0) > 0.33):        { _precLevel = 2; };
            case ((_precipitation select 0) > 0):           { _precLevel = 1; };
         };
         
         // layer 3: specials (thunder)
         if ([
               (_overcast select 0), 
               (_precipitation select 0),
               (_precipitation select 1)
            ] call RUBE_weatherForecastThunder) then
         {
            _layer3 = "thunder";
         };
      };
      
      // layer 2: finalize
      if (_precLevel > 0) then
      {
         _layer2 = format["%1%2", _precType, _precLevel];
      };
      
      // failsafe: make sure that at least one symbol shows up
      if ( (_layer0 == "empty") &&
           (_layer1 == "empty") &&
           (_layer2 == "empty") &&
           (_layer3 == "empty") ) then
      {
         //_layer0 = "sun";
         _layer1 = "cloud1";
      };
   
      
      // search lowest temperature
      _lo = ((_weather select _i) select 0) select 0;
      _t = ((_weather select (_i - 1)) select 0) select 0;
      
      if (_i < _weatherSize) then
      {
         _t = _t min (((_weather select (_i + 1)) select 0) select 0);
      };
      
      if (_t < _lo) then
      {
         _lo = (_t + _lo) * 0.5;
      };
      
      // search highest temperature
      _hi = (((_weather select _i) select 0) select 0) + 
            (((_weather select _i) select 0) select 1);
      _t = (((_weather select (_i - 1)) select 0) select 0) + 
           (((_weather select (_i - 1)) select 0) select 1);
           
      if (_i < _weatherSize) then
      {
         _t = _t max ((((_weather select (_i + 1)) select 0) select 0) + 
                      (((_weather select (_i + 1)) select 0) select 1));
      };
      
      if (_t > _hi) then
      {
         _hi = (_t + _hi) * 0.5;
      };
      
      // set
      (_data select 2) set [
         (_i - 1),
         [
            ((_weekday + _i - 1) % 7),
            ([_lo, 0.1] call RUBE_roundTo),
            ([_hi, 0.1] call RUBE_roundTo),
            [
               _layer0,
               _layer1,
               _layer2,
               _layer3
            ]
         ]
      ];
   };
   
   _data
};




/*
   RUBE_weatherForecastDaylight
   
   Description:
      Returns true if the sun-symbol should be shown, otherwise
      you'll get false.
      
   Parameters:
      _this select 0: day (array or integer)
      _this select 1: latitude (scalar in [-90,90])
      _this select 2: overcast (scalar in [0,1])
      _this select 3: fog (array)
      _this select 4: disturbance mask (array)
      _this select 5: wind speed in m/s (scalar)
   
   Returns:
      boolean
*/
RUBE_weatherForecastDaylight = {
   private ["_day", "_latitude", "_overcast", "_fog", 
            "_disturbanceMask", "_windSpeed", "_throttledFog",
            "_h", "_f", "_sunshine"];
   
   _day = _this select 0;
   _latitude = _this select 1;
   _overcast = _this select 2;
   _fog = _this select 3;
   _disturbanceMask = _this select 4;
   _windSpeed = _this select 5;
   
   _h = [_day, _latitude] call RUBE_daylightHours;
 
   // evaluate and apply disturbance mask (which throttles overcast/precipitation)
   _overcast = _overcast * (1 - (_disturbanceMask call RUBE_weatherDisturbanceMaskArea));
   
   // influence of windspeed on fog
   _throttledFog = [
      (_fog select 0),
      (_fog select 1),
      (_fog select 2),
      (_fog select 3),
      _windSpeed,
      _overcast,
      14.5 // daytime
   ] call RUBE_fog;
      
   // reduce daylight hours by overcast
   _h = _h * (0.1 + (0.9 * (1 - _overcast)));
   
   // reduce daylight hours by day-fog
   _f = ( (4 * (_throttledFog select 0)) +
          (((_fog select 1) + (_fog select 3)) * 0.5) +
          (3 * ((_fog select 2) max 0))
        ) * 0.125;
        
   _h = _h * ((1 + (1 * (1 - _f))) * 0.5);
   
   _sunshine = true;
   
   // below threshold?
   if (_h < 5) then
   {
      _sunshine = false;
   };
            
   _sunshine
};



/*
   RUBE_weatherForecastThunder
   
   Description:
      Returns true if the thunder-symbol shall be shown
      
   Parameters:
      _this select 0: overcast (scalar in [0,1])
      _this select 1: precipitation (scalar in [0,1])
      _this select 2: disturbance-mask (array)
   
   Returns:
      boolean
*/
RUBE_weatherForecastThunder = {
   private ["_overcast", "_precipitation", "_mask", "_bands", "_max"];
   
   _overcast = _this select 0;
   _precipitation = _this select 1;
   _mask = _this select 2;
   _bands = _mask select 1;
   
   if (_precipitation == 0) exitWith { false };
   if (_overcast < 0.85) exitWith { false };
   
   // search max in bands
   _max = 0;
   {
      if ((_x select 2) > _max) then
      {
         _max = _x select 2;
      };
   } forEach _bands;
   
   if ((_overcast * _max) < 0.895) exitWith { false };
   
   true
};



/*
   RUBE_weatherForecastWindDirection
   
   Description:
      Returns the sector of a given direction:
      
        - once in eighth's and numerique code/degrees, and
        - once in sixteenth parts and alphanumeric code consisting
          of the four ordinal cardinal directions, the four ordinal 
          directions, plus eight further divisions...
      
   Parameters:
      _this: direction (scalar)
      
   Returns:
      array [
         0: numerique sector in degree, integer in [0, 45, 90, 135, 180, 225, 270, 315]
         1: alphanumerique sector, string in ["N", "NNE", "NE", "ENE", "E", ...]
      ]
*/
RUBE_weatherForecastWindDirection = {
   private ["_deg", "_alpha"];
   
   _deg = 0;
   _alpha = "N";
   
   switch (true) do
   {
      case (_this >=  22.5 && _this <  67.5): { _deg = 45; };
      case (_this >=  67.5 && _this < 112.5): { _deg = 90; };
      case (_this >= 112.5 && _this < 157.5): { _deg = 135; };
      case (_this >= 157.5 && _this < 202.5): { _deg = 180; };
      case (_this >= 202.5 && _this < 247.5): { _deg = 225; };
      case (_this >= 247.5 && _this < 292.5): { _deg = 270; };
      case (_this >= 292.5 && _this < 337.5): { _deg = 315; };
   };
   
   switch (true) do
   {
      case (_this >=  11.25 && _this <  33.75): { _alpha = "NNE"; };
      case (_this >=  33.75 && _this <  56.25): { _alpha = "NE";  };
      case (_this >=  56.25 && _this <  78.75): { _alpha = "ENE"; };
      case (_this >=  78.75 && _this < 101.25): { _alpha = "E";   };
      case (_this >= 101.25 && _this < 123.75): { _alpha = "ESE"; };
      case (_this >= 123.75 && _this < 146.25): { _alpha = "SE";  };
      case (_this >= 146.25 && _this < 168.75): { _alpha = "SSE"; };
      case (_this >= 168.75 && _this < 191.25): { _alpha = "S";   };
      case (_this >= 191.25 && _this < 213.75): { _alpha = "SSW"; };
      case (_this >= 213.75 && _this < 236.25): { _alpha = "SW";  };
      case (_this >= 236.25 && _this < 258.75): { _alpha = "WSW"; };
      case (_this >= 258.75 && _this < 281.25): { _alpha = "W";   };
      case (_this >= 281.25 && _this < 303.75): { _alpha = "WNW"; };
      case (_this >= 303.75 && _this < 326.25): { _alpha = "NW";  };
      case (_this >= 326.25 && _this < 348.75): { _alpha = "NNW"; };   
   };

   [_deg, _alpha]
};


/*
   RUBE_weatherForecastPrecType
   
   Description:
      Determines the precipitation type
   
   Parameters:
      _this: selected weather-data (only one day, not the whole set)
   
   Returns:
      integer in [0:rain, 1:mixed, 2:snow]
*/
RUBE_weatherForecastPrecType = {
   private ["_Tmin", "_Trange", "_Tmax", "_type"];

   _Tmin = (_this select 0) select 0;
   _Trange = (_this select 0) select 1;
   _Tmax = _Tmin + _Trange;
   
   _type = 0;
   
   switch (true) do
   {
      case (_Tmax < 2): { _type = 2; }; // snow
      case (_Tmin > 4): { _type = 0; }; // rain
      default 
      { 
         switch (true) do
         {
            case (_Tmax < -1): { _type = 2; }; // snow
            case (_Tmin > 2):  { _type = 0; }; // rain
            default            { _type = 1; }; // mixed
         };
      }; 
   };
   
   _type
};



/*
   RUBE_weatherDisturbanceMaskArea
   
   Description:
      returns an approximation of the disturbance mask's 
      negative area (the dist.-mask throttles only!).
      The negative area of the disturbance mask is the area, 
      s.t.
      
         overcast * (1 - area) = actual overcast. 
      
   Parameters:
      _this: disturbance mask (array)
      
   Returns:
      scalar in [
                   0, (no influence of the disturbance mask)
                   1  (full influence/throttle)
                ] 
*/
RUBE_weatherDisturbanceMaskArea = {
   private ["_mask", "_segments", "_area", "_osc"];
   
   _mask = _this;
   _segments = (count (_mask select 1)) - 1;
   _area = 1;
   _osc = 1;

   // approximate oscillator
   if ((count (_mask select 0)) > 0) then
   {
      _osc = 0.5;
   };
      
   // evaluate bandlimiter
   if (_segments > 0) then
   {
      private ["_b0", "_b1", "_w", "_min", "_max", "_exp", "_a0", "_a1"];
      
      // calculate area for each segment
      for "_i" from 0 to (_segments - 1) do
      {
         _b0 = (_mask select 1) select _i;
         _b1 = (_mask select 1) select (_i + 1);
         
         _w = ((_b1 select 0) - (_b0 select 0)) / 24;
         
         _a0 = 0;
         _a1 = 0;
         if ((count _b0) > 0) then { _a0 = _b0 select 1; };
         if ((count _b1) > 0) then { _a1 = _b1 select 1; };
         
         _min = (_a0 + _a1) * 0.5;
         
         
         _a0 = 1;
         _a1 = 1;
         if ((count _b0) > 1) then { _a0 = _b0 select 2; };
         if ((count _b1) > 1) then { _a1 = _b1 select 2; };
         
         _max = (_a0 + _a1) * 0.5;
         
         
         _a0 = 1;
         _a1 = 1;
         if ((count _b0) > 2) then { _a0 = _b0 select 3; };
         if ((count _b1) > 2) then { _a1 = _b1 select 3; };
         
         _exp = (_a0 + _a1) * 0.5;
         
         if (_min > 0) then
         {
            _area = _area - (_min * _w);
         };
         
         _area = _area - ((_max - _min) * _w * _osc^_exp);
      };
   } else
   {
      _area = 1 - _osc;
   };
   
   _area
};


// done
RUBE_weatherModuleForecastFncInit = true;