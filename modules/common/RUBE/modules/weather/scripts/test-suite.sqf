/*
   RUBE weather generator
   statistical test suite
   --
   
   This test suite is intended to assist while messing around with the weather 
   generator algorithm. But it might aswell come in handy to test new season
   models - who knows how the weather generator might screw up and fail you?!
   
   Output goes to the arma2oa.rpt file.
   
   --
      
   I suggest to do something along these lines:
   
      1) Pick a month and make some experiments with a sample-size of 30 days.
         
         This way you study "complete" months. The results may vary quite
         a bit, depending on how many lows/highs you'll get and stuff...
         
            -> Study the detailed report.
         
            -> Repeat this process for at least the most different months
         (and at least one "average" one too).
         
      2) Pick a month and make a single experiment (testMonths consists of 
         a single month) with a very large sample-size/amount of days.
         
         This time we're looking for "outliers".
            
            -> Study the detailed report.
            
            -> Repeat...
            
      3) Pick a month and make experiments for a year or two (testMonths consists
         of 12-24 numbers representing the same month) with a sample-size of 30 days,
         to simulate one or two full years. Better disable the detailed report now.
         
         This time we're looking at the "grande" picture, which is why we calculate 
         error's/differences from the expected values now - which wouldn't make too
         much sense while studying a single month or so: they shall be quite unique
         and they will be with only 30 days a month. But if we're looking at the 
         summed results from data of one or two years, we should really be somewhere
         near those expectations/season definitions - otherwise our generator isn't
         up to the task yet...
         
            -> Study the summary.
            
            -> Repeat...
  
     4) And since we know calculate the correletion between expectation and measurment
        averages in the summary IF we test different months, a good idea would be to
        emulate a year or two with ALL THE MONTHS. Assuming the expectations differ 
        throughout the year, we should now see significant(!) correlation (small p's 
        are great!). 
        We don't aim for a perfect correlation though; weather is complex and full of 
        surprises. And some expectations are crude approximations or they come straight 
        out of my ass. So much for the science! hehe 
        
        But generally this is a great tool. Just keep in mind what linear correlation
        is about - and what it's not.
*/

enableLoadingScreen = true;

enableDetailedReport = true; 
enableSummary = true;

// comment out the test's, you don't need
testActiveTests = 
[
   "temperature",
   "pressure",
   "precipitation",
   "overcast",
   "fog",
   "wind",
   ""
];

testSeasonModel = "prague"; // season model
//testSeasonModel = "kandahar"; // season model
//testSeasonModel = "bamiyan"; // season model

testMonths = [6]; // can test a month from 1-12 any number of times, as you like
testNumberOfDaysPerMonth = 120; // can be overflown/as high as you like, 
                               // days will still be "from this month".
testDayIncrementor = 1; // some season values are interpolated over 3 months, 
                        // so with few daysPerMonth you may like to increase this number

/*
   1) set testNumberOfDaysPerMonth to 30
   2) make n experiments with the same month
   3) and study the summary
   
   -> Be carefull while studying the summary with mixed months
   -> Also, not everything is really an "error". Some months may
      indeed need more Lows (pressure) than Highs to meet the
      given precipitation averages, other might need more Highs'n'Dry's...
*/
/*
testMonths = [];
for "_i" from 1 to 12 do
{
   testMonths set [(count testMonths), 10];
};
/**/
/*
testMonths = [];
for "_i" from 1 to 12 do
{
   testMonths set [(count testMonths), _i];
   testMonths set [(count testMonths), _i];
};
/**/

testDaySelector = 1; // forecast index: 1=today, (forecastDays+1)=last-forecast-day
testDate = [2012, 1, 1, 12, 0];

generatorDaysOfForecast = 6; // min=1   [6]
histogramSize = 15;








if (enableLoadingScreen) then
{
   StartLoadingScreen["crunching numbers..."];
   progressLoadingScreen 0.0;
};


resultsMask = [
   [], // 0: temp. min
   [], // 1: temp. range
   [], // 2: prec. days
   [], // 3: prec. intensity
   [], // 4: overcast intensity
   [], // 5: fog days
   [], // 6: fog intensity
   [], // 7: fog d1
   [], // 8: fog d2
   [], // 9: fog d3
   [], // 10: wind speed
   [], // 11: wind direction
   [], // 12: pressure local
   [], // 13: pressure coeff. I
   [], // 14: temp. max
   [], // 15: pressure environment
   [], // 16: pressure coeff. II
   [], // 17: humidity coeff.
   [], // 18: pressure configuration/system type
   [], // 19: pressure coeff. I ABS
   []  // 20: pressure coeff. II ABS
];
results = [];


