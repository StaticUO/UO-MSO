#define RUBE_D_WeatherScreenW 0.66
#define RUBE_D_WeatherScreenH 0.5
#define RUBE_D_WeatherBlockW RUBE_D_WeatherScreenW / 25
#define RUBE_D_WeatherBlockH RUBE_D_WeatherScreenH / 18


/**
 * symbols & icons
 */
 
// big symbol: today's weather
class RUBE_WeatherReportSymbol : RUBE_GUI_IMAGE_KAR
{
   text = "modules\common\RUBE\modules\weather\icons\empty.paa";
   
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW, RUBE_D_WeatherScreenW);
   y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 4, RUBE_D_WeatherScreenH);
   w = RUBE_CLEN_X(RUBE_D_WeatherBlockW * 5);
   h = RUBE_CLEN_Y(RUBE_D_WeatherBlockH * 5);
};

// small symbols: weather forecast
class RUBE_WeatherReportSymbol2 : RUBE_WeatherReportSymbol
{
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW, RUBE_D_WeatherScreenW);
   y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 13, RUBE_D_WeatherScreenH);
   w = RUBE_CLEN_X(RUBE_D_WeatherBlockW * 3);
   h = RUBE_CLEN_Y(RUBE_D_WeatherBlockH * 3);
};

class RUBE_WeatherReportSymbol3 : RUBE_WeatherReportSymbol2
{
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 5, RUBE_D_WeatherScreenW);
};

class RUBE_WeatherReportSymbol4 : RUBE_WeatherReportSymbol2
{
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 9, RUBE_D_WeatherScreenW);
};

class RUBE_WeatherReportSymbol5 : RUBE_WeatherReportSymbol2
{
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 13, RUBE_D_WeatherScreenW);
};

class RUBE_WeatherReportSymbol6 : RUBE_WeatherReportSymbol2
{
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 17, RUBE_D_WeatherScreenW);
};

class RUBE_WeatherReportSymbol7 : RUBE_WeatherReportSymbol2
{
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 21, RUBE_D_WeatherScreenW);
};

// weather report icons
class RUBE_WeatherReportIcon : RUBE_WeatherReportSymbol
{
   w = RUBE_CLEN_X(RUBE_D_WeatherBlockW * 2);
   h = RUBE_CLEN_Y(RUBE_D_WeatherBlockH * 2);
};


/**
 * text, titles & labels
 */

// main (and sub-)title 
class RUBE_WeatherReportTitle : RUBE_GUI_TITLE
{
   colorText[] = RUBE_COLOR_BLACK;
   
   w = RUBE_CLEN_X(RUBE_D_WeatherBlockW * 11);
   h = RUBE_CLEN_Y(RUBE_D_WeatherBlockH * 2);
};

// todays weather report text 
class RUBE_WeatherReportLabel : RUBE_GUI_LABEL
{
   colorText[] = RUBE_COLOR_BLACK;
      
   w = RUBE_CLEN_X(RUBE_D_WeatherBlockW * 4);
   h = RUBE_CLEN_Y(RUBE_D_WeatherBlockH);
};

// ... and values/data-output-fields
class RUBE_WeatherReportValue : RUBE_WeatherReportLabel
{

};


// forecast titles
class RUBE_WeatherReportF2Title : RUBE_WeatherReportLabel
{
   style = RUBE_ST_CENTER;
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 1, RUBE_D_WeatherScreenW);
   y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 12, RUBE_D_WeatherScreenH);
   w = RUBE_CLEN_X(RUBE_D_WeatherBlockW * 3);
};

class RUBE_WeatherReportF3Title : RUBE_WeatherReportF2Title 
{
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 5, RUBE_D_WeatherScreenW);
};

class RUBE_WeatherReportF4Title : RUBE_WeatherReportF2Title 
{
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 9, RUBE_D_WeatherScreenW);
};

class RUBE_WeatherReportF5Title : RUBE_WeatherReportF2Title 
{
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 13, RUBE_D_WeatherScreenW);
};

class RUBE_WeatherReportF6Title : RUBE_WeatherReportF2Title 
{
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 17, RUBE_D_WeatherScreenW);
};

class RUBE_WeatherReportF7Title : RUBE_WeatherReportF2Title 
{
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 21, RUBE_D_WeatherScreenW);
};

