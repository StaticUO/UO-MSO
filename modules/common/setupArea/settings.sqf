
private ["_globalSetupTime", "_setupAreas", "_exemptUnits"];

_globalSetupTime = (10 * 60); // Seconds

_setupAreas = [ // Uses box and elipse markers to draw-out setup areas - The module will automatically remove markers listed here that a player isn't in
	//	["SetupAreaMarker"		, timeSecInt		, enabledBool	],
		["setup_area_blufor"	, _globalSetupTime	, true			],
		["setup_area_opfor"		, _globalSetupTime	, true			]
];

_exemptUnits = [];
