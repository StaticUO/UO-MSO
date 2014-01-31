
private ["_autoStartSpectator"];

_autoStartSpectator = true;

['gdtmod_deathMessage', "You are dead.\nEntering spectator mode..."] call CORE_fnc_setVariable;

['gdtmod_specPen', specPen] call CORE_fnc_setVariable; // Must be an object