/*
   RUBE weather module,
   weather disturber
   --
   
   Shitty weather throughout the whole damn day? Or do you rather prefer 
   a hot afternoon with a good thunderstorm all of a sudden? And what
   comes first; overcast or precipitation?
   
   Yeah, you've guessed right. And this is all what the weather disturber
   is about: creating typical weather, depending on various static and
   some "live" (from the running weather engine) input variables.

       ------------        ---------------        ---------------
       |          |        |   random    |        | disturbance |
       | forecast |  ===>  | oscillators |   X    |    mask     |
       |__________|        |_____________|        |_____________|
      
     (macro config.)      (micro evolution)   (typical characteristics)
   
   
      This is not part of the weather generator, since we need this 
   data only for the current day, just like RUBE_weatherGenerateMicro, 
   which initializes the random oscillators/walkers for the current day. 
   And it isn't part of these random oscillators either, because these 
   do not offer the needed amount of freedom/expressiveness as our
   disturber will do. 
   And last but not least; the disturbance mask needs to be accessible 
   before we launch the weather engine, s.t. it will be possible to 
   manipulate the disturbance mask's configuration. (For example we might 
   wanna plan a sudden storm ~15 minutes into the mission or something)
   
   How about some illustrations?
   
            --------------------         --------------------  
            |         / \      |         |   __     _       |
            |        /   --    |         |__/  \_  / \__/\  |
            |       |      \_  |         |       \/       \_|
            |     _/         \_|         |                  |
            |_  _/             |         |                  |
            |_\/_______________|         |__________________|
            0         18      24         0                 24
            
              ( thunderstorm )            ( widespread low )
                  at 18:00           

   By using the keyframed (over daytime) bandlimiter, we've created a
   short but intense thunderstorm (because of heating; large Trange for 
   example) - given the overcast and precipitation levels are high enough
   at that day. On the right illustration, the bandlimiter is in use too,
   but this time to guarantee a minimal level, s.t. the oscillation is 
   kept above that point (0.7 for example, or s.t. it can drop a bit below
   0.7; which is the ominous rain-threshold in case you wonder...).

   There are other important details, which I'm not willing to illustrate 
   with ASCII-pictures, :P, such as the frequency of the two used 
   oscillators (a sin and a cos multiplied together), and likewise 
   important: the exponents we use on them (and which can be keyframe
   animated over the day together with the bands): a very small exponent
   near zero leads to short spikes of overcast/precipitation, while a
   huge exponent - maybe seven - leads to non-stop rain, only shortly
   interrupted by less intense moments. So the exponent comes in handy to
   model the characteristics of rain; maybe even think about coupling it
   with the latitude, such that rain is way heavier near the equator...
   
   And don't get confused, the disturber doesn't add anything; it takes it
   away or limits it's inputs. The random oscillators/walkers are the 
   "additive" source, while the disturber "carves out" stuff. So if the
   input is already near zero, the disturber won't have much to do. You
   can think about this like the randomChoke used on wind speeds or
   precipitation intensity - just one level higher and with control instead
   of randomness, since we have a different goal this time.
   
   
   Side effects
   
   Besides manipulating the overcast and precipitation, there is a pressure 
   feedback involved, returning a pressure bonus (high) in case we took 
   overcast/precipitation-intensity away, which we will return as soon as the
   bands/oscillator open - with the goal of making things a bit more dynamic
   (and maybe coherent at it). The pressure then should affect all kind of
   other weather stuff (temperature, wind, fog, ...) - even if only slightly 
   (and at this point this is maybe still a TODO thing; check the weather-
   functions to know more, hehe).
   
*/
/*
   Disturbance Mask,
   DATA STRUCTURE:
   
   [
      // 0: oscillator (OR empty array)
      [
         0: phase,
         1: frequency 1,
         2: frequency 2
         
         // frequencies are in radian, s.t.
         //  f=0.157 => 2 cycles an hour
         //  f=0.314 => a full (sin) cycle an hour
         //  f=0.628 => half a cycle an hour
         //  ...
         //  f=1.0   => a full cycle a day/in 24h
         
         // => the "sample rate" depends on the cycle
         //    time of the weather engine (fsm)
      ], 
      
      // 1: bandlimiter, keyframed/piecewise linearly interpolated
      //    over daytime (OR empty array)
      [
         [
            0: daytime (keyframe reference in [0,24]),
            -
            1: band minimum (scalar in [0,1]),
            2: band maximum (scalar in [0,1]),
            3: oscillator exponent (scalar in ]0,oo[)
         ],
         
         // ... (as many you like, just keep them in order - sorted
         //      by daytime, since we'll linearly interpolate band
         //      min., band max. and the osc's exponent in reference
         //      to the daytime
      ],
      
      // 2: overcast(er) (or empty array)
      [
         0: overcast phase plus (with respect to precipitation), 
         1: overcast exponent fraction (w.r.t. precipitation)
         
         // overcast "runs" on the same oscillator as precipitation,
         // yet with a small phase plus we'll make sure that overcast
         // comes prior to precipitation and with the exponent fraction,
         // a value supposed to be smaller than 1, we will have "longer"
         // overcast than precipitation, since we're pushing the curve a
         // bit up by this.
      ]
      
      // => turn off any of the three components of the disturbance mask by 
      //    simply passing an empty array instead of the components configuration.
      //    So a passive distrubance mask would be: [[], [], []]
   ]
*/








