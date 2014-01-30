/*
   Author:
    rübe
    
   Description:
    RUBE weather generator for continuous (and thus forecastable)
    weather. Generates n days of weather from scratch or modifies
    n days of already generated weather, calculating the `next days`
    weather. 
    
    On each call, all forecasts are modified/mutated, such that there 
    is only minimal changes to the first day(s) for a "secure/robust" 
    forecast, and a greater possibility for a more drastic change for 
    the remaining days.
    
    So the idea is to init a weather with a fixed amount of days/
    forecast once, and call this function again each new day, to
    update/generate the weather/forecast...
    
    The sequence of days is defined as follows:
    
      [0]: previous days weather
      [1]: current/todays weather
      [2]: next days weather (forecast with good reliability)
      ...
      [n]: nth days weather (forecast with bad reliability)
      
    ... so minimal weather data to be run by the RUBE_weatherEngine 
    has at least weather data of 3 days (we need a previous and a 
    next day).
    
       Weather model:
       
        - seasonal, world-specific data (temperature, precipitation)
          to model the annual climatic cycle
          
        - the diurnal (daily) cycle is modeled with a Pearson Type-III
          distribution, using default/fixed adequatish parameters
          
        - dry and most/saturated lapse rates (lower temp. with altitude,
          unless there's an inversion...)
    
   
   Notes:
    The current paradigm of the generator is as follows: For one we try
    to respect a given season model (based on empiric data). And for two
    we try to create weather following physical rules (or rather country
    sayings/weather proverbs, hehe). Of course - these to approaches are
    bound to clash. We try to solve this by skewing the probabilities of
    the season model by our "physical rules", which should average out
    to the season models definition with big enough experiments...
   
    In case you're going to modify the weather generation functions, 
    you'd better double-check that the resulting weather actually 
    obeys the given seasonal data. Averages are not everything though;
    for example a wind speed that is in average very close to the given
    seasonal average  might still be "wrong" if it never reaches low
    windspeeds at all. In that case, clearly the "range" or standard
    deviation would be quite off...
    
    So *build yourself a little test-suite that creates enough days of
    weather and analyse the data with RUBE_descriptiveStatistics,
    RUBE_histogram or something. Then adjust your weather generation 
    functions - you will most likely need to.
    
    And keep in mind to only take (_weather select 1) as sample day,
    then use the generator function to generate the next day. I.e. do
    not consider the complete weather data, which includes the previous
    days data and n days of forecast.
    
    And finally, there is the "generation from scratch" part, and the
    mutation/evolution part of weather. The first part should be easy
    to master. It will be the latter, that screws things up. It's up
    to you, how much of "screwing around" you're going to tolerate 
    'round here. Good luck.
    
    * = There should be a test-suite available somewhere (check the 
        demo missions or have a look into the weather module's 
        directory)
    
   Parameter(s):
    _this: parameters (array of array [key (string), value (any)])
    
      - required:
        
        - none
        
      - optional:
      
        - "weather" (array, weather data structure)
          pass existing weather data to calculate a new day, while
          dropping the latest "previous" day, "next" day becomes
          "today", ..., creating a new days forecast...
          
        - "init" (scalar, default = 7; minimum = 3)
          how many days of weather/forecast that should be created,
          if no existing weather data is passed. We create at least
          three days, such that we have weather data for the previous 
          day, today and the next day (which is needed for the RUBE
          weather module)
          
        - "date" (array [year, month, day], default = date (i.e. today))
          the date defining the "today" for the calculations
        
        - "temperature" (array, temperature data structure, see default)
          seasonal data for the temperature: 
          
            1) Tmin, 
            2) std. dev. (of Tmin) and
            3) Trange
        
        - "precipitation" (array, precipitation data structure, see default)
          seasonal data for the precipitation (rain or snow):
          
            0) probability: daysWithPrecipitation/31, 
            1) avg. intensity (0-1)
        
        - "fog" (array, fog data structure, see default)
          
            0) probability: daysWithFogOccurence/31, 
            
        - "wind" (array, wind data structure, see default)
          
            0) avg. wind speed in m/s 
          
   Returns:
    weather data structure 
*/

private ["_date", "_dateM", "_dateD", "_weather", "_forecastSize", "_season", "_temperature", "_precipitation", "_fog", "_wind", "_latitude", "_debug", "_i", "_j"];

_date = date; 
_weather = [];
_forecastSize = 7;
_debug = false;


// see: \RUBE\modules\weather\season.sqf for the (default) seasonal data
_season = (RUBE_weather getVariable "season");
_latitude = (RUBE_weather getVariable "latitude");

// [
//    0: Tmin (or average), 
//    1: std. dev., 
//    2: Trange (daily), s.t. Tmin + Trange = Tmax
// ]
_temperature = _season select 0;

// [
//    0: probability: daysWithPrecipitation/31 ([0,1]), 
//    1: avg. intensity ([0,1])
// ]
_precipitation = _season select 1;

// [
//    0: probability: daysWith(noteworthy)FogOccurrence/31 ([0,1])
// ]
_fog = _season select 2;

// [
//    0: avg. wind speed in m/s         
// ]
_wind = _season select 3;

// read parameters
{
   switch (_x select 0) do
   {
      case "debug": { _debug = _x select 1; };
      case "date": { _date = _x select 1; };
      case "weather": 
      { 
         _weather = _x select 1; 
         _forecastSize = count _weather;
      };
      case "init": 
      { 
         _forecastSize = _x select 1;
         // we work with a minimum of 3 days, such
         // that we have a previous and a next day
         if (_forecastSize < 3) then
         {
            _forecastSize = 3;
         };
      };
      case "temperature": { _temperature = _x select 1; };
      case "precipitation": { _precipitation = _x select 1; };
      case "fog": { _fog = _x select 1; };
      case "wind": { _wind = _x select 1; };
      case "latitude": { _latitude = _x select 1; };
   };
} forEach _this;

_dateM = _date select 1;
_dateD = _date select 2;


/*
   some more generic private functions...
*/

private ["_monthsIndex", "_blendValues", "_gaussAutoSD"];

// private function: bounded month's index
//  maps: [1-12 (+-)] => [0-11]
_monthsIndex = {
   private ["_m"];
   
   _m = _this - 1; 
   
   while {_m < 0} do
   {
      _m = _m + 12;
   };
   
   (_m % 12)
};

// private function: randomly blend two values
// [v1, v2, (a1)] => v
_blendValues = {
   private ["_d"];
   _d = 0.1 + (random 0.8); // no extreme blends!
   
   if ((count _this) > 2) then
   {
      _d = _this select 2;
   };
   
   ((_d * (_this select 0)) + ((1 - _d) *  (_this select 1)))
};


// private function: piecewise random gauss distribution with 
// auto standard deviation operating on the range [0,1]
// mean => scalar OR [mean, lowerBound, upperBound] => scalar
_gaussAutoSD = {
   private ["_v", "_lowerBound", "_upperBound"];
   
   _v = _this;
   _lowerBound = 0.0;
   _upperBound = 1.0;
   
   if ((typeName _v) == "ARRAY") then
   {
      _v = _this select 0;
      
      if ((count _this) > 1) then { _lowerBound = _this select 1; };
      if ((count _this) > 2) then { _upperBound = _this select 2; };
   };
   
   switch (true) do
   {

      // ]0.8, 1.0]
      case (_v > 0.8): 
      {
         _v = [_v, (0.05 + (random 0.14)), [0,2]] call RUBE_randomGauss;
      };
      
      // special case for positive low values; sometimes :)
      case ((_v < 0.3) && (_v > 0) && ((random 1.0) < 0.5)): 
      {
         _v = abs ([0, ((_v * 0.45) min 0.025), [-1,1]] call RUBE_randomGauss);
      };
      
      // [0, 0.8]
      default
      {
         _v = [_v, (0.05 + (random 0.18)), [-1,2]] call RUBE_randomGauss;
      };
   };

   // wrap around upper and lower bounds, instead of increasing
   // the probability of hitting the most extremes...
   if (_v < _lowerBound) then
   {
      _v = _lowerBound + (_lowerBound - _v);
   };
   
   // ... and the upper bound
   if (_v > _upperBound) then
   {
      _v = _upperBound - (_v - _upperBound);
   };
   
   _v
};


