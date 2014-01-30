#define DAY_TO_PROB(d) d/31
#define KMH_TO_MS(s) s/3.6

/*
   RUBE weather generator
   season model
   --
   
   model:  kano
   class:  Tropical wet and dry or savanna climate (Aw)
   source: Kano (Nigeria), 
           http://www.weatherbase.com/
*/

([
   /* 0: temperature                                   (model: kano) 
      --------------------------------------------------------------
            
      [
         0: Tmin (or average), 
         1: std. dev., 
         2: Trange (daily), s.t. Tmin + Trange = Tmax
      ]
   */ 
   [
      [12, 2.5, 18], //  0: Jan
      [15, 2.4, 17], //  1: Feb
      [19, 1.9, 17], //  2: Mar
      [23, 2.1, 15], //  3: Apr
      [23, 1.8, 14], //  4: May 
      [22, 1.5, 12], //  5: Jun
      [21, 1.6, 10], //  6: Jul
      [21, 1.4,  8], //  7: Aug
      [21, 1.7, 10], //  8: Sep
      [21, 1.8, 15], //  9: Oct
      [16, 2.1, 17], // 10: Nov
      [13, 2.2, 17]  // 11: Dec
   ],

   /* 1: precipitation                                 (model: kano)
      --------------------------------------------------------------
      
      [
         0: probability: daysWithPrecipitation/31 ([0,1]), 
         1: avg. intensity ([0,1])
      ]
   */ 
   [
      [DAY_TO_PROB(0),  0.07], //  0: Jan
      [DAY_TO_PROB(1),  0.09], //  1: Feb
      [DAY_TO_PROB(1),  0.11], //  2: Mar
      [DAY_TO_PROB(1),  0.14], //  3: Apr
      [DAY_TO_PROB(5),  0.31], //  4: May 
      [DAY_TO_PROB(7),  0.44], //  5: Jun
      [DAY_TO_PROB(11), 0.59], //  6: Jul
      [DAY_TO_PROB(14), 0.67], //  7: Aug
      [DAY_TO_PROB(9),  0.49], //  8: Sep
      [DAY_TO_PROB(1),  0.47], //  9: Oct
      [DAY_TO_PROB(1),  0.10], // 10: Nov
      [DAY_TO_PROB(1),  0.07]  // 11: Dec
   ],

   /* 2: fog                                           (model: kano)
      --------------------------------------------------------------
      
      [
         0: probability: daysWith(noteworthy)FogOccurrence/31 ([0,1])
      ]
   */ 
   [
      [DAY_TO_PROB(0)],  //  0: Jan
      [DAY_TO_PROB(0)],  //  1: Feb
      [DAY_TO_PROB(1)],  //  2: Mar
      [DAY_TO_PROB(2)],  //  3: Apr
      [DAY_TO_PROB(1)],  //  4: May 
      [DAY_TO_PROB(2)], //  5: Jun
      [DAY_TO_PROB(4)], //  6: Jul
      [DAY_TO_PROB(5)], //  7: Aug
      [DAY_TO_PROB(3)], //  8: Sep
      [DAY_TO_PROB(4)], //  9: Oct
      [DAY_TO_PROB(2)],  // 10: Nov
      [DAY_TO_PROB(1)]   // 11: Dec
   ],
   /* 3: wind                                          (model: kano)
      --------------------------------------------------------------
      
      [
         0: avg. wind speed in m/s     
      ]
   */ 
   [
      [KMH_TO_MS(9)],  //  0: Jan
      [KMH_TO_MS(9)],  //  1: Feb
      [KMH_TO_MS(9)],  //  2: Mar
      [KMH_TO_MS(14)], //  3: Apr
      [KMH_TO_MS(14)], //  4: May 
      [KMH_TO_MS(14)], //  5: Jun
      [KMH_TO_MS(12)], //  6: Jul
      [KMH_TO_MS(9)],  //  7: Aug
      [KMH_TO_MS(9)],  //  8: Sep
      [KMH_TO_MS(14)], //  9: Oct
      [KMH_TO_MS(14)], // 10: Nov
      [KMH_TO_MS(14)]  // 11: Dec
   ]
])