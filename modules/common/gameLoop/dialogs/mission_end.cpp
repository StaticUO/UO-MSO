
// Variable
#define CM_MES_COLUMN_WIDTH		8
#define CM_MES_ROW_HEIGHT		26
#define CM_MES_X_PADDING_RATIO	(1/32)

#define CM_MES_LARGE_BG_RATIO	10

#define CM_MES_BG_COLOR			{0,0,0,1}
#define CM_MES_DIAG_COLOR		{0.2,0.2,0.2,1}
#define CM_MES_FRAME_COLOR		{0.3,0.3,0.3,1}

// Static
#define CM_MES_COL_START		((GUI_COLUMNS - CM_MES_COLUMN_WIDTH) / 2)
#define CM_MES_ROW_START		((GUI_ROWS - CM_MES_ROW_HEIGHT) / 2)

#define CM_MES_COL_END			(CM_MES_COL_START + CM_MES_COLUMN_WIDTH)
#define CM_MES_ROW_END			(CM_MES_ROW_START + CM_MES_ROW_HEIGHT)

#define CM_MES_COL(col)			(CM_MES_COL_START + col)
#define CM_MES_ROW(row)			(CM_MES_ROW_START + row)

#define CM_MES_GET_X(col)		GUI_GET_X(CM_MES_COL(col))
#define CM_MES_GET_Y(row)		GUI_GET_Y(CM_MES_ROW(row))

#define CM_MES_PAD_X_W			(GUI_GET_W(0,CM_MES_COLUMN_WIDTH) * CM_MES_X_PADDING_RATIO)

class cm_missionEndScreen {
	idd = 80123;
	movingEnable = 1;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "[] spawn {['gameLoop_endMissionFunc', gameLoop_endMissionParams] call CORE_fnc_callFunction;};";

	class controls {
		// Background
		class RscBG_1798: RscBackground
		{
			idc = 1798;
			x = GUI_X - (GUI_W * (CM_MES_LARGE_BG_RATIO / 2));
			y = GUI_Y - (GUI_H * (CM_MES_LARGE_BG_RATIO / 2));
			w = GUI_W * CM_MES_LARGE_BG_RATIO;
			h = GUI_H * CM_MES_LARGE_BG_RATIO;
			colorBackground[] = CM_MES_BG_COLOR;
		};
		class RscBG_1799: RscBackground
		{
			idc = 1799;
			x = CM_MES_GET_X(0) - CM_MES_PAD_X_W;
			y = CM_MES_GET_Y(0);
			w = GUI_GET_W(0,CM_MES_COLUMN_WIDTH) + (2 * CM_MES_PAD_X_W);
			h = GUI_GET_H(0,CM_MES_ROW_HEIGHT);
			colorBackground[] = CM_MES_DIAG_COLOR;
		};
		
		// Title and Header
		class RscBG_1800: RscBackground
		{
			idc = 1800;
			moving = 1;
			x = CM_MES_GET_X(0) - CM_MES_PAD_X_W;
			y = CM_MES_GET_Y(0);
			w = GUI_GET_W(0,CM_MES_COLUMN_WIDTH) + (2 * CM_MES_PAD_X_W);
			h = GUI_GET_H(0,1);
			colorBackground[] = CM_MES_FRAME_COLOR;
		};
		class RscText_1000: RscText
		{
			idc = 1000;
			moving = 1;
			text = "Mission Debriefing";
			x = CM_MES_GET_X(0) - CM_MES_PAD_X_W;
			y = CM_MES_GET_Y(0);
			w = GUI_GET_W(0,CM_MES_COLUMN_WIDTH) + (2 * CM_MES_PAD_X_W);
			h = GUI_GET_H(0,1);
			colorBackground[] = CM_MES_FRAME_COLOR;
		};
		