/*
   weather coefficients, used in generator functions
*/

private ["_humidityCoeff"];

// private function: returns a coefficient for a months `humidity` s.t.
// 0=completely dry, 1=totally wet and nasty, oO.
// [month, day] => scalar
_humidityCoeff = {
   private ["_month", "_day", "_probability", "_intensity", 
            "_a", "_b", "_c", "_pos"];
   
   _month = _this select 0;
   _day = _this select 1;
   
   //_probability = (_precipitation select (_this call _monthsIndex)) select 0;
   //_intensity   = (_precipitation select (_this call _monthsIndex)) select 1;

   /*
      ok, let's interpolate this, which is way more funny :)
      we'll use a bézier curve, where 0.3 = ~day1, 0.5 = ~day31
      ...so we may "overflow" the days by 30 days.
      
      using bezier-curves to interpolate between months leads to:
      
       - slightly lower probability/intensity, if the previous and next 
         months values are both lower.
         
       - slightly higher probability/intensity, if the previous and next
         months values are both higher.
         
       - but all in all it should balance it out. Also that "drift" is 
         rather minimal, since we use a small band of the bézier curve
         and a high multiplicity of the current months knot.
   */
   
   // interpolatino/bezier position, on [0.3, 0.5]
   _pos = 0.3 + ((_day / 31) * 0.2);
   if (_pos > 1) then { _pos = 1; };
   
   // probability knots
   _a = (_precipitation select ((_month - 1) call _monthsIndex)) select 0;
   _b = (_precipitation select (_month call _monthsIndex)) select 0;
   _c = (_precipitation select ((_month + 1) call _monthsIndex)) select 0;

   _probability = [
      [
         _a,
         _b, _b, _b, _b, _b,
         _c, _c
      ], 
      _pos
   ] call RUBE_bezier;
   
   // intensity knots
   _a = (_precipitation select ((_month - 1) call _monthsIndex)) select 1;
   _b = (_precipitation select (_month call _monthsIndex)) select 1;
   _c = (_precipitation select ((_month + 1) call _monthsIndex)) select 1;
   
   _intensity = [
      [
         _a,
         _b, _b, _b, _b, _b,
         _c, _c
      ], 
      _pos
   ] call RUBE_bezier;
   
   // we weight probability a way higher
   ((_probability^0.71 * _intensity^1.24)^0.5)
};



/*
   main private functions:
   ----------------------------------------------------
   Frau Holle's Kitchen
      (^^ you know... that sexy lady up in the clouds, 
              cooking the weather instead of sammiches)
   ----------------------------------------------------
   
    - There are _generateComponent functions for the 
      main components of weather, yet they do not produce
      the final weather all on their own. 
      
      Equally important is the "forecast"-process, which
      mutates/evolves/merges the weather as new days are 
      generated... and so is the number of forecast-days; 
      the higher this number, the more mutation/evolving
      is going on...
      
      
   Pressure configuration/system
   -----------------------------
   
   There are three main pressure components: the mean pressure (and it's
   standard deviation), the local pressure and an environmental/surrounding
   pressure, s.t.
   
      - all pressure readings operate on the same distribution (same mean/sd)
      
      - the local pressure is biased by Tmax, s.t.:
        - if Tmax < TavgMonth; rel. colder => rather higher pressure
        - if Tmax > TavgMonth; rel. warmer => rather lower pressure
        
      - the environmental pressure is biased by `humidity`(-Coeff), s.t.:
        - if `humidity` > 0.5: local low needed => Penv. rather higher pressure
        - if `humidity` < 0.5: local high needed => Penv. rather low pressure
        
        => so if it's a local dry season, we will have more local highs and
           environmental lows, and if it's a local rain season, we'll end up 
           with more local lows and environmental highs.
      
      - the bias should be roughly one standard deviation at max, while the
        standard deviation itself decreases s.t. the original (operational-) 
        range should be respected.
   
   ...from which we'll build two pressure coefficients as follows:
   
      - Pressure Coefficient I: 
        compares local pressure to the pressures mean, by dividing the absolute
        distance by four times the standard deviation (which is the max. possible
        distance between any pressure reading and the mean)
        
      - Pressure Coefficient II:
        compares the local pressure to the environmental one. This time the max.
        possible distance is eight times the standard deviation.
        
   
   So the pressure coefficient II is the main coefficient, that determines the 
   overall situation. Or the big picture. Pressure coefficient I, since compared
   to the mean, is more of a secondary coefficient for the local/micro situation
   or something.
   
   Anyway, we then may build the following matrix:
   
   
   Sy | coeffII x coeffI  | temp. | prec. | over. | fog   | wind  |     ???
   ---|-------------------|------------------------------------------------------
    0 |         |low      | +1    | +2    | +2    | -2    | +2    | warm core low
   ---|   LOW   |---------|-------|-------|-------|-------|-------|--------------
    1 |         |stable   |       |       |       |       |       |
   ---|         |---------|-------|-------|-------|-------|-------|--------------
    2 |         |high     | -1    |       |       |       |       | cold core low
   ---|---------|---------|-------|-------|-------|-------|-------|--------------
    3 |         |low      | +1    |       |       |       |       |
   ---| STABLE  |---------|-------|-------|-------|-------|-------|--------------
    4 |         |stable   |  /    |  /    |  /    | +2    | -2    |
   ---|         |---------|-------|-------|-------|-------|-------|--------------
    5 |         |high     | -1    |       |       |       |       |
   ---|---------|---------|-------|-------|-------|-------|-------|--------------
    6 |         |low      | +1    |       |       |       |       | warm core high
   ---|  HIGH   |---------|-------|-------|-------|-------|-------|--------------
    7 |         |stable   |       |       |       |       |       |
   ---|         |---------|-------|-------|-------|-------|-------|--------------
    8 |         |high     | -1    | -2    | -2    | -2    | +2    | cold core high
   ---|---------|---------|-------|-------|-------|-------|-------|--------------
   
      \________/ \_______/
       humidity x temperature   > "biased by ..."
   
                                  \______________________________________________/
                                   pressure conf./system then further biases the 
                                   remaining (-temp) main weather components
                                   
                           \_____/
                normally distributed to begin 
                with and used to bias Plocal  
                which determines coeffI        
                                   
                                   
                               
   Thus we have very strong and clear/non-ambiguous configurations/system: 
   
      0: (low/low), 
      4: (stable/stable) and 
      8: (high/high) 
   
   We have quite clear (identified as high/stable/low) ones:
   
      1: (low/stable),
      3: (stable/low),
      5: (stable/high) and
      7: (high/stable)
   
   And finally two configurations/systems, that are rather wierd - and so has the
   weather to be, I guess.
   
      2: (low/high) and
      6: (high/low)
      
      Anyway, due to the way we bias Plocal (temp.) and Penv. (humidity), these
   two "classes" of pressure configuration/system should not happen all too often.
   
   
   Pressure Stability Thresholds
   -----------------------------
   The coefficients indicate a High for values greater than zero and a Low for ones
   below zero. But when do we consider a situation as "stable"?
   
   For this, we'll work with a configurable pressure difference threshold (see 
   weather-constants.sqf) in Pa, somewhere below one standard deviation, since 
   the average difference is somewhere around 1.2 times the standard deviation.
   
   To map that difference threshold (in Pa) to our pressure coefficients, we can
   simply:
   
                    sigma * (threshold / sigma)       (threshold/sigma)
      Coeff. Th. =  ---------------------------   =   -----------------
                           R * sigma                          R
  
   ...where R = 4 for the pressure coefficient I and
            R = 8 for the pressure coefficient II,
            
            sigma is the standard deviation (in Pa) and
            threshold is that configureable threshold (in Pa)

   
   => The probability for a stable classification can now be easily 
      calculated, given:
      
               threshold (in Pa)
         dth = -----------------  and  Phi(x) = Normal Distribution Function
                 sigma (in Pa)                  (lookup in a table)
      
      
                                                           dth
         P_stable(coeffI)  = 2 * Phi(ci) - 1,   where ci = ---
                                                            4
                                                           
                                                           dth
         P_stable(coeffII) = 2 * Phi(ci) - 1,   where ci = ---
                                                            8
      
      => hm, only half the chance for coeffII; we might simply double
         the threshold for this one, such that the probability for stable
         conditions are equal for both coefficients. 
         Yeah, sounds like a plan. (see RUBE_atmosphericPressureSystem)
      
      
         So, for: threshold = 1000 Pa
                  sigma = 831.25 Pa
                  
             We get ciI = 0.3, thus P_stable(coeffI  = 0.3) = 0.2358 
                                                            = 23.6% 

         And for : threshold = 666 Pa, 
                   same sigma
         
             We get ciI = 0.2, thus P_stable(coeffI  = 0.2) = 0.1586 
                                                            = 15.9%
      
      To get a desired probability, you'd need to calculate that ci first:
      
                     P+1
         ci = Phi^-1(---) ,  where Phi^-1 is the inverse function of the
                      2      Normal Distribution Function and
                             P is the desired probability.
                            
         So if we wanna have a probability of 50% for stable conditions,
         then:
         
            ci = Phi^-1( 1.5/2 ) = Phi^-1(0.75) ~= 0.677
            
         And to get the needed threshold we calculate:
         
            threshold = 4 * ci * sigma
            
                      = 4 * 0.677 * 831.25 = 2251.025 Pa
         
      
      While these probabilities look rather low, keep in mind that for them
      to hold, the distritbution of pressure difference would need to be
      naturally distributed aswell - which it clearly is not; the expected
      value of difference is zero, not 0.5 (and looks like half the gauss 
      curve). 
      
      To correct this: ... hm, P^0.5 maybe? Even p^0.25? For sure it will 
      be way, waaay bigger. (TODO: how exactly do we calculate this? hmmm)
      
      
   So much for the pressure system. Phew. That is; just one final remark:
   Plocal and Penvironmental will both oscillate while the weather engine
   will be running (with initial position, range, ... setup accordingly).
   
   We'll see what and how much that will influence other aspects of the
   ingame weather components. It will probably have a big impact on the
   storm/shower-mask and probably other stuff too. The temperature for 
   example and so the snow line, etc...
      
*/

