/*
   Author:
    rübe
    
   Description:
    selects custom code from a given code pool by running their
    coef/test-functions and selecting the best one. If no rating
    is greater than 0, empty code will be returned.
    
    Usually used in fsms to select from code pools from 
     - RUBE\aicoef (coef/test functions) and 
     - RUBE\aisr (subroutines/custom code)
    
   Parameters:
    _this select 0: group (group)
    _this select 1: subroutines/custom code pool (array of [test-code, custom-code])
                    - test-code takes group as _this and returns scalar
                    - custom-code takes group as _this, returns void
    
   Returns:
    code
*/
 
private ["_group", "_subroutines", "_index", "_rating", "_i", "_r"];

_group = _this select 0;
_subroutines = _this select 1;

_index = 0;
_rating = -1;
	
for "_i" from 0 to ((count _subroutines) - 1) do
{
   _r = _group call ((_subroutines select _i) select 0);
   if (_r > _rating) then
   {
      _rating = _r;
      _index = _i;
   };
};

// skip adv. duty then...
if (_rating <= 0) exitWith
{
	{}
};

((_subroutines select _index) select 1)