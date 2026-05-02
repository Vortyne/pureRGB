; PureRGBnote: CHANGED: This map script was changed a bunch to simplify how currents move the player around.
SeafoamIslandsB3F_Script:
	call EnableAutoTextBoxDrawing
	call SeafoamIslandsB3FOnMapLoad
	ld de, SeafoamB3FHolesCoords
	ld hl, SeafoamBoulderB3FEventFunc
	ld bc, SeafoamB3FBoulderToggleData
	call SeafoamBoulderPushRoutine
	jr c, .runCurrentMapScript
	ld a, SEAFOAM_ISLANDS_B4F
	ld [wDungeonWarpDestinationMap], a
	ld hl, SeafoamB3FHolesCoords
	call IsPlayerOnDungeonWarp
	ld a, [wStatusFlags6]
	bit BIT_DUNGEON_WARP, a
	ret nz
.runCurrentMapScript
	ld hl, SeafoamIslandsB3F_ScriptPointers
	ld a, [wSeafoamIslandsB3FCurScript]
	jp CallFunctionInTable

SeafoamIslandsB3FOnMapLoad::
	call WasMapJustLoaded
	ret z
	SetFlag FLAG_MAP_HAS_OVERWORLD_ANIMATION
	; script constants were changed from older save file versions so potentially need to update them here to remove invalid values
	; TODO: remove later?
	ld hl, wSeafoamIslandsB3FCurScript
	ld a, [hl]
	cp SCRIPT_SEAFOAMISLANDSB3F_END
	jr c, .noIncorrectValue
	xor a
	ld [hl], a
.noIncorrectValue
	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	ret nz
	ld de, SeafoamB3FCurrentWestVerticalReplacements
	ld a, $76
	ld [wNewTileBlockID], a
	jpfar ReplaceMultipleTileBlockLineVerticalWithOneBlock

SeafoamIslandsB3F_ScriptPointers:
	def_script_pointers
	dw_const SeafoamIslandsB3FDefaultScript,       SCRIPT_SEAFOAMISLANDSB3F_DEFAULT
	dw_const SeafoamIslandsB3FObjectMoving1Script, SCRIPT_SEAFOAMISLANDSB3F_OBJECT_MOVING1
	DEF SCRIPT_SEAFOAMISLANDSB3F_END EQU const_value

SeafoamIslandsB3FDefaultScript:
	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	ret z
	call SeafoamIslandsCurrents
	ret nc
	ld hl, wStatusFlags7
	set BIT_FORCED_WARP, [hl]
	ld a, SCRIPT_SEAFOAMISLANDSB3F_OBJECT_MOVING1
	ld [wSeafoamIslandsB3FCurScript], a
	ret

SeafoamIslandsCurrents:
	lda_coord 8, 9 ; tile below player
	cp $30
	ld b, PAD_UP
	jr z, .forceInput
	cp $3B
	ld b, PAD_RIGHT
	jr z, .forceInput
	cp $42
	ld b, PAD_DOWN
	jr z, .forceInput
	and a
	ret
.forceInput
	ld a, b
	ld hl, wSimulatedJoypadStatesEnd
	ld [hli], a
	ld [hl], -1
	ld a, 1
	ld [wSimulatedJoypadStatesIndex], a
	SetFlag FLAG_FAST_AUTO_MOVEMENT
	call StartSimulatingJoypadStates
	scf
	ret

SeafoamIslandsB3FObjectMoving1Script:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld a, SCRIPT_SEAFOAMISLANDSB3F_DEFAULT
	ld [wSeafoamIslandsB3FCurScript], a
	ret

SeafoamIslandsB3F_TextPointers:
    def_text_pointers
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB3F_BOULDER1
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB3F_BOULDER2
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB3F_BOULDER3
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB3F_BOULDER4
	dw_const BoulderBlockingWaterB3F, TEXT_SEAFOAMISLANDSB3F_BOULDER5
	dw_const BoulderBlockingWaterB3F, TEXT_SEAFOAMISLANDSB3F_BOULDER6
	dw_const PickUpFossilText, TEXT_SEAFOAMISLANDSB3F_DOME_FOSSIL
	dw_const PickUpFossilText, TEXT_SEAFOAMISLANDSB3F_HELIX_FOSSIL

PickUpFossilText:
	text_asm
	SetEvent EVENT_SEAFOAM_FOUND_OTHER_FOSSIL
	callfar PickUpItem
	rst TextScriptEnd

BoulderBlockingWaterB3F:
	text_far _BoulderBlockingCurrent
	text_end

SeafoamWaveSFXB3F::
	ld hl, wAudioFlags
	bit BIT_WAITING_FOR_SOUND_TO_FINISH, [hl]
	ret nz ; don't play the sound if we're waiting for sounds to finish currently or it'll wait forever
	ld hl, wOverworldAnimationCounter
	inc [hl]
.notAllDone
	ld a, [wOverworldAnimationCounter]
	and %11
	ret nz ; every 2 iterations the below code will run
	lb bc, 7, 21
	lb de, 0,  4
	predef ArePlayerCoordsInRangePredef
	dec d
	jr z, .closeSound
	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	lb bc, 16, 21
	lb de, 5, 7
	jr z, .currentBlocked1
	lb bc, 12, 22
	lb de, 5, 12
.currentBlocked1
	predef ArePlayerCoordsInRangePredef
	dec d
	jr z, .closeSound
	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	jr z, .further
	lb bc, 18, 22
	lb de, 12, 17
	predef ArePlayerCoordsInRangePredef
	dec d
	jr nz, .further
.closeSound
	ld de, CurrentSoundLoud
	jp PlayNewSoundChannel8
.further
	lb bc, 5, 24
	lb de, 0,  6
	predef ArePlayerCoordsInRangePredef
	dec d
	jr z, .farSound
	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	lb bc, 14, 23
	lb de, 5, 11
	jr z, .currentBlocked2
	lb bc, 9, 24
	lb de, 5, 14
.currentBlocked2
	predef ArePlayerCoordsInRangePredef
	dec d
	jr z, .farSound
	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	ret z
	lb bc, 16, 24
	lb de, 12, 17
	predef ArePlayerCoordsInRangePredef
	dec d
	ret nz
.farSound
	ld de, CurrentSoundQuiet
	jp PlayNewSoundChannel8