private ["_generateTemperature", "_generatePressure", "_generatePressureEnv", 
         "_generatePrecipitation", "_adjustPrecipitation", "_generateOvercast", 
         "_generateWind", "_generateFog", "_generateWeather"];


// [month, day] => [temperature, range]
_generateTemperature = {
   private ["_month", "_day", "_mean", "_t", "_r"];
   
   _month = _this select 0;
   _day = _this select 1;

   // interpolate monthly avg. temperatures
   //  -> we use one month more, so we can safely 
   //     "overflow" the days in a month
   _mean = [
      [
         [ 0, ((_temperature select (_month call _monthsIndex)) select 0)],
         [31, ((_temperature select ((_month + 1) call _monthsIndex)) select 0)],
         [61, ((_temperature select ((_month + 2) call _monthsIndex)) select 0)]
      ],
      _day
   ] call RUBE_neville;
      
   // normally distributed temperature for the day
   _t = [
      _mean, 
      ((_temperature select (_month call _monthsIndex)) select 1)
   ] call RUBE_randomGauss;
   
   
   // interpolate monthly avg. temp. range
   _mean = [
      [
         [ 0, ((_temperature select (_month call _monthsIndex)) select 2)],
         [31, ((_temperature select ((_month + 1) call _monthsIndex)) select 2)],
         [61, ((_temperature select ((_month + 2) call _monthsIndex)) select 2)]
      ],
      _day
   ] call RUBE_neville;
   
   // normally distributed with a st. dev. such that the range should
   // never drop below zero, given a positive range...
   _r = abs ([
      _mean, 
      (abs _mean)*0.25
   ] call RUBE_randomGauss);

   // return
   [_t, _r]
};



/*
   generates the local atmospheric pressure
*/
// [month, forecast] => scalar (in Pa)
_generatePressure = {
   private ["_month", "_day", "_forecast", "_Tmin", "_Trange", "_Tmax", 
            "_TavgMin", "_TavgStDev", "_TavgRange", "_TavgMax", 
            "_d", "_sigma", "_pa"];
   
   _month = _this select 0;
   _day = _this select 1;
   _forecast = _this select 2;
      
   _pa = (RUBE_weather getVariable "pressure-mean");
   _sigma = (RUBE_weather getVariable "pressure-sd");
      
   _Tmin = (_forecast select 0) select 0;
   _Trange = (_forecast select 0) select 1;
   _Tmax = _Tmin + _Trange;
   
   _TavgMin = (_temperature select (_month call _monthsIndex)) select 0;
   _TavgStDev = (_temperature select (_month call _monthsIndex)) select 1;
   _TavgRange = (_temperature select (_month call _monthsIndex)) select 2;
   _TavgMax = _TavgMin + _TavgRange;
   
   /*
      the plan is as follows:
      
      - if the temperature is above the month's mean temperature, then we
        rather have a local low
      - if the temperature is below the month's mean, then we rather have
        a local high
        
        ... all compared to the mean, at this point.
   */
   
   // map temp. diff (inverted) to [1, -1]. We know the mean and the st. dev, 
   // so this should work pretty well.
   _d = (_TavgMax - _Tmax) / (4 * _TavgStDev);
   
   if (_d < -1) then { _d = -1; };
   if (_d > 1) then { _d = 1; };
   
   
   // biased normal distribution
   _pa = [
      (_pa + (2 * _sigma * _d)),
      (_sigma / (1 + (abs _d)))
   ] call RUBE_randomGauss;


   // return as integer
   (round _pa)
};




/*
   generates the environmental/surrounding atmospheric pressure
*/
// [month, forecast] => scalar (in Pa)
_generatePressureEnv = {
   private ["_month", "_day", "_forecast", "_pa", "_sigma",
            "_humidity"];
   
   _month = _this select 0;
   _day = _this select 1;
   _forecast = _this select 2;
   
   _pa = (RUBE_weather getVariable "pressure-mean");
   _sigma = (RUBE_weather getVariable "pressure-sd");
   
   _humidity = [_month, _day] call _humidityCoeff;
   
   /*
      the plan is as follows:
      
         - if the humidity coeff. is high, we rather need a local 
           low, so Penv. is biased towards a high
           
         - if the humidity coeff. is low, we rather need a local
           high, so Penv. is biased towards a low
   */

   // next we map it to a range of [-1, 1]
   _humidity = (_humidity * 2) - 1;
   
   //... that's a bit too much of weight, so...
   _humidity = _humidity * 0.725;

   // biased normal distribution
   _pa = [
      (_pa + (2 * _sigma * _humidity)),
      (_sigma / (1 + (abs _humidity)))
   ] call RUBE_randomGauss;
      
   // return as integer
   (round _pa)
};






