
private ["_unit"];

_unit = _this select 0;

((alive _unit) && !(_unit getVariable ['gdtmod_isSpectating', false]))