/*
   Author:
    rübe
    
   Description:
    basic group patrol script featuring points of interests as well 
    as a perimeter/enclosure patrol (by the help of a convex hull of 
    a given set of objects or positions). Both patrol methods may be 
    combined.
    
    The final route destination points are no direct routes, but may be 
    proceduraly split into smaller parts. After such a part is reached,
    the group may do some advanced (and custom!) patrol tasks, such as 
    searching nearby buildings or watching the horizon... 
       Thus, the larger these parts, the lazier the patrol and vice versa 
    smaller parts == more advanced patrol tasks.
    
    
   Illustration: 

                     .______________.
                    /               \
                   /                 \         X
                  /      X            \ 
                 /                X    \
                /                       \
               .                         \
                \                         .
                 \              X        /
                  \                     /
                   \                   /
                    \                 /
                     \               /
                      ._____________.    
                            
                            
        X = point of interest
        . = point on convex hull OR waypoints
        
        
      the task from going from A to B may be split into subtasks of 
      smaller distances to travel. Random detours are created with
      a deviance of some degrees to the (ideal) air-line. Plus there
      is a chance of (custom) advanced patrol tasks after each subtask 
      is completed:
      
      
           (A) ----(air-line)----> (B)      main task/(ideal route): 
             \                      /        from (A) to (B)
              \         p3 ._______.
               \          /        p4       sub tasks/(real route):
                \        /                   from (A) to p1 
                 .______. p2                 from p1 to p2  
                p1                           from p2 to p3 
                                             from p3 to p4
                                             from p4 to (B)  
      
      
   >> Warning/Note << 
   
      regarding custom code which is ment to be spawned: make sure that
      these scripts finish and return, no matter what. For example make 
      sure that they do not get stuck if the group died.  
         Custom code (for advanced duty or pointOfInterest code) gets 
      passed the group as _this. 
      
   >> Some ideas <<
   
      - You probably should disable or exchange the default advanced duty
        scripts if the group is a motorized/mechanized/armored one.
   
      - Have a trigger "detected by" to set the patroling groups waypoint
        behaviour to "DANGER" or "STEALTH", so the fsm knows, that the
        alarm went off. Or find other means by which the groups waypoint
        behaviour gets changed...
   
      - Have a pointOfInterest with ammunition, and pass with it some
        custom code to rearm the groups units if needed. Set patrolCoef
        to ~0.1, so the pointOfInterest is only frequented occasionaly.
        
      - If you have a pointOfInterest with friendly buildings, you might
        want to suppress advanced duty scripts there at all costs.. (cleaning
        friendly tents might look quite stupid). So just pass an empty code
        body along with the pointOfInterest.
        
      - Have two or more waypoints for perimeter patrol across a city,
        pass only a clear-building script for advanced duty, add a 
        pretty high deviance (~45 degree) and a pretty short distance
        (for the subroutes) and finally set dutyCoef to 1.0. Voila, 
        there you have your town cleansing attack squad.  
        
      - Try setting exitOnAlarm to true and have your onAlarm code set
        your groups waypoint-type to HOLD to stop the patrol and help
        defending...    


   Parameter(s):
    _this: parameters (array of array [key (string), value (any)])
    
           - required:
             
             - "group" (group)
           
           // at least one of the following parameters must be given
           // "perimeter" and "waypoints" can not be used at the same 
           // time since they will overwrite each other.
           
             - "pointsOfInterest" (array of positions OR [position, code])
                  Points of interest, that are randomly patrolled.
               If code is given, it will be executed/spawned after
               the point has been reached. The patrol script will
               wait/halt until the code/script is done.
                  The code is given the group as _this.
                  
             - "perimeter" (array of positions OR array of objects)
                  The given positions/objects are used to calculate
               the convex hull which is used as patrol perimeter route.
             
             - "waypoints" (array of positions)
                  The given positions are directly used as patrol
               perimeter route.
             
             
           - optional:
           
             - "patrolCoef" (scalar from 0 to 1)
                   Chance to keep patrolling points of interest vs. perimeter
                patrol.
                - 0.0: no points of interests are patrolled (perimeter patrol only)
                - 1.0: no perimeter points are patrolled (poi patrol only)
                
             - "distance" (scalar)
                  Mid distance the subroutes are split into. The larger this 
               distance, the more direct patrol points are beeing patroled.
               - default = 300
               
             - "deviance" (scalar)
                  Mid angle, the subroutes are beeing calculated off target 
               (deviance from ideal air line direction). The higher this value, the 
               longer the detour from one patrol point to another.
               - default = 5
               
             - "onAlarm" (code)
                  Code to be run on contact or once "alarm" goes off. In this case, 
               "alarm" is detected, if the groups waypoint combat mode got set to 
               "DANGER" or "STEALTH". The idea is to "alarm" the groups from another 
               script, such as a detected by trigger which would set the current 
               waypoint behaviour to "DANGER"..
               
             - "exitOnAlarm" (boolean)
                  If the patrol fsm should be quit, once the alarm went off. Otherwise
               regular patrol duty is resumed as soon as the groups waypoints combat 
               mode isn't set to "DANGER" or "STEALTH" anymore.
               - default = false
             
             - "formation" (string or array of strings)
                  Pool of formations to randomly pick from at the beginning of every
               new subroute.
                - default = "COLUMN"
               
             - "behaviour" (string or array of strings)
                  Pool of behaviours to randomly pick from at the beginning of every
               new subroute.
                - default = ["CARELESS", "SAFE"]
               
             - "speed" (string or array of strings)
                  Pool of speeds to randomly pick from at the beginning of every
               new subroute.
                - default = "LIMITED"
                
             - "combatFormation" (string or array of strings)
                  Pool of formations to randomly pick from on contact/alarm.
               - default = ["WEDGE", "VEE", "LINE"]
               
             - "combatType" (string or array of strings)
                  Pool of waypoint types to randomly pick from on contact/alarm.
               - default = ["HOLD", "GUARD", "SENTRY"]
             
             - "advancedDuty" ([score (code), script (code)] OR arrays thereof)
                  Advanced duties are scripts that are executed (with the probability
               of dutyCoef, randomly picked) after a subroute/route has been completed 
               (or a route point has been reached). Advanced duty is skipped if point 
               of interest code has been executed.
               
               - score (code):  This is a function taking group as _this and returning
                                a value from 0.0 (inappropriate) to 1.0 (most appropriate).
                                The highest score from all registered scripts will be run
                                as advanced duty. For example you may check if any buildings
                                are nearby, or if the current spot is empty or if units are
                                out of ammo or injured... You may aswell just have 
                                { (random 1.0) } as score script...
                                   Btw. it's fine to return negative values too, though no
                                script will be executed with a score smaller or equal to 0.
                                
                                >> make use of the RUBE_AICOEF functions:
                                   - RUBE_AICOEF_inTheOpen
                                   - RUBE_AICOEF_inTown
                                   - RUBE_AICOEF_inForest
               
               - script (code): Advanced duty scripts take the group as _this. The 
                                patrol script will wait/halt until the code/script is 
                                done. If this parameter is set, the default duties will 
                                be earsed, so you need to submit them too if you'd like 
                                to keep them in the duty pool.

               
             - "dutyCoef" (scalar from 0 to 1)
                  Probability to execute advanced duty on subtask/-route completion.
               - 0.0 = never 
               - 1.0 = always
   
   Returns:
    fsm handle (number, 0 when failed)
*/

