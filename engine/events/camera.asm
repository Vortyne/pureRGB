DEF NUM_CAMERA_PIC_PALETTES EQU 3
DEF CAMERA_PIC_TILE_COUNT EQU 48

INCLUDE "data/events/camera_pics.asm"

UseCameraItem:: 
	CheckEvent FLAG_BALL_DESIGNER_TURNED_OFF
	ld hl, .cantUseItem
	jr nz, .printDone
	ld a, [wWalkBikeSurfState]
	cp SURFING
	ld hl, .photoWhileSurfing
	jr z, .printDone
	ld a, [wCurMap]
	ld hl, CameraEventMaps
	ld de, 3
	call IsInArray
	jr nc, .noMap ; not in list
	inc hl
	hl_deref
	call hl_caller
	jr c, .noMap
	ld hl, .photoOpText
	jr z, .printDone
	ld hl, .perfect
	rst _PrintText
	call PauseMusic
	ld a, SFX_POKEDEX_RATING
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	call ResumeMusic
	ld hl, .perfectBallDesigner
	rst _PrintText
	jp ReloadAfterCameraPic
.noMap
	ld hl, .nothingToPhoto
	rst _PrintText
	ld hl, wCustomBallPhotoSnappedFlags
	ld b, 2
	call CountSetBits
	ld a, c
	push af
	ld hl, wCustomBallUnlockFlags
	ld b, 2
	call CountSetBits
	pop af
	sub c
	ret z
	ret c
	ld [w2CharStringBuffer], a
	ld hl, .photosToTurnIn
.printDone
	rst _PrintText
	ret
.perfect
	text_far _PerfectPhotoText
	text_end
.perfectBallDesigner
	text_far _PerfectPhotoBallDesignerText
	text_end
.nothingToPhoto
	text_far _NoPhotosText
	text_end
.photoOpText
	text_far _PhotoOpText
	text_end
.photoWhileSurfing
	text_far _UseCameraSurfing
	text_end
.photosToTurnIn
	text_far _PhotosToTurnIn
	text_end
.cantUseItem
	text_far _CameraDisabled
	text_end

CameraEventMaps:
	dbw ROUTE_2, UseCameraRoute2
	dbw ROUTE_5, UseCameraRoute5
	dbw ROUTE_6, UseCameraRoute6
	dbw ROUTE_8, UseCameraRoute8
	dbw ROUTE_10, UseCameraRoute10
	dbw ROUTE_11, UseCameraRoute11
	dbw ROUTE_12, UseCameraRoute12
	dbw ROUTE_13, UseCameraRoute13
	dbw ROUTE_16, UseCameraRoute16
	dbw ROUTE_24, UseCameraRoute24
	dbw LAVENDER_TOWN, UseCameraLavenderTown
	dbw CELADON_MANSION_2F, UseCameraCeladonMansion2F
	dbw SAFFRON_PIDGEY_HOUSE, UseCameraSaffronPidgeyHouse
	dbw FUCHSIA_BILLS_GRANDPAS_HOUSE, UseCameraFuchsiaBillsGrandpasHouse
	dbw CINNABAR_LAB_FOSSIL_ROOM, UseCameraCinnabarLabFossilRoom
	dbw MUSEUM_1F, UseCameraMuseum1F
	dbw SEAFOAM_ISLANDS_B4F, UseCameraSeafoamIslandsB4F
	dbw UNDERGROUND_PATH_WEST_EAST, UseCameraUndergroundPathWestEast
	db -1

UseCameraRoute2:
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_CUTE_BALL
	scf
	ret nz
	lb bc, 16, 16
	lb de, 2, 2
	predef ArePlayerCoordsInRangePredef
	ld a, d
	and a
	ret z
	push af
	SetEvent EVENT_SNAPPED_CAMERA_PIC_CUTE_BALL
	ld hl, MakePlayerHoldCamera
	rst _PrintText
	ld hl, .defaultJigText
	rst _PrintText
	call PlayAlternateJigglypuffSong
	call DisplayTextPromptButton
	ld hl, .useCameraRoute2
	rst _PrintText
	; jigglypuff guaranteed seen when you get to this event
	SetEvent FLAG_PLAYER_TAKING_PICTURE_UPWARDS
	ld d, BALL_ID_CUTE
	call PlayerSnapsPicThenDisplayPicture
	ld hl, .jigglypuffPeaceful
	rst _PrintText
	pop af
	ret
.defaultJigText
	text_far _Route2JigglypuffText
	text_end
.useCameraRoute2
	text_far _Route2JigglypuffCameraText
	text_end
.jigglypuffPeaceful
	text_far _Route2JigglypuffPeacefulText
	text_end

UseCameraRoute5:
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_FOREST_BALL
	scf
	ret nz
	lb bc, 6, 8
	lb de, 8, 10
	predef ArePlayerCoordsInRangePredef
	ld a, d
	and a
	ret z
	push af
	SetEvent EVENT_SNAPPED_CAMERA_PIC_FOREST_BALL
	ld d, ROUTE5_BUG_CATCHER
	call MakeSpriteFacePlayer
	ld hl, MakePlayerHoldCamera
	rst _PrintText
	ld hl, .useCameraRoute5
	rst _PrintText
	; bulbasaur guaranteed seen by the time you reach this event so no need to mark it
	ld a, [wYCoord]
	cp 10
	jr nz, .notUpward
	SetEvent FLAG_PLAYER_TAKING_PICTURE_UPWARDS
.notUpward
	ld d, BALL_ID_FOREST
	call PlayerSnapsPicThenDisplayPicture
	ld a, BULBASAUR
	call PlayCry
	ld hl, .bulbasaurCurious
	rst _PrintText
	pop af
	ret
.useCameraRoute5
	text_far _Route5BugCatcherCameraText
	text_end
.bulbasaurCurious
	text_far _Route5BugCatcherBulbasaurText
	text_end

