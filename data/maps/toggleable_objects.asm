; toggleable objects for each map

ToggleableObjectMapPointers:
; entries correspond to map ids
	table_width 2
FOR n, NUM_MAPS
	IF DEF(TOGGLEMAP{n}_NAME) ; defined by `toggle_consts_for`
		dw ToggleData_{TOGGLEMAP{n}_NAME}
	ELSE
		dw NoToggleData
	ENDC
ENDR
	assert_table_length NUM_MAPS
	dw -1 ; end

NoToggleData:
	db -1, -1, -1 ; end

DEF toggles_ok = 1

MACRO? toggleable_objects_for
	DEF toggle_map_id = \1 ; map id
	ToggleData_\1:
	IF toggles_ok
		ASSERT DEF(TOGGLEMAP{toggle_map_id}_ID), \
			"`toggleable_objects_for \1` is not defined"
		DEF toggles_ok &= DEF(TOGGLEMAP{toggle_map_id}_ID)
		IF toggles_ok
			assert_table_length TOGGLEMAP{toggle_map_id}_ID
			DEF toggles_ok &= TOGGLEMAP{toggle_map_id}_ID * 3 == @ - ToggleableObjectStates
		ENDC
	ENDC
ENDM

MACRO toggle_object_state
	db toggle_map_id ; from previous `toggleable_objects_for`
	db \1 ; object id
	db \2 ; OFF/ON
ENDM

ToggleableObjectStates:
; entries correspond to TOGGLE_* constants (see constants/toggle_constants.asm)
	table_width 3
