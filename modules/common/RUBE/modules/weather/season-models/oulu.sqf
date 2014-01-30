#define DAY_TO_PROB(d) d/31
#define KMH_TO_MS(s) s/3.6

/*
   RUBE weather generator
   season model
   --
   
   model:  oulu
   class:  Continental Subarctic or Boreal (taiga) climates (Dfc, Dwc, Dsc)
   source: Oulu (Finland), 
           http://www.weatherbase.com/
*/

([
   /* 0: temperature                                   (model: oulu) 
      --------------------------------------------------------------
            
      [
         0: Tmin (or average), 
         1: std. dev., 
         2: Trange (daily), s.t. Tmin + Trange = Tmax
      ]
   */ 
   [
      [-13, 1.8, 6], //  0: Jan
      [-12, 2.0, 6], //  1: Feb
      [-8,  1.9, 7], //  2: Mar
      [-2,  2.4, 6], //  3: Apr
      [ 3,  2.5, 8], //  4: May 
      [ 9,  2.9, 7], //  5: Jun
      [12,  3.1, 7], //  6: Jul
      [10,  2.9, 6], //  7: Aug
      [ 5,  2.4, 6], //  8: Sep
      [ 0,  2.1, 4], //  9: Oct
      [-5,  1.8, 4], // 10: Nov
      [-11, 2.0, 6]  // 11: Dec
   ],

   /* 1: precipitation                                 (model: oulu)
      --------------------------------------------------------------
      
      [
         0: probability: daysWithPrecipitation/31 ([0,1]), 
         1: avg. intensity ([0,1])
      ]
   */ 
   [
      [DAY_TO_PROB(26), 0.30], //  0: Jan
      [DAY_TO_PROB(24), 0.31], //  1: Feb
      [DAY_TO_PROB(26), 0.29], //  2: Mar
      [DAY_TO_PROB(20), 0.24], //  3: Apr
      [DAY_TO_PROB(16), 0.41], //  4: May 
      [DAY_TO_PROB(15), 0.50], //  5: Jun
      [DAY_TO_PROB(15), 0.52], //  6: Jul
      [DAY_TO_PROB(16), 0.64], //  7: Aug
      [DAY_TO_PROB(17), 0.49], //  8: Sep
      [DAY_TO_PROB(24), 0.48], //  9: Oct
      [DAY_TO_PROB(28), 0.37], // 10: Nov
      [DAY_TO_PROB(28), 0.31]  // 11: Dec
   ],

   /* 2: fog                                           (model: oulu)
      --------------------------------------------------------------
      
      [
         0: probability: daysWith(noteworthy)FogOccurrence/31 ([0,1])
      ]
   */ 
   [
      [DAY_TO_PROB(10)], //  0: Jan
      [DAY_TO_PROB(10)], //  1: Feb
      [DAY_TO_PROB(11)], //  2: Mar
      [DAY_TO_PROB(7)],  //  3: Apr
      [DAY_TO_PROB(6)],  //  4: May 
      [DAY_TO_PROB(4)],  //  5: Jun
      [DAY_TO_PROB(7)],  //  6: Jul
      [DAY_TO_PROB(9)],  //  7: Aug
      [DAY_TO_PROB(9)],  //  8: Sep
      [DAY_TO_PROB(10)], //  9: Oct
      [DAY_TO_PROB(9)],  // 10: Nov
      [DAY_TO_PROB(8)]   // 11: Dec
   ],
   /* 3: wind                                          (model: oulu)
      --------------------------------------------------------------
      
      [
         0: avg. wind speed in m/s     
      ]
   */ 
   [
      [KMH_TO_MS(16)], //  0: Jan
      [KMH_TO_MS(14)], //  1: Feb
      [KMH_TO_MS(14)], //  2: Mar
      [KMH_TO_MS(16)], //  3: Apr
      [KMH_TO_MS(17)], //  4: May 
      [KMH_TO_MS(16)], //  5: Jun
      [KMH_TO_MS(16)], //  6: Jul
      [KMH_TO_MS(9)],  //  7: Aug
      [KMH_TO_MS(14)], //  8: Sep
      [KMH_TO_MS(12)], //  9: Oct
      [KMH_TO_MS(14)], // 10: Nov
      [KMH_TO_MS(14)]  // 11: Dec
   ]
])