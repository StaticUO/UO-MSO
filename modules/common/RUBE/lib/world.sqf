/*
   the RUBE UFO Project,
   an object library of objects without classes
  
 > _world should be defined 
   before loading RUBE and set to one of the
   following options:
   
   - "A2": only Arma2 objects are registered 
           (and searched against)      
   - "OA": only Operation Arrowhead objects...
   - "CO": A2 and OA objects
   
     - default = "OA"
   
 > provided functions, 
   all taking an object and returning boolean:
    
    - RUBE_WORLD_isTree
    - RUBE_WORLD_isBush
    - RUBE_WORLD_isPlant
    - RUBE_WORLD_isStone
    - RUBE_WORLD_isRoad (without(!) sideways, dams, 
      brigdes, runways or invisible roads/paths.  
      Feel free to modify as needed... all objects
      are still listed below, just commented out...)
    - RUBE_WORLD_isRunway
    - RUBE_WORLD_isPond
    
 --  
   - all lowercase, 
   - without suffix ".p3d"
*/

_world = "CO";
_addons = [];

switch (toLower worldName) do
{
   // A2 worlds
   case "chernarus": { _world = "A2"; };
   case "utes": { _world = "A2"; };
   
   // OA
   case "takistan": { _world = "CO"; };
   case "zargabad": { _world = "CO"; };
   case "desert_e": { _world = "OA"; };
   
   // DLC
   case "shapur_baf": { _world = "CO"; };
   case "provinggrounds_pmc": 
   { 
      _world = "CO";
      _addons set [(count _addons), "PMC"];
   };
};


RUBE_WORLD_TREE = [];
RUBE_WORLD_BUSH = [];
RUBE_WORLD_PLANT = [];
RUBE_WORLD_STONE = [];
RUBE_WORLD_ROAD = [];
RUBE_WORLD_RUNWAY = [];
RUBE_WORLD_POND = [];