// cycle-index, component-index, value => void
_addTestResult = {
   private ["_cycle", "_component", "_value"];
   
   _cycle = _this select 0;
   _component = _this select 1;
   _value = _this select 2;
   
   ((results select _cycle) select _component) set [
      (count ((results select _cycle) select _component)),
      _value
   ];
};



// make sure the RUBE function library is loaded
if (isnil "RUBE_fnc_init") then
{
   [] call (compile preprocessFileLineNumbers "modules\common\RUBE\init.sqf");
};
waitUntil{!(isnil "RUBE_fnc_init")};


/*
   init weather module
*/

[] execVM "modules\common\RUBE\modules\weather\init.sqf";
waitUntil{!(isnil "RUBE_weather")};

// select season model
testSeasonModel call (RUBE_weather getVariable "set-season-model");
RUBE_weather setVariable ["forecast-days", generatorDaysOfForecast, true];



/*
RUBE_weather setVariable ["date", testDate, true];
[] call (RUBE_weather getVariable "generate-weather");
[] call (RUBE_weather getVariable "generate-next-day");
_j = 0;
{
   diag_log format["forecast [%1]:", _j];
   _j = _j + 1;
   for "_i" from 0 to ((count _x) - 1) do
   {
      diag_log format[" - [%1]: %2", _i, (_x select _i)];
   };
   diag_log "";
} forEach (RUBE_weather getVariable "forecast");

if (true) exitWith {};
*/


/*
   generate weather
*/
testCycles = (count testMonths);

for "_i" from 0 to (testCycles - 1) do
{
   _month = (testMonths select _i) - 1;
   testDate set [1, _month];
   testDate set [2, 1];
   
   results set [_i, (+resultsMask)];
   
   RUBE_weather setVariable ["date", testDate, true];
   [] call (RUBE_weather getVariable "generate-weather");
   
   for "_j" from 1 to testNumberOfDaysPerMonth do
   {
      if (_j > 1) then
      {
         testDate set [2, (((testDate select 2) + testDayIncrementor)%31)];
         RUBE_weather setVariable ["date", testDate, true];
      };
            
      hintSilent format[
         "generating weather samples (month: %1):\nprogress: %2/%3", 
         _month, 
         ((_i * testNumberOfDaysPerMonth) + _j), 
         (testNumberOfDaysPerMonth * testCycles)
      ];
      
      if (enableLoadingScreen) then
      {
         progressLoadingScreen (((_i * testNumberOfDaysPerMonth) + _j) / (testNumberOfDaysPerMonth * testCycles));
      };
      
      // save weather
      _season = (RUBE_weather getVariable "season");
      _day = (RUBE_weather getVariable "forecast") select testDaySelector;
      
      
      // stuff we're going to calculate no matter what:
      //
      
      
      // humidity coeff
      [
         _i, 
         17, 
         (
            (((_season select 1) select _month) select 0)^0.71 *
            (((_season select 1) select _month) select 1)^1.24
         )^0.5
      ] call _addTestResult; 
      
      
      // stuff by components
      //   calculate everything anyway (we might need that stuff for correlations...)
      
      //if ("temperature" in testActiveTests) then
      //{
         [_i, 0, ((_day select 0) select 0)] call _addTestResult; // temp. min
         [_i, 1, ((_day select 0) select 1)] call _addTestResult; // temp. range
         [_i, 14, 
            (((_day select 0) select 0) + ((_day select 0) select 1))
         ] call _addTestResult; // temp. max
      //};
      
      //if ("pressure" in testActiveTests) then
      //{
         _PcoeffI  = ((_day select 5) select 0) call RUBE_atmosphericPressureCoeff;
         _PcoeffII = [
            ((_day select 5) select 0),
            ((_day select 5) select 1)
         ] call RUBE_atmosphericPressureCoeffII;
      
         [_i, 12, ((_day select 5) select 0)] call _addTestResult; // pressure
         [_i, 13, _PcoeffI] call _addTestResult; // pressure coeff. I
         
         [_i, 15, ((_day select 5) select 1)] call _addTestResult; // pressure
         [_i, 16, _PcoeffII] call _addTestResult; // pressure coeff. II
         
         // config/system type: 18
         _Psystem = [_PcoeffI, _PcoeffII] call RUBE_atmosphericPressureSystem;

         [_i, 18, _Psystem] call _addTestResult;
         
         [_i, 19, (abs _PcoeffI)] call _addTestResult;
         [_i, 20, (abs _PcoeffII)] call _addTestResult;
         
      //};
      
      //if ("precipitation" in testActiveTests) then
      //{
         _isPrecDay = 0;
         if (((_day select 1) select 0) > 0.001) then { _isPrecDay = 1; };
         
         [_i, 2, _isPrecDay] call _addTestResult; // is prec. day
         [_i, 3, ((_day select 1) select 0)] call _addTestResult; // prec. intensity
         
      //};
      
      //if ("overcast" in testActiveTests) then
      //{
         [_i, 4, ((_day select 2) select 0)] call _addTestResult; // overcast intensity
      //};
      
      //if ("fog" in testActiveTests) then
      //{
         _isFogDay = 0; // intensity and max duration need to average above some threshold to count as fog-event
         //_fogA = (((_day select 3) select 1) max ((_day select 3) select 2)) max ((_day select 3) select 3);
         _fogA = ((_day select 3) select 1) max ((_day select 3) select 3);
         _fogB = (_day select 3) select 2;
         
         _fogI = (_day select 3) select 0;
         if ((_fogI > 0.4) && ((_fogA > 0.75) || (_fogB > 0.6))) then { _isFogDay = 1; };
         if (_fogI > 0.55) then { _isFogDay = 1; };
         
         [_i, 5, _isFogDay] call _addTestResult; // is fog day
         [_i, 6, ((_day select 3) select 0)] call _addTestResult; // fog intensity
         [_i, 7, ((_day select 3) select 1)] call _addTestResult; // fog duration 1
         [_i, 8, ((_day select 3) select 2)] call _addTestResult; // fog duration 2
         [_i, 9, ((_day select 3) select 3)] call _addTestResult; // fog duration 3
      //};
      
      //if ("wind" in testActiveTests) then
      //{
         [_i, 10, ((_day select 4) select 0)*3.6] call _addTestResult; // wind speed in km/h
         [_i, 11, ((_day select 4) select 1)] call _addTestResult; // wind direction
      //};
      
      // generate next day
      [] call (RUBE_weather getVariable "generate-next-day");
   };
};

