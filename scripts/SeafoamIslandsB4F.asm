; PureRGBnote: CHANGED: This script was adjusted a bunch to simplify how currents move the player, and to add an animation
; before you fight ARTICUNO, and some events/text when SARA and ERIK come here to research the DRAGONAIR in the lake.

SeafoamIslandsB4F_Script:
	call EnableAutoTextBoxDrawing
	call SeafoamIslandsB4FOnMapLoad
	ld a, [wSeafoamIslandsB4FCurScript]
	ld hl, SeafoamIslandsB4F_ScriptPointers
	jp CallFunctionInTable

SeafoamIslandsB4FOnMapLoad::
	call WasMapJustLoaded
	ret z
	SetFlag FLAG_MAP_HAS_OVERWORLD_ANIMATION
	CheckEvent EVENT_SEAFOAM_DRAGONAIR_PRESENT
	jr z, .noDragonair
	CheckEvent FLAG_BALL_DESIGNER_TURNED_OFF
	jr nz, .noDragonair
	lb bc, SPRITESTATEDATA2_MAPX, SEAFOAMISLANDSB4F_DRAGONAIR
	call GetFromSpriteStateData2
	ld [hl], 4 + 4
.noDragonair
	ld a, [wSeafoamIslandsB4FCurScript]
	cp SCRIPT_SEAFOAMISLANDSB4F_DRAGONAIR_EVENT_START
	jp z, SeafoamIslandsB4FDragonairEventOnMapLoad
	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	call z, SeafoamB4FReplaceEastCurrentBlock
	CheckBothEventsSet EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM4_BOULDER2_DOWN_HOLE
	ret nz
	ld de, SeafoamB4FCurrentWestHorizontalReplacements
	ld a, $76
	ld [wNewTileBlockID], a
	jpfar ReplaceMultipleTileBlockLineHorizontalWithOneBlock


SeafoamB4FReplaceEastCurrentBlock:
	ld a, $76
	lb bc, 8, 10
SeafoamReplaceTileBlockEntry:
	ld [wNewTileBlockID], a
	predef_jump ReplaceTileBlock

SeafoamIslandsB4F_ScriptPointers:
	def_script_pointers
	dw_const SeafoamIslandsB4FDefaultScript,       SCRIPT_SEAFOAMISLANDSB4F_DEFAULT
	dw_const SeafoamIslandsB4FObjectMoving1Script, SCRIPT_SEAFOAMISLANDSB4F_OBJECT_MOVING1
	dw_const SeafoamIslandsB4FArticunoIntroAnimation, SCRIPT_SEAFOAMISLANDSB4F_ARTICUNO_INTRO_ANIMATION
	dw_const SeafoamIslandsB4FEndArticunoBattleScript, SCRIPT_SEAFOAMISLANDSB4F_ARTICUNO_BATTLE_END
	dw_const SeafoamIslandsB4FDragonairEventStartScript, SCRIPT_SEAFOAMISLANDSB4F_DRAGONAIR_EVENT_START

SeafoamIslandsB4FResetScript:
	call EnableAllJoypad
	ld [wSeafoamIslandsB4FCurScript], a
	ret

SeafoamIslandsB4FEndArticunoBattleScript:
	ld a, [wIsInBattle]
	cp $ff ; do nothing if you lost the battle
	jr z, SeafoamIslandsB4FResetScript
	SetEvent EVENT_BEAT_ARTICUNO
	ld a, TOGGLE_ARTICUNO
	ld [wToggleableObjectIndex], a
	predef HideObject
SeafoamB4FDefaultScript:
	ld a, SCRIPT_SEAFOAMISLANDSB4F_DEFAULT
	ld [wSeafoamIslandsB4FCurScript], a
	ret

SeafoamIslandsB4FDefaultScript:
	ld a, [wXCoord]
	cp 18
	jr c, .leftSideCurrent
	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	jr nz, .doCurrents
