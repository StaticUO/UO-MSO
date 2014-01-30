
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
		["ACE_M4_F"					, 2			, 1			],
		["ACE_Backpack_US"			, 2			, 1			],
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
		["30Rnd_556x45_Stanag"		, 2			, 16		],
		["ACE_30Rnd_556x45_T_Stanag", 2			, 8			],
		["ACE_200Rnd_556x45_T_M249"	, 2			, 2			],
		["HandGrenade_West"			, 2			, 8			],
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