/*
   RUBE_weatherGenerateDisturbanceMask
   
   Description:
      returns the configuration of a disturbance mask.
      
   Parameter(s):
      _this select 0: forecast, "today"/day-x only (array, optional)
      _this select 1: date (array OR scalar, optional)
      _this select 2: latitude (array, optional)
   
   Returns:
    disturbance mask (array)
*/
RUBE_weatherGenerateDisturbanceMask = {
   private ["_forecast", "_today", "_latitude", "_date", "_seasonCoeff",
            "_paLoc", "_paEnv", "_paCoeffI", "_paCoeffII", "_paCoeffIIAbs", "_paSystem",
            "_oscillator", "_bands", "_overcaster",
            "_a", "_r", "_e", "_t", "_bandMax", "_bandExponent"];
   
   _today = [];
   _forecast = RUBE_weather getVariable "forecast";
   _date = RUBE_weather getVariable "date";
   _latitude = RUBE_weather getVariable "latitude";
   
   if ((typeName _this) == "ARRAY") then
   {
      if ((count _this) > 0) then { _today = _this select 0; };
      if ((count _this) > 1) then { _date = _this select 1; };
      if ((count _this) > 2) then { _latitude = _this select 2; };
   };
   
   if ((count _today) == 0) then
   {
      _today = _forecast select 1;
   };
   
   _seasonCoeff = [_date, _latitude] call RUBE_seasonCoeff;

   // pressure
   _paLoc = (_today select 5) select 0;
   _paEnv = (_today select 5) select 1;
   
   _paCoeffI = _paLoc call RUBE_atmosphericPressureCoeff;
   _paCoeffII = [_paLoc, _paEnv] call RUBE_atmosphericPressureCoeff;
   
   _paCoeffIIAbs = ((abs _paCoeffII) * -2) + 1; // [-1:unstable, 1:stable]
   
   _paSystem = [_paCoeffI, _paCoeffII] call RUBE_atmosphericPressureSystem;

   // init neutral disturbance mask
   _oscillator = [];
   _bands = [];
   _overcaster = [];   
   
   // set oscillator frequencies by pressure, s.t. we have larger ones
   // for stable conditions
   _a = (1.256 + (random 0.628)) + (_paCoeffIIAbs * (0.314 + (random 0.628)));
   _r = 0.2 + (random 0.2);
   
   _oscillator set [0, (random 99)];               // random phase/seed
   _oscillator set [1, (_a * _r) + (random 0.04)]; // freq1
   _oscillator set [2, (_a * (1 - _r))];           // freq2

   // set overcaster such that overcast is usually earlier, "over" and longer
   // than precipitation
   _a = 0.24 + (_paCoeffIIAbs * (0.1 + (random 0.1)));
   _e = 0.87 + (_paCoeffII * (0.1 + (random 0.15)));
   _overcaster set [0, _a]; // phase plus
   _overcaster set [1, _e]; // fraction of exponent (usually below 1)


   // bigger thunderstorm chance (with actual thunders) in summer season
   _a = (random 0.67) + ((1.2 + (random 0.8)) * _seasonCoeff);
   
   if (_a > 1.0) then 
   { 
      _a = 0.15; // full band 
   } else
   {
      _a = (0.15 * _seasonCoeff); // (top-)limited band to prevent thunders
   };
   
   _bandMax = 0.85 + _a;


   // mean oscillator exponent by latitude, s.t. we get much stronger periods
   // of overcast/prec. near the equator, than in polar regions, where air
   // can't hold many humidity anyway with those temperatures...
   
   _a = 0.1 + (random 0.1); // pushing the mask up near equator and up to ~45deg, then...
   _r = 5 + (random 2);     // we start pushing the mask down
   
   _bandExponent = [
      [_a, _a, _a, _r],
      ((abs _latitude) / 90)
   ] call RUBE_bezier;
   
   // ^^ this might look a bit extreme, but we'll mix this value with a more reasonable
   // one..., so hold on :9
   
   
   // by pressure system
   switch (true) do
   {
      // widespread prec.
      case (_paSystem in [0,1,3]):
      {
         // 00:00 "keyframe"
         _a = 0.4 + (random 0.3);
         _e = (_bandExponent + 0.25 + (random 0.75)) * 0.5;
         _bands set [0, [0, _a, _bandMax, _e] ];
         
         
         // ~08:00 
         _t = [8, 1.25, [4,10]] call RUBE_randomGauss;
         
         // good chance for a clearing(s)
         if ((random 1.0) < 0.4) then
         {
            // clearing(s) (maybe)
            _a = random 0.7;
            _e = (_bandExponent + (random 5.75)) * 0.5;
         } else
         {
            // steady levels
            _a = 0.6 + (random 0.1);
            _e = (_bandExponent + (random 1.0)) * 0.5;
         };
         _bands set [(count _bands), [_t, _a, _bandMax, _e] ];
         
         
         // ~15:00 
         _t = [15, 1.5, [11,20]] call RUBE_randomGauss;
         
         // small chance for a clearing(s) or the opposite
         if ((random 1.0) < 0.17) then
         {
            // clearing(s) (maybe)
            _a = 0.2 + (random 0.5);
            _e = (_bandExponent + (random 2.75)) * 0.5;
         } else
         {
            // steady levels
            _a = 0.6 + (random 0.1);
            _e = (_bandExponent + (random 1.0)) * 0.5;
         };
         _bands set [(count _bands), [_t, _a, _bandMax, _e] ];
         
         
         // 24:00 "keyframe"
         _a = 0.6 + (random 0.1);
         _e = (_bandExponent + 0.25 + (random 0.75)) * 0.5;
         _bands set [(count _bands), [24, _a, _bandMax, _e] ];
         
                    // daytime, min-band, max-band, exponent
      };
      
      // isolated afternoon/evening thunderstorms
      case (_paSystem in [2,7,8]):
      {
         // 00:00 "keyframe"
         _a = 0;
         _r = _bandMax * (0.5 + (random 0.5));
         _e = (_bandExponent + 1 + 1 + (random 3)) * 0.25;
         _bands set [0, [0, _a, _r, _e] ];
         
         // ~08:00 
         _t = [8, 1.5, [4,12]] call RUBE_randomGauss;
         _r = _bandMax * (0.25 + (random 0.5));
         _e = (_bandExponent + 1 + 1 + (random 5)) * 0.25;
         _bands set [(count _bands), [_t, _a, _bandMax, _e] ];
         
         // ~16:00 
         _t = [16.0, 1.5, [12,22]] call RUBE_randomGauss;
         _a = 0.7 + (random 0.25);
         _e = (_bandExponent + 0.5 + (random 1)) * 0.25;
         _bands set [(count _bands), [_t, _a, _bandMax, _e] ];
         
         // 24:00 "keyframe"
         _a = (random 0.5);
         _e = (_bandExponent + 1 + 1 + (random 2)) * 0.25;
         _bands set [(count _bands), [24, _a, _bandMax, _e] ];
      };
      
      // daytime/afternoon heating storms
      case (_paSystem in [6]):
      {
         // 00:00 "keyframe"
         _a = 0;
         _r = _bandMax * (0.5 + (random 0.5));
         _e = (_bandExponent + 1 + 1 + (random 7)) * 0.25;
         _bands set [0, [0, _a, _r, _e] ];
         
         // ~15:00 
         _t = [15, 1.45, [10,20]] call RUBE_randomGauss;
         _a = 0.6 + (random 0.15);
         _e = (_bandExponent + 0.5 + (random 1)) * 0.25;
         _bands set [(count _bands), [_t, _a, _bandMax, _e] ];
         
         // 24:00 "keyframe"
         _a = (random 0.5);
         _r = _bandMax * (0.5 + (random 0.5));
         _e = (_bandExponent + 1 + 1 + (random 5)) * 0.25;
         _bands set [(count _bands), [24, _a, _r, _e] ];
      };
      
      // undefined/stable (usually low influence of disturber)
      default
      {
         // 00:00 "keyframe"
         _a = (0.5 + (random 0.5))^(1 + (_paCoeffIIAbs * 0.2));
         _e = (_bandExponent + (random 2) + (random 2) + (random 2)) * 0.25;
      
         _bands set [0, [0, _a, _bandMax, _e] ];
         
         // ~12:00 
         _t = [12, 2, [4,20]] call RUBE_randomGauss;
         _a = (0.5 + (random 0.5))^(1 + (_paCoeffIIAbs * 0.2));
         _e = (_bandExponent + (random 2) + (random 2) + (random 2)) * 0.25;
         
         _bands set [(count _bands), [_t, _a, _bandMax, _e] ];
         
         // 24:00 "keyframe"
         _a = (0.5 + (random 0.5))^(1 + (_paCoeffIIAbs * 0.2));
         _e = (_bandExponent + (random 2) + (random 2) + (random 2)) * 0.25;
         
         _bands set [(count _bands), [24, _a, _bandMax, _e] ];
      };
   };

   /*
      granted, that wasn't too clever yet. But most importantly this 
      system let's the scripter create his own - and more elaborate -
      disturbance mask if needed. Maybe someone else comes up with 
      some good ideas...
   */
   [
      _oscillator,
      _bands,
      _overcaster
   ]
};