.leftSideCurrent
	CheckBothEventsSet EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM4_BOULDER2_DOWN_HOLE
	ret z
.doCurrents
	call SeafoamIslandsCurrents ; in SeafoamIslandsB3F.asm
	ret nc
	ld a, SCRIPT_SEAFOAMISLANDSB4F_OBJECT_MOVING1
	ld [wSeafoamIslandsB4FCurScript], a
	ret

SeafoamIslandsB4FObjectMoving1Script:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call EnableAllJoypad
	ld a, [wYCoord]
	cp 12
	jr nz, SeafoamB4FDefaultScript
	ld a, [wXCoord]
	cp 7
	call z, SeafoamDoneForcedSurfMovementLeft
	jr SeafoamB4FDefaultScript

SeafoamDoneForcedSurfMovementLeft:
	xor a
	ld [wWalkBikeSurfState], a
	ld [wWalkBikeSurfStateCopy], a
	jp ForceBikeOrSurf

SeafoamIslandsB4F_TextPointers:
	def_text_pointers
	dw_const BoulderBlockingWaterB4F,              TEXT_SEAFOAMISLANDSB4F_BOULDER1
	dw_const BoulderBlockingWaterB4F,              TEXT_SEAFOAMISLANDSB4F_BOULDER2
	dw_const SeafoamIslandsB4FArticunoText,     TEXT_SEAFOAMISLANDSB4F_ARTICUNO
	dw_const PickUpItemText,                    TEXT_SEAFOAMISLANDSB4F_ITEM1 ; PureRGBnote: ADDED: new item located here.
	dw_const SeafoamIslandsB4FDragonairEventStartText, TEXT_SEAFOAMISLANDSB4F_SCUBA1 
	dw_const DoRet,                             TEXT_SEAFOAMISLANDSB4F_SCUBA2
	dw_const SeafoamIslandsB4FDragonairText,    TEXT_SEAFOAMISLANDSB4F_DRAGONAIR
	dw_const SeafoamIslandsB4FBouldersSignText, TEXT_SEAFOAMISLANDSB4F_BOULDERS_SIGN
	dw_const SeafoamIslandsB4FDangerSignText,   TEXT_SEAFOAMISLANDSB4F_DANGER_SIGN
	dw_const SeafoamIslandsB4FFastCurrentText,  TEXT_SEAFOAMISLANDSB4F_FAST_CURRENT

SeafoamIslandsB4FArticunoText:
	text_far _SeafoamIslandsB4FArticunoBattleText
	text_asm
	call StopAllMusic
	ld a, ARTICUNO
	call PlayCry
	call WaitForSoundToFinish
	ld a, SCRIPT_SEAFOAMISLANDSB4F_ARTICUNO_INTRO_ANIMATION
	ld [wSeafoamIslandsB4FCurScript], a
	rst TextScriptEnd

SeafoamIslandsB4FArticunoIntroAnimation:
	; make articuno face down then open its wings
	ld a, SEAFOAMISLANDSB4F_ARTICUNO
	call SetSpriteFacingDown
	call UpdateSprites
	; make moltres open its wings
	ld hl, vNPCSprites tile $0C
	call OpenBirdSpriteWings
	; show snowflakes flying outwards in an X pattern
	call UpdateSpritesAndDelay3
	ld de, ArticunoIcyWindSFX
	call PlayNewSoundChannel8
	; replace the "nothing" sprite with
	; an ice crystal
	ld de, IceCrystalSprite
	lb bc, BANK(IceCrystalSprite), 4
	ld hl, vNPCSprites tile $18
	call CopyVideoData
	call DisableSpriteUpdates
	call .copyCrystalTileIDs
	rst _DelayFrame
	ld c, 8
	ld d, 4
.loopSetSpriteStartingCoords
	push de
	push bc
	lb de, $3C, $48
	callfar LoadSpecificOAMSpriteCoords
	pop bc
	pop de
	ld a, c
	add 4
	ld c, a
	dec d
	jr nz, .loopSetSpriteStartingCoords
	xor a
