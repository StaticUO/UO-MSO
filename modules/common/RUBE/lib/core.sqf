/*
   Author:
    rübe
    
   Description:
    RUBE library core data and functions.
*/

/**********************************************************
 * core options (you may overwrite these as desired after init)
 */

// hack to remove handguns from all units spawned with RUBE functions
// until the pistol-bug has been resolved...
RUBE_HACK_REMOVE_HANDGUNS = true;

// auto drag & drop feature (see RUBE_makeDraggable and RUBE_makeDroppable,
// also check out RUBE_TYPELIST_DRAGGABLE and RUBE_TYPELIST_DROPABLE defined
// in /RUBE/lib/typelists.sqf)
RUBE_ENABLE_AUTO_DRAGGABLE = true;
RUBE_ENABLE_AUTO_DROPABLE = true;




/**********************************************************
 * default spawn distances
 */

private ["_viewDistance"];

// cap viewdistance
_viewDistance = viewDistance;
if (_viewDistance > 2000) then
{
   _viewDistance = 2000;
};
 
//  for structures
RUBE_SPAWNDISTANCE1 = (1500 max _viewDistance);
// ... and for units
RUBE_SPAWNDISTANCE2 = (1005 max (_viewDistance * 0.67));


/**********************************************************
 * globals for the player while there is no player selected
 * (selectNoPlayer) -- used/introduced for animations, 
 * cutscenes and stuff...
 */

//RUBE_PLAYER_CURRENT_UNIT 
//RUBE_PLAYER_...

/**********************************************************
 * generic all-purpose unique id
 */
 
RUBE_INTERN_AUTOID_FORMAT = "RUBE_AUTOID_%1";
RUBE_INTERN_AUTOID = 0;
RUBE_INTERN_AUTOMRKID_FORMAT = "RUBE_AUTOMRKID_%1"; 
RUBE_INTERN_AUTOMRKID = 0;
RUBE_createID = {
   private ["_id"];
   _id = format [RUBE_INTERN_AUTOID_FORMAT, RUBE_INTERN_AUTOID];
   RUBE_INTERN_AUTOID = RUBE_INTERN_AUTOID + 1;
   _id
};

// separate id generator and clear all function for markers,
// so we can screw around, clear everything drawn with auto-ids
// and start again... yeah!
RUBE_createMarkerID = {
   private ["_id"];
   _id = format [RUBE_INTERN_AUTOMRKID_FORMAT, RUBE_INTERN_AUTOMRKID];
   RUBE_INTERN_AUTOMRKID = RUBE_INTERN_AUTOMRKID + 1;
   _id
};
RUBE_clearAutoMarkers = {
   for "_i" from 0 to (RUBE_INTERN_AUTOMRKID - 1) do
   {
      deleteMarker format[RUBE_INTERN_AUTOMRKID_FORMAT, _i];
   };
   RUBE_INTERN_AUTOMRKID = 0;
   true
};

// this is where we keep our addAction callbacks (used in fn_addAction.sqf)
// [[object, [callbacks]], [...]]
RUBE_INTERN_ACTION_CALLBACKS = [];




/**********************************************************
 * generic memory/data to avoid globals
 */
 
// Nothing can be really removed from this list to guarantee 
// data integrity. However we may "nullify" unneeded data.
RUBE_MEMORY_DATA = [];

// any => index
RUBE_saveData = {
   private ["_index"];
   _index = count RUBE_MEMORY_DATA;
   RUBE_MEMORY_DATA set [_index, _this];
   _index
};

// index => any
RUBE_getData = {
   if (_this < (count RUBE_MEMORY_DATA)) exitWith
   {
      (RUBE_MEMORY_DATA select _this)
   };
   objNull
};

// [index, any] => boolean
RUBE_setData = {
   if ((_this select 0) < (count RUBE_MEMORY_DATA)) exitWith
   {
      RUBE_MEMORY_DATA set [(_this select 0), (_this select 1)];
      true
   };
   false
};


/**********************************************************
 * generic, little, sugar...
 */


