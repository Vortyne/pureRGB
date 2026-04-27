; PureRGBnote: ADDED: Many new hidden items were added versus the original game

DEF num_hidden_event_maps = 0

MACRO hidden_event_map
	db \1 ; map id
	DEF HIDDENEVENTMAP{num_hidden_event_maps} EQUS "\1"
	DEF num_hidden_event_maps += 1
ENDM


HiddenEventMaps:
	hidden_event_map VIRIDIAN_POKECENTER
	hidden_event_map VIRIDIAN_MART
	hidden_event_map VIRIDIAN_GYM
	hidden_event_map PEWTER_GYM
	hidden_event_map PEWTER_MART
	hidden_event_map PEWTER_POKECENTER
	hidden_event_map CERULEAN_POKECENTER
	hidden_event_map CERULEAN_GYM
	hidden_event_map CERULEAN_MART
	hidden_event_map LAVENDER_POKECENTER
	hidden_event_map VERMILION_POKECENTER
	hidden_event_map VERMILION_GYM
	hidden_event_map CELADON_MANSION_2F
	hidden_event_map CELADON_POKECENTER
	hidden_event_map CELADON_GYM
	hidden_event_map GAME_CORNER
	hidden_event_map CELADON_HOTEL
	hidden_event_map FUCHSIA_POKECENTER
	hidden_event_map FUCHSIA_GYM
	hidden_event_map CINNABAR_GYM
	hidden_event_map CINNABAR_POKECENTER
	hidden_event_map SAFFRON_GYM
	hidden_event_map MT_MOON_POKECENTER
	hidden_event_map ROCK_TUNNEL_POKECENTER
	hidden_event_map TRADE_CENTER
	hidden_event_map COLOSSEUM
	hidden_event_map VIRIDIAN_FOREST
	hidden_event_map MT_MOON_B2F
	hidden_event_map ROUTE_25
	hidden_event_map ROUTE_9
	hidden_event_map SS_ANNE_KITCHEN
	hidden_event_map SS_ANNE_B1F_ROOMS
	hidden_event_map ROCKET_HIDEOUT_B1F
	hidden_event_map ROCKET_HIDEOUT_B3F
	hidden_event_map ROCKET_HIDEOUT_B4F
	hidden_event_map SAFFRON_POKECENTER
	hidden_event_map POKEMON_TOWER_5F
	hidden_event_map ROUTE_13
	hidden_event_map SAFARI_ZONE_CENTER
	hidden_event_map SAFARI_ZONE_WEST
	hidden_event_map SILPH_CO_5F
	hidden_event_map SILPH_CO_9F
	hidden_event_map COPYCATS_HOUSE_2F
	hidden_event_map CERULEAN_CAVE_1F
	hidden_event_map CERULEAN_CAVE_B1F
	hidden_event_map POWER_PLANT
	hidden_event_map SEAFOAM_ISLANDS_B2F
	hidden_event_map SEAFOAM_ISLANDS_B4F
	hidden_event_map POKEMON_MANSION_1F
	hidden_event_map POKEMON_MANSION_3F
	hidden_event_map ROUTE_23
	hidden_event_map VICTORY_ROAD_2F
	hidden_event_map BILLS_HOUSE
	hidden_event_map VIRIDIAN_CITY
	hidden_event_map ROUTE_10
	hidden_event_map INDIGO_PLATEAU_LOBBY
	hidden_event_map CINNABAR_LAB_FOSSIL_ROOM
	hidden_event_map ROUTE_11
	hidden_event_map ROUTE_12
	hidden_event_map POKEMON_MANSION_2F
	hidden_event_map POKEMON_MANSION_B1F
	hidden_event_map SILPH_CO_11F
	hidden_event_map ROUTE_17
	hidden_event_map UNDERGROUND_PATH_NORTH_SOUTH
	hidden_event_map UNDERGROUND_PATH_WEST_EAST
	hidden_event_map CELADON_CITY
	hidden_event_map SEAFOAM_ISLANDS_B3F
	hidden_event_map VERMILION_CITY
	hidden_event_map CERULEAN_CITY
	hidden_event_map ROUTE_4
	hidden_event_map FOSSIL_GUYS_HOUSE
	hidden_event_map ROUTE_2
	hidden_event_map ROUTE_6
	hidden_event_map ROUTE_8
	hidden_event_map ROUTE_14
	hidden_event_map ROUTE_16
	hidden_event_map ROUTE_18
	hidden_event_map PEWTER_CITY
	hidden_event_map SAFARI_ZONE_NORTH
	hidden_event_map CERULEAN_ROCKET_HOUSE_B1F
	hidden_event_map DAYCARE
	hidden_event_map VIRIDIAN_SCHOOL_HOUSE_B1F
	hidden_event_map SECRET_LAB
	hidden_event_map TYPE_GUYS_HOUSE
	hidden_event_map CINNABAR_VOLCANO
	hidden_event_map SILPH_CO_1F
	hidden_event_map POKEMON_TOWER_B1F
	hidden_event_map ROUTE_21
	db -1 ; end

