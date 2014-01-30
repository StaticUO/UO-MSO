/***
 * standard definitions
 */
 
#define true                        1
#define false                       0

#define private                     0
#define protected                   1
#define public                      2

/***
 * RUBE core definitions/constants
 */

#ifndef _RUBE_CORE_DEFS_HPP
#define _RUBE_CORE_DEFS_HPP

// control types
#define RUBE_CT_STATIC              0
#define RUBE_CT_BUTTON              1
#define RUBE_CT_EDIT                2
#define RUBE_CT_SLIDER              3
#define RUBE_CT_COMBO               4
#define RUBE_CT_LISTBOX             5
#define RUBE_CT_TOOLBOX             6
#define RUBE_CT_CHECKBOXES	         7
#define RUBE_CT_PROGRESS            8
#define RUBE_CT_HTML                9
#define RUBE_CT_STATIC_SKEW	      10
#define RUBE_CT_ACTIVETEXT	         11
#define RUBE_CT_TREE                12
#define RUBE_CT_STRUCTURED_TEXT     13 
#define RUBE_CT_CONTEXT_MENU        14 
#define RUBE_CT_CONTROLS_GROUP      15
#define RUBE_CT_SHORTCUT_BUTTON     16

#define RUBE_CT_3DSTATIC            20
#define RUBE_CT_3DACTIVETEXT	      21
#define RUBE_CT_3DLISTBOX           22
#define RUBE_CT_3DHTML              23
#define RUBE_CT_3DSLIDER            24
#define RUBE_CT_3DEDIT              25

#define RUBE_CT_XKEYDESC            40 
#define RUBE_CT_XBUTTON             41 
#define RUBE_CT_XLISTBOX            42 
#define RUBE_CT_XSLIDER             43 
#define RUBE_CT_XCOMBO              44 
#define RUBE_CT_ANIMATED_TEXTURE    45 

#define RUBE_CT_OBJECT              80
#define RUBE_CT_OBJECT_ZOOM	      81
#define RUBE_CT_OBJECT_CONTAINER    82
#define RUBE_CT_OBJECT_CONT_ANIM    83

#define RUBE_CT_LINEBREAK           98
#define RUBE_CT_USER                99
#define RUBE_CT_MAP                 100 
#define RUBE_CT_MAP_MAIN            101 
#define RUBE_CT_List_N_Box          102

// static styles
#define RUBE_ST_POS                 0x0F 
#define RUBE_ST_HPOS                0x03 
#define RUBE_ST_VPOS                0x0C 
#define RUBE_ST_LEFT                0x00 
#define RUBE_ST_RIGHT               0x01 
#define RUBE_ST_CENTER              0x02 
#define RUBE_ST_DOWN                0x04 
#define RUBE_ST_UP                  0x08 
#define RUBE_ST_VCENTER             0x0c

#define RUBE_ST_TYPE                0xF0 
#define RUBE_ST_SINGLE              0 
#define RUBE_ST_MULTI               16 
#define RUBE_ST_TITLE_BAR           32 
#define RUBE_ST_PICTURE             48 
#define RUBE_ST_FRAME               64 
#define RUBE_ST_BACKGROUND          80 
#define RUBE_ST_GROUP_BOX           96 
#define RUBE_ST_GROUP_BOX2          112 
#define RUBE_ST_HUD_BACKGROUND      128 
#define RUBE_ST_TILE_PICTURE        144 
#define RUBE_ST_WITH_RECT           160 
#define RUBE_ST_LINE                176 

#define RUBE_ST_SHADOW              0x100 
#define RUBE_ST_NO_RECT             0x200 
#define RUBE_ST_KEEP_ASPECT_RATIO   0x800 

#define RUBE_ST_TITLE               RUBE_ST_TITLE_BAR + RUBE_ST_CENTER 

// slider styles 
#define RUBE_SL_DIR                 0x400 
#define RUBE_SL_VERT                0 
#define RUBE_SL_HORZ                0x400 

#define RUBE_SL_TEXTURES            0x10

// listbox styles 
#define RUBE_LB_TEXTURES            0x10 
#define RUBE_LB_MULTI               0x20 

#endif