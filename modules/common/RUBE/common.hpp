/***
 * RUBE dialog macros
 */

// length, position and offset macros
// to simplify the definition of dialog controls
#define RUBE_CRAT safeZoneW / safeZoneH

#define RUBE_CLEN_X(value) safeZoneW * value
#define RUBE_CLEN_Y(value) safeZoneH * value
#define RUBE_COFF_X(width)  (safeZoneW - RUBE_CLEN_X(width)) * 0.5
#define RUBE_COFF_Y(height) (safeZoneH - RUBE_CLEN_Y(height)) * 0.5
#define RUBE_CPOS_X(value, width)  safeZoneX + RUBE_COFF_X(width) + RUBE_CLEN_X(value)
#define RUBE_CPOS_Y(value, height) safeZoneY + RUBE_COFF_Y(height) + RUBE_CLEN_Y(value)


/***
 * RUBE common definitions/constants
 */
 
#ifndef _RUBE_COMMON_DEFS_HPP
#define _RUBE_COMMON_DEFS_HPP

// fonts
/*
	available fonts in ArmA2:
		LucidaConsoleB
		Zeppelin33
		Zeppelin33Italic
		Zeppelin32
		EtelkaNarrowMediumPro
		Bitstream
		TahomaB
		EtelkaMonospaceProBold	
*/
#define RUBE_FONT_MONOSPACE          "Bitstream"
#define RUBE_FONT_DEFAULT            "TahomaB"
#define RUBE_FONT_HTML            	 "Zeppelin32"
#define RUBE_FONT_HTML_BOLD        	 "Zeppelin32"

#define RUBE_FONT_SIZE_SMALL          0.0208333
#define RUBE_FONT_SIZE_NORMAL         0.02474
#define RUBE_FONT_SIZE_BIG            0.0325521

// colors
#define RUBE_COLOR_TRANSPARENT        {1, 1, 1, 0}
#define RUBE_COLOR_BLACK              {0, 0, 0, 1}
#define RUBE_COLOR_WHITE              {1, 1, 1, 1}

#define RUBE_COLOR_TEXT               {0.02, 0.02, 0.02, 1}
#define RUBE_COLOR_TEXT_DISABLED      {0.3, 0.3, 0.3, 0.8}
#define RUBE_COLOR_TEXT_FOCUSED       {0, 0, 0, 1}
#define RUBE_COLOR_TEXT_SELECT        {0, 0, 0, 1}
#define RUBE_COLOR_BG                 {0.45, 0.45, 0.45, 1.0}
#define RUBE_COLOR_BG_FOCUSED         {0.48, 0.48, 0.48, 1.0}
#define RUBE_COLOR_BG_ACTIVE          {0.52, 0.52, 0.52, 1.0}
#define RUBE_COLOR_BG_SELECT          {0.52, 0.52, 0.52, 1.0}
#define RUBE_COLOR_BG_DISABLED        {0.31, 0.31, 0.31, 1.0}
#define RUBE_COLOR_BORDER             {0.107, 0.107, 0.107, 1.0}
#define RUBE_COLOR_SHADOW             {0.03, 0.05, 0.05, 0.67}

#define RUBE_COLOR_SCROLLBAR          {0.1, 0.1, 0.1, 1}
#define RUBE_COLOR_SCROLLBAR_HANDLE   {0, 0, 0, 1}
#define RUBE_COLOR_SCROLLBAR_ACTIVE   {0, 0, 0, 1}
#define RUBE_COLOR_SCROLLBAR_DISABLED {0.3, 0.3, 0.3, 0.6}

// default element/control size
#define RUBE_DEFAULT_ELEMENT_X 		  0.17
#define RUBE_DEFAULT_ELEMENT_Y 		  0.04
#define RUBE_DEFAULT_ELEMENT_WIDTH    RUBE_CLEN_X(RUBE_DEFAULT_ELEMENT_X)
#define RUBE_DEFAULT_ELEMENT_HEIGHT   RUBE_CLEN_Y(RUBE_DEFAULT_ELEMENT_Y)


/***
 * RUBE controls
 */

class RUBE_GUI_TEXT 
{
   type = RUBE_CT_STATIC;
   idc = -1;
   style = RUBE_ST_LEFT;
   colorText[] = RUBE_COLOR_TEXT;
   colorSelection[] = RUBE_COLOR_TEXT_SELECT;
   colorBackground[] = RUBE_COLOR_TRANSPARENT;
   font = RUBE_FONT_DEFAULT;
   sizeEx = RUBE_FONT_SIZE_NORMAL;
   