////////////////////////////////////////////////////////////
// Arma2
if (_world in ["A2", "CO"]) then
{
   // tree
   {
      RUBE_WORLD_TREE set [(count RUBE_WORLD_TREE), _x];
   } forEach [
      "t_acer2s",
      "t_alnus2s",
      "t_betula1f",
      "t_betula2f",
      "t_betula2s",
      "t_betula2w",
      "t_carpinus2s",
      "t_fagus2f",
      "t_fagus2s",
      "t_fagus2w",
      "t_fraxinus2s",
      "t_fraxinus2w",
      "t_larix3f",
      "t_larix3s",
      "t_malus1s",
      "t_picea1s",
      "t_picea2s",
      "t_picea3f",
      "t_pinusn1s",
      "t_pinusn2s",
      "t_pinuss2f",
      "t_populus3s",
      "t_pyrus2s",
      "t_quercus2f",
      "t_quercus3s",
      "t_salix2s",
      "t_sorbus2s",
      "t_stub_picea"
   ];
   
   // bush
   {
      RUBE_WORLD_BUSH set [(count RUBE_WORLD_BUSH), _x];
   } forEach [
      "b_betulahumilis",
      "b_canina2s",
      "b_corylus",
      "b_corylus2s",
      "b_craet1",
      "b_craet2",
      "b_pmugo",
      "b_prunus",
      "b_salix2s",
      "b_sambucus"
   ];
   
   // plant
   {
      RUBE_WORLD_PLANT set [(count RUBE_WORLD_PLANT), _x];
   } forEach [
      "lopuch_podzimni",
      "pumpkin",
      "pumpkin2",
      "p_articum",
      "p_carduus",
      "p_helianthus",
      "p_heracleum",
      "p_phragmites",
      "p_urtica",
      "sunflower"
   ];
   
   // stone
   {
      RUBE_WORLD_STONE set [(count RUBE_WORLD_STONE), _x];
   } forEach [
      "r2_boulder1",
      "r2_boulder2",
      "r2_rock1",
      "r2_rock2",
      "r2_rocktower",
      "r2_rockwall",
      "r2_stone"
   ];
   
   // road
   {
      RUBE_WORLD_ROAD set [(count RUBE_WORLD_ROAD), _x];
   } forEach [
   /*
     // dam
      "dam_barrier_40",
      "dam_conc_20",
      "dam_concp_20",
     // bridges
      "bridge_asf1_25",
      "bridge_stone_asf2_25",
      "bridge_wood_25",
     // runway
      "runwayold_40_main",
      "runwayold_80_dirt",
      "runway_beton",
      "runway_beton_end1",
      "runway_beton_end2",
      "runway_dirt_1",
      "runway_dirt_2",
      "runway_dirt_3",
      "runway_end15",
      "runway_end33",
      "runway_main",
      "runway_main_40",
      "runway_poj_draha",
      "runway_poj_l_1",
      "runway_poj_l_1_end",
      "runway_poj_l_2",
      "runway_poj_l_2_end",
      "runway_poj_spoj",
      "runway_poj_spoj_2",
      "runway_poj_t_1",
      "runway_poj_t_2",
   */
   /*
     // invisible roads/paths
      "path_0 2000",
      "path_1 1000",
      "path_10 100",
      "path_10 25",
      "path_10 50",
      "path_10 75",
      "path_12",
      "path_15 75",
      "path_22 50",
      "path_25",
      "path_30 25",
      "path_6",
      "path_60 10",
      "path_6konec",
      "path_7 100",
      "road_invisible",
      "road_invisible_t",     
   */
     // regular roads
      "asf1_0 2000",
      "asf1_1 1000",
      "asf1_10 100",
      "asf1_10 25",
      "asf1_10 50",
      "asf1_10 75",
      "asf1_12",
      "asf1_15 75",
      "asf1_22 50",
      "asf1_25",
      "asf1_30 25",
      "asf1_6",
      "asf1_60 10",
      "asf1_6konec",
      "asf1_6_crosswalk",
      "asf1_7 100",
      "asf2_0 2000",
      "asf2_1 1000",
      "asf2_10 100",
      "asf2_10 25",
      "asf2_10 50",
      "asf2_10 75",
      "asf2_12",
      "asf2_15 75",
      "asf2_22 50",
      "asf2_25",
      "asf2_30 25",
      "asf2_6",
      "asf2_60 10",
      "asf2_6konec",
      "asf2_6_crosswalk",
      "asf2_7 100",
      "asf3_0 2000",
      "asf3_1 1000",
      "asf3_10 100",
      "asf3_10 25",
      "asf3_10 50",
      "asf3_10 75",
      "asf3_12",
      "asf3_15 75",
      "asf3_22 50",
      "asf3_25",
      "asf3_30 25",
      "asf3_6",
      "asf3_60 10",
      "asf3_6konec",
      "asf3_7 100",
      "city_0 2000",
      "city_1 1000",
      "city_10 100",
      "city_10 25",
      "city_10 50",
      "city_10 75",
      "city_12",
      "city_15 75",
      "city_22 50",
      "city_25",
      "city_30 25",
      "city_6",
      "city_60 10",
      "city_6konec",
      "city_6_crosswalk",
      "city_7 100",
      "grav_0 2000",
      "grav_1 1000",
      "grav_10 100",
      "grav_10 25",
      "grav_10 50",
      "grav_10 75",
      "grav_12",
      "grav_15 75",
      "grav_22 50",
      "grav_25",
      "grav_30 25",
      "grav_6",
      "grav_60 10",
      "grav_6konec",
      "grav_7 100",
      "kr_t_asf1_asf2",
      "kr_t_asf1_asf3",
      "kr_t_asf1_city",
      "kr_t_asf2_asf2",
      "kr_t_asf2_asf3",
      "kr_t_asf3_asf2",
      "kr_t_asf3_asf3",
      "kr_t_asf3_grav",
      "kr_t_asf3_mud",
      "kr_t_city_asf3",
      "kr_t_city_city",
      "kr_t_mud_mud",
      "kr_x_asf1_asf3",
      "kr_x_asf1_city",
      "kr_x_asf2_asf3",
      "kr_x_asf2_city",
      "kr_x_city_asf3",
      "kr_x_city_city",
      "kr_x_city_city_asf3",
      "mud_0 2000",
      "mud_1 1000",
      "mud_10 100",
      "mud_10 25",
      "mud_10 50",
      "mud_10 75",
      "mud_12",
      "mud_15 75",
      "mud_22 50",
      "mud_25",
      "mud_30 25",
      "mud_6",
      "mud_60 10",
      "mud_6konec",
      "mud_7 100"
   ];
   
   // runway
   {
      RUBE_WORLD_RUNWAY set [(count RUBE_WORLD_RUNWAY), _x];
   } forEach [
      "road_invisible", // road-network-fix (without runway)
      "runwayold_40_main",
      "runwayold_80_dirt",
      "runway_beton",
      "runway_beton_end1",
      "runway_beton_end2",
      "runway_dirt_1",
      "runway_dirt_2",
      "runway_dirt_3",
      "runway_end15",
      "runway_end33",
      "runway_main",
      "runway_main_40",
      "runway_poj_draha",
      "runway_poj_l_1",
      "runway_poj_l_1_end",
      "runway_poj_l_2",
      "runway_poj_l_2_end",
      "runway_poj_spoj",
      "runway_poj_spoj_2",
      "runway_poj_t_1",
      "runway_poj_t_2"
   ];
   
   // pond
   {
      RUBE_WORLD_POND set [(count RUBE_WORLD_POND), _x];
   } forEach [
      "pondtest",
      "pondtest_repro_scale",
      "pond_big_01",
      "pond_big_02",
      "pond_big_28_01",
      "pond_big_28_02",
      "pond_big_28_03",
      "pond_big_28_04",
      "pond_big_29_01",
      "pond_big_29_02",
      "pond_big_29_03",
      "pond_big_29_04",
      "pond_big_30_01",
      "pond_big_30_02",
      "pond_big_30_03",
      "pond_big_30_04",
      "pond_big_31_01",
      "pond_big_31_02",
      "pond_big_31_03",
      "pond_big_31_04",
      "pond_big_32_01",
      "pond_big_32_02",
      "pond_big_32_03",
      "pond_big_33_01",
      "pond_big_33_02",
      "pond_big_33_03",
      "pond_big_34_01",
      "pond_big_34_02",
      "pond_big_34_03",
      "pond_big_34_04",
      "pond_big_35_01",
      "pond_big_35_02",
      "pond_big_36_01",
      "pond_big_36_02",
      "pond_big_36_03",
      "pond_big_36_04",
      "pond_big_37_01",
      "pond_big_37_02",
      "pond_big_37_03",
      "pond_big_37_04",
      "pond_big_38_01",
      "pond_big_38_02",
      "pond_big_38_03",
      "pond_big_38_04",
      "pond_big_39_01",
      "pond_big_39_02",
      "pond_big_39_03",
      "pond_big_39_04",
      "pond_big_40_01",
      "pond_big_40_02",
      "pond_big_40_03",
      "pond_big_40_04",
      "pond_big_41_01",
      "pond_big_41_02",
      "pond_big_41_03",
      "pond_big_41_04",
      "pond_big_41_05",
      "pond_big_42_01",
      "pond_big_42_02",
      "pond_big_42_03",
      "pond_big_42_04",
      "pond_big_42_05",
      "pond_big_42_06",
      "pond_big_42_07",
      "pond_big_42_08",
      "pond_big_42_09",
      "pond_big_42_10",
      "pond_big_42_11",
      "pond_big_42_12",
      "pond_big_42_13",
      "pond_big_42_14",
      "pond_big_42_15",
      "pond_big_42_16",
      "pond_big_42_17",
      "pond_big_42_18",
      "pond_big_42_19",
      "pond_big_42_20",
      "pond_big_43_01",
      "pond_big_43_02",
      "pond_big_43_03",
      "pond_big_43_04",
      "pond_big_43_05",
      "pond_big_43_06",
      "pond_big_43_07",
      "pond_big_43_08",
      "pond_big_43_09",
      "pond_big_43_10",
      "pond_big_43_11",
      "pond_big_43_12",
      "pond_big_43_13",
      "pond_big_43_14",
      "pond_big_43_15",
      "pond_big_43_16",
      "pond_big_43_17",
      "pond_big_43_18",
      "pond_big_43_19",
      "pond_big_43_20",
      "pond_big_43_21",
      "pond_big_43_22",
      "pond_big_43_23",
      "pond_big_43_24",
      "pond_big_43_25",
      "pond_big_43_26",
      "pond_big_43_27",
      "pond_big_43_28",
      "pond_big_43_29",
      "pond_big_43_30",
      "pond_big_43_31",
      "pond_big_43_32",
      "pond_big_43_33",
      "pond_big_43_34",
      "pond_big_43_35",
      "pond_big_43_36",
      "pond_big_44",
      "pond_small_01",
      "pond_small_02",
      "pond_small_03",
      "pond_small_04",
      "pond_small_05",
      "pond_small_06",
      "pond_small_07",
      "pond_small_08",
      "pond_small_09",
      "pond_small_10",
      "pond_small_11",
      "pond_small_12",
      "pond_small_13",
      "pond_small_14",
      "pond_small_15",
      "pond_small_16",
      "pond_small_17",
      "pond_small_18",
      "pond_small_19",
      "pond_small_20",
      "pond_small_21",
      "pond_small_22",
      "pond_small_23",
      "pond_small_24",
      "pond_small_25",
      "pond_small_26",
      "pond_small_27",
      "pont_big_01",
      "pont_big_02",
      "pont_small_01"
   ];
};


