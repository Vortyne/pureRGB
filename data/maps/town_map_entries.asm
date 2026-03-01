MACRO external_map
	dn \2, \1
	dw \3
ENDM

; PureRGBnote: CHANGED: some coordinates were changed for better positioning here
; the appearance of towns and routes in the town map
ExternalMapEntries:
	table_width 3
	; x, y, name
	external_map  2, 11, PalletTownName
	external_map  2,  8, ViridianCityName
	external_map  2,  3, PewterCityName
	external_map 10,  2, CeruleanCityName
	external_map 14,  5, LavenderTownName
	external_map 10,  9, VermilionCityName
	external_map  7,  5, CeladonCityName
	external_map 10,  5, SaffronCityName
	external_map  8, 13, FuchsiaCityName
	external_map  2, 15, CinnabarIslandName
	external_map  0,  2, IndigoPlateauName
	external_map  0,  0, PalletTownName ; unused
	external_map  2, 10, Route1Name
	external_map  2,  6, Route2Name
	external_map  4,  3, Route3Name
	external_map  8,  2, Route4Name
	external_map 10,  3, Route5Name
	external_map 10,  7, Route6Name
	external_map  8,  5, Route7Name
	external_map 12,  5, Route8Name
	external_map 13,  2, Route9Name
	external_map 14,  4, Route10Name
	external_map 12,  9, Route11Name
	external_map 14,  8, Route12Name
	external_map 13, 11, Route13Name
	external_map 11, 12, Route14Name
	external_map 10, 13, Route15Name
	external_map  5,  5, Route16Name
	external_map  4,  8, Route17Name
	external_map  6, 13, Route18Name
	external_map  6, 15, Route19Name
	external_map  4, 15, Route20Name
	external_map  2, 13, Route21Name
	external_map  0,  8, Route22Name
	external_map  0,  6, Route23Name
	external_map 10,  1, Route24Name
	external_map 11,  0, Route25Name
	assert_table_length FIRST_INDOOR_MAP


MACRO internal_map
	db \1 + 1
	dn \4, \3
	dw \5
	db \2
ENDM

