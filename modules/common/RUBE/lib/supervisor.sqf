/*
   Author:
    rübe
    
   Description:
    RUBE singleplayer mission supervisor
    (radio, diary and task manager)
*/

/*
   boah, wtf. Guess this is in need of a major
   rewrite. The whole data-structure of playable
   and tasks is pretty fucked up and also what if
   we wanna swap the playable characters, hu? :/
*/
RUBE_PLAYABLE = [];
RUBE_TASKS = []; // [[id, [playable]], ...]
RUBE_TASKS_CURRENT = -1; // supervisor task id!

RUBE_RADIO_QUEUE = [];
RUBE_RADIO_ABORT = false; // evil hack
RUBE_SUPERVISION_FSM = -1;


// auto hint on switch to the following task states (all uppercase!):
RUBE_TASK_AUTO_HINT = [];

// kbWasSaid wrapper to prevent dead ends in communication...
// [from/sender, to/recipient, topic, sentence] => boolean
RUBE_kbWasSaidOrDead = {

   format[
      "RUBE_kbWasSaidOrDead: %1->%2 [%3, %4] (%5)", 
      (_this select 0), 
      (_this select 1), 
      (_this select 2), 
      (_this select 3),
      time
   ] call RUBE_debugLog;
   
   if ((_this select 0) kbWasSaid [(_this select 1), (_this select 2), (_this select 3), 99999]) exitWith { true };
   if (!(alive (_this select 0))) exitWith { true };
   if (!(alive (_this select 1))) exitWith { true };
   
   // hack exit in case we got stuck again :/
   if (RUBE_RADIO_ABORT) exitWith
   {
      RUBE_RADIO_ABORT = false;
      true
   };
   
   false
};