// [month, day, forecast] => precipitation (0 OR >0,<=1)
_generatePrecipitation = {
   private ["_month", "_day", "_forecast", "_paLoc", "_paEnv",  
            "_paCoeffI", "_paCoeffII", "_paSystem", "_humidity", 
            "_precProb", "_precAvg", 
            "_intensity", "_rolls", "_precEvent"];
   
   _month = _this select 0;
   _day = _this select 1;
   _forecast = _this select 2;
   
   _paLoc = (_forecast select 5) select 0;
   _paEnv = (_forecast select 5) select 1;
   
   _paCoeffI = _paLoc call RUBE_atmosphericPressureCoeff;
   _paCoeffII = [_paLoc, _paEnv] call RUBE_atmosphericPressureCoeff;

   _paSystem = [_paCoeffI, _paCoeffII] call RUBE_atmosphericPressureSystem;
   
   _humidity = [_month, _day] call _humidityCoeff; 
   
   // we do not interpolate the precipitation probability 
   //  (or should we, and if; how?)
   _precProb = (_precipitation select (_month call _monthsIndex)) select 0;
   _precAvg = (_precipitation select (_month call _monthsIndex)) select 1;


   // avg./intensity adjustments, depending on the pressure system
   switch (true) do
   {
      // LOW (no bonus if average is too low, though)
      case ((_paSystem in [0,1,2]) && (_precAvg > 0.195)):
      {
         _precAvg = _precAvg + (_humidity * (random 0.6));
         if (_precAvg > 1) then { _precAvg = 1; };
      };
      // HIGH
      case (_paSystem in [7,8]):
      {
         _precAvg = _precAvg - ( (1 - _humidity) * (random 0.6) );
         if (_precAvg < 0) then { _precAvg = 0; };
      };
   };
       
   // adjust the probability for prec. depeding on the pressure readings
   //  the amount of lows/highs is already biased by the humidity, s.t.
   //  we should get plenty of lows if needed, most of the time.
   _precProb = _precProb + (_precProb * -1.01 * _paCoeffII);
   _precProb = _precProb + (_precProb * -0.47 * _paCoeffI);
   
   // we're throwing the dice multiple times; otherwise we woudn't meet the
   // given monthly averages. (this is a more sensible approach, than simply
   // increasing _precProb)
   _rolls = 1;
   // ... not needed anymore; could come in handy again to treat some special
   // cases maybe... :/
   /*
   if (_precAvg < 0.4) then
   {
      _rolls = _rolls + 1;
   };
   */
   
   _precEvent = false;
   
   for "_i" from 1 to _rolls do
   {
      _precEvent = _precEvent || ((random 1.0) < _precProb);
      if (_precEvent) exitWith {};
   };
   
   
   // precipitation event
   _intensity = 0;
   
   if (_precEvent) then
   {
      // small, slightly random intensity adjustments      
      _precAvg = _precAvg + ((1 - _precAvg) * _paCoeffII * -0.36 * (random _precAvg));
      _precAvg = _precAvg + ((1 - _precAvg) * _paCoeffI * -0.65 * (random _precAvg));

      _intensity = [
         _precAvg,
         ((1 - _precAvg) * _precAvg)^1.72,
         [0,1]
      ] call RUBE_randomGauss;
      
   };

   _intensity
};


// forecast => void
_adjustPrecipitation = {
   private ["_month", "_day", "_forecast", "_intensity", "_precAvg", "_a", "_b"];
   
   _month = _this select 0;
   _day = _this select 1;
   _forecast = _this select 2;
   
   _intensity = (_forecast select 1) select 0;
   _precAvg = (_precipitation select (_month call _monthsIndex)) select 1;
   
   /*
      this is a good opportunity to fine tune/fix the precipitation
      proability... really!
   */
   
   // negate intensity if too low (to indicate a clear prec.-free day)
   //  exactly 0 means => 1D-walkers/oscillators will be negated that day
   if ((_intensity < 0.095) || 
       ((_intensity < (_precAvg * 0.6)) && ((random 1.0) < 0.4))) then
   {
      // ... or make it really rain/snow :) (perfect to fine-tune)
      if ((random 1.0) < 0.03) then
      {
         _a = [_precAvg, 0.06, [0, 1]] call RUBE_randomGauss;
         _intensity = (_precAvg + _a) * 0.5;
      } else
      {
         _intensity = 0;
      };
      
      (_forecast select 1) set [0, _intensity];
   };
   
   // we have a small chance to cut out preci. completely in the mutation/evo-process,
   // so here's a chance to achieve more of an average result
   if ((_intensity > 0) && (_intensity < _precAvg) && ((random 1.0) < 0.18)) then
   {
      _a = [_precAvg, 0.06, [0, 1]] call RUBE_randomGauss;
      _b = [_precAvg, 0.07, [0, 1]] call RUBE_randomGauss;
      
      _intensity = (_intensity + _precAvg + _a + _b) * 0.25;
      (_forecast select 1) set [0, _intensity];
   }; 
   
   // create new distubance mask
   /*
      yeah, this looks a bit out-of-place; the original plan was to
      have only one distubance mask for the current day, yet we need
      disturbance masks for all days for our forecasts/to calculate
      the daylight hours... so that's why :P
   */
   (_forecast select 1) set [
      1, 
      ([
         _forecast,
         [
            (_date select 0),
            _month,
            _day
         ],
         _latitude
      ] call RUBE_weatherGenerateDisturbanceMask)
   ];
};




// [month, forecast] => overcast ([0,1])
_generateOvercast = {
   private ["_month", "_forecast", 
            "_overcast", "_precInt", "_Tmin", "_Trange", "_Tmax", "_TrangeAvg",
            "_skewByTrange",
            "_paLoc", "_paEnv", "_paCoeffI", "_paCoeffII", "_paSystem"];
   
   _month = _this select 0;
   _forecast = _this select 1;
   
   _precInt = (_forecast select 1) select 0;
   
   _Tmin = (_forecast select 0) select 0;
   _Trange = (_forecast select 0) select 1;
   _Tmax = _Tmin + _Trange; 
   
   _TrangeAvg = (_temperature select (_month call _monthsIndex)) select 2;
   
   _paLoc = (_forecast select 5) select 0;
   _paEnv = (_forecast select 5) select 1;
   
   _paCoeffI = _paLoc call RUBE_atmosphericPressureCoeff;
   _paCoeffII = [_paLoc, _paEnv] call RUBE_atmosphericPressureCoeff;
   
   _paSystem = [_paCoeffI, _paCoeffII] call RUBE_atmosphericPressureSystem;
   
   _overcast = 0;
   _skewByTrange = false;
   
   switch (true) do
   {
      // LOW: pressure OR FORCED PREC. (only necessary with rain, not snow)
      case ((_paSystem in [0,1]) ||
            ((_precInt > 0.2) && (_Tmin > 5))
           ):
      {
         // over 0.7 
         _overcast = [0.83, 0.085, [0.7,1]] call RUBE_randomGauss;
         
         // slightly randomize if we've hit the lower bound
         if (_overcast == 0.7) then
         {
            _overcast = _overcast + (random 0.1);
         };
      };
      
      // LOW: cold core low (rare system)
      case (_paSystem == 2):
      {
         // ~0.7 without guarantees
         _overcast = [0.78, 0.115, [0,1]] call RUBE_randomGauss;
         _skewByTrange = true;
      };
      
      // HIGH: (cold core high)
      case (_paSystem in [7,8]):
      {
         // clear sky
         _overcast = abs ([0, 0.0725, [-1,1]] call RUBE_randomGauss);
         _skewByTrange = true;
      };
      
      // HIGH: warm core high (rare system)
      case (_paSystem == 6):
      {
         // clear/almost clear sky - most of the time
         _overcast = abs ([0.2, 0.135, [-1,1]] call RUBE_randomGauss);
         _skewByTrange = true;
      };
      
      // STABLE (3,4,5)
      default
      {
         // avg. below 0.5, with a quite large sd.
         // lower extremes (no clouds) can be achieved,
         // upper extremes rather not
         _overcast = abs ([0.375, 0.181, [-1,1]] call RUBE_randomGauss);
         _skewByTrange = true;
      };            
   };
   
   // skew overcast by Trange (in comparison to month's average), 
   //      s.t. Trange > TrangeAvg => more heating => less overcast
   //           Trange < TrangeAvg => less heating => more overcast
   if (_skewByTrange) then
   {
      _r = (_Trange - _TrangeAvg) / (_TrangeAvg * 9);
      
      if (_r > 0.3)  then { _r = 0.3; };
      if (_r < -0.2) then { _r = -0.2; };
      
      _overcast = _overcast^(1 + _r);
   };

   _overcast
};