UseCameraRoute6:
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_DRENCH_BALL
	scf
	ret nz
	lb bc, 0, 3
	lb de, 28, 28
	predef ArePlayerCoordsInRangePredef
	ld a, d
	and a
	ret z
	push af
	SetEvent EVENT_SNAPPED_CAMERA_PIC_DRENCH_BALL
	call .getPsyduckMapX
	ld [hl], 2 + 4
	call UpdateSprites
	ld hl, MakePlayerHoldCamera
	rst _PrintText
	ld hl, .useCameraRoute6
	rst _PrintText
	ld c, 60
	rst _DelayFrames
	call DisableSpriteUpdates
	; move the shadow sprite to the bank of the pond
	ld hl, wShadowOAMSprite04YCoord
	ld d, [hl]
	inc hl
	ld e, [hl]
	ld c, 28
.loopMoveSprite
	dec e
	ld hl, wShadowOAMSprite04YCoord
	call LoadBallOAMCoords
	rst _DelayFrame
	rst _DelayFrame
	dec c
	jr nz, .loopMoveSprite
	; show psyduck coming out of the water
	; copy psyduck sprite onto shadow
	call .faceSide
	ld a, SFX_LEDGE
	rst _PlaySound
	; raise the sprite a bit
	ld hl, wShadowOAMSprite04YCoord
	ld a, [hl]
	sub 8
	ld [hli], a
	ld d, a
	ld e, [hl]
	ld hl, wShadowOAMSprite04XCoord
	; drop it back down while moving left
	ld c, 12
.loopMoveSprite2
	inc d
	dec e
	ld hl, wShadowOAMSprite04YCoord
	call LoadBallOAMCoords
	rst _DelayFrame
	dec c
	jr nz, .loopMoveSprite2
	ld c, 10
	rst _DelayFrames
	; make it face down
	call .faceDown
	ld c, 60
	rst _DelayFrames
	ld a, PSYDUCK
	call PlayCry
	ld hl, .psyduckAppeared
	rst _PrintText
	; make it look up and down 2 times
	ld c, 2
.loopUpDown
	push bc
	call .faceUp
	ld c, 20
	rst _DelayFrames
	call .faceDown
	ld c, 20
	rst _DelayFrames
	pop bc
	dec c
	jr nz, .loopUpDown
	ld c, 40
	rst _DelayFrames
	; make it look to the right
	call .faceSide
	ld de, wShadowOAMSprite04
	callfar FlipSpriteOAM
	ld c, 60
	rst _DelayFrames
	; put an exclamation mark above player's head
	call ExclamationDuringCameraEvent
	ld c, DEX_PSYDUCK - 1
  	call SetMonSeen
	SetEvent FLAG_PLAYER_TAKING_PICTURE_UPWARDS
	ld d, BALL_ID_DRENCH
	call PlayerSnapsPicThenDisplayPicture
	ld hl, .psyduckLooking
	rst _PrintText
	call .getPsyduckMapX
	ld [hl], 26 + 4
	pop af
	ret
.useCameraRoute6
	text_far _Route6CameraText
	text_end
.psyduckAppeared
	text_far _Route6PsyduckText
	text_end
.psyduckLooking
	text_far _Route6Psyduck2Text
	text_end
.faceSide
	ld a, [wSpriteOptions2]
	bit BIT_MENU_ICON_SPRITES, a
	ld de, Monster2Sprite tile 8
	lb bc, BANK(Monster2Sprite), 4
	jr nz, .copy
	ld de, MonsterSprite tile 8
	lb bc, BANK(MonsterSprite), 4
	jr .copy
.faceUp
	ld a, [wSpriteOptions2]
	bit BIT_MENU_ICON_SPRITES, a
	ld de, Monster2Sprite tile 4
	lb bc, BANK(Monster2Sprite), 4
	jr nz, .copy
	ld de, MonsterSprite tile 4
	lb bc, BANK(MonsterSprite), 4
	jr .copy
.faceDown
	; make the sprite face down
	ld a, [wSpriteOptions2]
	bit BIT_MENU_ICON_SPRITES, a
	ld de, Monster2Sprite
	lb bc, BANK(Monster2Sprite), 4
	jr nz, .copy
	ld de, MonsterSprite
	lb bc, BANK(MonsterSprite), 4
.copy
	ld hl, vNPCSprites tile $7C
	jp CopyVideoData
.getPsyduckMapX
	ld a, ROUTE6_PSYDUCK_SHADOW
	ldh [hSpriteIndex], a
	ld a, SPRITESTATEDATA2_MAPX
	ldh [hSpriteDataOffset], a
	jp GetPointerWithinSpriteStateData2

UseCameraRoute8:
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_BOLT_BALL
	jr z, .stillEvents
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_ANGEL_BALL
	jr z, .stillEvents
	scf
	ret
.stillEvents
	; range of jolteon event
	lb bc, 1, 1
	lb de, 8, 8
	predef ArePlayerCoordsInRangePredef
	ld a, d
	and a
	jr z, .checkLassEvent
	push af
	SetEvent EVENT_SNAPPED_CAMERA_PIC_BOLT_BALL
	ld hl, MakePlayerHoldCamera
	rst _PrintText
	ld hl, .useCameraRoute8
	rst _PrintText
	call CatSpriteFrame2
	ld c, 60
	rst _DelayFrames
	; make jolteon "absorb electricity"
	; darken color palette	
	ld a, 3
	ld [wMapPalOffset], a
	call LoadGBPal
	; sphere tile from battle animations
	ld de, MoveAnimationTiles0 tile 73
	ld hl, vNPCSprites tile $C4
	lb bc, BANK(MoveAnimationTiles0), 1
	call CopyVideoData

	ld b, BANK(SFX_Battle_25)
	call ResetModifiersMuteAudioAndChangeAudioBank
	ld a, SFX_BATTLE_25
	rst _PlaySound
	callfar JolteonTilePowerUpLoop
	call WaitForSoundToFinish
	call UnmuteAudioAndRestoreAudioBank
	; normal color palette
	xor a
	ld [wMapPalOffset], a
	call LoadGBPal
	call WaitForSoundToFinish
	call ExclamationDuringCameraEvent
	ld c, DEX_JOLTEON - 1
  	call SetMonSeen
	ld d, BALL_ID_BOLT
	call PlayerSnapsPicThenDisplayPicture
	ld a, JOLTEON
	call PlayCry
	ld hl, .joltronAbsorbing
	rst _PrintText
	call CatSpriteNormal
	pop af
	ret
.useCameraRoute8
	text_far _Route8JolteonCameraText
	text_end
.joltronAbsorbing
	text_far _Route8JolteonCameraAbsorbingText
	text_end
