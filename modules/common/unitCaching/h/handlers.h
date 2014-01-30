
class Extended_PreInit_EventHandlers
{
	class ucd
	{
		init = "call compile preProcessFileLineNumbers 'modules\common\unitCaching\load.sqf'";
	};
};

class Extended_Init_EventHandlers
{
    class AllVehicles
    {
		class ucd
		{
			init = "_this spawn UCD_fnc_cacheObject;";
		};
    };
};