// [month, forecast] => [speed, direction]
_generateWind = {
   private ["_month", "_forecast", "_speed", "_dir", "_windSpeedAvg",
            "_Tmin", "_Trange", "_Tmax",
            "_paLoc", "_paEnv", "_paCoeffI", "_paCoeffII", "_paSystem",
            "_c"];
   
   _month = _this select 0;
   _forecast = _this select 1;
   
   _windSpeedAvg = (_wind select (_month call _monthsIndex)) select 0;

   // temperature
   _Tmin = (_forecast select 0) select 0;
   _Trange = (_forecast select 0) select 1;
   _Tmax = _Tmin + _Trange; 
   
   // pressure
   _paLoc = (_forecast select 5) select 0;
   _paEnv = (_forecast select 5) select 1;
   
   _paCoeffI = _paLoc call RUBE_atmosphericPressureCoeff;
   _paCoeffII = [_paLoc, _paEnv] call RUBE_atmosphericPressureCoeff;
   
   _paSystem = [_paCoeffI, _paCoeffII] call RUBE_atmosphericPressureSystem;
 
   _speed = 0;  
    
   // skew avg. speed
   _c = ((abs _paCoeffI) * 2) - 1;
   _windSpeedAvg = _windSpeedAvg * (1 + (_c * 0.4)); 
    
   // and a small boost, since we'll lose too much under stable
   // conditions, regarding the averages
   if (_c > -0.2) then
   {
      _windSpeedAvg = _windSpeedAvg + (ln (1 + _windSpeedAvg))^0.75; 
   };
    
   // model by pressure configuration/system
   switch (true) do
   {
      // HIGH: (cold core high)
      case (_paSystem in [7,8]):
      {
         // average-highish speeds
         _speed = abs ([
            (_windSpeedAvg + (_windSpeedAvg * 0.175)), 
            (_windSpeedAvg * 0.32)
         ] call RUBE_randomGauss);
      };
      
      // HIGH: warm core high (rare system)
      case (_paSystem == 6):
      {
         // avg-highish speeds
         _speed = abs ([
            (_windSpeedAvg + (_windSpeedAvg * 0.135)), 
            (_windSpeedAvg * 0.25)
         ] call RUBE_randomGauss);
      };
      
      // LOW: pressure OR FORCED PREC. (only necessary with rain, not snow)
      case (_paSystem in [0,1]):
      {
         // very high speeds
         _speed = abs ([
            (_windSpeedAvg + (_windSpeedAvg * 0.592)), 
            (_windSpeedAvg * 0.592)
         ] call RUBE_randomGauss);
      };
      
      // LOW: cold core low (rare system)
      case (_paSystem == 2):
      {
         // avg speeds
         _speed = abs ([
            (_windSpeedAvg), 
            (_windSpeedAvg * 0.5)
         ] call RUBE_randomGauss);
      };
      
      // totally stable
      case (_paSystem == 4):
      {
         // good chance for virtually no speeds
         if ((random 1.0) < 0.75) then
         {
            _speed = abs ([0, (_windSpeedAvg * 0.05)] call RUBE_randomGauss);
         } else
         {
            _speed = abs ([0, (_windSpeedAvg * 0.21)] call RUBE_randomGauss);
         };
      };
            
      // STABLE (3,4,5)
      default
      {
         // usually very low speeds
         _speed = abs ([0, (_windSpeedAvg * 0.25)] call RUBE_randomGauss);
      };            
   };
    
   // we bias the wind direction by modeling the simplified
   // `Polar/Ferrel/Hadley`-cell model
   _dir = 0;
   
   // latitude, since corrected:  [North +90, ..., 0, ..., -90 South]
   //_latitude = (RUBE_weather getVariable "latitude");
   
   switch (true) do
   {
      case (_latitude > 60):  { _dir = 220; /* polar ost-winds */ };
      case (_latitude > 30):  { _dir =  50; /* west-winds */      };
      case (_latitude > 0):   { _dir = 240; /* ne-passat */       };
      case (_latitude > -30): { _dir = 300; /* se-passat */       };
      case (_latitude > -60): { _dir = 130; /* west-winds*/       };
      default                 { _dir = 320; /* polar ost-winds */ };
   };
   
   // it's only a bias, no direct order... :)
   _dir = ([_dir, 90] call RUBE_randomGauss) call RUBE_normalizeDirection;
   
   //
   [_speed, _dir]
};




