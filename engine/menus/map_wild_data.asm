	const_def
	const WILD_DATA_GRASS
	const WILD_DATA_WATER
	const WILD_DATA_SUPER_ROD

; TODO: reload uninteracted town map

ShowMapWildEncounters::
	CheckBothEventsSet EVENT_GOT_FUCHSIA_FISHING_GURU_ITEM, EVENT_GOT_ROUTE12_FISHING_GURU_ITEM
	jr z, .noPalletCheck
	ld a, d
	cp PALLET_TOWN
	ret z
.noPalletCheck
	push de
	ld a, d
	ld hl, NoWildMonsMaps
	call IsInSingleByteArray
	pop de
	ret c
	push de
	call SaveScreenTilesToBuffer1
	pop de
	xor a
	ld [wTownMapSpriteBlinkingEnabled], a
	ld [wCurTownMapWildDataFloorIndex], a
	ld [wCurTownMapMaxWildDataFloorIndex], a
	ld a, d
	ld [wCurTownMapWildDataMap], a
	ld [wCurTownMapInternalWildDataMap], a
	push de
	call GetWildDataMaxFloor
	call ClearSprites
	call ClearScreen
	ld a, [wCurTownMapWildDataMap]
	ld hl, WildMonSpecificMapPalettes
	ld de, 2
	call IsInArray
	jr nc, .noSpecialPalette
	inc hl
	ld a, [hl]
	ld [wGenericPaletteOverride], a
	ld d, SET_PAL_GENERIC
	call RunPaletteCommand
.noSpecialPalette
	; interface arrows
	ld hl, vSprites tile $D0
	ld de, WildDataArrows
	lb bc, BANK(WildDataArrows), 2
	call CopyVideoDataDouble
	ld hl, vSprites tile $D2
	ld de, BattleHudTiles1 tile1bpp 1
	lb bc, BANK(BattleHudTiles1), 1
	call CopyVideoDataDouble
	; grass tile
	ld hl, vSprites tile $D3
	ld de, Overworld_GFX tile $52
	lb bc, BANK(Overworld_GFX), 1
	call CopyVideoData
	; lava tile
	ld hl, vSprites tile $D4
	ld de, Volcano_GFX tile 20
	lb bc, BANK(Volcano_GFX), 1
	call CopyVideoData
	; foot tile
	ld hl, vSprites tile $D5
	ld de, WildDataShoe
	lb bc, BANK(WildDataShoe), 1
	call CopyVideoData
	; hook tile
	ld hl, vSprites tile $D6
	ld de, FishingWaterIcons
	lb bc, BANK(FishingWaterIcons), 1
	call CopyVideoDataDouble
	; ball tile
	callfar LoadPokeballTileGraphics
	pop de
	ld c, d
	decoord 1, 1
	callfar FarPrintTownMapEntry
	jr .skipMapLoopInit
.loopShowMapWildData
	hlcoord 0, 4
	lb bc, 12, 20
	call ClearScreenArea
.skipMapLoopInit
	ld a, [wCurTownMapInternalWildDataMap]
	ld d, a
	push de
	callfar LoadArbitraryWildData
	pop de
	callfar CopySuperRodEncounters
	call MapHasGrassEncounters
	ld de, wGrassMons
	ld a, WILD_DATA_GRASS
	jr c, .gotInitialEncounters
	call MapHasWaterEncounters
	ld de, wWaterMons
	ld a, WILD_DATA_WATER
	jr c, .gotInitialEncounters
	ld de, wSuperRodCount
	ld a, WILD_DATA_SUPER_ROD
.gotInitialEncounters
	ld [wCurTownMapWildDataType], a
	jr .skipInitLoop
.loopPrintEncounters
	hlcoord 0, 4
	lb bc, 12, 20
	call ClearScreenArea
	call GetWildMonDataSource
.skipInitLoop
	call PrintWildMonNamesAndLevels
	call PrintWildProbabilities
	hlcoord 1, 3
	ld de, WildPokemonText
	call PlaceString
	call CheckHasMultipleWildDataTypes
	hlcoord 1, 4
	jr z, .skipDownUpPrompt
	ld [hl], $D1 ; left/right arrow tile
	inc hl
	inc hl