.animationLoop
	push af
	; loop over moving them diagonally outwards at 60fps
	ld c, 63
	ld b, 0
.loop
	push bc
	; top left crystal
	ld hl, wShadowOAMSprite08YCoord
	ld d, [hl]
	inc hl
	ld e, [hl]
	dec e
	dec e
	dec d
	dec d
	ld c, 8
	callfar LoadSpecificOAMSpriteCoords

	; top right crystal
	ld hl, wShadowOAMSprite12YCoord
	ld d, [hl]
	inc hl
	ld e, [hl]
	dec d
	dec d
	inc e
	inc e
	ld c, 12
	callfar LoadSpecificOAMSpriteCoords
	; bottom left crystal
	ld hl, wShadowOAMSprite16YCoord
	ld d, [hl]
	inc hl
	ld e, [hl]
	inc d
	inc d
	dec e
	dec e
	ld c, 16
	callfar LoadSpecificOAMSpriteCoords
	; bottom right crystal
	ld hl, wShadowOAMSprite20YCoord
	ld d, [hl]
	inc hl
	ld e, [hl]
	inc d
	inc d
	inc e
	inc e
	ld c, 20
	callfar LoadSpecificOAMSpriteCoords
	rst _DelayFrame
	pop bc
	ld a, c
	; every 4 frames we make the ice crystal "sparkle"
	rrca
	jr c, .noSpriteUpdate
	rrca
	jr c, .noSpriteUpdate
	ld a, b
	xor 1
	ld b, a
	push bc
	ld de, IceCrystalSprite tile 4
	jr nz, .gotSprite
	ld de, IceCrystalSprite
.gotSprite
	lb bc, BANK(IceCrystalSprite), 4
	ld hl, vNPCSprites tile $18
	call CopyVideoData
	pop bc
.noSpriteUpdate
	dec c
	jr nz, .loop
	pop af
	and a
	jr nz, .doneAnimation
	callfar AnimationLightScreenPalette
	ld de, ArticunoIcyWindSFX2
	call PlayNewSoundChannel8
	ld a, 1
	jp .animationLoop
.doneAnimation
	; replace ice crystal sprite with nothing again
	ld de, NothingSprite
	lb bc, BANK(NothingSprite), 4
	ld hl, vNPCSprites tile $18
	call CopyVideoData
	; show everything freezing 
	call GBFadeOutToWhite
	; turn off the water visual animation
	xor a
	ldh [hTileAnimations], a
	; replace water tiles with "frozen water"
	ld de, FrozenWaterTile
	lb bc, BANK(FrozenWaterTile), 1
	ld hl, vTileset tile $14
	call CopyVideoData
	; replace rock tiles with ice crystals
	ld de, IceCrystal
	lb bc, BANK(IceCrystal), 2
	ld hl, vTileset tile $02
	call CopyVideoData
	ld de, IceCrystal tile 2
	lb bc, BANK(IceCrystal), 2
	ld hl, vTileset tile $12
	call CopyVideoData
	call GBPalNormal
	ld de, ArticunoFreezesEverythingCh5
	call PlayNewSoundChannel5
	ld de, ArticunoFreezesEverythingCh8
	call PlayNewSoundChannel8
	ld c, 60
	rst _DelayFrames
	call EnableSpriteUpdates
	; articuno shows an animation when you fight it now
	ld a, ARTICUNO
	ld [wEngagedTrainerClass], a
	ld a, 50
	ld [wEngagedTrainerSet], a
	call InitBattleEnemyParameters
	callfar PlayDefaultTrainerMusic
	ld c, 100
	rst _DelayFrames
	ld a, SCRIPT_SEAFOAMISLANDSB4F_ARTICUNO_BATTLE_END
	ld [wSeafoamIslandsB4FCurScript], a
	ret