/*
   Besides the intensity, there are 3 duration variables which define
   when fog is actually present and if it makes it through the day
   and so on... basically it's like in:
   
      - duration 1: fog at sunrise
      - duration 2: fog during the day
      - duration 3: fog at sunset
   
   TODO: For the love of god; someone please kill or rewrite me.
         (the results aren't too bad for now, but this function is an abomination)
*/
// [month, day, forecast] => [intensity ([0,1]), d1 ([0,1]), d2 ([0,1]), d3 ([0,1])]
_generateFog = {
   private ["_month", "_day", "_forecast", 
            "_fogProb", "_precInt", "_precProb", "_precAvg", "_humidity",
            "_Tmin", "_Trange", "_Tmax", "_TrangeAvg",
            "_paLoc", "_paEnv", "_paCoeffI", "_paCoeffII", "_paCoeffIIAbs", "_paSystem",
            "_c", "_t", "_s", "_u",
            "_intensity", "_d1", "_d2", "_d3"];
   
   _month = _this select 0;
   _day = _this select 1;
   _forecast = _this select 2;
   
   // seasonal occurrence probability for a fog event/occurrence
   _fogProb = (_fog select (_month call _monthsIndex)) select 0;
      
   // temperature
   _Tmin = (_forecast select 0) select 0;
   _Trange = (_forecast select 0) select 1;
   _Tmax = _Tmin + _Trange;  
   
   //_TrangeAvg = (_temperature select (_month call _monthsIndex)) select 2;
      
   // pressure
   _paLoc = (_forecast select 5) select 0;
   _paEnv = (_forecast select 5) select 1;
   
   _paCoeffI = _paLoc call RUBE_atmosphericPressureCoeff;
   _paCoeffII = [_paLoc, _paEnv] call RUBE_atmosphericPressureCoeff;
   
   _paSystem = [_paCoeffI, _paCoeffII] call RUBE_atmosphericPressureSystem;
   
   // precipitation
   _precInt= (_forecast select 1) select 0;
   // seasonal mean of prec. intensity as indicator for humidity/moisture
   _precProb = (_precipitation select (_month call _monthsIndex)) select 0;
   _precAvg = (_precipitation select (_month call _monthsIndex)) select 1;
   
   _humidity = [_month, _day] call _humidityCoeff;
      
   // overcast
   _overcast = (_forecast select 2) select 0;
   
   /*
      we do not consider negative influences from actively modeled 
      components such as wind speed or rain. These are handled
      by the weather engine - not by the generator.
      
      Potential influences (TODO):
       
       - Sea/salt in air, Lakes   <->   no sea, no salt, no lakes, ...
       - ...
       
      And now behold, this is going the be ugly :D
         ...and probably quite stupid - how do magne... uhm how does
         fog and why and when? :/
         
         -> especially because our "model" of humidity is quite lacking
            and there's no dew point and nothing ... (TODO)
   */
   
   // tweak base probability to catch days with lower winds
   _paCoeffIIAbs = ((abs _paCoeffII) * -2) + 1;
   _fogProb = _fogProb * (1 + ((0.5 + (random 0.5)) * _paCoeffIIAbs));
   
   // base level's/mean for normal dist.
   _intensity = 0;  //    in [0,1]
   
   _d1 =  0.1; // sunrise in [0,1]
   _d2 = -0.6; // day    in [-1,1]]
   _d3 =  0.1; // sunset  in [0,1]
   
      /* ==> cumulative max: [0.0, 0.1, -0.6, 0.1] 
       */
   
   // factor in general "humidity"
   _c = ((_humidity min 0.7071) min 
         ((random _fogProb) + (random _fogProb)))^2; // ~0.5 max, usually much lower
   
   _t = (random (_fogProb max 0.4)) min (random _fogProb);
   _s = (random (_fogProb max 0.5)) min (random _fogProb);
   _u = (random (_fogProb max 0.4)) min (random _fogProb);
      
      /* Did I already mention that it get's ugly?
         I'm sorry, but I currently have no better idea, than
         to spread _fogProb as much as possible, to average
         it out somehow... :/ fuck
      */
      
   _intensity = _intensity + (((random _fogProb) max 0.125) * _c);
   _d1 = _d1 + ( _t * _c);
   _d2 = _d2 + ( _s * _c);
   _d3 = _d3 + ( _u * _c);
   
      /* ==> cumulative max: [0.225, 0.25, -0.35, 0.25] 
       */
   
   // larger Trange => stronger cooling => +d1, +d3
   _c = (_Trange min 30) / 30;

   _intensity = _intensity + (((random (_humidity * _fogProb)^0.73) max 0.175) * _c);
   _d1 = _d1 + ( 0.4 * _c);
   _d2 = _d2 + ( (random 0.3) * _c);
   _d3 = _d3 + ( 0.4 * _c);

      /* ==> cumulative max: [0.30, 0.65, -0.05, 0.65] 
       */

   // cold temperatures/winter-months bonus (+ ice fog)
   _t = (-50 min (_Tmax max 20)); // [-50,20]
   
   // map to [0,~1], s.t.:  -50'=~1,   0'=2/3,   10'=1/2,   20'=0
   _c = ( (ln (2 - (_t / 20)))^0.531 ) * 0.805; 
   
   _s = _humidity;
   
   if (_humidity > 0.09) then
   {
      _s = (random (_fogProb min 0.4)) max (random (_fogProb max 0.4));
   };
   
   _intensity = _intensity + ((1 - _intensity) * _s * _c);
   _d1 = _d1 + ( ((random _fogProb) max 0.1) * _c);
   _d2 = _d2 + ( (0.3 + ((random _fogProb) max 0.3)) * _c);
   _d3 = _d3 + ( ((random _fogProb) max 0.1) * _c);
   
      /* ==> cumulative max: [0.6, 0.75, 0.85, 0.75] 
       */

   // occ. create more extremes, based on pressure
   _c = 1 - ( (1 - _paCoeffIIAbs) * (0.09 * (_humidity + _fogProb)) );
   switch (true) do
   {
      case ((random 1.0) < _fogProb): { _d1 = _d1^_c; };
      case ((random 1.0) < _fogProb): { _d3 = _d3^_c; };
   };
   
   
   // pressure situation adjustments
   switch (true) do
   {
      // HIGH: (cold core high)
      case (_paSystem in [7,8]):
      {
         _u = 0;
         
         if (_Tmax > (1 + (random 8))) then
         {
            // considered summer -> much lower fog
         } else
         {
            // considered winter -> chance for fog, nonetheless
            if ((random 1.0) < _fogProb) then
            {
               _u = 1; // don't get rid of fog
               
               // chance for a super fog day
               if ((_fogProb > 0.2) && ((random 1.0) < 0.16)) then
               {
                  // somewhere along these lines, hahaha :)
                  _intensity = 0.89;
                  _d1 = 0.5 + (random 0.4);
                  _d2 = 0.6 + (random 0.3);
                  _d3 = 0.4 + (random 0.5);
               } else
               {
                  _c = 0.1 * (random (1 - _fogProb));
                  _intensity = _intensity^(1 - (random 0.16) - _c);
                  
                  _d1 = _d1^(0.2 * (random (1 - _fogProb)));
                  _d3 = _d3^(0.2 * (random (1 - _fogProb)));
                  _d2 = _d2 + ( (1 - _d2) * (random _fogProb) );
               };
            };
         };
         
         // no fog
         if (_u < 0.5) then
         {
            _intensity = _intensity * ((random 2.0) max 0.5) * (random 0.5);
            _d1 = _d1 * ((random 3.0) max 0.5);
            _d3 = _d3 * ((random 3.0) max 0.5);
            if (_d2 > 0) then
            {
               _d2 = (_d2 * ((random 2.0) max 1.0)) - (random 1.0);
            };
         };
      
      };
      
      // HIGH: warm core high (rare system)
      case (_paSystem == 6):
      {
         _intensity = _intensity * ((random 2.0) max 0.25) * ((random 2.0) max 0.25);
         if (_d2 > 0) then
         {
            _d2 = (_d2 * (0.5 + (random 0.5))) - (0.5 * (random 1.0));
         };
      };
      
      // LOW: warm core low
      case (_paSystem in [0,1]):
      {
         _d1 = _d1 * (0.4 + (random 0.6));
         _d3 = _d3 * (0.5 + (random 0.5));
      
         if (_d2 > 0) then
         {
            _d2 = _d2^(1 + (random 0.9) + 0.57);
         };

         if ((random 1.0) < 0.67) then
         {
            if (_Tmax > (3 + (random 7))) then
            {
               _intensity = _intensity * (random 0.9) * (random 0.9);
            } else
            {
               // slight boost in winter, nonetheless
               _intensity = _intensity^(1 - (random 0.16) - 0.04);
            };
         } else
         {
            _intensity = _intensity * ((random 2.0) max 1.0) * (random 1.0);
         };
      };
      
      // LOW: cold core low (rare system)
      case (_paSystem == 2):
      {
         _d1 = _d1 * (0.5 + (random 0.5));
         _d3 = _d3 * (0.4 + (random 0.6));
         
         if (_d2 > 0) then
         {
            _d2 = (_d2 * (0.5 + (random 0.5))) - (0.5 * (random 1.0));
         };
         
         _intensity = _intensity * ((random 1.5) max 1.0) * (random 1.0);
      };
      
      // STABLE (3,4,5)
      default
      {      
         if ((random 1.0) < _fogProb) then
         {
            _c = (1 - _humidity)^0.74;
            
            _intensity = _intensity^(1 - (random _c) - 0.05);
            
            if (_d2 < 0) then { _d2 = (abs _d2)^(1 - (random 0.2)); };
            
            if ((random 1.0) < _fogProb) then { _d1 = _d1^(1 - (random _c) - 0.09); };
            if ((random 1.0) < _fogProb) then { _d2 = _d2^(1 - (random _c) - 0.14); };
            if ((random 1.0) < _fogProb) then { _d3 = _d3^(1 - (random _c) - 0.09); };
         } else
         {
            // chance for a super fog day
            if ((_Tmax < (-1 + (random 9))) && ((random 1.0) < _fogProb)) then
            {
               // :)
               _intensity = 0.89;
               _d1 = 0.89;
               _d2 = 0.85;
               _d3 = 0.78;
            } else
            {
               if ((_Tmax < (random 12)) && ((random 1.0) < _fogProb)) then
               {
                  _c = (1 - _fogProb)^(2 - (1 - _humidity));
                  switch (true) do
                  {
                     case ((random 1.0) < _fogProb): { _d1 = _d1^_c; };
                     case ((random 1.0) < _fogProb): { _d3 = _d3^_c; };
                     case ((random 0.9) < _fogProb): { _d2 = 0.5 + (random 0.4); };
                  };
                  
                  _intensity = _intensity^(0.8 + (random 0.4));
               } else
               {
                  _intensity = _intensity * (random 1.0) * (random 1.0);
               };
            };
         };
      };            
   };   
   
   // all in [0,1], except for _d2 which is in [-1, 1]
   _intensity = _intensity call _gaussAutoSD;
   
   _d1 = _d1 call _gaussAutoSD;
   _d2 = [_d2, -1.0 /* overwrite lower bound */] call _gaussAutoSD; 
   _d3 = _d3 call _gaussAutoSD;

   // ugh, let's get the hell out of here... :)
   [_intensity, _d1, _d2, _d3]
};