////////////////////////////////////////////////////////////
// Operation Arrowhead
if (_world in ["OA", "CO"]) then
{
   // tree
   {
      RUBE_WORLD_TREE set [(count RUBE_WORLD_TREE), _x];
   } forEach [
      "t_amygdalusc2s_ep1",
      "t_ficusb2s_ep1",
      "t_juniperusc2s_ep1",
      "t_pinuse2s_ep1",
      "t_pinuss3s_ep1",
      "t_pistacial2s_ep1",
      "t_populusb2s_ep1",
      "t_populusf2s_ep1",
      "t_prunuss2s_ep1"
   ];
   
   // bush
   {
      RUBE_WORLD_BUSH set [(count RUBE_WORLD_BUSH), _x];
   } forEach [
      "b_amygdalusn1s_ep1",
      "b_pinusm1s_ep1",
      "b_pistacial1s_ep1"
   ];
   
   // plant
   {
      RUBE_WORLD_PLANT set [(count RUBE_WORLD_PLANT), _x];
   } forEach [
      "p_fiberplant_ep1",
      "p_papaver_ep1",
      "p_wheat_ep1"
   ];
   
   // stone
   {
      RUBE_WORLD_STONE set [(count RUBE_WORLD_STONE), _x];
   } forEach [
      "r_boulder_01_ep1",
      "r_boulder_02_ep1",
      "r_boulder_03_ep1",
      "r_rock_01_ep1",
      "r_rock_02_ep1",
      "r_rock_03_ep1",
      "r_stone_01_ep1",
      "r_stone_02_ep1",
      "r_tk_boulder_01_ep1",
      "r_tk_boulder_02_ep1",
      "r_tk_boulder_03_ep1",
      "r_tk_rock_01_ep1",
      "r_tk_rock_02_ep1",
      "r_tk_rock_03_ep1",
      "r_tk_stone_01_ep1",
      "r_tk_stone_02_ep1"
   ];
   
   // road
   {
      RUBE_WORLD_ROAD set [(count RUBE_WORLD_ROAD), _x];
   } forEach [
   /*
     // sidewalks
      "sw_a_body_6m_ep1",
      "sw_a_end_l_ep1",
      "sw_a_end_r_ep1",
      "sw_a_turn_ep1",
      "sw_b_body_6m_ep1",
      "sw_b_end_l_ep1",
      "sw_b_end_r_ep1",
      "sw_c_body_6m_ep1",
      "sw_c_crosst_ep1",
      "sw_c_end_l_ep1",
      "sw_c_end_r_ep1",
      "sw_c_turn_ep1",   
     // runway
      "runway_beton_end1_ep1",
      "runway_beton_end2_ep1",
      "runway_beton_ep1",
      "runway_dirt_1_ep1",
      "runway_dirt_2_ep1",
      "runway_dirt_3_ep1",
      "runway_end00_ep1",
      "runway_end04_ep1",
      "runway_end06_ep1",
      "runway_end09_ep1",
      "runway_end15_ep1",
      "runway_end18_ep1",
      "runway_end22_ep1",
      "runway_end24_ep1",
      "runway_end27_ep1",
      "runway_end33_ep1",
      "runway_main_40_ep1",
      "runway_main_ep1",
      "runway_poj_draha_ep1",
      "runway_poj_l_1_end_ep1",
      "runway_poj_l_1_ep1",
      "runway_poj_l_2_end_ep1",
      "runway_poj_l_2_ep1",
      "runway_poj_spoj_2_ep1",
      "runway_poj_spoj_ep1",
      "runway_poj_t_1_ep1",
      "runway_poj_t_2_ep1",   
   */
   /*
     // invisible roads/paths
      "path_02000",
      "path_11000",
      "path_12",
      "path_1575",
      "path_2250",
      "path_25",
      "path_3025",
      "path_6",
      "path_6010",
      "path_6konec",
      "path_7100",
      "road_invisible",
      "road_invisible_t",
   */
     // regular roads
      "asf10_w10_a0_286_r2000",
      "asf10_w10_a0_573_r1000",
      "asf10_w10_a0_573_r2000",
      "asf10_w10_a11_459_r100",
      "asf10_w10_a11_459_r50",
      "asf10_w10_a15_279_r75",
      "asf10_w10_a1_146_r1000",
      "asf10_w10_a1_146_r500",
      "asf10_w10_a22_918_r25",
      "asf10_w10_a22_918_r50",
      "asf10_w10_a2_292_r500",
      "asf10_w10_a2_865_r200",
      "asf10_w10_a45_837_r25",
      "asf10_w10_a5_73_r100",
      "asf10_w10_a5_73_r200",
      "asf10_w10_a7_639_r75",
      "asf10_w10_l10",
      "asf10_w10_l10_term",
      "asf10_w10_l20",
      "asf12_w12_a0_344_r2000",
      "asf12_w12_a0_688_r1000",
      "asf12_w12_a0_688_r2000",
      "asf12_w12_a13_751_r100",
      "asf12_w12_a13_751_r50",
      "asf12_w12_a18_335_r75",
      "asf12_w12_a1_375_r1000",
      "asf12_w12_a1_375_r500",
      "asf12_w12_a27_502_r25",
      "asf12_w12_a27_502_r50",
      "asf12_w12_a2_75_r500",
      "asf12_w12_a3_438_r200",
      "asf12_w12_a55_004_r25",
      "asf12_w12_a68_755_r10",
      "asf12_w12_a6_875_r100",
      "asf12_w12_a6_875_r200",
      "asf12_w12_a9_167_r75",
      "asf12_w12_l12",
      "asf12_w12_l12_term",
      "asf12_w12_l24",
      "asf1_02000",
      "asf1_11000",
      "asf1_12",
      "asf1_1575",
      "asf1_2250",
      "asf1_25",
      "asf1_3025",
      "asf1_6",
      "asf1_6010",
      "asf1_6konec",
      "asf1_7100",
      "asf2_02000",
      "asf2_11000",
      "asf2_12",
      "asf2_1575",
      "asf2_2250",
      "asf2_25",
      "asf2_3025",
      "asf2_6",
      "asf2_6010",
      "asf2_6konec",
      "asf2_7100",
      "dirt10_w10_a0_286_r2000",
      "dirt10_w10_a0_573_r1000",
      "dirt10_w10_a0_573_r2000",
      "dirt10_w10_a11_459_r100",
      "dirt10_w10_a11_459_r50",
      "dirt10_w10_a15_279_r75",
      "dirt10_w10_a1_146_r1000",
      "dirt10_w10_a1_146_r500",
      "dirt10_w10_a22_918_r25",
      "dirt10_w10_a22_918_r50",
      "dirt10_w10_a2_292_r500",
      "dirt10_w10_a2_865_r200",
      "dirt10_w10_a45_837_r25",
      "dirt10_w10_a57_296_r10",
      "dirt10_w10_a5_73_r100",
      "dirt10_w10_a5_73_r200",
      "dirt10_w10_a7_639_r75",
      "dirt10_w10_l10",
      "dirt10_w10_l10_term",
      "dirt10_w10_l20",
      "dirt1_02000",
      "dirt1_11000",
      "dirt1_12",
      "dirt1_1575",
      "dirt1_2250",
      "dirt1_25",
      "dirt1_3025",
      "dirt1_6",
      "dirt1_6010",
      "dirt1_6konec",
      "dirt1_7100",
      "dirt2_02000",
      "dirt2_11000",
      "dirt2_12",
      "dirt2_1575",
      "dirt2_2250",
      "dirt2_25",
      "dirt2_3025",
      "dirt2_6",
      "dirt2_6010",
      "dirt2_6konec",
      "dirt2_7100",
      "dirt7_w7_a0_201_r2000",
      "dirt7_w7_a0_401_r1000",
      "dirt7_w7_a0_401_r2000",
      "dirt7_w7_a0_802_r1000",
      "dirt7_w7_a0_802_r500",
      "dirt7_w7_a10_695_r75",
      "dirt7_w7_a16_043_r25",
      "dirt7_w7_a16_043_r50",
      "dirt7_w7_a1_604_r500",
      "dirt7_w7_a2_005_r200",
      "dirt7_w7_a32_086_r25",
      "dirt7_w7_a40_107_r10",
      "dirt7_w7_a4_011_r100",
      "dirt7_w7_a4_011_r200",
      "dirt7_w7_a5_348_r75",
      "dirt7_w7_a80_214_r10",
      "dirt7_w7_a8_021_r100",
      "dirt7_w7_a8_021_r50",
      "dirt7_w7_l14",
      "dirt7_w7_l7",
      "dirt7_w7_l7_term",
      "kr_t_asf10_w10_asf10_w10_asf10_w10",
      "kr_t_asf10_w10_asf10_w10_asf12_w12",
      "kr_t_asf10_w10_asf10_w10_dirt10_w10",
      "kr_t_asf10_w10_asf10_w10_dirt7_w7",
      "kr_t_asf12_w12_asf12_w12_asf10_w10",
      "kr_t_asf12_w12_asf12_w12_asf12_w12",
      "kr_t_asf12_w12_asf12_w12_dirt10_w10",
      "kr_t_asf12_w12_asf12_w12_dirt7_w7",
      "kr_t_asf1_asf2",
      "kr_t_asf1_dirt1",
      "kr_t_asf1_dirt2",
      "kr_t_asf2_dirt2",
      "kr_t_dirt10_w10_dirt10_w10_asf10_w10",
      "kr_t_dirt10_w10_dirt10_w10_dirt10_w10",
      "kr_t_dirt10_w10_dirt10_w10_dirt7_w7",
      "kr_t_dirt7_w7_dirt7_w7_asf10_w10",
      "kr_t_dirt7_w7_dirt7_w7_dirt10_w10",
      "kr_t_dirt7_w7_dirt7_w7_dirt7_w7",
      "kr_x_asf10_w10_dirt10_w10_asf10_w10_asf10_w10",
      "kr_x_asf10_w10_dirt7_w7_asf10_w10_asf10_w10",
      "kr_x_asf10_w10_dirt7_w7_dirt7_w7_asf10_w10",
      "kr_x_asf12_w12_asf10_w10_asf12_w12_asf10_w10",
      "kr_x_asf12_w12_asf10_w10_asf12_w12_asf12_w12",
      "kr_x_asf12_w12_asf12_w12_asf12_w12_asf12_w12",
      "kr_x_asf12_w12_dirt10_w10_asf12_w12_dirt10_w10",
      "kr_x_asf12_w12_dirt7_w7_asf12_w12_asf10_w10",
      "kr_x_asf12_w12_dirt7_w7_asf12_w12_dirt10_w10",
      "kr_x_asf1_asf1",
      "kr_x_asf1_asf2",
      "kr_x_asf1_dirt2",
      "kr_x_dirt10_w10_asf10_w10_dirt10_w10_dirt10_w10",
      "kr_x_dirt10_w10_dirt7_w7_dirt10_w10_dirt10_w10",
      "kr_x_dirt10_w10_dirt7_w7_dirt10_w10_dirt7_w7",
      "kr_x_dirt7_w7_dirt7_w7_dirt7_w7_dirt7_w7"
   ];
   
   // runway
   {
      RUBE_WORLD_RUNWAY set [(count RUBE_WORLD_RUNWAY), _x];
   } forEach [
      "road_invisible", // road-network-fix (without runway)
      "runway_beton_end1_ep1",
      "runway_beton_end2_ep1",
      "runway_beton_ep1",
      "runway_dirt_1_ep1",
      "runway_dirt_2_ep1",
      "runway_dirt_3_ep1",
      "runway_end00_ep1",
      "runway_end04_ep1",
      "runway_end06_ep1",
      "runway_end09_ep1",
      "runway_end15_ep1",
      "runway_end18_ep1",
      "runway_end22_ep1",
      "runway_end24_ep1",
      "runway_end27_ep1",
      "runway_end33_ep1",
      "runway_main_40_ep1",
      "runway_main_ep1",
      "runway_poj_draha_ep1",
      "runway_poj_l_1_end_ep1",
      "runway_poj_l_1_ep1",
      "runway_poj_l_2_end_ep1",
      "runway_poj_l_2_ep1",
      "runway_poj_spoj_2_ep1",
      "runway_poj_spoj_ep1",
      "runway_poj_t_1_ep1",
      "runway_poj_t_2_ep1"
   ];
   
   // pond
   {
      RUBE_WORLD_POND set [(count RUBE_WORLD_POND), _x];
   } forEach [
      "airport_pond",
      "feeruzabad_pond_1",
      "feeruzabad_pond_2",
      "kakaru_pond",
      "nagara_pond_1",
      "nagara_pond_2",
      "nagara_pond_3",
      "rasman_pond",
      "ravanay_pond",
      "test_pond",
      "zr_dam_01_ep1",
      "zr_dam_02_ep1",
      "zr_dam_03_ep1",
      "zr_dam_04_ep1",
      "zr_dam_05_ep1",
      "zr_dam_06_ep1",
      "zr_dam_07_ep1",
      "zr_dam_08_ep1",
      "zr_dam_09_ep1"
   ];
};


