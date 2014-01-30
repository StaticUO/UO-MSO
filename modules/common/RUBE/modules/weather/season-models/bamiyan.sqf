#define DAY_TO_PROB(d) d/31
#define KMH_TO_MS(s) s/3.6

/*
   RUBE weather generator
   season model
   --
   
   model: bamiyan
   class: Dry (arid and semiarid) climates (BSh, steppe climate)
   source: Bamiyan (Afghanistan), Kabul (Afghanistan) to fill up
           some gaps... 
           
           http://www.weatherreports.com/
           http://www.weatherbase.com/

*/

([
   /* 0: temperature                                (model: bamiyan) 
      --------------------------------------------------------------
            
      [
         0: Tmin (or average), 
         1: std. dev., 
         2: Trange (daily), s.t. Tmin + Trange = Tmax
      ]
   */ 
   [
      [-5, 2.5, 4], //  0: Jan
      [-3, 2.6, 3], //  1: Feb
      [ 2, 2.8, 5], //  2: Mar
      [ 8, 3.0, 5], //  3: Apr
      [12, 3.1, 5], //  4: May 
      [16, 3.0, 6], //  5: Jun
      [19, 3.2, 6], //  6: Jul
      [18, 3.2, 6], //  7: Aug
      [13, 3.4, 7], //  8: Sep
      [ 7, 3.2, 6], //  9: Oct
      [ 1, 3.1, 6], // 10: Nov
      [-2, 2.8, 4]  // 11: Dec
   ],

   /* 1: precipitation                              (model: bamiyan)
      --------------------------------------------------------------
      
      [
         0: probability: daysWithPrecipitation/31 ([0,1]), 
         1: avg. intensity ([0,1])
      ]
   */ 
   [
      [DAY_TO_PROB(7),  0.38], //  0: Jan
      [DAY_TO_PROB(9),  0.49], //  1: Feb
      [DAY_TO_PROB(12), 0.56], //  2: Mar
      [DAY_TO_PROB(10), 0.52], //  3: Apr
      [DAY_TO_PROB(7),  0.31], //  4: May 
      [DAY_TO_PROB(3),  0.16], //  5: Jun
      [DAY_TO_PROB(4),  0.07], //  6: Jul
      [DAY_TO_PROB(6),  0.11], //  7: Aug
      [DAY_TO_PROB(5),  0.19], //  8: Sep
      [DAY_TO_PROB(4),  0.21], //  9: Oct
      [DAY_TO_PROB(3),  0.23], // 10: Nov
      [DAY_TO_PROB(7),  0.31]  // 11: Dec
   ],

   /* 2: fog                                        (model: bamiyan)
      --------------------------------------------------------------
      
      [
         0: probability: daysWith(noteworthy)FogOccurrence/31 ([0,1])
      ]
   */ 
   [
      [DAY_TO_PROB(11)], //  0: Jan
      [DAY_TO_PROB(10)], //  1: Feb
      [DAY_TO_PROB(8)], //  2: Mar
      [DAY_TO_PROB(3)], //  3: Apr
      [DAY_TO_PROB(2)],  //  4: May 
      [DAY_TO_PROB(1)],  //  5: Jun
      [DAY_TO_PROB(2)],  //  6: Jul
      [DAY_TO_PROB(2)], //  7: Aug
      [DAY_TO_PROB(4)], //  8: Sep
      [DAY_TO_PROB(6)], //  9: Oct
      [DAY_TO_PROB(9)], // 10: Nov
      [DAY_TO_PROB(10)]  // 11: Dec
   ],
   /* 3: wind                                       (model: bamiyan)
      --------------------------------------------------------------
      
      [
         0: avg. wind speed in m/s    
      ]
   */ 
   [
      [KMH_TO_MS(6)], //  0: Jan
      [KMH_TO_MS(8)], //  1: Feb
      [KMH_TO_MS(6)], //  2: Mar
      [KMH_TO_MS(12)], //  3: Apr
      [KMH_TO_MS(16)], //  4: May 
      [KMH_TO_MS(20)], //  5: Jun
      [KMH_TO_MS(19)], //  6: Jul
      [KMH_TO_MS(17)], //  7: Aug
      [KMH_TO_MS(14)], //  8: Sep
      [KMH_TO_MS(12)], //  9: Oct
      [KMH_TO_MS(6)], // 10: Nov
      [KMH_TO_MS(6)]  // 11: Dec
   ]
])