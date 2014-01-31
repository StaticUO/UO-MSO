
private ["_keyIdx"];
_keyIdx = if (typeName(_this) == "ARRAY") then {_this select 0} else {_this};
[_keyIdx, 1] call FMH_fnc_removeFlexiEntry;
