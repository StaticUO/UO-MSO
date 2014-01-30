class RUBE_SplashScreen : RUBE_GUI_PANEL
{
   idd = RUBE_IDC_SPLASH_dialog;
   
   class controlsBackground 
   {
      class Background : BackgroundPanel
      {
         x = safeZoneX;
         y = safeZoneY;
         w = safeZoneW;
         h = safeZoneH;
         
         colorBackground[] = RUBE_COLOR_BLACK;
      };
   };
   
   class controls
   {
      class RubeSplash : RUBE_GUI_IMAGE
      {
         idc = RUBE_IDC_SPLASH_image;
         
         style = RUBE_ST_PICTURE + RUBE_ST_KEEP_ASPECT_RATIO;
         text = "modules\common\RUBE\dialogs\rube.paa";
         colorBackground[] = RUBE_COLOR_BLACK;
         x = 0.2;
         y = 0.2;
         h = 0.6;
         w = 0.6;
      };
      
      class RubeText : RUBE_GUI_TITLE
      {
         idc = RUBE_IDC_SPLASH_title;
         
         x = 0.25;
         y = 0.67;
         h = 0.5;
         w = 0.5;
         
         style = RUBE_ST_CENTER;
         colorText[] = {1, 1, 1, 0};
         text = "RUBE presents";
      };
   };
};