// load addons
if ("PMC" in _addons) then
{
   // plant
   {
      RUBE_WORLD_PLANT set [(count RUBE_WORLD_PLANT), _x];
   } forEach [
      "c_grassgreen_grouphard_pmc",
      "c_grassdesert_groupsoft_pmc",
      "c_grassgreen_groupsoft_pmc",
      "c_carduus_pmc",
      "c_branchbig_pmc",
      "c_grasscrooked_pmc",
      "c_grasstall_pmc",
      "c_grassdrylongbunch_pmc"
   ];
};


////////////////////////////////////////////////////////////
// UFO functions

// [haystack, needels(, shift)] => boolean
RUBE_WORLD_search = {
   private ["_match", "_shift"];
   _match = false;
   _shift = 0;
   if ((count _this) > 2) then
   {
      _shift = _this select 2;
   };
   
   {
      if ([_x, (_this select 0), _shift] call RUBE_isSuffix) exitWith
      {
         _match = true;
      };
   } forEach (_this select 1);
   
   _match
};


// object => boolean
RUBE_WORLD_isTree = {
   if ((typeOf _this) != "") exitWith 
   {
      false
   };
   
   ([(format["%1", _this]), RUBE_WORLD_TREE, 4] call RUBE_WORLD_search)
};

// object => boolean
RUBE_WORLD_isBush = {
   if ((typeOf _this) != "") exitWith 
   {
      false
   };
   
   ([(format["%1", _this]), RUBE_WORLD_BUSH, 4] call RUBE_WORLD_search)
};

// object => boolean
RUBE_WORLD_isPlant = {
   if ((typeOf _this) != "") exitWith 
   {
      false
   };
   
   ([(format["%1", _this]), RUBE_WORLD_PLANT, 4] call RUBE_WORLD_search)
};

// object => boolean
RUBE_WORLD_isStone = {
   if ((typeOf _this) != "") exitWith 
   {
      false
   };
   
   ([(format["%1", _this]), RUBE_WORLD_STONE, 4] call RUBE_WORLD_search)
};

// object => boolean
RUBE_WORLD_isRoad = {
   if ((typeOf _this) != "") exitWith 
   {
      false
   };
   
   ([(format["%1", _this]), RUBE_WORLD_ROAD, 4] call RUBE_WORLD_search)
};

// object => boolean
RUBE_WORLD_isRunway = {
   if ((typeOf _this) != "") exitWith 
   {
      false
   };
   
   ([(format["%1", _this]), RUBE_WORLD_RUNWAY, 4] call RUBE_WORLD_search)
};

// object => boolean
RUBE_WORLD_isPond = {
   if ((typeOf _this) != "") exitWith 
   {
      false
   };
   
   ([(format["%1", _this]), RUBE_WORLD_POND, 4] call RUBE_WORLD_search)
};