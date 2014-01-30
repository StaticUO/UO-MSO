
private ["_unit", "_class", "_side", "_weapons", "_optics", "_items", "_mainMagazines", "_secondaryMagazines", "_ifak", "_result"];

_unit	= _this select 0;
_class	= _this select 1;
_side	= _this select 2;

//------------------------------------------------------------

/**************************************
*	Weapon Slots(addType)
*		Gear Normal(0)	x2
*		Ruck(1)			xInf
*		WOB(3)			x1
**************************************/
_weapons = [
	//	["ClassName"				, AddTypeInt, CountInt	],
		["ACE_HK416_D14_COMPM3_M320", 0			, 1			],
		["ACE_Rucksack_RD99"		, 3			, 1			]
];

/**************************************
*	Optic Slots(addType)
*		Gear Optics(0)	x2
*		Ruck(1)			xInf
**************************************/
_optics = [
	//	["ClassName"				, AddTypeInt, CountInt	],
		["NVGoggles"				, 0			, 1			],
		["Binocular"				, 0			, 1			]
];

/**************************************
*	Item Slots(addType)
*		Gear Items(0)	x12
*		Ruck(1)			xInf
**************************************/
_items = [
	//	["ClassName"				, AddTypeInt, CountInt	],
		["ItemMap"					, 0			, 1			],
		["ItemWatch"				, 0			, 1			],
		["ItemCompass"				, 0			, 1			],
		["ACE_Earplugs"				, 0			, 1			],
		["ACE_GlassesBalaklava"		, 0			, 1			],
		["ACRE_PRC343"				, 0			, 1			],
		["ACE_Map_Tools"			, 1			, 1			],
		["ACE_KeyCuffs"				, 1			, 1			],
		["ACE_GlassesGasMask_RU"	, 1			, 1			]
];

/**************************************
*	Main Magazine Slots(addType)
*		Gear Normal(1)	x12
*		Ruck(1)			xInf
**************************************/
_mainMagazines = [
	//	["ClassName"				, AddTypeInt, CountInt	],
		["30Rnd_556x45_G36"			, 0			, 7			],
		["ACE_30Rnd_556x45_T_G36"	, 0			, 1			],
		["HandGrenade_East"			, 0			, 2			],
		["SmokeShell"				, 0			, 2			],
		["30Rnd_556x45_G36"			, 1			, 2			],
		["ACE_30Rnd_556x45_T_G36"	, 1			, 1			]
];

/**************************************
*	Secondary Magazine Slots(addType)
*		Gear Small(0)	x8
*		Ruck(1)			xInf
**************************************/
_secondaryMagazines = [
	//	["ClassName"				, AddTypeInt, CountInt	],
		["ACE_1Rnd_HE_M203"			, 0			, 8			],
		["ACE_1Rnd_HE_M203"			, 1			, 32		],
		["1Rnd_Smoke_M203"			, 1			, 4			],
		["1Rnd_SmokeGreen_M203"		, 1			, 4			],
		["1Rnd_SmokeRed_M203"		, 1			, 4			],
		["1Rnd_SmokeYellow_M203"	, 1			, 4			],
		["ACE_Bandage"				, 1			, 2			],
		["ACE_LargeBandage"			, 1			, 1			],
		["ACE_Morphine"				, 1			, 1			],
		["ACE_Epinephrine"			, 1			, 1			]
];

/**************************************
*	IFAK
**************************************/
_ifak = [
	1,			// Slot 1
	1,			// Slot 2
	1,			// Slot 3
	true		// Set(true) or Add(false)
];

//------------------------------------------------------------

_result = [_unit, (_weapons + _optics + _items), (_mainMagazines + _secondaryMagazines), _ifak];

_result