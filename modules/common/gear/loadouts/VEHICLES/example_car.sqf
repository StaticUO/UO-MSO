
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
];

/**************************************
*	Vehicle Magazines
*		Vehicle(0)			xInf
*		Cargo(2)			xInf
**************************************/
_magazines = [
	//	["ClassName"				, typeInt	, CountInt	],
];

//------------------------------------------------------------

_result = [_veh, _weapons, _magazines];

_result