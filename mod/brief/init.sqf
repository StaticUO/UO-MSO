
/* Macros */
#define LOAD_BRIEF(file) call compile str(preProcessFile ("mod\brief\briefing\" + file))

/* Load Common Diary Records */
player createDiaryRecord ["Diary", ["MISSION NOTES", LOAD_BRIEF("common\mission_notes.html")]];

/* Load Side-Specific Diary Records */
switch (side player) do {
	case WEST: {
		#include "west\x_load.sqf";
	};
	case EAST: {
		#include "east\x_load.sqf";
	};
	case RESISTANCE: {
		#include "resistance\x_load.sqf";
	};
	case CIVILIAN: {
		#include "civilian\x_load.sqf";
	};
};

/* Add any code to load custom briefings below */
