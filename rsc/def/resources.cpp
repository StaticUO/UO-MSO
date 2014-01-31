class RscControlsGroup {
	type = CT_CONTROLS_GROUP;
	idc = -1;
	x = 0;
	y = 0;
	w = 1;
	h = 1;
	shadow = false;
	style = 16;
	
	class VScrollbar {
		width = 0.021;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;
		shadow = false;
	};
	
	class HScrollbar {
		height = 0.028;
		shadow = false;
	};
	
	class ScrollBar {
		color[] = {1, 1, 1, 0.6};
		colorActive[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.3};
		thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
		arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
		arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
		border = "\ca\ui\data\ui_border_scroll_ca.paa";
	};
	
	class Controls {};
};

class RscListNBox {
	style = 16;
	shadow = 2;
	type = CT_LISTNBOX;
	color[] = {1, 1, 1, 1};
	colorText[] = {0.8784, 0.8471, 0.651, 1.0};
	colorScrollbar[] = {0.95, 0.95, 0.95, 1};
	colorSelect[] = {0.95, 0.95, 0.95, 1};
	colorSelect2[] = {0.95, 0.95, 0.95, 1};
	colorSelectBackground[] = {0, 0, 0, 1};
	colorSelectBackground2[] = {0.8784, 0.8471, 0.651, 1.0};
	
	class ScrollBar {
		color[] = {1, 1, 1, 0.6};
		colorActive[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.3};
		thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
		arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
		arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
		border = "\ca\ui\data\ui_border_scroll_ca.paa";
	};
};

class DefaultTextAttributes {
	font = "Zeppelin32";
	color = "#ffffff";
	size = 1;
	align = "left";
	valign = "middle";
	shadow = "true";
	shadowOffset = 0.07;
	shadowColor = "#000000";
	underline = "false";
};

class RscButtonImages {
	class XBoxA {
		id = 0x00050000 + 0;
		image = "\ca\ui\data\ui_xbox_shortcut_a_ca.paa";
		size = 1.3333;
	};
	
	class XBoxB {
		id = 0x00050000 + 1;
		image = "\ca\ui\data\ui_xbox_shortcut_b_ca.paa";
		size = 1.3333;
	};
	
	class XBoxX {
		id = 0x00050000 + 2;
		image = "\ca\ui\data\ui_xbox_shortcut_x_ca.paa";
		size = 1.3333;
	};
	
	class XBoxY {
		id = 0x00050000 + 3;
		image = "\ca\ui\data\ui_xbox_shortcut_y_ca.paa";
		size = 1.3333;
	};
	
	class XBoxUp {
		id = 0x00050000 + 4;
		image = "#(argb,8,8,3)color(0,1,0,1)";
		size = 1.3333;
	};
	
	class XBoxDown {
		id = 0x00050000 + 5;
		image = "#(argb,8,8,3)color(0,1,0,1)";
		size = 1.3333;
	};
	
	class XBoxLeft {
		id = 0x00050000 + 6;
		image = "#(argb,8,8,3)color(0,1,0,1)";
		size = 1.3333;
	};
	
	class XBoxRight {
		id = 0x00050000 + 7;
		image = "#(argb,8,8,3)color(0,1,0,1)";
		size = 1.3333;
	};
	
	class XBoxStart {
		id = 0x00050000 + 8;
		image = "\ca\ui\data\ui_xbox_shortcut_start_ca.paa";
		size = 1.3333;
	};
	
	class XBoxBack {
		id = 0x00050000 + 9;
		image = "#(argb,8,8,3)color(0.3,0.3,0.3,1)";
		size = 1.3333;
	};
	
	class XBoxBlack {
		id = 0x00050000 + 10;
		image = "#(argb,8,8,3)color(0,0,0,1)";
		size = 1.3333;
	};
	
	class XBoxWhite {
		id = 0x00050000 + 11;
		image = "#(argb,8,8,3)color(1,1,1,1)";
		size = 1.3333;
	};
	
