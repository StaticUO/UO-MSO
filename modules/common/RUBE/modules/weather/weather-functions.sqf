/*
   RUBE weather module,
   weather function library
   --
   
   while some of these could be hidden in some fsm, I thought
   these should be more transparent to you; for inspection or
   trying out your own ideas...
   
*/





/*
   RUBE_lapseRate
   
   Description:
      calculates and returns the current lapse rate, by interpolating
      between dry adiabatic and moist/saturated adiabatic lapse rate,
      based on a extremely simplified approximation for saturation/air
      moisture. 
      
      So all in all, this is quite wacky... but whatever. :P
      
   Parameter(s):
      none OR scalar (for moisture)
      
   Returns:
      scalar in K/m
*/
RUBE_lapseRate = {
   private ["_moisture"];
   
   // we assume the air is fully saturated if it rains,
   // otherwise we take overcast as approximation for 
   // saturation/air moisutre
   _moisture = 1;
   
   if ((typeName _this) == "SCALAR") then
   {
      _moisture = _this;
   } else
   {
      if (rain < 0.001) then
      {
         _moisture = overcast;
      };
   };
   
   
   // return lapse rate
   ([
      [
         0.0098,   // dry adiabatic lapse rate
         0.0065,   // moist/saturated adiabatic lapse rate
         0.0065
      ], 
      _moisture
   ] call RUBE_bezier)
};




/*
   RUBE_atmosphericPressure
   
   Description:
      Returns the atmospheric pressure in Pa at the
      given height
   
   Parameter(s):
      _this: - height above sea level (scalar), or
             - position (array), or
             - object (object)
             
             => special case: if an `empty array` is passed,
                the pressure at the weather modules center
                (object) is returned.
      
   Returns:
      scalar (Pa)
*/
RUBE_atmosphericPressure = {
   private ["_h", "_p0", "_L", "_t0", "_g", "_M", "_R"];
   
   // m; height above sea level
   _h = _this;
   
   switch (typeName _h) do
   {
      case "OBJECT": 
      { 
         _h = (getPosASL _this) select 2; 
      };
      case "ARRAY":
      {
         if ((count _h) > 1) then
         {
            _h = getTerrainHeightASL _this;
         } else
         {
            _h = (getPosASL (RUBE_weatherEngine getFSMVariable "_weatherObject")) select 2;
         };
      };
   };  

   // Pa; sea level standard atmospheric pressure
   //_p0 = 101325;
   _p0 = RUBE_weatherEngine getFSMVariable "_pressureLocal";
   
   // K/m; temperature lapse rate (moist : 0.0065, dry : 0.0098)
   _L = [] call RUBE_lapseRate;
   
   // K; sea level standard temperature
   _t0 = (0 call RUBE_temperature) + 273.15; 
   
   // m/s^2; Earth - surface gravitational acceleration
   _g = 9.80665; 
   
   // kg/mol; molar mass of dry air 
   //  (avg. one for moist air doesn't change things by much, so whatever...)                           
   _M = 0.0289644;

   // J/(mol*K); universal gas constant
   _R = 8.31447;
   
   (_p0 * (1 - ((_L * _h) / (_t0))^((_g * _M) / (_R * _L))))
};



