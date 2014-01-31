
private ["_timeOut", "_rand", "_seedStart", "_bluforSeed", "_opforSeed", "_indSeed", "_civSeed", "_radioSeeds", "_channelStep", "_seedStep"];

_timeOut		= 30;	// Time-Out in seconds

_channelStep	= 5;
_seedStep		= 0.025;

_rand			= (_channelStep / _seedStep) / 4;

_seedStart		= 0;
_bluforSeed		= _seedStart + random(_rand);
_opforSeed		= _bluforSeed + random(_rand);
_indSeed		= _opforSeed + random(_rand);
_civSeed		= _indSeed + random(_rand);

_radioSeeds = [
	[	// Blufor
		_bluforSeed,
		_channelStep,
		_seedStep
	],
	[	// Opfor
		_opforSeed,
		_channelStep,
		_seedStep
	],
	[	// Independent
		_indSeed,
		_channelStep,
		_seedStep
	],
	[	// Civilian
		_civSeed,
		_channelStep,
		_seedStep
	]
];