   x = 0;
   y = 0;
   w = RUBE_DEFAULT_ELEMENT_WIDTH;
   h = RUBE_DEFAULT_ELEMENT_HEIGHT;
   
   text = "";
};

class RUBE_GUI_TEXT_MONO : RUBE_GUI_TEXT
{
	font = RUBE_FONT_MONOSPACE;
	colorBackground[] = RUBE_COLOR_WHITE;
};

class RUBE_GUI_TEXT_MULTI : RUBE_GUI_TEXT
{
	style = RUBE_ST_MULTI;
	lineSpacing = 1;
};

class RUBE_GUI_TEXT_STRUCTURED : RUBE_GUI_TEXT
{
	type = RUBE_CT_STRUCTURED_TEXT;
	size = RUBE_FONT_SIZE_NORMAL;
	
	class Attributes 
	{ 
		font = RUBE_FONT_DEFAULT; 
		color = "#000000"; 
		align = "left"; 
		valign = "middle"; 
		shadow = false; 
		shadowColor = "#000000"; 
		size = "1"; 
	};
};

class RUBE_GUI_LABEL : RUBE_GUI_TEXT 
{
   sizeEx = RUBE_FONT_SIZE_SMALL;
   colorText[] = RUBE_COLOR_WHITE;
};

class RUBE_GUI_TITLE : RUBE_GUI_TEXT
{
   sizeEx = RUBE_FONT_SIZE_BIG;
   colorText[] = RUBE_COLOR_WHITE;
};

class RUBE_GUI_TEXTFIELD : RUBE_GUI_TEXT
{
   type = RUBE_CT_EDIT;
   autocomplete = false;
   colorBackground[] = RUBE_COLOR_BG;
};

class RUBE_GUI_HTML : RUBE_GUI_TEXT
{
	type = RUBE_CT_HTML;

	cycleLinks = 0;
	cycleAllLinks = 0;
	default = 0;
	filename = "";
	
	colorBold[] = {1, 0, 0, 1};
	colorLink[] = {0, 0, 1, 1};
	colorLinkActive[] = {1, 0, 0, 1};
	colorPicture[] = {1, 1, 1, 1};
	colorPictureBorder[] = {1, 0, 0, 1}; 
	colorPictureLink[] = {0, 0, 1, 1}; 
	colorPictureSelected[] = {0, 1, 0, 1};
	
	prevPage = "\ca\ui\data\arrow_left_ca.paa"; 
	nextPage = "\ca\ui\data\arrow_right_ca.paa";
	
	class H1 
	{ 
		font = RUBE_FONT_HTML; 
		fontBold = RUBE_FONT_HTML_BOLD;
		sizeEx = RUBE_FONT_SIZE_BIG * 1.67; 
		align = "left";
		//color = {0, 0, 0, 0};
		//colorText = {1, 0, 0, 1};
	}; 
	
	class H2 
	{ 
		font = RUBE_FONT_HTML; 
		fontBold = RUBE_FONT_HTML_BOLD;
		sizeEx = RUBE_FONT_SIZE_BIG; 
		align = "left";
	}; 
	
	class H3 
	{ 
		font = RUBE_FONT_HTML; 
		fontBold = RUBE_FONT_HTML_BOLD;
		sizeEx = RUBE_FONT_SIZE_NORMAL; 
		align = "left";
	}; 
	
	class H4 
	{ 
		font = RUBE_FONT_HTML; 
		fontBold = RUBE_FONT_HTML_BOLD;
		sizeEx = RUBE_FONT_SIZE_NORMAL; 
		align = "left";
	}; 
	
	class H5 
	{ 
		font = RUBE_FONT_HTML; 
		fontBold = RUBE_FONT_HTML_BOLD; 
		sizeEx = RUBE_FONT_SIZE_NORMAL; 
		align = "left";
	}; 
	
	class H6 
	{ 
		font = RUBE_FONT_HTML; 
		fontBold = RUBE_FONT_HTML_BOLD;
		sizeEx = RUBE_FONT_SIZE_NORMAL; 
		align = "left";
	}; 
	
	class P 
	{ 
		font = RUBE_FONT_HTML; 
		fontBold = RUBE_FONT_HTML_BOLD; 
		sizeEx = RUBE_FONT_SIZE_SMALL; 
		align = "left";
	}; 
};

class RUBE_GUI_IMAGE : RUBE_GUI_TEXT 
{
   style = RUBE_ST_PICTURE;
   colorText[] = RUBE_COLOR_WHITE;
   