.checkLassEvent
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_ANGEL_BALL
	scf
	ret nz
	; is the player beside the clefairy girl?
	ld c, ROUTE8_COOLTRAINER_F4
	call IsPlayerBesideMapSprite
	ret z
	push af
	SetEvent EVENT_SNAPPED_CAMERA_PIC_ANGEL_BALL
	ld d, ROUTE8_COOLTRAINER_F4
	call MakeSpriteFacePlayer
	ld hl, MakePlayerHoldCamera
	rst _PrintText
	ld hl, .useCameraLass
	rst _PrintText
	ld c, DEX_CLEFAIRY - 1
  	call SetMonSeen
	ld a, [wYCoord]
	cp 13
	jr nz, .notUpward
	SetEvent FLAG_PLAYER_TAKING_PICTURE_UPWARDS
.notUpward
	ld d, BALL_ID_ANGEL
	call PlayerSnapsPicThenDisplayPicture
	ld c, BANK(Music_MeetFemaleTrainer)
	ld a, MUSIC_MEET_FEMALE_TRAINER
	call PlayMusic
	ld hl, .lovely
	rst _PrintText
	pop af
	ret
.useCameraLass
	text_far _LassCameraText
	text_end
.lovely
	text_far _LassCuteText
	text_end


UseCameraRoute10:
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_BLAZE_BALL
	scf
	ret nz
	lb bc, 17, 17
	lb de, 52, 52
	predef ArePlayerCoordsInRangePredef
	ld a, d
	and a
	ret z
	push af
	SetEvent EVENT_SNAPPED_CAMERA_PIC_BLAZE_BALL
	ld hl, MakePlayerHoldCamera
	rst _PrintText
	ld hl, .useCameraRoute10
	rst _PrintText
	call CatSpriteFrame2
	ld c, 40
	rst _DelayFrames
	call ExclamationDuringCameraEvent
	ld hl, .flareonGreatPose
	rst _PrintText
	ld c, DEX_FLAREON - 1
  	call SetMonSeen
	ld d, BALL_ID_BLAZE
	call PlayerSnapsPicThenDisplayPicture
	call CatSpriteNormal
	ld a, FLAREON
	call PlayCry
	ld hl, .flareonMajestic
	rst _PrintText
	pop af
	ret
.useCameraRoute10
	text_far _Route10FlareonCameraText
	text_end
.flareonMajestic
	text_far _Route10FlareonMajesticText
	text_end
.flareonGreatPose
	text_far _Route10FlareonPoseText
	text_end

CatSpriteFrame2:
	ld a, [wSpriteOptions2]
	bit BIT_MENU_ICON_SPRITES, a
	ld de, CatSprite tile 12
	lb bc, BANK(CatSprite), 4
	ld hl, vNPCSprites tile $48
	jr nz, .copy
	ld de, QuadrupedSprite tile 4
	lb bc, BANK(QuadrupedSprite), 4
	ld hl, vNPCSprites tile $7C
.copy
	jp CopyVideoData

CatSpriteNormal:
	ld a, [wSpriteOptions2]
	bit BIT_MENU_ICON_SPRITES, a
	ld de, CatSprite
	lb bc, BANK(CatSprite), 4
	ld hl, vNPCSprites tile $48
	jr nz, .copy2
	ld de, QuadrupedSprite 
	lb bc, BANK(QuadrupedSprite), 4
	ld hl, vNPCSprites tile $7C
.copy2
	jp CopyVideoData

UseCameraRoute24:
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_MIND_BALL
	scf
	ret nz
	lb bc, 4, 5
	lb de, 4, 4
	predef ArePlayerCoordsInRangePredef
	ld a, d
	and a
	ret z
	push af
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	SetEvent EVENT_SNAPPED_CAMERA_PIC_MIND_BALL
	ld hl, .fakeNothing
	rst _PrintText
	ld c, 40
	rst _DelayFrames
	ld a, SFX_TELEPORT_EXIT_1
	rst _PlaySound
	lb de, 0, -2
	ld c, ROUTE24_ABRA
	callfar FarMoveSpriteInRelationToPlayer
	call UpdateSpritesAndDelay3
	call DisableSpriteUpdates
	ld a, [wXCoord]
	cp 4
	ld hl, wShadowOAMSprite04YCoord
	jr z, .gotSprite
	ld hl, wShadowOAMSprite08YCoord
.gotSprite
	inc [hl]
	inc [hl]
	inc [hl]
	inc hl
	ld d, h
	ld e, l
	call TeleportInSprite
	ld c, 30
	rst _DelayFrames
	ld hl, MakePlayerHoldCamera
	rst _PrintText
	; abra guaranteed to be seen by this event
	ld hl, .useCameraAbra
	rst _PrintText
	SetEvent FLAG_PLAYER_TAKING_PICTURE_UPWARDS
	ld d, BALL_ID_MIND
	call PlayerSnapsPicThenDisplayPicture
	ld hl, .snoozing
	rst _PrintText
	pop af
	ret
.fakeNothing
	text_far _AbraCameraEventFakeNothing
	text_end
.useCameraAbra
	text_far _AbraCameraEventSleep
	text_end
.snoozing
	text_far _AbraCameraEventSnoozing
	text_end


UseCameraCeladonMansion2F:
	ld a, [wYCoord]
	cp 12
	jr nc, PorygonCameraEvent.setc
	lb de, 6, 6
	jr PorygonCameraEventLeft

UseCameraFuchsiaBillsGrandpasHouse:
UseCameraSaffronPidgeyHouse:
	lb bc, 3, 3
	lb de, 2, 2
	jr PorygonCameraEvent
	
UseCameraCinnabarLabFossilRoom:
	lb de, 5, 5
PorygonCameraEventLeft:
	lb bc, 0, 1
PorygonCameraEvent:
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_TRI_BALL
	jr nz, .setc
	predef ArePlayerCoordsInRangePredef
	ld a, d
	and a
	ret z
	push af
	SetEvent EVENT_SNAPPED_CAMERA_PIC_TRI_BALL
	ld hl, MakePlayerHoldCamera
	rst _PrintText
	ld hl, .useCameraPorygon
	rst _PrintText
	ld c, DEX_PORYGON - 1
  	call SetMonSeen
	SetEvent FLAG_PLAYER_TAKING_PICTURE_UPWARDS
	ld d, BALL_ID_TRI
	call PlayerSnapsPicThenDisplayPicture
	ld hl, .porygonVirtualWorld
	rst _PrintText
	pop af
	ret
