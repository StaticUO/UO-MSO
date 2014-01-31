
/*
	Title: Module Settings
	File: modules.cpp
	Author(s): Naught
	
	Notes:
		1. All information on configuring a module can be found in that module's "setup.txt" file.
	
	Example:
	(start code)
		class example_module
		{
			enabled = 1;
			identifier = "exm";
			priority = PRIORITY_NORMAL;
			machines = {MACHINE_ALL};
			dependencies = {};
			init = "init.sqf";
			class params
			{
				syncTime = 1;
			};
		};
	(end)
	
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

class AI_Hear_Talking
{
	enabled = 1;
	identifier = "aiht";
	priority = PRIORITY_NORMAL;
	machines = {MACHINE_CLIENT};
	dependencies = {};
};

class Briefing
{
	enabled = 1;
	identifier = "brief";
	priority = PRIORITY_LAST;
	machines = {MACHINE_CLIENT};
	dependencies = {};
};

class Building
{
	enabled = 0;
	identifier = "build";
	priority = PRIORITY_LOW;
	machines = {MACHINE_CLIENT};
	dependencies = {"fmh"};
};

class Flexi_Menu_Helper
{
	enabled = 1;
	identifier = "fmh";
	priority = PRIORITY_VERY_HIGH;
	machines = {MACHINE_ALL};
	dependencies = {};
};

class Gear
{
	enabled = 1;
	identifier = "gear";
	priority = PRIORITY_NORMAL;
	machines = {MACHINE_ALL};
	dependencies = {};
	init = "";
};

class Game_Loop
{
	enabled = 1;
	identifier = "gloop";
	priority = PRIORITY_NORMAL;
	machines = {MACHINE_ALL};
	dependencies = {};
};

class Mission_Specific_Code
{
	enabled = 0;
	identifier = "msc";
	priority = PRIORITY_NORMAL;
	machines = {MACHINE_ALL};
	dependencies = {};
};

class Mission_Settings
{
	enabled = 1;
	identifier = "mset";
	priority = PRIORITY_NORMAL;
	machines = {MACHINE_ALL};
	dependencies = {};
};

class Radio_Scrambler
{
	enabled = 1;
	identifier = "radio";
	priority = PRIORITY_NORMAL;
	machines = {MACHINE_ALL};
	dependencies = {};
};

class Setup_Area_Timer
{
	enabled = 1;
	identifier = "setup";
	priority = PRIORITY_NORMAL;
	machines = {MACHINE_ALL};
	dependencies = {};
};

class Spectator
{
	enabled = 1;
	identifier = "spec";
	priority = PRIORITY_NORMAL;
	machines = {MACHINE_PLAYER};
	dependencies = {};
};

class Sync_Time
{
	enabled = 1;
	identifier = "synct";
	priority = PRIORITY_IMMEDIATE;
	machines = {MACHINE_ALL};
	dependencies = {};
};

class Teleport_To_Squad_Leader
{
	enabled = 1;
	identifier = "ttsl";
	priority = PRIORITY_LOW;
	machines = {MACHINE_PLAYER};
	dependencies = {"fmh"};
};

class Unit_Caching_Distribution
{
	enabled = 1;
	identifier = "ucd";
	priority = PRIORITY_NORMAL;
	machines = {MACHINE_ALL};
	dependencies = {};
	init = "";
};
