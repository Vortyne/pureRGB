AnimationSendOutMoonPoof::
	ld a, [wBattleMonFlags]
	rra
	rra
	rra
	and %11111
AnimationSpecificCustomBallPoof::
	call BallAnimCheckForcePokeball
	push af
	call Random
	; counter starts at a random value as to make multicolor animations vary more
	ld [wBallAnimFrameCounter], a
	; on GBC, we will use 2x cpu mode for faster calculations
	callfar GBCSetCPU2xSpeed
	ld hl, wBallAnimSGBColorLoadFlag
	res 0, [hl]
	set 1, [hl]
	ld a, $35
	call LoadTileIntoOAM36Times
	ld hl, wBaseCoordX
	ld [hl], 40
	inc hl
	ld [hl], 96
	; load pokeball OAM
	call LoadPokeballTilesAndOAM
	pop af
	cp 6
	jr nc, .customBallAnim
	ld hl, DefaultBallAnimTable
	add a
	ld d, 0
	ld e, a
	add hl, de
	hl_deref
	jr .gotBallAnim
.customBallAnim
	sub 6
	ld hl, wCustomPokeballSettings
	ld d, 0
	ld e, a
	add hl, de
	add hl, de
	add hl, de
	jr .doCustomBallAnim
.gotBallAnim
	call hl_caller
	call HideAnimationOAMEntries
	callfar AnimationResetScreenPalette
	call BallAnimResetColor
	ld a, [wIsInBattle]
	and a
	ret z
	jpfar GBCSetCPU1xSpeed
.doCustomBallAnim
	ld a, [hl]
	swap a
	and %1111
	push hl
	call LoadBallPoofTile
	pop hl
	ld a, [hli]
	and %1111
	push hl
	push af
	inc hl
	bit 2, [hl]
	ld a, %11100100
	jr z, .skipInvert
	ld a, %11011000
.skipInvert
	ldh [rOBP0], a
	pop af
	call LoadBallAnimPalette
	pop hl
	ld a, [hl]
	swap a
	and %1111
	cp %1111
	call z, .randomize
	and a
	jr z, .skipTossAnim
	push hl
	dec a ; 0 = no ball toss anim
	; throw anim
	ld hl, BallTossAnimJumpTable
	ld d, 0
	ld e, a
	add hl, de
	add hl, de
	hl_deref
	call hl_caller
	call HideAnimationOAMEntries
	pop hl
.skipTossAnim
	ld a, [hli]
	and %1111
	push hl
	call PlayPoofSFX
	pop hl
	ld a, [hl]
	push hl
	and %11
	jr z, .next
	dec a
	jr z, .darkScreen
	callfar AnimationLightScreenPalette
	jr .next
.darkScreen
	callfar AnimationDarkScreenPalette
.next
	pop hl
	ld a, [hl]
	swap a
	and %1111
	cp %1111
	call z, .randomize
	; poof anim
	ld hl, PoofAnimJumpTable
	ld d, 0
	ld e, a
	add hl, de
	add hl, de
	hl_deref
	jp .gotBallAnim
.randomize
	call Random
	and %1111
	cp %1111
	jr z, .randomize ; result must not be 16
	ret

LoadPokeballTilesAndOAM::
	ld hl, vSprites tile $31
	ld de, MoveAnimationTiles0
	lb bc, BANK(MoveAnimationTiles0), 24
	call CopyVideoData
LoadPokeballOAM:
	ld hl, wShadowOAMSprite36TileID
	ld de, PokeballOAMList
LoadPokeballOAMLoop:
	ld a, [de]
	cp -1
	ret z
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hl], a
	call GoToNextOAMEntry
	jr LoadPokeballOAMLoop

PokeballOAMList:
	db $33, 0
	db $33, OAM_HFLIP
	db $43, 0
	db $43, OAM_HFLIP
	db -1

LoadBallPoofTile:
	cp $FF
	jr z, .blankTile
	; input a = 0 to 15, aka which tile
	ld hl, BallPoofAnimTileIndices
	cp 4
	ld b, BANK(MoveAnimationTiles0)
	ld de, MoveAnimationTiles0
	jr c, .lookUpTile
	cp 6
	ld b, BANK(MoveAnimationTiles1)
	ld de, MoveAnimationTiles1
	jr c, .lookUpTile
	sub 6
	ld b, BANK(BallAnimTiles)
	ld de, BallAnimTiles
	jr .gotTile
.lookUpTile
	push de
	ld d, 0
	ld e, a
	add hl, de
	pop de
	ld a, [hl]
.gotTile
	and a
	jr z, .skip
	ld h, d
	ld l, e
	ld d, 0
	ld e, LEN_2BPP_TILE
	ld c, a
	and a
.loopFindTile
	add hl, de
	dec c
	jr nz, .loopFindTile
	ld d, h
	ld e, l
.skip
	ld c, 1
	ld hl, vSprites tile $35
	jp CopyVideoData
.blankTile
	ld de, NothingSprite
	ld b, BANK(NothingSprite)
	jr .skip


BallPoofAnimTileIndices:
	; tileset 0
	db 73 ; sphere
	db 28 ; sparkle
	db 77 ; rock
	db 55 ; water droplet
	; tileset 1
	db 64 ; leaf
	db 65 ; fire

LoadBallAnimPalette::
	call TransferBallAnimPalette.getPalette
	ld [wBallAnimPalette], a
TransferBallAnimPalette:
	ld a, [wBallAnimPalette]
	cp PAL_PRISMATIC
	jr nz, .continue
	ld a, [wBallAnimFrameCounter]
	and a
	jr nz, .multicolor
	ld a, [wBallAnimPalette]
	jr .continue
.multicolor
	and %1111
	srl a ; color will be palettes 0 to 8 depending on the frame counter, changing every 2 frames
	call .getPalette
.continue
	ld d, a
	jpfar TransferSpecificAnimPalette
.getPalette
	ld hl, BallAnimPaletteList
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ret

	; on GBC we will set each sprite palette to one color of the rainbow

FarGetBallDataPalette::
	ld d, 0
	ld a, e
	call BallAnimCheckForcePokeball
	ld e, a
	cp 6
	jr nc, .customPalette
	ld hl, BallDefaultPalettes
	add hl, de
	ld a, [hl]
	ld e, a
	ret
.customPalette
	ld hl, wCustomPokeballSettings
	sub 6
	ld e, a
	add hl, de
	add hl, de
	add hl, de
	ld a, [hl]
	and %1111
	ld hl, BallAnimPaletteList
	ld d, 0
	ld e, a
	add hl, de
	ld e, [hl]
	ret
	
BallDefaultPalettes:
	db PAL_REDMON ; pokeball
	db PAL_BLUEMON ; great ball
	db PAL_ULTRABALL ; ultra ball
	db PAL_SAFARIBALL ; safari ball
	db PAL_GREENMON ; hyper ball
	db PAL_PURPLEMON ; master ball

BallAnimPaletteList:
	db PAL_REDMON
	db PAL_YELLOWMON
	db PAL_MEWMON
	db PAL_GREENMON 
	db PAL_CYANMON
	db PAL_BLUEMON
	db PAL_0F
	db PAL_PURPLEMON
	db PAL_PINKMON
	db PAL_GRAYMON
	db PAL_BLACKMON
	db PAL_WHITEMON
	db PAL_REDBAR
	db PAL_GREENBAR
	db PAL_REALLY_REDMON
	db PAL_PRISMATIC ; indicates to use multicolor
	
PoofAnimJumpTable:
	dw FastPoofAnim
	dw EightWayPoofOutAnim
	dw CircleAroundPoofAnim
	dw CircleOutwardPoofAnim
	dw SpiralOutPoofAnim
	dw WaterDropletsDownAnim
	dw CrissCrossAnimation
	dw ScanUpwardsAnimation
	dw WindmillPoofAnim
	dw DropAnimation ; STRIKE
	dw SpecklePoofAnimation
	dw ConfettiPoofAnimation
	dw DoubleHelixDownPoofAnimation
	dw TornadoPoofAnim
	dw ExplodePoofAnim

BallTossAnimJumpTable:
	dw AppearBallTossAnim
	dw FlashBallTossAnim
	dw ShakeBallTossAnim
	dw VibrateBallTossAnim
	dw ThrowBallTossAnim
	dw DropBallTossAnim
	dw BounceBallTossAnim
	dw RollBallTossAnim
	dw ZigZagBallTossAnim
	dw FakeoutBallTossAnim
	dw EmotionBallTossAnim
	dw TheMergeTossAnim
	dw SliceBallTossAnim
	dw DescendBallTossAnim

