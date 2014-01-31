
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
		["AK_47_M"					, 2			, 2			],
		["AK_74"					, 2			, 1			],
		["ACE_Backpack_Wood"		, 2			, 1			],
		["ACE_Stretcher"			, 2			, 1			],
		["ACRE_PRC343"				, 2			, 2			]
];

/**************************************
*	Vehicle Magazines
*		Vehicle(0)			xInf
*		Cargo(2)			xInf
**************************************/
_magazines = [
	//	["ClassName"				, typeInt	, CountInt	],
		["ACE_30Rnd_762x39_AP_AK47"	, 2			, 20		],
		["ACE_30Rnd_545x39_AP_AK"	, 2			, 16		],
		["ACE_30Rnd_762x39_T_AK47"	, 2			, 10		],
		["ACE_30Rnd_545x39_T_AK"	, 2			, 8			],
		["HandGrenade_East"			, 2			, 8			],
		["SmokeShell"				, 2			, 4			],
		["ACE_Bandage"				, 2			, 12		],
		["ACE_LargeBandage"			, 2			, 4			],
		["ACE_Morphine"				, 2			, 6			],
		["ACE_Epinephrine"			, 2			, 4			],
		["ACE_Medkit"				, 2			, 2			]
];

//------------------------------------------------------------

_result = [_veh, _weapons, _magazines];

_result