.skipDownUpPrompt
	call PrintCurrentWildDataType
	call CheckMapHasMultipleFloors
	jr nc, .loopJoypad
	call PrintFloorText
.loopJoypad
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	bit B_PAD_B, a
	jr nz, .exit
	bit B_PAD_RIGHT, a
	jr nz, .goRight
	bit B_PAD_LEFT, a
	jr nz, .goLeft
	bit B_PAD_DOWN, a
	jr nz, .goDown
	bit B_PAD_UP, a
	jr nz, .goUp
	jr .loopJoypad
.goRight
	call CheckHasMultipleWildDataTypes
	jr z, .loopJoypad
	ld a, SFX_LEDGE
	rst _PlaySound
	call FindNextWildDataType
	jr .loopPrintEncounters
.goLeft
	call CheckHasMultipleWildDataTypes
	jr z, .loopJoypad
	ld a, SFX_LEDGE
	rst _PlaySound
	call FindPrevWildDataType
	jr .loopPrintEncounters
.goDown
	call CheckMapHasMultipleFloors
	jr nc, .loopJoypad
	ld a, SFX_TELEPORT_ENTER_2
	rst _PlaySound
	call FindNextWildDataFloor
	jp .loopShowMapWildData
.goUp
	call CheckMapHasMultipleFloors
	jr nc, .loopJoypad
	ld a, SFX_TELEPORT_ENTER_2
	rst _PlaySound
	call FindPrevWildDataFloor
	jp .loopShowMapWildData
.exit
	call ClearScreen
	call Delay3
	call LoadScreenTilesFromBuffer1
	ld d, SET_PAL_TOWN_MAP
	call RunPaletteCommand
	ld hl, wTownMapSavedOAM + (wShadowOAMSprite36 - wShadowOAMSprite00)
	ld de, wShadowOAMSprite36
	ld bc, 16
	rst _CopyData
	jpfar LoadWildData

FindNextWildDataType:
	ld a, [wCurTownMapWildDataType]
	inc a
	cp WILD_DATA_SUPER_ROD + 1
	jr nz, .got
	xor a
.got
	call FindSubsequentWildDataType
	ret c
	jr FindNextWildDataType

FindPrevWildDataType:
	ld a, [wCurTownMapWildDataType]
	dec a
	cp $FF
	jr nz, .got
	ld a, WILD_DATA_SUPER_ROD
.got
	call FindSubsequentWildDataType
	ret c
	jr FindPrevWildDataType

FindSubsequentWildDataType:
	ld [wCurTownMapWildDataType], a
	cp WILD_DATA_GRASS
	jr z, MapHasGrassEncounters
	cp WILD_DATA_WATER
	jr z, MapHasWaterEncounters
	jr MapHasSuperRodEncounters

MapHasGrassEncounters:
	ld a, [wCurTownMapInternalWildDataMap]
	ld hl, NoGrassEncountersMaps
	call IsInSingleByteArray
	jr c, .done
	ld a, [wGrassRate]
	and a
	ret z
	scf
	ret
.done
	ccf
	ret

MapHasWaterEncounters:
	ld a, [wWaterRate]
	and a
	ret z
	scf
	ret

MapHasSuperRodEncounters:
	CheckBothEventsSet EVENT_GOT_FUCHSIA_FISHING_GURU_ITEM, EVENT_GOT_ROUTE12_FISHING_GURU_ITEM
	jr nz, .no
	ld a, [wCurTownMapInternalWildDataMap]
	ld d, a
	push bc
	callfar DoesMapHaveSuperRodEncounters
	pop bc
	jr nc, .no
	scf
	ret
.no
	and a
	ret

CheckHasMultipleWildDataTypes:
	ld b, 0
	push bc
	call MapHasGrassEncounters
	pop bc
	jr nc, .skip1
	inc b
.skip1
	call MapHasWaterEncounters
	jr nc, .skip2
	inc b
.skip2
	call MapHasSuperRodEncounters
	jr nc, .skip3
	inc b