DefaultBallAnimTable:
	dw PokeBallAnim
	dw GreatBallAnim
	dw UltraBallAnim
	dw SafariBallAnim
	dw HyperBallAnim
	dw MasterBallAnim

PokeBallAnim:
	ld a, BALL_COLOR_RED
	call LoadBallAnimPalette
	call AppearBallTossAnim
.ogPoof
	call HideAnimationOAMEntries
	ld a, BALL_SFX_ORIGINAL
	call PlayPoofSFX
	call OriginalPoofAnim
	jp HideAnimationOAMEntries

GreatBallAnim:
	ld a, BALL_COLOR_BLUE
	call LoadBallAnimPalette
	call ShakeBallTossAnim
.fastPoof
	call HideAnimationOAMEntries
	ld a, BALL_SFX_ORIGINAL
	call PlayPoofSFX
	call FastPoofAnim
	jp HideAnimationOAMEntries

UltraBallAnim:
	ld a, PAL_ULTRABALL
	ld [wBallAnimPalette], a
	ld d, a
	callfar TransferSpecificAnimPalette
	call VibrateBallTossAnim
	jr GreatBallAnim.fastPoof

SafariBallAnim:
	ld a, PAL_SAFARIBALL
	ld [wBallAnimPalette], a
	ld d, a
	callfar TransferSpecificAnimPalette
	call RollBallTossAnim
	jr GreatBallAnim.fastPoof

HyperBallAnim:
	ld a, BALL_TILE_SPHERE
	call LoadBallPoofTile
	ld a, BALL_COLOR_GREEN
	call LoadBallAnimPalette
	call ThrowBallTossAnim
	call HideAnimationOAMEntries
	callfar AnimationLightScreenPalette
	ld a, SFX_BATTLE_0E
	call PlaySoundResetSFXModifiers
	call HyperBallDropAnim
	call HideAnimationOAMEntries
	jpfar AnimationResetScreenPalette

MasterBallAnim:
	ld a, BALL_TILE_SPHERE
	call LoadBallPoofTile
	ld a, BALL_COLOR_PURPLE
	call LoadBallAnimPalette
	ld a, SFX_HORN_DRILL
	call PlaySoundResetSFXModifiers
	call ThrowBallTossAnim
	call HideAnimationOAMEntries
	callfar AnimationLightScreenPalette
	ld a, SFX_FAINT_THUD
	call PlaySoundResetSFXModifiers
	call SpiralOutPoofAnim
	call HideAnimationOAMEntries
	jpfar AnimationResetScreenPalette


EightWayPoofOutAnim:
	xor a
	ld [wCircleAnimRotationSpeed], a ; no rotation, so they will just move outward
	ld a, 1
	ld [wCircleAnimRadiusChange], a
	ld a, 8
	ld [wCircleAnimSpacing], a
	ld a, 8
	ld [wCircleAnimTileCount], a
	ld d, 2 ; initial circle radius
	jp CircleAnim


LoadTileIntoOAM36Times:
	ld c, 36
	ld hl, wShadowOAMSprite00TileID
	ld de, 4
.loop
	ld [hl], a
	add hl, de
	dec c
	jr nz, .loop
	ret

GoToNextOAMEntry:
	inc hl
	inc hl
	inc hl
	ret

HideAnimationOAMEntries:
	ld hl, wShadowOAMSprite00YCoord
	lb de, 0, 0
	ld b, 40
LoadOAMCoordsBTimes:
.loop
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	inc hl
	inc hl
	dec b
	jr nz, .loop
	ret

SpiralOutPoofAnim:
	ld hl, wBaseCoordX
	ld [hl], 40
	inc hl
	ld [hl], 96
	call BallPoofDelayFrame
	ld a, 1
	ld [wCircleAnimRadiusChange], a
	ld a, 6
	ld [wCircleAnimRotationSpeed], a
	ld [wCircleAnimTileCount], a
	ld a, 3
	ld [wCircleAnimSpacing], a
	ld d, 2 ; initial circle radius
	jp CircleAnim

CircleAroundPoofAnim:
	ld hl, wBaseCoordX
	ld [hl], 40
	inc hl
	ld [hl], 96
	call BallPoofDelayFrame
	xor a
	ld [wCircleAnimRadiusChange], a
	ld a, 1
	ld [wCircleAnimRotationSpeed], a
	ld a, 8 ; 8 = perfect spacing
	ld [wCircleAnimSpacing], a
	ld [wCircleAnimTileCount], a
	ld d, 20 ; initial circle radius
	jr CircleAnim

CircleOutwardPoofAnim:
	ld hl, wBaseCoordX
	ld [hl], 40
	inc hl
	ld [hl], 96
	call BallPoofDelayFrame
	ld a, 1
	ld [wCircleAnimRadiusChange], a
	inc a
	ld [wCircleAnimRotationSpeed], a
	ld a, 8 ; 8 = perfect spacing
	ld [wCircleAnimSpacing], a
	ld [wCircleAnimTileCount], a
	ld d, 3 ; initial circle radius
	; fall through
CircleAnim:
	ld c, 0
CircleAnimWithOffset:
	xor a
	ld [wAnimCounter], a
CircleAnimCounterSet:
	; loop for each frame of animation
.outerLoop
	ld hl, wShadowOAMSprite00YCoord - 4
	call CircleAnimFrame
	ld a, [wCircleAnimRadiusChange]
	add d
	ld d, a
	call BallPoofDelayFrame
	ld a, [wAnimCounter]
	inc a
	ld [wAnimCounter], a
	cp 30
	jr nz, .outerLoop
	ret

CircleAnimFrame:
	ld a, [wCircleAnimRotationSpeed]
	add c
	ld c, a
	ld a, [wCircleAnimTileCount]
	ld e, a
	; loop through each tile
.tileLoop
	inc hl
	inc hl
	inc hl
	inc hl
	ld b, 0
	push hl
	; loop once for each y then x coord
.loopCoordSet
	; add the offset for each tile so they don't appear at the exact same spot
	push de
	ld a, [wCircleAnimSpacing]
	ld d, a
	ld a, c
.addLoop
	add d
	dec e
	jr nz, .addLoop
	pop de
	push de
	push hl
	dec b
	inc b
	jr z, .sine
	call BattleAnim_Cosine
	jr .next
.sine
	call BattleAnim_Sine
.next
	ld d, a
	dec b
	inc b
	ld hl, wBaseCoordX
	jr nz, .gotBaseCoord
	inc hl
.gotBaseCoord
	ld a, [hl]
	pop hl
	add d
	pop de
	ld [hli], a
	inc b
	ld a, b
	cp 2
	jr nz, .loopCoordSet
	pop hl
	dec e
	jr nz, .tileLoop
	ret

TornadoPoofAnim:
	ld hl, wShadowOAMSprite00YCoord
	lb de, 108, 0
	ld b, 40
	call LoadOAMCoordsBTimes
    ; tiles will go upwards vertically in a x sign wave
    ld b, 30
    xor a
    ld [wSpinningHorizontalTilesRotationSpeed], a
	ld [wSpinningHorizontalTilesCounter], a
    ld a, 2
	ld d, a
	ld e, a
	ld [wAnimCounter], a
	ld a, -2
	ld [wSpinningHorizontalTilesYChange], a
	ld [wSpinningHorizontalTilesRotationSpeed], a
	ld a, 8
	ld [wSpinningHorizontalTilesOffset], a
.loop
	ld hl, wShadowOAMSprite00YCoord - 3
	ld c, 8
	call SpinningHorizontalTiles
	ld a, b
	cp 20
	jr nc, .noSecondCircleYet
	push de
	ld d, e
	ld hl, wShadowOAMSprite08YCoord - 3
	ld c, 8
	call SpinningHorizontalTiles
	pop de
	inc e
	ld a, b
	cp 10
	jr nc, .noThirdCircleYet
	push de
	ld hl, wShadowOAMSprite16YCoord - 3
	ld a, [wAnimCounter]
	ld d, a
	inc a
	ld [wAnimCounter], a
	ld c, 8
	call SpinningHorizontalTiles
	pop de
.noThirdCircleYet
.noSecondCircleYet
	call BallPoofDelayFrame
	inc d
	dec b
	jr nz, .loop
	ret

SpinningHorizontalTiles:
	; b = current y value
.loopTiles
	call GoToNextOAMEntry
	push bc
	ld a, [wSpinningHorizontalTilesYChange]
	and a
	jr z, .skip
	ld b, a
	ld a, [hl]
	add b
	ld [hl], a
	jr .loopAddOffset
.skip
	ld a, [wSpinningHorizontalTilesCounter]