		// Mission End Reason and Description
		class RscBG_1801: RscBackground
		{
			idc = 1801;
			x = CM_MES_GET_X(0);
			y = CM_MES_GET_Y(2);
			w = GUI_GET_W(0,CM_MES_COLUMN_WIDTH);
			h = GUI_GET_H(2,18);
			colorBackground[] = CM_MES_FRAME_COLOR;
		};
		class RscText_1001: RscText
		{
			idc = 1001;
			style = ST_CENTER;
			text = "Title";
			x = CM_MES_GET_X(0);
			y = CM_MES_GET_Y(2);
			w = GUI_GET_W(0,CM_MES_COLUMN_WIDTH);
			h = GUI_GET_H(2,4);
		};
		class RscBG_1807: RscBackground
		{
			idc = 1807;
			style = ST_LINE;
			x = CM_MES_GET_X(0);
			y = CM_MES_GET_Y(4);
			w = GUI_GET_W(0,CM_MES_COLUMN_WIDTH);
			h = GUI_GET_H(4,4.2);
			colorBackground[] = CM_MES_DIAG_COLOR;
		};
		class RscStructuredText_1100: RscText
		{
			idc = 1100;
			text = "Description";
			style = ST_LEFT + ST_MULTI + ST_NO_RECT;
			lineSpacing = 1;
			x = CM_MES_GET_X(0);
			y = CM_MES_GET_Y(5);
			w = GUI_GET_W(0,CM_MES_COLUMN_WIDTH);
			h = GUI_GET_H(5,18);
		};
		
		// Casualties Box
		#define CM_MES_SB_X	(CM_MES_GET_X(((CM_MES_COLUMN_WIDTH / 3) * 0)) + ((CM_MES_PAD_X_W / 2) * 0))
		#define CM_MES_SB_W	(GUI_GET_W(0,(CM_MES_COLUMN_WIDTH / 3)) - CM_MES_PAD_X_W)
		class RscBG_1802: RscBackground
		{
			idc = 1802;
			x = CM_MES_SB_X;
			y = CM_MES_GET_Y(19);
			w = CM_MES_SB_W;
			h = GUI_GET_H(19,25);
			colorBackground[] = CM_MES_FRAME_COLOR;
		};
		class RscText_1010: RscText
		{
			idc = 1010;
			text = "Casualties:";
			style = ST_CENTER;
			x = CM_MES_SB_X;
			y = CM_MES_GET_Y(19);
			w = CM_MES_SB_W;
			h = GUI_GET_H(19,20);
		};
		class RscText_1011: RscText
		{
			idc = 1011;
			text = "Blufor:";
			x = CM_MES_SB_X;
			y = CM_MES_GET_Y(20);
			w = CM_MES_SB_W / 2;
			h = GUI_GET_H(20,21);
		};
		class RscText_1021: RscText
		{
			idc = 1021;
			text = "0";
			style = ST_CENTER;
			x = CM_MES_SB_X + (CM_MES_SB_W / 2);
			y = CM_MES_GET_Y(20);
			w = CM_MES_SB_W / 2;
			h = GUI_GET_H(20,21);
		};
		class RscText_1012: RscText
		{
			idc = 1012;
			text = "Opfor:";
			x = CM_MES_SB_X;
			y = CM_MES_GET_Y(21);
			w = CM_MES_SB_W / 2;
			h = GUI_GET_H(21,22);
		};
		class RscText_1022: RscText
		{
			idc = 1022;
			text = "0";
			style = ST_CENTER;
			x = CM_MES_SB_X + (CM_MES_SB_W / 2);
			y = CM_MES_GET_Y(21);
			w = CM_MES_SB_W / 2;
			h = GUI_GET_H(21,22);
		};
		class RscText_1013: RscText
		{
			idc = 1013;
			text = "Independent:";
			x = CM_MES_SB_X;
			y = CM_MES_GET_Y(22);
			w = CM_MES_SB_W / 2;
			h = GUI_GET_H(22,23);
		};
		class RscText_1023: RscText
		{
			idc = 1023;
			text = "0";
			style = ST_CENTER;
			x = CM_MES_SB_X + (CM_MES_SB_W / 2);
			y = CM_MES_GET_Y(22);
			w = CM_MES_SB_W / 2;
			h = GUI_GET_H(22,23);
		};
		class RscText_1014: RscText
		{
			idc = 1014;
			text = "Civilians:";
			x = CM_MES_SB_X;
			y = CM_MES_GET_Y(23);
			w = CM_MES_SB_W / 2;
			h = GUI_GET_H(23,24);
		};
		class RscText_1024: RscText
		{
			idc = 1024;
			text = "0";
			style = ST_CENTER;
			x = CM_MES_SB_X + (CM_MES_SB_W / 2);
			y = CM_MES_GET_Y(23);
			w = CM_MES_SB_W / 2;
			h = GUI_GET_H(23,24);
		};
		
