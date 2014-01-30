
private ["_previewUpdateSpeed", "_previewMethod", "_structures", "_buildMenuCond"];

_previewUpdateSpeed		= 30;	// Hertz, update speed of preview structure position. Affects performance. Set to 0 for constant updating.
_previewMethod			= 0;	// 0 = local, 1 = global. Global previews can use a lot of bandwidth if _previewUpdateSpeed is set too high.

_structures = [		// Building Structures
	//	["Structure Name"		, "ClassName"						, "PreviewClass"						, timeToDeploy	, distance	, flipBool||turnInt	],
		["Barbed Wire"			, "Fort_RazorWire"					, "Fort_RazorWirePreview"				, 1				, 4			, false				],
		["Sandbags (Straight)"	, "Land_fort_bagfence_long"			, "Land_fort_bagfence_longPreview"		, 1				, 3			, false				],
		["Sandbags (Round)"		, "Land_fort_bagfence_round"		, "Land_fort_bagfence_roundPreview"		, 3				, 5			, false				],
		["Sandbags (Corner)"	, "Land_fort_bagfence_corner"		, "Land_fort_bagfence_cornerPreview"	, 3				, 4			, true				],
		["Hesco Barrier"		, "Land_HBarrier3"					, "Land_HBarrier3ePreview"				, 2				, 4			, false				],
		["Hesco Barrier (Short)", "Land_HBarrier1"					, "Land_HBarrier1Preview"				, 1				, 4			, false				],
		["Hesco Barrier (Long)"	, "Land_HBarrier5"					, "Land_HBarrier5Preview"				, 3				, 4			, false				],
		["Hesco Barrier (Large)", "Land_HBarrier_large"				, "Land_HBarrier_largePreview"			, 5				, 6			, false				],
		["Wooden Ramp"			, "Land_WoodenRamp"					, "Land_WoodenRamp"						, 2				, 0.5		, true				],
		["Rampart (Straight)"	, "Land_fort_rampart_EP1"			, "Land_fort_rampartPreview"			, 4				, 5			, false				],
		["Rampart (Round)"		, "Land_fort_artillery_nest_EP1"	, "Land_fort_artillery_nestPreview"		, 5				, 8			, false				],
		["Bunker (Small)"		, "Land_fortified_nest_small_EP1"	, "Land_fortified_nest_smallPreview"	, 7				, 5			, true				],
		["Bunker (Tower)"		, "Land_Fort_Watchtower_EP1"		, "Land_Fort_Watchtower_EP1"			, 15			, 8			, true				],
		["Bunker (Large)"		, "Land_fortified_nest_big_EP1"		, "Land_fortified_nest_big_EP1"			, 20			, 8			, true				]
];

_buildMenuCond = {
	// Example Visible Condition for structure building menu
	private ["_result"];
	_result = false;
	_area = player getVariable ["build_area", nil];
	if (!isNil "_area") then {
		_result = ((alive player) && ((vehicle player) == player) && !building_playerBusy && {[player, _area] call CBA_fnc_inArea} && {time <= (['building_timeLimit', -1] call CORE_fnc_getVariable)});
	};
	_result
};

// Condition-Specific Settings
['building_timeLimit', (10 * 60)] call CORE_fnc_setVariable;