.loopAddOffset
	ld b, a
	ld a, [wSpinningHorizontalTilesOffset]
	add b
	dec c
	jr nz, .loopAddOffset
	ld b, a
	ld a, [wSpinningHorizontalTilesRotationSpeed]
	add b
	pop bc
	inc hl
	push hl
	push de
	; a = y value
	call BattleAnim_Sine
	ld d, a
	ld a, [wBaseCoordX]
	add d
	pop de
	pop hl
	ld [hl], a
	dec c
	jr nz, .loopTiles
	ret

DoubleHelixDownPoofAnimation:
	ld hl, wShadowOAMSprite00YCoord
	lb de, 40, 0
	ld b, 40
	call LoadOAMCoordsBTimes
    ; tiles will go down vertically in a x sine wave
	ld b, 30 ; number of frames in the animation
.loop
	ld a, b
	cp 10
	jr c, .spread 
	ld hl, wShadowOAMSprite00YCoord - 3
	ld a, 32
	ld [wSpinningHorizontalTilesOffset], a
	ld a, 3
	ld [wSpinningHorizontalTilesYChange], a
	ld a, 8
	ld [wSpinningHorizontalTilesRotationSpeed], a
	xor a
	ld [wSpinningHorizontalTilesCounter], a
	ld d, 14 ; radius of circle
	ld c, 2 ; number of tiles
	call SpinningHorizontalTiles
	jr .delayAndNext
.spread
	ld hl, wShadowOAMSprite00XCoord
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	ld hl, wShadowOAMSprite01XCoord
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
.delayAndNext
	call BallPoofDelayFrame
	dec b
	jr nz, .loop
	ret

SpecklePoofAnimation:
	ld hl, wBaseCoordX
	ld [hl], 40
	inc hl
	ld [hl], 86
	xor a
	ld [wCircleAnimRotationSpeed], a ; no rotation, so they will just move outward
	ld a, 2
	ld [wCircleAnimRadiusChange], a
	ld a, 8
	ld [wCircleAnimSpacing], a
	ld [wCircleAnimTileCount], a
	ld a, 20
	ld [wAnimCounter], a
	ld d, 2 ; initial circle radius
	ld c, 0
	call CircleAnimCounterSet
    ; tiles will go upwards vertically in a x sign wave
	ld b, 15 ; number of frames
	ld hl, wShadowOAMSprite03YCoord
	ld de, SpeckleTileCoords
.loop
	ld a, [de]
	and a
	jr nz, .dontRestart
	ld de, SpeckleTileCoords
.dontRestart
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	inc de
	push hl
	push bc
	ld b, 15
	ld hl, wShadowOAMSprite03YCoord
.innerLoop
	ld a, [hl]
	and a
	jr z, .skip ; dont increment sprites that aren't currently showing
	inc [hl]
.skip
	call GoToNextOAMEntry4
	dec b
	jr nz, .innerLoop
	pop bc
	pop hl
	push hl
	dec hl
	call GoToPrevOAMEntry
	call GoToPrevOAMEntry
	call GoToPrevOAMEntry
	ld [hl], 0 ; y value of the speckle that was shown 4 frames ago (hide it)
	pop hl
	call GoToNextOAMEntry
	ld a, b
	and %1
	call z, BallAnimInvertColor
	call BallPoofDelay2Frames
	dec b
	jr nz, .loop
	ret

GoToPrevOAMEntry:
	dec hl
	dec hl
	dec hl
	dec hl
	ret

GoToNextOAMEntry4:
	inc hl
	inc hl
	inc hl
	inc hl
	ret

SpeckleTileCoords:
	db 64, 32 
	db 88, 24 
	db 96, 64 
	db 72, 44
	db 104, 32  
	db 96, 40 
	db 80, 56 
	db 72, 64 
	db 68, 48 
	db 64, 56
	db 80, 40 
	db 104, 40 
	db 76, 28 
	db 88, 48 
	db 104, 56 
	db 0

WaterDropletsDownAnim:
	ld hl, wShadowOAMSprite00YCoord
	lb de, 86, 0
	ld b, 40
	call LoadOAMCoordsBTimes
	ld b, 30 ; number of frames in the animation
	ld d, 2 ; initial radius of the circle
.loop
	ld a, b
	cp 10
	jr c, .skip
	push bc
	; get the x coords
	ld hl, wShadowOAMSprite00YCoord - 3
	ld a, 8
	ld [wSpinningHorizontalTilesOffset], a
	ld a, b
	ld [wSpinningHorizontalTilesCounter], a
	xor a
	ld [wSpinningHorizontalTilesYChange], a
	ld [wSpinningHorizontalTilesRotationSpeed], a
	ld c, 8 ; number of tiles
	call SpinningHorizontalTiles
	pop bc
	inc d
	ld a, b
	and %1
	jr z, .skip
	inc d
.skip
	; get the y coords (up 10 frames down 20 frames)
	push bc
	ld c, 16
	ld hl, wShadowOAMSprite00YCoord
.loopY
	ld a, b
	cp 17
	jr c, .down
.up
	dec [hl]
	dec [hl]
	jr .nextY
.down
	ld a, [hl]
	and a
	jr z, .nextY
	cp 104
	jr c, .down2
	ld [hl], 0
	jr .nextY
.down2
	inc [hl]
	inc [hl]
	inc [hl]
.nextY
	call GoToNextOAMEntry4
	dec c
	jr nz, .loopY
	pop bc
	call BallPoofDelayFrame
	dec b
	jr nz, .loop
	ret


ScanUpwardsAnimation::
	ld hl, wShadowOAMSprite00YCoord
	lb de, 104, 0
	ld b, 8
	call LoadOAMCoordsBTimes
	ld hl, wShadowOAMSprite08YCoord
	lb de, 74, 0
	ld b, 8
	call LoadOAMCoordsBTimes
	ld b, 30 ; number of frames in the animation
.loop
	push bc
	ld a, b
	ld [wSpinningHorizontalTilesCounter], a
	; get the x coords
	ld hl, wShadowOAMSprite00YCoord - 3
	call .spinCircle
	ld hl, wShadowOAMSprite08YCoord - 3
	call .spinCircle
	pop bc
	ld c, 8
	ld hl, wShadowOAMSprite00YCoord
.loopYChange
	dec [hl]
	call GoToNextOAMEntry4
	dec c
	jr nz, .loopYChange
	ld c, 8
	ld hl, wShadowOAMSprite08YCoord
.loopYChange2
	inc [hl]
	call GoToNextOAMEntry4
	dec c
	jr nz, .loopYChange2
	call BallPoofDelayFrame
	dec b
	jr nz, .loop
	ret
.spinCircle
	ld a, 8
	ld [wSpinningHorizontalTilesOffset], a
	xor a
	ld [wSpinningHorizontalTilesYChange], a
	ld a, 2
	ld [wSpinningHorizontalTilesRotationSpeed], a
	ld c, 8 ; number of tiles
	ld d, 18 ; initial radius of the circle
	jp SpinningHorizontalTiles


CrissCrossAnimation::
	ld hl, wShadowOAMSprite00YCoord
	ld de, CrissCrossAnimationBaseCoords
.loopCopyBaseCoords
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	inc de
	ld [hl], a
	call GoToNextOAMEntry
	ld a, [de]
	cp -1
	jr nz, .loopCopyBaseCoords
	ld c, 10 ; number of frames in the animation
.loopPhase1
	; first phase, cross
	ld hl, wShadowOAMSprite00XCoord
	call .incFourTimes
	call .decFourTimes
	call BallPoofDelayFrame
	dec c
	jr nz, .loopPhase1
; phase 2, wait 6 frames
	ld c, 6
	call BallPoofDelayFrames
; phase 3, invert
	ld c, 4
.loopPhase3
	ld hl, wShadowOAMSprite00YCoord
	ld b, 4
.innerLoop1Phase3
	dec [hl]
	dec [hl]
	call GoToNextOAMEntry4
	dec b
	jr nz, .innerLoop1Phase3
	ld b, 4
.innerLoop2Phase3
	inc [hl]
	inc [hl]
	call GoToNextOAMEntry4
	dec b
	jr nz, .innerLoop2Phase3
	dec c
	jr nz, .loopPhase3
; phase 4, cross again
	ld c, 10 ; number of frames in the animation
.loopPhase4
	; first phase, cross
	ld hl, wShadowOAMSprite00XCoord
	call .decFourTimes
	call .incFourTimes
	call BallPoofDelayFrame
	dec c
	jr nz, .loopPhase4
	ret
.incFourTimes
	ld b, 4
.loopIncFourTimes
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	call GoToNextOAMEntry4
	dec b
	ret z
	jr .loopIncFourTimes
.decFourTimes
	ld b, 4