// forecast labels
class RUBE_WeatherReportF2Label : RUBE_WeatherReportValue
{
   style = RUBE_ST_CENTER;
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 1, RUBE_D_WeatherScreenW);
   y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 16, RUBE_D_WeatherScreenH);
   w = RUBE_CLEN_X(RUBE_D_WeatherBlockW * 3);
};

class RUBE_WeatherReportF3Label : RUBE_WeatherReportF2Label
{
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 5, RUBE_D_WeatherScreenW);
};

class RUBE_WeatherReportF4Label : RUBE_WeatherReportF2Label
{
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 9, RUBE_D_WeatherScreenW);
};

class RUBE_WeatherReportF5Label : RUBE_WeatherReportF2Label
{
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 13, RUBE_D_WeatherScreenW);
};

class RUBE_WeatherReportF6Label : RUBE_WeatherReportF2Label
{
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 17, RUBE_D_WeatherScreenW);
};

class RUBE_WeatherReportF7Label : RUBE_WeatherReportF2Label
{
   x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 21, RUBE_D_WeatherScreenW);
};





/**
 * weather report/forecast dialog
 */
class RUBE_WeatherReportDialog : RUBE_GUI_PANEL
{
   idd = -1;
   
   onLoad = "uiNamespace setVariable ['RUBE_weatherReport', (_this select 0)]";
   onUnload = "uiNamespace setVariable ['RUBE_weatherReport', nil]";
      
   class controlsBackground 
   {
      class Background : BackgroundPanel
      {      	
         idc = RUBE_IDC_WEATHERREPORT_bgPanel;
         
         x = RUBE_CPOS_X(0, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(0, RUBE_D_WeatherScreenH);
         w = RUBE_CLEN_X(RUBE_D_WeatherScreenW);
         h = RUBE_CLEN_Y(RUBE_D_WeatherScreenH);
         
         colorBackground[] = {0.98, 0.98, 1, 1};
      };
      
      //
      class d1sun :           RUBE_WeatherReportSymbol   { idc = RUBE_IDC_WEATHERREPORT_S1L0; };
      class d1overcast :      RUBE_WeatherReportSymbol   { idc = RUBE_IDC_WEATHERREPORT_S1L1; };
      class d1precipitation : RUBE_WeatherReportSymbol   { idc = RUBE_IDC_WEATHERREPORT_S1L2; };
      class d1special :       RUBE_WeatherReportSymbol   { idc = RUBE_IDC_WEATHERREPORT_S1L3; };
      
      class d2sun :           RUBE_WeatherReportSymbol2  { idc = RUBE_IDC_WEATHERREPORT_S2L0; };
      class d2overcast :      RUBE_WeatherReportSymbol2  { idc = RUBE_IDC_WEATHERREPORT_S2L1; };
      class d2precipitation : RUBE_WeatherReportSymbol2  { idc = RUBE_IDC_WEATHERREPORT_S2L2; };
      class d2special :       RUBE_WeatherReportSymbol2  { idc = RUBE_IDC_WEATHERREPORT_S2L3; };
      
      class d3sun :           RUBE_WeatherReportSymbol3  { idc = RUBE_IDC_WEATHERREPORT_S3L0; };
      class d3overcast :      RUBE_WeatherReportSymbol3  { idc = RUBE_IDC_WEATHERREPORT_S3L1; };
      class d3precipitation : RUBE_WeatherReportSymbol3  { idc = RUBE_IDC_WEATHERREPORT_S3L2; };
      class d3special :       RUBE_WeatherReportSymbol3  { idc = RUBE_IDC_WEATHERREPORT_S3L3; };
      
      class d4sun :           RUBE_WeatherReportSymbol4  { idc = RUBE_IDC_WEATHERREPORT_S4L0; };
      class d4overcast :      RUBE_WeatherReportSymbol4  { idc = RUBE_IDC_WEATHERREPORT_S4L1; };
      class d4precipitation : RUBE_WeatherReportSymbol4  { idc = RUBE_IDC_WEATHERREPORT_S4L2; };
      class d4special :       RUBE_WeatherReportSymbol4  { idc = RUBE_IDC_WEATHERREPORT_S4L3; };
      