// [month, day, thisDayIndex, previousOrNextDayIndices, stability] => forecast
_generateWeather = {
   private ["_month", "_day", "_sourceIndex", "_links", "_linksN", "_stability", 
            "_forecast", "_i", "_j"];
   
   _month = _this select 0;
   _day = _this select 1;
   
   // indices to existing weather data
   _sourceIndex = _this select 2;   // existing forecast for this day
   _links = _this select 3;         // previous or next days forcast data
   _stability = _this select 4;     // defines chance of mutation/evolution
   
   _linksN = count _links;
   
   /*
      FORECAST DATA STRUCTURE DEFINITION
      ----------------------------------
      
      0: temperature    -> [
                              0: Tmin, 
                              1: Trange
                           ]
      1: precipitation  -> [
                              0: intensity (0 OR ]0,1]),
                              1: disturbance mask (array; will be slapped on at the very end)
                           ]
      2: overcast       -> [
                              0: intensity ([0,1])
                           ]
      3: fog            -> [
                              0: intensity ([0,1]),
                              1: duration 1, sunrise ([0,1]),
                              2: duration 2, day     ([0,1]),
                              3: duration 3, sunset  ([0,1]),
                           ]
      4: wind           -> [
                              0: speed in m/s ([0,oo]),
                              1: direction in degree ([0,360])
                           ]
      5: pressure       -> [
                              0: local atmospheric pressure at sea level, in Pa 
                                 (somewhere around ]98000, 104000[ with a mean of 101325),
                              1: environmental/surrounding atmospheric pressure at 
                                 sea level, in Pa
                           ]
   */
   _forecast = [
      /* 0 */ [0,0],
      /* 1 */ [0,[]],
      /* 2 */ [0],
      /* 3 */ [0,0,0],
      /* 4 */ [0,0],
      /* 5 */ [0,0]
   ];
   
   // chance to drop the source of a days weather
   if ((_stability < 0.4) && ((random 1.0) < 0.25)) then
   {
      _sourceIndex = -1;
   };
   
   // process
   switch (true) do
   {
      // two links available
      // --> (chance to) blend to days together, skipping/dropping the source
      case ((_linksN > 1) && ((random (1.0 - _stability)) > 0.21)):
      {
         if (_debug) then
         {
            diag_log format[" -> [T0-blend]: two links available, blend two days together"];
         };
         
         private ["_linkA", "_linkB", "_v", "_w"];
         
         _linkA = _weather select (_links call RUBE_randomPop);
         _linkB = _weather select (_links call RUBE_randomPop);
         
         // blend: temperature
         for "_i" from 0 to 1 do
         {
            _v = [
               ((_linkA select 0) select _i), 
               ((_linkB select 0) select _i)
            ] call _blendValues;
            
            (_forecast select 0) set [_i, _v];
         };
         
         // blend: pressure
         for "_i" from 0 to 1 do
         {
            _v = [
               ((_linkA select 5) select _i), 
               ((_linkB select 5) select _i)
            ] call _blendValues;
            
            (_forecast select 5) set [_i, _v];
         };
         
         // blend: precipitation
         _v = [
            ((_linkA select 1) select 0), 
            ((_linkB select 1) select 0)
         ] call _blendValues;
         
         _w = ((_linkA select 1) select 0) max ((_linkB select 1) select 0);
         if (_v < _w && ((random 1.0) < 0.5)) then
         {
            _v = ((_v + _w) * 0.5);
         };
         
         (_forecast select 1) set [0, _v];
         [_month, _day, _forecast] call _adjustPrecipitation;
         
         // blend: overcast
         _v = [
            ((_linkA select 2) select 0), 
            ((_linkB select 2) select 0)
         ] call _blendValues;
         
         (_forecast select 2) set [0, _v];
         
         // blend: fog
         for "_i" from 0 to 3 do
         {
            _v = [
               ((_linkA select 3) select _i), 
               ((_linkB select 3) select _i)
            ] call _blendValues;
            
            (_forecast select 3) set [_i, _v];
         };
         
         // blend: wind
         for "_i" from 0 to 1 do
         {
            _v = [
               ((_linkA select 4) select _i), 
               ((_linkB select 4) select _i)
            ] call _blendValues;
            
            (_forecast select 4) set [_i, _v];
         };
      };
      
      // no source, yet we have links available
      // --> (chance to) evolve weather (otherwise generate from scratch)
      case ((_sourceIndex < 0) && (_linksN > 0) && ((random 1.0) < 0.31)):
      {
         if (_debug) then
         {
            diag_log format[" -> [T1-evolve]: evolve weather, no source, some links"];
         };
         
         private ["_link", "_v", "_w", "_my", "_sigma"];
         
         _link = _weather select (_links call RUBE_randomPop);
         
         // evolve: temperature (link temp as new mean, only half std. dev.)
         _v = [
            ((_link select 0) select 0),
            (((_temperature select (_month call _monthsIndex)) select 1) * 0.5)
         ] call RUBE_randomGauss;
         (_forecast select 0) set [0, _v];
         
         // evolve: temperature range
         _v = [
            ((_link select 0) select 1),
            ((_link select 0) select 1)^0.25
         ] call RUBE_randomGauss;
         (_forecast select 0) set [1, _v];
                  
         // evolve: atmospheric pressure
         _my = RUBE_weather getVariable "pressure-mean";
         _sigma = RUBE_weather getVariable "pressure-sd";
         
         for "_i" from 0 to 1 do
         {
            _w = ((_link select 5) select _i);
            _v = [
               _w, 
               // lower st. dev. the farer away from mean
               (1 - ((abs (_my - _w))/(_sigma*4)) )^1.5
            ] call RUBE_randomGauss;
            (_forecast select 5) set [_i, _v];
         };
                  
         // evolve: precipitation        
         _v = [((_link select 1) select 0), 0.21, [0,1]] call RUBE_randomGauss;
         (_forecast select 1) set [0, _v];
         [_month, _day, _forecast] call _adjustPrecipitation;
         
         // evolve: overcast
         _v = [((_link select 2) select 0), 0.19, [0,1]] call RUBE_randomGauss;
         (_forecast select 2) set [0, _v];
         
         // evolve: fog
         for "_i" from 0 to 3 do
         {
            _v = [((_link select 3) select _i), 0.13, [0,1]] call RUBE_randomGauss;
            (_forecast select 3) set [_i, _v];
         };
         
         // evolve: wind
         _w = (_link select 4) select 0;
         _v = abs ([_w, _w^(0.2 + (random 0.3))] call RUBE_randomGauss);
         (_forecast select 4) set [0, _v];
         
         _w = random 30;
         _v = (((_link select 4) select 1) - _w + (random (_w * 2))) call RUBE_normalizeDirection;
         
         (_forecast select 4) set [1, _v];
         
      };      
   
      // no source, no links, no weather data existing at all
      // --> generate new weather from scratch
      case (_sourceIndex < 0):
      {
         if (_debug) then
         {
            diag_log format[" -> [T2-generate]: new weather from scratch"];
         };
         
         // generate: temperature
         _forecast set [
            0, 
            ([_month, _day] call _generateTemperature)
         ]; 
         
         // generate: atmospheric pressure
         _forecast set [
            5, 
            [
               ([_month, _day, _forecast] call _generatePressure),
               ([_month, _day, _forecast] call _generatePressureEnv)
            ]
         ]; 
         
         
         // generate: precipitation
         _forecast set [
            1, 
            [ 
               ([_month, _day, _forecast] call _generatePrecipitation)
            ]
         ]; 
         
         [_month, _day, _forecast] call _adjustPrecipitation;
         
         // generate: overcast
         _forecast set [
            2,
            [
               ([_month, _forecast] call _generateOvercast)
            ]
         ];
         
         // generate: fog
         _forecast set [
            3,
            ([_month, _day, _forecast] call _generateFog)
         ];
         
         // generate: wind
         _forecast set [
            4,
            ([_month, _forecast] call _generateWind)
         ];
         
      };
      
      // source only, no links (previous or next day) available for mutation
      // --> blend with new day according to given stability coefficient
      case (_linksN == 0):
      {
         if (_debug) then
         {
            diag_log format[" -> [T3-blend]: blend with new day"];
         };
         
         private ["_v", "_w", "_afterRain", "_source"];
         
         _source = _weather select _sourceIndex;

         // blend: temperature
         _w = [_month, _day] call _generateTemperature;
         
         for "_i" from 0 to 1 do
         {
            _v = [ 
               ((_source select 0) select _i),
               (_w select _i),
               _stability
            ] call _blendValues;
            (_forecast select 0) set [_i, _v];
         };
         
         // blend: atmospheric pressure
         _v = [
            ((_source select 5) select 0), 
            ([_month, _day, _forecast] call _generatePressure),
            _stability
         ] call _blendValues;
         (_forecast select 5) set [0, _v];
         
         _v = [
            ((_source select 5) select 1), 
            ([_month, _day, _forecast] call _generatePressureEnv),
            _stability
         ] call _blendValues;
         (_forecast select 5) set [1, _v];

         // blend: precipitation
         _afterRain = false;
         
         switch (true) do
         {
            // small chance to simply stop any rain-periods
            case ((((_source select 1) select 0) > 0.1) && ((random 1.0) < 0.11)):
            {
               (_forecast select 1) set [0, 0];
               _afterRain = true;
            };
            // blend
            default
            {
               _w = [_month, _day, _forecast] call _generatePrecipitation;
               _v = [ 
                  ((_source select 1) select 0),
                  _w,
                  _stability
               ] call _blendValues;
               
               (_forecast select 1) set [0, _v];
            };
         };
         
         [_month, _day, _forecast] call _adjustPrecipitation;
         
         // blend: overcast
         switch (true) do
         {
            // lower overcast if we've stop-mutated rain
            case (_afterRain):
            {
               (_forecast select 2) set [0, (((_source select 2) select 0) * (random 0.5))];
            };
            // blend
            default
            {
               _v = [
                  ((_source select 2) select 0), 
                  ([_month, _forecast] call _generateOvercast),
                  _stability
               ] call _blendValues;
               (_forecast select 2) set [0, _v];
            };
         };
         
         // blend: fog
         switch (true) do
         {
            // higher fog if we've stop-mutated rain
            case (_afterRain):
            {
               for "_i" from 0 to 3 do
               {
                  _w = (_source select 3) select _i;
                  _v = _w + ((1 - _w) * (random 0.67));
                  (_forecast select 3) set [_i, _v];
               };
            };
            // blend new with previous days 
            default
            {
               _w = [_month, _day, _forecast] call _generateFog;
               for "_i" from 0 to 3 do
               {
                  _v = [
                     ((_source select 3) select _i),
                     (_w select _i),
                     _stability
                  ] call _blendValues;
                  (_forecast select 3) set [_i, _v];
               };
            };
         };
         
         // blend: wind
         _w = [_month, _forecast] call _generateWind;
         
         for "_i" from 0 to 1 do
         {
            _v = [ 
               ((_source select 4) select _i),
               (_w select _i),
               _stability
            ] call _blendValues;
            (_forecast select 4) set [_i, _v];
         };
      };
      
      // default; we have source data and some links
      // --> mutate according to given stability coefficient,
      //     mutation sources are choosen randomly from links-pool
      default
      {
         if (_debug) then
         {
            diag_log format[" -> [T4-mutate]: mutate source and link"]; 
         };  
                  
         private ["_source", "_link", "_v", "_w", "_afterRain"];
         
         _source = _weather select _sourceIndex;
         _link = _weather select (_links call RUBE_randomSelect);
         
         // mutate: temperature
         for "_i" from 0 to 1 do
         {
            _v = [ 
               ((_source select 0) select _i),
               ((_link select 0) select _i),
               _stability
            ] call _blendValues;
            (_forecast select 0) set [_i, _v];
         };
         
         // mutate: reselect mutation source
         _link = _weather select (_links call RUBE_randomSelect);
         
         // mutate: atmospheric pressure
         for "_i" from 0 to 1 do
         {
            _v = [ 
               ((_source select 5) select _i),
               ((_link select 5) select _i),
               _stability
            ] call _blendValues;
            
            (_forecast select 5) set [_i, _v];      
         };   
         
         // mutate: reselect mutation source
         _link = _weather select (_links call RUBE_randomSelect);
         
         // mutate: precipitation
         _afterRain = false;
         
         switch (true) do
         {
            // small chance to simply stop any rain-periods
            case ((((_source select 1) select 0) > 0.1) && ((random 1.0) < 0.08)):
            {
               (_forecast select 1) set [0, 0];
               _afterRain = true;
            };
            // mutate
            default
            {
               _v = [ 
                  ((_source select 1) select 0),
                  ((_link select 1) select 0),
                  _stability
               ] call _blendValues;
               
               (_forecast select 1) set [0, _v];
            };
         };
         
         [_month, _day, _forecast] call _adjustPrecipitation;
         
         // mutate: reselect mutation source
         _link = _weather select (_links call RUBE_randomSelect);
         
         
         // mutate: overcast
         switch (true) do
         {
            // lower overcast if we've stop-mutated rain
            case (_afterRain):
            {
               (_forecast select 2) set [0, (((_source select 2) select 0) * (random 0.5))];
            };
            // mutate
            default
            {
               _v = [
                  ((_source select 2) select 0), 
                  ((_link select 2) select 0),
                  _stability
               ] call _blendValues;
               (_forecast select 2) set [0, _v];
            };
         };
         
         // mutate: reselect mutation source
         _link = _weather select (_links call RUBE_randomSelect);
         
         // mutate: fog
         switch (true) do
         {
            // higher fog if we've stop-mutated rain
            case (_afterRain):
            {
               for "_i" from 0 to 3 do
               {
                  _w = (_source select 3) select _i;
                  _v = _w + ((1 - _w) * (random 0.67));
                  (_forecast select 3) set [_i, _v];
               };
            };
            // mutate  
            default
            {     
               for "_i" from 0 to 3 do
               {
                  _v = [
                     ((_source select 3) select _i), 
                     ((_link select 3) select _i), 
                     _stability
                  ] call _blendValues;
                  (_forecast select 3) set [_i, _v];
               };
            };
         };
         
         // mutate: reselect mutation source
         _link = _weather select (_links call RUBE_randomSelect);
         
         // mutate: wind
         for "_i" from 0 to 1 do
         {
            _v = [ 
               ((_source select 4) select _i),
               ((_link select 4) select _i),
               _stability
            ] call _blendValues;
            (_forecast select 4) set [_i, _v];
         };
         
      };
   };
   
   // return forecast data
   _forecast
};





