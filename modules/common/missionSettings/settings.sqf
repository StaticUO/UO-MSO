
private ["_serverVD", "_serverTG", "_clientTG", "_clientVD", "_ace_settings_max_vd",
		"_clientDisableGreetingMenu", "_clientRadioVolume", "_playerSafetyWeapon"];

_clientVD							= PARAMS_ClientVD;	// Client view distance
_clientTG							= PARAMS_ClientTG;	// Client terrain grid (grass)

_serverVD							= 1200;				// Server view distance, affects AI and performance
_serverTG							= _clientTG;		// Server terrain grid (grass)

ace_settings_enable_vd_change		= PARAMS_ACEVD;		// Allow view distance change in ACE settings
ace_settings_enable_tg_change		= PARAMS_ACETG;		// Allow terrain grid (grass) change in ACE settings
_ace_settings_max_vd				= _clientVD;		// Max view distance in ACE settings menu

ace_sys_wounds_noai					= true; 			// Disable wounds for AI for performance
ace_wounds_prevtime					= (5 * 60); 		// ACE Wounds Unconscious Countdown Timer
ace_sys_wounds_withSpect			= nil;				// If player is unconscious, spectator script initializes

ace_sys_tracking_radio_required		= false;			// Black vehicle tracking marker, require Radio
ace_sys_tracking_markers_enabled	= true;				// Black vehicle tracking marker global enabled

enableEngineArtillery false;  							// Disable BI simple artillery computer
enableSaving [false, false];							// Disable Saving
enableRadio false;										// Disable BIS radio (gamey)
_clientRadioVolume					= 0;				// Change BIS radio volume
_clientDisableGreetingMenu			= true;				// Disable BIS Greeting Menu

_playerSafetyWeapon					= true;				// Safety player weapon on start