/*
   RUBE_atmosphericPressureCoeff
   
   Description:
      Returns the "quality" of the current atmospheric 
      pressure as a value between -1 and 1, s.t.
      
         c = -1:  extreme low pressure area
         c < 0:   low pressure area
         c = 0:   stable/balanced pressure area
         c > 0:   high pressure area
         c = 1:   extreme high pressure area
          
      in respect to the mean pressure (1. variant) or in
      respect to the environmental/surrounding pressure
      (2. variant).
      
      (see generator.sqf for more details) 
      
   Parameters:
   
      1. variant; single variable model/coefficient
      -------------------------------------------------
      This model assumes that the atmospheric pressure 
      in the (imaginary) circumjacent/surrounding 
      environment is constant at 101325 Pa. 
      
      (of course, we can calculate this coeff. also for  
       the environmental pressure)
      
      _this = none; taking the current pressure from
              the running weather engine
              
            = pressure (scalar)
            = readings (array [
                          0: pressure-local (scalar)
                       ])
               
      2) variant; dual variable model/coefficient
      -------------------------------------------------
      This model works with two pressure readings: the
      local pressure and the environmental pressure, 
      which are both naturally distributed with the 
      same mean and the same standard deviation.
      
      So this model is more dynamic, since we operate
      on a greater range of possible difference. And no,
      it would be not the same model as in the first 
      variant, given the environmental pressure would be
      constant at mean pressure: the coefficient would be
      roughly half at max, since we now divide by 8 times
      the standard deviation, instead of 4 times as in the
      first variant.
      
      _this = readings (array [
                          0: pressure-local (scalar), 
                          1: pressure-environment (scalar)
                       ])
  
   Returns:
      scalar in [-1, 1]
*/
RUBE_atmosphericPressureCoeff = {
   private ["_sd", "_PaLocal", "_PaEnv", "_divisor", "_dp", "_exp"];
   
   _sd = (RUBE_weather getVariable "pressure-sd");
   _PaLocal = false;
   _PaEnv = false;
   _divisor = 4; // half Pa range, multiple of sigma/st.dev.
   
   /*
      with an exponent < 1 we can push all pressure readings
      away from the mean, which leads to less stable conditions
      for CoeffI and CoeffII. 
      
      (tweaked to the current generator, verified with the stat.
       test suite, so don't touch this. :P )
   */
   _exp = 0.776;

   switch (typeName _this) do
   {
      case "SCALAR": { _PaLocal = _this; };
      case "ARRAY": 
      {
         if ((count _this) > 0) then
         {
            _PaLocal = _this select 0;
         };
         if ((count _this) > 1) then
         {
            _PaEnv = _this select 1;
            _divisor = 8; // full Pa range
         };
      };
   };
   

   if ((typeName _PaLocal) != "SCALAR") then
   {
      _PaLocal = RUBE_weatherEngine getFSMVariable "_pressureLocal";
   };
   
   if ((typeName _PaEnv) != "SCALAR") then
   {
      _PaEnv = RUBE_weather getVariable "pressure-mean";
   };
   
   _dp = (_PaLocal - _PaEnv) / (_divisor * _sd);
 
   if (_dp < -1) then { _dp = -1; };
   if (_dp > 1) then { _dp = 1; };

   // adjust/skew distribution
   if (_dp < 0) then
   {
      _dp = (_dp * -1)^_exp;
      _dp = _dp * -1;
   } else
   {
      _dp = _dp^_exp;
   };
   
   _dp
};

/*
   RUBE_atmosphericPressureCoeffII
   
   Description:
      short for RUBE_atmosphericPressureCoeff, 2. variant
      and live data from the weather engine
      
      (see RUBE_atmosphericPressureCoeff)
      
   Parameter(s):
      _this select 0: local pressure in, Pa (scalar)
      _this select 1: environmental pressure, in Pa (scalar)
      
   Returns:
      scalar in [-1, 1]
*/
RUBE_atmosphericPressureCoeffII = {
   private ["_local", "_env"];
   _local = false;
   _env = false;
   
   if ((typeName _this) == "ARRAY") then
   {
      if ((count _this) > 0) then { _local = _this select 0; };
      if ((count _this) > 1) then { _env = _this select 1; };
   };
   
   if ((typeName _local) != "SCALAR") then 
   {
      _local = RUBE_weatherEngine getFSMVariable "_pressureLocal";
   };
   
   if ((typeName _env) != "SCALAR") then 
   {
      _env = RUBE_weatherEngine getFSMVariable "_pressureEnv";
   };

   ([_local, _env] call RUBE_atmosphericPressureCoeff)
};



/*
   RUBE_atmosphericPressureSystem
   
   Description:
      Returns the pressure system class, based on pressure coefficient II
      and I. (see generator.sqf for more details)
      
   Pressure matrix/classes:
   
      Sy | coeffII x coeffI  |     ???
      ---|-------------------|--------------
       0 |         |low      | warm core low
      ---|   LOW   |---------|--------------
       1 |         |stable   |
      ---|         |---------|--------------
       2 |         |high     | cold core low
      ---|---------|---------|--------------
       3 |         |low      |
      ---| STABLE  |---------|--------------
       4 |         |stable   |
      ---|         |---------|--------------
       5 |         |high     |
      ---|---------|---------|--------------
       6 |         |low      | warm core high
      ---|  HIGH   |---------|--------------
       7 |         |stable   |
      ---|         |---------|--------------
       8 |         |high     | cold core high
      ---|---------|---------|--------------
       ^
   (this number will be returned)
   
   Parameter(s):
      _this select 0: coeffI  (scalar, optional; both or none, that is)
      _this select 1: coeffII (scalar, optional)
      
      -> will take the pressure readings from the
         running weather engine if no parameters
         are passed along...

   Returns:
      integer
*/
RUBE_atmosphericPressureSystem = {
   private ["_sd", "_th", "_dth", "_thresholdI", "_thresholdII", 
            "_coeffI", "_coeffII", "_system"];
   
   _system = 0;
   
   _sd = (RUBE_weather getVariable "pressure-sd");
   _th = (RUBE_weather getVariable "pressure-threshold");
   
   _dth = _th / _sd;
   
   _thresholdI = _dth / 4;
   _thresholdII = _dth / 8;
   //_thresholdII = _dth / 4; // thresholdII will count twice (in Pa),
                            // for the same "stable"-probability

   _coeffI = 99; 
   _coeffII = 99;
   
   // coefficients already supplied?
   if ((typeName _this) == "ARRAY") then
   {
      if ((count _this) > 1) then
      {
         _coeffI = _this select 0;
         _coeffII = _this select 1;
      };
   };
   
   // calculate with weather engine readings
   if ((_coeffI > 1) || (_coeffII > 2)) then
   {
      _coeffI = [] call RUBE_atmosphericPressureCoeff;
      _coeffII = [] call RUBE_atmosphericPressureCoeffII;
   };
      
   // classify
   switch (true) do
   {
      case (_coeffII > _thresholdII):        { _system = 6; };
      case (_coeffII < (_thresholdII * -1)): { /* 0 */ };
      default                                { _system = 3; };
   };
   
   switch (true) do
   {
      case (_coeffI > _thresholdI):        { _system = _system + 2; };
      case (_coeffI < (_thresholdI * -1)): { /* +0 */ };
      default                              { _system = _system + 1; }
   };
   
   _system
};




