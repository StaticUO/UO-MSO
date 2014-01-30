
private ["_step", "_players", "_playerCount", "_return"];

_step			= _this select 0;
_players		= call CBA_fnc_players;
_playerCount	= count _players;
_selection		= gdtmod_seagull_players_select;
_return			= ['gdtmod_specPen', objNull] call CORE_fnc_getVariable;

if (_playerCount > 0) then {
	
	private ["_loopCount", "_selectedPlayer"];
	_loopCount = 0;
	_selectedPlayer	= _players select _selection;
	
	while {!(['gdtmod_isValidTarget', [_selectedPlayer]] call CORE_fnc_callFunction) && (_loopCount < _playerCount)} do {
		private ["_selection"];
		_selection = _selection + _step;
		_loopCount = _loopCount + _step;
		if (_selection < 0) then {_selection = (_playerCount - 1)};
		if (_selection > (_playerCount - 1)) then {_selection = 0};
		_selectedPlayer	= _players select _selection;
	};
	
	if (['gdtmod_isValidTarget', [_selectedPlayer]] call CORE_fnc_callFunction) then {
		_return = vehicle _selectedPlayer;
		gdtmod_seagull_players_select = _selection;
	};
};

gdtmod_seagull_target = _return;

_return