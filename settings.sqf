
/*
	Title: CORE Settings
	File: settings.sqf
	Author(s): Naught
	
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
	Section: Error Logging
	
	Notes:
		1. Log Levels:
			LOG_NONE	= 0;	// None
			LOG_CRIT	= 1;	// Critical
			LOG_ERROR	= 2;	// Error
			LOG_WARN	= 3;	// Warning
			LOG_NOTICE	= 4;	// Notice
			LOG_INFO	= 5;	// Info
			LOG_ALL		= 6;	// All
		2. Add (or subtract) log levels
			ie. 'LOG_CRIT + LOG_ERROR'
			or 'LOG_ALL - LOG_INFO'
			or 'LOG_NONE'

*/
CORE_logLevel				= LOG_ALL - LOG_INFO;	// Logging Level: Dev = LOG_ALL; Prod = LOG_ALL - LOG_INFO;
CORE_logToDiary				= true;					// Whether or not to log all errors to the map-based diary
