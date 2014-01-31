
/*
	Title: Mission Settings
	File: settings.cpp
	Author(s): Naught
	
	Notes:
		1. Comment-out any features that you do
		   not want to use.
		2. Block comments are used to describe
		   the features directly below them. An
		   empty line will signify irrelevance.
	
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

/************************************************
*	The purpose of this class definition is to
*	signal the engine the gameType which is
*	displayed in the MP game browser. This can
*	assist other players for finding particular
*	missions using the filters.
*
*	gameType can be one of following:
*		DM - Death Match
*		CTF - Capture the Flag
*		FF - Flag Fight
*		Coop -Cooperative Mission
*		Team - Team Mission
*		Scont - Sector Control
*		Hold - Hold Location
*		Unknown - Used when no class header is defined
************************************************/
class Header
{
	gameType				= Coop;	// GameType, see above
	minPlayers				= 1;	// Min number of players to start
	maxPlayers				= 10;	// Max number of players allowed
	playerCountMultipleOf	= 1;	// Should always be 1
};

/************************************************
*	Sets respawn type.
*	Can be one of:
*		- 0 or "NONE" - No respawn
*		- 1 or "BIRD" - Respawn as a seagull
*		- 2 or "INSTANT" - Respawn where you died
*		- 3 or "BASE" - Respawn in base
*			- Requires a marker named:
*				- respawn_west
*				- respawn_east
*				- respawn_guerrila
*				- respawn_civilian
*			- Vehicle respawn in base requires a
*			  marker named:
*				- respawn_vehicle_west
*				- respawn_vehicle_east
*				- respawn_vehicle_guerrila
*				- respawn_vehicle_civilian
*		- 4 or "GROUP" - Respawn in your group
*		- 5 or "SIDE" - Respawn into an AI unit
*					  on your side
************************************************/
respawn					= "BASE";

respawndelay			= 1;	// Set respawn delay in seconds.
//respawnVehicleDelay	= 11;	// Set vehicle respawn delay in seconds.

respawnDialog			= 0;	// Show the scoreboard and respawn countdown timer for a player if he is killed.

disabledAI				= 1;	// When 1, removes all playable units which do not have a human player.
aiKills					= 0;	// Enables scorelist for AI players.

briefing				= 0;	// Skip briefing screen for SP missions.
debriefing				= 0;	// Defines if the debriefing is shown or not at the end of the mission.

enableItemsDropping		= 0;	// Disable dropping items while swimming.

loadScreen				= "";	// You can define a picture to be shown while the mission is loaded.

onLoadMission			= "";	// Displays a message while the mission is loading.
onLoadIntro				= "";	// Displays a message while the intro is loading.
onLoadMissionTime		= 0;	// Define whether you will see the time and date displayed while the mission loads.
onLoadIntroTime			= 0;	// Define whether you will see the time and date displayed while the intro loads.

/************************************************
*	Disable global, side, command and system chat
*
*		0 = Global
*		1 = Side
*		2 = Command
*		3 = Group
*		4 = Vehicle
*		5 = Direct
*		6 = System
************************************************/
disableChannels[]		= {};

/************************************************
*	Set minimum, average, and maximum scores for
*	your mission. Score is related to the star
*	display in the debriefing screen. The score
*	can be influenced during a missions progress
*	by using the addRating command.
*	minScore < avgScore < maxScore
************************************************/
//minScore				= 0;
//avgScore				= 1800;
//maxScore				= 75000;