.setc
	scf
	ret
.useCameraPorygon
	text_far _PorygonCameraText
	text_end
.porygonVirtualWorld
	text_far _PorygonVirtualWorldText
	text_end

UseCameraMuseum1F:
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_BOULDER_BALL
	scf
	ret nz
	lb bc, 0, 5
	lb de, 1, 7
	predef ArePlayerCoordsInRangePredef
	ld a, d
	and a
	ret z
	push af
	SetEvent EVENT_SNAPPED_CAMERA_PIC_BOULDER_BALL
	ld hl, MakePlayerHoldCamera
	rst _PrintText
	ld hl, .useCameraFossil
	rst _PrintText
	ld a, [wYCoord]
	cp 7
	jr nz, .notUpward
	SetEvent FLAG_PLAYER_TAKING_PICTURE_UPWARDS
.notUpward
	ld d, BALL_ID_BOULDER
	call PlayerSnapsPicThenDisplayPicture
	ld hl, .mysteriousFossils
	rst _PrintText
	pop af
	ret
.useCameraFossil
	text_far _FossilCameraText
	text_end
.mysteriousFossils
	text_far _MysteriousFossilsText
	text_end

UseCameraSeafoamIslandsB4F:
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_SUBZERO_BALL
	scf
	ret nz
	CheckEvent EVENT_BEAT_ARTICUNO
	lb bc, 6, 8
	lb de, 0, 2
	jr z, .articunoEvent
	CheckEvent EVENT_SEAFOAM_DRAGONAIR_PRESENT
	scf
	ret z
	lb bc, 7, 7
	lb de, 6, 9
.articunoEvent
	predef ArePlayerCoordsInRangePredef
	ld a, d
	and a
	ret z
	push af
	SetEvent EVENT_SNAPPED_CAMERA_PIC_SUBZERO_BALL
	ld hl, MakePlayerHoldCamera
	rst _PrintText
	ld hl, .useCameraArticunoDragonair
	rst _PrintText
	ld a, [wYCoord]
	cp 2
	jr nz, .notUpward
	SetEvent FLAG_PLAYER_TAKING_PICTURE_UPWARDS
.notUpward
	CheckEvent EVENT_BEAT_ARTICUNO
	ld d, BALL_ID_SUBZERO
	jr z, .articunoEvent2
	ld c, DEX_DRAGONAIR - 1
  	call SetMonSeen
	SetEvent EVENT_SNAPPED_PIC_OF_DRAGONAIR
	ld d, 16 ; dragonair pic
.articunoEvent2
	call PlayerSnapsPicThenDisplayPicture
	ld hl, .articunoDragonairAurora
	rst _PrintText
	pop af
	ret
.useCameraArticunoDragonair
	text_far _UseCameraArticunoDragonair
	text_end
.articunoDragonairAurora
	text_far _UseCameraArticunoDragonairAurora
	text_end

UseCameraRoute13:
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_TORNADO_BALL
	scf
	ret nz
	lb bc, 6, 6
	lb de, 4, 4
	predef ArePlayerCoordsInRangePredef
	ld a, d
	and a
	ret z
	push af
	SetEvent EVENT_SNAPPED_CAMERA_PIC_TORNADO_BALL
	ld hl, MakePlayerHoldCamera
	rst _PrintText
	ld hl, .useCameraPidgeot
	rst _PrintText
	ld c, 30
	rst _DelayFrames
	ld a, SFX_FLY
	rst _PlaySound
	; show pidgeot taking off
	ld hl, wShadowOAMSprite04YCoord
	lb de, $1C, $48
	ld c, 32
	ld b, 1
.loopMoveUp
	dec d
	ld a, c
	and %11
	jr nz, .skipDecX
	dec e
.skipDecX
	push hl
	call LoadBallOAMCoords
	ld a, c
	and %11
	jr nz, .skipFlap
	ld a, b
	xor 1
	ld b, a
	push de
	push bc
	and a
	jr z, .secondFrame
	call .loadPidgeotLeftWingsOpen
	jr .nexto
.secondFrame
	call .loadPidgeotLeft
.nexto
	pop bc
	pop de
.skipFlap
	rst _DelayFrame
	pop hl
	dec c
	jr nz, .loopMoveUp
	ld c, 60
	rst _DelayFrames
	ld b, BANK(SFX_Battle_13)
	call ResetModifiersMuteAudioAndChangeAudioBank
	ld a, SFX_BATTLE_13
	rst _PlaySound
	; make it fly across the screen left to right
	ld hl, wShadowOAMSprite04YCoord
	lb de, $1C, 160
	call LoadBallOAMCoords
	rst _DelayFrame
	ld c, 42
.loopFlyAcross
	dec e
	dec e
	dec e
	dec e
	ld a, c
	cp 21
	jr c, .checkGoUp
.checkGoDown
	and %11
	jr nz, .skipYChange
	inc d
	inc d
	inc d
	jr .skipYChange
.checkGoUp
	and %11
	jr nz, .skipYChange
	dec d
	dec d
	dec d
.skipYChange
	ld hl, wShadowOAMSprite04YCoord
	call LoadBallOAMCoords
	rst _DelayFrame
	dec c
	jr nz, .loopFlyAcross
	call WaitForSoundToFinish
	call UnmuteAudioAndRestoreAudioBank
	ld c, DEX_PIDGEOT - 1
  	call SetMonSeen
	SetEvent FLAG_PLAYER_TAKING_PICTURE_UPWARDS
	ld d, BALL_ID_TORNADO
	call PlayerSnapsPicThenDisplayPicture
	ld a, PIDGEOT
	call PlayCry
	ld hl, .magnificent
	rst _PrintText
	call .loadPidgeotLeft
	lb bc, SPRITESTATEDATA2_MAPX, ROUTE13_PIDGEOT
	call GetFromSpriteStateData2
	ld [hl], 65 + 4
	pop af
	ret
.useCameraPidgeot
	text_far _UseCameraPidgeotText
	text_end
.magnificent
	text_far _PidgeotPlumageText
	text_end
