/*
   Author:
    rübe
    
   Description:
    group waiting in the wings fsm that works with infantry or
    vehicle groups. In the latter case just make sure, that the
    units are assigned to the vehicle, the moment you call this
    function.
    
    waiting in the wings = group will disembark if in vehicles 
    and hang out safely at some position (auto or set) until 
    they are alert (explicitly by setting their waypoint-behaviour 
    to DANGER or STEALTH or implicitly if they are directly attacked).
    
    Once alarmed, they will get in their vehicles (if the group has 
    any), update their behaviour and possibly set out for a defineable
    combat position. Though it's intended to be used with combat 
    waypoint types such as SUPPORT, HOLD, SENTRY or GUARD. You get the
    idea...
    
   Parameter(s):
    _this: parameters (array of array [key (string), value (any)])
    
           - required:
             
             - "group" (group)
             
           - optional:
           
             - "position" (position)
                  position the group hangs out. If non is given, a
               suitable one will be looked for...
               
             - "behaviour" (string OR array of strings)
                  hang out behaviour.
               - default = ["CARELESS", "SAFE"]
               
             - "speed" (string OR array of strings)
                  hang our speed.
               - default = ["LIMITED"];
             
             - "combatPosition" (position)
                  position the group will move out to once alarmed.
               Though the "move"-part highly depends on the given
               combatType.
               - default = none
             
             - "combatFormation" (string OR array of strings)
                  formation in combat/once alarmed.
               - default = ["WEDGE", "VEE", "LINE"]
               
             - "combatType" (string OR array of strings)
                  waypoint type in combat/once alarmed.
               - default = ["HOLD", "GUARD", "SENTRY"];
               
             - "combatSpeed" (string OR array of strings)
                  waypoint type in combat/once alarmed.
               - default = ["NORMAL", "FULL"]
             
             - "onAlarm" (code)
                  Code to be run on contact or once "alarm" goes off.
                  
   Returns:
    fsm handle (number, 0 when failed)
*/

// execute fsm and return fsm handle
(_this execFSM "modules\common\RUBE\ai\ai_waitingInTheWings.fsm")