	class XBoxLeftBumper {
		id = 0x00050000 + 10;
		image = "#(argb,8,8,3)color(0,0,1,1)";
		size = 1.3333;
	};
	
	class XBoxRightBumper {
		id = 0x00050000 + 11;
		image = "#(argb,8,8,3)color(1,0,0,1)";
		size = 1.3333;
	};
	
	class XBoxLeftTrigger {
		id = 0x00050000 + 12;
		image = "#(argb,8,8,3)color(0,1,0,1)";
		size = 1.3333;
	};
	
	class XBoxRightTrigger {
		id = 0x00050000 + 13;
		image = "#(argb,8,8,3)color(0,1,0,1)";
		size = 1.3333;
	};
	
	class XBoxLeftThumb {
		id = 0x00050000 + 14;
		image = "\ca\ui\data\ui_xbox_shortcut_rightthumb_ca.paa";
		size = 1.3333;
	};
	
	class XBoxRightThumb {
		id = 0x00050000 + 15;
		image = "";
		size = 1.3333;
	};
	
	class XBoxLeftThumbXRight {
		id = 0x00050000 + 16;
		image = "#(argb,8,8,3)color(0,1,0,1)";
		size = 1.3333;
	};
	
	class XBoxLeftThumbYUp {
		id = 0x00050000 + 17;
		image = "#(argb,8,8,3)color(0,1,0,1)";
		size = 1.3333;
	};
	
	class XBoxRightThumbXRight {
		id = 0x00050000 + 16;
		image = "#(argb,8,8,3)color(0,1,0,1)";
		size = 1.3333;
	};
	
	class XBoxRightThumbYUp {
		id = 0x00050000 + 19;
		image = "#(argb,8,8,3)color(0,1,0,1)";
		size = 1.3333;
	};
	
	class XBoxLeftThumbXLeft {
		id = 0x00050000 + 20;
		image = "#(argb,8,8,3)color(0,1,0,1)";
		size = 1.3333;
	};
	
	class XBoxLeftThumbYDown {
		id = 0x00050000 + 21;
		image = "#(argb,8,8,3)color(0,1,0,1)";
		size = 1.3333;
	};
	
	class XBoxRightThumbXLeft {
		id = 0x00050000 + 22;
		image = "#(argb,8,8,3)color(0,1,0,1)";
		size = 1.3333;
	};
	
	class XBoxRightThumbYDown {
		id = 0x00050000 + 23;
		image = "#(argb,8,8,3)color(0,1,0,1)";
		size = 1.3333;
	};
};

class RscText {
	x = 0;
	y = 0;
	h = 0.037;
	w = 0.3;
	style = ST_SINGLE;
	shadow = 2;
	type = CT_STATIC;
	font = "Zeppelin32";
	SizeEx = 0.03921;
	colorText[] = {0.8784, 0.8471, 0.651, 1.0};
	colorBackground[] = {0, 0, 0, 0};
};

class RscLine : RscText {
	idc = -1;
	style = 176;
	type = CT_STATIC;
	x = 0.17;
	y = 0.48;
	w = 0.66;
	h = 0;
	text = "";
	colorBackground[] = {0, 0, 0, 0};
	colorText[] = {0.8784, 0.8471, 0.651, 1.0};
};

class RscTextMainMenu : RscText {
	style = 0x02 + 0x100;
};

class RscTree {
	type = CT_TREE;
	font = "Zeppelin32";
	sizeEx = 0.02674;
};

class RscTitle : RscText {
	shadow = 2;
};

class RscPicture {
	shadow = false;
	type = CT_STATIC;
	colorText[] = {1, 1, 1, 1};
	x = 0;
	y = 0;
	w = 0.2;
	h = 0.15;
};

class RscPictureKeepAspect : RscPicture {
	style = 0x30 + 0x800;
};