   soundClick[] = {"", 0, 1};
   soundEnter[] = {"", 0, 1};
   soundEscape[] = {"", 0, 1};
   soundPush[] = {"", 0, 1};
};

class RUBE_GUI_IMAGE_KAR : RUBE_GUI_TEXT 
{
   style = RUBE_ST_PICTURE + RUBE_ST_KEEP_ASPECT_RATIO;
   colorText[] = RUBE_COLOR_WHITE;
};

class RUBE_GUI_TEXTURE : RUBE_GUI_TEXT
{
   style = RUBE_ST_TILE_PICTURE;
   colorText[] = RUBE_COLOR_WHITE;
};

class RUBE_GUI_BUTTON 
{
   type = RUBE_CT_BUTTON;
   idc = -1;
   style = RUBE_ST_CENTER;
   borderSize = 0;

   colorText[] = RUBE_COLOR_TEXT;
   colorDisabled[] = RUBE_COLOR_TEXT_DISABLED;
   colorFocused[] = RUBE_COLOR_BG_FOCUSED;
   colorBackground[] = RUBE_COLOR_BG;
   colorBackgroundActive[] = RUBE_COLOR_BG_ACTIVE;
   colorBackgroundDisabled[] = RUBE_COLOR_BG_DISABLED;
   colorShadow[] = RUBE_COLOR_SHADOW;
   colorBorder[] = RUBE_COLOR_BORDER;

   font = RUBE_FONT_DEFAULT;
   sizeEx = RUBE_FONT_SIZE_NORMAL;
   
   /*
   offsetX = 0.002;
   offsetY = 0.002;
   offsetPressedX = 0.0005;
   offsetPressedY = 0.0005;
   */
   
   offsetX = 0;
   offsetY = 0;
   offsetPressedX = 0;
   offsetPressedY = 0;
   
   soundEnter[] = {"\ca\ui\data\sound\mouse2",0.08,1};
   soundPush[] = {"\ca\ui\data\sound\new1", 0.09, 1};
   soundClick[] = {"\ca\ui\data\sound\mouse3", 0.07, 1};
   soundEscape[] = {"\ca\ui\data\sound\mouse1",0.08,1};

   default = false;
   text = "";   
	
   w = RUBE_DEFAULT_ELEMENT_WIDTH;
   h = RUBE_DEFAULT_ELEMENT_HEIGHT; 
};

class RUBE_GUI_CHECKBOX 
{
   type = RUBE_CT_CHECKBOXES;
   idc = -1;
   style = RUBE_ST_CENTER;
   
   colorText[] = RUBE_COLOR_TEXT;
   colorDisabled[] = RUBE_COLOR_TEXT_DISABLED;
   colorFocused[] = RUBE_COLOR_TEXT_FOCUSED;
   colorBackground[] = RUBE_COLOR_BG;
   colorBackgroundActive[] = RUBE_COLOR_BG_ACTIVE;
   colorBackgroundDisabled[] = RUBE_COLOR_BG_DISABLED;
   colorShadow[] = RUBE_COLOR_SHADOW;
   colorBorder[] = RUBE_COLOR_BORDER;
   
   font = RUBE_FONT_DEFAULT;
   sizeEx = RUBE_FONT_SIZE_NORMAL;
   
   offsetX = ;
   offsetY = ;
   offsetPressedX = ;
   offsetPressedY = ;
	
   w = RUBE_DEFAULT_ELEMENT_WIDTH;
   h = RUBE_DEFAULT_ELEMENT_HEIGHT; 
};

class RUBE_GUI_LIST 
{
   idc = -1;
   style = RUBE_ST_LEFT;
   
   colorBackground[] = RUBE_COLOR_BG;
   colorSelectBackground[] = RUBE_COLOR_BG_SELECT;
   colorSelect[] = RUBE_COLOR_TEXT_SELECT;
   colorText[] = RUBE_COLOR_TEXT;
   
   color[] = RUBE_COLOR_SCROLLBAR;
   colorActive[] = RUBE_COLOR_SCROLLBAR_ACTIVE;
   colorDisabled[] = RUBE_COLOR_SCROLLBAR_DISABLED;
   
   colorFocused[] = RUBE_COLOR_TEXT_FOCUSED;
   colorShadow[] = RUBE_COLOR_SHADOW;
   colorBorder[] = RUBE_COLOR_BORDER;
	
   borderSize = 1;
   
   font = RUBE_FONT_DEFAULT;
   sizeEx = RUBE_FONT_SIZE_NORMAL;
   rowHeight = RUBE_DEFAULT_ELEMENT_HEIGHT;
   