.loopDecFourTimes
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	call GoToNextOAMEntry4
	dec b
	ret z
	jr .loopDecFourTimes	

WindmillPoofAnim:
	ld hl, wBaseCoordX
	ld [hl], 40
	inc hl
	ld [hl], 96
	ld b, 30
.loop
	ld d, 8 ; initial circle radius
	ld hl, wShadowOAMSprite00YCoord - 4
	call .doOneCircle
	ld d, 16
	ld hl, wShadowOAMSprite04YCoord - 4
	call .doOneCircle
	ld d, 24
	ld hl, wShadowOAMSprite08YCoord - 4
	call .doOneCircle
	call BallPoofDelayFrame
	dec b
	jr nz, .loop
	ret
.doOneCircle
	push bc
	xor a
	ld [wCircleAnimRadiusChange], a
	ld a, b
	ld [wCircleAnimRotationSpeed], a
	ld a, 16
	ld [wCircleAnimSpacing], a
	ld a, 4
	ld [wCircleAnimTileCount], a
	ld c, 8
	call CircleAnimFrame
	pop bc
	ret


; 10 frames -> cross
; 6 frames -> wait
; 4 frames -> invert
; 10 frames -> cross

CrissCrossAnimationBaseCoords:
	db 68, 20
	db 80, 20
	db 92, 20
	db 104,20
	db 64, 60
	db 76, 60
	db 88, 60
	db 100,60
	db -1

DropAnimation:
	call DropAnimationPhase1
	ld hl, wBaseCoordX
	ld [hl], 40
	inc hl
	ld [hl], 96
	xor a
	ld [wCircleAnimRadiusChange], a
	ld a, 1
	ld [wCircleAnimRotationSpeed], a
	ld a, 4
	ld [wCircleAnimTileCount], a
	ld a, 16
	ld [wCircleAnimSpacing], a
	dec a ; 15
	ld [wAnimCounter], a
	ld d, 6 ; initial circle radius
	ld c, 0
	jp CircleAnimCounterSet

DropAnimationPhase1:
	ld hl, wShadowOAMSprite00YCoord
	ld de, DropAnimationBaseCoords
	call PoofLoadOAMCoordList
	ld c, 15
.loopPhase1
	ld hl, wShadowOAMSprite00YCoord
	ld b, 4
.innerLoopPhase1
	inc [hl]
	inc [hl]
	inc [hl]
	call GoToNextOAMEntry4
	dec b
	jr nz, .innerLoopPhase1
	call BallPoofDelayFrame
	dec c
	jr nz, .loopPhase1
	ret

HyperBallDropAnim:
	ld hl, vSprites tile $36
	ld de, MoveAnimationTiles0 tile 67
	lb bc, BANK(MoveAnimationTiles0), 1
	call CopyVideoData
	call DropAnimationPhase1
	call HideAnimationOAMEntries
	lb de, 90, 36
	ld hl, wShadowOAMSprite00YCoord
	call LoadBallOAMCoords
	ld b, 4
	ld a, $36
	ld hl, wShadowOAMSprite00TileID
	ld [hl], a
	call GoToNextOAMEntry4
	ld [hli], a
	set OAM_X_FLIP, [hl]
	call GoToNextOAMEntry
	ld [hli], a
	set OAM_Y_FLIP, [hl]
	call GoToNextOAMEntry
	ld [hli], a
	ld [hl], OAM_VFLIP | OAM_HFLIP
	ld c, 15
	call BallPoofDelayFrames
	jp HideAnimationOAMEntries


DropAnimationBaseCoords:
	db 40, 40
	db 46, 40
	db 52, 40
	db 58, 40
	db -1

PoofLoadOAMCoordList:
.loop
		ld a, [de]
		ld [hli], a
		inc de
		ld a, [de]
		inc de
		ld [hl], a
		call GoToNextOAMEntry
		ld a, [de]
		cp -1
		jr nz, .loop
		ret

ConfettiPoofAnimation:
	ld hl, wBaseCoordX
	ld [hl], 40
	inc hl
	ld [hl], 86
	xor a
	ld [wCircleAnimRotationSpeed], a ; no rotation, so they will just move outward
	ld a, 2
	ld [wCircleAnimRadiusChange], a
	ld a, 8
	ld [wCircleAnimSpacing], a
	ld [wCircleAnimTileCount], a
	ld a, 25
	ld [wAnimCounter], a
	ld d, 2 ; initial circle radius
	ld c, 0
	call CircleAnimCounterSet
	call .initializeParticles
	ld b, 25
.particleFallLoop
	ld hl, wShadowOAMSprite00YCoord
	ld c, 12
.loopParticleInc
	inc [hl]
	inc hl
	ld a, b
	and %11
	jr nz, .particleNext
	call Random
	and %1
	jr nz, .decIt
	inc [hl]
	jr .particleNext
.decIt
	dec [hl]
.particleNext
	call GoToNextOAMEntry
	dec c
	jr nz, .loopParticleInc
	ld a, b
	and %1
	call nz, BallAnimInvertColor
	call BallPoofDelayFrame
	dec b
	jr nz, .particleFallLoop
	ret
.initializeParticles
	ld hl, wShadowOAMSprite00YCoord
	lb de, 28, 60
	ld b, 4 ; num of rows
.initializeParticlesLoop
	ld c, 3 ; num of particles per row
.initializeParticleRow
	ld [hl], e
	inc hl
	ld [hl], d
	call GoToNextOAMEntry
	ld a, d
	add 16
	ld d, a
	dec c
	jr nz, .initializeParticleRow
	ld a, e ; y coord
	add 8
	ld e, a
	ld a, b
	and %1
	ld a, 28
	jr nz, .skip
	sub 8
.skip
	ld d, a
	dec b
	jr nz, .initializeParticlesLoop
	ret

AppearBallTossAnim:
	lb de, 90, 36
	call LoadDefaultBallOAMCoords
	ld c, 10
	jp BallPoofDelayFrames

DropBallTossAnim:
	lb de, 36, 36
	call LoadDefaultBallOAMCoords
	ld c, 18
.loop
	ld b, 4
	ld hl, wShadowOAMSprite36YCoord
.tileLoop
	inc [hl]
	inc [hl]
	inc [hl]
	call GoToNextOAMEntry4
	dec b
	jr nz, .tileLoop
	call BallPoofDelayFrame
	dec c
	jr nz, .loop
	jp BallPoofDelay2Frames

VibrateBallTossAnim:
	lb de, 90, 36
	call LoadDefaultBallOAMCoords
	ld c, 8
	call BallPoofDelayFrames
	ld b, 3
.loop
	lb de, 90, 34
	call .loadDelay
	lb de, 90, 38
	call .loadDelay
	dec b
	jr nz, .loop
	ld b, 3
.loop2
	lb de, 90, 32
	call .loadDelay
	lb de, 90, 40
	call .loadDelay
	dec b
	jr nz, .loop2
	ret
.loadDelay
	call LoadDefaultBallOAMCoords
	jp BallPoofDelayFrame

ShakeBallTossAnim:
	lb de, 90, 36
	call LoadDefaultBallOAMCoords
	ld c, 6
	call BallPoofDelayFrames
	ld c, 2
.loopShake
	push bc
	ld b, 0
	ld de, BallShakeOAMTiles
	call .loadOAMTileIDs
	call BallPoofDelay3
	call LoadPokeballOAM
	call BallPoofDelay3
	ld b, 1
	ld de, BallShakeOAMTilesFlipped
	call .loadOAMTileIDs
	call BallPoofDelay3
	call LoadPokeballOAM
	call BallPoofDelay3
	pop bc
	dec c
	jr nz, .loopShake
	ret
.loadOAMTileIDs
	ld hl, wShadowOAMSprite36TileID
	jp LoadPokeballOAMLoop

BallShakeOAMTiles:
	db $37, 0
	db $38, 0
	db $47, 0
	db $48, 0
	db  -1

BallShakeOAMTilesFlipped:
	db $38, OAM_HFLIP
	db $37, OAM_HFLIP
	db $48, OAM_HFLIP
	db $47, OAM_HFLIP
	db -1

RollBallTossAnim:
	lb de, 96, 0
	call LoadDefaultBallOAMCoords
	ld b, 18
.loopRoll
	ld c, 4
	ld hl, wShadowOAMSprite36XCoord
.loopIncX
	inc [hl]
	inc [hl]
	call GoToNextOAMEntry4
	dec c
	jr nz, .loopIncX
	ld a, b
	and %11
	call z, BallAnimInvertColor
	call BallPoofDelayFrame
	dec b
	jr nz, .loopRoll
	jp BallPoofDelay2Frames

