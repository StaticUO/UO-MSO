/*
   RUBE
    the init file
*/

#define COMPILE_FILE(dir) (compile preprocessFileLineNumbers (dir))
#define COMPILE_RUBE(localDir) COMPILE_FILE("modules\common\RUBE\" + localDir)

// load the BIS functions library first
createCenter SideLogic;
RUBE_GroupLogic = createGroup SideLogic;
_logic = RUBE_GroupLogic CreateUnit ["FunctionsManager",[0,0,0],[],0,"NONE"];


// load core...
[] call (COMPILE_RUBE("lib\core.sqf"));
[] call (COMPILE_RUBE("lib\strings.sqf"));
[] call (COMPILE_RUBE("lib\world.sqf"));
[] call (COMPILE_RUBE("lib\typelists.sqf"));
[] call (COMPILE_RUBE("lib\supervisor.sqf"));


// string functions
RUBE_inString = COMPILE_RUBE("fn\fn_inString.sqf");
RUBE_isSuffix = COMPILE_RUBE("fn\fn_isSuffix.sqf");
RUBE_pad = COMPILE_RUBE("fn\fn_pad.sqf");

// math, statistics
RUBE_average = COMPILE_RUBE("fn\fn_average.sqf");
RUBE_descriptiveStatistics = COMPILE_RUBE("fn\fn_descriptiveStatistics.sqf");
RUBE_erfcc = COMPILE_RUBE("fn\fn_erfcc.sqf");
RUBE_pearsonCorrelation = COMPILE_RUBE("fn\fn_pearsonCorrelation.sqf");
RUBE_histogram = COMPILE_RUBE("fn\fn_histogram.sqf");
RUBE_chance = COMPILE_RUBE("fn\fn_chance.sqf");
RUBE_roundTo = COMPILE_RUBE("fn\fn_roundTo.sqf");
RUBE_randomWalk = COMPILE_RUBE("fn\fn_randomWalk.sqf");
RUBE_randomGauss = COMPILE_RUBE("fn\fn_randomGauss.sqf");
RUBE_neville = COMPILE_RUBE("fn\fn_neville.sqf");
RUBE_bezier = COMPILE_RUBE("fn\fn_bezier.sqf");
RUBE_bspline = COMPILE_RUBE("fn\fn_bspline.sqf");

// (world/map) geometry
RUBE_averagePosition = COMPILE_RUBE("fn\fn_averagePosition.sqf");
RUBE_bearing = COMPILE_RUBE("fn\fn_bearing.sqf");
RUBE_dirDiff = COMPILE_RUBE("fn\fn_dirDiff.sqf");
RUBE_dirInArc = COMPILE_RUBE("fn\fn_dirInArc.sqf");
RUBE_lineSegmentIntersection = COMPILE_RUBE("fn\fn_lineSegmentIntersection.sqf");
RUBE_convexHull = COMPILE_RUBE("fn\fn_convexHull.sqf");
RUBE_polygonCentroid = COMPILE_RUBE("fn\fn_polygonCentroid.sqf");
RUBE_polygonArea = COMPILE_RUBE("fn\fn_polygonArea.sqf");
RUBE_distanceFilter = COMPILE_RUBE("fn\fn_distanceFilter.sqf");

// date, time
RUBE_sun = COMPILE_RUBE("fn\fn_sun.sqf");
RUBE_moonphase = COMPILE_RUBE("fn\fn_moonphase.sqf");
RUBE_weekday = COMPILE_RUBE("fn\fn_weekday.sqf");
RUBE_daylightHours = COMPILE_RUBE("fn\fn_daylightHours.sqf");
RUBE_seasonCoeff = COMPILE_RUBE("fn\fn_seasonCoeff.sqf");

// arrays, matrices, data-structures...
RUBE_insertSort = COMPILE_RUBE("fn\fn_insertSort.sqf");
RUBE_shellSort = COMPILE_RUBE("fn\fn_shellSort.sqf");
RUBE_arrayReverse = COMPILE_RUBE("fn\fn_arrayReverse.sqf");
RUBE_arrayMin = COMPILE_RUBE("fn\fn_arrayMin.sqf");
RUBE_arrayMax = COMPILE_RUBE("fn\fn_arrayMax.sqf");
RUBE_arrayMap = COMPILE_RUBE("fn\fn_arrayMap.sqf");
RUBE_arrayFilter = COMPILE_RUBE("fn\fn_arrayFilter.sqf");
RUBE_arrayDropIndex = COMPILE_RUBE("fn\fn_arrayDropIndex.sqf");
RUBE_arraySwap = COMPILE_RUBE("fn\fn_arraySwap.sqf");
RUBE_arrayMultiMerge = COMPILE_RUBE("fn\fn_arrayMultiMerge.sqf");
RUBE_arrayAppend = COMPILE_RUBE("fn\fn_arrayAppend.sqf");
RUBE_arrayInsert = COMPILE_RUBE("fn\fn_arrayInsert.sqf");
RUBE_arrayInterpolate = COMPILE_RUBE("fn\fn_arrayInterpolate.sqf");
RUBE_distribute = COMPILE_RUBE("fn\fn_distribute.sqf");
RUBE_multipass = COMPILE_RUBE("fn\fn_multipass.sqf");


