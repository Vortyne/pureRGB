DEF OFF EQU $11
DEF ON  EQU $15

MACRO toggle_consts_for
	DEF TOGGLEMAP{\1}_ID EQU const_value
	DEF TOGGLEMAP{\1}_NAME EQUS "\1"
ENDM

; ToggleableObjectStates indexes (see data/maps/toggleable_objects.asm)
; This lists the object_events that can be toggled by ShowObject/HideObject.
; The constants marked with an X are never used, because those object_events
; are not toggled on/off in any map's script.
; (The X-ed ones are either items or static Pokemon encounters that deactivate
; after battle and are detected in wToggleableObjectList.)

	const_def

	toggle_consts_for PALLET_TOWN
	const TOGGLE_PALLET_TOWN_OAK               ; 00

	toggle_consts_for VIRIDIAN_CITY
	const TOGGLE_LYING_OLD_MAN                 ; 01
	const TOGGLE_OLD_MAN                       ; 02

	toggle_consts_for PEWTER_CITY
	const TOGGLE_MUSEUM_GUY                    ; 03
	const TOGGLE_GYM_GUY                       ; 04
	const TOGGLE_PEWTER_CITY_ITEM                  ; NEW X

	toggle_consts_for CERULEAN_CITY
	const TOGGLE_CERULEAN_RIVAL                ; 05
	const TOGGLE_CERULEAN_ROCKET               ; 06
	const TOGGLE_CERULEAN_GUARD_1              ; 07
	const TOGGLE_CERULEAN_CAVE_GUY             ; 08
	const TOGGLE_CERULEAN_GUARD_2              ; 09
	const TOGGLE_CERULEAN_ITEM                     ; NEW X

	toggle_consts_for SAFFRON_CITY
	const TOGGLE_SAFFRON_CITY_1                ; 0A
	const TOGGLE_SAFFRON_CITY_2                ; 0B
	const TOGGLE_SAFFRON_CITY_3                ; 0C
	const TOGGLE_SAFFRON_CITY_4                ; 0D
	const TOGGLE_SAFFRON_CITY_5                ; 0E
	const TOGGLE_SAFFRON_CITY_6                ; 0F
	const TOGGLE_SAFFRON_CITY_7                ; 10
	const TOGGLE_SAFFRON_CITY_8                ; 11
	const TOGGLE_SAFFRON_CITY_9                ; 12
	const TOGGLE_SAFFRON_CITY_A                ; 13
	const TOGGLE_SAFFRON_CITY_B                ; 14
	const TOGGLE_SAFFRON_CITY_C                ; 15
	const TOGGLE_SAFFRON_CITY_D                ; 16
	const TOGGLE_SAFFRON_CITY_E                ; 17
	const TOGGLE_SAFFRON_CITY_F                ; 18

	toggle_consts_for ROUTE_2
	const TOGGLE_ROUTE_2_ITEM_1                ; 19 X
	const TOGGLE_ROUTE_2_ITEM_2                ; 1A X
	const TOGGLE_ROUTE_2_ITEM_3                ; NEW X

	toggle_consts_for ROUTE_4
	const TOGGLE_ROUTE_4_ITEM_1                ; 1B X
	const TOGGLE_ROUTE_4_ITEM_2                ; NEW X

	toggle_consts_for ROUTE_5
	const TOGGLE_ROUTE_5_ITEM                  ; NEW X
	
	toggle_consts_for ROUTE_6
	const TOGGLE_ROUTE_6_ITEM                  ; NEW X
	
	toggle_consts_for ROUTE_8
	const TOGGLE_ROUTE_8_ITEM                  ; NEW X

	toggle_consts_for ROUTE_9
	const TOGGLE_ROUTE_9_ITEM                  ; 1C X

	toggle_consts_for ROUTE_10
	const TOGGLE_ROUTE_10_ITEM                 ; NEW X

	toggle_consts_for ROUTE_11
	const TOGGLE_ROUTE_11_ITEM                 ; NEW X

	toggle_consts_for ROUTE_12
	const TOGGLE_ROUTE_12_SNORLAX              ; 1D
	const TOGGLE_ROUTE_12_ITEM_1               ; 1E X
	const TOGGLE_ROUTE_12_ITEM_2               ; 1F X
	const TOGGLE_ROUTE_12_ITEM_3               ; NEW X

	toggle_consts_for ROUTE_15
	const TOGGLE_ROUTE_15_ITEM                 ; 20 X

	toggle_consts_for ROUTE_16
	const TOGGLE_ROUTE_16_SNORLAX              ; 21

	toggle_consts_for ROUTE_21
	const TOGGLE_ROUTE_21_ITEM                 ; NEW X

	toggle_consts_for ROUTE_22
	const TOGGLE_ROUTE_22_RIVAL_1              ; 22
	const TOGGLE_ROUTE_22_RIVAL_2              ; 23
	const TOGGLE_ROUTE_22_ITEM_1               ; NEW X
	const TOGGLE_ROUTE_22_ITEM_2               ; NEW X

	toggle_consts_for ROUTE_23
	const TOGGLE_ROUTE_23_ITEM_1               ; NEW X
	const TOGGLE_ROUTE_23_ITEM_2               ; NEW X

	toggle_consts_for ROUTE_24
	const TOGGLE_NUGGET_BRIDGE_GUY             ; 24
	const TOGGLE_ROUTE_24_ITEM_1               ; 25 X
	const TOGGLE_ROUTE_24_ITEM_2               ; NEW X

	toggle_consts_for ROUTE_25
	const TOGGLE_ROUTE_25_ITEM                 ; 26 X

	toggle_consts_for BLUES_HOUSE
	const TOGGLE_DAISY_SITTING                 ; 27
	const TOGGLE_DAISY_WALKING                 ; 28
	const TOGGLE_TOWN_MAP                      ; 29

	toggle_consts_for OAKS_LAB
	const TOGGLE_OAKS_LAB_RIVAL                ; 2A
	const TOGGLE_STARTER_BALL_1                ; 2B
	const TOGGLE_STARTER_BALL_2                ; 2C
	const TOGGLE_STARTER_BALL_3                ; 2D
	const TOGGLE_OAKS_LAB_OAK_1                ; 2E
	const TOGGLE_POKEDEX_1                     ; 2F
	const TOGGLE_POKEDEX_2                     ; 30
	const TOGGLE_OAKS_LAB_OAK_2                ; 31

	toggle_consts_for VIRIDIAN_GYM
	const TOGGLE_VIRIDIAN_GYM_GIOVANNI         ; 32
	const TOGGLE_VIRIDIAN_GYM_ITEM             ; 33 X

	toggle_consts_for MUSEUM_1F
	const TOGGLE_OLD_AMBER                     ; 34

	toggle_consts_for CERULEAN_CAVE_1F
	const TOGGLE_CERULEAN_CAVE_1F_ITEM_1       ; 35 X
	const TOGGLE_CERULEAN_CAVE_1F_ITEM_2       ; 36 X
	const TOGGLE_CERULEAN_CAVE_1F_ITEM_3       ; 37 X

	toggle_consts_for POKEMON_TOWER_2F
	const TOGGLE_POKEMON_TOWER_2F_RIVAL        ; 38

	toggle_consts_for POKEMON_TOWER_3F
	const TOGGLE_POKEMON_TOWER_3F_ITEM         ; 39 X

	toggle_consts_for POKEMON_TOWER_4F
	const TOGGLE_POKEMON_TOWER_4F_ITEM_1       ; 3A X
	const TOGGLE_POKEMON_TOWER_4F_ITEM_2       ; 3B X
	const TOGGLE_POKEMON_TOWER_4F_ITEM_3       ; 3C X

	toggle_consts_for POKEMON_TOWER_5F
	const TOGGLE_POKEMON_TOWER_5F_ITEM         ; 3D X

	toggle_consts_for POKEMON_TOWER_6F
	const TOGGLE_POKEMON_TOWER_6F_ITEM_1       ; 3E X
	const TOGGLE_POKEMON_TOWER_6F_ITEM_2       ; 3F X

	toggle_consts_for POKEMON_TOWER_7F
	const TOGGLE_POKEMON_TOWER_7F_ROCKET_1     ; 40 X
	const TOGGLE_POKEMON_TOWER_7F_ROCKET_2     ; 41 X
	const TOGGLE_POKEMON_TOWER_7F_ROCKET_3     ; 42 X
	const TOGGLE_POKEMON_TOWER_7F_MR_FUJI      ; 43

	toggle_consts_for MR_FUJIS_HOUSE
	const TOGGLE_MR_FUJIS_HOUSE_MR_FUJI        ; 44

	toggle_consts_for CELADON_MANSION_ROOF
	const TOGGLE_CELADON_MANSION_ROOF_ITEM     ; NEW X

	toggle_consts_for CELADON_MANSION_ROOF_HOUSE
	const TOGGLE_CELADON_MANSION_EEVEE_GIFT    ; 45

	toggle_consts_for GAME_CORNER
	const TOGGLE_GAME_CORNER_ROCKET            ; 46

	toggle_consts_for WARDENS_HOUSE
	const TOGGLE_WARDENS_HOUSE_ITEM            ; 47 X

	toggle_consts_for POKEMON_MANSION_1F
	const TOGGLE_POKEMON_MANSION_1F_ITEM_1     ; 48 X
	const TOGGLE_POKEMON_MANSION_1F_ITEM_2     ; 49 X

	toggle_consts_for FIGHTING_DOJO
	const TOGGLE_FIGHTING_DOJO_GIFT_1          ; 4A
	const TOGGLE_FIGHTING_DOJO_GIFT_2          ; 4B

	toggle_consts_for SILPH_CO_1F
	const TOGGLE_SILPH_CO_1F_TRAINER_1         ; NEW
	const TOGGLE_SILPH_CO_1F_TRAINER_2         ; NEW
	const TOGGLE_SILPH_CO_1F_TRAINER_3         ; NEW
	const TOGGLE_SILPH_CO_1F_TRAINER_4         ; NEW
	const TOGGLE_SILPH_CO_1F_RECEPTIONIST      ; 4C

	toggle_consts_for ROCK_TUNNEL_1F
	const TOGGLE_ROCK_TUNNEL_1F_ITEM           ; NEW X

	toggle_consts_for ROCK_TUNNEL_B1F
	const TOGGLE_ROCK_TUNNEL_B1F_ITEM_1        ; NEW X
	const TOGGLE_ROCK_TUNNEL_B1F_ITEM_2        ; NEW X

	toggle_consts_for POWER_PLANT
	const TOGGLE_VOLTORB_1                     ; 4D X
	const TOGGLE_VOLTORB_2                     ; 4E X
	const TOGGLE_VOLTORB_3                     ; 4F X
	const TOGGLE_ELECTRODE_1                   ; 50 X
	const TOGGLE_VOLTORB_4                     ; 51 X
	const TOGGLE_VOLTORB_5                     ; 52 X
	const TOGGLE_ELECTRODE_2                   ; 53 X
	const TOGGLE_VOLTORB_6                     ; 54 X
	const TOGGLE_ZAPDOS                        ; 55 X
	const TOGGLE_POWER_PLANT_ITEM_1            ; 56 X
	const TOGGLE_POWER_PLANT_ITEM_2            ; 57 X
	const TOGGLE_POWER_PLANT_ITEM_3            ; 58 X
	const TOGGLE_POWER_PLANT_ITEM_4            ; 59 X
	const TOGGLE_POWER_PLANT_ITEM_5            ; 5A X

	toggle_consts_for VICTORY_ROAD_2F
	const TOGGLE_MOLTRES                       ; 5B X
	const TOGGLE_VICTORY_ROAD_2F_ITEM_1        ; 5C X
	const TOGGLE_VICTORY_ROAD_2F_ITEM_2        ; 5D X
	const TOGGLE_VICTORY_ROAD_2F_ITEM_3        ; 5E X
	const TOGGLE_VICTORY_ROAD_2F_ITEM_4        ; 5F X
	const TOGGLE_VICTORY_ROAD_2F_BOULDER       ; 60

	toggle_consts_for BILLS_HOUSE
	const TOGGLE_BILL_POKEMON                  ; 61
	const TOGGLE_BILL_1                        ; 62
	const TOGGLE_BILL_2                        ; 63

	toggle_consts_for VIRIDIAN_FOREST
	const TOGGLE_VIRIDIAN_FOREST_ITEM_1        ; 64 X
	const TOGGLE_VIRIDIAN_FOREST_ITEM_2        ; 65 X
	const TOGGLE_VIRIDIAN_FOREST_ITEM_3        ; 66 X

	toggle_consts_for MT_MOON_1F
	const TOGGLE_MT_MOON_1F_ITEM_1             ; 67 X
	const TOGGLE_MT_MOON_1F_ITEM_2             ; 68 X
	const TOGGLE_MT_MOON_1F_ITEM_3             ; 69 X
	const TOGGLE_MT_MOON_1F_ITEM_4             ; 6A X
	const TOGGLE_MT_MOON_1F_ITEM_5             ; 6B X
	const TOGGLE_MT_MOON_1F_ITEM_6             ; 6C X

	toggle_consts_for MT_MOON_B2F
	const TOGGLE_MT_MOON_B2F_FOSSIL_1          ; 6D
	const TOGGLE_MT_MOON_B2F_FOSSIL_2          ; 6E
	const TOGGLE_MT_MOON_B2F_ITEM_1            ; 6F X
	const TOGGLE_MT_MOON_B2F_ITEM_2            ; 70 X

	toggle_consts_for SS_ANNE_2F
	const TOGGLE_SS_ANNE_2F_RIVAL              ; 71

	toggle_consts_for SS_ANNE_1F_ROOMS
	const TOGGLE_SS_ANNE_1F_ROOMS_ITEM         ; 72 X

	toggle_consts_for SS_ANNE_2F_ROOMS
	const TOGGLE_SS_ANNE_2F_ROOMS_ITEM_1       ; 73 X
	const TOGGLE_SS_ANNE_2F_ROOMS_ITEM_2       ; 74 X

	toggle_consts_for SS_ANNE_B1F_ROOMS
	const TOGGLE_SS_ANNE_B1F_ROOMS_ITEM_1      ; 75 X
	const TOGGLE_SS_ANNE_B1F_ROOMS_ITEM_2      ; 76 X
	const TOGGLE_SS_ANNE_B1F_ROOMS_ITEM_3      ; 77 X

	toggle_consts_for VICTORY_ROAD_3F
	const TOGGLE_VICTORY_ROAD_3F_ITEM_1        ; 78 X
	const TOGGLE_VICTORY_ROAD_3F_ITEM_2        ; 79 X
	const TOGGLE_VICTORY_ROAD_3F_BOULDER       ; 7A

	toggle_consts_for ROCKET_HIDEOUT_B1F
	const TOGGLE_ROCKET_HIDEOUT_B1F_ITEM_1     ; 7B X
	const TOGGLE_ROCKET_HIDEOUT_B1F_ITEM_2     ; 7C X

	toggle_consts_for ROCKET_HIDEOUT_B2F
	const TOGGLE_ROCKET_HIDEOUT_B2F_ITEM_1     ; 7D X
	const TOGGLE_ROCKET_HIDEOUT_B2F_ITEM_2     ; 7E X
	const TOGGLE_ROCKET_HIDEOUT_B2F_ITEM_3     ; 7F X
	const TOGGLE_ROCKET_HIDEOUT_B2F_ITEM_4     ; 80 X

	toggle_consts_for ROCKET_HIDEOUT_B3F
	const TOGGLE_ROCKET_HIDEOUT_B3F_ITEM_1     ; 81 X
	const TOGGLE_ROCKET_HIDEOUT_B3F_ITEM_2     ; 82 X

	toggle_consts_for ROCKET_HIDEOUT_B4F
	const TOGGLE_ROCKET_HIDEOUT_B4F_GIOVANNI   ; 83
	const TOGGLE_ROCKET_HIDEOUT_B4F_ITEM_1     ; 84 X
	const TOGGLE_ROCKET_HIDEOUT_B4F_ITEM_2     ; 85 X
	const TOGGLE_ROCKET_HIDEOUT_B4F_ITEM_3     ; 86 X
	const TOGGLE_ROCKET_HIDEOUT_B4F_ITEM_4     ; 87
	const TOGGLE_ROCKET_HIDEOUT_B4F_ITEM_5     ; 88

	toggle_consts_for SILPH_CO_2F
	const TOGGLE_SILPH_CO_2F_1                 ; 89 XXX never (de)activated?
	const TOGGLE_SILPH_CO_2F_2                 ; 8A
	const TOGGLE_SILPH_CO_2F_3                 ; 8B
	const TOGGLE_SILPH_CO_2F_4                 ; 8C
	const TOGGLE_SILPH_CO_2F_5                 ; 8D

	toggle_consts_for SILPH_CO_3F
	const TOGGLE_SILPH_CO_3F_1                 ; 8E
	const TOGGLE_SILPH_CO_3F_2                 ; 8F
	const TOGGLE_SILPH_CO_3F_ITEM              ; 90 X

	toggle_consts_for SILPH_CO_4F
	const TOGGLE_SILPH_CO_4F_1                 ; 91
	const TOGGLE_SILPH_CO_4F_2                 ; 92
	const TOGGLE_SILPH_CO_4F_3                 ; 93
	const TOGGLE_SILPH_CO_4F_ITEM_1            ; 94 X
	const TOGGLE_SILPH_CO_4F_ITEM_2            ; 95 X
	const TOGGLE_SILPH_CO_4F_ITEM_3            ; 96 X

	toggle_consts_for SILPH_CO_5F
	const TOGGLE_SILPH_CO_5F_1                 ; 97
	const TOGGLE_SILPH_CO_5F_2                 ; 98
	const TOGGLE_SILPH_CO_5F_3                 ; 99
	const TOGGLE_SILPH_CO_5F_4                 ; 9A
	const TOGGLE_SILPH_CO_5F_ITEM_1            ; 9B X
	const TOGGLE_SILPH_CO_5F_ITEM_2            ; 9C X
	const TOGGLE_SILPH_CO_5F_ITEM_3            ; 9D X

	toggle_consts_for SILPH_CO_6F
	const TOGGLE_SILPH_CO_6F_1                 ; 9E
	const TOGGLE_SILPH_CO_6F_2                 ; 9F
	const TOGGLE_SILPH_CO_6F_3                 ; A0
	const TOGGLE_SILPH_CO_6F_ITEM_1            ; A1 X
	const TOGGLE_SILPH_CO_6F_ITEM_2            ; A2 X

	toggle_consts_for SILPH_CO_7F
	const TOGGLE_SILPH_CO_7F_1                 ; A3
	const TOGGLE_SILPH_CO_7F_2                 ; A4
	const TOGGLE_SILPH_CO_7F_3                 ; A5
	const TOGGLE_SILPH_CO_7F_4                 ; A6
	const TOGGLE_SILPH_CO_7F_RIVAL             ; A7
	const TOGGLE_SILPH_CO_7F_ITEM_1            ; A8 X
	const TOGGLE_SILPH_CO_7F_ITEM_2            ; A9 X

	toggle_consts_for SILPH_CO_8F
	const TOGGLE_SILPH_CO_8F_1                 ; AB
	const TOGGLE_SILPH_CO_8F_2                 ; AC
	const TOGGLE_SILPH_CO_8F_3                 ; AD

	toggle_consts_for SILPH_CO_9F
	const TOGGLE_SILPH_CO_9F_1                 ; AE
	const TOGGLE_SILPH_CO_9F_2                 ; AF
	const TOGGLE_SILPH_CO_9F_3                 ; B0

	toggle_consts_for SILPH_CO_10F
	const TOGGLE_SILPH_CO_10F_1                ; B1
	const TOGGLE_SILPH_CO_10F_2                ; B2
	const TOGGLE_SILPH_CO_10F_3                ; B3 XXX never (de)activated?
	const TOGGLE_SILPH_CO_10F_ITEM_1           ; B4 X
	const TOGGLE_SILPH_CO_10F_ITEM_2           ; B5 X
	const TOGGLE_SILPH_CO_10F_ITEM_3           ; B6 X

	toggle_consts_for SILPH_CO_11F
	const TOGGLE_SILPH_CO_11F_1                ; B7
	const TOGGLE_SILPH_CO_11F_2                ; B8
	const TOGGLE_SILPH_CO_11F_3                ; B9

	toggle_consts_for POKEMON_MANSION_2F
	const TOGGLE_POKEMON_MANSION_2F_ITEM       ; BB X

	toggle_consts_for POKEMON_MANSION_3F
	const TOGGLE_POKEMON_MANSION_3F_ITEM_1     ; BC X
	const TOGGLE_POKEMON_MANSION_3F_ITEM_2     ; BD X

	toggle_consts_for POKEMON_MANSION_B1F
	const TOGGLE_POKEMON_MANSION_B1F_ITEM_1    ; BE X
	const TOGGLE_POKEMON_MANSION_B1F_ITEM_2    ; BF X
	const TOGGLE_POKEMON_MANSION_B1F_ITEM_3    ; C0 X
	const TOGGLE_POKEMON_MANSION_B1F_ITEM_4    ; C1 X
	const TOGGLE_POKEMON_MANSION_B1F_ITEM_5    ; C2 X

	toggle_consts_for CERULEAN_CAVE_2F
	const TOGGLE_CERULEAN_CAVE_2F_ITEM_1       ; CE X
	const TOGGLE_CERULEAN_CAVE_2F_ITEM_2       ; CF X
	const TOGGLE_CERULEAN_CAVE_2F_ITEM_3       ; D0 X

	toggle_consts_for CERULEAN_CAVE_B1F
	const TOGGLE_MEWTWO                        ; D1 X
	const TOGGLE_CERULEAN_CAVE_B1F_ITEM_1      ; D2 X
	const TOGGLE_CERULEAN_CAVE_B1F_ITEM_2      ; D3 X

	toggle_consts_for VICTORY_ROAD_1F
	const TOGGLE_VICTORY_ROAD_1F_ITEM_1        ; D4 X
	const TOGGLE_VICTORY_ROAD_1F_ITEM_2        ; D5 X

	toggle_consts_for CHAMPIONS_ROOM
	const TOGGLE_CHAMPIONS_ROOM_OAK            ; D6

	toggle_consts_for SEAFOAM_ISLANDS_1F
	const TOGGLE_SEAFOAM_ISLANDS_1F_BOULDER_1  ; D7
	const TOGGLE_SEAFOAM_ISLANDS_1F_BOULDER_2  ; D8

	toggle_consts_for SEAFOAM_ISLANDS_B1F
	const TOGGLE_SEAFOAM_ISLANDS_B1F_BOULDER_1 ; D9
	const TOGGLE_SEAFOAM_ISLANDS_B1F_BOULDER_2 ; DA

	toggle_consts_for SEAFOAM_ISLANDS_B2F
	const TOGGLE_SEAFOAM_ISLANDS_B2F_BOULDER_1 ; DB
	const TOGGLE_SEAFOAM_ISLANDS_B2F_BOULDER_2 ; DC

	toggle_consts_for SEAFOAM_ISLANDS_B3F
	const TOGGLE_SEAFOAM_ISLANDS_B3F_BOULDER_1 ; DD
	const TOGGLE_SEAFOAM_ISLANDS_B3F_BOULDER_2 ; DE
	const TOGGLE_SEAFOAM_ISLANDS_B3F_BOULDER_3 ; DF
	const TOGGLE_SEAFOAM_ISLANDS_B3F_BOULDER_4 ; E0
	const TOGGLE_SEAFOAM_ISLANDS_B3F_DOME_FOSSIL   ; E2
	const TOGGLE_SEAFOAM_ISLANDS_B3F_HELIX_FOSSIL  ; E3

	toggle_consts_for SEAFOAM_ISLANDS_B4F
	const TOGGLE_SEAFOAM_ISLANDS_B4F_BOULDER_1 ; E1
	const TOGGLE_SEAFOAM_ISLANDS_B4F_BOULDER_2 ; E2
	const TOGGLE_ARTICUNO                      ; E3 X
	const TOGGLE_SEAFOAM_ISLANDS_B4F_ITEM      ; NEW X

	toggle_consts_for VERMILION_DOCK
	const TOGGLE_MEW_VERMILION_DOCK            ; NEW X

	toggle_consts_for CERULEAN_ROCKET_HOUSE_1F
	const TOGGLE_CERULEAN_ROCKET_HOUSE_1F_GUY  ; NEW X

	toggle_consts_for CELADON_HOTEL
	const TOGGLE_LAPRAS_GUY_CELADON  ; NEW X
	; current length -> 245 (F5)
	; 9 slots remain
