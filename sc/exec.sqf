
/* This file is for executing addAction code without creating new files, uses passed params to execute */

private ["_target", "_caller", "_actionID", "_code", "_handle"];
_target		= _this select 0;
_caller		= _this select 1;
_actionID	= _this select 2;
_code		= _this select 3;
_handle		= nil;

if (typeName(_code) == typeName("")) then {
	_code = compile _code;
};

if (typeName(_code) == typeName({})) then {
	_handle = [_target, _caller, _actionID] spawn _code;
};

_handle