hint format["analysing..."];

statsLabels = [
   ["avg", "median", "mode"],
   ["min", "max", "range", "variance", "st. dev.", "skewness", "kurtosis"]
];

_printStats = {
   for "_i" from 0 to ((count _this) - 1) do
   {
      for "_j" from 0 to ((count (_this select _i)) - 1) do
      {
         diag_log format[
            " - %1: %2", 
            ((statsLabels select _i) select _j),
            ((_this select _i) select _j)
         ];
      };
      diag_log "";
   };
};

_sum = {
   private ["_s"];
   _s = 0;
   {
      _s = _s + _x;
   } forEach _this;
   
   _s
};


// array of strings => void
_printPreamble = {
   if (!enableDetailedReport) exitwith {};
   
   diag_log "";
   
   {
      diag_log _x
   } forEach _this;
   
   diag_log "";
};


// [labelX, setX, labelY, setY]
_printCorrelation = {
   private ["_p"];
   
   // since we don't do anything else with the result, other
   // than printing it right now, we may not caluculate it aswell...
   if (!enableDetailedReport) exitWith {};
   
   _p = [(_this select 1), (_this select 3)] call RUBE_pearsonCorrelation;
   
   //if (enableDetailedReport) then
   //{
      diag_log format[
         " - Corr(%1, %2) = %3    [p: %4]",
         (_this select 0), 
         (_this select 2),
         (_p select 0), 
         (_p select 1)
      ];
   //};

   _p
};


diag_log "##############################";
diag_log " WEATHER GENERATOR STATISTICS ";
diag_log "------------------------------";
diag_log "";
diag_log format[" - world: %1", worldName]; 
diag_log format[" - season model: %1", (RUBE_weather getVariable "season-model")]; 
diag_log format[" - test year: %1", (testDate select 0)];
diag_log format[" - test months: %1", testMonths];
diag_log format[" - generated days per month: %1", testNumberOfDaysPerMonth];
diag_log format[" - days of forecast: %1", generatorDaysOfForecast];
diag_log format[" - test day selector: %1", testDaySelector];
diag_log format[" - day generation incrementor: %1", testDayIncrementor];
diag_log "";

