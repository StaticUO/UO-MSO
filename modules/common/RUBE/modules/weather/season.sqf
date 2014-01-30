/*
   RUBE weather generator
   seasonal data
   --
   
   Parameter(s):
      _this = model-name (string), or
            = model-data (array)
            
   Returns:
      array [
         0: model-name (string),
         1: model-data (array)
      ]
   

   Seasonal Data, (data structure):
   --------------------------------
   
      [
         // 0: temperature
         [ 
            [
               0: Tmin (or average) in degree celsius,         (scalar in [-oo, oo])
               1: standard deviation (on Tmin),                (scalar in [0, oo])
               2: Trange (daily),                              (scalar in [0, oo])
                  s.t. Tmin + Trange = Tmax
            ],
            ...
         ],
         
         // 1: precipitation
         [
            [
               0: probability: daysWithPrecipitation/31        (scalar in [0,1]), 
               1: avg. intensity                               (scalar in [0,1])
            ],
            ...
         ],
         
         // 2: fog
         [
            [
               0: probability: daysWith(noteworthy)Fog/31      (scalar in [0,1])
            ],
            ...
         ],
         
         // 3: wind
         [
            [
               0: avg. wind speed in m/s                       (scalar in [0,oo])
            ]
         ]
      ]
   
   
   Notes:
   ------
      
      - Each category (temperature, precipitation, fog, ...) consists of twelve
        arrays - one for each month, s.t. 
        
         0: january, 
         1: februrary, 
            ..., 
         11: december
      
      
      - Temperature: since we're modleing a diurnal (daily) cycle, we work with
        two averages (Tmin = minimum, Trange = additional range) instead of only
        one single value, s.t. the actual temperature at a given time will be:
        
            T = Tmin (normally distributed) + Trange * PearsonIII
        
        ...where PearsonIII is a variable for a Pearson type III distribution,
        which returns a value in [0,1]. Thus a days maximum temperature will be:
        
            Tmax = Tmin + Trange
            
        - The best part about using Tmin and Trange (instead of simply Tavg) is
          that we can model the difference of temperature at day vs. the 
          temperature at night. Is it extreme as in a desert? Or rather moderate?    
                       
        - PearsonIII: Btw. Parameters y and a for the Pearson type III 
          distribution are reasonably set and that's it. Nobody will care :) 
          
            see RUBE\modules\weather\functions.sqf for more details.
          
        - Standard deviation: For the existing models, this data comes right out 
          of my ***, and yours will probably too - unless you find a better 
          source.
          Anyway, given Tmin (from a reliable source), I suggest you plot some 
          normal distributions in mathematica/mathlab and adjust the st. dev. to 
          your liking... A visual representation gives a good feedback for the
          resulting range and probabilities. In case you don't have access to 
          some fancy math package, try: www.wolframalpha.com with an input like:
          
            "normal distribution, mean=-5, sd=3.3"
            
          ...where mean is Tmin and sd the standard deviation. -- And maybe read
          http://en.wikipedia.org/wiki/Standard_deviation for a minimal
          understanding, so you can easily judge the probabilities for certain
          bands of temperatures. 
        
        
     - About to make a new season model? A great source for reliable data is:
     
         http://www.weatherbase.com/  
         http://www.worldclimateguide.co.uk/ 
         http://www.weatherreports.com/
         http://freemeteo.com/
         
       Check it out!


   TODO:
   -----
   
     - Mabye the color-function should be part of the season model?
   
*/

private ["_model", "_models", "_isArray", "_isValid", "_data", "_elevationOffset"];

_model = _this;

// explicit model definition
if ((typeName _model) == "ARRAY") then
{
   // check passed data and trash it if it's garbage
   // (mainly we wanna be able to pass an empty array
   //  and still get default behaviour...)
   if ((count _model) < 3) then
   {
      _model = "";
   };
};

_isArray = ((typeName _model) == "ARRAY");
_isValid = false;
if (_isArray) then
{
   _isValid = ((count _model) > 0);
};

// custom model/full season model data
if (_isArray && _isValid) exitWith
{
   ["custom", _model]
};


// garbage passed?
if ((typeName _model) != "STRING") then
{
   _model = "";
};