/*
   RUBE_temperature 
   
   Description:
      calculates and returns the current temperature (only valid for the
      troposphere; up to ~11000m above sea level).
      
      Factors: Tmin, Trange (daytime), height over sealevel (of weather-
      centric object, which is usually the player)
      
   Details:
      The factors to calculate the temperature are: Tmin, Trange and the 
      height. 
      
         - *Tmin* is a normally distributed temperature, depeding on the
           date, respectively the worlds weather/seasons-configuration.
           Also Tmin might be influenced by weather-events...
           
         - *Trange*, also depeding on seasonal data, is the amount added 
           to Tmin to model the diurnal cycle, such that Tmin + Trange is 
           the maximum temperature in a day, reached at ~15:00 (or even 
           later). The diurnal cycle is modeled by a Pearson Type-III 
           distribution, see: 
           
               Satterlung R. Donald - Modeling the Daily Temperature Cycle
               
               http://www.vetmed.wsu.edu/org_nws/NWSci%20journal%20articles/
               1983%20files/Issue%201/v57%20p22%20Satterlund%20et%20al.PDF 
               
             -> This function is not really continous at 00:00 <-> 24:00,
                but since our parameters a, y are fixed, we've chosen y
                high enough, such that the step isn't really much.
   
         - Finally the altitude is a factor too; depending on the air 
           moisture (overcast, rain) we interpolate between the dry and
           moist/saturated adiabatic lapse rate, such that the temperature
           decreases with altitude (unless there is an inversion, which 
           aren't modeled yet...)
   
   Parameters: 
      - none   (using the weather modules center as position/height), 
      - scalar (for the temperature at the given height above sea level),
      - object (for the temperature at the height of that object),
      - array [
         0: empty array|object|scalar  (to select from the above options)
         1: daytime (array, optional)
        ]
   
   Returns:
      scalar (in degree celsius)
*/
RUBE_temperature = {
   private ["_temp", "_weather", "_Tmin", "_Trange", "_h", "_time", "_y", "_a", "_t", "_lapseRate"];
   
   _temp = 0;
   _weather = RUBE_weatherEngine getFSMVariable "_weatherObject";
   _Tmin = RUBE_weatherEngine getFSMVariable "_Tmin";
   _Trange = RUBE_weatherEngine getFSMVariable "_Trange";
   _h = 0;
   _time = daytime;
   
   switch (typeName _this) do
   {
      case "SCALAR": { _weather = _this; };
      case "OBJECT": { _weather = _this; };
      case "ARRAY": 
      {
         if ((count _this) > 1) then
         {
            _weather = _this select 0;
            _time = _this select 1;
         };
      };
   };

   switch (typeName _weather) do
   {
      case "SCALAR": { _h = _weather; };
      case "OBJECT": { _h = (getPosASL _weather) select 2; };
   };

   // we don't model temperatures below sea level
   if (_h < 0) then { _h = 0; };

   _y = 0.67; // pearson: an empirically derived coefficient
   _a = 14; // length of period of rising temperature (in hours)
   _t = _time - _a; // adjusted daytime
   
   // Pearson Type-III distribution (diurnal cycle)
   _temp = _Tmin + (_Trange * (exp 1)^(-1 * _y * _t) * (1 + (_t / _a))^(_y * _a));
   
   // lapse rate (effect of altitude on temperature)
   //  - TODO: inversion, how though? :/
   _temp = _temp - (([] call RUBE_lapseRate) * _h);
   
   // return
   _temp
};