_printResult = {
   private ["_data", "_histogram", "_expectedAvg", "_expectedSD", "_extra", 
            "_filterZeroValues", "_stats", "_hOptions"];
   _data = _this select 0;
   _histogram = true;
   _expectedAvg = false;
   _expectedSD = false;
   _extra = false;
   _filterZeroValues = false;
   
   if ((count _this) > 1) then { _histogram = _this select 1; };
   if ((count _this) > 2) then { _expectedAvg = _this select 2; };
   if ((count _this) > 3) then { _expectedSD = _this select 3; };
   if ((count _this) > 4) then { _extra = _this select 4; };
   if ((count _this) > 5) then { _filterZeroValues = _this select 5; };
   
   if (enableDetailedReport) then
   {
      if ((typeName _expectedAvg) != "BOOL") then
      {
         diag_log format[" - expected avg.: %1", _expectedAvg];
      };
      
      if ((typeName _expectedSD) != "BOOL") then
      {
         diag_log format[" - expected st. dev.: %1", _expectedSD];
      };
      
      if ((typeName _extra) == "ARRAY") then
      {
         {
            diag_log _x;
         } forEach _extra;
      };
   
      diag_log "";
   };
   
   _hOptions = [
      ["samples", _data],
      ["size", histogramSize]
   ];
   
   if ((typeName _histogram) == "ARRAY") then
   {
      {
         _hOptions set [(count _hOptions), _x];
      } forEach _histogram;
      _histogram = true;
   };
   
   if (_histogram && enableDetailedReport) then
   {
      _hOptions call RUBE_histogram;
   };
   
   if (_filterZeroValues) then
   {      
      _data = [
         _data, 
         {
            if (_this == 0) exitWith { false };
            true
         }
      ] call RUBE_arrayFilter;
   };
   
   _stats = [
      _data,
      [_expectedAvg, _expectedSD]
   ] call RUBE_descriptiveStatistics;
   
   if (enableDetailedReport) then
   {
      _stats call _printStats;
      diag_log "";
   };

   _stats
};




summary = [
  /*  0 */ ["Tmin"], 
  /*  1 */ ["Trange"], 
  /*  2 */ ["Tmax"],
  /*  3 */ ["Pressure (local)"],
  /*  4 */ ["Pressure Coeff.I (local vs. mean)"],
  /*  5 */ ["Pressure (environment)"],
  /*  6 */ ["Pressure Coeff II. (local vs. environment)"],
  /*  7 */ ["Precipitation (probability)"],
  /*  8 */ ["Precipitation (intensity)"],
  /*  9 */ ["Overcast"],
  /* 10 */ ["Wind (speed)"],
  /* 11 */ ["Wind (direction)"],
  /* 12 */ ["Fog (events/days with noteworthy fog)"],
  /* 13 */ ["Fog (intensity)"],
  /* 14 */ ["Fog (duration 1; sunrise)"],
  /* 15 */ ["Fog (duration 2; day)"],
  /* 16 */ ["Fog (duration 3: sunset"]
];

summaryMonths = [];

if (enableSummary) then
{
   {
      _x set [1, []];
      _x set [2, []];
      _x set [3, []];
   } forEach summary;
};

// [index, expected, measured] => void
_collectForSummary = {
   private ["_index", "_expected", "_measured", "_n"];
   
   if (!enableSummary) exitWith {};
      
   _index = _this select 0;
   _expected = _this select 1;
   _measured = _this select 2;
   
   _n = count ((summary select _index) select 1);
   
   ((summary select _index) select 1) set [_n, _expected];
   ((summary select _index) select 2) set [_n, _measured];
   ((summary select _index) select 3) set [_n, (_measured - _expected)];
};

_season = (RUBE_weather getVariable "season");

