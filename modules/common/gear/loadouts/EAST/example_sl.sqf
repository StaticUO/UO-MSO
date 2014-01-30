
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
		["ACE_G3A3_RSAS_F"			, 0			, 1			],
		["glock17_EP1"				, 0			, 1			],
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
		["ACE_Rangefinder_OD"		, 0			, 1			]
];

/**************************************
*	Item Slots(addType)
*		Gear Items(0)	x12
*		Ruck(1)			xInf
**************************************/
_items = [
	//	["ClassName"				, AddTypeInt, CountInt	],
		["ItemMap"					, 0			, 1			],
		["ItemGPS"					, 0			, 1			],
		["ItemWatch"				, 0			, 1			],
		["ItemCompass"				, 0			, 1			],
		["ACE_DAGR"					, 0			, 1			],
		["ACE_Earplugs"				, 0			, 1			],
		["ACE_GlassesBalaklava"		, 0			, 1			],
		["ACRE_PRC343"				, 0			, 1			],
		["ACRE_PRC148"				, 0			, 1			],
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
		["ACE_20Rnd_762x51_B_G3"	, 0			, 7			],
		["ACE_20Rnd_762x51_T_G3"	, 0			, 1			],
		["HandGrenade_East"			, 0			, 2			],
		["SmokeShell"				, 0			, 2			],
		["ACE_20Rnd_762x51_B_G3"	, 1			, 6			],
		["ACE_20Rnd_762x51_T_G3"	, 1			, 2			],
		["ACE_Battery_Rangefinder"	, 1			, 2			],
		["HandGrenade_East"			, 1			, 2			],
		["SmokeShellGreen"			, 1			, 2			],
		["SmokeShellRed"			, 1			, 2			],
		["SmokeShellPurple"			, 1			, 2			],
		["SmokeShellBlue"			, 1			, 2			]
];

/**************************************
*	Secondary Magazine Slots(addType)
*		Gear Small(0)	x8
*		Ruck(1)			xInf
**************************************/
_secondaryMagazines = [
	//	["ClassName"				, AddTypeInt, CountInt	],
		["17Rnd_9x19_glock17"		, 0			, 4			],
		["17Rnd_9x19_glock17"		, 1			, 2			],
		["ACE_Knicklicht_B"			, 1			, 4			],
		["ACE_Knicklicht_G"			, 1			, 4			],
		["ACE_Knicklicht_R"			, 1			, 4			],
		["ACE_Knicklicht_Y"			, 1			, 4			],
		["ACE_Knicklicht_IR"		, 1			, 4			],
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