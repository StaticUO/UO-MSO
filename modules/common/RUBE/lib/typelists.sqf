/*
   RUBE common type lists, 
    used in filters, generic packers and the like...
   
 > provided type lists:
   
   - themed packer sets (to pack areas with)
     - RUBE_PACKERSET_MILITARY
     - RUBE_PACKERSET_SUPPLIES
     - RUBE_PACKERSET_CONSTRUCTION
     - RUBE_PACKERSET_MECHANICAL
     - RUBE_PACKERSET_WOODWORKS
     
   - RUBE_TYPELIST_TABLEITEMS  
     
   - RUBE_TYPELIST_MEDICS
     (list of medic units in the game)
     
   - RUBE_TYPELIST_BUILDINGS_MILITARY 
     (military buildings, used to filter buildings for civilian usages)
     
   - RUBE_TYPELIST_DRAGGABLE
     (draggable objects, for/working with RUBE_makeDraggable)
     
   - RUBE_TYPELIST_DROPABLE
     (droppable objects, for/working with RUBE_makeDroppable)
*/

RUBE_PACKERSET_MILITARY = [
   "SkeetMachine",
   "Barrels",
   "Paleta1",
   "Paleta2",
   "SmallTable",
   "Misc_Backpackheap",
   "Misc_cargo_cont_net1",
   "Misc_cargo_cont_net2",
   "Misc_cargo_cont_net3",
   "Misc_cargo_cont_small",
   "Misc_cargo_cont_small2",
   "Misc_cargo_cont_tiny",
   "PowGen_Big",
   "Misc_Cargo1B_military",
   "Misc_Cargo1Bo_military",
   "Land_obstacle_prone",
   "Land_obstacle_run_duck",
   "Land_obstacle_get_over"
];

RUBE_PACKERSET_SUPPLIES = [
   "Barrels",
   "Land_Barrel_empty",
   "Land_Barrel_sand",
   "Land_Barrel_water",
   "Paleta1",
   "Paleta2",
   "SmallTable",
   "Misc_cargo_cont_net1",
   "Misc_cargo_cont_net2",
   "Misc_cargo_cont_net3",
   "Land_obstacle_prone",
   "Land_obstacle_run_duck",
   "Land_obstacle_get_over",
   "Land_Crates_EP1",
   "Land_Crates_stack_EP1",
   "Land_transport_crates_EP1",
   "Land_bags_stack_EP1",
   "Land_bags_EP1",
   "Land_Bag_EP1",
   "Land_Canister_EP1"
];

RUBE_PACKERSET_CONSTRUCTION = [
   "Barrel4",
   "Land_Ind_TankSmall2",
   "Land_Misc_GContainer_Big",
   "Misc_concrete_High",
   "Misc_palletsfoiled",
   "Misc_palletsfoiled_heap",
   "Paleta1",
   "Paleta2",
   "PowGen_Big",
   "Misc_cargo_cont_small",
   "Misc_cargo_cont_small2",
   "Misc_cargo_cont_tiny",
   "Land_obstacle_prone",
   "Land_obstacle_run_duck",
   "Land_obstacle_get_over",
   "Land_Shed_M02",
   "Land_Misc_IronPipes_EP1",
   "Land_Wheel_cart_EP1"
];

RUBE_PACKERSET_MECHANICAL = [
   "Barrel1",
   "Barrel5",
   "Land_Ind_TankSmall",
   "Land_Pneu",
   "Misc_TyreHeap",
   "Paleta1",
   "Paleta2",
   "SmallTable",
   "PowGen_Big",
   "Misc_cargo_cont_small",
   "Misc_cargo_cont_small2",
   "Misc_cargo_cont_tiny",
   "Land_tires_EP1"
];

RUBE_PACKERSET_WOODWORKS = [
   "Axe_woodblock",
   "Barrel4",
   "Land_Ind_Timbers",
   "Land_Ind_BoardsPack1",
   "Land_Ind_BoardsPack2",
   "Misc_palletsfoiled",
   "Misc_palletsfoiled_heap",
   "Paleta1",
   "Paleta2",
   "PowGen_Big",
   "Land_Ind_Workshop01_box",
   "Land_Wheel_cart_EP1"
];

