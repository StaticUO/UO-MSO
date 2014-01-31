
/*
   Title: Module Configuration
   File: config.cpp
   Author(s): Naught
   
   Notes:
	   1. All information on configuring a module can be found in that module's "setup.txt" file.

   License:
	   Copyright 2014 Dylan Plecki.
	   
	   Licensed under the Apache License, Version 2.0 (the "License");
	   you may not use this file except in compliance with the License.
	   You may obtain a copy of the License at
	   
	   http://www.apache.org/licenses/LICENSE-2.0
	   
	   Unless required by applicable law or agreed to in writing, software
	   distributed under the License is distributed on an "AS IS" BASIS,
	   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	   See the License for the specific language governing permissions and
	   limitations under the License.
*/

/*
	Section: Module Configuration
	Notes:
		1. You may edit below this comment.
*/

class Extended_PreInit_EventHandlers
{
	UCD_pre_init = "call compile preProcessFileLineNumbers 'mod\ucd\pre_init.sqf'";
	GEAR_pre_init = "call compile preProcessFileLineNumbers 'mod\gear\pre_init.sqf'";
};

class Extended_Init_EventHandlers
{
    class AllVehicles
    {
		UCD_veh_init = "_this spawn UCD_fnc_cacheObject";
		GEAR_veh_init = "_this spawn GEAR_fnc_unitInit";
    };
};

class Params
{
	/* Note: Comment out or delete lines from modules which aren't in use */
	#include "gloop\params.hpp"
	#include "mset\params.hpp"
	#include "synct\params.hpp"
};

#include "gloop\rsc.hpp" // Game Loop End Screen Dialog

/*
	Section: Module Settings
	Notes:
		1. Do not edit below this comment!
*/

#define MACHINE_CLIENT 1
#define MACHINE_PLAYER 2
#define MACHINE_HC 4
#define MACHINE_NON_JIP 8
#define MACHINE_JIP 16
#define MACHINE_SERVER 32
#define MACHINE_DEDICATED 64

#define MACHINE_ALL MACHINE_CLIENT, MACHINE_SERVER
#define MACHINE_AI_HOST MACHINE_HC, MACHINE_SERVER

#define PRIORITY_IMMEDIATE 0
#define PRIORITY_VERY_HIGH 1
#define PRIORITY_HIGH 50
#define PRIORITY_NORMAL 100
#define PRIORITY_LOW 250
#define PRIORITY_VERY_LOW 500
#define PRIORITY_LAST 1000

class CfgModules
{
	#include "modules.cpp"
};