.skip3
	dec b
	ret

GetWildMonDataSource:
	ld hl, WildMonDataSources
	ld a, [wCurTownMapWildDataType]
	add a
	ld d, 0
	ld e, a
	add hl, de
	de_deref
	ret

WildMonDataSources:
	dw wGrassMons
	dw wWaterMons
	dw wSuperRodCount

PrintCurrentWildDataType:
	ld a, [wCurTownMapWildDataType]
	cp WILD_DATA_WATER
	jr z, .water
	cp WILD_DATA_SUPER_ROD
	ld b, $D6
	ld de, WildDataSuperRodText
	jr z, .gotType
.grassOrCave
	ld b, $D3
	ld de, WildDataGrassText
	ld a, [wCurTownMapWildDataMap]
	cp FIRST_INDOOR_MAP
	jr c, .gotType
	cp SAFARI_ZONE_EAST
	jr z, .gotType
	cp VIRIDIAN_FOREST
	jr z, .gotType
	ld b, $D5
	ld de, WildDataWalkingText
	jr .gotType
.water
	ld a, [wCurTownMapWildDataMap]
	cp CINNABAR_VOLCANO
	ld b, $D4
	ld de, WildDataLavaText
	jr z, .gotType
	ld b, $64
	ld de, WildDataSurfingText
.gotType
	push bc
	call PlaceString
	pop bc
	hlcoord 9, 3
	ld [hl], b
	inc hl
	ld [hl], b
	ret

WildPokemonText:
	db "Wild <PKMN>:@"
WildDataGrassText:
	db "Grass@"
WildDataSurfingText:
	db "Surfing@"
WildDataSuperRodText:
	db "SuperRod@"
WildDataWalkingText:
	db "Walking@"
WildDataLavaText:
	db "Lava@"
WildDataFloorText:
	db "Floor:@"
WildDataAreaText:
	db "Area:@"

PrintWildMonNamesAndLevels:
	hlcoord 0, 6
	ld a, [wCurTownMapWildDataType]
	cp WILD_DATA_SUPER_ROD
	ld b, 10
	jr nz, .loopPrintWildEntries
	ld a, [de]
	inc de
	ld b, a
.loopPrintWildEntries
	push bc
	push hl
	inc de
	ld a, [de]
	call IsWildMonCaught
	jr nc, .notCaught
	ld [hl], $72 ; ball tile
.notCaught
	inc hl
	inc hl
	ld a, [de]
	ld [wNamedObjectIndex], a
	push de
	push af
	call GetMonName
	pop af
	call IsWildMonSeen
	jr c, .seen
	ld de, WildMonNotSeen
.seen
	call PlaceString
	ld de, NAME_LENGTH
	add hl, de
	ld [hl], $D2 ; "Lv" tile
	inc hl
	pop de
	dec de
	lb bc, 1, 2
	push de
	call PrintNumber
	pop de
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	inc de
	inc de
	pop bc
	dec b
	jr nz, .loopPrintWildEntries
	ret

PrintWildProbabilities:
	hlcoord 17, 6
	ld a, [wCurTownMapWildDataType]
	cp WILD_DATA_SUPER_ROD
	jr nz, .normal
	ld a, [wSuperRodCount]
	ld b, a
	cp 2
	ld de, SuperRod2
	jr z, .rodTextLoop
	ld de, SuperRod4
.rodTextLoop
	push de
	push bc
	call PlaceString
	pop bc
	ld de, SCREEN_WIDTH
	add hl, de
	pop de
	dec b
	jr nz, .rodTextLoop
	ret
.normal
	ld b, 10
	ld c, 0
.loopPlaceWildPercentages
	push bc
	push hl
	ld hl, WildProbabilityMapping
	ld d, 0
	ld e, c
	add hl, de
	ld a, [hl]
	add a
	ld hl, WildPercentagesText
	ld e, a
	add hl, de
	ld d, h
	ld e, l
	pop hl
	push hl
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hli], a
	ld [hl], '%'
	pop hl
	ld d, 0
	ld e, SCREEN_WIDTH
	add hl, de
	pop bc
	inc c
	dec b
	jr nz, .loopPlaceWildPercentages
	ret