/*
   RUBE_weatherApplyDisturbanceMask
   
   Description:
      Applies a disturbance mask
      
   Parameter(s):
      _this select 0: readings [overcast, precipitation, (daytime)]
      _this select 1: disturbation mask
   
   Returns:
      [overcast, precipitation, pressureOffset (surplus)]
*/
RUBE_weatherApplyDisturbanceMask = {
   private ["_readings", "_overcast", "_precipitation", "_daytime",
            "_mask", "_oscillator", "_bandlimiter", "_overcaster", 
            "_normalize", "_bandLimit", "_evalOSC",
            "_amplitudeOvercast", "_amplitudePrecipitation", "_overcastShift",
            "_overcastExpFrac", "_interpolant", "_overcastD", "_precipitationD",
            "_pressurePotential", "_pressureOffset"];

   _readings = _this select 0;
   _overcast = _readings select 0;
   _precipitation = _readings select 1;
   _daytime = daytime;
   if ((count _readings) > 3) then
   {
      _daytime = _readings select 3;
   };
   
   _mask = _this select 1;
   
   _oscillator = [];
   _bandlimiter = [];
   _overcaster = [];
   
   if ((typeName _mask) == "ARRAY") then
   {
      if ((count _mask) > 0) then { _oscillator = _mask select 0; };
      if ((count _mask) > 1) then { _bandlimiter = _mask select 1; };
      if ((count _mask) > 2) then { _overcaster = _mask select 2; };
   };


   /*
      private functions
   */
   
   // [-1,1] => [0,1]
   _normalize = {
      ((_this + 1) * 0.5)
   };
   
   // [min, max, x] => [min, max]
   _bandLimit = {
      private ["_band"];
      
      _band = (_this select 1) - (_this select 0);
      
      ((_band * (_this select 2)) + ((_this select 1) - _band))
   };
         
   // [freq1, freq2, t] => scalar in [0,1]
   _evalOSC = {
      private ["_freq1", "_freq2", "_t"];
      _freq1 = _this select 0;
      _freq2 = _this select 1;
      _t = (_this select 2) * 57.2958;
      
      ((
         (sin (_t / _freq1)) * (cos (_t / _freq2))
      ) call _normalize)
   };

   /**/   
   _amplitudeOvercast = 1;
   _amplitudePrecipitation = 1;
   _overcastShift = 0;
   _overcastExpFrac = 1;
   
   if ((count _overcaster) > 0) then
   {
      _overcastShift = _overcaster select 0;
      _overcastExpFrac = _overcaster select 1;
   };
   
   // evaluate oscillator
   if ((count _oscillator) > 0) then
   {
      _amplitudeOvercast = [
         (_oscillator select 1), 
         (_oscillator select 2), 
         _daytime + (_oscillator select 0) + _overcastShift
      ] call _evalOSC;
      
      _amplitudePrecipitation = [
         (_oscillator select 1), 
         (_oscillator select 2), 
         _daytime + (_oscillator select 0)
      ] call _evalOSC;
   };
   
   
   // evaluate bandlimiter
   if ((count _bandlimiter) > 0) then
   {
      _interpolant = [_bandlimiter, _daytime] call RUBE_arrayInterpolate;

      _amplitudeOvercast = [
         (_interpolant select 1),
         (_interpolant select 2),
         _amplitudeOvercast^((_interpolant select 3) * _overcastExpFrac)
      ] call _bandLimit;
      
      _amplitudePrecipitation = [
         (_interpolant select 1),
         (_interpolant select 2),
         _amplitudePrecipitation^(_interpolant select 3)
      ] call _bandLimit;
   };

   // disturb and calculate pressure offset
   _pressurePotential = RUBE_weather getVariable "pressure-threshold";
   
   _overcastD = _overcast * _amplitudeOvercast;
   _precipitationD = _precipitation * _amplitudePrecipitation;
   
   _pressureOffset = ((3 * (_overcast - _overcastD)) + 
                           (_precipitation - _precipitationD))
                     * 0.25 * _pressurePotential;

   //
   [
      _overcastD,
      _precipitationD,
      _pressureOffset
   ]
};





// done
RUBE_weatherModuleDisturberFncInit = true;