; format: map id, object id, OFF/ON

	toggleable_objects_for PALLET_TOWN
	toggle_object_state PALLETTOWN_OAK, OFF

	toggleable_objects_for VIRIDIAN_CITY
	toggle_object_state VIRIDIANCITY_OLD_MAN_SLEEPY, ON
	toggle_object_state VIRIDIANCITY_OLD_MAN,        OFF

	toggleable_objects_for PEWTER_CITY
	toggle_object_state PEWTERCITY_SUPER_NERD1, ON
	toggle_object_state PEWTERCITY_YOUNGSTER, ON
	toggle_object_state PEWTERCITY_ITEM1, ON

	toggleable_objects_for CERULEAN_CITY
	toggle_object_state CERULEANCITY_RIVAL, OFF
	toggle_object_state CERULEANCITY_ROCKET, ON
	toggle_object_state CERULEANCITY_GUARD1, OFF
	toggle_object_state CERULEANCITY_SUPER_NERD3, ON
	toggle_object_state CERULEANCITY_GUARD2, ON
	toggle_object_state CERULEANCITY_ITEM1, ON

	toggleable_objects_for SAFFRON_CITY
	toggle_object_state SAFFRONCITY_ROCKET1,        ON
	toggle_object_state SAFFRONCITY_ROCKET2,        ON
	toggle_object_state SAFFRONCITY_ROCKET3,        ON
	toggle_object_state SAFFRONCITY_ROCKET4,        ON
	toggle_object_state SAFFRONCITY_ROCKET5,        ON
	toggle_object_state SAFFRONCITY_ROCKET6,        ON
	toggle_object_state SAFFRONCITY_ROCKET7,        ON
	toggle_object_state SAFFRONCITY_SCIENTIST,      OFF
	toggle_object_state SAFFRONCITY_SILPH_WORKER_M, OFF
	toggle_object_state SAFFRONCITY_SILPH_WORKER_F, OFF
	toggle_object_state SAFFRONCITY_GENTLEMAN,      OFF
	toggle_object_state SAFFRONCITY_PIDGEOT,        OFF
	toggle_object_state SAFFRONCITY_ROCKER,         OFF
	toggle_object_state SAFFRONCITY_ROCKET8,        ON
	toggle_object_state SAFFRONCITY_ROCKET9,        OFF

	toggleable_objects_for ROUTE_2
	toggle_object_state ROUTE2_ITEM1, ON
	toggle_object_state ROUTE2_ITEM2, ON
	toggle_object_state ROUTE2_ITEM3, ON

	toggleable_objects_for ROUTE_4
	toggle_object_state ROUTE4_ITEM1, ON
	toggle_object_state ROUTE4_ITEM2, ON

	toggleable_objects_for ROUTE_5
	toggle_object_state ROUTE5_ITEM1, ON

	toggleable_objects_for ROUTE_6
	toggle_object_state ROUTE6_ITEM1, ON

	toggleable_objects_for ROUTE_8
	toggle_object_state ROUTE8_ITEM1, ON

	toggleable_objects_for ROUTE_9
	toggle_object_state ROUTE9_ITEM1, ON

	toggleable_objects_for ROUTE_10
	toggle_object_state ROUTE10_ITEM1, ON


	toggleable_objects_for ROUTE_11
	toggle_object_state ROUTE11_ITEM1, ON

	toggleable_objects_for ROUTE_12
	toggle_object_state ROUTE12_SNORLAX, ON
	toggle_object_state ROUTE12_ITEM1, ON
	toggle_object_state ROUTE12_ITEM2, ON
	toggle_object_state ROUTE12_ITEM3, ON

	toggleable_objects_for ROUTE_15
	toggle_object_state ROUTE15_ITEM1, ON

	toggleable_objects_for ROUTE_16
	toggle_object_state ROUTE16_SNORLAX, ON

	toggleable_objects_for ROUTE_21
	toggle_object_state ROUTE21_ITEM1, ON

	toggleable_objects_for ROUTE_22
	toggle_object_state ROUTE22_RIVAL1, OFF
	toggle_object_state ROUTE22_RIVAL2, OFF
	toggle_object_state ROUTE22_ITEM1, ON
	toggle_object_state ROUTE22_ITEM2, ON

	toggleable_objects_for ROUTE_23
	toggle_object_state ROUTE23_ITEM1, ON
	toggle_object_state ROUTE23_ITEM2, ON

	toggleable_objects_for ROUTE_24
	toggle_object_state ROUTE24_COOLTRAINER_M1, ON
	toggle_object_state ROUTE24_ITEM1, ON
	toggle_object_state ROUTE24_ITEM2, ON

	toggleable_objects_for ROUTE_25
	toggle_object_state ROUTE25_ITEM1, ON

	toggleable_objects_for BLUES_HOUSE
	toggle_object_state BLUESHOUSE_DAISY_SITTING,   ON
	toggle_object_state BLUESHOUSE_DAISY_WALKING,   OFF
	toggle_object_state BLUESHOUSE_TOWN_MAP,        ON

	toggleable_objects_for OAKS_LAB
	toggle_object_state OAKSLAB_RIVAL,                ON
	toggle_object_state OAKSLAB_CHARMANDER_POKE_BALL, ON
	toggle_object_state OAKSLAB_SQUIRTLE_POKE_BALL,   ON
	toggle_object_state OAKSLAB_BULBASAUR_POKE_BALL,  ON
	toggle_object_state OAKSLAB_OAK1,                 OFF
	toggle_object_state OAKSLAB_POKEDEX1,             ON
	toggle_object_state OAKSLAB_POKEDEX2,             ON
	toggle_object_state OAKSLAB_OAK2,                 OFF

	toggleable_objects_for VIRIDIAN_GYM
	toggle_object_state VIRIDIANGYM_GIOVANNI, ON
	toggle_object_state VIRIDIANGYM_ITEM1,    ON

	toggleable_objects_for MUSEUM_1F
	toggle_object_state MUSEUM1F_OLD_AMBER, ON

	toggleable_objects_for CERULEAN_CAVE_1F
	toggle_object_state CERULEANCAVE1F_ITEM1, ON
	toggle_object_state CERULEANCAVE1F_ITEM2, ON
	toggle_object_state CERULEANCAVE1F_ITEM3, ON

	toggleable_objects_for POKEMON_TOWER_2F
	toggle_object_state POKEMONTOWER2F_RIVAL, ON

	toggleable_objects_for POKEMON_TOWER_3F
	toggle_object_state POKEMONTOWER3F_ITEM1, ON

	toggleable_objects_for POKEMON_TOWER_4F
	toggle_object_state POKEMONTOWER4F_ITEM1, ON
	toggle_object_state POKEMONTOWER4F_ITEM2, ON
	toggle_object_state POKEMONTOWER4F_ITEM3, ON

	toggleable_objects_for POKEMON_TOWER_5F
	toggle_object_state POKEMONTOWER5F_ITEM1, ON

	toggleable_objects_for POKEMON_TOWER_6F
	toggle_object_state POKEMONTOWER6F_ITEM1, ON
	toggle_object_state POKEMONTOWER6F_ITEM2, ON

	toggleable_objects_for POKEMON_TOWER_7F
	toggle_object_state POKEMONTOWER7F_ROCKET1, ON
	toggle_object_state POKEMONTOWER7F_ROCKET2, ON
	toggle_object_state POKEMONTOWER7F_ROCKET3, ON
	toggle_object_state POKEMONTOWER7F_MR_FUJI, ON

	toggleable_objects_for MR_FUJIS_HOUSE
	toggle_object_state MRFUJISHOUSE_MR_FUJI, OFF

	toggleable_objects_for CELADON_MANSION_ROOF
	toggle_object_state CELADONMANSIONROOF_ITEM1, ON

	toggleable_objects_for CELADON_MANSION_ROOF_HOUSE
	toggle_object_state CELADONMANSION_ROOF_HOUSE_EEVEE_POKEBALL, ON

	toggleable_objects_for GAME_CORNER
	toggle_object_state GAMECORNER_ROCKET, ON

	toggleable_objects_for WARDENS_HOUSE
	toggle_object_state WARDENSHOUSE_ITEM1, ON

	toggleable_objects_for POKEMON_MANSION_1F
	toggle_object_state POKEMONMANSION1F_ITEM1, ON
	toggle_object_state POKEMONMANSION1F_ITEM2, ON

	toggleable_objects_for FIGHTING_DOJO
	toggle_object_state FIGHTINGDOJO_HITMONLEE_POKE_BALL,  ON
	toggle_object_state FIGHTINGDOJO_HITMONCHAN_POKE_BALL, ON

	toggleable_objects_for SILPH_CO_1F
	toggle_object_state SILPHCO1F_FIREFIGHTER1, OFF
	toggle_object_state SILPHCO1F_SOLDIER1, OFF
	toggle_object_state SILPHCO1F_SOLDIER2, OFF
	toggle_object_state SILPHCO1F_FIREFIGHTER2, OFF
	toggle_object_state SILPHCO1F_LINK_RECEPTIONIST, OFF

	toggleable_objects_for ROCK_TUNNEL_1F
	toggle_object_state ROCKTUNNEL1F_ITEM1, ON

	toggleable_objects_for ROCK_TUNNEL_B1F
	toggle_object_state ROCKTUNNELB1F_ITEM1, ON
	toggle_object_state ROCKTUNNELB1F_ITEM2, ON

	toggleable_objects_for POWER_PLANT
	toggle_object_state POWERPLANT_VOLTORB1,   ON
	toggle_object_state POWERPLANT_VOLTORB2,   ON
	toggle_object_state POWERPLANT_VOLTORB3,   ON
	toggle_object_state POWERPLANT_ELECTRODE1, ON
	toggle_object_state POWERPLANT_VOLTORB4,   ON
	toggle_object_state POWERPLANT_VOLTORB5,   ON
	toggle_object_state POWERPLANT_ELECTRODE2, ON
	toggle_object_state POWERPLANT_VOLTORB6,   ON
	toggle_object_state POWERPLANT_ZAPDOS,     ON
	toggle_object_state POWERPLANT_ITEM1,      ON
	toggle_object_state POWERPLANT_ITEM2,      ON
	toggle_object_state POWERPLANT_ITEM3,      ON
	toggle_object_state POWERPLANT_ITEM4,      ON
	toggle_object_state POWERPLANT_ITEM5,      ON

	toggleable_objects_for VICTORY_ROAD_2F
	toggle_object_state VICTORYROAD2F_MOLTRES,  ON
	toggle_object_state VICTORYROAD2F_ITEM1,    ON
	toggle_object_state VICTORYROAD2F_ITEM2,    ON
	toggle_object_state VICTORYROAD2F_ITEM3,    ON
	toggle_object_state VICTORYROAD2F_ITEM4,    ON
	toggle_object_state VICTORYROAD2F_BOULDER3, ON

	toggleable_objects_for BILLS_HOUSE
	toggle_object_state BILLSHOUSE_BILL_POKEMON,                   ON
	toggle_object_state BILLSHOUSE_BILL_SS_TICKET,                 OFF
	toggle_object_state BILLSHOUSE_BILL_CHECK_OUT_MY_RARE_POKEMON, OFF

	toggleable_objects_for VIRIDIAN_FOREST
	toggle_object_state VIRIDIANFOREST_ITEM1, ON
	toggle_object_state VIRIDIANFOREST_ITEM2, ON
	toggle_object_state VIRIDIANFOREST_ITEM3, ON

	toggleable_objects_for MT_MOON_1F
	toggle_object_state MTMOON1F_ITEM1, ON
	toggle_object_state MTMOON1F_ITEM2, ON
	toggle_object_state MTMOON1F_ITEM3, ON
	toggle_object_state MTMOON1F_ITEM4, ON
	toggle_object_state MTMOON1F_ITEM5, ON
	toggle_object_state MTMOON1F_ITEM6, ON

	toggleable_objects_for MT_MOON_B2F
	toggle_object_state MTMOONB2F_DOME_FOSSIL,   ON
	toggle_object_state MTMOONB2F_HELIX_FOSSIL,  ON
	toggle_object_state MTMOONB2F_ITEM1,         ON
	toggle_object_state MTMOONB2F_ITEM2,         ON

	toggleable_objects_for SS_ANNE_2F
	toggle_object_state SSANNE2F_RIVAL, OFF

	toggleable_objects_for SS_ANNE_1F_ROOMS
	toggle_object_state SSANNE1FROOMS_ITEM1, ON

	toggleable_objects_for SS_ANNE_2F_ROOMS
	toggle_object_state SSANNE2FROOMS_ITEM1,  ON
	toggle_object_state SSANNE2FROOMS_ITEM2,  ON

	toggleable_objects_for SS_ANNE_B1F_ROOMS
	toggle_object_state SSANNEB1FROOMS_ITEM1, ON
	toggle_object_state SSANNEB1FROOMS_ITEM2, ON
	toggle_object_state SSANNEB1FROOMS_ITEM3, ON

	toggleable_objects_for VICTORY_ROAD_3F
	toggle_object_state VICTORYROAD3F_ITEM1,    ON
	toggle_object_state VICTORYROAD3F_ITEM2,    ON
	toggle_object_state VICTORYROAD3F_BOULDER4, ON

	toggleable_objects_for ROCKET_HIDEOUT_B1F
	toggle_object_state ROCKETHIDEOUTB1F_ITEM1, ON
	toggle_object_state ROCKETHIDEOUTB1F_ITEM2, ON

	toggleable_objects_for ROCKET_HIDEOUT_B2F
	toggle_object_state ROCKETHIDEOUTB2F_ITEM1, ON
	toggle_object_state ROCKETHIDEOUTB2F_ITEM2, ON
	toggle_object_state ROCKETHIDEOUTB2F_ITEM3, ON
	toggle_object_state ROCKETHIDEOUTB2F_ITEM4, ON

	toggleable_objects_for ROCKET_HIDEOUT_B3F
	toggle_object_state ROCKETHIDEOUTB3F_ITEM1, ON
	toggle_object_state ROCKETHIDEOUTB3F_ITEM2, ON

	toggleable_objects_for ROCKET_HIDEOUT_B4F
	toggle_object_state ROCKETHIDEOUTB4F_GIOVANNI,    ON
	toggle_object_state ROCKETHIDEOUTB4F_ITEM1,       ON
	toggle_object_state ROCKETHIDEOUTB4F_ITEM2,       ON
	toggle_object_state ROCKETHIDEOUTB4F_ITEM3,       ON
	toggle_object_state ROCKETHIDEOUTB4F_SILPH_SCOPE, OFF
	toggle_object_state ROCKETHIDEOUTB4F_LIFT_KEY,    OFF

	toggleable_objects_for SILPH_CO_2F
	toggle_object_state SILPHCO2F_SILPH_WORKER_F, ON
	toggle_object_state SILPHCO2F_SCIENTIST1,     ON
	toggle_object_state SILPHCO2F_SCIENTIST2,     ON
	toggle_object_state SILPHCO2F_ROCKET1,        ON
	toggle_object_state SILPHCO2F_ROCKET2,        ON

	toggleable_objects_for SILPH_CO_3F
	toggle_object_state SILPHCO3F_ROCKET,       ON
	toggle_object_state SILPHCO3F_SCIENTIST,    ON
	toggle_object_state SILPHCO3F_ITEM1,        ON

	toggleable_objects_for SILPH_CO_4F
	toggle_object_state SILPHCO4F_ROCKET1,     ON
	toggle_object_state SILPHCO4F_SCIENTIST,   ON
	toggle_object_state SILPHCO4F_ROCKET2,     ON
	toggle_object_state SILPHCO4F_ITEM1,       ON
	toggle_object_state SILPHCO4F_ITEM2,       ON
	toggle_object_state SILPHCO4F_ITEM3,       ON

	toggleable_objects_for SILPH_CO_5F
	toggle_object_state SILPHCO5F_ROCKET1,      ON
	toggle_object_state SILPHCO5F_SCIENTIST,    ON
	toggle_object_state SILPHCO5F_ROCKER,       ON
	toggle_object_state SILPHCO5F_ROCKET2,      ON
	toggle_object_state SILPHCO5F_ITEM1,        ON
	toggle_object_state SILPHCO5F_ITEM2,        ON
	toggle_object_state SILPHCO5F_ITEM3,        ON

	toggleable_objects_for SILPH_CO_6F
	toggle_object_state SILPHCO6F_ROCKET1,    ON
	toggle_object_state SILPHCO6F_SCIENTIST,  ON
	toggle_object_state SILPHCO6F_ROCKET2,    ON
	toggle_object_state SILPHCO6F_ITEM1,      ON
	toggle_object_state SILPHCO6F_ITEM2,      ON

	toggleable_objects_for SILPH_CO_7F
	toggle_object_state SILPHCO7F_ROCKET1, ON
	toggle_object_state SILPHCO7F_SCIENTIST, ON
	toggle_object_state SILPHCO7F_ROCKET2, ON
	toggle_object_state SILPHCO7F_ROCKET3, ON
	toggle_object_state SILPHCO7F_RIVAL, ON
	toggle_object_state SILPHCO7F_ITEM1, ON
	toggle_object_state SILPHCO7F_ITEM2, ON

	toggleable_objects_for SILPH_CO_8F
	toggle_object_state SILPHCO8F_ROCKET1,   ON
	toggle_object_state SILPHCO8F_SCIENTIST, ON
	toggle_object_state SILPHCO8F_ROCKET2,   ON

	toggleable_objects_for SILPH_CO_9F
	toggle_object_state SILPHCO9F_ROCKET1,   ON
	toggle_object_state SILPHCO9F_SCIENTIST, ON
	toggle_object_state SILPHCO9F_ROCKET2,   ON

	toggleable_objects_for SILPH_CO_10F
	toggle_object_state SILPHCO10F_ROCKET,         ON
	toggle_object_state SILPHCO10F_SCIENTIST,      ON
	toggle_object_state SILPHCO10F_SILPH_WORKER_F, ON
	toggle_object_state SILPHCO10F_ITEM1,          ON
	toggle_object_state SILPHCO10F_ITEM2,          ON
	toggle_object_state SILPHCO10F_ITEM3,          ON

	toggleable_objects_for SILPH_CO_11F
	toggle_object_state SILPHCO11F_GIOVANNI, ON
	toggle_object_state SILPHCO11F_ROCKET1, ON
	toggle_object_state SILPHCO11F_ROCKET2, ON

	toggleable_objects_for POKEMON_MANSION_2F
	toggle_object_state POKEMONMANSION2F_ITEM1, ON

	toggleable_objects_for POKEMON_MANSION_3F
	toggle_object_state POKEMONMANSION3F_ITEM1, ON
	toggle_object_state POKEMONMANSION3F_ITEM2, ON

	toggleable_objects_for POKEMON_MANSION_B1F
	toggle_object_state POKEMONMANSIONB1F_ITEM1, ON
	toggle_object_state POKEMONMANSIONB1F_ITEM2, ON
	toggle_object_state POKEMONMANSIONB1F_ITEM3, ON
	toggle_object_state POKEMONMANSIONB1F_ITEM4, ON
	toggle_object_state POKEMONMANSIONB1F_SECRET_KEY, ON

	toggleable_objects_for CERULEAN_CAVE_2F
	toggle_object_state CERULEANCAVE2F_ITEM1, ON
	toggle_object_state CERULEANCAVE2F_ITEM2, ON
	toggle_object_state CERULEANCAVE2F_ITEM3, ON

	toggleable_objects_for CERULEAN_CAVE_B1F
	toggle_object_state CERULEANCAVEB1F_MEWTWO, ON
	toggle_object_state CERULEANCAVEB1F_ITEM1,  ON
	toggle_object_state CERULEANCAVEB1F_ITEM2,  ON

	toggleable_objects_for VICTORY_ROAD_1F
	toggle_object_state VICTORYROAD1F_ITEM1, ON
	toggle_object_state VICTORYROAD1F_ITEM2, ON

	toggleable_objects_for CHAMPIONS_ROOM
	toggle_object_state CHAMPIONSROOM_OAK, OFF

	toggleable_objects_for SEAFOAM_ISLANDS_1F
	toggle_object_state SEAFOAMISLANDS1F_BOULDER1, ON
	toggle_object_state SEAFOAMISLANDS1F_BOULDER2, ON

	toggleable_objects_for SEAFOAM_ISLANDS_B1F
	toggle_object_state SEAFOAMISLANDSB1F_BOULDER1, OFF
	toggle_object_state SEAFOAMISLANDSB1F_BOULDER2, OFF

	toggleable_objects_for SEAFOAM_ISLANDS_B2F
	toggle_object_state SEAFOAMISLANDSB2F_BOULDER1, OFF
	toggle_object_state SEAFOAMISLANDSB2F_BOULDER2, OFF

	toggleable_objects_for SEAFOAM_ISLANDS_B3F
	toggle_object_state SEAFOAMISLANDSB3F_BOULDER2, ON
	toggle_object_state SEAFOAMISLANDSB3F_BOULDER3, ON
	toggle_object_state SEAFOAMISLANDSB3F_BOULDER5, OFF
	toggle_object_state SEAFOAMISLANDSB3F_BOULDER6, OFF
	toggle_object_state SEAFOAMISLANDSB3F_DOME_FOSSIL, ON ; FOSSIL
	toggle_object_state SEAFOAMISLANDSB3F_HELIX_FOSSIL, ON ; FOSSIL

	toggleable_objects_for SEAFOAM_ISLANDS_B4F
	toggle_object_state SEAFOAMISLANDSB4F_BOULDER1, OFF
	toggle_object_state SEAFOAMISLANDSB4F_BOULDER2, OFF
	toggle_object_state SEAFOAMISLANDSB4F_ARTICUNO, ON
	toggle_object_state SEAFOAMISLANDSB4F_ITEM1, ON

	toggleable_objects_for VERMILION_DOCK
	toggle_object_state VERMILIONDOCK_MEW, OFF

	toggleable_objects_for CERULEAN_ROCKET_HOUSE_1F
	toggle_object_state CERULEANROCKETHOUSE1F_ROCKET, ON

	toggleable_objects_for CELADON_HOTEL
	toggle_object_state CELADONHOTEL_LAPRAS_GUY, ON

	assert_table_length NUM_TOGGLEABLE_OBJECTS

	db -1, 1, ON ; end