LoadDefaultBallOAMCoords::
	ld hl, wShadowOAMSprite36YCoord
	jr LoadBallOAMCoords

	; de = coords
	; c = which sprite is the beginning of the 4-sprite 
LoadSpecificOAMSpriteCoords::
	ld hl, wShadowOAMSprite00YCoord
	push de
	ld a, c
	and a
	jr z, .skip
	ld b, 0
	ld de, 4
.loop
	add hl, de
	dec c
	jr nz, .loop
.skip
	pop de
LoadBallOAMCoords::
	ld a, d
	ld [hli], a
	ld a, e
	ld [hld], a
	call GoToNextOAMEntry4
	ld a, d
	ld [hli], a
	ld a, e
	add 8
	ld [hld], a
	call GoToNextOAMEntry4
	ld a, d
	add 8
	ld [hli], a
	ld a, e
	ld [hld], a
	call GoToNextOAMEntry4
	ld a, d
	add 8
	ld [hli], a
	ld a, e
	add 8
	ld [hl], a
	ret

BallAnimResetColor:
	push hl
	ld a, %11100100
	ldh [rOBP0], a
	pop hl
	ret

BallAnimInvertColor:
	push de
	push bc
	push hl
	ldh a, [rOBP0]
	xor %00111100 ; complement colors 1 and 2
	ldh [rOBP0], a
	call TransferBallAnimPalette
	pop hl
	pop bc
	pop de
	ret

BounceDownBallTossAnim:
	ld de, BounceBallTossAnimYCoordsList
	ld h, 0
	ld c, 36
	jr YAdjustLoopBallToss

BounceBallTossAnim:
	ld de, BounceBallTossAnimYCoordsList
	jr ConstXIncreaseBallToss

ThrowBallTossAnim:
	ld de, ThrowBallTossAnimYCoordsList
ConstXIncreaseBallToss:
	ld h, 2
	ld c, 0 ; initial x coord
YAdjustLoopBallToss:
	ld b, 20 ; number of frames
.loopThrowAnim
	push hl
	push de
	ld a, [de]
	ld d, a
	ld e, c
	call LoadDefaultBallOAMCoords
	pop de
	inc de
	ld a, b
	and %1
	call z, BallAnimInvertColor
	call BallPoofDelayFrame
	pop hl
	ld a, c
	add h
	ld c, a
	dec b
	jr nz, .loopThrowAnim
	ret
	
ThrowBallTossAnimYCoordsList:
	db 68
	db 66 
	db 64 
	db 62 
	db 60 
	db 59 
	db 58 
	db 57 
	db 57 
	db 56 
	db 57 
	db 57 
	db 58 
	db 62 
	db 66 
	db 70 
	db 75 
	db 80 
	db 85 
	db 90 

BounceBallTossAnimYCoordsList:
	db 68
	db 74 
	db 80 
	db 86
	db 90  
	db 86
	db 80 	
	db 74 
	db 74 
	db 80 
	db 86 
	db 90 
	db 86 
	db 80
	db 80 
	db 86 
	db 90 
	db 86 
	db 86 
	db 90 

FlashBallTossAnim:
	lb de, 90, 36
	call LoadDefaultBallOAMCoords
	ld c, 6
	call BallPoofDelayFrames
	ld b, 14
	ld c, 3
.loopFlashAnim
	dec c
	jr nz, .skipFlash
	ld c, 3
	call BallAnimInvertColor
.skipFlash
	call BallPoofDelayFrame
	dec b
	jr nz, .loopFlashAnim
	ret

EmotionBallTossAnim:
	lb de, 90, 36
	call LoadDefaultBallOAMCoords
	; choose a random emotion bubble
.reroll
	call Random
	and %111
	cp 5
	jr nc, .reroll
	ld hl, vSprites tile $49
	lb bc, BANK(EmotionBubbles), 4
	ld de, ShockEmote
	dec a
	jr z, .loadEmote
	ld de, QuestionEmote
	dec a
	jr z, .loadEmote
	ld de, HappyEmote
	dec a
	jr z, .loadEmote
	ld b, BANK(LoveEmote)
	ld de, LoveEmote
	dec a
	jr z, .loadEmote
	ld de, SleepingEmote
.loadEmote
	call CopyVideoData
	ld hl, wShadowOAMSprite32TileID
	ld de, EmoteOAMData
	call LoadPokeballOAMLoop
	ld hl, wShadowOAMSprite32Attributes
	ld b, 4
.loadOBJ1IntoEmoteSprites
	ld [hl], 1
	call GoToNextOAMEntry4
	dec b
	jr nz, .loadOBJ1IntoEmoteSprites
	ldh a, [hGBC]
	and a
	jr z, .notGBC
.notInBlankingPeriod
	ldh a, [rSTAT]
	and %10 ; mask for non-V-blank/non-H-blank STAT mode
	jr nz, .notInBlankingPeriod
	ld a, $8A ; bit 7 set and 10th byte
	ldh [rOBPI], a ; 2nd color of 2nd palette and auto increment bit set
	ld a, $FF
	ldh [rOBPD], a ; white
	ldh [rOBPD], a ; white
.notGBC
	ld hl, wShadowOAMSprite32YCoord
	lb de, 76, 36
	call LoadBallOAMCoords
	ld c, 20
	jp BallPoofDelayFrames

EmoteOAMData:
	db $49, 0
	db $4A, 0
	db $4B, 0
	db $4C, 0
	db -1

FakeoutBallTossAnim:
	ld de, FakeoutBallTossAnimXCoordsList
	ld h, 4
	ld c, 10
	jr ArbitraryYIncreaseBallTossAnim

ZigZagBallTossAnim:
	ld de, ZigZagBallTossAnimXCoordsList
ConstYIncreaseBallTossAnim:
	ld h, 2  ; y increase
	ld c, 50 ; initial y coord
ArbitraryYIncreaseBallTossAnim:
	ld b, 20 ; number of frames
.loopThrowAnim
	push de
	ld a, [de]
	ld d, c
	ld e, a
	push hl
	call LoadDefaultBallOAMCoords
	pop hl
	pop de
	inc de
	call BallPoofDelayFrame
	ld a, h
	add c
	ld c, a
	dec b
	jr nz, .loopThrowAnim
	ret

ZigZagBallTossAnimXCoordsList:
	db 22
	db 28 
	db 32 
	db 38
	db 44  
	db 50
	db 44 	
	db 38 
	db 32 
	db 28 
	db 22 
	db 28 
	db 32 
	db 38
	db 44  
	db 50
	db 44 	
	db 38 
	db 37
	db 36


TheMergeTossAnim:
	lb de, 90, 36
	call LoadDefaultBallOAMCoords
	ld de, wShadowOAMSprite36XCoord
	; fall through

	; input de = which OAM 4-tile sprite to animate
TeleportInSprite::
	ld h, d
	ld l, e
	ld a, [hl]
	sub 20
	ld d, a ; initial "left" x coord
	ld a, [hld]
	add 20
	ld e, a ; initial "right" x coord
	ld b, 20 ; number of frames
	ld c, [hl] ; y coord of sprite
.loopThrowAnim
	push de
	ld a, b
	and %1
	jr z, .next
	ld e, d
.next
	ld d, c
	push hl
	call LoadBallOAMCoords
	pop hl
	pop de
	call BallPoofDelayFrame
	inc d
	dec e
	dec b
	jr nz, .loopThrowAnim
	ret

FakeoutBallTossAnimXCoordsList:
	db 08
	db 24 
	db 40 
	db 56
	db 72  
	db 88
	db 96 	
	db 104 
	db 100 
	db 104 
	db 100 
	db 104
	db 96 
	db 88 
	db 72
	db 64  
	db 56
	db 48 	
	db 40 
	db 36

DivineProtectionSound::
	ld de, SFX_Sparkle_Ch5
	ld de, SFX_Sparkle_Ch6
PlayRemappedBattleSound:
	push de
	push de
	ld a, SFX_BATTLE_35
	rst _PlaySound
	ld hl, wChannelCommandPointers + CHAN5 * 2
	pop de
	call RemapSoundChannel
	inc hl
	pop de
	jp RemapSoundChannel

DescendBallTossAnim:
	xor a
	ld [wFrequencyModifier], a
	ld a, $80
	ld [wTempoModifier], a
	ld de, SFX_SparkleShort_Ch5
	ld de, SFX_SparkleShort_Ch6
	call PlayRemappedBattleSound
	ld hl, vSprites tile $49
	ld de, BallAnimTiles tile 10
	lb bc, BANK(BallAnimTiles), 3
	call CopyVideoData
	lb de, 50, 36
	call LoadDefaultBallOAMCoords
	ld hl, wShadowOAMSprite35YCoord
	ld [hl], 46
	inc hl
	ld [hl], 40
	inc hl
	ld [hl], $49 ; halo tile
	ld b, 40
	lb de, 50, 36