.loadPidgeotLeft
	ld de, BirdSprite tile 8
	jr .loadPidgeotNext
.loadPidgeotLeftWingsOpen
	ld de, BirdSprite tile 20
.loadPidgeotNext
	lb bc, BANK(BirdSprite), 4
	ld hl, vNPCSprites tile $74
	jp CopyVideoData

UseCameraUndergroundPathWestEast:
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_VENOM_BALL
	scf
	ret nz
	lb bc, 12, 13
	lb de, 2, 3
	predef ArePlayerCoordsInRangePredef
	ld a, d
	and a
	jr z, .continue
	; standing on the sewer grate
	ld hl, .standingOnSewerGrateText
	rst _PrintText
	xor a
	ret
.continue
	lb bc, 11, 14
	lb de, 2, 5
	predef ArePlayerCoordsInRangePredef
	ld a, d
	and a
	ret z
	push af
	SetEvent EVENT_SNAPPED_CAMERA_PIC_VENOM_BALL
	ld hl, vTileset tile $50
	ld de, GrimerPeekingSprite
	lb bc, BANK(GrimerPeekingSprite), 5
	call CopyVideoData
	call WaitForSoundToFinish
	ld a, SFX_59
	rst _PlaySound
	; find the sewer grate tile in the background tilemap
	hlcoord 0, 0
.loopFind
	ld a, [hli]
	cp $0E
	jr nz, .loopFind
	dec hl
	; make sewer grate open
	; hl = tilemap coord of sewer grate
	call .copyGrimerSewerGrateTiles
	ld c, 10
	rst _DelayFrames
	call .copyNoGrimerSewerGrateTiles
	ld c, 10
	rst _DelayFrames
	call .copyGrimerSewerGrateTiles
	ld bc, SCREEN_WIDTH
	add hl, bc
	inc hl
	call Delay3
	; make grimer blink
	ld d, 3
.loopBlink
	ld [hl], $54
	ld c, 5
	rst _DelayFrames
	ld [hl], $53
	ld c, 5
	rst _DelayFrames
	dec d
	jr nz, .loopBlink
	ld c, 30
	rst _DelayFrames
	ld a, GRIMER
	call PlayCry
	ld hl, MakePlayerHoldCamera
	rst _PrintText
	ld hl, .useCameraGrimer
	rst _PrintText
	; grimer guaranteed to be seen here
	ld a, [wYCoord]
	cp 2
	jr z, .skipLookUp
	SetEvent FLAG_PLAYER_TAKING_PICTURE_UPWARDS
.skipLookUp
	ld d, BALL_ID_VENOM
	call PlayerSnapsPicThenDisplayPicture
	ld hl, .sewerGrate
	rst _PrintText
	pop af
	ret
.standingOnSewerGrateText
	text_far _GrimerCameraStandingOnSewerGrate
	text_end
.useCameraGrimer
	text_far _GrimerCameraText
	text_end
.sewerGrate
	text_far _GrimerCrazyText
	text_end
.copyNoGrimerSewerGrateTiles
	lb de, $0E, $19
	jr .copySewerGrateTiles
.copyGrimerSewerGrateTiles
	lb de, $50, $52
.copySewerGrateTiles
	push hl
	ld [hl], d
	inc hl
	inc d
	ld [hl], d
	dec hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld [hl], e
	inc e
	inc hl
	ld [hl], e
	pop hl
	ret

UseCameraLavenderTown:
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_SPOOKY_BALL
	scf
	ret nz
	; is the player beside the little girl?
	ld c, LAVENDERTOWN_LITTLE_GIRL
	call IsPlayerBesideMapSprite
	ret z
	push af
	SetEvent EVENT_SNAPPED_CAMERA_PIC_SPOOKY_BALL
	ld d, LAVENDERTOWN_LITTLE_GIRL
	call MakeSpriteFacePlayer
	ld hl, MakePlayerHoldCamera
	rst _PrintText
	ld hl, .useCameraGastly
	rst _PrintText
	ld c, DEX_GASTLY - 1
  	call SetMonSeen
	ld d, BALL_ID_SPOOKY
	call PlayerSnapsPicThenDisplayPicture
	ld a, GASTLY
	call PlayCry
	ld hl, .yikes
	rst _PrintText
	pop af
	ret
.useCameraGastly
	text_far _GastlyCameraText
	text_end
.yikes
	text_far _GastlyYikesText
	text_end

UseCameraRoute11:
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_CLEAVE_BALL
	scf
	ret nz
	; is the player standing on a grass block?
	lb de, 2, 2 ; block coord player is standing on
	callfar GetBlockAtCoord
	ld a, d
	cp $0B ; grass block
	jr z, .continue
	xor a
	ret
.continue
	SetEvent EVENT_SNAPPED_CAMERA_PIC_CLEAVE_BALL
	ld hl, .useCameraScyther
	rst _PrintText
	ld hl, MakePlayerHoldCamera
	rst _PrintText
	; load silhoette sprite into VRAM
	ld hl, vNPCSprites tile $C4
	ld de, GhostSprite tile 4
	lb bc, BANK(GhostSprite), 4
	call CopyVideoData
	; load "leaf" into VRAM
	ld hl, vNPCSprites tile $C8
	ld de, MoveAnimationTiles1 tile 64
	lb bc, BANK(MoveAnimationTiles1), 1
	call CopyVideoData
	; load OAM with silhouette tile IDs
	ld hl, wShadowOAMSprite16TileID
	ld b, 4
	ld a, $C4
.loopLoadOAM1
	ld [hl], a
	inc a
	call GoToNextOAMEntry4
	dec b
	jr nz, .loopLoadOAM1
	; load OAM with leaf tile IDs
	ld a, $C8
	ld hl, wShadowOAMSprite20TileID
	call .loadLeafOAM4Times
	ld b, BANK(SFX_Not_Very_Effective)
	call ResetModifiersMuteAudioAndChangeAudioBank
	ld a, SFX_BATTLE_0E
	rst _PlaySound
	call WaitForSoundToFinish
	ld a, SFX_NOT_VERY_EFFECTIVE
	rst _PlaySound
	; make silhoette fly down across the screen, leaves appear around 1/3 and 2/3 of the way through
	lb de, $28, 0
	ld c, 42