/*
   RUBE_weatherCalibrateTemperature
   
   Description:
      calibrates given seasonal temperatures in respect to the
      worlds elevation offset.
      
   Parameters:
      _this select 0: temperature (scalar)
      _this select 1: elevation offset (scalar)
   
   Returns:
      temperature (scalar)
*/
RUBE_weatherCalibrateTemperature = {
   private ["_temperature", "_elevationOffset"];
   
   _temperature = _this select 0;
   _elevationOffset = _this select 1;

   if (_elevationOffset < 0) then { _elevationOffset = 0; };
   
   _temperature = _temperature + ((0 call RUBE_lapseRate) * _elevationOffset);
   
   //diag_log format["calibrateTemperature: %1 =[%2 h]=> %3", _this select 0, _this select 1, _temperature];
   
   _temperature
};






/*
   RUBE_weatherSnowRatio
   
   Description:
    returns the amount of snow (as opposed to rain) in a range 
    from 0 to 1, where 
    
      0: means rain only, no snow and
      1: means snow only, no rain.
    
      - Snow can reach earth with temperatures up to 5°, 
      - but it can also rain with temps below 0° (Blitzeis)
   
      -> This function is not fully passive and actively "creates"
         the snow-rain ratio by slight randomization of the snow-rain
         transition function.
         
      -> Also this value doesn't mean much on its own. If the
         precipitation level is zero, there won't be any snow or
         rain anyway...
   
   Parameter(s):
    _this select 0: temperature (scalar)
    
   Returns:
    scalar
*/
RUBE_weatherSnowRatio = {
   private ["_temperature", "_snow", "_lower", "_upper", "_range", "_paCoeffII"];
   _temperature = _this;
   _snow = 0;
   
   // influence of pressure
   _paCoeffII = [] call RUBE_atmosphericPressureCoeffII;
   
   // lower bound for rain
   _lower = -1;
   // upper bound for snow
   _upper = 5;
   
   // minimal pressure adjustments (only some degrees if we have really extreme settings)
   if (_paCoeffII < 0) then
   {
      _upper = _upper + (5 * (abs _paCoeffII));
   } else
   {
      _lower = _lower - (3 * _paCoeffII);
   };

   switch (true) do
   {
      case (_temperature > _upper):  { _snow = 0.0; };
      case (_temperature < _lower): { _snow = 1.0; };
      
      // small chances for one or the other
      //case ((random 1.0) < 0.03): { _snow = 0.0; };
      //case ((random 1.0) < 0.04): { _snow = 1.0; };
      
      // randomized exponential transition map
      default
      {
         _range = _upper - _lower; // make sure that lower<0, upper>0
         
         // linear probability to snow
         if (_temperature > 0) then
         {
            _snow = (_upper - _temperature) / _range;
         } else
         {
            _snow = (_range - (abs (_lower - _temperature))) / _range;
         };
         
         // randomly distort p in favor of snow
         _snow = _snow^(0.3 + (random 0.6));
      };
   };
      
   // high (c > 0) => rather rain
   // low  (c < 0) => rather snow
   _snow = _snow^(1 + (_paCoeffII * 0.11));
   
   //
   _snow
};



