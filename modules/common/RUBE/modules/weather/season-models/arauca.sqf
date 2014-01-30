#define DAY_TO_PROB(d) d/31
#define KMH_TO_MS(s) s/3.6

/*
   RUBE weather generator
   season model
   --
   
   model:  arauca
   class:  Tropical rainforest climate (Af)
   source: Arauca (Columbia), 
           http://www.weatherbase.com/
*/

([
   /* 0: temperature                                 (model: arauca) 
      --------------------------------------------------------------
            
      [
         0: Tmin (or average), 
         1: std. dev., 
         2: Trange (daily), s.t. Tmin + Trange = Tmax
      ]
   */ 
   [
      [21, 1.7, 11], //  0: Jan
      [21, 2.4, 12], //  1: Feb
      [22, 2.5, 12], //  2: Mar
      [22, 2.3, 10], //  3: Apr
      [21, 2.0,  9], //  4: May 
      [21, 1.6,  8], //  5: Jun
      [22, 1.4,  7], //  6: Jul
      [22, 1.5,  9], //  7: Aug
      [21, 1.6, 10], //  8: Sep
      [21, 1.8, 10], //  9: Oct
      [21, 1.7, 11], // 10: Nov
      [21, 1.9, 11]  // 11: Dec
   ],

   /* 1: precipitation                               (model: arauca)
      --------------------------------------------------------------
      
      [
         0: probability: daysWithPrecipitation/31 ([0,1]), 
         1: avg. intensity ([0,1])
      ]
   */ 
   [
      [DAY_TO_PROB(5),  0.14], //  0: Jan
      [DAY_TO_PROB(2),  0.07], //  1: Feb
      [DAY_TO_PROB(2),  0.09], //  2: Mar
      [DAY_TO_PROB(9),  0.45], //  3: Apr
      [DAY_TO_PROB(12), 0.81], //  4: May 
      [DAY_TO_PROB(16), 0.89], //  5: Jun
      [DAY_TO_PROB(14), 0.80], //  6: Jul
      [DAY_TO_PROB(12), 0.77], //  7: Aug
      [DAY_TO_PROB(10), 0.79], //  8: Sep
      [DAY_TO_PROB(8),  0.63], //  9: Oct
      [DAY_TO_PROB(6),  0.39], // 10: Nov
      [DAY_TO_PROB(3),  0.11]  // 11: Dec
   ],

   /* 2: fog                                         (model: arauca)
      --------------------------------------------------------------
      
      [
         0: probability: daysWith(noteworthy)FogOccurrence/31 ([0,1])
      ]
   */ 
   [
      [DAY_TO_PROB(8)],  //  0: Jan
      [DAY_TO_PROB(4)],  //  1: Feb
      [DAY_TO_PROB(5)],  //  2: Mar
      [DAY_TO_PROB(8)],  //  3: Apr
      [DAY_TO_PROB(9)],  //  4: May 
      [DAY_TO_PROB(11)], //  5: Jun
      [DAY_TO_PROB(13)], //  6: Jul
      [DAY_TO_PROB(10)], //  7: Aug
      [DAY_TO_PROB(12)], //  8: Sep
      [DAY_TO_PROB(11)], //  9: Oct
      [DAY_TO_PROB(7)],  // 10: Nov
      [DAY_TO_PROB(6)]   // 11: Dec
   ],
   /* 3: wind                                        (model: arauca)
      --------------------------------------------------------------
      
      [
         0: avg. wind speed in m/s     
      ]
   */ 
   [
      [KMH_TO_MS(12)], //  0: Jan
      [KMH_TO_MS(10)], //  1: Feb
      [KMH_TO_MS(11)], //  2: Mar
      [KMH_TO_MS(12)], //  3: Apr
      [KMH_TO_MS(9)],  //  4: May 
      [KMH_TO_MS(9)],  //  5: Jun
      [KMH_TO_MS(12)], //  6: Jul
      [KMH_TO_MS(12)], //  7: Aug
      [KMH_TO_MS(12)], //  8: Sep
      [KMH_TO_MS(9)],  //  9: Oct
      [KMH_TO_MS(9)],  // 10: Nov
      [KMH_TO_MS(9)]   // 11: Dec
   ]
])