.loop
	call LoadDefaultBallOAMCoords
	push de
	push bc
	ld a, b
	and %1
	jr z, .skip
	ld hl, wShadowOAMSprite21YCoord
	lb de, 0, 0
	ld b, 14
	call LoadOAMCoordsBTimes
	jr .skip2
.skip
	ld c, 32
	ld e, $4B
	ld hl, wShadowOAMSprite21YCoord
	call .drawLine
	ld c, 48
	ld e, $4A
	ld hl, wShadowOAMSprite28YCoord
	call .drawLine
.skip2
	pop bc
	pop de
	ld hl, wShadowOAMSprite35YCoord
	inc [hl]
	inc d
	call BallPoofDelayFrame
	dec b
	jr nz, .loop
	jp StopSFXChannels
.drawLine
	ld b, 50
	ld d, 7
.loopDrawTile
	ld [hl], b
	inc hl
	ld [hl], c
	inc hl
	ld [hl], e
	inc hl
	inc hl
	ld a, 8
	add b
	ld b, a
	dec d
	jr nz, .loopDrawTile
	ret 

SliceBallTossAnim:
	lb de, 90, 36
	call LoadDefaultBallOAMCoords
	xor a
	ld [wFrequencyModifier], a
	ld a, $a0
	ld [wTempoModifier], a
	ld a, SFX_NOT_VERY_EFFECTIVE
	rst _PlaySound
	call BallPoofDelayFrame
	callfar AnimationDarkScreenPalette
	call BallPoofDelay2Frames
	callfar AnimationResetScreenPalette
	ld c, 10
	call BallPoofDelayFrames
	ld b, 20
.loopSliceVertical
	ld hl, wShadowOAMSprite36YCoord
	dec [hl]
	call GoToNextOAMEntry4
	inc [hl]
	call GoToNextOAMEntry4
	dec [hl]
	call GoToNextOAMEntry4
	inc [hl]
	call BallPoofDelayFrame
	dec b
	jr nz, .loopSliceVertical
	ret

FastPoofAnim:
	ld c, 3
	jr OriginalPoofAnimCommon

OriginalPoofAnim:
	ld c, 5
OriginalPoofAnimCommon:
	push bc
	ld hl, vSprites tile $4D
	ld de, MoveAnimationTiles0 tile 32
	lb bc, BANK(MoveAnimationTiles0), 6
	call CopyVideoData
	ld hl, vSprites tile $53
	ld de, MoveAnimationTiles0 tile 48
	lb bc, BANK(MoveAnimationTiles0), 6
	call CopyVideoData

	ld de, FirstFrameTileIDOrder
	call InitFourTimesFourPoofAnim


	pop bc
	push bc
	call BallPoofDelayFrames

	ld de, SecondFrameTileIDOrder
	call LoadPoofOAM4Times
	pop bc
	push bc
	call BallPoofDelayFrames

	call .expand

	pop bc
	push bc
	call BallPoofDelayFrames

	ld de, FourthFrameTileIDOrder
	call LoadPoofOAM4Times

	pop bc
	push bc
	call BallPoofDelayFrames

	call .expand
	pop bc
	push bc
	call BallPoofDelayFrames
	pop bc
	jp BallPoofDelayFrames

.expand
	ld b, 4
	ld hl, wShadowOAMSprite00YCoord
	ld de, ThirdFramePixelDifferentials
.loadPixelDifferentialsBTimes
	ld c, 4
.loopPixelDifferentials
	push bc
	push de
.loopAgain
	push de
	ld a, [de]
	ld c, [hl]
	add c
	ld [hli], a
	inc de
	ld a, [de]
	ld c, [hl]
	add c
	ld [hl], a
	call GoToNextOAMEntry
	pop de
	dec b
	jr nz, .loopAgain
	pop de
	inc de
	inc de
	pop bc
	dec c
	jr nz, .loopPixelDifferentials
	ret

InitFourTimesFourPoofAnim:
	call LoadPoofOAM4Times
	ld hl, wShadowOAMSprite00Attributes
	call LoadCircularAttributes
	ld hl, wShadowOAMSprite00YCoord
	ld de, FourTimesFourPoofCoords
	jp PoofLoadOAMCoordList

LoadCircularAttributes:
	ld b, 4
	ld c, 4
.loopCircularAttributes
	push bc
.loop
	push bc
	dec c
	ld a, OAM_VFLIP | OAM_HFLIP
	jr z, .gotAttributes
	dec c
	ld a, OAM_VFLIP
	jr z, .gotAttributes
	dec c
	ld a, OAM_HFLIP
	jr z, .gotAttributes
	xor a
.gotAttributes
	ld [hl], a
	call GoToNextOAMEntry4
	pop bc
	dec b
	jr nz, .loop
	pop bc
	dec c
	jr nz, .loopCircularAttributes
	ret

LoadPoofOAM4Times:
	ld hl, wShadowOAMSprite00TileID
	ld b, 4
.loopLoadOAMBTimes
	push de
	ld c, 4
.loopLoadTileIDs
	ld a, [de]
	inc de
	ld [hl], a
	call GoToNextOAMEntry4
	dec c
	jr nz, .loopLoadTileIDs
	pop de
	dec b
	jr nz, .loopLoadOAMBTimes
	ret

FirstFrameTileIDOrder:
	db $50, $56, $55, 0

FourTimesFourPoofCoords:
	db 84, 36
	db 92, 36
	db 92, 28
	db 84, 28
	db 84, 44
	db 92, 44
	db 92, 52
	db 84, 52
	db 108, 36
	db 100, 36
	db 100, 28
	db 108, 28
	db 108, 44
	db 100, 44
	db 100, 52
	db 108, 52
	db -1

SecondFrameTileIDOrder:
	db $4E, $54, $53, $4D

ThirdFramePixelDifferentials:
	db -4, -4
	db -4, 4
	db  4, -4
	db  4, 4

FourthFrameTileIDOrder:
	db $52, 0, $57, $51

ExplodePoofAnim:
	ld hl, vSprites tile $4D
	ld de, MoveAnimationTiles1 tile 34
	lb bc, BANK(MoveAnimationTiles1), 4
	call CopyVideoData
	ld hl, vSprites tile $51
	ld de, MoveAnimationTiles1 tile 50
	lb bc, BANK(MoveAnimationTiles1), 4
	call CopyVideoData
	ld hl, vSprites tile $55
	ld de, MoveAnimationTiles1 tile 67
	lb bc, BANK(MoveAnimationTiles1), 1
	call CopyVideoData
	ld b, 2
.loop
	push bc
	ld de, ExplodeFirstFrameTileIDOrder
	call InitFourTimesFourPoofAnim
	call BallPoofDelay2Frames
	ld de, ExplodeSecondFrameTileIDOrder
	call LoadPoofOAM4Times
	call BallPoofDelay2Frames
	ld de, ExplodeThirdFrameTileIDOrder
	call LoadPoofOAM4Times
	call BallPoofDelay2Frames
	call HideAnimationOAMEntries
	ld c, 8
	call BallPoofDelayFrames
	pop bc
	dec b
	jr nz, .loop
	ret

ExplodeFirstFrameTileIDOrder:
	db 0, $52, 0, 0

ExplodeSecondFrameTileIDOrder:
	db $4E, $55, $51, $4D

ExplodeThirdFrameTileIDOrder:
	db $50, $54, $53, $4F

PlayPoofSFX:
	ld hl, PoofSFXChoices
	ld d, 0
	ld e, a
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	cp $FF
	jr z, .soundFunc
	ld [wTempoModifier], a
	ld a, [hli]
	ld [wFrequencyModifier], a
	ld a, [hl]
	rst _PlaySound
	ret
.soundFunc
	hl_deref
	jp hl

PlayIcePoofSFX:
	lb bc, 0, SFX_BATTLE_1E
	ld de, SFX_Short_Ball_Poof_Ch8
	push de
	ld de, SFX_Ice_Poof_Ch5
	push de
	xor a
	jr PoofRemapChan5Chan8

PlayWaterPoofSFX:
	lb bc, 0, SFX_BATTLE_24
	ld de, SFX_Battle_Water_Poof_Ch8
	push de
	ld de, SFX_Battle_Water_Poof_Ch5
	push de
	ld a, 15
	jr PoofRemapChan5Chan8

PlayHeartsPoofSFX:
	lb bc, $80, SFX_BATTLE_24
	ld de, SFX_Short_Ball_Poof_Ch8
	push de
	ld de, SFX_Hearts_Poof_Ch5
	push de
	xor a
	; fall through