/*
   RUBE_fog
   
   Description:
      calculates and returns the current fog level, modeling
      a diurnal cycle consisting of 3 phases: sunrise, day and sunset.
      And then there are other variables that might prevent fog, such
      as too much overcast/strong wind.
      
      - We will generate two values:
      
         - one for the regular in-game ArmA-Fog and 
         
         - a second value for `radiation fog` (or ground fog) which 
           will be used for an additional particle effect. 
           
      - This functions isn't designed to be called from outside the
        weather module's FSM. But whatever...
   
   Parameters:
    _this select 0: fog intensity           (scalar in [0,1])
    _this select 1: fog duration 1, sunrise (scalar in [0,1])
    _this select 2: fog duration 2, day     (scalar in [0,1])
    _this select 3: fog duration 3, sunset  (scalar in [0,1])
    _this select 4: wind speed, unchocked in m/s 
    
    _this select 5: overcast (overcast, optional)
    _this select 6: time (daytime, optional)
    
   
   Returns:
      [regularFog (scalar), radiationFog (scalar)]
*/
RUBE_fog = {

   private ["_intensity", "_radiation", "_d1", "_d2", "_d3", "_windSpeed", "_maxWindSpeed",
            "_paCoeffI", "_overcast", "_time", "_dt", "_dw", "_a", "_m"];

   _overcast = overcast;
   _time = daytime;

   /*
       TODO: effect of altitude/beeing above the clouds/fog-layer.
             - in (or up to) which height is that cloud/fog-layer?
             - should this also affect overcast?
             
             ~> uhm, we have higher wind speeds up there, so less fog anyway.. 
   */
   
   // fog definition
   _intensity = _this select 0;

   _d1 = _this select 1;
   _d2 = _this select 2;
   _d3 = _this select 3;
   
   _windSpeed = _this select 4;
   
   //
   if ((count _this) > 5) then
   {
      _overcast = _this select 5;
   };
   
   if ((count _this) > 6) then
   {
      _time = _this select 6;
   };
   
   // time coeff
   _dt = daytime / 24;
   
   // influence of windspeeds on overall fog intensity
   // wind speed coeff, cap at ~100km/h (~38.9m/s)
   _maxWindSpeed = ceil (100 / 3.6);
   if (_windSpeed > _maxWindSpeed) then { _windSpeed = _maxWindSpeed; };

   _dw = [
      [1,1,0.1,0.1], 
      (_windSpeed / _maxWindSpeed)
   ] call RUBE_bezier;
   
   _intensity = _intensity * _dw;
   
   // influence of pressure   
   // high pressure => higher temp (if rest stays const.) => can hold more moisture => less fog
   // low pressure => lower temp => can hold less moisture => more fog
   _paCoeffI = [] call RUBE_atmosphericPressureCoeff;
   _intensity = _intensity^(1 + (_paCoeffI * 0.1));
   
   // map overall intensity (most likely lower intensity during day)
   _a = (_d1 + _d2) * 0.5;
   _m = (_d3 + _d2) * 0.5;
   
   _intensity = _intensity * ([
      [1, 1, _a, _m, 1, 1], 
      _dt
   ] call RUBE_bezier);
   
   if (_intensity < 0) then { _intensity = 0; };
      
   // radiation function, based on the three duration variables
   _a = (_d1 + _d3) * 0.5;
   _m = _d2;
   if (_d2 < _a) then
   {
      _m = _d2 - (_a - _d2);
   };
   
   _radiation = [
      [_a, _d1, _d1, _m, _m, _m, _d3, _d3, _a],
      _dt
   ] call RUBE_bezier;
   
   if (_radiation > 1) then { _radiation = 1; };
   if (_radiation < 0) then 
   { 
      _radiation = 0; 
   } else
   {
      // intensity boost (positive influence)
      _radiation = _radiation + (_radiation * (1 - _radiation)^0.87 * _intensity);
      
      // intensity correlation (negative influence)
      // -> no loss up to _a (upper bound)
      _a = 0.6; // upper bound
      if (_intensity < _a) then
      {
         _radiation = _radiation * ((_intensity/_a)^0.3);
      };      

      // wind influence, loss of radiation fog
      _maxWindSpeed = ceil (20 / 3.6);
      if (_windSpeed > _maxWindSpeed) then { _windSpeed = _maxWindSpeed; };

      _dw = [
         [1,1,0,0,0,0], 
         (_windSpeed / _maxWindSpeed)
      ] call RUBE_bezier;
      
      _radiation = _radiation * _dw;
   };

   //
   [_intensity, _radiation]
};



/*
   RUBE_weatherRandomChoke
   
   Description:
    map's a value A to [0, A], with an expected value of A,
    thus creating a stuttering/choke effect, which is useful
    for wind speed or rain intensity randomization...
    
   Parameters:
    _this select 0: value (scalar)
    _this select 1: zero choke-point (scalar in [0, `max. choke-point`[, optional)              
    _this select 2: max. choke-point (scalar in [`zero choke-point`, 1], optional)
      
      => make sure zero-choke point is strictly(!) smaller than
         max. choke-point!              
    
    
      (choke/output multiplier)
    
           ^
       1.0 |            ------------------  
           |           /
           |          / ^
           |         /  max. choke point
       0.0 |  ------/
           -------------------------------->  (rand in [0,1])
                   ^
              zero choke-point
    
    
      s.t. zero choke-point     = probability for zero output and
           1 - max. choke-point = probability for max. output
    
   Returns:
    scalar in [0, value]
*/
RUBE_weatherRandomChoke = {
   private ["_v", "_a", "_b", "_r"];
   
   _v = _this select 0;
   
   _a = 0.05; // very small chance for full choke
   _b = 0.4;  // 60% chance for no choke at all
   
   if ((count _this) > 1) then { _a = _this select 1; };
   if ((count _this) > 2) then { _b = _this select 2; };
   
   _r = random 1.0;
   
   if (_r >= _b) exitWith { _v };
   if (_r <= _a) exitWith { 0 };
   
   (_v * ((_r - _a) / (_b - _a))^0.5)
};