.loopFlyAcross
	ld a, e
	add 4
	ld e, a
	ld hl, wShadowOAMSprite16YCoord
	call LoadBallOAMCoords
	ld a, c
	cp 24
	jr z, .initializeFirstLeaves
	jr c, .skipInitializeFirstLeaves
	jr .noLeavesYet
.initializeFirstLeaves
	ld hl, wShadowOAMSprite20YCoord
	call .initializeLeaves
.skipInitializeFirstLeaves
	ld hl, wShadowOAMSprite20YCoord
	call .leafGoesUp
	ld hl, wShadowOAMSprite21YCoord
	call .leafGoesDown
	ld a, c
	cp 12
	jr z, .initializeSecondLeaves
	jr c, .skipInitializeSecondLeaves
	jr .noLeavesYet
.initializeSecondLeaves
	ld hl, wShadowOAMSprite22YCoord
	call .initializeLeaves
.skipInitializeSecondLeaves
	ld hl, wShadowOAMSprite22YCoord
	call .leafGoesUp
	ld hl, wShadowOAMSprite23YCoord
	call .leafGoesDown
.noLeavesYet
	rst _DelayFrame
	dec c
	jr nz, .loopFlyAcross
	xor a
	ld hl, wShadowOAMSprite20YCoord
	call .loadLeafOAM4Times
	call UnmuteAudioAndRestoreAudioBank
	ld c, DEX_SCYTHER - 1
  	call SetMonSeen
	ld d, BALL_ID_CLEAVE
	call PlayerSnapsPicThenDisplayPicture
	ld a, SCYTHER
	call PlayCry
	ld hl, .cool
	rst _PrintText
	or 1
	ret
.useCameraScyther
	text_far _ScytherCameraText
	text_end
.cool
	text_far _ScytherCoolText
	text_end
.loadLeafOAM4Times
	ld b, 4
.loopLoadOAM2
	ld [hl], a
	call GoToNextOAMEntry4
	dec b
	ret z
	jr .loopLoadOAM2
.leafGoesDown
	inc [hl]
	inc [hl]
	inc [hl]
	jr .leafnext
.leafGoesUp
	dec [hl]
	dec [hl]
	dec [hl]
.leafnext
	inc hl
	dec [hl]
	dec [hl]
	dec [hl]
	ret
.initializeLeaves
	push bc
	push hl
	ld hl, wShadowOAMSprite16YCoord
	ld b, [hl]
	inc hl
	ld c, [hl]
	pop hl
	ld [hl], b
	inc hl
	ld [hl], c
	call GoToNextOAMEntry
	ld [hl], b
	inc hl
	ld [hl], c
	pop bc
	ret

UseCameraRoute16:
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_BOMB_BALL
	scf
	ret nz
	lb bc, 32, 35
	lb de, 2, 4
	predef ArePlayerCoordsInRangePredef
	ld a, d
	and a
	ret z
	push af
	SetEvent EVENT_SNAPPED_CAMERA_PIC_BOMB_BALL
	ld hl, MakePlayerHoldCamera
	rst _PrintText
	ld hl, .mankeyCameraPic
	rst _PrintText
	; mankey guaranteed seen at this point
	ld d, BALL_ID_BOMB
	call PlayerSnapsPicThenDisplayPicture
	ld hl, .angry
	rst _PrintText
	pop af
	ret
.mankeyCameraPic
	text_far _MankeyCameraText
	text_end
.angry
	text_far _MankeyScowlText
	text_end

UseCameraRoute12:
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_PRISM_BALL
	scf
	ret nz
	call IsFinalPhotoUnlocked
	ret c
	lb bc, 4, 6
	lb de, 26, 27
	predef ArePlayerCoordsInRangePredef
	ld a, d
	and a
	ret z
	CheckEvent EVENT_BEAT_ROUTE_12_TRAINER_9
	ret z
	push af
	SetEvent EVENT_SNAPPED_CAMERA_PIC_PRISM_BALL
	ld d, ROUTE12_GAMBLER
	call MakeSpriteFacePlayer
	ld hl, MakePlayerHoldCamera
	rst _PrintText
	ld hl, .gamblerCameraPic
	rst _PrintText
	ld a, SFX_WITHDRAW_DEPOSIT
	call PlaySoundWaitForCurrent
	ld a, SFX_59
	call PlaySoundWaitForCurrent
	ld c, 30
	rst _DelayFrames
	ld a, [wYCoord]
	cp 27
	jr nz, .notUpward
	SetEvent FLAG_PLAYER_TAKING_PICTURE_UPWARDS
.notUpward
	ld d, BALL_ID_PRISM
	call PlayerSnapsPicThenDisplayPicture
	ld hl, .art
	rst _PrintText
	pop af
	ret
.gamblerCameraPic
	text_far _GamblerCameraText
	text_end
.art
	text_far _GamblerArtText
	text_end

MakePlayerHoldCamera::
	text_asm
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	call UpdateSprites
	ld de, CameraSprite
	call LoadCameraSprite
	call DisableSpriteUpdates
	; to have the camera take priority over the player's sprite have to make it the earlier OAM sprite
	; so copy the player's OAM data to the last sprite in OAM
	ld hl, wShadowOAMSprite00
	ld de, wShadowOAMSprite36
	ld bc, 16
	rst _CopyData
	; now load the camera in the first slot
	lb de, 83, 71
	ld hl, wShadowOAMSprite00YCoord
	call LoadBallOAMCoords
	xor a
	ld c, 4
	ld d, $C0
	ld hl, wShadowOAMSprite00TileID
.loop
	ld [hl], d
	inc hl
	ld [hli], a
	inc hl
	inc hl
	inc d
	dec c
	jr nz, .loop
	rst TextScriptEnd

LoadCameraSprite:
	ld hl, vNPCSprites tile $C0
	lb bc, BANK(CameraSprite), 4
	jp CopyVideoData

CopyDataReverse::
; Copy bc bytes from hl to de but by decrementing instead of incrementing
	ld a, [hld]
	ld [de], a
	dec de
	dec bc
	ld a, c
	or b
	jr nz, CopyDataReverse
	ret


PlayerSnapsPicThenDisplayPicture::
	ldh a, [hSCX]
	push af
	ldh a, [hSCY]
	push af
	push de
	; first animate the player lifting the camera
	ld c, 4
	lb de, 83, 71