HiddenEventPointers:
; each of these pointers is for the corresponding map in HiddenEventMaps
FOR n, num_hidden_event_maps
	dw HiddenEventsFor_{HIDDENEVENTMAP{n}}
ENDR

MACRO hidden_events_for
	HiddenEventsFor_\1:
ENDM

MACRO hidden_event
	db \2 ; y coord
	db \1 ; x coord
	db \4 ; function argument
	dba \3 ; event function
ENDM

MACRO hidden_text_predef
	db \2 ; y coord
	db \1 ; x coord
	db_tx_pre \4 ; text id
	dba \3 ; event function
ENDM

; Some hidden events use SPRITE_FACING_* values,
; but these do not actually prevent the player
; from interacting with them in any direction.
DEF ANY_FACING EQU $d0

	hidden_events_for TRADE_CENTER
	hidden_event   5,  4, CableClubRightGameboy, ANY_FACING
	hidden_event   4,  4, CableClubLeftGameboy, ANY_FACING
	db -1 ; end

	hidden_events_for COLOSSEUM
	hidden_event   5,  4, CableClubRightGameboy, ANY_FACING
	hidden_event   4,  4, CableClubLeftGameboy, ANY_FACING
	db -1 ; end

	hidden_events_for VIRIDIAN_POKECENTER
	hidden_event  13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for VIRIDIAN_MART ; TODO: remove pointless event pointer?
	db -1 ; end

	hidden_events_for VIRIDIAN_GYM
	hidden_event  15, 15, GymStatues, SPRITE_FACING_UP
	hidden_event  18, 15, GymStatues, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for PEWTER_GYM
	hidden_event   3, 10, GymStatues, SPRITE_FACING_UP
	hidden_event   6, 10, GymStatues, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for PEWTER_MART ; TODO: pointless pointer
	db -1 ; end

	hidden_events_for PEWTER_POKECENTER
	hidden_event  13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for CERULEAN_POKECENTER
	hidden_event  13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for CERULEAN_GYM
	hidden_event   3, 11, GymStatues, SPRITE_FACING_UP
	hidden_event   6, 11, GymStatues, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for CERULEAN_MART ; TODO: pointless pointer
	db -1 ; end

	hidden_events_for LAVENDER_POKECENTER
	hidden_event  13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for VERMILION_POKECENTER
	hidden_event  13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for VERMILION_GYM
	hidden_event   3, 14, GymStatues, SPRITE_FACING_UP
	hidden_event   6, 14, GymStatues, SPRITE_FACING_UP
	;hidden_event   6,  1, PrintTrashText, SPRITE_FACING_DOWN ; PureRGBnote: CHANGED: gave this trash can near surge unique text
	; third param: [wGymTrashCanIndex]
	hidden_event   1,  7,  GymTrashScript,  0 
	hidden_event   1,  9,  GymTrashScript,  1
	hidden_event   1, 11,  GymTrashScript,  2
	hidden_event   3,  7,  GymTrashScript,  3
	hidden_event   3,  9,  GymTrashScript,  4
	hidden_event   3, 11,  GymTrashScript,  5
	hidden_event   5,  7,  GymTrashScript,  6
	hidden_event   5,  9,  GymTrashScript,  7
	hidden_event   5, 11,  GymTrashScript,  8
	hidden_event   7,  7,  GymTrashScript,  9
	hidden_event   7,  9,  GymTrashScript, 10
	hidden_event   7, 11,  GymTrashScript, 11
	hidden_event   9,  7,  GymTrashScript, 12
	hidden_event   9,  9,  GymTrashScript, 13
	hidden_event   9, 11,  GymTrashScript, 14
	db -1 ; end

	hidden_events_for CELADON_MANSION_2F
	hidden_event   0,  5, PorygonPCHiddenObject, SPRITE_FACING_UP
	hidden_event   1,  5, PorygonPCHiddenObject, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for CELADON_POKECENTER
	hidden_event  13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for CELADON_GYM
	hidden_event   3, 15, GymStatues, SPRITE_FACING_UP 
	hidden_event   6, 15, GymStatues, SPRITE_FACING_UP 
	db -1 ; end

	hidden_events_for GAME_CORNER
	hidden_event  18, 15, StartSlotMachine, ANY_FACING
	hidden_event  18, 14, StartSlotMachine, ANY_FACING
	hidden_event  18, 13, StartSlotMachine, ANY_FACING
	hidden_event  18, 12, StartSlotMachine, ANY_FACING
	hidden_event  18, 11, StartSlotMachine, ANY_FACING
	hidden_event  18, 10, StartSlotMachine, SLOTS_SOMEONESKEYS
	hidden_event  13, 10, StartSlotMachine, ANY_FACING
	hidden_event  13, 11, StartSlotMachine, ANY_FACING
	hidden_event  13, 12, StartSlotMachine, SLOTS_OUTTOLUNCH
	hidden_event  13, 13, StartSlotMachine, ANY_FACING
	hidden_event  13, 14, StartSlotMachine, ANY_FACING
	hidden_event  13, 15, StartSlotMachine, ANY_FACING
	; PureRGBnote: FIXED: this machine is inaccessible due to the NPC in front, and is blocking obtaining the coins
	; defined on its coordinate below, so remove it to make those coins accessible.
	;hidden_event  12, 15, StartSlotMachine, ANY_FACING 
	hidden_event  12, 14, StartSlotMachine, ANY_FACING
	hidden_event  12, 13, StartSlotMachine, ANY_FACING
	hidden_event  12, 12, StartSlotMachine, ANY_FACING
	hidden_event  12, 11, StartSlotMachine, ANY_FACING
	hidden_event  12, 10, StartSlotMachine, ANY_FACING
	hidden_event   7, 10, StartSlotMachine, ANY_FACING
	hidden_event   7, 11, StartSlotMachine, ANY_FACING
	hidden_event   7, 12, StartSlotMachine, ANY_FACING
	hidden_event   7, 13, StartSlotMachine, ANY_FACING
	hidden_event   7, 14, StartSlotMachine, ANY_FACING
	hidden_event   7, 15, StartSlotMachine, ANY_FACING
	hidden_event   6, 15, StartSlotMachine, ANY_FACING
	hidden_event   6, 14, StartSlotMachine, ANY_FACING
	hidden_event   6, 13, StartSlotMachine, ANY_FACING
	hidden_event   6, 12, StartSlotMachine, SLOTS_OUTOFORDER
	hidden_event   6, 11, StartSlotMachine, ANY_FACING
	hidden_event   6, 10, StartSlotMachine, ANY_FACING
	hidden_event   1, 10, StartSlotMachine, ANY_FACING
	hidden_event   1, 11, StartSlotMachine, ANY_FACING
	hidden_event   1, 12, StartSlotMachine, ANY_FACING
	hidden_event   1, 13, StartSlotMachine, ANY_FACING
	hidden_event   1, 14, StartSlotMachine, ANY_FACING
	hidden_event   1, 15, StartSlotMachine, ANY_FACING
	hidden_event   0,  8, HiddenCoins, COIN+10
	hidden_event   1, 16, HiddenCoins, COIN+10
	hidden_event   3, 11, HiddenCoins, COIN+20
	hidden_event   3, 14, HiddenCoins, COIN+10
	hidden_event   4, 12, HiddenCoins, COIN+10
	hidden_event   9, 12, HiddenCoins, COIN+20
	hidden_event   9, 15, HiddenCoins, COIN+10
	hidden_event  16, 14, HiddenCoins, COIN+10
	hidden_event  10, 16, HiddenCoins, COIN+10
	hidden_event  11,  7, HiddenCoins, COIN+40
	hidden_event  15,  8, HiddenCoins, COIN+100
	hidden_event  12, 15, HiddenCoins, COIN+10
	db -1 ; end

	hidden_events_for CELADON_HOTEL
	hidden_event  13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for FUCHSIA_POKECENTER
	hidden_event  13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for FUCHSIA_GYM
	hidden_event   3, 15, GymStatues, SPRITE_FACING_UP
	hidden_event   6, 15, GymStatues, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for CINNABAR_GYM
	hidden_event  17, 13, GymStatues, SPRITE_FACING_UP
	; third param: ([hGymGateAnswer] << 4) | [hGymGateIndex]
	hidden_event  15,  7, PrintCinnabarQuiz, (FALSE << 4) | 1
	hidden_event  10,  1, PrintCinnabarQuiz, (TRUE  << 4) | 2
	hidden_event   9,  7, PrintCinnabarQuiz, (TRUE  << 4) | 3
	hidden_event   9, 13, PrintCinnabarQuiz, (TRUE  << 4) | 4
	hidden_event   1, 13, PrintCinnabarQuiz, (TRUE  << 4) | 5
	hidden_event   1,  7, PrintCinnabarQuiz, (TRUE  << 4) | 6
	db -1 ; end

	hidden_events_for CINNABAR_POKECENTER
	hidden_event  13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for SAFFRON_GYM
	hidden_event   9, 15, GymStatues, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for MT_MOON_POKECENTER
	hidden_event  13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for ROCK_TUNNEL_POKECENTER
	hidden_event  13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for VIRIDIAN_FOREST
	hidden_event   1, 18, HiddenItems, HIDDEN_ITEM_VIRIDIAN_FOREST_NORTHWEST_BUG_CATCHER
	hidden_event  16, 42, HiddenItems, HIDDEN_ITEM_VIRIDIAN_FOREST_SOUTH_CENTRAL_TREE
	db -1 ; end

	hidden_events_for MT_MOON_B2F
	hidden_event  18, 12, HiddenItems, HIDDEN_ITEM_MT_MOON_ALCOVE_NEAR_SUPER_NERD
	hidden_event  33,  9, HiddenItems, HIDDEN_ITEM_MT_MOON_LONE_ROCK_DOWN_2ND_LADDER
	db -1 ; end

	hidden_events_for ROUTE_25
	hidden_event  38,  5, HiddenItems, HIDDEN_ITEM_ROUTE_25_FENCE_NEAR_EASTMOST_LASS
	hidden_event  10,  3, HiddenItems, HIDDEN_ITEM_ROUTE_25_ALCOVE_BEHIND_FIRST_HIKER
	db -1 ; end

	hidden_events_for ROUTE_9
	hidden_event  14,  7, HiddenItems, HIDDEN_ITEM_ROUTE_9_NORTHWEST_LONE_SHRUB
	hidden_event  32,  3, HiddenItems, HIDDEN_ITEM_ROUTE_9_NORTH_CENTRAL_GRASS_PATCH_NEW ; NEW
	db -1 ; end

	hidden_events_for SS_ANNE_KITCHEN
	hidden_event  13,  9, HiddenItems, HIDDEN_ITEM_SS_ANNE_KITCHEN_TRASH_CAN
	db -1 ; end

	hidden_events_for SS_ANNE_B1F_ROOMS
	hidden_event   3,  1, HiddenItems2, HIDDEN_ITEM_SS_ANNE_BED_PILLOW
	db -1 ; end

	hidden_events_for ROUTE_10
	hidden_event   9, 17, HiddenItems, HIDDEN_ITEM_ROUTE_10_NEAR_ROCK_TUNNEL_NORTH_ENTR
	hidden_event  16, 53, HiddenItems, HIDDEN_ITEM_ROUTE_10_SOUTHERN_LONE_SHRUB
	hidden_event  18, 52, Route10FlareonHiddenText, SPRITE_FACING_RIGHT
	db -1 ; end

	hidden_events_for ROCKET_HIDEOUT_B1F
	hidden_event  21, 15, HiddenItems, HIDDEN_ITEM_HIDEOUT_B1F_POTTED_PLANT
	db -1 ; end

	hidden_events_for ROCKET_HIDEOUT_B3F
	hidden_event  27, 17, HiddenItems, HIDDEN_ITEM_HIDEOUT_B3F_BESIDE_ITEM_BALL
	db -1 ; end

	hidden_events_for ROCKET_HIDEOUT_B4F
	hidden_event  25,  1, HiddenItems2, HIDDEN_ITEM_HIDEOUT_B4F_MACHINE_BEHIND_GIOVANNI
	db -1 ; end

	hidden_events_for SAFFRON_POKECENTER
	hidden_event  13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for POKEMON_TOWER_5F
	hidden_event   4, 12, HiddenItems2, HIDDEN_ITEM_TOWER_5F_ALCOVE_NEAR_WEST_STAIRS
	db -1 ; end

	hidden_events_for ROUTE_13
	hidden_event   1, 14, HiddenItems, HIDDEN_ITEM_ROUTE_13_SOUTHEAST_SHRUB_ALCOVE
	hidden_event  16, 13, HiddenItems, HIDDEN_ITEM_ROUTE_13_NEAR_SIGN
	hidden_event  42,  5, HiddenItems2, HIDDEN_ITEM_ROUTE_13_NORTHWEST_GRASS_PATCH_NEW ; NEW
	hidden_event   6,  3, PidgeotHiddenObject, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for SAFARI_ZONE_CENTER
	hidden_event  4, 14, HiddenItems, HIDDEN_ITEM_SAFARI_ZONE_CENTER_NEAR_WEST_EXIT ; used to be unobtainable, now it's obtainable in safari zone center
	db -1 ; end

	hidden_events_for SAFARI_ZONE_WEST
	hidden_event   6,  5, HiddenItems5, HIDDEN_ITEM_SAFARI_ZONE_WEST_POKEMON_STATUE
	db -1 ; end

	hidden_events_for SILPH_CO_5F
	hidden_event  12,  3, HiddenItems, HIDDEN_ITEM_SILPH_CO_5F_RIGHT_POTTED_PLANT
	db -1 ; end

	hidden_events_for SILPH_CO_9F
	hidden_event   2, 15, HiddenItems2, HIDDEN_ITEM_SILPH_CO_9F_BED_LEFT_OF_HEALING_LADY
	hidden_event  10,  7, HiddenItems, HIDDEN_ITEM_SILPH_CO_9F_ALCOVE_BESIDE_TABLES_NEW ; NEW
	db -1 ; end

	hidden_events_for COPYCATS_HOUSE_2F
	hidden_event   1,  1, HiddenItems, HIDDEN_ITEM_COPYCATS_HOUSE_2F_DESK
	db -1 ; end

	hidden_events_for CERULEAN_CAVE_1F
	hidden_event  14, 11, HiddenItems5, HIDDEN_ITEM_CERULEAN_CAVE_1F_RUBBLE_SQUARE
	db -1 ; end

	hidden_events_for CERULEAN_CAVE_B1F
	hidden_event  27,  3, HiddenItems5, HIDDEN_ITEM_CERULEAN_CAVE_B2F_RUBBLE_SQUARE
	db -1 ; end

	hidden_events_for POWER_PLANT
	hidden_event  17, 16, HiddenItems2, HIDDEN_ITEM_POWER_PLANT_CENTRAL_BOXES_ALCOVE
	hidden_event  12,  1, HiddenItems, HIDDEN_ITEM_POWER_PLANT_NEAR_ZAPDOS_ALCOVE
	hidden_event  11,  4, PowerPlantElectricity1, SPRITE_FACING_UP
	hidden_event  11,  5, PowerPlantElectricity2, SPRITE_FACING_UP
	hidden_event  11,  6, PowerPlantElectricity3, SPRITE_FACING_UP
	hidden_event  11,  7, PowerPlantElectricity4, SPRITE_FACING_UP
	hidden_event  50, 17, PowerPlantMagnet, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for SEAFOAM_ISLANDS_B2F
	hidden_event  15, 15, HiddenItems, HIDDEN_ITEM_SEAFOAM_B2F_LONE_ROCK
	db -1 ; end

	hidden_events_for SEAFOAM_ISLANDS_B4F
	hidden_event  25, 17, HiddenItems2, HIDDEN_ITEM_SEAFOAM_B4F_SURF_ALCOVE
	hidden_event   7, 12, SeafoamIslandsB4FFastCurrent, SPRITE_FACING_DOWN
	db -1 ; end

	hidden_events_for POKEMON_MANSION_1F
	hidden_event   8, 16, HiddenItems, HIDDEN_ITEM_MANSION_ENTRANCE_5TH_RIGHT_BOX
	hidden_event   2,  5, Mansion1Script_Switches, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for POKEMON_MANSION_2F
	hidden_event   2, 11, Mansion2Script_Switches, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for POKEMON_MANSION_3F
	hidden_event   1,  9, HiddenItems, HIDDEN_ITEM_MANSION_3F_WEST_ALCOVE
	hidden_event  10,  5, Mansion3Script_Switches, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for POKEMON_MANSION_B1F
	hidden_event   1,  9, HiddenItems, HIDDEN_ITEM_MANSION_B1F_CORNER_NEAR_SECRET_KEY
	hidden_event  20,  3, Mansion4Script_Switches, SPRITE_FACING_UP
	hidden_event  18, 25, Mansion4Script_Switches, SPRITE_FACING_UP
	hidden_event   3, 11, CheckUnlockLab, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for ROUTE_23
	hidden_event   9, 44, HiddenItems, HIDDEN_ITEM_ROUTE_23_ROCK_PILE_BEFORE_FINAL_GUARD
	hidden_event  19, 70, HiddenItems5, HIDDEN_ITEM_ROUTE_23_EAST_SHRUB_AFTER_WATER_SEGMENT
	hidden_event   8, 90, HiddenItems, HIDDEN_ITEM_ROUTE_23_TINY_ISLAND
	db -1 ; end

	hidden_events_for VICTORY_ROAD_2F
	hidden_event   5,  2, HiddenItems2, HIDDEN_ITEM_VICTORY_ROAD_MOLTRES_ROOM_LONE_ROCK
	hidden_event  26,  7, HiddenItems, HIDDEN_ITEM_VICTORY_ROAD_ROCK_OUTCROP_NEAR_EXIT
	db -1 ; end

	hidden_events_for BILLS_HOUSE
	hidden_event   1,  4, BillsHousePC, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for VIRIDIAN_CITY
	hidden_event  14,  4, HiddenItems, HIDDEN_ITEM_VIRIDIAN_CITY_CUT_TREE
	db -1 ; end

	hidden_events_for INDIGO_PLATEAU_LOBBY
	hidden_event  15,  7, OpenPokemonCenterPC, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for CINNABAR_LAB_FOSSIL_ROOM
	hidden_event   0,  4, PorygonPCHiddenObject, SPRITE_FACING_UP
	hidden_event   2,  4, OpenPokemonCenterPC, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for ROUTE_11
	hidden_event  48,  5, HiddenItems2, HIDDEN_ITEM_ROUTE_11_LONE_SHRUB
	db -1 ; end

	hidden_events_for ROUTE_12
	hidden_event   2, 63, HiddenItems2, HIDDEN_ITEM_ROUTE_12_NEAR_ROUTE_11_GATE
	db -1 ; end

	hidden_events_for SILPH_CO_11F
	hidden_event  10, 12, OpenPokemonCenterPC, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for ROUTE_17
	hidden_event  14,  15, HiddenItems, HIDDEN_ITEM_CYCLING_ROAD_GRASS
	hidden_event   9,  45, HiddenItems5, HIDDEN_ITEM_CYCLING_ROAD_CENTER_PATH
	hidden_event  16,  72, HiddenItems, HIDDEN_ITEM_CYCLING_ROAD_EAST_PATH_FLOWERS
	hidden_event   4,  90, HiddenItems2, HIDDEN_ITEM_CYCLING_ROAD_LEFT_PATH_FLOWERS
	hidden_event   9, 121, HiddenItems3, HIDDEN_ITEM_CYCLING_ROAD_SOUTH_PATH_MERGE
	db -1 ; end

	hidden_events_for UNDERGROUND_PATH_NORTH_SOUTH
	hidden_event   3,  4, HiddenItems, HIDDEN_ITEM_UNDERGROUND_ROUTE_5_6_2ND_COLUMN
	hidden_event   4, 34, HiddenItems, HIDDEN_ITEM_UNDERGROUND_ROUTE_5_6_3RD_COLUMN
	db -1 ; end

	hidden_events_for UNDERGROUND_PATH_WEST_EAST
	hidden_event  12,  2, HiddenItems, HIDDEN_ITEM_UNDERGROUND_ROUTE_8_7_2ND_ROW
	hidden_event  21,  5, HiddenItems3, HIDDEN_ITEM_UNDERGROUND_ROUTE_8_7_5TH_ROW
	db -1 ; end

	hidden_events_for CELADON_CITY
	hidden_event  48, 15, HiddenItems, HIDDEN_ITEM_CELADON_CITY_EAST
	hidden_event   3,  2, HiddenItems, HIDDEN_ITEM_CELADON_CITY_NORTHWEST_NEW
	hidden_event  48,  7, HiddenItems2, HIDDEN_ITEM_CELADON_CITY_EAST2_NEW
	db -1 ; end

	hidden_events_for SEAFOAM_ISLANDS_B3F
	hidden_event   9, 16, HiddenItems, HIDDEN_ITEM_SEAFOAM_B3F_LONE_ROCK
	db -1 ; end

	hidden_events_for VERMILION_CITY
	hidden_event  14, 13, HiddenItems2, HIDDEN_ITEM_VERMILION_CITY_SURF
	db -1 ; end

	hidden_events_for CERULEAN_CITY
	hidden_event  15,  8, HiddenItems, HIDDEN_ITEM_CERULEAN_CITY_NORTH_OF_BADGE_HOUSE
	db -1 ; end

	hidden_events_for ROUTE_4
	hidden_event  40,  3, HiddenItems, HIDDEN_ITEM_ROUTE_4_EMPTY_SQUARE_NEAR_CERULEAN
	db -1 ; end