RUBE_TYPELIST_TABLEITEMS = [
   "EvMap", 
   "EvPhoto", 
   "EvMoney",
   "EvDogTags",
   "EvKobalt",
   "SatPhone", 
   "Notebook",
   "Radio",
   "SmallTV"
];

RUBE_TYPELIST_MEDICS = [
   "USMC_Soldier_Medic", 
   "CDF_Soldier_Medic", 
   "RU_Soldier_Medic", 
   "Ins_Soldier_Medic", 
   "GUE_Soldier_Medic",
   "US_Soldier_Medic_EP1", 
   "GER_Soldier_Medic_EP1", 
   "TK_Soldier_Medic_EP1", 
   "TK_INS_Bonesetter_EP1", 
   "TK_GUE_Bonesetter_EP1",
   "Doctor",
   "Dr_Hladik_EP1"
];

RUBE_TYPELIST_BUILDINGS_MILITARY = [
   "Camp",  
   "CampEast",
   "CampEast_EP1",
   "MASH", 
   "MASH_EP1", 
   "Land_tent_east",
   "Land_CamoNet_NATO",
   "Land_CamoNet_NATO_EP1",
   "Land_CamoNet_EAST",
   "Land_CamoNet_EAST_EP1",
   "Land_CamoNetB_NATO",
   "Land_CamoNetB_NATO_EP1",
   "Land_CamoNetB_EAST",
   "Land_CamoNetB_EAST_EP1",
   "Land_CamoNetVar_NATO",
   "Land_CamoNetVar_NATO_EP1",
   "Land_CamoNetVar_EAST",
   "Land_CamoNetVar_EAST_EP1",
   "Land_Fort_Watchtower",
   "Land_Fort_Watchtower_EP1",
   "Fort_Barricade",
   "Fort_Barricade_EP1",
   "Land_fortified_nest_big",
   "Land_fortified_nest_big_EP1",
   "Land_fortified_nest_small",
   "Land_fortified_nest_small_EP1",
   "Land_vez"
];

RUBE_TYPELIST_DRAGGABLE = [
   // TODO
];

RUBE_TYPELIST_DROPABLE = [
   // open trucks
   "KamazOpen", "UralOpen_CDF", "UralOpen_INS", "UralCivil2", 
   "V3S_Gue", "V3S_Civ", "V3S_Open_TK_CIV_EP1", "V3S_Open_TK_EP1",
   
   // closed trucks 
   "MTVR", "MTVR_DES_EP1", "Ural_CDF", "Ural_INS", "V3S_TK_EP1", 
   "V3S_TK_GUE_EP1", "Ural_UN_EP1", "Kamaz", "Ural_TK_CIV_EP1", 
   "Ural_UN_EP1", "V3S_TK_EP1", "V3S_TK_GUE_EP1",
   
   // "salvage"/supply trucks
   "WarfareSalvageTruck_USMC", "WarfareSalvageTruck_CDF", 
   "WarfareSalvageTruck_RU", "WarfareSalvageTruck_INS", 
   "WarfareSalvageTruck_Gue", "MtvrSupply_DES_EP1",
   "UralSupply_TK_EP1", "V3S_Supply_TK_GUE_EP1",
   
   // offroader/pickups
   "Pickup_PK_GUE", "Pickup_PK_INS", "datsun1_civil_1_open",
   "datsun1_civil_3_open", "hilux1_civil_1_open", "hilux1_civil_3_open",
   "hilux1_civil_3_open_EP1", "Offroad_DSHKM_Gue", "Offroad_DSHKM_INS",
   "Offroad_SPG9_Gue", "Offroad_DSHKM_TK_GUE_EP1", "Offroad_SPG9_TK_GUE_EP1",
   "Pickup_PK_TK_GUE_EP1"
];