/*
   available season models
   -----------------------
   
   as a guideline, I suggest you take a look at:

   Köppen climate classification
   http://en.wikipedia.org/wiki/K%C3%B6ppen_climate_classification
   
    GROUP A: Tropical/megathermal climates
    GROUP B: Dry (arid and semiarid) climates   
    GROUP C: Temperate/mesothermal climates
    GROUP D: Continental/microthermal climate
    GROUP E: Polar climates
    GROUP H: Alpine climates
    
   -> The idea would be to implement only one model for each of
      these climate classes.
      
      And hey, if you come up with a missing model (and defaults 
      for other worlds/islands), I'd gladly put them into my 
      official releases, aslong as you didn't screw around too 
      much. ;)
      
      Or if you don't agree with some defaults or something, just
      drop me a note.
      
      
   TODO: 
      - implement a procedural season model, based on latitude/longitude
        and a simplified clima model: polar <-> ferrel <-> hadley.
      
*/
_models = [

///// GROUP A: Tropical/megathermal climates 
/////          (Af, Am, Aw)
   
   /*
      model: arauca
      class: Tropical rainforest climate (Af)
   */
   "arauca",
   
   /*
      model: kano
      class: Tropical wet and dry or savanna climate (Aw)
   */
   "kano",

///// GROUP B: Dry (arid and semiarid) climates
/////          (BWh, BWk, BSh, BSk)

   /*
      model: bamiyan
      class: Dry (arid and semiarid) climates (BSh, steppe climate)
   */
   "bamiyan",

   /*
      model: kandahar
      class: Dry (arid and semiarid) climates (BWh, desert climate)
   */
   "kandahar",
   
///// GROUP C: Temperate/mesothermal climates 
/////          (Csa, Csb, Cwa-Cwc, Cfa-Cfc)
   /* 
      class: - Dry-summer subtropical or Mediterranean climates (Csa, Csb)
             - Humid subtropical climates (Cfa, Cwa)
             - Maritime Temperate climates or Oceanic climates (Cfb, Cwb, Cfc)
               - temperate climate with dry winters (Cwb, Cwc)
               - Maritime Subarctic climates or Subpolar Oceanic climates (Cfc)
   */
   // "",
   
   
///// GROUP D: Continental/microthermal climate
/////          (Dsa-Dsd, Dwa-Dwd, Dfa-Dfd)
   /*
      class: - Hot Summer Continental climates (Dfa, Dwa, Dsa)
             - Continental Subarctic or Boreal (taiga) climates (Dfc, Dwc, Dsc)
             - Continental Subarctic climates with extremely severe winters (Dfd, Dwd)
   */
   // "",
   
   /*
      model: prague
      class: Warm Summer Continental or Hemiboreal climates (Dfb, Dwb, Dsb)
   */
   "prague",
   
   /*
      model: oulu
      class: Continental Subarctic or Boreal (taiga) climates (Dfc, Dwc, Dsc)
   */
   "oulu",
   
   
///// GROUP E: Polar climates
/////          (ET, EF)
   /*
      class: - Tundra climate (ET)
             - Ice Cap climate (EF)
   */
   // "",
   
   
///// GROUP H: Alpine climates
/////          (The Alpine climates are considered to be part of group E)
   /*
      class: Alpine Climate 
   */
   // "",
   
   
/////
   // last useless entry without coma, so we can screw around
   // up there ^^
   "my-only-friend-the-end"
];

// remove "my-only-friend-the-end"; just in case...
_models resize ((count _models) - 1);



// (default selection or invalid season model)
if (!(_model in _models)) then
{
   // select default/appropriate model
   switch (toLower worldName) do
   {
      // A2 worlds
      case "chernarus": { _model = "prague"; };
      case "utes":      { _model = "prague"; };
      
      // OA
      case "takistan": { _model = "bamiyan"; }; 
      case "zargabad": { _model = "kandahar"; };
      case "desert_e": { _model = "kandahar"; };
      
      // DLC
      case "shapur_baf":          { _model = "bamiyan"; };
      case "provinggrounds_pmc":  { _model = "bamiyan"; };
      
      // Community made addons
      case "lingor":    { _model = "arauca"; };
      case "isladuala": { _model = "kano"; };
      case "tropica":   { _model = "kano"; };
      case "thirsk":    { _model = "oulu"; };
      case "thirskw":   { _model = "oulu"; };
      case "namalsk":   { _model = "prague"; };
      case "sbrodj":    { _model = "prague"; };
      case "fallujah":  { _model = "kandahar"; };
      
      // failsafe; default for any other world...
      default
      {
         _model = "prague";
      };
   };
};





// load select season model
//diag_log format["loading RUBE\modules\weather\season-models\%1.sqf (%2)", _model, _this];
_data = [] call (compile preprocessFileLineNumbers format["modules\common\RUBE\modules\weather\season-models\%1.sqf", _model]);

if ((typeName _data) != "ARRAY") then
{
   diag_log format["RUBE_weatherGenerator, ERROR: couldn't load season model: %1", _model];
   _model = "invalid";
};

// calibrate temperatures and windspeed in respect to the worlds
// "elevation offset"

// NOTE: hmmm, looks like this is actually not really needed.
// We can't use "elevationOffset", since that's an "imaginary" number;
// but we need the actual minimum (or maybe average) height above sea-level 
// - ingame. And I've checked that: worlds such as Chernarus or Utes don't
// need any corrections at all, since we have a sea there. 
//    And worlds like Takistan, Zagrabad, Shapur et. al. would need a correction
// of ~50meters at max - some only like 5 meters, so that doesn't matter.
/*
if (_elevationOffset > 0) then
{
   // calibrate temperatures
   [
      (_data select 0),
      {
         [
            ([(_this select 0), _elevationOffset] call RUBE_weatherCalibrateTemperature),
            (_this select 1),
            (_this select 2)
         ]
      }
   ] call RUBE_arrayMap;
   
   // calibrate wind speeds
   [
      (_data select 3), 
      {
         [
            ([(_this select 0), _elevationOffset] call RUBE_weatherCalibrateWindSpeed)
         ]
      }
   ] call RUBE_arrayMap;
};
*/


// return
[_model, _data]