/*
   ok, let's do this!
*/

private ["_forecastStability"];

// forecast stability/reliability coefficient
// nDaysInFuture => scalar from 0 (unstable/unreliable) to 1 (stable/reliable)
//  TODO: maybe make this customizeable/overwriteable
_forecastStability = {
   //  n=1   n=2   n=3   n=4   n=5   n=6   n=7
   // .934, .801, .595, .417, .283, .188, .123, ...
   (1.54 * (_this / (exp _this))^0.5)
};


// init/create new weather
if ((count _weather) < 1) then
{   
   for "_i" from 0 to (_forecastSize - 1) do
   {
      _weather set [
         _i,
         ([
            _dateM, 
            (_dateD + _i),
            -1,
            [],
            1
         ] call _generateWeather)
      ];
   };
};


// apply forecast sorcery (mutate and generate a new day of weather)
for "_i" from 0 to (_forecastSize - 1) do
{
   switch (_i) do
   {
      case 0:
      {
         // copy current days weather to previous day slot
         _weather set [0, (_weather select 1)];
      };
      case (_forecastSize - 2):
      {
         // no link to next day
         _weather set [
            _i,
            ([
               _dateM, 
               (_dateD + _i - 1),
               (_i + 1),                     // source
               [(_i - 1)],                   // link to already mutated previous day
               (_i call _forecastStability)
            ] call _generateWeather)
         ];
      };
      case (_forecastSize - 1):
      {
         // last forecast
         _weather set [
            _i,
            ([
               _dateM, 
               (_dateD + _i - 1),
               -1,                           // no source
               [(_i - 1)],
               (_i call _forecastStability)
            ] call _generateWeather)
         ];
      };
      default
      {
         // days inbetween with previous and next links
         _weather set [
            _i,
            ([
               _dateM, 
               (_dateD + _i - 1),
               (_i + 1),                     // source
               [_i, (_i + 2)],               // links
               (_i call _forecastStability)
            ] call _generateWeather)
         ];
      };
   };
};

// return forecast/weather data
_weather