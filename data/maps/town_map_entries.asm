MACRO outdoor_map
	dn \2, \1
	dw \3
ENDM

; PureRGBnote: CHANGED: some coordinates were changed for better positioning here
; the appearance of towns and routes in the town map
ExternalMapEntries:
	table_width 3
	; x, y, name
	outdoor_map  2, 11, PalletTownName
	outdoor_map  2,  8, ViridianCityName
	outdoor_map  2,  3, PewterCityName
	outdoor_map 10,  2, CeruleanCityName
	outdoor_map 14,  5, LavenderTownName
	outdoor_map 10,  9, VermilionCityName
	outdoor_map  7,  5, CeladonCityName
	outdoor_map 10,  5, SaffronCityName
	outdoor_map  8, 13, FuchsiaCityName
	outdoor_map  2, 15, CinnabarIslandName
	outdoor_map  0,  2, IndigoPlateauName
	outdoor_map  0,  0, PalletTownName ; unused
	outdoor_map  2, 10, Route1Name
	outdoor_map  2,  6, Route2Name
	outdoor_map  4,  3, Route3Name
	outdoor_map  8,  2, Route4Name
	outdoor_map 10,  3, Route5Name
	outdoor_map 10,  7, Route6Name
	outdoor_map  8,  5, Route7Name
	outdoor_map 12,  5, Route8Name
	outdoor_map 13,  2, Route9Name
	outdoor_map 14,  4, Route10Name
	outdoor_map 12,  9, Route11Name
	outdoor_map 14,  8, Route12Name
	outdoor_map 13, 11, Route13Name
	outdoor_map 11, 12, Route14Name
	outdoor_map 10, 13, Route15Name
	outdoor_map  5,  5, Route16Name
	outdoor_map  4,  8, Route17Name
	outdoor_map  6, 13, Route18Name
	outdoor_map  6, 15, Route19Name
	outdoor_map  4, 15, Route20Name
	outdoor_map  2, 13, Route21Name
	outdoor_map  0,  8, Route22Name
	outdoor_map  0,  6, Route23Name
	outdoor_map 10,  1, Route24Name
	outdoor_map 11,  0, Route25Name
	assert_table_length FIRST_INDOOR_MAP


MACRO indoor_map
	db \1 + 1
	dn \3, \2
	dw \4
ENDM