PoofRemapChan5Chan8:
	ld [wFrequencyModifier], a
	ld a, b
	ld [wTempoModifier], a
	ld a, c
	rst _PlaySound
	ld hl, wChannelCommandPointers + CHAN5 * 2
	pop de
	call RemapSoundChannel
	ld hl, wChannelCommandPointers + CHAN8 * 2
	pop de
	jp RemapSoundChannel

PlaySparklePoofSFX:
	lb bc, $80, SFX_BATTLE_34
	ld de, SFX_Short_Ball_Poof_Ch8
	push de
	ld de, SFX_Sparkle_Poof_Ch6
	push de
	ld de, SFX_Sparkle_Poof_Ch5
	push de
	xor a
	jr PoofRemapChan5Chan6Chan8


PlayLightningStrikePoofSFX:
	lb bc, 0, SFX_BATTLE_34
	ld de, SFX_Battle_Lightning_Strike_Poof_Ch8
	push de
	ld de, SFX_Battle_Lightning_Strike_Poof_Ch6
	push de
	ld de, SFX_Battle_Lightning_Strike_Poof_Ch5
	push de
	ld a, 20
	jr PoofRemapChan5Chan6Chan8

PlayPsychicPoofSFX:
	lb bc, $20, SFX_BATTLE_36
	ld de, SFX_Psychic_Ball_Poof_Ch8
	push de
	ld de, SFX_Psychic_Ball_Poof_Ch6
	push de
	ld de, SFX_Psychic_Ball_Poof_Ch5
	push de
	xor a
	jr PoofRemapChan5Chan6Chan8

PlayGhostWhirlSFX:
	ld a, 65
	jr PlayElectricWhirlSFX.next

PlayElectricWhirlSFX:
	ld a, 70
.next
	lb bc, 0, SFX_BATTLE_27
	ld de, SFX_Electric_Whirl_Poof_Ch8
	push de
	ld de, SFX_Electric_Whirl_Poof_Ch6
	push de
	ld de, SFX_Electric_Whirl_Poof_Ch5
	push de
	jr PoofRemapChan5Chan6Chan8

PlayPoisonWhirlPoofSFX:
	lb bc, 0, SFX_BATTLE_2A
	ld de, SFX_Poison_Whirl_Poof_Ch8
	push de
	ld de, SFX_Poison_Whirl_Poof_Ch6
	push de
	ld de, SFX_Poison_Whirl_Poof_Ch5
	push de
	ld a, 15
	; fall through
PoofRemapChan5Chan6Chan8:
	ld [wFrequencyModifier], a
	ld a, b
	ld [wTempoModifier], a
	ld a, c
	rst _PlaySound
	ld hl, wChannelCommandPointers + CHAN5 * 2
	pop de
	call RemapSoundChannel
	inc hl
	pop de
	call RemapSoundChannel
	pop de
.only8
	ld hl, wChannelCommandPointers + CHAN8 * 2
	jp RemapSoundChannel

PlayWindPoofSFX:
	ld a, SFX_BATTLE_13
	call PlaySoundResetSFXModifiers
	ld de, SFX_Wind_Poof_Ch8
	jr PoofRemapChan5Chan6Chan8.only8

PoofSFXChoices:
	db 0, 0, SFX_BALL_POOF
	dbw $FF, PlayWindPoofSFX ; tornado -> flying -> grass?
	db 0, 235, SFX_NOT_VERY_EFFECTIVE ; cut ? -> good  -> fighting sort of -> bug sort of
	db 0, 5, SFX_NOT_VERY_EFFECTIVE ; whoosh -> good
	db 0, 25, SFX_SUPER_EFFECTIVE ; rock slam -> good -> fire sort of -> fighting sort of -> rock
	dbw $FF, PlayHeartsPoofSFX ; cute sound -> normal
	dbw $FF, PlayWaterPoofSFX ; water gun -> okay -> water
	db $60, 125, SFX_BATTLE_33 ; recover -> good
	dbw $FF, PlayPsychicPoofSFX ; psychic waves -> psychic
	dbw $FF, PlayGhostWhirlSFX ; ghost
	dbw $FF, PlayIcePoofSFX
	dbw $FF, PlayElectricWhirlSFX ; electric swirl -> ground -> electric
	dbw $FF, PlayPoisonWhirlPoofSFX ; poison whirl -> poison -> water
	db 0, 15, SFX_BATTLE_34 ; explode deep -> good -> fire sort of
	dbw $FF, PlayLightningStrikePoofSFX ; lightning strike -> good -> electric
	dbw $FF, PlaySparklePoofSFX ; grass -> 
	db -1

BallPoofDelay2Frames:
	call BallPoofDelayFrame
	jp BallPoofDelayFrame

BallPoofDelayFrame:
	call BallPoofDelayFrameColorCheck
	rst _DelayFrame
	ret

BallPoofDelay3:
	ld c, 3
BallPoofDelayFrames:
	call BallPoofDelayFrame
	dec c
	jr nz, BallPoofDelayFrames
	ret

BallPoofDelayFrameColorCheck:
	ld a, [wBallAnimFrameCounter]
	inc a
	ld [wBallAnimFrameCounter], a
	ld a, [wBallAnimPalette]
	cp PAL_PRISMATIC
	ret nz
	push hl
	push de
	push bc
	call TransferBallAnimPalette
	pop bc
	pop de
	pop hl
	ret

FarBallAnimCheckForcePokeball::
	ld a, d
	call BallAnimCheckForcePokeball
	ld d, a
	ret

BallAnimCheckForcePokeball:
	CheckEventHL FLAG_BALL_DESIGNER_TURNED_OFF
	jr z, .continue
	cp FIRST_CUSTOM_BALL_DATA_CONST
	jr nc, .forcePokeball
.continue
	cp PAST_LAST_CUSTOM_BALL_DATA_CONST
	ret c
.forcePokeball
	xor a ; force pokeball if invalid value
	ret

; sine / cosine code from pokecrystal

MACRO sine_table
; \1 samples of sin(x) from x=0 to x<0.5 turns (pi radians)
	for x, \1
		dw sin(x * 0.5 / (\1))
	endr
ENDM

MACRO calc_sine_wave
; input: a = a signed 6-bit value
; output: a = d * sin(a * pi/32)
	and %111111
	cp %100000
	jr nc, .negative\@
	call .apply\@
	ld a, h
	ret
.negative\@
	and %011111
	call .apply\@
	ld a, h
	xor $ff
	inc a
	ret
.apply\@
	ld e, a
	ld a, d
	ld d, 0
if _NARG == 1
	ld hl, \1
else
	ld hl, .sinetable\@
endc
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, 0
.multiply\@ ; factor amplitude
	srl a
	jr nc, .even\@
	add hl, de
.even\@
	sla e
	rl d
	and a
	jr nz, .multiply\@
	ret
if _NARG == 0
.sinetable\@
	sine_table 32
endc
ENDM

BattleAnim_Cosine:
; a = d * cos(a * pi/32)
	add %010000 ; cos(x) = sin(x + pi/2)
	; fallthrough
BattleAnim_Sine:
; a = d * sin(a * pi/32)
	calc_sine_wave

	; maybe
	;db 254, 25, SFX_HORN_DRILL ; vortex -> good -> grass?
	;db 0, 10, SFX_SUPER_EFFECTIVE ; burst / fire -> good but too similar to rock slam
	;db 0, 20, SFX_VINE_WHIP ; explode
	;db 0, 60, SFX_NOT_VERY_EFFECTIVE ; explode
	;db 0, 20, SFX_SUPER_EFFECTIVE ; rock
	;db 0, 45, SFX_NOT_VERY_EFFECTIVE ; explode
	;db 0, 30, SFX_BATTLE_0E ; cut ? 
	;db 0, 25, SFX_NOT_VERY_EFFECTIVE ; cut ?
	;db 0, 178, SFX_SUPER_EFFECTIVE ; wind? - combine with poof
	;db $30, $FF, SFX_NOT_VERY_EFFECTIVE ; Poison gas
	;db 0, 225, SFX_BATTLE_0F ; guillotine
	; no
	;db 0, 15, SFX_ICE ; ice -> too long  remove
	;db 0, 65, SFX_BATTLE_27 ; ghost sounds -> too long remove
	;db 0, 35, SFX_BATTLE_13 ; fire -> crap
	;db 0, 2, SFX_BATTLE_36 ; hyper beam
	;db 0, 20, SFX_BATTLE_35 ; sing
	;db 0, 100, SFX_DAMAGE ; quick snap
	;db 0, 70, SFX_VINE_WHIP ; cut?
	;db 0, 230, SFX_BATTLE_12 ; bells
	;db 0, 35, SFX_BATTLE_0F ; rocks falling
	;db 0, 75, SFX_NOT_VERY_EFFECTIVE ; explode
	;db 0, 60, SFX_BATTLE_27 ; rock whirl
	;db 0, 35, SFX_BATTLE_0E
	;db 0, 20, SFX_BATTLE_25 ; fire whirl up
	;db 0, 20, SFX_BATTLE_12 ; tornado repeat?
	;db 0, 250, SFX_DAMAGE ; quick cut
	;db 0, 40, SFX_HORN_DRILL ; vortex
	;db 0, 20, SFX_NOT_VERY_EFFECTIVE ; whoosh
	;db 0, 80, SFX_ACID_ARMOR
	;db 0, 70, SFX_ACID_ARMOR
	;db 0, 0, SFX_BATTLE_27  ; supersonic
	;db 0, 25, SFX_BATTLE_25 ; rock whirl
	;db 0, 75, SFX_BATTLE_0C
	;db 0, 55, SFX_BATTLE_0D
	;db 0, 10, SFX_BATTLE_12 ; cut ?
	;db 0, 45, SFX_BATTLE_1C ; cut?