SuperRod2:
	db "50%@"

SuperRod4:
	db "25%@"

WildMonNotSeen:
	db "------@"

WildPercentagesText:
	db "20"
	db "15"
	db "10"
	db " 5"
	db " 4"
	db " 1"

WildProbabilityMapping:
	db 0
	db 0
	db 1
	db 2
	db 2
	db 2
	db 3
	db 3
	db 4
	db 5

IsWildMonSeen::
	push hl
	ld hl, wPokedexSeen
	jr WildMonCheckFlags

IsWildMonCaught::
	push hl
	ld hl, wPokedexOwned
	; fall through
WildMonCheckFlags::
	push de
	push bc
	push hl
	ld [wPokedexNum], a
	call IndexToPokedex
	ld a, [wPokedexNum]
	pop hl
	dec a
	ld c, a
	ld b, FLAG_TEST
	call FlagAction
	jr z, .done
	scf
.done
	pop bc
	pop de
	pop hl
	ret

CheckMapHasMultipleFloors:
	ld hl, MultiFloorMaps
	ld a, [wCurTownMapWildDataMap]
	ld de, 3
	jp IsInArray

PrintFloorText:
	ld a, [wCurTownMapWildDataMap]
	cp SAFARI_ZONE_EAST
	hlcoord 15, 4
	ld de, WildDataFloorText
	jr nz, .print
	hlcoord 12, 4
	ld de, WildDataAreaText
.print
	ld [hl], $D0 ; up and down arrow indicator
	inc hl
	inc hl
	push hl
	hlcoord 12, 3
	call PlaceString
	call GetWildDataFloorData
	call GetWildDataCurrentFloorData
	inc hl
	ld a, [wCurTownMapWildDataMap]
	cp SAFARI_ZONE_EAST
	jr nz, .notSafari
	ld a, [hl]
	ld hl, SafariZoneAreasText
	ld bc, 7
	call AddNTimes
	ld d, h
	ld e, l
	jr .gotAreaName
.notSafari
	ld a, [hl]
	ld [wNamedObjectIndex], a
	callfar GetFloorName
.gotAreaName
	pop hl
	jp PlaceString

SafariZoneAreasText:
	db "EAST@@@"
	db "CENTER@"
	db "NORTH@@"
	db "WEST@@@"

GetWildDataFloorData:
	ld a, [wCurTownMapWildDataMap]
	ld hl, MultiFloorMaps
	ld de, 3
	call IsInArray
	inc hl
	hl_deref
	ret

MultiFloorMaps:
	dbw MT_MOON_1F, WildMonFloorsMtMoon
	dbw ROCK_TUNNEL_1F, WildMonFloorsRockTunnel
	dbw POKEMON_TOWER_3F, WildMonFloorsPokemonTower
	dbw SAFARI_ZONE_EAST, WildMonFloorsSafariZone
	dbw SEAFOAM_ISLANDS_1F, WildMonFloorsSeafoam
	dbw POKEMON_MANSION_1F, WildMonFloorsPokemonMansion 
	dbw VICTORY_ROAD_1F, WildMonFloorsVictoryRoad
	dbw CERULEAN_CAVE_1F, WildMonFloorsCeruleanCave
	db -1

NoWildMonsMaps:
	db PEWTER_CITY
	db BILLS_HOUSE ; BILLS GARDEN remap?
	db SS_ANNE_1F
	db LAVENDER_TOWN
	db SAFFRON_CITY
	db INDIGO_PLATEAU
	db -1

NoGrassEncountersMaps:
	db ROUTE_19
	db ROUTE_20
	db CINNABAR_ISLAND
	db -1

WildMonFloorsMtMoon:
	db MT_MOON_1F, FLOOR_1F
	db MT_MOON_B1F, FLOOR_B1F
	db MT_MOON_B2F, FLOOR_B2F
	db -1

WildMonFloorsRockTunnel:
	db ROCK_TUNNEL_1F, FLOOR_1F
	db ROCK_TUNNEL_B1F, FLOOR_B1F
	db -1

