/*************************************************
*	Advanced multiplayer mission parameters. The
*	array of parameters can be accessed via:
*		PARAMS_className
*	unless otherwise defined in the varName entry.
*
*	ie. PARAMS_ExampleParam will return the
*		admin choice (or default choice in SP)
*		of the ExampleParam param class.
*
*	Notes:
*	  -	If you're not using a module that is
*		included here, you may want to comment-
*		out its include line.
*
*	Example (Only the first 4 entries are required):
*		class ExampleParam					// Param Class Name
*		{
*			title = "Mission Timer";		// Param Name (Text; For Display)
*			values[] = {60,120};			// Param Values (Number Array)
*			texts[] = {"1 Hour","2 Hours"};	// Param Value Displays (Text Array)
*			default = 60;					// Param Default Value (Number)
*			toBool = 0;						// Param Value (values[] = {0,1}) To Boolean on Load (Number; 0 or 1)
*			varName = "mission_time_limit";	// Param Variable Name on Load (Global Variable), leave empty to not save as variable (text)
*			executeCode = "_this";			// Param Code to execute on mission start, passes chosen param value as _this, returns a value for the above variable (text)
*		};
*
*************************************************/
class Params
{
	
	// Time Sync Module Parameters
	#include "modules\common\syncTime\params.hpp"
	
	// Game Loop Module Parameters
	#include "modules\common\gameLoop\params.hpp"
	
	// Mission Settings Parameters
	#include "modules\common\missionSettings\params.hpp"
	
};