;SFXTestValues:
;	;db 0, 0, SFX_BATTLE_34 ; explode standard
;
;LoopTestSFX2:
;	call StopAllMusic
;	ld hl, PoofSFXChoices
;.loopSFX
;	ld a, [hl]
;	cp -1
;	ret z
;.replay
;	push hl
;	ld a, [hli]
;	ld [wTempoModifier], a
;	ld a, [hli]
;	ld [wFrequencyModifier], a
;	ld a, [hl]
;	rst _PlaySound
;	hlcoord 2, 2
;	ld de, wTempoModifier
;	lb bc, 1 | LEADING_ZEROES , 3
;	call PrintNumber
;	hlcoord 2, 4
;	ld de, wFrequencyModifier
;	lb bc, 1 | LEADING_ZEROES, 3
;	call PrintNumber
;	hlcoord 2, 6
;	ld de, wSoundID
;	lb bc, 1 | LEADING_ZEROES, 3
;	call PrintNumber
;	call WaitForTextScrollButtonPress 
;	pop hl
;	ldh a, [hJoy5]
;	bit BIT_B_BUTTON, a
;	jr nz, .replay
;	inc hl
;	inc hl
;	inc hl
;	jr .loopSFX

;LoopTestSFX::
;	call StopAllMusic
;	ld hl, SFXList
;.loopSFX
;	ld a, [hl]
;	cp -1
;	ret z
;	ld c, 0
;	ld b, 0
;.loopFrequencies
;.replay
;	ld a, b
;	ld [wTempoModifier], a
;	ld a, c
;	ld [wFrequencyModifier], a
;	push hl
;	push bc
;	ld a, [hl]
;	rst _PlaySound
;	hlcoord 2, 2
;	ld de, wTempoModifier
;	lb bc, 1 | LEADING_ZEROES , 3
;	call PrintNumber
;	hlcoord 2, 4
;	ld de, wFrequencyModifier
;	lb bc, 1 | LEADING_ZEROES, 3
;	call PrintNumber
;	hlcoord 2, 6
;	ld de, wSoundID
;	lb bc, 1 | LEADING_ZEROES, 3
;	call PrintNumber
;	call WaitForTextScrollButtonPress 
;	pop bc
;	pop hl
;	ldh a, [hJoy5]
;	bit BIT_B_BUTTON, a
;	jr nz, .replay
;	inc c
;	ld a, c
;	;cp 75
;	;jr nz, .loopFrequencies
;	inc hl
;	jr .loopSFX
;
;SFXList:
;	db  SFX_BATTLE_27
;	db  SFX_PSYCHIC_M
;	db  SFX_BATTLE_36 ; 220
;	db  SFX_BATTLE_0C
;	db  SFX_BATTLE_0D
;	db  SFX_BATTLE_0E
;	db  SFX_BATTLE_0F
;	db  SFX_DAMAGE
;	db  SFX_NOT_VERY_EFFECTIVE
;	db  SFX_BATTLE_12
;	db  SFX_BATTLE_13
;	db  SFX_VINE_WHIP
;	db  SFX_BATTLE_19
;	db  SFX_SUPER_EFFECTIVE
;	db  SFX_BATTLE_1C
;	db  SFX_HORN_DRILL
;	db  SFX_BATTLE_22
;	db  SFX_BATTLE_24
;	db  SFX_BATTLE_25
;	db  SFX_BATTLE_26
;	db  SFX_BATTLE_28
;	db  SFX_BATTLE_2A
;	db  SFX_BATTLE_29
;	db  SFX_BATTLE_2B
;	db  SFX_PSYBEAM ; ?
;	db  SFX_BATTLE_2F
;	db  SFX_BATTLE_32 ; defense curl sound
;	db  SFX_BATTLE_33 ; recover sound
;	db  SFX_BATTLE_34 ; explosion 225
;	db  SFX_BATTLE_35 ; sing 40
;	db -1

;AnimationTestList:
;	; fire
;	dn BALL_TILE_FIRE, BALL_COLOR_RED, BALL_THROW_VIBRATE, BALL_SFX_EXPLODE, BALL_POOF_CIRCLE_SPREAD, 0
;	; water
;	dn BALL_TILE_DROPLET, BALL_COLOR_BLUE, BALL_THROW_DROP, BALL_SFX_SQUIRT, BALL_POOF_GRAVITY, 0 
;	; grass
;	dn BALL_TILE_LEAF, BALL_COLOR_GREEN, BALL_THROW_ROLL, BALL_SFX_WHOOSH, BALL_POOF_CIRCLE_SPREAD, 0 
;	; electric
;	dn BALL_TILE_BOLT, BALL_COLOR_YELLOW, BALL_THROW_ZIGZAG, BALL_SFX_THUNDER, BALL_POOF_STRIKE, %0001
;	; ice
;	dn BALL_TILE_CRYSTAL, BALL_COLOR_CYAN, BALL_THROW_SHAKE, BALL_SFX_ICY, BALL_POOF_SPECKLE, 0
;	; psychic
;	dn BALL_TILE_EYE, BALL_COLOR_PINK, BALL_THROW_THE_MERGING, BALL_SFX_PSY, BALL_POOF_WINDMILL , 0 
;	; ghost
;	dn BALL_TILE_GHOST, BALL_COLOR_PURPLE, BALL_THROW_THE_MERGING, BALL_SFX_EVIL, BALL_POOF_TORNADO, %0001
;	; bug
;	dn BALL_TILE_SWORD, BALL_COLOR_GREENYELLOW, BALL_THROW_SLICE, BALL_SFX_SHWING, BALL_POOF_CRISSCROSS, 0
;	; rock
;	dn BALL_TILE_ROCK, BALL_COLOR_GRAY, BALL_THROW_BOUNCE, BALL_SFX_SMASH, BALL_POOF_GRAVITY, 0
;	; ground
;	dn BALL_TILE_CONE, BALL_COLOR_PALE, BALL_THROW_APPEAR, BALL_SFX_MACHINE, BALL_POOF_HELIX, 0
;	; poison
;	dn BALL_TILE_DROPLET, BALL_COLOR_PURPLE, BALL_THROW_THROW, BALL_SFX_FLOOD, BALL_POOF_SPREAD, 0
;	; flying
;	dn BALL_TILE_CONE, BALL_COLOR_GRAY, BALL_THROW_FAKEOUT, BALL_SFX_WIND, BALL_POOF_TORNADO, 0
;	; dragon
;	dn BALL_TILE_SKULL, BALL_COLOR_INDIGO, BALL_THROW_SHAKE, BALL_SFX_POWER_UP, BALL_POOF_CIRCLE_SPREAD, 0
;	; cute
;	dn BALL_TILE_HEART, BALL_COLOR_PINK, BALL_THROW_EMOTION, BALL_SFX_CUTE, BALL_POOF_CIRCLE_AROUND, 0
;	; flower
;	;dn BALL_TILE_LEAF, BALL_COLOR_PINK, BALL_THROW_DROP, BALL_SFX_SPARKLE, BALL_POOF_CONFETTI, 0
;	; shine
;	dn BALL_TILE_SHINE, BALL_COLOR_YELLOW, BALL_THROW_ANGELIC, BALL_SFX_SHWING, BALL_POOF_CONFETTI, %0010
;	; explosion
;	dn BALL_TILE_SPHERE, BALL_COLOR_BLACK, BALL_THROW_FLASH, BALL_SFX_EXPLODE, BALL_POOF_EXPLOSION, 0
;
;	db -1