.loop
	ld hl, wShadowOAMSprite00YCoord
	dec d
	call LoadBallOAMCoords
	rst _DelayFrame
	rst _DelayFrame
	dec c
	jr nz, .loop
	; should player turn to face upwards?
	CheckEvent FLAG_PLAYER_TAKING_PICTURE_UPWARDS
	jr z, .noFaceUp
	; copy player OAM to the backup
	ld hl, wShadowOAMSprite36
	ld de, wBuffer
	ld bc, 16
	rst _CopyData
	; move all sprites down 1 OAM
	ld hl, wShadowOAMSprite36 - 1
	ld de, wShadowOAMEnd - 1
	ld bc, (OAM_COUNT - 1) * 4
	call CopyDataReverse
	; put player sprite in first OAM slot
	ld hl, wBuffer
	ld de, wShadowOAMSprite00
	ld bc, 16
	rst _CopyData
	; reposition camera a bit
	ld hl, wShadowOAMSprite04YCoord
	ld d, [hl]
	inc hl
	ld e, [hl]
	inc e
	dec hl
	ld a, d
	sub 6
	ld d, a
	call LoadBallOAMCoords
	; if player is in grass, make the lower two sprites of the camera in grass too
	ld a, [wShadowOAMSprite03Attributes]
	bit B_OAM_PRIO, a
	jr z, .noPriority
	ld hl, wShadowOAMSprite06Attributes
	set B_OAM_PRIO, [hl]
	ld hl, wShadowOAMSprite07Attributes
	set B_OAM_PRIO, [hl]
.noPriority
	; make camera face up by loading replacement graphics
	ld de, CameraSprite tile 4
	call LoadCameraSprite
	; make player face up by loading replacement graphics
	ld a, [wWalkBikeSurfState]
	cp BIKING
	jr nz, .gotRedSprite1
	ld de, RedBikeSprite tile 4
	call .updatePlayerSprite
	jr .gotSprite2
.gotRedSprite1
	ld de, RedTakingPictureSprite
	lb bc, BANK(RedTakingPictureSprite), 4
	call .updatePlayerSprite2
.gotSprite2	
.noFaceUp
	ld c, 30
	rst _DelayFrames
	ld b, BANK(SFX_Faint_Thud)
	call ResetModifiersMuteAudioAndChangeAudioBank
	ld a, SFX_FAINT_THUD
	rst _PlaySound
	ld hl, wChannelCommandPointers + CHAN8 * 2
	ld de, SFX_Camera_Shutter
	call RemapSoundChannel
	call GBFadeInFromWhite
	ld c, 60
	rst _DelayFrames
	call UnmuteAudioAndRestoreAudioBank
	SetEvent FLAG_SLIDING_CAMERA_PIC
	pop de
	call ShowCustomBallUnlockPicture
	ld a, SFX_TELEPORT_ENTER_1
	rst _PlaySound
	ld hl, rLCDC
	set B_LCDC_BG_MAP, [hl]
	res B_LCDC_WINDOW, [hl]
	; animate it sliding down
.loop2
	ld a, [hSCY]
	dec a
	dec a
	ldh [hSCY], a
	ld b, a
	rst _DelayFrame
	dec b
	inc b
	jr nz, .loop2
	ld hl, rLCDC
	set B_LCDC_WINDOW, [hl]
	rst _DelayFrame
	ld hl, rLCDC
	res B_LCDC_BG_MAP, [hl]
	CheckAndResetEvent FLAG_PLAYER_TAKING_PICTURE_UPWARDS
	jr z, .noPlayerReload
	; reload player sprite with down facing graphics
	ld a, [wWalkBikeSurfState]
	cp BIKING
	ld de, RedSprite
	jr nz, .gotRedSprite2
	ld de, RedBikeSprite
.gotRedSprite2
	call .updatePlayerSprite
.noPlayerReload
	pop af
	ldh [hSCY], a
	pop af
	ldh [hSCX], a
	ret
.updatePlayerSprite
	lb bc, BANK(RedSprite), 4
.updatePlayerSprite2
	ld hl, vNPCSprites
	jp CopyVideoData

LoadScreenSquareTiles:
.outerLoop
	push hl
	push bc
.line
	ld [hl], d
	inc hl
	inc d
	dec b
	jr nz, .line
	pop bc
	pop hl
	push de
	ld de, SCREEN_WIDTH
	add hl, de
	pop de
	dec c
	jr nz, .outerLoop
	ret

LoadBGMapSquareData:
.outerLoop
	push hl
	push bc
.line
	ld [hl], d
	inc hl
	and a
	jr z, .noInc
	inc d
.noInc
	dec b
	jr nz, .line
	pop bc
	pop hl
	push de
	ld de, TILEMAP_WIDTH
	add hl, de
	pop de
	dec c
	jr nz, .outerLoop
	ret

ShowCustomBallUnlockPicture::
	ld a, d
	push af
	ld hl, CustomPokeballCameraPics
	ld bc, 48 tiles
	call AddNTimes
	ld d, h
	ld e, l
	pop af
	ld hl, CustomPokeballCameraPicPalettes
	ld bc, CUSTOM_BALL_PALETTE_DATA_LENGTH
	call AddNTimes
	; hl = palette data 
	; de = picture data
	ld a, BANK(CustomPokeballCameraPics)
ShowCameraPicture::
	push hl
	push de
	push af
	call GBFadeOutToWhite
	call ClearScreen
	xor a
	ldh [hTileAnimations], a
	call DisableSpriteUpdates
	call HideAnimationOAMEntries
	call GBFadeInFromWhite
	call DisableLCD
	call ClearBGMap
	pop af
	pop hl ; pop de into hl
	ld de, vTileset 
	ld bc, 48 tiles
	call FarCopyData2
	pop hl
	ld a, [wOnSGB]
	and a
	jr z, .skipPalettes
	ldh a, [hGBC]
	and a
	jr z, .sgbPalettes
	ld a, [wOptions2]
	and %11
	jr z, .skipPalettes
	ld a, 8 | %10000000
	ldh [rBGPI], a
	ld de, rBGPD
	ld b, NUM_CAMERA_PIC_PALETTES * 8