      class d5sun :           RUBE_WeatherReportSymbol5  { idc = RUBE_IDC_WEATHERREPORT_S5L0; };
      class d5overcast :      RUBE_WeatherReportSymbol5  { idc = RUBE_IDC_WEATHERREPORT_S5L1; };
      class d5precipitation : RUBE_WeatherReportSymbol5  { idc = RUBE_IDC_WEATHERREPORT_S5L2; };
      class d5special :       RUBE_WeatherReportSymbol5  { idc = RUBE_IDC_WEATHERREPORT_S5L3; };
      
      class d6sun :           RUBE_WeatherReportSymbol6  { idc = RUBE_IDC_WEATHERREPORT_S6L0; };
      class d6overcast :      RUBE_WeatherReportSymbol6  { idc = RUBE_IDC_WEATHERREPORT_S6L1; };
      class d6precipitation : RUBE_WeatherReportSymbol6  { idc = RUBE_IDC_WEATHERREPORT_S6L2; };
      class d6special :       RUBE_WeatherReportSymbol6  { idc = RUBE_IDC_WEATHERREPORT_S6L3; };
      
      class d7sun :           RUBE_WeatherReportSymbol7  { idc = RUBE_IDC_WEATHERREPORT_S7L0; };
      class d7overcast :      RUBE_WeatherReportSymbol7  { idc = RUBE_IDC_WEATHERREPORT_S7L1; };
      class d7precipitation : RUBE_WeatherReportSymbol7  { idc = RUBE_IDC_WEATHERREPORT_S7L2; };
      class d7special :       RUBE_WeatherReportSymbol7  { idc = RUBE_IDC_WEATHERREPORT_S7L3; };

   };
   
   class controls
   {
      class reportTitle : RUBE_WeatherReportTitle
      {
         idc = RUBE_IDC_WEATHERREPORT_reportT;
         
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH, RUBE_D_WeatherScreenH);
         
         text = "Weather Report";
      };
      
      
      //
      class tempHiIcon : RUBE_WeatherReportIcon
      {
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 6, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 4, RUBE_D_WeatherScreenH);
         
         text = "modules\common\RUBE\modules\weather\icons\tempHi.paa";
      };
        
      class tempHiTitle : RUBE_WeatherReportLabel
      {
         idc = RUBE_IDC_WEATHERREPORT_thTitle;
         
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 8, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 4, RUBE_D_WeatherScreenH);
         