		// Statistics Box
		#define CM_MES_SB_X	(CM_MES_GET_X(((CM_MES_COLUMN_WIDTH / 3) * 1)) + ((CM_MES_PAD_X_W / 2) * 1))
		class RscBG_1803: RscBackground
		{
			idc = 1803;
			x = CM_MES_SB_X;
			y = CM_MES_GET_Y(19);
			w = CM_MES_SB_W;
			h = GUI_GET_H(19,25);
			colorBackground[] = CM_MES_FRAME_COLOR;
		};
		class RscText_1030: RscText
		{
			idc = 1030;
			text = "Statistics:";
			style = ST_CENTER;
			x = CM_MES_SB_X;
			y = CM_MES_GET_Y(19);
			w = CM_MES_SB_W;
			h = GUI_GET_H(19,20);
		};
		class RscText_1031: RscText
		{
			idc = 1031;
			text = "Brief Time:";
			x = CM_MES_SB_X;
			y = CM_MES_GET_Y(20);
			w = CM_MES_SB_W / 2;
			h = GUI_GET_H(20,21);
		};
		class RscText_1041: RscText
		{
			idc = 1041;
			text = "0";
			style = ST_CENTER;
			x = CM_MES_SB_X + (CM_MES_SB_W / 2);
			y = CM_MES_GET_Y(20);
			w = CM_MES_SB_W / 2;
			h = GUI_GET_H(20,21);
		};
		class RscText_1032: RscText
		{
			idc = 1032;
			text = "Game Time:";
			x = CM_MES_SB_X;
			y = CM_MES_GET_Y(21);
			w = CM_MES_SB_W / 2;
			h = GUI_GET_H(21,22);
		};
		class RscText_1042: RscText
		{
			idc = 1042;
			text = "0";
			style = ST_CENTER;
			x = CM_MES_SB_X + (CM_MES_SB_W / 2);
			y = CM_MES_GET_Y(21);
			w = CM_MES_SB_W / 2;
			h = GUI_GET_H(21,22);
		};
		class RscText_1033: RscText
		{
			idc = 1033;
			text = "Total Time:";
			x = CM_MES_SB_X;
			y = CM_MES_GET_Y(22);
			w = CM_MES_SB_W / 2;
			h = GUI_GET_H(22,23);
		};
		class RscText_1043: RscText
		{
			idc = 1043;
			text = "0";
			style = ST_CENTER;
			x = CM_MES_SB_X + (CM_MES_SB_W / 2);
			y = CM_MES_GET_Y(22);
			w = CM_MES_SB_W / 2;
			h = GUI_GET_H(22,23);
		};
		class RscText_1034: RscText
		{
			idc = 1034;
			text = "Score:";
			x = CM_MES_SB_X;
			y = CM_MES_GET_Y(23);
			w = CM_MES_SB_W / 2;
			h = GUI_GET_H(23,24);
		};
		class RscText_1044: RscText
		{
			idc = 1044;
			text = "0";
			style = ST_CENTER;
			x = CM_MES_SB_X + (CM_MES_SB_W / 2);
			y = CM_MES_GET_Y(23);
			w = CM_MES_SB_W / 2;
			h = GUI_GET_H(23,24);
		};
		
		// End Mission Button
		#define CM_MES_SB_X	(CM_MES_GET_X(((CM_MES_COLUMN_WIDTH / 3) * 2)) + ((CM_MES_PAD_X_W / 2) * 2))
		class RscButton_1600: RscButton
		{
			idc = 1600;
			text = "End Local Mission";
			action = "endMission 'END1'; forceEnd;";
			x = CM_MES_SB_X + (CM_MES_SB_W / 4);
			y = CM_MES_GET_Y(19) + (GUI_GET_H(19,25) / 4);
			w = CM_MES_SB_W / 2;
			h = GUI_GET_H(19,25) / 2;
			default = true;
		};
	}; // Controls
}; // Dialog