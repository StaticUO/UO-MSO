#define DAY_TO_PROB(d) d/31
#define KMH_TO_MS(s) s/3.6

/*
   RUBE weather generator
   season model
   --
   
   model:  prague
   class:  Warm Summer Continental or Hemiboreal climates (Dfb, Dwb, Dsb)
   source: Lovosice/Prague, remixed (Czech Republic), 
           http://www.weatherbase.com/
*/

([
   /* 0: temperature                                 (model: prague) 
      --------------------------------------------------------------
      
       - I've taken a mix of Tmin and Tavg, more of Tmin in winter 
         months, and Tavg for summer months, to model nicer/more 
         extreme winter and summer. (I have no idea of the weather 
         in the czech republic anyway :P)
      
      [
         0: Tmin (or average), 
         1: std. dev., 
         2: Trange (daily), s.t. Tmin + Trange = Tmax
      ]
   */ 
   [
      [-5, 3.3, 4], //  0: Jan
      [-4, 3.1, 4], //  1: Feb
      [ 1, 2.8, 4], //  2: Mar
      [ 7, 2.6, 7], //  3: Apr
      [12, 2.4, 8], //  4: May 
      [15, 2.3, 8], //  5: Jun
      [18, 2.5, 7], //  6: Jul
      [16, 2.7, 7], //  7: Aug
      [11, 3.0, 6], //  8: Sep
      [ 6, 3.1, 5], //  9: Oct
      [ 1, 3.2, 3], // 10: Nov
      [-2, 3.4, 3]  // 11: Dec
   ],

   /* 1: precipitation                               (model: prague)
      --------------------------------------------------------------
      
      [
         0: probability: daysWithPrecipitation/31 ([0,1]), 
         1: avg. intensity ([0,1])
      ]
   */ 
   [
      [DAY_TO_PROB(18), 0.31], //  0: Jan
      [DAY_TO_PROB(16), 0.24], //  1: Feb
      [DAY_TO_PROB(18), 0.28], //  2: Mar
      [DAY_TO_PROB(16), 0.38], //  3: Apr
      [DAY_TO_PROB(14), 0.64], //  4: May 
      [DAY_TO_PROB(15), 0.65], //  5: Jun
      [DAY_TO_PROB(14), 0.78], //  6: Jul
      [DAY_TO_PROB(14), 0.75], //  7: Aug
      [DAY_TO_PROB(13), 0.49], //  8: Sep
      [DAY_TO_PROB(13), 0.43], //  9: Oct
      [DAY_TO_PROB(17), 0.37], // 10: Nov
      [DAY_TO_PROB(20), 0.31]  // 11: Dec
   ],

   /* 2: fog                                         (model: prague)
      --------------------------------------------------------------
      
      [
         0: probability: daysWith(noteworthy)FogOccurrence/31 ([0,1])
      ]
   */ 
   [
      [DAY_TO_PROB(16)], //  0: Jan
      [DAY_TO_PROB(15)], //  1: Feb
      [DAY_TO_PROB(13)], //  2: Mar
      [DAY_TO_PROB(11)], //  3: Apr
      [DAY_TO_PROB(9)],  //  4: May 
      [DAY_TO_PROB(8)],  //  5: Jun
      [DAY_TO_PROB(7)],  //  6: Jul
      [DAY_TO_PROB(10)], //  7: Aug
      [DAY_TO_PROB(14)], //  8: Sep
      [DAY_TO_PROB(17)], //  9: Oct
      [DAY_TO_PROB(16)], // 10: Nov
      [DAY_TO_PROB(15)]  // 11: Dec
   ],
   /* 3: wind                                        (model: prague)
      --------------------------------------------------------------
      
      [
         0: avg. wind speed in m/s     
      ]
   */ 
   [
      [KMH_TO_MS(22)], //  0: Jan
      [KMH_TO_MS(20)], //  1: Feb
      [KMH_TO_MS(19)], //  2: Mar
      [KMH_TO_MS(16)], //  3: Apr
      [KMH_TO_MS(12)], //  4: May 
      [KMH_TO_MS(16)], //  5: Jun
      [KMH_TO_MS(16)], //  6: Jul
      [KMH_TO_MS(14)], //  7: Aug
      [KMH_TO_MS(17)], //  8: Sep
      [KMH_TO_MS(17)], //  9: Oct
      [KMH_TO_MS(20)], // 10: Nov
      [KMH_TO_MS(22)]  // 11: Dec
   ]
])