; new hidden object areas start here

	hidden_events_for FOSSIL_GUYS_HOUSE
	hidden_event  2, 4, FossilGuysPC, SPRITE_FACING_UP
	db -1 ; end	

	hidden_events_for ROUTE_2
	hidden_event  18, 66, HiddenItems5, HIDDEN_ITEM_ROUTE_2_SOUTHEAST_FLOWERS_NEW ; NEW
	hidden_event  16,  1, Route2JigglypuffHiddenObject, SPRITE_FACING_UP	
	db -1 ; end

	hidden_events_for ROUTE_6
	hidden_event  6, 4, HiddenItems3, HIDDEN_ITEM_ROUTE_6_NORTHWEST_FLOWERS_NEW ; NEW
	hidden_event  2, 27, PsyduckShadowDistance, SPRITE_FACING_UP 
	db -1 ; end

	hidden_events_for ROUTE_8
	hidden_event  34, 14, HiddenItems3, HIDDEN_ITEM_ROUTE_8_GRASS ; NEW
	hidden_event  19,  5, HiddenItems, HIDDEN_ITEM_ROUTE_8_BETWEEN_CENTER_LEDGES ; NEW
	hidden_event   4,  7, JolteonRightSide, SPRITE_FACING_LEFT 
	hidden_event   5,  8, JolteonRightSide, SPRITE_FACING_DOWN
	hidden_event   2,  8, JolteonLeftSide, SPRITE_FACING_RIGHT
	db -1 ; end

	hidden_events_for ROUTE_14
	hidden_event   4, 19, HiddenItems3, HIDDEN_ITEM_ROUTE_14_GRASS_NEW ; NEW
	db -1 ; end

	hidden_events_for ROUTE_16
	hidden_event   2,  2, HiddenItems2, HIDDEN_ITEM_ROUTE_16_NORTHWEST_FLOWERS_NEW ; NEW
	hidden_event  36,  2, MankeyHiddenObject, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for ROUTE_18
	hidden_event   7,  9, HiddenItems2, HIDDEN_ITEM_CYCLING_ROAD_SOUTHWEST_CORNER_NEW ; NEW
	db -1 ; end

	hidden_events_for PEWTER_CITY
	hidden_event  23,  2, HiddenItems, HIDDEN_ITEM_PEWTER_OUTSIDE_MUSEUM_ALCOVE_NEW ; NEW
	db -1 ; end

	hidden_events_for SAFARI_ZONE_NORTH
	hidden_event   7, 13, HiddenItems3, HIDDEN_ITEM_SAFARI_ZONE_NORTH_NORTHWEST_NEW ; NEW
	db -1 ; end

	hidden_events_for CERULEAN_ROCKET_HOUSE_B1F
	hidden_event  2,  5,  RocketBasementMachine, SPRITE_FACING_UP
	hidden_event  3,  5,  RocketBasementMachine, SPRITE_FACING_UP
	hidden_event  4,  5,  RocketBasementMachine, SPRITE_FACING_UP
	hidden_event  5,  5,  RocketBasementMachine, SPRITE_FACING_UP
	hidden_event  6,  5,  RocketBasementMachine, SPRITE_FACING_UP
	hidden_event  7,  5,  RocketBasementMachine, SPRITE_FACING_UP
	hidden_event  8,  5,  RocketBasementMachine, SPRITE_FACING_UP
	hidden_event  9,  5,  RocketBasementMachine, SPRITE_FACING_UP
	hidden_event  10,  5, RocketBasementMachine, SPRITE_FACING_UP
	hidden_event  11,  5, RocketBasementMachine, SPRITE_FACING_UP
	hidden_event  12,  5, RocketBasementMachine, SPRITE_FACING_UP
	hidden_event  13,  5, RocketBasementMachine, SPRITE_FACING_UP
	hidden_event  14,  5, RocketBasementMachine, SPRITE_FACING_UP
	hidden_event  15,  5, RocketBasementMachine, SPRITE_FACING_UP
	db -1 ; end	

	hidden_events_for DAYCARE
	hidden_event  4,  1, OpenPokemonCenterPC, SPRITE_FACING_UP
	db -1 ; end

	hidden_events_for VIRIDIAN_SCHOOL_HOUSE_B1F
	hidden_event   0,  1, ViridianSchoolHouseB1FBookCases, 0
	hidden_event   1,  1, ViridianSchoolHouseB1FBookCases, 13
	hidden_event  16,  1, ViridianSchoolHouseB1FBookCases, 26
	hidden_event  17,  1, ViridianSchoolHouseB1FBookCases, 39
	db -1 ; end

	hidden_events_for SECRET_LAB
	hidden_event  9, 25, HiddenItems, HIDDEN_ITEM_SECRET_LAB_RIGHT_BUTTON ; NEW
	hidden_event  1, 10, SecretLabFailedClones, 0
	hidden_event  3, 10, SecretLabFailedClones, 1
	hidden_event  6, 10, SecretLabFailedClones, 2
	hidden_event  8, 10, SecretLabFailedClones, 3
	hidden_event  1, 13, SecretLabFailedClones, 4
	hidden_event  3, 13, SecretLabFailedClones, 5
	hidden_event  6, 13, SecretLabFailedClones, 6
	hidden_event  8, 13, SecretLabFailedClones, 7
	hidden_event  1, 8, SecretLabComputers, 0
	hidden_event  2, 8, SecretLabComputers, 1
	hidden_event  3, 8, SecretLabComputers, 2
	hidden_event  4, 8, SecretLabComputers, 3
	hidden_event  6, 7, SecretLabMewtwoMachine, SPRITE_FACING_UP
	hidden_event  7, 7, SecretLabMewtwoMachine, SPRITE_FACING_UP
	db -1

	hidden_events_for TYPE_GUYS_HOUSE
	hidden_event  12, 0, TypeGuysHouseLightSwitch, 0
	hidden_event   8, 3, TypeGuysHouseComputer, 0
	hidden_event   9, 3, TypeGuysHouseComputer, 0
	db -1

	hidden_events_for CINNABAR_VOLCANO
	hidden_event  43, 64, VolcanoHiddenItemInit, HIDDEN_ITEM_VOLCANO_LAVA_SEA_NEW ; NEW
	hidden_event  34, 28, VolcanoBombableRockFloor1, 0
	hidden_event  48, 38, VolcanoBombableRockFloor2, 0
	hidden_event  50, 50, VolcanoBombableRockFloor3, 0
	hidden_event  48, 66, VolcanoBombableRockFloor4, 0
	db -1

	hidden_events_for SILPH_CO_1F
	hidden_event  37, 13, SaffronAbandonedBuildingHeliumPipe, 0
	db -1

	hidden_events_for POKEMON_TOWER_B1F
	hidden_event  5, 48, PokemonTowerB1FFirstGrave, 0
	hidden_event  5, 42, PokemonTowerB1FSecondGrave, 0
	hidden_event  5, 36, PokemonTowerB1FThirdGrave, 0
	hidden_event  5, 30, PokemonTowerB1FFourthGrave, 0
	db -1

	hidden_events_for ROUTE_21
	hidden_event  9, 53, Route21CinnabarVolcanoSign, 0
	db -1