// classes, sides and factions
RUBE_isMale = COMPILE_RUBE("fn\fn_isMale.sqf");
RUBE_initSides = COMPILE_RUBE("fn\fn_initSides.sqf");
RUBE_extractConfigEntries = COMPILE_RUBE("fn\fn_extractConfigEntries.sqf");
RUBE_isWeapon = COMPILE_RUBE("fn\fn_isWeapon.sqf");
RUBE_isMagazine = COMPILE_RUBE("fn\fn_isMagazine.sqf");
RUBE_selectCrew = COMPILE_RUBE("fn\fn_selectCrew.sqf");
RUBE_spawnVehicle = COMPILE_RUBE("fn\fn_spawnVehicle.sqf");
RUBE_spawnCrew = COMPILE_RUBE("fn\fn_spawnCrew.sqf");
RUBE_selectFactionInfo = COMPILE_RUBE("fn\fn_selectFactionInfo.sqf");
RUBE_selectFactionUnit = COMPILE_RUBE("fn\fn_selectFactionUnit.sqf");
RUBE_selectFactionWeapon = COMPILE_RUBE("fn\fn_selectFactionWeapon.sqf");
RUBE_selectFactionAmmobox = COMPILE_RUBE("fn\fn_selectFactionAmmobox.sqf");
RUBE_selectFactionBuilding = COMPILE_RUBE("fn\fn_selectFactionBuilding.sqf");
RUBE_selectFactionVehicle = COMPILE_RUBE("fn\fn_selectFactionVehicle.sqf");
RUBE_selectCivilian = COMPILE_RUBE("fn\fn_selectCivilian.sqf");
RUBE_selectCivilianCar = COMPILE_RUBE("fn\fn_selectCivilianCar.sqf");
RUBE_spawnFactionUnit = COMPILE_RUBE("fn\fn_spawnFactionUnit.sqf");
RUBE_spawnFactionGroup = COMPILE_RUBE("fn\fn_spawnFactionGroup.sqf");
RUBE_spawnCivilians = COMPILE_RUBE("fn\fn_spawnCivilians.sqf");

// random values & positions
RUBE_randomPop = COMPILE_RUBE("fn\fn_randomPop.sqf");
RUBE_randomBetween = COMPILE_RUBE("fn\fn_randomBetween.sqf");
RUBE_randomSelect = COMPILE_RUBE("fn\fn_randomSelect.sqf");
RUBE_randomSubSet = COMPILE_RUBE("fn\fn_randomSubSet.sqf");
RUBE_randomizeValue = COMPILE_RUBE("fn\fn_randomizeValue.sqf");
RUBE_randomizePos = COMPILE_RUBE("fn\fn_randomizePos.sqf");
RUBE_randomCirclePositions = COMPILE_RUBE("fn\fn_randomCirclePositions.sqf");
RUBE_randomWorldPosition = COMPILE_RUBE("fn\fn_randomWorldPosition.sqf");
RUBE_randomLocation = COMPILE_RUBE("fn\fn_randomLocation.sqf");

// units & groups
RUBE_groupReady = COMPILE_RUBE("fn\fn_groupReady.sqf");
RUBE_aliveGroup = COMPILE_RUBE("fn\fn_aliveGroup.sqf");
RUBE_deleteGroup = COMPILE_RUBE("fn\fn_deleteGroup.sqf");
RUBE_getVehicleCrew = COMPILE_RUBE("fn\fn_getVehicleCrew.sqf");
RUBE_getGroupVehicles = COMPILE_RUBE("fn\fn_getGroupVehicles.sqf");
RUBE_assignAsTurret = COMPILE_RUBE("fn\fn_assignAsTurret.sqf");
RUBE_splitGroup = COMPILE_RUBE("fn\fn_splitGroup.sqf");
RUBE_removeWeapon = COMPILE_RUBE("fn\fn_removeWeapon.sqf");
RUBE_removeHandgun = COMPILE_RUBE("fn\fn_removeHandgun.sqf");
RUBE_updateWaypoint = COMPILE_RUBE("fn\fn_updateWaypoint.sqf");
RUBE_makeKnown = COMPILE_RUBE("fn\fn_makeKnown.sqf");
RUBE_getEnemyContact = COMPILE_RUBE("fn\fn_getEnemyContact.sqf");
RUBE_isEngaging = COMPILE_RUBE("fn\fn_isEngaging.sqf");