/*
   RUBE_weatherWindSpeed
   
   Description:
      models a diurnal/daily wind-cycle tied to the diurnal
      cycle of the temperature (higher wind speeds at day, 
      lower speeds at night) and randomly chokes it.
      
      Also the overall weather situation (pressure vs. pressure
      of the environment) plays a role.
   
   Parameter(s):
      _this select 0: wind speed in m/s (scalar)
      _this select 1: Tmin (scalar)
      _this select 2: Trange (scalar)
      _this select 3: height OR weather center object (scalar | object)
   
   Returns:
      array [
         0: wind speed, choked (scalar),
         1: wind speed, unchoked (scalar)
      ]
*/
RUBE_weatherWindSpeed = {
   private ["_speed", "_Tmin", "_Trange", "_Tmax", "_h", "_t", "_f",
            "_dt", "_dp", "_tm", "_h0", "_z0"];
   
   _speed = _this select 0;
   
   _Tmin = _this select 1;
   _Trange = _this select 2;
   _Tmax = _Tmin + _Trange;
   
   _h = _this select 3;
   if ((typeName _h) == "OBJECT") then
   {
      _h = (getPosASL _h) select 2;
   };
   
   // temperature at sea level
   _t = 0 call RUBE_temperature;

   // influence of overall weather situation/pressure gradient: lower 
   // speeds if stable, higher speeds if in High/Low pressure situation. 
   // While you might think that the generator should have already taken
   // care of this, sure, and it did. But the pressure changes randomly
   // while the weather module is running, so this takes care of that.
   _dp = abs ([] call RUBE_atmosphericPressureCoeffII); // in [-1,1]
   _f = 0.4; // leads to a multiplicator in [0.8,1.2]
   
   _speed = _speed * (1 + (_dp * _f) - (_f * 0.5));
      
   
   // influence of diurnal cycle
   // TODO: We'd need to know if we're on a peak or in a valley to be 
   // able to model this better (no/less diurnal cycle in height/on peaks,
   // tripple-peaking cycles for valley streams, and so on...)
   //
   // Anyway, we know Tmin, Trange and Tmax; and t follows a
   // Pearson Type-III distribution. Thus we may simply
   // tune in and get our coefficient, so we don't need
   // to recalculate that distribution...
   _dt = (_t - _Tmin) / _Trange; // in [0,1] since _t in [Tmin, Tmax]
   
   // influence of diurnal cycle is stronger in summer than in winter,
   // ... so we make it stronger with more temperature...
   //
   //_f = 0.5; // amplitude => [0.5, 1.5] (might be a bit exaggerated/too much)
   _tm = _Tmin;
   if (_tm < -50) then { _tm = -50; };
   if (_tm > 50)  then { _tm =  50; };
   
   _f = 0.35 + (_tm / ((abs _tm)^1.4 + 100)); // amp.: -50: 0.2, 0: 0.35, +50: 0.5
   
   _speed = _speed * (1 + ((_dt - 0.5) * 2 * _f));
   
   
   // influence of altitude: for higher speeds up there...
   _h0 = 10;  // reference height; ~at sea level
   _z0 = 0.3; // roughness length; choosen extremely low, otherwise we'd gain 
              // too much speed in higher altitudes      
                
   if (_h > _h0) then
   {
      // we need to scale/tone this down a lot for Arma's scale/measures
      _speed = _speed * ( (ln ( (_h0 + ((_h - _h0)/27)) / _z0 )) / (ln (_h0 / _z0)) );
   };

   if (_speed < 0) then
   {
      _speed = 0;
   };

   // and finally we randomly choke the output to model turbulence at
   // ground-level.
   // TODO: don't if weatherObject is above ground level?
   // TODO: choke way less in high altitudes? even on ground level?
   [
      ([_speed, 0.15, 0.6] call RUBE_weatherRandomChoke),
      _speed
   ]
};


/*
   RUBE_weatherCalibrateWindSpeed
   
   Description:
      calibrates given seasonal wind speeds in respect to the
      worlds elevation offset.
      
   Parameters:
      _this select 0: speed in m/s (scalar)
      _this select 1: elevation offset (scalar)
   
   Returns:
      speed in m/s (scalar)
*/
RUBE_weatherCalibrateWindSpeed = {
   private ["_speed", "_elevationOffset", "_h0", "_z0"];
   
   _speed = _this select 0;
   _elevationOffset = _this select 1;

   // make sure these match the one used in RUBE_weatherWindSpeed!
   _h0 = 10;  // reference height; ~at sea level
   _z0 = 0.3; // roughness length
   
   if (_elevationOffset < _h0) then
   {
      _elevationOffset = _h0;
   };
   
   _speed = _speed * ( (ln (_h0 / _z0)) / (ln ( (_h0 + ((_elevationOffset - _h0)/27)) / _z0 )) ); 
   
   //diag_log format["calibrateWindSpeed: %1 =[%2 h]=> %3", _this select 0, _this select 1, _speed];
   
   _speed
};