; PureRGBnote: CHANGED: some coordinates were changed for better positioning here
; the appearance of buildings and dungeons in the town map
InternalMapEntries:
	table_width 4
	; indoor map group, x, y, name
	indoor_map OAKS_LAB,                       2, 11, PalletTownName
	indoor_map VIRIDIAN_GYM,                   2,  8, ViridianCityName
	indoor_map DIGLETTS_CAVE_ROUTE_2,          3,  4, DiglettsCaveName
	indoor_map VIRIDIAN_FOREST_NORTH_GATE,     2,  4, Route2Name
	indoor_map VIRIDIAN_FOREST_SOUTH_GATE,     2,  5, Route2Name
	indoor_map VIRIDIAN_FOREST,                2,  4, ViridianForestName
	indoor_map PEWTER_POKECENTER,              2,  3, PewterCityName
	indoor_map MT_MOON_B2F,                    6,  2, MountMoonName
	indoor_map CERULEAN_MART,                 10,  2, CeruleanCityName
	indoor_map MT_MOON_POKECENTER,             5,  2, Route4Name
	indoor_map POWER_PLANT_ROOF,              15,  3, PowerPlantName
	indoor_map DAYCARE,                       10,  4, Route5Name
	indoor_map UNDERGROUND_PATH_ROUTE_6_COPY, 10,  6, Route6Name
	indoor_map UNDERGROUND_PATH_ROUTE_7_COPY,  9,  5, Route7Name
	indoor_map UNDERGROUND_PATH_ROUTE_8,      11,  5, Route8Name
	indoor_map ROCK_TUNNEL_POKECENTER,        14,  3, Route10Name
	indoor_map ROCK_TUNNEL_1F,                14,  3, RockTunnelName
	indoor_map POWER_PLANT,                   15,  3, PowerPlantName
	indoor_map ROUTE_11_GATE_1F,              13,  9, Route11Name
	indoor_map DIGLETTS_CAVE_ROUTE_11,        11,  8, DiglettsCaveName
	indoor_map ROUTE_11_GATE_2F,              13,  9, Route11Name
	indoor_map ROUTE_12_GATE_1F,              14,  7, Route12Name
	indoor_map BILLS_HOUSE,                   12,  0, SeaCottageName
	indoor_map VERMILION_DOCK,                10,  9, VermilionCityName
	indoor_map SS_ANNE_B1F_ROOMS,              9, 10, SSAnneName
	indoor_map CERULEAN_ROCKET_HOUSE_B1F,     10,  2, CeruleanCityName
	indoor_map VICTORY_ROAD_1F,                0,  4, VictoryRoadName
	indoor_map VIRIDIAN_SCHOOL_HOUSE_B1F,      2,  8, ViridianCityName
	indoor_map BILLS_GARDEN,                  13,  0, BillsGardenName
	indoor_map SECRET_LAB,                     2, 15, PokemonMansionName
	indoor_map CHAMP_ARENA,                    0,  2, PokemonLeagueName
	indoor_map DIAMOND_MINE,                  12,  4, DiamondMineName
	indoor_map CINNABAR_VOLCANO_WEST,          1, 13, CinnabarVolcanoName
	indoor_map HALL_OF_FAME,                   0,  2, PokemonLeagueName
	indoor_map UNDERGROUND_PATH_NORTH_SOUTH,  10,  5, UndergroundPathName
	indoor_map CHAMPIONS_ROOM,                 0,  2, PokemonLeagueName
	indoor_map UNDERGROUND_PATH_WEST_EAST,    10,  5, UndergroundPathName
	indoor_map CELADON_HOTEL,                  7,  5, CeladonCityName
	indoor_map LAVENDER_POKECENTER,           14,  5, LavenderTownName
	indoor_map POKEMON_TOWER_7F,              15,  4, PokemonTowerName
	indoor_map LAVENDER_CUBONE_HOUSE,         14,  5, LavenderTownName
	indoor_map WARDENS_HOUSE,                  8, 13, FuchsiaCityName
	indoor_map SAFARI_ZONE_GATE,               8, 12, SafariZoneName
	indoor_map FUCHSIA_MEETING_ROOM,           8, 13, FuchsiaCityName
	indoor_map SEAFOAM_ISLANDS_B4F,            5, 15, SeafoamIslandsName
	indoor_map VERMILION_OLD_ROD_HOUSE,       10,  9, VermilionCityName
	indoor_map FUCHSIA_GOOD_ROD_HOUSE,         8, 13, FuchsiaCityName
	indoor_map POKEMON_MANSION_1F,             2, 15, PokemonMansionName
	indoor_map CINNABAR_MART,                  2, 15, CinnabarIslandName
	indoor_map TYPE_GUYS_HOUSE,                0,  6, Route23Name
	indoor_map INDIGO_PLATEAU_LOBBY,           0,  2, IndigoPlateauName
	indoor_map MR_PSYCHICS_HOUSE,             10,  5, SaffronCityName
	indoor_map ROUTE_15_GATE_2F,               9, 13, Route15Name
	indoor_map ROUTE_16_FLY_HOUSE,             4,  5, Route16Name
	indoor_map ROUTE_12_SUPER_ROD_HOUSE,      14, 10, Route12Name
	indoor_map ROUTE_18_GATE_2F,               7, 13, Route18Name
	indoor_map SEAFOAM_ISLANDS_1F,             5, 15, SeafoamIslandsName
	indoor_map ROUTE_22_GATE,                  0,  7, Route22Name
	indoor_map VICTORY_ROAD_2F,                0,  4, VictoryRoadName
	indoor_map ROUTE_12_GATE_2F,              14,  7, Route12Name
	indoor_map VERMILION_TRADE_HOUSE,         10,  9, VermilionCityName
	indoor_map DIGLETTS_CAVE,                 11,  8, DiglettsCaveName
	indoor_map VICTORY_ROAD_3F,                0,  4, VictoryRoadName
	indoor_map ROCKET_HIDEOUT_ELEVATOR,        7,  5, RocketHQName
	indoor_map FUCHSIA_TREE_DELETER_HOUSE,     8, 13, FuchsiaCityName
	indoor_map FOSSIL_GUYS_HOUSE,             10,  5, SaffronCityName
	indoor_map SILPH_CO_8F,                   10,  5, SilphCoName
	indoor_map POKEMON_MANSION_B1F,            2, 15, PokemonMansionName
	indoor_map SAFARI_ZONE_NORTH_REST_HOUSE,   8, 12, SafariZoneName
	indoor_map CERULEAN_CAVE_1F,               9,  1, CeruleanCaveName
	indoor_map NAME_RATERS_HOUSE,             14,  5, LavenderTownName
	indoor_map CERULEAN_BADGE_HOUSE,          10,  2, CeruleanCityName
	indoor_map ROCK_TUNNEL_B1F,               14,  3, RockTunnelName
	indoor_map SILPH_CO_ELEVATOR,             10,  5, SilphCoName
	indoor_map AGATHAS_ROOM,                   0,  2, PokemonLeagueName
	db -1 ; end
