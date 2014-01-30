
private ["_veh", "_class", "_side", "_weapons", "_magazines", "_result"];

_veh	= _this select 0;
_class	= _this select 1;
_side	= _this select 2;

//------------------------------------------------------------

/**************************************
*	Vehicle Weapons
*		Vehicle(0)			xInf
*		Cargo(2)			xInf
**************************************/
_weapons = [
	//	["ClassName"				, typeInt	, CountInt	],
		["AK_47_M"					, 2			, 3			],
		["AK_74"					, 2			, 3			],
		["ACE_G36K_EOTech"			, 2			, 1			],
		["glock17_EP1"				, 2			, 2			],
		["ACE_RPG22"				, 2			, 2			],
		["ACE_Backpack_Wood"		, 2			, 4			],
		["ACRE_PRC343"				, 2			, 2			]
];

/**************************************
*	Vehicle Magazines
*		Vehicle(0)			xInf
*		Cargo(2)			xInf
**************************************/
_magazines = [
	//	["ClassName"				, typeInt	, CountInt	],
		["30Rnd_762x39_AK47"		, 2			, 32		],
		["ACE_30Rnd_762x39_AP_AK47"	, 2			, 16		],
		["ACE_30Rnd_762x39_T_AK47"	, 2			, 16		],
		["30Rnd_545x39_AK"			, 2			, 32		],
		["ACE_30Rnd_545x39_AP_AK"	, 2			, 16		],
		["ACE_30Rnd_545x39_T_AK"	, 2			, 16		],
		["30Rnd_556x45_G36"			, 2			, 24		],
		["ACE_30Rnd_556x45_T_G36"	, 2			, 12		],
		["100Rnd_556x45_BetaCMag"	, 2			, 8			],
		["5Rnd_127x108_KSVK"		, 2			, 4			],
		["ACE_5Rnd_127x108_T_KSVK"	, 2			, 2			],
		["HandGrenade_East"			, 2			, 24		],
		["SmokeShell"				, 2			, 16		],
		["SmokeShellGreen"			, 2			, 8			],
		["SmokeShellRed"			, 2			, 8			],
		["SmokeShellPurple"			, 2			, 8			],
		["SmokeShellBlue"			, 2			, 8			],
		["ACE_C4_M"					, 2			, 4			],
		["ACE_CLAYMORE_M"			, 2			, 1			],
		["ACE_TRIPFLARE_M"			, 2			, 2			],
		["PipeBomb"					, 2			, 1			],
		["17Rnd_9x19_glock17"		, 2			, 12		],
		["ACE_1Rnd_HE_M203"			, 2			, 64		],
		["1Rnd_Smoke_M203"			, 2			, 32		],
		["1Rnd_SmokeGreen_M203"		, 2			, 32		],
		["1Rnd_SmokeRed_M203"		, 2			, 32		],
		["1Rnd_SmokeYellow_M203"	, 2			, 32		]
];

//------------------------------------------------------------

_result = [_veh, _weapons, _magazines];

_result