
#define SETUP_START_TEXT	("<t size=3 align=left>You Have </t><t size=3 color='#6599FF' shadow='1' shadowColor='#000000' align=left>" + (str _delay) + "</t><t size=3 align=left> Seconds Setup Time.</t>")
#define SETUP_OOB_TEXT		("The Setup Area Ends Here.")
#define SETUP_END_TEXT		("<t size=3 align=left>SETUP COMPLETE!</t>")

private ["_unit", "_index", "_sa", "_marker", "_delay", "_enabled", "_xOverOld", "_yOverOld"];

_unit		= _this select 0;
_index		= _this select 1;
_wait		= if ((count _this) > 2) then {_this select 2} else {-1};
_sa			= sa_setupAreas select _index;
_marker		= _sa select 0;
_delay		= _sa select 1;
_enabled	= _sa select 2;
_xOverOld	= 0;
_yOverOld	= 0;

if (_wait > 0) then {sleep _wait};

hint (parsetext SETUP_START_TEXT);

while {_enabled} do {
	
	private ["_pos", "_size", "_dir", "_sleep", "_playerVeh", "_xSize", "_ySize", "_disabled"];
	_pos		= getMarkerPos _marker;
	_size		= getMarkerSize _marker;
	_dir		= (markerDir _marker) % 360;
	_sleep		= 10;
	_playerVeh	= objNull;
	_xSize		= _size select 0;
	_ySize		= _size select 1;
	_disabled	= false;
	
	if ((vehicle _unit) == _unit) then { // on foot
		_playerVeh = _unit;
	} else { // in a vehicle
		if (((driver (vehicle _unit)) == _unit) && !((vehicle _unit) isKindOf "Air")) then { // _unit is driving NOT flying
			_playerVeh = vehicle _unit;
		} else { // _unit is passenger OR flying
			_disabled = true;
			_sleep = 1;
		};
	};
	
	if (!_disabled) then {
		private ["_playerPos", "_x", "_y", "_cos", "_sin", "_x2", "_y2", "_xOver", "_yOver"];
		
		_playerPos	= getPos _playerVeh;
		_x			= (_playerPos select 0) - (_pos select 0);
        _y			= (_playerPos select 1) - (_pos select 1);
		_cos		= cos(_dir);
		_sin		= sin(_dir);
		_x2 		= (_cos * _x) - (_sin * _y);
        _y2 		= (_sin * _x) + (_cos * _y);
        _xOver		= 0;
		_yOver		= 0;
		
        if (_x2 > _xSize) then {
			_xOver = _x2 - _xSize;
        } else {
			if (_x2 < (_xSize * -1)) then {
				_xOver = (_x2 * -1) - _xSize;
			};
		};
        
        if (_y2 > _ySize) then {
			_yOver = _y2 - _ySize;
        } else {
			if (_y2 < (_ySize * -1)) then {
				_yOver = (_y2 * -1) - _ySize;
			};
		};

        if ((_xOver > (_xOverOld + 0.1)) || (_yOver > (_yOverOld + 0.1))) then {
			
			hint (parseText SETUP_OOB_TEXT);
			
			if (_unit == (vehicle _unit)) then {
				_unit playMove "AmovPpneMstpSrasWrflDnon";
			};
			
			_playerVeh setVelocity [0,0,0];
        };
		
        _xOverOld = _xOver;
        _yOverOld = _yOver;
        
        if (_x2 > (_xSize - 100)) then {
			_sleep = 0.2;
        } else {
			if (_x2 < ((_xSize - 100) * -1)) then {
				_sleep = 0.2;
			};
		};
		
        if (_y2 > (_ySize - 100)) then {
			_sleep = 0.2;
        } else {
			if (_y2 < ((_ySize - 100) * -1)) then {
				_sleep = 0.2;
			};
		};
	};
	
	sleep _sleep;
	
	// Reload Variables
	_sa			= sa_setupAreas select _index;
	_marker		= _sa select 0;
	_delay		= _sa select 1;
	_enabled	= _sa select 2;
};

/* End Setup */
_marker setMarkerAlphaLocal 0;
hint (parsetext SETUP_END_TEXT);