// makes sure a variable is defined; if not, we're going
// to initialize it with the given default...
// [obj, var, init-value] => any (variable/init-value)
// OR
// [obj, var, init-value, dont-evaluate] => any (variable/init-value)
//  -> if init-value is code, we evaluate it, and set the result as
//     init-value per default or if dont-evaluate is set to false.
//     .. also that code get's passed the obj as _this
RUBE_initVariable = {
   private ["_var", "_eval"];
   _var = (_this select 0) getVariable (_this select 1);
   _eval = true;
   if ((count _this) > 3) then
   {
      _eval = !(_this select 3);
   };

   if (isNil "_var") then 
   { 
      if (((typeName (_this select 2)) == "CODE") && _eval) then
      {
         (_this select 0) setVariable [(_this select 1), ((_this select 0) call (_this select 2)), true]; 
      } else
      {
         (_this select 0) setVariable [(_this select 1), (_this select 2), true]; 
      };
   }; 
   
   ((_this select 0) getVariable (_this select 1)) 
};


// to easily check boolean variables in some objects scope
// (getVariable wrapper function)
// [obj, var] => boolean
RUBE_isTrue = {
   private ["_var"];
   _var = (_this select 0) getVariable (_this select 1);
   
   if (isNil ("_var")) exitWith 
   { 
      false 
   };   
   
   if ((typeName _var) != "BOOL") exitWith
   {
      false
   };
   
   _var
};

// same trick as with the above _isTrue, but with objects (objNull doesn't count as one)
// (getVariable wrapper function)
// [obj, var] => boolean
RUBE_isObject = {
   private ["_var"];
   _var = (_this select 0) getVariable (_this select 1);
   
   if (isNil ("_var")) exitWith 
   { 
      false 
   };   
   
   if ((typeName _var) != "OBJECT") exitWith
   {
      false
   };
   
   (!(isNull _var))
};


// [obj, var, equalToValue] => boolean
RUBE_isEqual = {
   private ["_var", "_value"];
   _var = (_this select 0) getVariable (_this select 1);
   _value = _this select 2;
   
   if (isNil ("_var")) exitWith 
   { 
      false 
   };
   
   if ((typeName _var) != (typeName _value)) exitWith
   {
      false
   };
   
   (_var == _value)
};





/**********************************************************
 * some more sugar... (player/unit shortcuts)
 */

// TODO: needs probably something better than this.. :/
//       AI acts weird... :|
// unit => void
RUBE_hideWeapons = {
   private ["_weapons"];
   _weapons = weapons _this;
   
   {
      _this removeWeapon _x;
   } forEach _weapons;
   
   _this setVariable ["RUBE_weapons", _weapons, true];
};

// unit => void
RUBE_showWeapons = {
   private ["_weapons"];
   _weapons = _this getVariable "RUBE_weapons";
   if ((typeName _weapons) != "ARRAY") exitWith {};
   
   {
      _unit addWeapon _x;
   } forEach _weapons;
   
   _this selectWeapon (primaryWeapon _this);
   
   _this setVariable ["RUBE_weapons", nil, true];
};


/*
----------------------------------------------------------------------------
  DEPRECATED(!) since OA 1.55 and the introduction of getTerrainHeightASL
----------------------------------------------------------------------------
*/
// probe object (to setPos and getPosASL)
//RUBE_PROBE_OBJ = createVehicle ["Baseball", [0,0,0], [], 0, "NONE"];



/**********************************************************
 * debug functions
 */

// outputs the given information via diag_log into the rpt-file
//  only if the variable RUBE_DEBUG is defined in the callers scope 
//  and evaluates to true. 
// string => void (rpt output)
RUBE_debugLog = {
   if (isNil("RUBE_DEBUG")) exitWith {};
   if (RUBE_DEBUG) then
   {
      diag_log _this;
   };
};

// hint's only if RUBE_DEBUG is defined and true.
// string => void (default hint)
RUBE_debugHint = {
   if (isNil("RUBE_DEBUG")) exitWith {};
   if (RUBE_DEBUG) then
   {
      hint _this;
   };
};

// wrapper for debug markers
RUBE_debugDrawMarker = {
   if (isNil("RUBE_DEBUG")) exitWith {};
   if (RUBE_DEBUG) then
   {
      _this call RUBE_mapDrawMarker;
   };
};

// wrapper for debug lines
RUBE_debugDrawLine = {
   if (isNil("RUBE_DEBUG")) exitWith {};
   if (RUBE_DEBUG) then
   {
      _this call RUBE_mapDrawLine;
   };
};