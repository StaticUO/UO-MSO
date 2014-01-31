
// Grid User Interface (GUI) definition file

#define GUI_ROWS				40
#define GUI_COLUMNS				12

#define GUI_X					safezoneX
#define GUI_Y					safezoneY
#define GUI_W					safezoneW
#define GUI_H					safezoneH

#define GUI_BOX_H				(GUI_H / GUI_ROWS)
#define GUI_BOX_W				(GUI_W / GUI_COLUMNS)

#define GUI_GET_X(col)			(GUI_X + (col * GUI_BOX_W))
#define GUI_GET_Y(row)			(GUI_Y + (row * GUI_BOX_H))
#define GUI_GET_W(col1,col2)	((col2 - col1) * GUI_BOX_W)
#define GUI_GET_H(row1,row2)	((row2 - row1) * GUI_BOX_H)