
#define OFFSET_X	((sin _dir) * ( - 10))
#define OFFSET_Y	((cos _dir) * ( - 10))
#define OFFSET_Z	2

private ["_obj", "_cam", "_pos", "_dir"];

_obj	= _this select 0;
_cam	= _this select 1;
_pos	= getPos _obj;
_dir	= getDir _obj;

_cam setpos [((_pos select 0) + OFFSET_X), ((_pos select 1) + OFFSET_Y), ((_pos select 2) + OFFSET_Z)];
_cam setdir _dir;

true