for "_i" from 0 to (testCycles - 1) do
{
   _month = (testMonths select _i) - 1;
   _data = results select _i;

   if (enableSummary) then
   {
      summaryMonths set [(count summaryMonths), _month];
   };

   [
      "------------------------------",
      format[" CYCLE %1, month: %2", _i, (_month + 1)],
      "------------------------------"
   ] call _printPreamble;

   _TmaxStats = [];
   _TmaxExpected = 0;
   _PlocalStats = [];
   _PcorrIStats = [];
   _PcorrIIStats = [];

   if ("temperature" in testActiveTests) then
   {
   
      [
         "# Temperature",
         "# Tmin"
      ] call _printPreamble;
   
      _expected = (((_season select 0) select _month) select 0);
      _TminStats = [
         (_data select 0), // results
         true, // histrogram
         _expected, // expected average
         (((_season select 0) select _month) select 1)  // expected st. dev.
      ] call _printResult;
      
      [0, _expected, ((_TminStats select 0) select 0)] call _collectForSummary;
      
      [
         "# Temperature",
         "# Trange"
      ] call _printPreamble;
      
      _expected = (((_season select 0) select _month) select 2);
      _TrangeStats = [
         (_data select 1), // results
         true, // histrogram
         _expected, // expected average
         false  // expected st. dev.
      ] call _printResult;
      
      [1, _expected, ((_TrangeStats select 0) select 0)] call _collectForSummary;
      
       
      [
         "# Temperature",
         "# Tmax"
      ] call _printPreamble;

      _expected = (((_season select 0) select _month) select 0) + (((_season select 0) select _month) select 2);
      _TmaxStats = [
         (_data select 14), // results
         true, // histrogram
         _expected, // expected average
         false  // expected st. dev.
      ] call _printResult;
      
      [2, _expected, ((_TmaxStats select 0) select 0)] call _collectForSummary;

   };
   
   _PlocalStats = [];
   _PenvStats = [];
   _PcorrIStats = [];
   _PcorrIIStats = [];
   
   if ("pressure" in testActiveTests) then
   {     
      [
         "# Pressure",
         "# Local Pressure"
      ] call _printPreamble;
      
      _expected = (RUBE_weather getVariable "pressure-mean");
      _PlocalStats = [
         (_data select 12), // results
         true, // histrogram
         _expected, // expected average
         (RUBE_weather getVariable "pressure-sd"),  // expected st. dev.
         [
            " ~ influenced by the days temperature"
         ]// extra
      ] call _printResult;
      
      [3, _expected, ((_PlocalStats select 0) select 0)] call _collectForSummary;
      

      [
         "# Pressure",
         "# Pressure Coefficient I: local vs. mean"
      ] call _printPreamble;
      
      _expected = 0;
      _PcorrIStats = [
         (_data select 13), // results
         true, // histrogram
         _expected, // expected average
         0.25  // expected st. dev.
      ] call _printResult;

      [4, _expected, ((_PcorrIStats select 0) select 0)] call _collectForSummary;

      _PcorrIIextra = [
         format[
            " ~ humidity: %1 (high hum. => biased low Ploc/high Penv. => neg. PcorrII)",
            ([(_data select 17)] call RUBE_average) 
         ]
      ];
      
      [
         "# Pressure",
         "# Environmental Pressure"
      ] call _printPreamble;
      
      _expected = (RUBE_weather getVariable "pressure-mean");
      _PenvStats = [
         (_data select 15), // results
         true, // histrogram
         _expected, // expected average
         (RUBE_weather getVariable "pressure-sd"),  // expected st. dev.
         _PcorrIIextra // extra
      ] call _printResult;
      
      [5, _expected, ((_PenvStats select 0) select 0)] call _collectForSummary;
      
      
      [
         "# Pressure",
         "# Pressure Coefficient II: local vs. environment"
      ] call _printPreamble;
      
      _expected = 0;
      _PcorrIIStats = [
         (_data select 16), // results
         true, // histrogram
         _expected, // expected average
         0.25  // expected st. dev.
      ] call _printResult;
      
      [6, _expected, ((_PcorrIIStats select 0) select 0)] call _collectForSummary;
      
      //
      [
         "# Pressure",
         "# Pressure Correlations"
      ] call _printPreamble;
      
      [
         "PaLocal", (_data select 12), 
         "PaEnv", (_data select 15)
      ] call _printCorrelation;
      
      [
         "PaLocal", (_data select 12), 
         "Tmax", (_data select 14)
      ] call _printCorrelation;
      
      [
         "PcoeffI", (_data select 13), 
         "Tmax", (_data select 14)
      ] call _printCorrelation;
      
      
      [
         "PaEnv", (_data select 15), 
         "prec.Days", (_data select 2)
      ] call _printCorrelation;
      
      [
         "PaEnv", (_data select 15), 
         "prec.Intensity", (_data select 3)
      ] call _printCorrelation;

      [
         "PaEnv", (_data select 15), 
         "HumidityCoeff", (_data select 17)
      ] call _printCorrelation;
      
      [
         "PcoeffII", (_data select 16), 
         "HumidityCoeff", (_data select 17)
      ] call _printCorrelation;
      
      [
         "PcoeffI", (_data select 13), 
         "PcoeffII", (_data select 16)
      ] call _printCorrelation;

            
      [
         "# Pressure",
         "# Pressure Configuration/System"
      ] call _printPreamble;
      
      _PcorrIIStats = [
         (_data select 18), // results
         [
            ["min", 0],
            ["max", 9],
            ["interval", 1]
         ], // histrogram
         4, // expected average
         1  // expected st. dev.
      ] call _printResult;
   };
      
      
      
   if ("precipitation" in testActiveTests) then
   {
      _precSum = (_data select 2) call _sum;
      _expected = (((_season select 1) select _month) select 0);
      _actual = (_precSum/testNumberOfDaysPerMonth);
      _precInfo = [
         (format[
            " - expected probability, P(intensity > 0): %1", 
            _expected // expected probability
         ]),
         (format[
            " - actual probability, P(intensity > 0): %1/%2 = %3", 
            _precSum, // number of rainy days
            testNumberOfDaysPerMonth, // days per cycle/month
            _actual // actual probability
         ])
      ];
      
      [7, _expected, _actual] call _collectForSummary;

      [
         "# Precipitation",
         "# PIntensity (stats. without null-values)"
      ] call _printPreamble;
      
      _expectedPREC = (((_season select 1) select _month) select 1);
      _PrecIntensityStats = [
         (_data select 3), // results
         true, // histrogram
         _expectedPREC, // expected average
         false,  // expected st. dev.
         _precInfo, // extra
         true // filter zero values from stats
      ] call _printResult;
      
      [8, _expectedPREC, ((_PrecIntensityStats select 0) select 0)] call _collectForSummary;
      
      //
      [
         "# Precipitation",
         "# Precipitation Correlations"
      ] call _printPreamble;
                
      [
         "Prec.Intensity", (_data select 3), 
         "Plocal", (_data select 12)
      ] call _printCorrelation;
      
      [
         "Prec.Intensity", (_data select 3), 
         "PcoeffI", (_data select 13)
      ] call _printCorrelation;
      
      [
         "Prec.Intensity", (_data select 3), 
         "Penvironment", (_data select 15)
      ] call _printCorrelation;
      
      [
         "Prec.Intensity", (_data select 3), 
         "PcoeffII", (_data select 16)
      ] call _printCorrelation;
   };
   
   
   
   if ("overcast" in testActiveTests) then
   {
      _humidityInfo = [
         " ~ expectation based on pressure coeff.II",
         (format[
            " ~ correlation with `humidity`:"
         ]),
         (format[
            "   ~ prec. probability: %1",
            (((_season select 1) select _month) select 0)
         ]),
         (format[
            "   ~ prec. avg. intensity: %1",
            (((_season select 1) select _month) select 1)
         ])
      ];
   
      [
         "# Overcast",
         "# "
      ] call _printPreamble;
      
      _expectedOC = 0.5 - (0.5 * ([(_data select 16)] call RUBE_average)); // pressure coeff II
      
      _overcastStats = [
         (_data select 4), // results
         true, // histrogram
         _expectedOC, // expected average
         0.125,  // expected st. dev.
         _humidityInfo
      ] call _printResult;

      [9, _expectedOC, ((_overcastStats select 0) select 0)] call _collectForSummary;
      
      //
      [
         "# Overcast",
         "# Overcast Correlations"
      ] call _printPreamble;
    
      [
         "Overcast", (_data select 4), 
         "Prec.Intensity", (_data select 3)
      ] call _printCorrelation;
      
      [
         "Overcast", (_data select 4), 
         "Trange", (_data select 1)
      ] call _printCorrelation;
      
      [
         "Overcast", (_data select 4), 
         "Plocal", (_data select 12)
      ] call _printCorrelation;
      
      [
         "Overcast", (_data select 4), 
         "PcoeffI", (_data select 13)
      ] call _printCorrelation;
      
      [
         "Overcast", (_data select 4), 
         "Penvironment", (_data select 15)
      ] call _printCorrelation;
      
      [
         "Overcast", (_data select 4), 
         "PcoeffII", (_data select 16)
      ] call _printCorrelation;
   };
   
   
   
   
   if ("wind" in testActiveTests) then
   {
      [
         "# Wind",
         "# Wind Speed, in km/h"
      ] call _printPreamble;
      
      _expectedWS = (((_season select 3) select _month) select 0) * 3.6;
      _windSpeedStats = [
         (_data select 10), // results
         true, // histrogram
         _expectedWS, // expected average
         false  // expected st. dev.
      ] call _printResult;
      
      [10, _expectedWS, ((_windSpeedStats select 0) select 0)] call _collectForSummary;
      
      [
         "# Wind",
         "# Wind Direction"
      ] call _printPreamble;
      _expectedWD = 180; // whatever
      _windDirStats = [
         (_data select 11), // results
         true, // histrogram
         false, // expected average
         false  // expected st. dev.
      ] call _printResult;
      
      [11, _expectedWD, ((_windDirStats select 0) select 0)] call _collectForSummary;
      
      //
      [
         "# Wind",
         "# Wind Speed Correlations"
      ] call _printPreamble;
      
      [
         "Wind Speed", (_data select 10), 
         "Prec.Intensity", (_data select 3)
      ] call _printCorrelation;
      
      [
         "Wind Speed", (_data select 10), 
         "Humidity.Coeff", (_data select 17)
      ] call _printCorrelation;
               
      [
         "Wind Speed", (_data select 10), 
         "Plocal", (_data select 12)
      ] call _printCorrelation;
      
      [
         "Wind Speed", (_data select 10), 
         "Pcoeff.I", (_data select 13)
      ] call _printCorrelation;
      
      [
         "Wind Speed", (_data select 10), 
         "Pcoeff.I (ABS)", (_data select 19)
      ] call _printCorrelation;
      
      [
         "Wind Speed", (_data select 10), 
         "Penvironment", (_data select 15)
      ] call _printCorrelation;
      
      [
         "Wind Speed", (_data select 10), 
         "Pcoeff.II", (_data select 16)
      ] call _printCorrelation;     
      
      [
         "Wind Speed", (_data select 10), 
         "Pcoeff.II (ABS)", (_data select 20)
      ] call _printCorrelation;  
   };
   
   
   
   
   if ("fog" in testActiveTests) then
   {
      _fogSum = (_data select 5) call _sum;
      
      _expectedFogDays = (((_season select 2) select _month) select 0);
      _actualFogDays = (_fogSum/testNumberOfDaysPerMonth);
      
      _fogInfo = [
         (format[
            " - expected probability: %1", 
            _expectedFogDays // expected probability
         ]),
         (format[
            " ~ actual probability: %1/%2 = %3", 
            _fogSum, // number of fogy days
            testNumberOfDaysPerMonth, // days per cycle/month
            _actualFogDays // actual probability
         ]),
         (format[
            " ~ actual probability is a rough estimate, intensity correlates with `humidity`:"
         ]),
         (format[
            "   ~ prec. probability: %1",
            (((_season select 1) select _month) select 0)
         ]),
         (format[
            "   ~ prec. avg. intensity: %1",
            (((_season select 1) select _month) select 1)
         ])
      ];
      
      [12, _expectedFogDays, _actualFogDays] call _collectForSummary;
      
      [
         "# Fog",
         "# Intensity"
      ] call _printPreamble;
      
      _expectedFI = (0.3 + _expectedFogDays) * 0.5; // whatever
      
      _fogIntStats = [
         (_data select 6), // results
         true, // histrogram
         _expectedFI, // expected average
         false,  // expected st. dev.
         _fogInfo // extra
      ] call _printResult;
      
      [13, _expectedFI, ((_fogIntStats select 0) select 0)] call _collectForSummary;
      
      [
         "# Fog",
         "# Duration 1 (sunrise)"
      ] call _printPreamble;
      
      _expectedD1 = (0.5 + _expectedFogDays) * 0.5; // whatever
      
      _fogD1Stats = [
         (_data select 7), // results
         true, // histrogram
         false, // expected average
         false  // expected st. dev.
      ] call _printResult;
      
      [14, _expectedD1, ((_fogD1Stats select 0) select 0)] call _collectForSummary;

      [
         "# Fog",
         "# Duration 2 (day/midday/afternoon)"
      ] call _printPreamble;
      
      _expectedD2 = (0.25 + (_expectedFogDays * 0.5)) * 0.5; // whatever
      
      _fogD2Stats = [
         (_data select 8), // results
         true, // histrogram
         false, // expected average
         false  // expected st. dev.
      ] call _printResult;
      
      [15, _expectedD2, ((_fogD2Stats select 0) select 0)] call _collectForSummary;
      
      [
         "# Fog",
         "# Duration 3 (sunset)"
      ] call _printPreamble;
      
      _expectedD3 = (0.5 + _expectedFogDays) * 0.5; // whatever
      
      _fogD3Stats = [
         (_data select 9), // results
         true, // histrogram
         false, // expected average
         false  // expected st. dev.
      ] call _printResult;
      
      [16, _expectedD3, ((_fogD3Stats select 0) select 0)] call _collectForSummary;
      
      //
      [
         "# Fog",
         "# Fog correlations"
      ] call _printPreamble;
      
      [
         "Fog intensity", (_data select 6), 
         "Trange", (_data select 1)
      ] call _printCorrelation;
      
      [
         "Fog intensity", (_data select 6), 
         "Tmax", (_data select 14)
      ] call _printCorrelation;
      
      [
         "Fog intensity", (_data select 6), 
         "Prec.Intensity", (_data select 3)
      ] call _printCorrelation;
      
      [
         "Fog intensity", (_data select 6), 
         "Wind Speed", (_data select 10)
      ] call _printCorrelation;
      
      [
         "Fog intensity", (_data select 6), 
         "PaLocal", (_data select 12)
      ] call _printCorrelation;
      
      [
         "Fog intensity", (_data select 6), 
         "PaCoeff.I", (_data select 13)
      ] call _printCorrelation;
      
      [
         "Fog intensity", (_data select 6), 
         "PaCoeff.I (ABS)", (_data select 19)
      ] call _printCorrelation;
      
      [
         "Fog intensity", (_data select 6), 
         "PaEnv", (_data select 15)
      ] call _printCorrelation;
      
      [
         "Fog intensity", (_data select 6), 
         "PaCoeff.II", (_data select 16)
      ] call _printCorrelation;
      
      [
         "Fog intensity", (_data select 6), 
         "PaCoeff.II (ABS)", (_data select 20)
      ] call _printCorrelation;
      
      ["-"] call _printPreamble;
      
      [
         "Fog duration1", (_data select 7), 
         "Trange", (_data select 1)
      ] call _printCorrelation;
      
      [
         "Fog duration3", (_data select 9), 
         "Trange", (_data select 1)
      ] call _printCorrelation;
      
      [
         "Fog duration2", (_data select 8), 
         "PaEnv", (_data select 15)
      ] call _printCorrelation;
      
      [
         "Fog duration2", (_data select 8), 
         "PaCoeff.II", (_data select 16)
      ] call _printCorrelation;
   };
   
   
   
   

   
};