// ['command', args] => int
// 
// command:             args:
// init                 [playable-units]
// createDiaryRecord    [name, record]
// createTask           [name, description, waypoint-label, position] => id
// setTaskState         [id, status]
// taskState            id
// setTaskPosition      [id, position]
// setCurrentTask       id
// currentPlayerTask    [] => the player's current task
// currentTaskId        [] => supervisor task id (not the task itself!)
// hintTask             id
// failOpenTasks        -
// radio                code
//                      [args, code]
//                      [args, code, true]  (emergency/high priority transmission)      
// isTransmitting       -   => boolean
RUBE_SUPERVISION_FSM = -1;
RUBE_supervisor = {
   private ["_index", "_i", "_id", "_call", "_tasks"];
   _index = -1;
      
   switch (_this select 0) do
   {
      case "isTransmitting":
      {
         _index = RUBE_SUPERVISION_FSM getFSMVariable "_transmitting";
      };
      case "radio": 
      {
         _i = false; 
         _call = [0, {}];
         
         switch (typeName (_this select 1)) do
         {
            case "ARRAY":
            {
               _call = _this select 1;
               if ((count (_this select 1)) > 2) then
               {
                  _i = (_this select 1) select 2;
               };
            };
            case "CODE":
            {
               _call = [0, (_this select 1)];
            };
         };

         if (_i) then
         {
            // high priority transmission
            RUBE_RADIO_QUEUE = [RUBE_RADIO_QUEUE, [_call]] call RUBE_arrayAppend;
         } else
         {
            RUBE_RADIO_QUEUE = [[_call], RUBE_RADIO_QUEUE] call RUBE_arrayAppend;
         };
      };
      case "hintTask":
      {
         private ["_title", "_color", "_icon"];
         _id = _this select 1;
         
         _title = "";
         _color = [];
         _icon = "";

         switch (taskState ((RUBE_TASKS select _id) select 0)) do
         {
            case "Created":
            {
               _title = localize "str_taskNew";
               _color = [1,1,1,1];
               _icon = "taskNew";
            };
            case "Current":
            {
               _title = localize "str_taskSetCurrent";
               _color = [1,1,1,1];
               _icon = "taskCurrent";
            };
            case "Assigned":
            {
               _title = localize "str_taskSetCurrent";
               _color = [1,1,1,1];
               _icon = "taskCurrent";
            };
            case "Succeeded":
            {
               _title = localize "str_taskAccomplished";
               _color = [0.600000,0.839215,0.466666,1.000000];
               _icon = "taskDone";
            };
            case "Failed":
            {
               _title = localize "str_taskFailed";
               _color = [0.972549,0.121568,0.000000,1.000000];
               _icon = "taskFailed";
            };
            case "Canceled":
            {
               _title = localize "str_taskCancelled";
               _color = [0.750000,0.750000,0.750000,1.000000];
               _icon = "taskFailed";
            };
         };
         
         if (_title != "") then
         {
            taskHint [
               (format ["%1\n%2", _title, ((taskDescription ((RUBE_TASKS select _id) select 0)) select 1)]),
               _color,
               _icon
            ];
         };
      };
      case "setTaskPosition":
      {
         _id = (_this select 1) select 0;
         {
            _x setSimpleTaskDestination ((_this select 1) select 1);
         } forEach (RUBE_TASKS select _id);
      };
      case "setTaskState": 
      {
         _id = (_this select 1) select 0;
         {
            _x setTaskState ((_this select 1) select 1);
         } forEach (RUBE_TASKS select _id);
         
         if (((_this select 1) select 1) in RUBE_TASK_AUTO_HINT) then
         {
            ["hintTask", _id] call RUBE_supervisor;
         };
      };
      case "taskState":
      {
         _id = _this select 1;
         _index = (taskState ((RUBE_TASKS select _id) select 0));
      };
      case "failOpenTasks":
      {
         for "_i" from 0 to ((count RUBE_TASKS) - 1) do
         {
            _tasks = RUBE_TASKS select _i;
            if (!(taskCompleted (_tasks select 0))) then
            {
               {
                  _x setTaskState "FAILED";
               } forEach _tasks;
               
               if ("FAILED" in RUBE_TASK_AUTO_HINT) then
               {
                  ["hintTask", _i] call RUBE_supervisor;
               };
            };
         };
      };
      case "setCurrentTask": 
      {
         _id = _this select 1;
         if ((typeName _id) == "ARRAY") then
         {
            _id = (_this select 1) select 0;
         };
         
         RUBE_TASKS_CURRENT = _id;
         
         for "_i" from 0 to ((count RUBE_PLAYABLE) - 1) do
         {
            if (alive (RUBE_PLAYABLE select _i)) then
            {
               (RUBE_PLAYABLE select _i) setCurrentTask ((RUBE_TASKS select _id) select _i);
            };
         };
         
         if ("ASSIGNED" in RUBE_TASK_AUTO_HINT) then
         {
            ["hintTask", _id] call RUBE_supervisor;
         };
      };
      case "currentTaskId":
      {
         _index = RUBE_TASKS_CURRENT;
      };
      case "currentPlayerTask":
      {         
         _index = (RUBE_TASKS select RUBE_TASKS_CURRENT) select (player getVariable "RUBE_PLAYABLE_ID");
      };
      case "currentPlayerTaskId":
      {
         private ["_pid", "_cpt"];
         _pid = player getVariable "RUBE_PLAYABLE_ID";
         _cpt = currentTask player;
         for "_i" from 0 to ((count RUBE_TASKS) - 1) do
         {
            if (((RUBE_TASKS select _i) select _pid) == _cpt) exitWith
            {
               _index = _i;
            };
         };
      };
      case "createTask": 
      {
         _index = count RUBE_TASKS;
         RUBE_TASKS set [_index, []];
         {
            _i = count (RUBE_TASKS select _index);
            
            _x setVariable ["RUBE_PLAYABLE_ID", _i, true];
            
            (RUBE_TASKS select _index) set [
               _i,
               (_x createSimpleTask [((_this select 1) select 0)])
            ];
            ((RUBE_TASKS select _index) select _i) setSimpleTaskDestination ((_this select 1) select 3);
            ((RUBE_TASKS select _index) select _i) setSimpleTaskDescription [
               ((_this select 1) select 1),
               ((_this select 1) select 0),
               ((_this select 1) select 2)
            ];
            ((RUBE_TASKS select _index) select _i) setTaskState "CREATED";
         } forEach RUBE_PLAYABLE;
         
         if ("CREATED" in RUBE_TASK_AUTO_HINT) then
         {
            ["hintTask", _index] call RUBE_supervisor;
         };
      };
      case "createDiaryRecord": 
      {
         {
            _x createDiaryRecord [
               "diary", 
               [
                  ((_this select 1) select 0), 
                  ((_this select 1) select 1)
               ]
            ];
         } forEach RUBE_PLAYABLE;
      };
      case "init": 
      {
         if ((typeName (_this select 1)) == "ARRAY") then
         {
            RUBE_PLAYABLE = _this select 1;
         } else
         {
            RUBE_PLAYABLE = [(_this select 1)];
         };
         // start supervisor fsm
         if (RUBE_SUPERVISION_FSM < 0) then
         {
            RUBE_SUPERVISION_FSM = [] execFSM "common\modules\RUBE\lib\supervisor.fsm";
         };
      };
   };
   
   _index
};