DEF NUM_TOGGLEABLE_OBJECTS EQU const_value


	const_def

	toggle_consts_for SAFARI_ZONE_EAST
	const TOGGLE_SAFARI_ZONE_EAST_RANGER_0     ; 00 X
	const TOGGLE_SAFARI_ZONE_EAST_TRAINER_0    ; 01 X
	const TOGGLE_SAFARI_ZONE_EAST_TRAINER_1    ; 02 X
	const TOGGLE_SAFARI_ZONE_EAST_TRAINER_2    ; 03 X
	const TOGGLE_SAFARI_ZONE_EAST_TRAINER_3    ; 04 X
	const TOGGLE_SAFARI_ZONE_EAST_ITEM_1       ; 05 X
	const TOGGLE_SAFARI_ZONE_EAST_ITEM_2       ; 06 X
	const TOGGLE_SAFARI_ZONE_EAST_ITEM_3       ; 07 X
	const TOGGLE_SAFARI_ZONE_EAST_ITEM_4       ; 08 X

	toggle_consts_for SAFARI_ZONE_NORTH
	const TOGGLE_SAFARI_ZONE_NORTH_RANGER_0    ; 09 X
	const TOGGLE_SAFARI_ZONE_NORTH_TRAINER_0   ; 0A X
	const TOGGLE_SAFARI_ZONE_NORTH_TRAINER_1   ; 0B X
	const TOGGLE_SAFARI_ZONE_NORTH_TRAINER_2   ; 0C X
	const TOGGLE_SAFARI_ZONE_NORTH_TRAINER_3   ; 0D X
	const TOGGLE_SAFARI_ZONE_NORTH_TRAINER_4   ; 0E X
	const TOGGLE_SAFARI_ZONE_NORTH_ITEM_1      ; 0F X
	const TOGGLE_SAFARI_ZONE_NORTH_ITEM_2      ; 10 X

	toggle_consts_for SAFARI_ZONE_WEST
	const TOGGLE_SAFARI_ZONE_WEST_RANGER_0    ; 11 X
	const TOGGLE_SAFARI_ZONE_WEST_RANGER_1    ; 12 X
	const TOGGLE_SAFARI_ZONE_WEST_TRAINER_0   ; 13 X
	const TOGGLE_SAFARI_ZONE_WEST_TRAINER_1   ; 14 X
	const TOGGLE_SAFARI_ZONE_WEST_TRAINER_2   ; 15 X
	const TOGGLE_SAFARI_ZONE_WEST_TRAINER_3   ; 16 X
	const TOGGLE_SAFARI_ZONE_WEST_TRAINER_4   ; 17 X
	const TOGGLE_SAFARI_ZONE_WEST_ITEM_1       ; 18 X
	const TOGGLE_SAFARI_ZONE_WEST_ITEM_2       ; 19 X
	const TOGGLE_SAFARI_ZONE_WEST_ITEM_3       ; 1A X
	const TOGGLE_SAFARI_ZONE_WEST_ITEM_4       ; 1B X

	toggle_consts_for SAFARI_ZONE_CENTER
	const TOGGLE_SAFARI_ZONE_CENTER_RANGER_0     ; 1C X
	const TOGGLE_SAFARI_ZONE_CENTER_TRAINER_0    ; 1D X
	const TOGGLE_SAFARI_ZONE_CENTER_TRAINER_1    ; 1E X
	const TOGGLE_SAFARI_ZONE_CENTER_TRAINER_2    ; 1F X
	const TOGGLE_SAFARI_ZONE_CENTER_TRAINER_3    ; 20 X
	const TOGGLE_SAFARI_ZONE_CENTER_ITEM       ; 21 X

	toggle_consts_for VIRIDIAN_SCHOOL_HOUSE
	const TOGGLE_VIRIDIAN_SCHOOL_HOUSE_DETENTION ; 22 X
	const TOGGLE_VIRIDIAN_SCHOOL_HOUSE_DETENTION2 ; 23 X\

	toggle_consts_for VIRIDIAN_SCHOOL_HOUSE_B1F
	const TOGGLE_VIRIDIAN_SCHOOL_HOUSE_B1F_DETENTION ; 24 X
	const TOGGLE_VIRIDIAN_SCHOOL_HOUSE_B1F_DETENTION2 ; 25 X

	toggle_consts_for REDS_HOUSE_1F
	const TOGGLE_REDS_HOUSE_1F_DAD ; 26 X

	toggle_consts_for CERULEAN_ROCKET_HOUSE_B1F
	const TOGGLE_TOPSECRETKEY ; 27 X

	toggle_consts_for SECRET_LAB
	const TOGGLE_SECRET_LAB_SOLDIER_1 ; 28 X
	const TOGGLE_SECRET_LAB_SOLDIER_2 ; 29 X
	const TOGGLE_SECRET_LAB_CHIEF ; 2A X

	toggle_consts_for POKEMON_TOWER_1F
	const TOGGLE_POKEMON_TOWER_1F_ROCKET ; 2B X

	toggle_consts_for CHAMP_ARENA
	const TOGGLE_CHAMP_ARENA_CHALLENGER ; 2C X
	const TOGGLE_CHAMP_ARENA_PROXY_PLAYER ; 2D X
	const TOGGLE_CHAMP_ARENA_TM_KID ; 2E X
	const TOGGLE_CHAMP_ARENA_CROWD_1 ; 2F X
	const TOGGLE_CHAMP_ARENA_CROWD_2 ; 30 X
	const TOGGLE_CHAMP_ARENA_VARIABLE_CROWD_1 ; 31 X
	const TOGGLE_CHAMP_ARENA_VARIABLE_CROWD_2 ; 32 X
	const TOGGLE_CHAMP_ARENA_CROWD_3 ; 33 X
	const TOGGLE_CHAMP_ARENA_VARIABLE_CROWD_3 ; 34 X
	const TOGGLE_CHAMP_ARENA_CROWD_4 ; 35 X

	toggle_consts_for INDIGO_PLATEAU_LOBBY
	const TOGGLE_INDIGO_PLATEAU_LOBBY_CHAMP_ARENA_ASSISTANT ; 36 X

	toggle_consts_for CELADON_MANSION_2F
	const TOGGLE_PROSPECTORS_HOUSE_PROSPECTOR ; 37 X

	toggle_consts_for CINNABAR_VOLCANO
	const TOGGLE_VOLCANO_BLAINE ; 38 X
	const TOGGLE_VOLCANO_ARCANINE ; 39 X
	const TOGGLE_VOLCANO_MOLTRES ; 3A X
	const TOGGLE_VOLCANO_RUBY_1 ; 3B X
	const TOGGLE_VOLCANO_RUBY_2 ; 3C X
	const TOGGLE_VOLCANO_RUBY_3 ; 3D X
	const TOGGLE_VOLCANO_ANIMATION_PROXY ; 3E X
	const TOGGLE_VOLCANO_ITEM1 ; 3F X
	const TOGGLE_VOLCANO_ITEM2 ; 40 X
	const TOGGLE_VOLCANO_SURFING_RHYDON ; 41 X
	const TOGGLE_VOLCANO_BOSS_MAGMAR ; 42 X

	toggle_consts_for POWER_PLANT_ROOF
	const TOGGLE_POWER_PLANT_ROOF_ZAPDOS ; 43 X

	toggle_consts_for DIGLETTS_CAVE
	const TOGGLE_DIGLETTS_CAVE_DIGLETT1 ; 44 X
	const TOGGLE_DIGLETTS_CAVE_DIGLETT2 ; 45 X
	const TOGGLE_DIGLETTS_CAVE_DIGLETT3 ; 46 X
	const TOGGLE_DIGLETTS_CAVE_DIGLETT4 ; 47 X

	toggle_consts_for LAVENDER_CUBONE_HOUSE
	const TOGGLE_LAVENDER_TOWN_CUBONE ; 48 X

	toggle_consts_for FUCHSIA_CITY
	const TOGGLE_FUCHSIA_ERIK ; 49

	toggle_consts_for SAFARI_ZONE_CENTER_REST_HOUSE
	const TOGGLE_SAFARI_ZONE_CENTER_REST_HOUSE_SARA ; 4A
	const TOGGLE_SAFARI_ZONE_CENTER_REST_HOUSE_ERIK ; 4B

	toggle_consts_for FUCHSIA_GOOD_ROD_HOUSE
	const TOGGLE_ERIK_HOUSE ; 4C
	const TOGGLE_SARA_HOUSE ; 4D
	const TOGGLE_ERIK_SARA_HOUSE_NOTE2 ; 4E

	toggle_consts_for CERULEAN_BALL_DESIGNER
	const TOGGLE_CERULEAN_BALL_DESIGNER_CLIPBOARD ; 4F
	const TOGGLE_CERULEAN_BALL_DESIGNER_CAMERA ; 50
	const TOGGLE_CERULEAN_BALL_DESIGNER_CLIPBOARD2 ; 51

	toggle_consts_for VERMILION_FITNESS_CLUB
	const TOGGLE_VERMILIONFITNESSCLUB_CLERK ; 52
	const TOGGLE_VERMILIONFITNESSCLUB_MUSCLE1 ; 53
	const TOGGLE_VERMILIONFITNESSCLUB_JANITOR ; 54
	; max allowed value = 98

DEF NUM_EXTRA_TOGGLEABLE_OBJECTS EQU const_value