class RscStructuredText {
	x = 0;
	y = 0;
	h = 0.035;
	w = 0.1;
	text = "";
	type = CT_STRUCTURED_TEXT;
	//style = ST_MULTI;
	size = 0.03921;
	colorText[] = {0.8784, 0.8471, 0.651, 1.0};
	shadow = 2;
	
	class Attributes {
		font = "Zeppelin32";
		color = "#e0d8a6";
		align = "center";
		shadow = true;
	};
};
class RscObject;	// External class reference

class RscActiveText {
	idc = -1;
	x = 0;
	y = 0;
	h = 0.035;
	w = 0.035;
	font = "Zeppelin32";
	type = CT_ACTIVETEXT;
	shadow = 2;
	sizeEx = 0.03921;
	color[] = {0, 0, 0, 1};
	colortext[] = {0, 0, 0, 1};
	colorActive[] = {0.3, 0.4, 0, 1};
};

class RscButton {
	style = 2;
	x = 0;
	y = 0;
	w = 0.095589;
	h = 0.039216;
	shadow = 2;
	font = "Zeppelin32";
	type = CT_BUTTON;
	sizeEx = 0.03921;
	colorText[] = {0.8784, 0.8471, 0.651, 1.0};
	colorDisabled[] = {0.4, 0.4, 0.4, 1};
	colorBackground[] = {1, 0.537, 0, 0.5};
	colorBackgroundActive[] = {1, 0.537, 0, 1};
	colorBackgroundDisabled[] = {0.95, 0.95, 0.95, 1};
	offsetX = 0.003;
	offsetY = 0.003;
	offsetPressedX = 0.002;
	offsetPressedY = 0.002;
	colorFocused[] = {1, 0.537, 0, 1};
	colorShadow[] = {0.023529, 0, 0.0313725, 1};
	colorBorder[] = {0.023529, 0, 0.0313725, 1};
	borderSize = 0.0;
	soundEnter[] = {"\ca\ui\data\sound\onover", 0.09, 1};
	soundPush[] = {"\ca\ui\data\sound\new1", 0.0, 0};
	soundClick[] = {"\ca\ui\data\sound\onclick", 0.07, 1};
	soundEscape[] = {"\ca\ui\data\sound\onescape", 0.09, 1};
};

class RscShortcutButton {
	idc = -1;
	style = 0;
	default = 0;
	shadow = 2;
	w = 0.183825;
	h = 0.104575;
	color[] = {0.8784, 0.8471, 0.651, 1.0};
	color2[] = {0.95, 0.95, 0.95, 1};
	colorBackground[] = {1, 1, 1, 1};
	colorbackground2[] = {1, 1, 1, 0.4};
	colorDisabled[] = {1, 1, 1, 0.25};
	periodFocus = 1.2;
	periodOver = 0.8;
	
	class HitZone {
		left = 0.004;
		top = 0.029;
		right = 0.004;
		bottom = 0.029;
	};
	
	class ShortcutPos {
		left = 0.0145;
		top = 0.026;
		w = 0.0392157;
		h = 0.0522876;
	};
	
	class TextPos {
		left = 0.05;
		top = 0.034;
		right = 0.005;
		bottom = 0.005;
	};
	animTextureNormal = "\ca\ui\data\ui_button_normal_ca.paa";
	animTextureDisabled = "\ca\ui\data\ui_button_disabled_ca.paa";
	animTextureOver = "\ca\ui\data\ui_button_over_ca.paa";
	animTextureFocused = "\ca\ui\data\ui_button_focus_ca.paa";
	animTexturePressed = "\ca\ui\data\ui_button_down_ca.paa";
	animTextureDefault = "\ca\ui\data\ui_button_default_ca.paa";
	period = 0.4;
	font = "Zeppelin32";
	type = CT_SHORTCUTBUTTON;
	size = 0.03921;
	sizeEx = 0.03921;
	text = "";
	soundEnter[] = {"\ca\ui\data\sound\onover", 0.09, 1};
	soundPush[] = {"\ca\ui\data\sound\new1", 0.0, 0};
	soundClick[] = {"\ca\ui\data\sound\onclick", 0.07, 1};
	soundEscape[] = {"\ca\ui\data\sound\onescape", 0.09, 1};
	action = "";
	
