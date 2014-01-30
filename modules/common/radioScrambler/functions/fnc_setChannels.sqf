private["_radioClass", "_channelsArray", "_array", "_run", "_go", "_radioClassBare", "_varName"];
_radioClass = _this select 0;
_channelsArray = _this select 1;

if(isNil "_radioClass" || isNil "_channelsArray") exitWith { false };

// remove the ACRE_ part of the string
_radioClass = toLower _radioClass;
_array = toArray _radioClass;

_i = 5;
_radioClassBare = "";
while { _i < (count _array) } do {
	_radioClassBare = _radioClassBare + toString[(_array select _i)];
	_i = _i + 1;
};

_varName = "acre_sys_" + _radioClassBare + "_channels";

{ // forEach
	(missionNamespace getVariable _varName) set [_foreachindex, (_channelsArray select _foreachindex)];
} forEach _channelsArray;

uiNameSpace setVariable [_varName, (missionNamespace getVariable _varName)];

true