// objects, buildings, positions, directions, etc.
RUBE_createTrigger = COMPILE_RUBE("fn\fn_createTrigger.sqf");
RUBE_normalizeDirection = COMPILE_RUBE("fn\fn_normalizeDirection.sqf");
RUBE_getALD = COMPILE_RUBE("fn\fn_getALD.sqf");
RUBE_getPosASL = COMPILE_RUBE("fn\fn_getPosASL.sqf");
RUBE_maxFlatEmptyArea = COMPILE_RUBE("fn\fn_maxFlatEmptyArea.sqf");
RUBE_positionExpValue = COMPILE_RUBE("fn\fn_positionExpValue.sqf");
RUBE_sampleTerrain = COMPILE_RUBE("fn\fn_sampleTerrain.sqf");
RUBE_samplePeriphery = COMPILE_RUBE("fn\fn_samplePeriphery.sqf");
RUBE_analyzePeriphery = COMPILE_RUBE("fn\fn_analyzePeriphery.sqf");
RUBE_midwayPosition = COMPILE_RUBE("fn\fn_midwayPosition.sqf");
RUBE_offsetPosition = COMPILE_RUBE("fn\fn_offsetPosition.sqf");
RUBE_getTentPositions = COMPILE_RUBE("fn\fn_getTentPositions.sqf");
RUBE_getBuildingPositions = COMPILE_RUBE("fn\fn_getBuildingPositions.sqf");
RUBE_perimeterRoads = COMPILE_RUBE("fn\fn_perimeterRoads.sqf");
RUBE_closeDoors = COMPILE_RUBE("fn\fn_closeDoors.sqf");
RUBE_blast = COMPILE_RUBE("fn\fn_blast.sqf");
RUBE_boundingBoxSize = COMPILE_RUBE("fn\fn_boundingBoxSize.sqf");
RUBE_scaledBoundingBox = COMPILE_RUBE("fn\fn_scaledBoundingBox.sqf"); 
RUBE_setArmament = COMPILE_RUBE("fn\fn_setArmament.sqf");
RUBE_setLoadout = COMPILE_RUBE("fn\fn_setLoadout.sqf");
RUBE_getObjectDimensions = COMPILE_RUBE("fn\fn_getObjectDimensions.sqf");
RUBE_objectInDesert = COMPILE_RUBE("fn\fn_objectInDesert.sqf");
RUBE_rectangleBlockSplit = COMPILE_RUBE("fn\fn_rectangleBlockSplit.sqf");
RUBE_rectanglePacker = COMPILE_RUBE("fn\fn_rectanglePacker.sqf");
RUBE_gridCellDepth = COMPILE_RUBE("fn\fn_gridCellDepth.sqf");
RUBE_gridCellPosition = COMPILE_RUBE("fn\fn_gridCellPosition.sqf");
RUBE_gridOffsetPosition = COMPILE_RUBE("fn\fn_gridOffsetPosition.sqf");
RUBE_spawnObjects = COMPILE_RUBE("fn\fn_spawnObjects.sqf");
RUBE_spawnObjectChain = COMPILE_RUBE("fn\fn_spawnObjectChain.sqf");
RUBE_spawnObjectCircle = COMPILE_RUBE("fn\fn_spawnObjectCircle.sqf");
RUBE_spawnObjectCloud = COMPILE_RUBE("fn\fn_spawnObjectCloud.sqf");
RUBE_spawnObjectGrid = COMPILE_RUBE("fn\fn_spawnObjectGrid.sqf");
RUBE_spawnTable = COMPILE_RUBE("fn\fn_spawnTable.sqf");
RUBE_spawnPackedArea = COMPILE_RUBE("fn\fn_spawnPackedArea.sqf");
RUBE_packVehicle = COMPILE_RUBE("fn\fn_packVehicle.sqf");

// input listeners
RUBE_addInputListener = COMPILE_RUBE("fn\fn_addInputListener.sqf");
RUBE_removeInputListener = COMPILE_RUBE("fn\fn_removeInputListener.sqf");
(call (COMPILE_RUBE("fn\fn_addInputListenerLib.sqf")));

// actions
RUBE_addAction = COMPILE_RUBE("fn\fn_addAction.sqf");
RUBE_removeAction = COMPILE_RUBE("fn\fn_removeAction.sqf");