	class Attributes {
		font = "Zeppelin32";
		color = "#E5E5E5";
		align = "left";
		shadow = "true";
	};
	
	class AttributesImage {
		font = "Zeppelin32";
		color = "#E5E5E5";
		align = "left";
	};
};

class RscXKeyShadow {
	style = 0;
	w = 0.313726;
	h = 0.104575;
	size = 0.03921;
	
	class Attributes {
		font = "Zeppelin32";
		color = "#E5E5E5";
		align = "left";
	};
	
	class AttributesImage {
		color = "#E5E5E5";
	};
};

class RscButton_small : RscButton {
	w = 0.095589;
	h = 0.039216;
	sizeEx = 0.02674;
};

class RscButtonTextOnly : RscButton {
	SizeEx = 0.02674;
	colorBackground[] = {1, 1, 1, 0};
	colorBackgroundActive[] = {1, 1, 1, 0};
	colorBackgroundDisabled[] = {1, 1, 1, 0};
	colorFocused[] = {1, 1, 1, 0};
	colorShadow[] = {1, 1, 1, 0};
	borderSize = 0.0;
};

class RscProgress {
	x = 0.344;
	y = 0.619;
	w = 0.313726;
	h = 0.0261438;
	shadow = 2;
	type = CT_PROGRESS;
	texture = "\ca\ui\data\loadscreen_progressbar_ca.paa";
	colorFrame[] = {0, 0, 0, 0};
	colorBar[] = {1, 1, 1, 1};
};

class RscProgressBackground : RscPicture {
	x = 0.0;
	y = 0.892164;
	w = 1;
	h = 0.078432;
	text = "\ca\ui\data\ui_gradient_title_gs.paa";
	colorText[] = {0, 0, 0, 0.4};
};

class RscLoadingText : RscText {
	style = 2;
	x = 0.29412;
	y = 0.666672;
	w = 0.411768;
	h = 0.039216;
	sizeEx = 0.03921;
	colorText[] = {0.8784, 0.8471, 0.651, 1.0};
};

class RscProgressNotFreeze {};

class RscListBox {
	style = 16;
	font = "Zeppelin32";
	type = CT_LISTBOX;
	shadow = 2;
	sizeEx = 0.03921;
	color[] = {1, 1, 1, 1};
	colorText[] = {0.8784, 0.8471, 0.651, 1.0};
	colorScrollbar[] = {0.95, 0.95, 0.95, 1};
	colorSelect[] = {0.95, 0.95, 0.95, 1};
	colorSelect2[] = {0.95, 0.95, 0.95, 1};
	colorSelectBackground[] = {0, 0, 0, 1};
	colorSelectBackground2[] = {0.8784, 0.8471, 0.651, 1.0};
	period = 1.2;
	colorBackground[] = {0, 0, 0, 1};
	maxHistoryDelay = 1.0;
	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;
	
	class ScrollBar {
		color[] = {1, 1, 1, 0.6};
		colorActive[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.3};
		thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
		arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
		arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
		border = "\ca\ui\data\ui_border_scroll_ca.paa";
	};
};

class RscListBoxKeys : RscListBox {
	collisionColor[] = {1, 0, 0, 1};
	disabledKeyColor[] = {1, 1, 1, 0.5};
};

class RscEdit {
	style = 0x00 + 0x40;
	font = "Zeppelin32";
	type = CT_EDIT;
	shadow = 2;
	sizeEx = 0.03921;
	colorBackground[] = {0, 0, 0, 1};
	colorText[] = {0.95, 0.95, 0.95, 1};
	colorSelection[] = {0.8784, 0.8471, 0.651, 1.0};
};

