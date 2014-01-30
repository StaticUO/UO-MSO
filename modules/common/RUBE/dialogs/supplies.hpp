#define RUBE_D_SupplyScreen_width 0.36
#define RUBE_D_SupplyScreen_height 0.24

class RUBE_SupplyScreen : RUBE_GUI_PANEL
{
	idd = RUBE_IDC_SUPPLYSCREEN_dialog;
	
   class controlsBackground 
   {
      class BackgroundTexture : RUBE_GUI_IMAGE
      {
      	text = "modules\common\RUBE\dialogs\paper.paa";
      	
         x = RUBE_CPOS_X(0, RUBE_D_SupplyScreen_width);
         y = RUBE_CPOS_Y(0, RUBE_D_SupplyScreen_height);
         w = RUBE_CLEN_X(RUBE_D_SupplyScreen_width);
         h = RUBE_CLEN_Y(RUBE_D_SupplyScreen_height);
      };
   };
   
   class controls
   {
   	class LineP1 : RUBE_GUI_TEXT_STRUCTURED
   	{
   		idc = RUBE_IDC_SUPPLYSCREEN_p1;
   		
         x = RUBE_CPOS_X(0, RUBE_D_SupplyScreen_width);
         y = RUBE_CPOS_Y(0, RUBE_D_SupplyScreen_height);
         w = RUBE_CLEN_X(RUBE_D_SupplyScreen_width);
         h = RUBE_DEFAULT_ELEMENT_HEIGHT * 2;
         
         colorBackground[] = RUBE_COLOR_TRANSPARENT;
   	};
   	
   	class LineP2 : RUBE_GUI_TEXT_STRUCTURED
   	{
   		idc = RUBE_IDC_SUPPLYSCREEN_p2;
   		
         x = RUBE_CPOS_X(0, RUBE_D_SupplyScreen_width);
         y = RUBE_CPOS_Y((RUBE_DEFAULT_ELEMENT_Y * 2), RUBE_D_SupplyScreen_height);
         w = RUBE_CLEN_X(RUBE_D_SupplyScreen_width);
         h = RUBE_CLEN_Y(RUBE_D_SupplyScreen_height) - (RUBE_DEFAULT_ELEMENT_HEIGHT * 3);
         
         colorBackground[] = RUBE_COLOR_TRANSPARENT;
   	};
   	
      class CloseButton : RUBE_GUI_BUTTON
      {
         idc = RUBE_IDC_SUPPLYSCREEN_close;
         
         x = RUBE_CPOS_X(0, RUBE_D_SupplyScreen_width);
         y = RUBE_CPOS_Y(RUBE_D_SupplyScreen_height, RUBE_D_SupplyScreen_height) - RUBE_DEFAULT_ELEMENT_HEIGHT;
         w = RUBE_CLEN_X(RUBE_D_SupplyScreen_width);
         
         colorFocused[] = {0, 0, 0, 0.03};
			colorBackground[] = {0, 0, 0, 0.01};
			colorBackgroundActive[] = {0, 0, 0, 0.05};
			colorBackgroundDisabled[] = RUBE_COLOR_TRANSPARENT;
			colorShadow[] = RUBE_COLOR_TRANSPARENT;
         
         text = "< close >";
         onButtonClick = "closeDialog 0;";
      }; 
   };
};