// action: dragg-/droppable objects
RUBE_makeDroppable = COMPILE_RUBE("fn\fn_makeDroppable.sqf");
RUBE_makeDraggable = COMPILE_RUBE("fn\fn_makeDraggable.sqf");
(call (COMPILE_RUBE("fn\fn_makeDraggableLib.sqf")));

// action: buildables and supplies
RUBE_makeBuildable = COMPILE_RUBE("fn\fn_makeBuildable.sqf");
(call (COMPILE_RUBE("fn\fn_makeBuildableLib.sqf")));
(call (COMPILE_RUBE("fn\fn_makeSuppliesLib.sqf")));

// map & markers
RUBE_readMarkers = COMPILE_RUBE("fn\fn_readMarkers.sqf");
RUBE_mapDrawLine = COMPILE_RUBE("fn\fn_mapDrawLine.sqf");
RUBE_mapDrawMarker = COMPILE_RUBE("fn\fn_mapDrawMarker.sqf");
RUBE_findRoute = COMPILE_RUBE("fn\fn_findRoute.sqf");
RUBE_plotRoute = COMPILE_RUBE("fn\fn_plotRoute.sqf");

// particle effects
RUBE_PE_Building = COMPILE_RUBE("pe\pe_building.sqf");
RUBE_PE_DragObj = COMPILE_RUBE("pe\pe_dragObj.sqf");
RUBE_PE_Blood = COMPILE_RUBE("pe\pe_blood.sqf");
RUBE_PE_houseBurn = COMPILE_RUBE("pe\pe_houseBurn.sqf");
RUBE_PE_catchFire = COMPILE_RUBE("pe\pe_catchFire.sqf");
RUBE_PE_catchFireSmoke = COMPILE_RUBE("pe\pe_catchFireSmoke.sqf");

// recipes (dynamic compositions & behaviour)
RUBE_RECIPE_chaosSpawn = COMPILE_RUBE("recipes\recipe_chaosSpawn.sqf");
RUBE_RECIPE_findCampPosition = COMPILE_RUBE("recipes\recipe_findCampPosition.sqf");
RUBE_RECIPE_forestCamp = COMPILE_RUBE("recipes\recipe_forestCamp.sqf");
RUBE_RECIPE_protectiveBarrier = COMPILE_RUBE("recipes\recipe_protectiveBarrier.sqf");
RUBE_RECIPE_baseEntrance = COMPILE_RUBE("recipes\recipe_baseEntrance.sqf");
RUBE_RECIPE_townOccupation = COMPILE_RUBE("recipes\recipe_townOccupation.sqf");
RUBE_RECIPE_garrisonAreaBuildings = COMPILE_RUBE("recipes\recipe_garrisonAreaBuildings.sqf");
RUBE_RECIPE_findSmallCampPosition = COMPILE_RUBE("recipes\recipe_findSmallCampPosition.sqf");

// AI
RUBE_AI_spawnGuard = COMPILE_RUBE("ai\ai_spawnGuard.sqf");
RUBE_AI_taskPatrol = COMPILE_RUBE("ai\ai_taskPatrol.sqf");
RUBE_AI_waitingInTheWings = COMPILE_RUBE("ai\ai_waitingInTheWings.sqf");

// AI SUBROUTINES SELECTOR
RUBE_AI_selectSubroutine = COMPILE_RUBE("ai\ai_selectSubroutine.sqf");

// AI SUBROUTINES (these are no functions and need to be spawned, not called.)
RUBE_AISR_secureNearestBuilding = COMPILE_RUBE("aisr\aisr_secureNearestBuilding.sqf");
RUBE_AISR_watchHorizon = COMPILE_RUBE("aisr\aisr_watchHorizon.sqf");
RUBE_AISR_regroup = COMPILE_RUBE("aisr\aisr_regroup.sqf");
RUBE_AISR_convoyDefend = COMPILE_RUBE("aisr\aisr_convoyDefend.sqf");


// AI COEFFICIENTS (generic AI coeficients (0.0 (not/negative) to 1.0 (true/totally)))
RUBE_AICOEF_inTheOpen = COMPILE_RUBE("aicoef\aicoef_inTheOpen.sqf");
RUBE_AICOEF_inTown = COMPILE_RUBE("aicoef\aicoef_inTown.sqf");
RUBE_AICOEF_inForest = COMPILE_RUBE("aicoef\aicoef_inForest.sqf");
RUBE_AICOEF_outOfFormation = COMPILE_RUBE("aicoef\aicoef_outOfFormation.sqf");

[] spawn {
	waitUntil{!isnil "BIS_fnc_init"};
	RUBE_fnc_init = true;
};