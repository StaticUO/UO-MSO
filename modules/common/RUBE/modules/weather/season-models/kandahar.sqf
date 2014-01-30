#define DAY_TO_PROB(d) d/31
#define KMH_TO_MS(s) s/3.6

/*
   RUBE weather generator
   season model
   --

   model: kandahar
   class: Dry (arid and semiarid) climates (BWh, desert climate)
   source: Kandahar (Afghanistan), 
           http://www.weatherbase.com/         (temperatures, precipitation)
           http://www.worldclimateguide.co.uk/ (precipitation)
           http://www.meoweather.com/          (fog)
*/

([
   /* 0: temperature                               (model: kandahar) 
      --------------------------------------------------------------
      
       - High variation between summer and winter temperatures
       - still warm in november, but nights are sharply cooler
      
      [
         0: Tmin (or average), 
         1: std. dev., 
         2: Trange (daily), s.t. Tmin + Trange = Tmax
      ]
   */ 
   [
      [ 0, 3.8, 12], //  0: Jan
      [ 2, 3.2, 15], //  1: Feb
      [ 7, 2.8, 15], //  2: Mar
      [12, 3.0, 15], //  3: Apr
      [16, 3.4, 17], //  4: May 
      [20, 3.6, 18], //  5: Jun
      [23, 3.4, 17], //  6: Jul
      [20, 3.6, 18], //  7: Aug
      [15, 3.8, 19], //  8: Sep
      [ 7, 4.2, 21], //  9: Oct
      [ 2, 3.9, 17], // 10: Nov
      [-1, 4.1, 13]  // 11: Dec
   ],

   /* 1: precipitation                             (model: kandahar)
      --------------------------------------------------------------
      
       - little precipitation, extremely dry summer period
       - Winter begins in December and sees most of its precipitation 
         in the form of rain
      
      [
         0: probability: daysWithPrecipitation/31 ([0,1]), 
         1: avg. intensity ([0,1])
      ]
   */ 
   [
      [DAY_TO_PROB(5), 0.52], //  0: Jan
      [DAY_TO_PROB(6), 0.42], //  1: Feb
      [DAY_TO_PROB(7), 0.39], //  2: Mar
      [DAY_TO_PROB(5), 0.21], //  3: Apr
      [DAY_TO_PROB(3), 0.08], //  4: May 
      [DAY_TO_PROB(0), 0.01], //  5: Jun
      [DAY_TO_PROB(1), 0.04], //  6: Jul
      [DAY_TO_PROB(0), 0.02], //  7: Aug
      [DAY_TO_PROB(0), 0.01], //  8: Sep
      [DAY_TO_PROB(0), 0.01], //  9: Oct
      [DAY_TO_PROB(1), 0.09], // 10: Nov
      [DAY_TO_PROB(4), 0.41]  // 11: Dec
   ],

   /* 2: fog                                       (model: kandahar)
      --------------------------------------------------------------
      
       - quite seldom, as it seems (no reliable sources found though)
      
      [
         0: probability: daysWith(noteworthy)FogOccurrence/31 ([0,1])
      ]
   */ 
   [
      [DAY_TO_PROB(6)], //  0: Jan
      [DAY_TO_PROB(5)], //  1: Feb
      [DAY_TO_PROB(3)], //  2: Mar
      [DAY_TO_PROB(1)], //  3: Apr
      [DAY_TO_PROB(0)], //  4: May 
      [DAY_TO_PROB(0)], //  5: Jun
      [DAY_TO_PROB(2)], //  6: Jul
      [DAY_TO_PROB(1)], //  7: Aug
      [DAY_TO_PROB(0)], //  8: Sep
      [DAY_TO_PROB(0)], //  9: Oct
      [DAY_TO_PROB(1)], // 10: Nov
      [DAY_TO_PROB(4)]  // 11: Dec
   ],
   /* 3: wind                                      (model: kandahar)
      --------------------------------------------------------------
      
      [
         0: avg. wind speed in m/s      
      ]
   */ 
   [
      [KMH_TO_MS(14)], //  0: Jan
      [KMH_TO_MS(18)], //  1: Feb
      [KMH_TO_MS(17)], //  2: Mar
      [KMH_TO_MS(11)], //  3: Apr
      [KMH_TO_MS(10)], //  4: May 
      [KMH_TO_MS(10)], //  5: Jun
      [KMH_TO_MS(10)], //  6: Jul
      [KMH_TO_MS(10)], //  7: Aug
      [KMH_TO_MS(11)], //  8: Sep
      [KMH_TO_MS(10)], //  9: Oct
      [KMH_TO_MS(11)], // 10: Nov
      [KMH_TO_MS(12)]  // 11: Dec
   ]
])