.copyCrystalTileIDs
	ld hl, wShadowOAMSprite08TileID
	ld e, 4
	ld bc, 4
.copyOAMTileIDsOuter
	ld a, $18
	ld d, 4
.copyOAMTileIDs
	ld [hl], a
	add hl, bc
	inc a
	dec d
	jr nz, .copyOAMTileIDs
	dec e
	jr nz, .copyOAMTileIDsOuter
	ret


SeafoamIslandsB4FBouldersSignText:
	text_far _SeafoamIslandsB4FBouldersSignText
	text_end

SeafoamIslandsB4FDangerSignText:
	text_far _SeafoamIslandsB4FDangerSignText
	text_end

BoulderBlockingWaterB4F:
	text_far _BoulderBlockingCurrent
	text_end

FarOpenBirdSpriteWings::
	ld h, d
	ld l, e
; input hl = where in vram to replace it
OpenBirdSpriteWings:
	ld a, [wSpriteOptions2]
	bit BIT_MENU_ICON_SPRITES, a
	ld de, LegendaryBirdSprite tile 12
	lb bc, BANK(LegendaryBirdSprite), 4
	jr nz, .gotSprite
	ld de, BirdSprite tile 12
	lb bc, BANK(BirdSprite), 4
.gotSprite
	jp CopyVideoData

SeafoamIslandsB4FDragonairEventOnMapLoad:
	; replace nothing sprite with scuba sprite
	ld de, ScubaSuitSprite
	lb bc, BANK(ScubaSuitSprite), 4
	ld hl, vNPCSprites tile $18
	call CopyVideoData
	; make player face down
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, 1 << PLAYER_DIR_BIT_DOWN
	ld [wPlayerDirection], a
	; move 2 of the nothing sprites near player to be sara and erik
	lb de, -1, -1
	ld c, SEAFOAMISLANDSB4F_SCUBA1
	callfar FarMoveSpriteInRelationToPlayer
	lb de, 1, -1
	ld c, SEAFOAMISLANDSB4F_SCUBA2
	callfar FarMoveSpriteInRelationToPlayer
	jp UpdateSprites

SeafoamIslandsB4FDragonairEventStartScript:
	ld a, [wStatusFlags5] ; is the player moving?
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	bit BIT_SCRIPTED_MOVEMENT_STATE, a
	ret nz
	ld a, [wYCoord]
	cp 5
	jr z, .initialText
	call EnableAllJoypad
	ld c, 60
	rst _DelayFrames
	; play a splash sound
	ld a, SFX_INTRO_RAISE
	rst _PlaySound
	; diving animation
	ld de, GhostSprite tile 4
	lb bc, BANK(GhostSprite), 4
	call .copyPlayerSprite
	ld de, GhostSprite tile 8
	lb bc, BANK(GhostSprite), 4
	call .copyPlayerSprite
	ld de, NothingSprite
	lb bc, BANK(NothingSprite), 4
	call .copyPlayerSprite
	ld c, 60
	rst _DelayFrames
  	; load scripted warp to seafoam islands 1f
  	ld a, 7 ; 8th warp
	ld [wDestinationWarpID], a
	ld a, SEAFOAM_ISLANDS_1F
	ldh [hWarpDestinationMap], a
	ld hl, wStatusFlags3
	set BIT_WARP_FROM_CUR_SCRIPT, [hl] ; scripted warp flag
	
	ld a, SCRIPT_SEAFOAMISLANDSB4F_DEFAULT
	ld [wSeafoamIslandsB4FCurScript], a
	ret
.copyPlayerSprite
	ld hl, vNPCSprites
	call CopyVideoData
	jp Delay3
.initialText
	call GBFadeInFromBlack
	ld a, TEXT_SEAFOAMISLANDSB4F_SCUBA1
	ldh [hTextID], a
	call DisplayTextID
	; add more "downs" to the surf auto movement
	ld a, PAD_DOWN
	ld hl, wSimulatedJoypadStatesEnd + 1
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, 5
	ld [wSimulatedJoypadStatesIndex], a
	ret

