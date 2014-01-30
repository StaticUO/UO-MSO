
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
//        These Variables should be checked and set as required, to make the mission runs properly.
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

private ["_markerAlpha"];

// Hide marker areas. All markers area must be named area0, area1...area13.
_markerAlpha = false;

//1=Enable or 0=disable debug. In debug could see a mark positioning de leader and another mark of the destination of movement, very useful for editing mission
KRON_UPS_Debug = 1;

//1=Enable or 0=disable. In game display global chat info about who just killed a civilian. 
//numbers of Civilians killed by players could be read from array 'KILLED_CIV_COUNTER' -> [Total, by West, by East, by Res, The killer]
R_WHO_IS_CIV_KILLER_INFO = 0;


// if you are spotted by AI group, how close the other AI group have to be to You , to be informed about your present position. over this, will lose target
KRON_UPS_sharedist = 200;

// If enabled IA communication between them with radio defined sharedist distance, 0/2 
// (must be set to 2 in order to use reinforcement !R)
KRON_UPS_comradio = 2;

//Sides that are enemies of resistance
KRON_UPS_Res_enemy = [west];

// Distance from destination for searching vehicles. (Search area is about 200m), 
// If your destination point is further than KRON_UPS_searchVehicledist, AI will try to find a vehicle to go there.
KRON_UPS_searchVehicledist = 600; // 700, 900  

//Enables or disables AI to use static weapons
KRON_UPS_useStatics = true;

//Enables or disables AI to put mines if armoured enemies near (use ambush2 if needed)
KRON_UPS_useMines = false;

//------------------------------------------------------------------------------------------------------------------------------
//        These Variables can be changed if needed but it is not necessary.
//------------------------------------------------------------------------------------------------------------------------------

//% of chanse to use smoke by team members when someone wounded or killed in the group in %(default 13 & 35).
// set both to 0 -> to switch off this function 
R_USE_SMOKE_wounded = 13;
R_USE_SMOKE_killed = 35;

//Height that heli will fly this input will be randomised in a 10%
KRON_UPS_flyInHeight = 80;

//Percentage of units to surrender.
KRON_UPS_EAST_SURRENDER = 5; // 10
KRON_UPS_WEST_SURRENDER = 5; // 10
KRON_UPS_GUER_SURRENDER = 5; // 10

// knowsAbout 0.5 1.03 , 1.49 to add this enemy to "target list" (1-4) the higher number the less detect ability (original in 5.0.7 was 0.5)
// it does not mean the AI will not shoot at you. This means: what must be knowsAbout you to UPSMON adds you to the list of targets (UPSMON list of target) 
R_knowsAboutEnemy = 0.5;

// units will react (change the beahaviour) when dead bodies found 
R_deadBodiesReact = false;  // true OR flase

// ---------------------------------------------------------------------------------------------------------------------
//      Better do not change these variables if you aren't sure !R
// ---------------------------------------------------------------------------------------------------------------------

//Efective distance for doing perfect ambush (max distance is this x2)
KRON_UPS_ambushdist = 70;

//Max distance to target for doing para-drop, will be randomised between 0 and 100% of this value.
KRON_UPS_paradropdist = 250;

//Frequency for doing calculations for each squad.
KRON_UPS_Cycle = 10; //org 20

//Time that lider wait until doing another movement, this time reduced dynamically under fire, and on new targets
KRON_UPS_react = 60;

//Min time to wait for doing another reaction
KRON_UPS_minreact = 30; // org 30

//Max waiting is the maximum time patrol groups will wait when arrived to target for doing another target.
KRON_UPS_maxwaiting = 30;

// how long AI units should be in alert mode after initially spotting an enemy
KRON_UPS_alerttime = 90;

// how far opfors should move away if they're under attack
KRON_UPS_safedist = 250; //org 300

// how close unit has to be to target to generate a new one target or to enter stealth mode
KRON_UPS_closeenough = 300; //org 300 

//Enable it to send reinforcements, better done it in a trigger inside your mission.
KRON_UPS_reinforcement = false; 

//Artillery support, better control if set in trigger  
KRON_UPS_ARTILLERY_EAST_FIRE = false; //set to true for doing east to fire
KRON_UPS_ARTILLERY_WEST_FIRE = false; //set to true for doing west to fire
KRON_UPS_ARTILLERY_GUER_FIRE = false; //set to true for doing resistance to fire
