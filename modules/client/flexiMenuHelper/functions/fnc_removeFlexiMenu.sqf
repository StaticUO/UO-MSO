
private ["_keyIdx"];

_keyIdx = if (typeName(_this) == "ARRAY") then {_this select 0} else {_this};

["fmh_removeFlexiEntry", [_keyIdx, 0]] call CORE_fnc_callFunction;