.copy
	ld a, [hli]
	ld [de], a
	dec b
	jr nz, .copy
	push hl
	ld a, 1
	ldh [rVBK], a
	hlbgcoord 6, 4, vBGMap1
	ld d, 1 ; palette 1
	lb bc, 8, 6
	xor a
	call LoadBGMapSquareData
	pop de ; pop hl into de
	call CopyPicExtraBGPalettes
	xor a
	ldh [rVBK], a
.skipPalettes
	hlcoord 6, 4
	ld d, 0 ; tileset tile 0
	lb bc, 8, 6
	call LoadScreenSquareTiles
	CheckAndResetEvent FLAG_SLIDING_CAMERA_PIC
	jr z, .skip
	xor a
	ldh [hSCX], a
	ld a, 96
	ldh [hSCY], a
.skip
	rst _DelayFrame
.done
	jp EnableLCD
.sgbPalettes
	ld de, CUSTOM_BALL_PALETTE_DATA_LENGTH - 1
	add hl, de
	ld a, [hl] ; SGB palette
	ld [wGenericPaletteOverride], a
    ld d, SET_PAL_GENERIC
	call RunPaletteCommand
	jr .skipPalettes

CopyPicExtraBGPalettes:
	hlbgcoord 6, 4, vBGMap1
	ld c, 2
	push hl
	call .writeExtraPalettes
	pop hl
	ld c, 3
	; fall through
.writeExtraPalettes
	ld b, 6
.outerLoop
	push bc
	ld b, 8
	ld a, [de]
	inc de
	push hl
.loopShiftBits
	sla a
	jr nc, .skipSet
	ld [hl], c
.skipSet
	inc hl
	dec b
	jr nz, .loopShiftBits
	pop hl
	push de
	ld de, TILEMAP_WIDTH
	add hl, de
	pop de
	pop bc
	dec b
	jr nz, .outerLoop
	ret

; d = which sprite
MakeSpriteFacePlayer::
	ld c, d
	ld b, SPRITESTATEDATA2_MAPY
	call GetFromSpriteStateData2
	ld a, [hli]
	sub 4
	ld b, a
	ld a, [wYCoord]
	cp b
	ld a, d
	jr z, .xCompare
	ld b, SPRITE_FACING_DOWN
	jr nc, .gotDir
	ld b, SPRITE_FACING_UP
	jr .gotDir
.xCompare
	ld a, [hl]
	sub 4
	ld b, a
	ld a, [wXCoord]
	cp b
	ld a, d
	ld b, SPRITE_FACING_RIGHT
	jr nc, .gotDir
	ld b, SPRITE_FACING_LEFT
.gotDir
	jp ChangeSpriteFacing

ExclamationDuringCameraEvent:
	ld a, SFX_SWAP
	rst _PlaySound
	ld a, EXCLAMATION_BUBBLE
  	ld [wWhichEmotionBubble], a
	xor a
	ld [wEmotionBubbleSpriteIndex], a
	ld hl, wMovementFlags
	set BIT_LEDGE_OR_FISHING, [hl]
	callfar EmotionBubble
	ld hl, wMovementFlags
	res BIT_LEDGE_OR_FISHING, [hl]
	ld hl, wShadowOAMSprite04YCoord
	ld de, wShadowOAMSprite00YCoord
	ld bc, 32
	rst _CopyData
	ret

PlayAlternateJigglypuffSong::
	ld c, BANK(Music_JigglypuffSong)
	ld a, MUSIC_JIGGLYPUFF_SONG
	call PlayMusic
	ld de, Music_JigglypuffSong_Ch1_Alternate
	ld hl, wChannelCommandPointers + CHAN1 * 2
	call RemapSoundChannel
	inc hl
	ld de, Music_JigglypuffSong_Ch2_Alternate
	call RemapSoundChannel
.next
	ld a, [wChannelSoundIDs]
	cp MUSIC_JIGGLYPUFF_SONG
	jr z, .next
	jp PlayDefaultMusic

IsPlayerBesideMapSprite::
	ld b, SPRITESTATEDATA2_MAPY
	call GetFromSpriteStateData2
	ld a, [wYCoord]
	call .compare
	ret z
	ld a, [wXCoord]
	; fall through
.compare
	ld b, a
	ld a, [hli]
	sub 4
	sub b
	jr z, .found
	cp $FF ; 1 less
	jr z, .found
	cp 1   ; 1 more
	jr z, .found
	xor a
	ret
.found
	or 1
	ret

ReloadAfterCameraPic::
	call ReloadAfterCameraPicNoFadeIn
	jp GBFadeInFromWhite

ReloadAfterCameraPicNoFadeIn::
	call GBPalWhiteOut
	call DisableLCD
	call LoadTilesetTilePatternData
	ldh a, [hGBC]
	and a
	jr z, .skipGBC
	ld a, 1
	ldh [rVBK], a
	hlbgcoord 6, 4, vBGMap1
	xor a
	ld d, a ; palette 0
	lb bc, 8, 6
	call LoadBGMapSquareData
	xor a
	ldh [rVBK], a
.skipGBC
	call EnableLCD
	callfar LoadExtraTiles
	call EnableSpriteUpdates
	call UpdateSprites
	call LoadCurrentMapView
	call Delay3
	call PlayDefaultMusicFadeOutCurrent
	call RunDefaultPaletteCommand
	jpfar ReloadTileAnimsValue

; Screen must be off to do this
ClearBGMap:
	hlbgcoord 0, 0, vBGMap1
	ld d, ' '
	lb bc, 32, 32
	xor a
	jp LoadBGMapSquareData

; nc if unlocked
IsFinalPhotoUnlocked::
	ld hl, wCustomBallUnlockFlags
	ld b, 2
	call CountSetBits
	ld a, [wNumSetBits]
	cp 15
	ret

; inputs :
  ; d : map X
  ; e : map Y
; outputs :
  ; d : screen X
  ; e : screen Y
;GetScreenXYFromXYMapPosition:
;    ld a, [wYCoord]
;    cpl
;    inc a
;    add e
;    and $f
;    swap a          ; * 16
;    sub $4          ; - 4
;    ld e, a
;    ld a, [wXCoord]
;    cpl
;    inc a
;    add d
;    and $f
;    swap a          ; * 16
;    ld d, a
;    ret