         text = "Max. Temp.:";
      };
            
      class tempHiText : RUBE_WeatherReportValue
      {
         idc = RUBE_IDC_WEATHERREPORT_thText;
         
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 8, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 5, RUBE_D_WeatherScreenH);
         
         text = "+0' C";
      };
      
      class tempLoIcon : RUBE_WeatherReportIcon
      {
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 6, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 7, RUBE_D_WeatherScreenH);
         
         text = "modules\common\RUBE\modules\weather\icons\tempLo.paa";
      };
      
      class tempLoTitle : RUBE_WeatherReportLabel
      {
         idc = RUBE_IDC_WEATHERREPORT_tlTitle;
         
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 8, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 7, RUBE_D_WeatherScreenH);
         
         text = "Min. Temp.:";
      };
      
      class tempLoText : RUBE_WeatherReportValue
      {
         idc = RUBE_IDC_WEATHERREPORT_tlText;
         
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 8, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 8, RUBE_D_WeatherScreenH);
         
         text = "-0' C";
      };
      
      
      //
      class windSpeedIcon : RUBE_WeatherReportIcon
      {
         idc = RUBE_IDC_WEATHERREPORT_wsIcon;
         
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 12, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 4, RUBE_D_WeatherScreenH);
         
         text = "modules\common\RUBE\modules\weather\icons\wind1.paa";
      };
      
      class windSpeedTitle : RUBE_WeatherReportLabel
      {
         idc = RUBE_IDC_WEATHERREPORT_wsTitle;
         
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 14, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 4, RUBE_D_WeatherScreenH);
         
         text = "Wind Speed:";
      };
      
      class windSpeedText : RUBE_WeatherReportValue
      {
         idc = RUBE_IDC_WEATHERREPORT_wsText;
         
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 14, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 5, RUBE_D_WeatherScreenH);
         
         text = "0 km/h";
      };
      
      
      //
      class windDirIcon : RUBE_WeatherReportIcon
      {
         idc = RUBE_IDC_WEATHERREPORT_wdIcon;
         
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 12, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 7, RUBE_D_WeatherScreenH);
         
         text = "modules\common\RUBE\modules\weather\icons\dir0.paa";
      };
      
      class windDirTitle : RUBE_WeatherReportLabel
      {
         idc = RUBE_IDC_WEATHERREPORT_wdTitle;
         
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 14, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 7, RUBE_D_WeatherScreenH);
         
         text = "Wind Direction:";
      };
      
      class windDirText : RUBE_WeatherReportValue
      {
         idc = RUBE_IDC_WEATHERREPORT_wdText;
         
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 14, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 8, RUBE_D_WeatherScreenH);
         
         text = "N";
      };
      
      
      //
      class sunriseIcon : RUBE_WeatherReportIcon
      {
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 18, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 4, RUBE_D_WeatherScreenH);
         
         text = "modules\common\RUBE\modules\weather\icons\sunrise.paa";
      };
      
      class sunriseTitle : RUBE_WeatherReportLabel
      {
         idc = RUBE_IDC_WEATHERREPORT_srTitle;
         
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 20, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 4, RUBE_D_WeatherScreenH);
         
         text = "Sunrise:";
      };
      
      class sunriseText : RUBE_WeatherReportValue
      {
         idc = RUBE_IDC_WEATHERREPORT_srText;
         
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 20, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 5, RUBE_D_WeatherScreenH);
         
         text = "00:00";
      };
      
      
      class sunsetIcon : RUBE_WeatherReportIcon
      {
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 18, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 7, RUBE_D_WeatherScreenH);
         
         text = "modules\common\RUBE\modules\weather\icons\sunset.paa";
      };
      
      class sunsetTitle : RUBE_WeatherReportLabel
      {
         idc = RUBE_IDC_WEATHERREPORT_ssTitle;
         
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 20, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 7, RUBE_D_WeatherScreenH);
         
         text = "Sunset:";
      };
      
      class sunsetText : RUBE_WeatherReportValue
      {
         idc = RUBE_IDC_WEATHERREPORT_ssText;
         
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW * 20, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 8, RUBE_D_WeatherScreenH);
         
         text = "00:00";
      };

      
      //
      class forecastTitle : RUBE_WeatherReportTitle
      {
         idc = RUBE_IDC_WEATHERREPORT_forecastT;
         
         x = RUBE_CPOS_X(RUBE_D_WeatherBlockW, RUBE_D_WeatherScreenW);
         y = RUBE_CPOS_Y(RUBE_D_WeatherBlockH * 10, RUBE_D_WeatherScreenH);
         h = RUBE_CLEN_Y(RUBE_D_WeatherBlockH);
         
         text = "";
      };
         
      //
      class forecast2T : RUBE_WeatherReportF2Title { idc = RUBE_IDC_WEATHERREPORT_S2T; };
      class forecast2L : RUBE_WeatherReportF2Label { idc = RUBE_IDC_WEATHERREPORT_S2L; };
      
      class forecast3T : RUBE_WeatherReportF3Title { idc = RUBE_IDC_WEATHERREPORT_S3T; };
      class forecast3L : RUBE_WeatherReportF3Label { idc = RUBE_IDC_WEATHERREPORT_S3L; };
      
      class forecast4T : RUBE_WeatherReportF4Title { idc = RUBE_IDC_WEATHERREPORT_S4T; };
      class forecast4L : RUBE_WeatherReportF4Label { idc = RUBE_IDC_WEATHERREPORT_S4L; };
      
      class forecast5T : RUBE_WeatherReportF5Title { idc = RUBE_IDC_WEATHERREPORT_S5T; };
      class forecast5L : RUBE_WeatherReportF5Label { idc = RUBE_IDC_WEATHERREPORT_S5L; };
      
      class forecast6T : RUBE_WeatherReportF6Title { idc = RUBE_IDC_WEATHERREPORT_S6T; };
      class forecast6L : RUBE_WeatherReportF6Label { idc = RUBE_IDC_WEATHERREPORT_S6L; };
      
      class forecast7T : RUBE_WeatherReportF7Title { idc = RUBE_IDC_WEATHERREPORT_S7T; };
      class forecast7L : RUBE_WeatherReportF7Label { idc = RUBE_IDC_WEATHERREPORT_S7L; };
      
   };
};
