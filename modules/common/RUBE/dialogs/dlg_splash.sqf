/*
   RUBE splash screen
   
   - how to run RUBE splash screen:
   
      // RUBE splash screen
      RUBE_SPLASH_SCREEN = false;
      [] execVM "modules\common\RUBE\dialogs\dlg_splash.sqf";

      waitUntil { RUBE_SPLASH_SCREEN };
      waitUntil { !dialog };
      
      // fade in and so on...
      cutText ["", "BLACK IN", 5];
      
*/
#include "core.hpp"
#include "x-rubeSplashScreen.hpp"
disableSerialization;

titleCut["", "BLACK FADED", 999];
RUBE_SPLASH_SCREEN = createDialog "RUBE_SplashScreen"; 

_splashScreen = (findDisplay RUBE_IDC_SPLASH_dialog) displayCtrl RUBE_IDC_SPLASH_image;
_splashTitle = (findDisplay RUBE_IDC_SPLASH_dialog) displayCtrl RUBE_IDC_SPLASH_title;

sleep 2.5;

// evil laugh and machine gun fire, 
// har har  :D
//
// |- 1.95s -| |- 1.79s -| |- 2.65 -|
//   laughing    mg fire     outro

//playSound "RUBE_Splash"; // Removed for script version
sleep 1.947;

for "_i" from 0 to 29 do
{
   _splashScreen ctrlSetTextColor [1, 1, 1, (random 1.0)];
   sleep (random 0.05);
   
   if (_i == 14) then
   {
      sleep (0.1 + (random 0.2));
   };
};

for "_i" from 0 to 4 do
{
   _splashScreen ctrlSetTextColor [1, 1, 1, (random 1.0)];
   _splashTitle ctrlSetTextColor [1, 1, 1, (random 1.0)];
   sleep (random 0.05);
};

_splashScreen ctrlSetTextColor [1, 1, 1, 0];
_splashTitle ctrlSetTextColor [1, 1, 1, 1];

sleep 0.2;
_iter = 32;
_sleep = 2.25 / _iter;
for "_i" from 1 to _iter do
{
   _splashTitle ctrlSetTextColor [1, 1, 1, ((_iter - _i) / _iter)];
   sleep _sleep;
};

sleep 1;

closeDialog RUBE_IDC_SPLASH_dialog;
RUBE_SPLASH_SCREEN = false;