WildMonFloorsPokemonTower:
	db POKEMON_TOWER_3F, FLOOR_3F
	db POKEMON_TOWER_7F, FLOOR_7F
	db POKEMON_TOWER_6F, FLOOR_6F
	db POKEMON_TOWER_5F, FLOOR_5F
	db POKEMON_TOWER_4F, FLOOR_4F
	db -1

WildMonFloorsSafariZone:
	db SAFARI_ZONE_EAST, 0
	db SAFARI_ZONE_CENTER, 1
	db SAFARI_ZONE_NORTH, 2
	db SAFARI_ZONE_WEST, 3
	db -1

WildMonFloorsSeafoam:
	db SEAFOAM_ISLANDS_1F, FLOOR_1F
	db SEAFOAM_ISLANDS_B1F, FLOOR_B1F
	db SEAFOAM_ISLANDS_B2F, FLOOR_B2F
	db SEAFOAM_ISLANDS_B3F, FLOOR_B3F
	db SEAFOAM_ISLANDS_B4F, FLOOR_B4F
	db -1

WildMonFloorsVictoryRoad:
	db VICTORY_ROAD_1F, FLOOR_1F
	db VICTORY_ROAD_3F, FLOOR_3F
	db VICTORY_ROAD_2F, FLOOR_2F
	db -1

WildMonFloorsPokemonMansion:
	db POKEMON_MANSION_1F, FLOOR_1F
	db POKEMON_MANSION_B1F, FLOOR_B1F
	db POKEMON_MANSION_3F, FLOOR_3F
	db POKEMON_MANSION_2F, FLOOR_2F
	db -1

WildMonFloorsCeruleanCave:
	db CERULEAN_CAVE_1F, FLOOR_1F
	db CERULEAN_CAVE_B1F, FLOOR_B1F
	db CERULEAN_CAVE_2F, FLOOR_2F
	db -1

GetWildDataMaxFloor:
	call CheckMapHasMultipleFloors
	ret nc
	call GetWildDataFloorData
	ld b, 0
.loopFindMax
	ld a, [hli]
	inc hl
	cp -1
	jr z, .found
	inc b
	jr .loopFindMax
.found
	ld a, b
	ld [wCurTownMapMaxWildDataFloorIndex], a
	ret

GetWildDataCurrentFloorData:
	ld a, [wCurTownMapWildDataFloorIndex]
	add a
	ld d, 0
	ld e, a
	add hl, de
	ret

FindNextWildDataFloor:
	ld a, [wCurTownMapMaxWildDataFloorIndex]
	ld b, a
	ld a, [wCurTownMapWildDataFloorIndex]
	inc a
	cp b
	jr nz, .gotIndex
	xor a
.gotIndex
	jr LoadWildDataFloorData

FindPrevWildDataFloor:
	ld a, [wCurTownMapWildDataFloorIndex]
	dec a
	cp $FF
	jr nz, .gotIndex
	ld a, [wCurTownMapMaxWildDataFloorIndex]
	dec a
.gotIndex
	; fall through
LoadWildDataFloorData:
	ld [wCurTownMapWildDataFloorIndex], a
	call GetWildDataFloorData
	call GetWildDataCurrentFloorData
	ld a, [hl]
	ld [wCurTownMapInternalWildDataMap], a
	ret

WildMonSpecificMapPalettes:
	db MT_MOON_1F, PAL_CAVE
	db ROCK_TUNNEL_1F, PAL_CAVE
	db CINNABAR_VOLCANO, PAL_VOLCANO
	db POKEMON_TOWER_3F, PAL_GRAYMON
	db CERULEAN_CAVE_1F, PAL_CAVE
	db POKEMON_MANSION_1F, PAL_CINNABAR
	db VICTORY_ROAD_1F, PAL_CAVE
	db SEAFOAM_ISLANDS_1F, PAL_0F
	db SAFARI_ZONE_EAST, PAL_FUCHSIA
	db POWER_PLANT, PAL_MEWMON
	db DIGLETTS_CAVE, PAL_CAVE
	db -1