ExtraToggleableObjectStates:
; entries correspond to TOGGLE_* constants (see constants/OFF_ON_constants)
	table_width 3, ExtraToggleableObjectStates
; format: map id, object id, OFF/ON

	toggleable_objects_for SAFARI_ZONE_EAST
	toggle_object_state SAFARIZONEEAST_RANGER_F,      ON ; ranger
	toggle_object_state SAFARIZONEEAST_PSYCHIC,       ON ; trainer
	toggle_object_state SAFARIZONEEAST_ROCKER,        ON ; trainer
	toggle_object_state SAFARIZONEEAST_COOLTRAINER_M, ON ; trainer
	toggle_object_state SAFARIZONEEAST_ENGINEER,      ON ; trainer
	toggle_object_state SAFARIZONEEAST_ITEM1,         ON 
	toggle_object_state SAFARIZONEEAST_ITEM2,         ON 
	toggle_object_state SAFARIZONEEAST_ITEM3,         ON
	toggle_object_state SAFARIZONEEAST_ITEM4,         ON

	toggleable_objects_for SAFARI_ZONE_NORTH
	toggle_object_state SAFARIZONENORTH_RANGER_F, ON ; ranger
	toggle_object_state SAFARIZONENORTH_JUGGLER, ON ; trainer
	toggle_object_state SAFARIZONENORTH_COOLTRAINER_M, ON ; trainer
	toggle_object_state SAFARIZONENORTH_SUPER_NERD, ON ; trainer
	toggle_object_state SAFARIZONENORTH_ENGINEER, ON ; trainer
	toggle_object_state SAFARIZONENORTH_POKEMANIAC, ON ; trainer
	toggle_object_state SAFARIZONENORTH_ITEM1, ON
	toggle_object_state SAFARIZONENORTH_ITEM2, ON

	toggleable_objects_for SAFARI_ZONE_WEST
	toggle_object_state SAFARIZONEWEST_RANGER1, ON ; ranger
	toggle_object_state SAFARIZONEWEST_RANGER2, ON ; ranger
	toggle_object_state SAFARIZONEWEST_BURGLAR, ON ; trainer
	toggle_object_state SAFARIZONEWEST_POKEMANIAC, ON ; trainer
	toggle_object_state SAFARIZONEWEST_ROCKER, ON ; trainer
	toggle_object_state SAFARIZONEWEST_JUGGLER, ON ; trainer
	toggle_object_state SAFARIZONEWEST_PSYCHIC, ON ; trainer
	toggle_object_state SAFARIZONEWEST_ITEM1, ON
	toggle_object_state SAFARIZONEWEST_ITEM2, ON
	toggle_object_state SAFARIZONEWEST_ITEM3, ON
	toggle_object_state SAFARIZONEWEST_ITEM4, ON

	toggleable_objects_for SAFARI_ZONE_CENTER
	toggle_object_state SAFARIZONECENTER_RANGER,     ON ; ranger
	toggle_object_state SAFARIZONECENTER_ROCKER,     ON ; trainer
	toggle_object_state SAFARIZONECENTER_ENGINEER,   ON ; trainer
	toggle_object_state SAFARIZONECENTER_JUGGLER,    ON ; trainer
	toggle_object_state SAFARIZONECENTER_POKEMANIAC, ON ; trainer
	toggle_object_state SAFARIZONECENTER_ITEM1,      ON

	toggleable_objects_for VIRIDIAN_SCHOOL_HOUSE
	toggle_object_state VIRIDIANSCHOOLHOUSE_BRUNETTE_GIRL, ON ; brunette girl
	toggle_object_state VIRIDIANSCHOOLHOUSE_ROCKER, OFF ; rocker

	toggleable_objects_for VIRIDIAN_SCHOOL_HOUSE_B1F
	toggle_object_state SCHOOLB1F_ROCKER, ON ; rocker
	toggle_object_state SCHOOLB1F_BRUNETTE_GIRL, OFF ; brunette girl

	toggleable_objects_for REDS_HOUSE_1F
	toggle_object_state REDSHOUSE1F_DAD, OFF ; dad

	toggleable_objects_for CERULEAN_ROCKET_HOUSE_B1F
	toggle_object_state CERULEANROCKETHOUSEB1F_ITEM1, ON ; top secret key item

	toggleable_objects_for SECRET_LAB
	toggle_object_state SECRETLAB_SOLDIER1, ON ; soldier 1 in secret lab
	toggle_object_state SECRETLAB_SOLDIER2, ON ; soldier 2 in secret lab
	toggle_object_state SECRETLAB_CHIEF,    ON ; chief in secret lab

	toggleable_objects_for POKEMON_TOWER_1F
	toggle_object_state POKEMONTOWER1F_ROCKET, ON ; new rocket in pokemon tower 1F blocking downstairs

	toggleable_objects_for CHAMP_ARENA
	toggle_object_state CHAMP_ARENA_CHALLENGER,      OFF ; challenger
	toggle_object_state CHAMP_ARENA_PROXY_PLAYER,    OFF ; proxy player's sprite
	toggle_object_state CHAMP_ARENA_TM_KID,          OFF ; tm kid
	toggle_object_state CHAMP_ARENA_CROWD1,          OFF ; crowd 1
	toggle_object_state CHAMP_ARENA_CROWD2,          OFF ; crowd 2
	toggle_object_state CHAMP_ARENA_VARIABLE_CROWD1, OFF ; crowd 3
	toggle_object_state CHAMP_ARENA_VARIABLE_CROWD2, OFF ; crowd 4
	toggle_object_state CHAMP_ARENA_CROWD3,          OFF ; crowd 5
	toggle_object_state CHAMP_ARENA_VARIABLE_CROWD3, OFF ; crowd 6
	toggle_object_state CHAMP_ARENA_CROWD4,          OFF ; crowd 7

	toggleable_objects_for INDIGO_PLATEAU_LOBBY
	toggle_object_state INDIGOPLATEAULOBBY_ARENA_ASSISTANT, ON ; arena assistant

	toggleable_objects_for CELADON_MANSION_2F
	toggle_object_state CELADON_PROSPECTORS_HOUSE_PROSPECTOR, OFF

	toggleable_objects_for CINNABAR_VOLCANO
	toggle_object_state CINNABAR_VOLCANO_BLAINE, ON
	toggle_object_state CINNABAR_VOLCANO_ARCANINE, ON
	toggle_object_state CINNABAR_VOLCANO_MOLTRES, ON
	toggle_object_state CINNABAR_VOLCANO_RUBY1, OFF
	toggle_object_state CINNABAR_VOLCANO_RUBY2, OFF
	toggle_object_state CINNABAR_VOLCANO_RUBY3, OFF
	toggle_object_state CINNABAR_VOLCANO_ANIMATION_PROXY, OFF
	toggle_object_state CINNABAR_VOLCANO_ITEM1, ON
	toggle_object_state CINNABAR_VOLCANO_ITEM2, ON
	toggle_object_state CINNABAR_VOLCANO_SURFING_RHYDON, ON
	toggle_object_state CINNABAR_VOLCANO_BOSS_MAGMAR, ON

	toggleable_objects_for POWER_PLANT_ROOF
	toggle_object_state POWER_PLANT_ROOF_ZAPDOS, ON

	toggleable_objects_for DIGLETTS_CAVE
	toggle_object_state DIGLETTS_CAVE_DIGLETT1, OFF
	toggle_object_state DIGLETTS_CAVE_DIGLETT2, OFF
	toggle_object_state DIGLETTS_CAVE_DIGLETT3, OFF
	toggle_object_state DIGLETTS_CAVE_DIGLETT4, OFF

	toggleable_objects_for LAVENDER_CUBONE_HOUSE
	toggle_object_state LAVENDERCUBONEHOUSE_CUBONE, ON

	toggleable_objects_for FUCHSIA_CITY
	toggle_object_state FUCHSIACITY_ERIK, ON

	toggleable_objects_for SAFARI_ZONE_CENTER_REST_HOUSE
	toggle_object_state SAFARIZONECENTERRESTHOUSE_SARA, ON
	toggle_object_state SAFARIZONECENTERRESTHOUSE_ERIK, OFF

	toggleable_objects_for FUCHSIA_GOOD_ROD_HOUSE
	toggle_object_state FUCHSIAGOODRODHOUSE_SARA, OFF
	toggle_object_state FUCHSIAGOODRODHOUSE_ERIK, OFF
	toggle_object_state FUCHSIAGOODRODHOUSE_NOTE2, OFF

	toggleable_objects_for CERULEAN_BALL_DESIGNER
	toggle_object_state CERULEANBALLDESIGNER_CLIPBOARD, OFF
	toggle_object_state CERULEANBALLDESIGNER_CAMERA, ON
	toggle_object_state CERULEANBALLDESIGNER_CLIPBOARD2, OFF

	toggleable_objects_for VERMILION_FITNESS_CLUB
	toggle_object_state VERMILIONFITNESSCLUB_CLERK, OFF
	toggle_object_state VERMILIONFITNESSCLUB_MUSCLE1, OFF
	toggle_object_state VERMILIONFITNESSCLUB_JANITOR, ON

	assert_table_length NUM_EXTRA_TOGGLEABLE_OBJECTS
	
	db -1, 1, ON ; end