class RscSlider {
	h = 0.025;
	type = CT_SLIDER;
	color[] = {1, 1, 1, 0.8};
	colorActive[] = {1, 1, 1, 1};
};

class RscXSliderH {
	style = 0x400	+ 0x10;
	shadow = 2;
	type = CT_XSLIDER;
	x = 0;
	y = 0;
	h = 0.029412;
	w = 0.4;
	color[] = {1, 1, 1, 0.4};
	colorActive[] = {1, 1, 1, 1};
	colorDisabled[] = {1, 1, 1, 0.2};
	arrowEmpty = "\ca\ui\data\ui_arrow_left_ca.paa";
	arrowFull = "\ca\ui\data\ui_arrow_left_active_ca.paa";
	border = "\ca\ui\data\ui_border_frame_ca.paa";
	thumb = "\ca\ui\data\ui_slider_bar_ca.paa";
};

class RscXListBox {
	style = 0x400 + 0x02 +	0x10;
	shadow = 2;
	type = CT_XLISTBOX;
	arrowEmpty = "\ca\ui\data\ui_arrow_left_ca.paa";
	arrowFull = "\ca\ui\data\ui_arrow_left_active_ca.paa";
	border = "\ca\ui\data\ui_border_frame_ca.paa";
	w = 0.14706;
	h = 0.039216;
	colorSelect[] = {0.95, 0.95, 0.95, 1};
	colorText[] = {0.8784, 0.8471, 0.651, 1.0};
	font = "Zeppelin32";
	sizeEx = 0.03921;
	soundSelect[] = {"\ca\ui\data\sound\new1", 0.0, 0};
};

class RscFrame {
	type = CT_STATIC;
	idc = -1;
	style = 64;
	shadow = 2;
	colorBackground[] = {0, 0, 0, 0};
	colorText[] = {1, 1, 1, 1};
	font = "Zeppelin32";
	sizeEx = 0.02;
	text = "";
};

class RscBackground : RscText {
	IDC = -1;
	style = 512;
	shadow = false;
	x = 0.0;
	y = 0.0;
	w = 1.0;
	h = 1.0;
	text = "";
	ColorBackground[] = {0.48, 0.5, 0.35, 1};
	ColorText[] = {0.1, 0.1, 0.1, 1};
	font = "Zeppelin32";
	SizeEx = 1;
};

class RscHTML {
	type = CT_HTML;
	colorText[] = {0.8784, 0.8471, 0.651, 1.0};
	colorLink[] = {0.8784, 0.8471, 0.651, 1.0};
	colorBold[] = {0.8784, 0.8471, 0.651, 1.0};
	colorLinkActive[] = {1, 0.537, 0, 1};
	sizeEx = 0.03921;
	prevPage = "\ca\ui\data\arrow_left_ca.paa";
	nextPage = "\ca\ui\data\arrow_right_ca.paa";
	shadow = 2;
	
	class H1 {
		font = "Zeppelin32";
		fontBold = "Zeppelin33";
		sizeEx = 0.03921;
		align = "left";
	};
	
	class H2 {
		font = "Zeppelin32";
		fontBold = "Zeppelin33";
		sizeEx = 0.03921;
		align = "left";
	};
	
	class H3 {
		font = "Zeppelin32";
		fontBold = "Zeppelin33";
		sizeEx = 0.03921;
		align = "left";
	};
	
	class H4 {
		font = "Zeppelin33Italic";
		fontBold = "Zeppelin33";
		sizeEx = 0.03921;
		align = "left";
	};
	
	class H5 {
		font = "Zeppelin32";
		fontBold = "Zeppelin33";
		sizeEx = 0.03921;
		align = "left";
	};
	
	class H6 {
		font = "Zeppelin32";
		fontBold = "Zeppelin33";
		sizeEx = 0.03921;
		align = "left";
	};
	
	class P {
		font = "Zeppelin32";
		fontBold = "Zeppelin33";
		sizeEx = 0.03921;
		align = "left";
	};
};