summaryPadSize = 20;
summaryPadSizeSmall = 5;
summaryPadSizeFull = summaryPadSizeSmall + (3 * summaryPadSize) + 9;

summaryDifferentMonths = false;

_n = count summaryMonths;

if (_n > 0) then
{
   _m = summaryMonths select 0;
   for "_i" from 1 to (_n - 1) do
   {
      if ((summaryMonths select _i) != _m) exitWith 
      {
         summaryDifferentMonths = true;
      };
      _m = summaryMonths select _i;
   };
};


_printSummary = {
   private ["_index", "_data", "_n", "_i", "_p"];
   
   _index = _this select 0;
   _data = summary select _index;
   _n = count (_data select 1);
   
   diag_log "";
   diag_log format["   %1 (summary):", _data select 0];
   diag_log format["   %1", (["", summaryPadSizeFull, "-", false] call RUBE_pad)];
   
   diag_log format[
      "   %1 | %2 | %3 | %4 ",
      (["month", summaryPadSizeSmall, " ", false] call RUBE_pad),
      (["expected avg.", summaryPadSize, " ", false] call RUBE_pad),
      (["measured avg.", summaryPadSize, " ", false] call RUBE_pad),
      (["error avg.", summaryPadSize, " ", false] call RUBE_pad)
   ];
   
   diag_log format["   %1", (["", summaryPadSizeFull, "-", false] call RUBE_pad)];
   
   for "_i" from 0 to (_n - 1) do
   {
      diag_log format[
         "   %1 | %2 | %3 | %4 ",
         ([(summaryMonths select _i), summaryPadSizeSmall, " ", false] call RUBE_pad),
         ([((_data select 1) select _i), summaryPadSize, " ", false] call RUBE_pad),
         ([((_data select 2) select _i), summaryPadSize, " ", false] call RUBE_pad),
         ([((_data select 3) select _i), summaryPadSize, " ", false] call RUBE_pad)
      ];
   };
   
   diag_log format["   %1", (["", summaryPadSizeFull, "-", false] call RUBE_pad)];
   diag_log format[
      "   %1 | %2 | %3 | %4 ",
      (["", summaryPadSizeSmall, " ", false] call RUBE_pad),
      ([([(_data select 1)] call RUBE_average), summaryPadSize, " ", false] call RUBE_pad),
      ([([(_data select 2)] call RUBE_average), summaryPadSize, " ", false] call RUBE_pad),
      ([([(_data select 3)] call RUBE_average), summaryPadSize, " ", false] call RUBE_pad)
   ];
   diag_log "";
   
   //
   if (summaryDifferentMonths) then
   {
      _p = [(_data select 1), (_data select 2)] call RUBE_pearsonCorrelation;
      
      diag_log format[
         "   %1   Corr(expected, measured) = %2     [p: %3]",
         (["", summaryPadSizeSmall, " ", false] call RUBE_pad),
         (_p select 0),
         (_p select 1)
      ];
      diag_log "";
   };

};




if (enableSummary) then
{
   diag_log "";
   diag_log "------------------------------";
   diag_log " summary ";
   diag_log "------------------------------";

   if ("temperature" in testActiveTests) then
   {
      [0] call _printSummary;
      [1] call _printSummary;
      [2] call _printSummary;
   };
   
   if ("pressure" in testActiveTests) then
   {
      [3] call _printSummary;
      [4] call _printSummary;
      [5] call _printSummary;
      [6] call _printSummary;
   };
   
   if ("precipitation" in testActiveTests) then
   {
      [7] call _printSummary;
      [8] call _printSummary;
   };
   
   if ("overcast" in testActiveTests) then
   {
      [9] call _printSummary;
   };
   
   if ("wind" in testActiveTests) then
   {
      [10] call _printSummary;
      [11] call _printSummary;
   };
   
   if ("fog" in testActiveTests) then
   {
      [12] call _printSummary;
      [13] call _printSummary;
      [14] call _printSummary;
      [15] call _printSummary;
      [16] call _printSummary;
   };
};


diag_log "";
hint format["DONE"];

if (enableLoadingScreen) then
{
   progressLoadingScreen 1.0;
   endLoadingScreen;
};