SeafoamIslandsB4FDragonairEventStartText:
	text_asm
	CheckEvent EVENT_DRAGONAIR_EVENT_CLEARED_ONCE
	jr nz, .skipFirstText
	ld hl, .initialText
	rst _PrintText
.skipFirstText 
	ld hl, .initialText2
	rst _PrintText
	ld a, SFX_INTRO_WHOOSH
	rst _PlaySound
	callfar PlayerQuickSpin
	ld de, ScubaSuitSprite
	lb bc, BANK(ScubaSuitSprite), 4
	ld hl, vNPCSprites
	call CopyVideoData
	ld a, SFX_TRADE_MACHINE
	rst _PlaySound
	ld c, 60
	rst _DelayFrames
	ld a, $14 ; water tile
	ld [wTileInFrontOfPlayer], a ; this isn't loaded correctly sometimes, just force it because we're facing water for sure
	ld a, SURFBOARD
	ld [wCurItem], a
	ld [wPseudoItemID], a
	call UseItem
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	rst TextScriptEnd
.initialText
	text_far _SeafoamIslandsB4FDragonairEventStartText
	text_end
.initialText2
	text_far _SeafoamIslandsB4FDragonairEventStartText2
	text_end

SeafoamIslandsB4FFastCurrent::
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_DOWN
	ret nz
	CheckBothEventsSet EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM4_BOULDER2_DOWN_HOLE
	ret z
	ld a, TEXT_SEAFOAMISLANDSB4F_FAST_CURRENT
	ldh [hTextID], a
	jp DisplayTextID

SeafoamIslandsB4FFastCurrentText::
	text_far _CurrentTooFastText2
	text_end

SeafoamWaveSFXB4F::
	ld hl, wAudioFlags
	bit BIT_WAITING_FOR_SOUND_TO_FINISH, [hl]
	ret nz ; don't play the sound if we're waiting for sounds to finish currently or it'll wait forever
	ld hl, wOverworldAnimationCounter
	inc [hl]
.notAllDone
	ld a, [wOverworldAnimationCounter]
	and %11
	ret nz ; every 2 iterations the below code will run
	CheckBothEventsSet EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM4_BOULDER2_DOWN_HOLE
	lb bc, 2, 7
	lb de, 14, 17
	jr z, .blockedTide
	lb bc, 4, 11
	lb de, 10, 15
.blockedTide
	predef ArePlayerCoordsInRangePredef
	dec d
	jr z, .closeSound
.next1
	lb bc, 18, 23
	lb de, 13, 17
	predef ArePlayerCoordsInRangePredef
	dec d
	jr nz, .further
.closeSound
	ld de, CurrentSoundLoud
	jp PlayNewSoundChannel8
.further
	CheckBothEventsSet EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM4_BOULDER2_DOWN_HOLE
	lb bc, 2, 7
	lb de, 12, 17
	jr z, .blockedTide2
	lb bc, 1, 16
	lb de, 8, 17
.blockedTide2
	predef ArePlayerCoordsInRangePredef
	dec d
	jr z, .farSound	
.next2
	lb bc, 15, 26
	lb de, 11, 17
	predef ArePlayerCoordsInRangePredef
	dec d
	ret nz
.farSound
	ld de, CurrentSoundQuiet
	jp PlayNewSoundChannel8

SeafoamIslandsB4FDragonairText::
	text_far _SeafoamIslandsB4FDragonairText
	text_asm
	ld c, DEX_DRAGONAIR - 1
  	callfar SetMonSeen
	ld a, DRAGONAIR
	call PlayCry
	call DisplayTextPromptButton
	ld hl, .couldItBeInvestigating
	rst _PrintText
	rst TextScriptEnd
.couldItBeInvestigating
	text_far _SeafoamIslandsB4FDragonairText2
	text_end