   soundSelect[] = {"\ca\ui\data\sound\new1", 0.09, 1};
   soundExpand[] = {"\ca\ui\data\sound\new1", 0.07, 1};
   soundCollapse[] = {"\ca\ui\data\sound\new1", 0.07, 1};
	
   maxHistoryDelay = 10;
	
   autoScrollSpeed = -1;
   autoScrollDelay = 5;
   autoScrollRewind = 0;
	
   w = RUBE_DEFAULT_ELEMENT_WIDTH;
   h = RUBE_DEFAULT_ELEMENT_HEIGHT; 
};

class RUBE_GUI_LIST_BOX : RUBE_GUI_LIST 
{
   type = RUBE_CT_LISTBOX;
   
   colorScrollbar[] = RUBE_COLOR_SCROLLBAR_HANDLE;
   period = 1;
   
   class ScrollBar
   {
      color[] = RUBE_COLOR_SCROLLBAR;
      colorActive[] = RUBE_COLOR_SCROLLBAR_ACTIVE;
      colorDisabled[] = RUBE_COLOR_SCROLLBAR_DISABLED;
      thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
      arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
      arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
      border = "\ca\ui\data\ui_border_scroll_ca.paa";
   };
};

class RUBE_GUI_COMBO_BOX : RUBE_GUI_LIST 
{
   type = RUBE_CT_COMBO;
   wholeHeight = 0.3;
   
   colorScrollbar[] = RUBE_COLOR_SCROLLBAR_HANDLE;
   period = 1;
   
   thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
   arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
   arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
   border = "\ca\ui\data\ui_border_scroll_ca.paa";
	
   class ScrollBar
   {
      color[] = RUBE_COLOR_SCROLLBAR;
      colorActive[] = RUBE_COLOR_SCROLLBAR_ACTIVE;
      colorDisabled[] = RUBE_COLOR_SCROLLBAR_DISABLED;
      thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
      arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
      arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
      border = "\ca\ui\data\ui_border_scroll_ca.paa";
   };
};

class RUBE_GUI_SLIDER 
{
   idc = -1;
   type = RUBE_CT_SLIDER;
   style = RUBE_SL_HORZ;
   
   color[] = RUBE_COLOR_SCROLLBAR_HANDLE;
   colorActive[] = RUBE_COLOR_SCROLLBAR_ACTIVE;
   
   soundSelect[] = {"",0.1,1};
   soundExpand[] = {"",0.1,1};
   soundCollapse[] = {"",0.1,1};
	
   w = RUBE_DEFAULT_ELEMENT_WIDTH;
   h = RUBE_DEFAULT_ELEMENT_HEIGHT;
};

class RUBE_GUI_CONTROLGROUP
{
	idc = -1;
	type = RUBE_CT_CONTROLS_GROUP;
	style = RUBE_CT_STATIC;
	
   x = 0;
   y = 0;
   w = RUBE_DEFAULT_ELEMENT_WIDTH;
   h = RUBE_DEFAULT_ELEMENT_HEIGHT;
   
   class VScrollbar
   {
   	color[] = RUBE_COLOR_SCROLLBAR;
   	width = 0.021;
   	autoScrollSpeed = -1;
   	autoScrollDelay = 5;
   	autoScrollRewind = 0;
   };
   
   class HScrollbar
   {
   	color[] = RUBE_COLOR_SCROLLBAR;
   	height = 0.028;
   };
   
   class ScrollBar
   {
      color[] = RUBE_COLOR_SCROLLBAR;
      colorActive[] = RUBE_COLOR_SCROLLBAR_ACTIVE;
      colorDisabled[] = RUBE_COLOR_SCROLLBAR_DISABLED;
      thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
      arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
      arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
      border = "\ca\ui\data\ui_border_scroll_ca.paa";
   };
   
   class Controls {};
};

class RUBE_GUI_PANEL
{
   movingEnable = false;
   fadein = 2;
   fadeout = 2;
   duration=10e10;
   
   controlsBackground[] =
   {
      BackgroundPanel
   };
   
   class BackgroundPanel : RUBE_GUI_TEXT
   {
      borderSize = 0;
      colorBackground[] = RUBE_COLOR_BG_ACTIVE;
      colorShadow[] = RUBE_COLOR_SHADOW;
      colorBorder[] = RUBE_COLOR_BORDER;
   };
};

/***
 * RUBE dialogs
 */
 
#include "dialogs\splash.hpp"
#include "dialogs\supplies.hpp"

// modules
#include "modules\weather\dialogs\weatherReport.hpp"

#endif