private ["_group", "_pointsOfInterest", "_perimeter", "_patrolCoef", "_subtaskDistance", "_subtaskDeviance", "_onAlarm", "_exitOnAlarm", "_formationPool", "_behaviourPool", "_speedPool", "_combatFormationPool", "_combatTypePool", "_advancedDutyPool", "_advancedDutyCoef"];

_group = grpNull;

_pointsOfInterest = [];
_perimeter = [];
_patrolCoef = 0.5;
_subtaskDistance = 300;
_subtaskDeviance = 5;
_onAlarm = "";
_exitOnAlarm = false;
_formationPool = "COLUMN";
_behaviourPool = ["CARELESS", "SAFE"];
_speedPool = "LIMITED";

_combatFormationPool = ["WEDGE", "VEE", "LINE"];
_combatTypePool = ["HOLD", "GUARD", "SENTRY"];

_advancedDutyPool = [
   [RUBE_AICOEF_inTown, RUBE_AISR_secureNearestBuilding],
   [RUBE_AICOEF_inTheOpen, RUBE_AISR_watchHorizon]
];
_advancedDutyCoef = 0.3;


// read parameters
{
   switch (_x select 0) do
   {
      case "group": { _group = _x select 1; };
      case "pointsOfInterest": { _pointsOfInterest = _x select 1; };
      case "perimeter": 
      {
         // calculate the convex hull
         _perimeter = [
            (_x select 1), // positions/objects
            10, // spacing
            20 // min. ch point distance 
         ] call RUBE_convexHull;
         
         // remove last (polygon closing) point
         if ((count _perimeter) > 2) then
         {
            _perimeter resize ((count _perimeter) - 1);
         };
         // chance to flip convex hull, so they walk the other
         // way around...
         if (50 call RUBE_chance) then
         {
            _perimeter call RUBE_arrayReverse;
         };
      };
      case "waypoints": { _perimeter = _x select 1; }; 
      case "patrolCoef": { _patrolCoef = _x select 1; };
      case "distance": { _subtaskDistance = _x select 1; };
      case "deviance": { _subtaskDeviance = _x select 1; };
      case "onAlarm": { _onAlarm = _x select 1; };
      case "exitOnAlarm": { _exitOnAlarm = _x select 1; };
      case "formation": { _formationPool = _x select 1; };
      case "behaviour": { _behaviourPool = _x select 1; };
      case "speed": { _speedPool = _x select 1; };
      case "combatFormation": { _combatFormationPool = _x select 1; };
      case "combatType": { _combatTypePool = _x select 1; };
      case "advancedDuty": { _advancedDutyPool = _x select 1; };
      case "dutyCoef": { _advancedDutyCoef = _x select 1; };
   };
} forEach _this;



// empty routes? how funny.... :/
if (((count _pointsOfInterest) + (count _perimeter)) == 0) exitWith
{
   0
};

// fix coefficients for empty pools
if ((count _pointsOfInterest) == 0) then
{
   _patrolCoef = 0;
};

if ((count _perimeter) == 0) then
{
   _patrolCoef = 1;
};

if ((count _advancedDutyPool) == 0) then
{
   _dutyCoef = 0;
};


// execute fsm and return fsm handle
([
   ["group", _group],
   ["points", _pointsOfInterest],
   ["perimeter", _perimeter],
   ["patrolCoef", _patrolCoef],
   ["distance", _subtaskDistance],
   ["deviance", _subtaskDeviance],
   ["onAlarm", _onAlarm],
   ["exitOnAlarm", _exitOnAlarm],
   ["formation", _formationPool],
   ["behaviour", _behaviourPool],
   ["speed", _speedPool],
   ["combatFormation", _combatFormationPool],
   ["combatType", _combatTypePool],
   ["advancedDuty", _advancedDutyPool],
   ["dutyCoef", _advancedDutyCoef]
] execFSM "modules\common\RUBE\ai\ai_taskPatrol.fsm")