/*
   RUBE_weatherGenerateMicro
   
   Description:
    creates the (micro-)weather for the current/ingame weather,
    based on the data from RUBE_weatherGenerator. We need a previous
    and a next day and spawn the daytime s.t. it correlates roughly
    as illustrated:
    
         data points:     t_{i-1}      t_{i}      t_{i+1}
                         (yesterday)    /\       (tomorrow)
                             /\         ||          /\
                             ||         ||          ||
                             \/         \/          \/                   
         today's daytime:  12:00 ----> 12:00 ----> 12:00 ----> ???
                            (12h)       (24h)       (12h)
    
    The micro-weather is modeled with one-dimensional, bounded random 
    walkers/oscillators. These are continuous, so it doesn't matter if 
    we "start"a day at 23:55. Plus the weatherModule is capable of polling
    the next days weather on it's own. 
*/
RUBE_weatherGenerateMicro = {
   private ["_precipitation", "_overcast", "_fog",
            "_dt", "_deltas", "_oscs", "_walkerOSC", "_walkerConfig"];
      
   _dt = (12 + daytime)/48; // [0,24] -> [1/4,3/4]
   _deltas = [];
   
   // calculate initial walker position
   _walkerOSC = {
      private ["_s0", "_base", "_mul", "_abs", "_osc1", "_osc2", "_diff", "_sign"];
      
      _s0 = _this select 0;
      _base = _this select 1;
      _mul = _this select 2;
      _abs = _this select 3;
      
      _osc1 = 0;
      _osc2 = 0;
      
      if (_abs) then
      {
         _diff = (_s0 - _base);
         if (_mul < 0) then { _diff = _diff * -1; };
         _sign = 1;
         if (_diff < 0) then { _sign = -1; };
         if (_diff > (_mul * 0.5)) then
         {
            _osc1 = 90 * _sign;
            _osc2 = (_mul - _diff) * 90 * _sign;
         } else
         {
            _osc1 = _diff * 90 * _sign;
            _osc2 = 0;
         };
      } else
      {
         _diff = _s0 - _base;
         _sign = 1;
         if (_diff < 0) then { _sign = -1; };
         if ((abs _diff) > (_mul * 0.5)) then
         {
            _osc1 = 90 * _sign;
            _osc2 = (_mul - _diff) * 90 * _sign;
         } else
         {
            _osc1 = _diff * 90 * _sign;
            _osc2 = 0;
         };
      };
      
      [_osc1, _osc2]
   };
   
   
   // calculate walker configuration based on
   // the deltas d1: prev.->current, d2: current->next
   _walkerConfig = {
      private ["_v0", "_v1", "_v2", "_forDeltaAvg", "_canGoZeroAnyway", "_intensityMultiplier",  
               "_pts", "_s0", "_d0", "_d1", "_d2", "_min", "_range", "_sum"];
      
      _v0 = _this select 0; // F( t_{i-1} ): yesterday
      _v1 = _this select 1; // F( t_{i}   ): today
      _v2 = _this select 2; // F( t_{i+1} ): tomorrow
      
      _pts = [];
      
      _forDeltaAvg = _this select 3;
      _canGoZeroAnyway = _this select 4;
      _intensityMultiplier = 1;
      
      if ((count _this) > 5) then
      {
         _intensityMultiplier = _this select 5;
      };

      if (_dt < 0.5) then
      {
         _pts = [_v0, _v1, _v1]; // prev  -[1/4, 3/4]-> today 
      } else
      {
         _pts = [_v1, _v1, _v2]; // today -[1/4, 3/4]-> next
      };
      
      _s0 = [_pts, _dt] call RUBE_bezier; // todays start position
      
      _d0 = _v1 - _v0; // delta: yesterday -> today
      _d1 = _v2 - _v1; // delta: today -> tomorrow
      _d2 = _d0 + _d1; // sum in [0,1]
      
      _min = (_v0 min (_v1 min _v2));
      _range = (_v0 max (_v1 max _v2)) - _min;
      
      if (_canGoZeroAnyway) then
      {
         _min = 0;
         _range = (_v0 max (_v1 max _v2));
      };      
       
      _sum = (abs _d0) + (abs _d1); // abs. sum
      
      // register delta-sum for avg. delta
      if (_forDeltaAvg) then
      {
         _deltas set [(count _deltas), _sum];
      };
      
      private ["_intensity", "_base", "_mul", "_abs", "_osc1", "_osc2"];
      
      _intensity = (1 + (_sum * 0.5 * 15)) * _intensityMultiplier;
      _base = 0;
      _mul = 1;
      _abs = false;
      _osc1 = 0;
      _osc2 = 0;
      
      switch (true) do
      {
         case (_sum < 0.125):
         {
            // no trend, low deltas -> stable
            _base = _min + (_range * 0.5);
            _mul = _range;            
         };
         case ((_d0 > 0) && (_d1 > 0)):
         {
            // strict upward trend
            _abs = true;
            _base = _min;
            _mul = _range;
         };
         case ((_d0 < 0) && (_d1 < 0)):
         {
            // strict downward trend
            _abs = true;
            _base = _min + _range;
            _mul = -1;
         };
         default
         {
            // no trend, yet high deltas -> unstable
            _base = _min + (_range * 0.5);
            _mul = _range;              
         };
      };
           
      // return walker
      [
         // 0: current position/value [READ ONLY]  (scalar)
         0, 
         // 1: age; in simulation steps/iterations (integer)
         0, 
         // 2: settings                            (array)
         [
            (_intensity * 0.4), // 0: intensity (base)     (scalar)
            (_intensity * 0.6), // 1: intensity (random)   (scalar)
            _base,              // 2: base                 (scalar)
            _mul,               // 3: multiplier           (scalar)
            _abs                // 4: abs. range           (boolean)
         ],
         // 3: initial position of independent, unbounded 1D walkers   (array)
         ([_s0, _base, _mul, _abs] call _walkerOSC)
      ]
   };

   
   _oscs = [
      // 0: local atmospheric pressure
      ([
         (((_this select 0) select 5) select 0),   // previous days data
         (((_this select 1) select 5) select 0),   // current days data
         (((_this select 2) select 5) select 0),   // next days data
         false,                                    // consider for delta avg; only if in range [0,1]
         false,                                    // can go to zero anyway?
         1                                         // walker intensity (speed) multiplier
      ] call _walkerConfig),
      // 1: environmental/surrounding atmospheric pressure
      ([
         (((_this select 0) select 5) select 1),   // previous days data
         (((_this select 1) select 5) select 1),   // current days data
         (((_this select 2) select 5) select 1),   // next days data
         false,                                    // consider for delta avg; only if in range [0,1]
         false,                                    // can go to zero anyway?
         1                                         // walker intensity (speed) multiplier
      ] call _walkerConfig),
      // 2: precipitation (intensity)
      ([
         (((_this select 0) select 1) select 0),   // previous days data
         (((_this select 1) select 1) select 0),   // current days data
         (((_this select 2) select 1) select 0),   // next days data
         true,                                     // consider for delta avg; only if in range [0,1]
         true,                                     // can go to zero anyway?
         1.25                                      // walker intensity (speed) multiplier
      ] call _walkerConfig),
      // 3: overcast (intensity)
      ([
         (((_this select 0) select 2) select 0),
         (((_this select 1) select 2) select 0),
         (((_this select 2) select 2) select 0),
         true,
         true
      ] call _walkerConfig),
      // 4: fog (intensity)
      ([
         (((_this select 0) select 3) select 0),
         (((_this select 1) select 3) select 0),
         (((_this select 2) select 3) select 0),
         true,
         true
      ] call _walkerConfig),
      // 5: wind speed
      ([
         (((_this select 0) select 4) select 0),
         (((_this select 1) select 4) select 0),
         (((_this select 2) select 4) select 0),
         false,
         true,
         1.5
      ] call _walkerConfig),
      // 6: wind direction
      //    -> this will be slightly biased, since we have a "funny" scale where
      //       we'll always operate on the "big" angle, not the shortest one. 
      //       (ex. min=3, max=340 => angle/range = 3-340, and not 340-0, 0-3)
      //       ..., but whatever.
      ([
         (((_this select 0) select 4) select 1),
         (((_this select 1) select 4) select 1),
         (((_this select 2) select 4) select 1),
         false,
         false,
         1.2
      ] call _walkerConfig)
   ];
   
   // there shall be no minimal fluctuation if precipitation is exactly zero
   if ((((_this select 1) select 1) select 0) == 0) then
   {
      ((_oscs select 2) select 2) set [2, 0]; // set base to 0
      ((_oscs select 2) select 2) set [3, 0]; // set mul. to 0
   };
   
   // simulate/step all oscillators once
   {
      _x call RUBE_randomWalk;
   } forEach _oscs;
   
   // return
   [
      // 0: average transition time (in seconds)
      ([
         [
            [0,  5 * 60], // min. mean 
            [2,  1 * 60]  // max. mean
         ],
         ([_deltas] call RUBE_average)
      ] call RUBE_neville),

      // 1: oscillators
      _oscs
   ]
};



// done
RUBE_weatherModuleWeatherFncInit = true;