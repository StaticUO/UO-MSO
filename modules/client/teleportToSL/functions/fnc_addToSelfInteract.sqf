
sleep 1;

ttSL_startingPos = call ttSL_startingPosCode;

['fmh_addFlexiButton', [
	'selfInteraction',
	'Teleport to SL',
	{['teleportToSL', [player]] call CORE_fnc_callFunction;},
	"main",
	true,
	"((getPos player) distance ttSL_startingPos) <= ttSL_maxDistance"
]] call CORE_fnc_callFunction;