; PureRGBnote: CHANGED: some coordinates were changed for better positioning here
; the appearance of buildings and dungeons in the town map
InternalMapEntries:
	; maximum map id subject to this rule, what map ID will be used to display wild data, x, y, name
	internal_map OAKS_LAB,                       PALLET_TOWN,         2, 11, PalletTownName
	internal_map VIRIDIAN_GYM,                   VIRIDIAN_CITY,       2,  8, ViridianCityName
	internal_map DIGLETTS_CAVE_ROUTE_2,          DIGLETTS_CAVE,       3,  4, DiglettsCaveName
	internal_map VIRIDIAN_FOREST_NORTH_GATE,     ROUTE_2,             2,  4, Route2Name
	internal_map VIRIDIAN_FOREST_SOUTH_GATE,     ROUTE_2,             2,  5, Route2Name
	internal_map VIRIDIAN_FOREST,                VIRIDIAN_FOREST,     2,  4, ViridianForestName
	internal_map PEWTER_POKECENTER,              PEWTER_CITY,         2,  3, PewterCityName
	internal_map MT_MOON_B2F,                    MT_MOON_1F,          6,  2, MountMoonName
	internal_map CERULEAN_MART,                  CERULEAN_CITY,      10,  2, CeruleanCityName
	internal_map MT_MOON_POKECENTER,             ROUTE_4,             5,  2, Route4Name
	internal_map POWER_PLANT_ROOF,               POWER_PLANT,        15,  3, PowerPlantName
	internal_map DAYCARE,                        ROUTE_5,            10,  4, Route5Name
	internal_map UNDERGROUND_PATH_ROUTE_6,       ROUTE_6,            10,  6, Route6Name
	internal_map VERMILION_FITNESS_CLUB,         VERMILION_CITY,     10,  9, VermilionCityName
	internal_map UNDERGROUND_PATH_ROUTE_7,       ROUTE_7,             9,  5, Route7Name
	internal_map CELADON_BACK_ALLEY,             CELADON_CITY,        7,  5, CeladonCityName
	internal_map UNDERGROUND_PATH_ROUTE_8,       ROUTE_8,            11,  5, Route8Name
	internal_map ROCK_TUNNEL_POKECENTER,         ROUTE_10,           14,  3, Route10Name
	internal_map ROCK_TUNNEL_1F,                 ROCK_TUNNEL_1F,     14,  3, RockTunnelName
	internal_map POWER_PLANT,                    POWER_PLANT,        15,  3, PowerPlantName
	internal_map ROUTE_11_GATE_1F,               ROUTE_11,           13,  9, Route11Name
	internal_map DIGLETTS_CAVE_ROUTE_11,         DIGLETTS_CAVE,      11,  8, DiglettsCaveName
	internal_map ROUTE_11_GATE_2F,               ROUTE_11,           13,  9, Route11Name
	internal_map ROUTE_12_GATE_1F,               ROUTE_12,           14,  7, Route12Name
	internal_map BILLS_HOUSE,                    BILLS_GARDEN,       12,  0, SeaCottageName
	internal_map VERMILION_DOCK,                 VERMILION_CITY,     10,  9, VermilionCityName
	internal_map SS_ANNE_B1F_ROOMS,              SS_ANNE_1F,          9, 10, SSAnneName
	internal_map CERULEAN_ROCKET_HOUSE_B1F,      CERULEAN_CITY,      10,  2, CeruleanCityName
	internal_map VICTORY_ROAD_1F,                VICTORY_ROAD_1F,     0,  4, VictoryRoadName
	internal_map VIRIDIAN_SCHOOL_HOUSE_B1F,      VIRIDIAN_CITY,       2,  8, ViridianCityName
	internal_map BILLS_GARDEN,                   BILLS_GARDEN,       13,  0, BillsGardenName
	internal_map SECRET_LAB,                     POKEMON_MANSION_1F,  1, 15, PokemonMansionName
	internal_map CHAMP_ARENA,                    INDIGO_PLATEAU,      0,  2, PokemonLeagueName
	internal_map DIAMOND_MINE,                   INDIGO_PLATEAU,     12,  4, DiamondMineName
	internal_map CINNABAR_VOLCANO_WEST,          CINNABAR_VOLCANO,    1, 13, CinnabarVolcanoName
	internal_map HALL_OF_FAME,                   INDIGO_PLATEAU,      0,  2, PokemonLeagueName
	internal_map UNDERGROUND_PATH_NORTH_SOUTH,   INDIGO_PLATEAU,     10,  5, UndergroundPathName
	internal_map CHAMPIONS_ROOM,                 INDIGO_PLATEAU,      0,  2, PokemonLeagueName
	internal_map UNDERGROUND_PATH_WEST_EAST,     INDIGO_PLATEAU,     10,  5, UndergroundPathName
	internal_map CELADON_HOTEL,                  CELADON_CITY,        7,  5, CeladonCityName
	internal_map LAVENDER_POKECENTER,            LAVENDER_TOWN,      14,  5, LavenderTownName
	internal_map POKEMON_TOWER_7F,               POKEMON_TOWER_3F,   15,  4, PokemonTowerName
	internal_map LAVENDER_CUBONE_HOUSE,          LAVENDER_TOWN,      14,  5, LavenderTownName
	internal_map WARDENS_HOUSE,                  FUCHSIA_CITY,        8, 13, FuchsiaCityName
	internal_map SAFARI_ZONE_GATE,               SAFARI_ZONE_EAST,    8, 12, SafariZoneName
	internal_map FUCHSIA_MEETING_ROOM,           FUCHSIA_CITY,        8, 13, FuchsiaCityName
	internal_map SEAFOAM_ISLANDS_B4F,            SEAFOAM_ISLANDS_1F,  5, 15, SeafoamIslandsName
	internal_map VERMILION_OLD_ROD_HOUSE,        VERMILION_CITY,     10,  9, VermilionCityName
	internal_map FUCHSIA_GOOD_ROD_HOUSE,         FUCHSIA_CITY,        8, 13, FuchsiaCityName
	internal_map POKEMON_MANSION_1F,             POKEMON_MANSION_1F,  1, 15, PokemonMansionName
	internal_map CINNABAR_MART,                  CINNABAR_ISLAND,     2, 15, CinnabarIslandName
	internal_map TYPE_GUYS_HOUSE,                ROUTE_23,            0,  6, Route23Name
	internal_map INDIGO_PLATEAU_LOBBY,           INDIGO_PLATEAU,      0,  2, IndigoPlateauName
	internal_map MR_PSYCHICS_HOUSE,              SAFFRON_CITY,       10,  5, SaffronCityName
	internal_map ROUTE_15_GATE_2F,               ROUTE_15,            9, 13, Route15Name
	internal_map ROUTE_16_FLY_HOUSE,             ROUTE_16,            4,  5, Route16Name
	internal_map ROUTE_12_SUPER_ROD_HOUSE,       ROUTE_12,           14, 10, Route12Name
	internal_map ROUTE_18_GATE_2F,               ROUTE_18,            7, 13, Route18Name
	internal_map SEAFOAM_ISLANDS_1F,             SEAFOAM_ISLANDS_1F,  5, 15, SeafoamIslandsName
	internal_map ROUTE_22_GATE,                  ROUTE_22,            0,  7, Route22Name
	internal_map VICTORY_ROAD_2F,                VICTORY_ROAD_1F,     0,  4, VictoryRoadName
	internal_map ROUTE_12_GATE_2F,               ROUTE_12,           14,  7, Route12Name
	internal_map VERMILION_TRADE_HOUSE,          VERMILION_CITY,     10,  9, VermilionCityName
	internal_map DIGLETTS_CAVE,                  DIGLETTS_CAVE,      11,  8, DiglettsCaveName
	internal_map VICTORY_ROAD_3F,                VICTORY_ROAD_1F,     0,  4, VictoryRoadName
	internal_map ROCKET_HIDEOUT_ELEVATOR,        INDIGO_PLATEAU,      7,  5, RocketHQName
	internal_map FUCHSIA_TREE_DELETER_HOUSE,     FUCHSIA_CITY,        8, 13, FuchsiaCityName
	internal_map FOSSIL_GUYS_HOUSE,              SAFFRON_CITY,       10,  5, SaffronCityName
	internal_map SILPH_CO_8F,                    INDIGO_PLATEAU,     10,  5, SilphCoName
	internal_map POKEMON_MANSION_B1F,            POKEMON_MANSION_1F,  1, 15, PokemonMansionName
	internal_map SAFARI_ZONE_NORTH_REST_HOUSE,   SAFARI_ZONE_EAST,    8, 12, SafariZoneName
	internal_map CERULEAN_CAVE_1F,               CERULEAN_CAVE_1F,    9,  1, CeruleanCaveName
	internal_map NAME_RATERS_HOUSE,              LAVENDER_TOWN,      14,  5, LavenderTownName
	internal_map CERULEAN_BALL_DESIGNER,         CERULEAN_CITY,      10,  2, CeruleanCityName
	internal_map ROCK_TUNNEL_B1F,                ROCK_TUNNEL_1F,     14,  3, RockTunnelName
	internal_map SILPH_CO_ELEVATOR,              INDIGO_PLATEAU,     10,  5, SilphCoName
	internal_map AGATHAS_ROOM,                   INDIGO_PLATEAU,      0,  2, PokemonLeagueName
	db -1 ; end
