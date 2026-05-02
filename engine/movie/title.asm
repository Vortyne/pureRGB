_PrepareTitleScreen::
	xor a
	ldh [hWY], a
	ld [wLetterPrintingDelayFlags], a
	ld hl, wStatusFlags6
	ld [hli], a
	ASSERT wStatusFlags6 + 1 == wStatusFlags7
	ld [hli], a
	ASSERT wStatusFlags7 + 1 == wElite4Flags
	ld [hl], a
	ld a, BANK(Music_TitleScreen)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a

_DisplayTitleScreen::
	call GBPalWhiteOut
	ld a, $1
	ldh [hAutoBGTransferEnabled], a
	xor a
	ldh [hTileAnimations], a
	ldh [hSCX], a
	ld a, $40
	ldh [hSCY], a
	ld a, $90
	ldh [hWY], a
	call ClearScreen
	call DisableLCD
	call LoadFontTilePatterns
	ld hl, NintendoCopyrightLogoGraphics
	ld de, vTitleLogo2 tile 16
	ld bc, 5 tiles
	ld a, BANK(NintendoCopyrightLogoGraphics)
	call FarCopyData2
	ld hl, GameFreakLogoGraphics
	ld de, vTitleLogo2 tile (16 + 5)
	ld bc, 9 tiles
	ld a, BANK(GameFreakLogoGraphics)
	call FarCopyData2
	ld hl, PokemonLogoGraphics
	ld de, vTitleLogo
	ld bc, $60 tiles
	ld a, BANK(PokemonLogoGraphics)
	call FarCopyData2          ; first chunk
	ld hl, PokemonLogoGraphics tile $60
	ld de, vTitleLogo2
	ld bc, $10 tiles
	ld a, BANK(PokemonLogoGraphics)
	call FarCopyData2          ; second chunk
	call IsPureTitleScreenEnabled
	jr nz, .skipOGGraphics

	ld hl, Version_GFX
	ld de, vChars1 tile $60
	ld bc, Version_GFXEnd - Version_GFX
	ld a, BANK(Version_GFX)
	call FarCopyDataDouble
	jr .skipPureGraphics

.skipOGGraphics
	ld hl, Version_GFX_Pure
	ld de, vChars1 tile $60
	ld bc, Version_GFX_PureEnd - Version_GFX_Pure
	ld a, BANK(Version_GFX_Pure)
	call FarCopyData2
IF DEF(_RED)
	ld hl, MoveAnimationTiles1 tile 4
	ld de, vSprites tile $40
	call CopyFromBattleAnim1

	ld hl, MoveAnimationTiles1 tile 20
	ld de, vSprites tile $42
	call CopyFromBattleAnim1

	ld hl, MoveAnimationTiles1 tile 65
	ld de, vSprites tile $44
	call CopyFromBattleAnim1

	ld hl, CharizardBlinking
	ld de, vChars2 tile $7A
	ld bc, 3 tiles
	ld a, BANK(CharizardBlinking)
	call FarCopyData2
ENDC
IF DEF(_BLUE)
	ld hl, MoveAnimationTiles0 tile 4
	ld de, vSprites tile $40
	call CopyFromBattleAnim0

	ld hl, MoveAnimationTiles0 tile 20
	ld de, vSprites tile $42
	call CopyFromBattleAnim0

	ld hl, MoveAnimationTiles0 tile 64
	ld de, vSprites tile $44
	ld bc, 3 tiles
	call CopyFromBattleAnim0_2

	ld a, [wSpriteOptions]
	bit BIT_BLASTOISE_SPRITE, a
	ld hl, BlastoiseBlinking1
	jr z, .gotSprite
	ld hl, BlastoiseBlinking2
.gotSprite
	ld de, vChars2 tile $7A
	ld bc, 5 tiles
	ld a, BANK(BlastoiseBlinking1)
	ASSERT BANK(BlastoiseBlinking1) == BANK(BlastoiseBlinking2)
	call FarCopyData2
ENDC
IF DEF(_GREEN)
	ld hl, ShineSprites tile 2
	ld de, vSprites tile $40
	ld bc, 4 tiles
	ld a, BANK(ShineSprites)
	call FarCopyData2

	ld hl, VenusaurBlinking
	ld de, vChars2 tile $7A
	ld bc, 3 tiles
	ld a, BANK(VenusaurBlinking)
	call FarCopyData2
ENDC

	ld hl, ShineSprites
	ld de, vSprites tile $7E
	ld bc, 2 tiles
	ld a, BANK(ShineSprites)
	call FarCopyData2

	;;;;
.skipPureGraphics
	call ClearBothBGMaps

; place tiles for pokemon logo (except for the last row)
	hlcoord 2, 1
	ld a, $80
	ld de, SCREEN_WIDTH
	ld c, 6
.pokemonLogoTileLoop
	ld b, $10
	push hl
.pokemonLogoTileRowLoop ; place tiles for one row
	ld [hli], a
	inc a
	dec b
	jr nz, .pokemonLogoTileRowLoop
	pop hl
	add hl, de
	dec c
	jr nz, .pokemonLogoTileLoop

; place tiles for the last row of the pokemon logo
	hlcoord 2, 7
	ld a, $31
	ld b, $10
.pokemonLogoLastTileRowLoop
	ld [hli], a
	inc a
	dec b
	jr nz, .pokemonLogoLastTileRowLoop

	call DrawPlayerCharacter

; put a pokeball in the player's hand
	ld hl, wShadowOAMSprite10
	ld [hl], $74

; place tiles for title screen copyright
	hlcoord 2, 17
	ld de, .tileScreenCopyrightTiles
	ld b, .tileScreenCopyrightTilesEnd - .tileScreenCopyrightTiles
.tileScreenCopyrightTilesLoop
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .tileScreenCopyrightTilesLoop

	jr .next

.tileScreenCopyrightTiles
	db $41,$42,$43,$42,$44,$42,$45,$46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E ; ©'95.'96.'98 GAME FREAK inc.
.tileScreenCopyrightTilesEnd

.next
	call SaveScreenTilesToBuffer2
	call LoadScreenTilesFromBuffer2
	call EnableLCD

	call IsPureTitleScreenEnabled  
	; which Pokemon to show first on the title screen
IF DEF(_RED)
	ld a, STARTER1
	jr z, .gotFirstMon
	ld a, CHARIZARD
.gotFirstMon
ENDC
IF DEF(_BLUE)
	ld a, STARTER2
	jr z, .gotFirstMon
	ld a, BLASTOISE
.gotFirstMon
ENDC
IF DEF(_GREEN) ; PureRGBnote: GREENBUILD: 
	ld a, STARTER3
	jr z, .gotFirstMon
	ld a, VENUSAUR
.gotFirstMon
ENDC
	ld [wTitleMonSpecies], a
	call LoadTitleMonSprite

	ld a, HIGH(vBGMap0 + $300)
	call TitleScreenCopyTileMapToVRAM
	call SaveScreenTilesToBuffer1
	ld a, $40
	ldh [hWY], a
	call LoadScreenTilesFromBuffer2
	ld a, HIGH(vBGMap0)
	call TitleScreenCopyTileMapToVRAM
	ld d, SET_PAL_TITLE_SCREEN
	call RunPaletteCommand
	call GBPalNormal
	ld a, %11100100
	ldh [rOBP0], a
	call UpdateGBCPal_OBP0 ; shinpokerednote: gbcnote: gbc color code from yellow 

	push de
	lb de, CONVERT_BGP, 2
	farcall TransferMonPal ; shinpokerednote: gbcnote: update the palette for the new title mon
	pop de

; make pokemon logo bounce up and down
	ld bc, hSCY ; background scroll Y
	ld hl, .TitleScreenPokemonLogoYScrolls
.bouncePokemonLogoLoop
	ld a, [hli]
	and a
	jr z, .finishedBouncingPokemonLogo
	ld d, a
	cp -3
	jr nz, .skipPlayingSound
	ld a, SFX_INTRO_CRASH
	rst _PlaySound
.skipPlayingSound
	ld a, [hli]
	ld e, a
	call .ScrollTitleScreenPokemonLogo
	jr .bouncePokemonLogoLoop

.TitleScreenPokemonLogoYScrolls:
; Controls the bouncing effect of the Pokemon logo on the title screen
	db -4,16  ; y scroll amount, number of times to scroll
	db 3,4
	db -3,4
	db 2,2
	db -2,2
	db 1,2
	db -1,2
	db 0      ; terminate list with 0

.ScrollTitleScreenPokemonLogo:
; Scrolls the Pokemon logo on the title screen to create the bouncing effect
; Scrolls d pixels e times
	rst _DelayFrame
	ld a, [bc] ; background scroll Y
	add d
	ld [bc], a
	dec e
	jr nz, .ScrollTitleScreenPokemonLogo
	ret

.finishedBouncingPokemonLogo
	call LoadScreenTilesFromBuffer1
	ld c, 36
	rst _DelayFrames
	call IsPureTitleScreenEnabled
	jr z, .skipNewTitleStuff1
	ld a, HIGH(vBGMap0)
	ldh [hAutoBGTransferDest + 1], a
	ld a, SCREEN_HEIGHT_PX
	ldh [hWY], a
	call DrawPlayerCharacterAgainAfterLogoAnimationBGTiles
	call Delay3
	call DrawPlayerCharacterAgainAfterLogoAnimationSpritePortion
	call PureTitleScreenVersionAnimation
	jr .skipOldTitleStuff1
.skipNewTitleStuff1
	ld a, SFX_INTRO_WHOOSH
	rst _PlaySound

; scroll game version in from the right
	call PrintGameVersionOnTitleScreen
	ld a, SCREEN_HEIGHT_PX
	ldh [hWY], a
	ld d, 144
.scrollTitleScreenGameVersionLoop
	ld h, d
	ld l, 64
	call ScrollTitleScreenGameVersion
	lb hl, 0, 80
	call ScrollTitleScreenGameVersion
	ld a, d
	add 4
	ld d, a
	and a
	jr nz, .scrollTitleScreenGameVersionLoop

	ld a, HIGH(vBGMap1)
	call TitleScreenCopyTileMapToVRAM
	call LoadScreenTilesFromBuffer2
	call PrintGameVersionOnTitleScreen
.skipOldTitleStuff1
	call Delay3
	call WaitForSoundToFinish
	ld a, MUSIC_TITLE_SCREEN
	ld [wNewSoundID], a
	rst _PlaySound

	call IsPureTitleScreenEnabled
	jr nz, .skipOldTitleStuff2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; shinpokerednote: gbcnote: The tiles in the window need to be shifted so that the bottom
;half of the title screen is in the top half of the window area.
;This is accomplished by copying the tile map to vram at an offset.
;The goal is to get the tile map for the bottom half of the title screen
;resides in the BGMap1 address space (address $9c00).
	ld a, (vBGMap0 + $300) / $100
	call TitleScreenCopyTileMapToVRAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Keep scrolling in new mons indefinitely until the user performs input.
.awaitUserInterruptionLoop
	ld c, 200
	call CheckForUserInterruption
	jr c, .finishedWaiting
	call TitleScreenScrollInMon
	ld c, 1
	call CheckForUserInterruption
	jr c, .finishedWaiting
	farcall TitleScreenAnimateBallIfStarterOut
	call TitleScreenPickNewMon
	jr .awaitUserInterruptionLoop

.skipOldTitleStuff2
	call PureTitleScreenLoop
.finishedWaiting
	call IsPureTitleScreenEnabled
	jr z, .skipNewTitleStuff3
	ld a, [wTitleMonSpecies]
	push af
	hlcoord $0C, $0A
	lb bc, 7, 4
	call ClearScreenArea
	call IsPureTitleScreenEnabled
	call DrawPlayerCharacterAgain ; temporarily make the player a sprite so they dont disappear for a moment
	ld hl, wShadowOAMSprite10TileID
	ld [hl], $6F ; make the duplicate pokeball hidden
	ld hl, wShadowOAMSprite15TileID
	ld [hl], $6F ; make the duplicate "hand" hidden
	call Delay3
	; load the "player pointing" tiles in
	ld hl, vChars2 tile $4F
	ld de, PureTitlePlayerSpritePointing
	lb bc, BANK(PureTitlePlayerSpritePointing), 7 * 6
	call CopyVideoData
	call DrawPlayerPointingSpriteBGTiles
	call ClearSprites
	ld a, SFX_INTRO_HOP
	rst _PlaySound
	call WaitForSoundToFinish
	ld c, 10
	rst _DelayFrames
	pop af
	ld [wTitleMonSpecies], a

.skipNewTitleStuff3
	ld a, [wTitleMonSpecies]
	call GetCryData
	rst _PlaySound
	call IsPureTitleScreenEnabled
	call nz, MakeTitlePokemonBlink
	call WaitForSoundToFinish
	call GBPalWhiteOutWithDelay3
	call ClearSprites
	xor a
	ldh [hWY], a
	inc a
	ldh [hAutoBGTransferEnabled], a
	call ClearScreen
	ld a, HIGH(vBGMap0)
	call TitleScreenCopyTileMapToVRAM
	ld a, HIGH(vBGMap1)
	call TitleScreenCopyTileMapToVRAM
	call Delay3
;;;;;;; PureRGBnote: FIXED: Prevents colors in the main menu from getting dark if player saved in a dark area 
;;;;;;; (rock tunnel) and went from title to continue screen twice
	call GBPalNormal
;;;;;;;
	ret

TitleScreenPickNewMon:
	ld a, HIGH(vBGMap0)
	call TitleScreenCopyTileMapToVRAM

.loop
; Keep looping until a mon different from the current one is picked.
	call Random
	and $f
	ld c, a
	ld b, 0
	ld hl, TitleMons
	add hl, bc
	ld a, [hl]
	ld hl, wTitleMonSpecies

; Can't be the same as before.
	cp [hl]
	jr z, .loop

	ld [hl], a
	call LoadTitleMonSprite
;;;;;;;;;; shinpokerednote: gbcnote: update the palette for the new title mon
	push de
	lb de, CONVERT_BGP, 2
	farcall TransferMonPal 
	pop de
;;;;;;;;;;

	ld a, $90
	ldh [hWY], a
	ld d, 1 ; scroll out
	farjp TitleScroll

TitleScreenScrollInMon:
	ld d, 0 ; scroll in
	farcall TitleScroll
	;xor a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; shinpokerednote: gbcnote: The window normally covers the whole screen when picking a new title screen mon.
;This is not desired since it applies BG pal 2 to the whole screen when on a gbc.
;Instead, shift the window downwards by 40 tiles to just cover the version text and below.
;This makes it so the map attributes for BGMap1 (address $9c00) are covering the bottom half 
;of the screen.
	ld a, $40
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldh [hWY], a
	ret

ScrollTitleScreenGameVersion:
	predef BGLayerScrollingUpdate ; shinpokerednote: gbcnote: consolidated into a predef that also fixes some issues
.wait2
	ldh a, [rLY]
	cp h
	jr z, .wait2
	ret

DrawPlayerCharacterForceOriginal:
	xor a
	jr DrawPlayerCharacter.continue

DrawPlayerCharacter:
	call IsPureTitleScreenEnabled
.continue
	push af
	ld hl, PlayerCharacterTitleGraphics
	ld de, vSprites
	ld bc, PlayerCharacterTitleGraphicsEnd - PlayerCharacterTitleGraphics
	ld a, BANK(PlayerCharacterTitleGraphics)
	call FarCopyData2
	pop af
	push af
	jr nz, .newTitle
	call ClearSprites
	pop af
	jr DrawPlayerCharacterAgain
.newTitle
	ld hl, PlayerCharacterTitleGraphics tile 1
	ld de, vChars2 tile $4F
	ld bc, PlayerCharacterTitleGraphicsEnd - PlayerCharacterTitleGraphics - 2
	ld a, BANK(PlayerCharacterTitleGraphics)
	call FarCopyData2
	pop af
DrawPlayerCharacterAgain:
	ld hl, wShadowOAM
	lb de, $60, $5A
	jr z, .continue
	lb de, $60, $60
.continue
	xor a
	ld [wPlayerCharacterOAMTile], a
	ld b, 7
.loop
	push de
	ld c, 5
.innerLoop
	ld a, d
	ld [hli], a ; Y
	ld a, e
	ld [hli], a ; X
	add 8
	ld e, a
	ld a, [wPlayerCharacterOAMTile]
	ld [hli], a ; tile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; shinpokerednote: gbcnote: set the palette for the player tiles
;These bits only work on the GBC
	push af
	ld a, [hl]	;Attributes/Flags
	and %11111000
	or  %00000010
	ld [hl], a
	pop af
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	inc a
	ld [wPlayerCharacterOAMTile], a
	inc hl
	dec c
	jr nz, .innerLoop
	pop de
	ld a, 8
	add d
	ld d, a
	dec b
	jr nz, .loop
	ret

DrawPlayerCharacterAgainAfterLogoAnimationSpritePortion:
	call ClearSprites
	ld hl, wShadowOAMSprite38
	ld de, PureTitlePlayerSpritePortionOAMData
.outerLoop
	ld b, 3
.innerLoop
	ld a, [de]
	cp -1
	ret z
	inc de
	ld [hli], a
	dec b
	jr nz, .innerLoop
	ld a, 2 ; 2nd palette
	ld [hli], a
	jr .outerLoop

DrawPlayerCharacterAgainAfterLogoAnimationBGTiles:
	lb bc, 7, 4
	; copy the non-sprite tiles of the player
	hlcoord $0C, $0A
	ld a, $4F ; start at tile 4f
	ld b, 7
.outerLoop2
	; 4 background tiles per row in the tilemap
	ld c, 4
.innerLoop2
	ld [hli], a
	inc a
	dec c
	jr nz, .innerLoop2
	; skip the extra sprite tile
	inc a
	; navigate to the next row in the tilemap
	ld de, SCREEN_WIDTH - 4
	add hl, de
	dec b
	jr nz, .outerLoop2
	ret

DrawPlayerPointingSpriteBGTiles:
	lb bc, 7, 6
	; copy the non-sprite tiles of the player
	hlcoord $0C, $0A
	ld a, $4F ; start at tile 4f
	ld b, 7
.outerLoop2
	; 6 background tiles per row in the tilemap
	ld c, 6
.innerLoop2
	ld [hli], a
	inc a
	dec c
	jr nz, .innerLoop2
	; navigate to the next row in the tilemap
	ld de, SCREEN_WIDTH - 6
	add hl, de
	dec b
	jr nz, .outerLoop2
	ret

ClearBothBGMaps:
	ld hl, vBGMap0
	ld bc, 2 * TILEMAP_AREA
	ld a, ' '
	jp FillMemory

LoadTitleMonSprite:
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	hlcoord 5, 10
	call GetMonHeader
	jp LoadFrontSpriteByMonIndex

TitleScreenCopyTileMapToVRAM:
	ldh [hAutoBGTransferDest + 1], a
	jp Delay3

LoadCopyrightAndTextBoxTiles:
	xor a
	ldh [hWY], a
	call ClearScreen
	call LoadTextBoxTilePatterns

LoadCopyrightTiles:
	ld de, NintendoCopyrightLogoGraphics
	ld hl, vChars2 tile $60
	lb bc, BANK(NintendoCopyrightLogoGraphics), (GameFreakLogoGraphicsEnd - NintendoCopyrightLogoGraphics) / TILE_SIZE
	call CopyVideoData
	hlcoord 2, 7
	ld de, CopyrightTextString
	jp PlaceString

CopyrightTextString:
	db   $60,$61,$62,$61,$63,$61,$64,$7F,$65,$66,$67,$68,$69,$6A             ; ©'95.'96.'98 Nintendo
	next $60,$61,$62,$61,$63,$61,$64,$7F,$6B,$6C,$6D,$6E,$6F,$70,$71,$72     ; ©'95.'96.'98 Creatures inc.
	next $60,$61,$62,$61,$63,$61,$64,$7F,$73,$74,$75,$76,$77,$78,$79,$7A,$7B ; ©'95.'96.'98 GAME FREAK inc.
	db   "@"

INCLUDE "data/pokemon/title_mons.asm"

; prints version text (red, blue)
PrintGameVersionOnTitleScreen:
	IF DEF(_GREEN) ; PureRGBnote: GREENBUILD: version text needs to be slightly moved to the left due to the larger length
		hlcoord 6, 8 
	ELSE
		hlcoord 7, 8
	ENDC
	ld de, VersionOnTitleScreenText
	jp PlaceString

; these point to special tiles specifically loaded for that purpose and are not usual text
VersionOnTitleScreenText:
IF DEF(_RED)
	db $E0,$E1,$7F,$E5,$E6,$E7,$E8,$E9,"@" ; "Red Version"
ENDC
IF DEF(_BLUE)
	db $E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7,"@" ; "Blue Version"
ENDC
IF DEF(_GREEN) ; PureRGBnote: GREENBUILD: different title screen subtitle text for green version
	db $E2,$E3,$E4,$7F,$E5,$E6,$E7,$E8,$E9,"@" ; "Green Version"
ENDC

; In the PureRGB title screen, we will make the player's image only partially a sprite to free up space in OAM
; This prevents sliding pokemon across the screen behind the player at the moment (may change later)

PureTitlePlayerSpritePortionOAMData:
	db $74, $60, $0A 
	db $78, $60, $0F 
	db -1

PureTitleScreenVersionAnimation:
IF DEF(_RED)
	ld b, BANK(SFX_Battle_29)
	call MuteAudioAndChangeAudioBank
	ld a, $1F
	ld [wFrequencyModifier], a
	ld a, $20
	ld [wTempoModifier], a
	ld a, SFX_BATTLE_29
	rst _PlaySound
	ld hl, PureRedVersionAnimationFireOAM
	ld de, wShadowOAMSprite00
	ld bc, 16
	rst _CopyData
	lb de, 72, 56
	ld c, 0
	callfar LoadSpecificOAMSpriteCoords
	lb de, 72, 56
	ld b, 3
.loopAnimateFire
	inc e
	ld c, 0
	ld a, b
	and %11
	call z, .nextFireFrame
	ld a, b
	and %111
	call z, PureTitleDrawNextVersionLogoColumn
	push de
	push bc
	callfar LoadSpecificOAMSpriteCoords
	pop bc
	pop de
	rst _DelayFrame
	inc b
	ld a, b
	cp 59 ; 56 frames of movement
	jr nz, .loopAnimateFire
	call PureTitleClearNonPlayerOAM
	ld c, 22
	rst _DelayFrames
	call StopAllMusic
	call Delay3
	;callfar PlaySparkleShort
	call PureTitleShineGoesAcrossVersion
	call UnmuteAudioAndRestoreAudioBank
	ret
.nextFireFrame
	push bc
	push de
	ld a, [wShadowOAMSprite00TileID]
	cp $40
	ld hl, PureRedVersionAnimationFireOAMFrame2
	jr z, .gotSet
	ld hl, PureRedVersionAnimationFireOAM
.gotSet
	ld de, wShadowOAMSprite00
	ld bc, 16
	rst _CopyData
	pop de
	pop bc
	ret
ENDC
IF DEF(_BLUE)
	ld b, BANK(SFX_Battle_2A)
	call MuteAudioAndChangeAudioBank
	xor a
	ld [wFrequencyModifier], a
	ld a, $80
	ld [wTempoModifier], a
	ld a, SFX_BATTLE_2A
	rst _PlaySound
	lb de, 80, 64
	ld hl, wShadowOAMSprite08
	ld [hl], d
	inc hl
	ld [hl], e
	inc hl
	ld [hl], $45
	inc hl
	ld [hl], 1
	ld hl, PureBlueVersionAnimationPumpOAM
	ld de, wShadowOAMSprite00
	ld bc, 16
	rst _CopyData
	lb de, 72, 60
	ld c, 0
	callfar LoadSpecificOAMSpriteCoords
	ld b, 7 ; 7 tiles to animate across
.loopAnimateWater
	ld c, 10 ; 10 frames per tile
.innerLoopAnimateWater
	ld a, c
	cp 5
	jr c, .last5Frames
	; first 5 frames, raise water
	dec d
	jr .continue
.last5Frames
	; last 5 frames, lower water
	inc d
.continue
	push bc
	push de
	ld c, 0
	callfar LoadSpecificOAMSpriteCoords
	rst _DelayFrame
	pop de
	pop bc
	dec c
	jr nz, .innerLoopAnimateWater
	call .nextWaterFrame
	ld a, [wShadowOAMSprite08XCoord]
	add 8
	ld [wShadowOAMSprite08XCoord], a
	ld a, e
	add 8
	ld e, a
	ld d, 71
	call PureTitleDrawNextVersionLogoColumn
	dec b
	jr nz, .loopAnimateWater
	call PureTitleClearNonPlayerOAM
	call WaitForSoundToFinish
	;callfar PlaySparkleShort
	call PureTitleShineGoesAcrossVersion
	call UnmuteAudioAndRestoreAudioBank
	ret
.nextWaterFrame
	push bc
	push de
	ld a, [wShadowOAMSprite00TileID]
	cp $40
	ld hl, PureBlueVersionAnimationPumpOAMFrame2
	ld a, $46
	jr z, .gotSet
	ld hl, PureBlueVersionAnimationPumpOAM
	ld a, $45
.gotSet
	ld de, wShadowOAMSprite08TileID
	ld [de], a
	ld de, wShadowOAMSprite00
	ld bc, 16
	rst _CopyData
	pop de
	pop bc
	ret
ENDC
IF DEF(_GREEN)
	ld b, BANK(SFX_Battle_2E)
	call MuteAudioAndChangeAudioBank
	xor a
	ld [wFrequencyModifier], a
	ld a, $80
	ld [wTempoModifier], a
	ld a, SFX_BATTLE_2E
	rst _PlaySound
	ld hl, PureGreenVersionAnimationEnergyOAM
	ld de, wShadowOAMSprite00
	ld bc, 48
	rst _CopyData
	lb de, 74, 56
	ld c, 0
	callfar LoadSpecificOAMSpriteCoords
	lb de, 74, 56
	ld c, 4
	callfar LoadSpecificOAMSpriteCoords
	call .initSecondaryEnergyBalls
	ld b, 1
	lb de, 74, 56
.loopMoveEnergy
	ld a, b
	and %111
	call z, PureTitleDrawNextVersionLogoColumn
	inc e
	push bc
	push de
	ld c, 0
	callfar LoadSpecificOAMSpriteCoords
	pop de
	push de
	ld c, 4
	callfar LoadSpecificOAMSpriteCoords
	pop de
	pop bc
	call .moveSecondaryEnergyBalls
	ld a, b
	and %1111
	dec a
	call z, .initSecondaryEnergyBalls
	rst _DelayFrame
	inc b
	ld a, b
	cp 65
	jr nz, .loopMoveEnergy
	call PureTitleClearNonPlayerOAM
	ld c, 12
	rst _DelayFrames
	call StopAllMusic
	call Delay3
	;callfar PlaySparkleShort
	call PureTitleShineGoesAcrossVersion
	call UnmuteAudioAndRestoreAudioBank
	ret
.moveSecondaryEnergyBalls
	ld hl, wShadowOAMSprite08YCoord
	inc [hl]
	inc hl
	inc [hl]
	inc [hl]
	ld hl, wShadowOAMSprite09YCoord
	inc [hl]
	ld hl, wShadowOAMSprite10YCoord
	dec [hl]
	inc hl
	inc [hl]
	inc [hl]
	ld hl, wShadowOAMSprite11YCoord
	dec [hl]
	ret
.initSecondaryEnergyBalls
	push de
	ld hl, wShadowOAMSprite00YCoord
	ld de, wShadowOAMSprite08YCoord
	ld a, [hli]
	sub 8
	ld [de], a
	inc de
	ld a, [hl]
	sub 8
	ld [de], a
	ld hl, wShadowOAMSprite01YCoord
	ld de, wShadowOAMSprite09YCoord
	ld a, [hli]
	sub 8
	ld [de], a
	inc de
	ld a, [hl]
	add 8
	ld [de], a
	ld hl, wShadowOAMSprite02YCoord
	ld de, wShadowOAMSprite10YCoord
	ld a, [hli]
	add 8
	ld [de], a
	inc de
	ld a, [hl]
	sub 8
	ld [de], a
	ld hl, wShadowOAMSprite03YCoord
	ld de, wShadowOAMSprite11YCoord
	ld a, [hli]
	add 8
	ld [de], a
	inc de
	ld a, [hl]
	add 8
	ld [de], a
	pop de
	ret
ENDC

PureTitleDrawNextVersionLogoColumn:
	push bc
	push de
IF DEF(_GREEN)
	ld b, $E8
ELSE
	ld b, $E7
ENDC
	hlcoord 7, 8
	ld a, [hli]
	cp $7F
	jr z, .firstOne
.loopFindCurrentLogoColumn
	inc b
	ld a, [hli]
	cp $7F
	jr nz, .loopFindCurrentLogoColumn
.firstOne
	dec hl
	ld [hl], b
	ld de, SCREEN_WIDTH
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	ld a, b
IF DEF(_GREEN)
	sub 8
ELSE
	sub 7
ENDC
	ld b, a
	ld [hl], b
	pop de
	pop bc
	ret

PureTitleShineGoesAcrossVersion:
	ld a, SFX_HEAL_AILMENT
	rst _PlaySound
	ld hl, StartingShineOAM
	ld de, wShadowOAMSprite00
	ld bc, 8
	rst _CopyData
IF DEF(_RED)
	ld b, 98 ; x value where shine disappears
ENDC
IF DEF(_BLUE)
	ld b, 100 ; x value where shine disappears
ENDC
IF DEF(_GREEN)
	ld b, 102 ; x value where shine disappears
ENDC
	ld c, 0
	ld hl, wShadowOAMSprite00XCoord
	ld d, [hl]
	ld hl, wShadowOAMSprite01XCoord
	ld e, [hl]
.loopShineAcross
	ld hl, wShadowOAMSprite00XCoord
	ld a, d
	cp b
	jr z, .doneShineAcross
	inc d
	ld a, c
	and %1
	ld [hl], d
	jr z, .noHide
	ld [hl], 0
.noHide
	ld hl, wShadowOAMSprite01XCoord
	ld a, e
	cp b
	jr nz, .noZeroing
	ld [hl], 0
	jr .noHide2
.noZeroing
	inc e
	ld a, c
	and %1
	ld [hl], e
	jr z, .noHide2
	ld [hl], 0
.noHide2
	rst _DelayFrame
	inc c
	jr .loopShineAcross
.doneShineAcross
	call PureTitleClearNonPlayerOAM
	ld c, 10
	rst _DelayFrames
	jp StopAllMusic

PureTitleClearNonPlayerOAM:
	ld hl, wShadowOAM
	ld bc, 38*4
	xor a
	jp FillMemory

PureTitleScreenLoop:
	; wait for the right part of the song to show the particles
	ld c, 240
	call CheckForUserInterruption
	ret c
	; first load in the particle tile ID and palettes
IF DEF(_RED)
	lb de, $44, 1
ENDC
IF DEF(_BLUE)
	lb de, $44, 1
ENDC
IF DEF(_GREEN)
	lb de, $42, 1
ENDC
	ld hl, wShadowOAMSprite00TileID
	ld b, 38
.loopLoadTileIDAndPalette
IF DEF(_RED)
	; red will alternate tile
	ld a, d
	cp $44
	ld d, $45
	jr z, .next
	ld d, $44
.next
ENDC
	ld [hl], d
	inc hl
	ld [hl], e
	inc hl
	inc hl
	inc hl
	dec b
	jr nz, .loopLoadTileIDAndPalette
	; now initialize their x and y coords
	ld hl, wShadowOAMSprite00YCoord
	ld de, ParticleXPositions
	ld a, 16
	ld b, 9 ; 9 rows
.outerLoop
	ld c, 4 ; 4 particles per row
.innerLoop
	ld [hl], a
	push af
	inc hl
	ld a, [de]
	cp -1
	jr nz, .gotXPosition
	ld de, ParticleXPositions
	ld a, [de]
.gotXPosition
	ld [hl], a
	inc hl
	inc hl
	inc hl
	inc de
	pop af
	dec c
	jr nz, .innerLoop
	add 16
	dec b
	jr nz, .outerLoop
	ld c, 0
.loopScroll
	; two sprites left, manually put them where they look nice
	ld hl, wShadowOAMSprite36YCoord
	ld [hl], 0
	inc hl
	ld [hl], 16
	ld hl, wShadowOAMSprite37YCoord
	ld [hl], 0
	inc hl
	ld [hl], 152
	; sprites are loaded, now scroll them
	ld b, 38
	ld hl, wShadowOAMSprite00YCoord
	call PureTitleScrollingParticleUpdate
	inc c
	push bc
	ld c, 1
	call CheckForUserInterruption
	pop bc
	jr nc, .loopScroll
	jp PureTitleClearNonPlayerOAM

PureTitleScrollingParticleUpdate:
IF DEF(_RED)
.loopUpdateScroll
	dec [hl]
	dec [hl]
	ld a, [hl]
	cp 8
	jr nc, .noResetY
	add 152
	ld [hl], a
.noResetY
	inc hl
	inc [hl]
	ld a, [hl]
	cp 160
	jr c, .noResetX
	sub 160
	ld [hl], a
.noResetX
	inc hl
	; flicker the sprites by switching tile IDs to a blank tile every other frame
	ld a, c
	and %1
	ld a, $7D
	jr nz, .hide
	; alternate which fire tile is used when they aren't blank
	ld a, b
	and %1
	ld a, $44
	jr z, .hide
	inc a ; $45
.hide
	ld [hl], a
	inc hl
	inc hl
	dec b
	jr nz, .loopUpdateScroll
	ret
ENDC
IF DEF(_BLUE)
.loopUpdateScroll
	inc [hl]
	inc [hl]
	ld a, [hl]
	cp 152
	jr c, .noResetY
	sub 152
	ld [hl], a
.noResetY
	inc hl
	dec [hl]
	ld a, [hl]
	cp 8
	jr nc, .noResetX
	add 160
	ld [hl], a
.noResetX
	inc hl
	; flicker the sprites by switching tile IDs to a blank tile every other frame
	ld a, c
	and %1
	ld a, $44
	jr z, .skipHide
	ld a, $7D
.skipHide
	ld [hl], a
	inc hl
	inc hl
	dec b
	jr nz, .loopUpdateScroll
	ret
ENDC
IF DEF(_GREEN)
.loopUpdateScroll
	inc [hl]
	ld a, [hl]
	cp 152
	jr c, .noResetY
	sub 152
	ld [hl], a
.noResetY
	inc hl
	inc [hl]
	inc [hl]
	ld a, [hl]
	cp 168
	jr c, .noResetX
	sub 168
	ld [hl], a
.noResetX
	inc hl
	; flicker the sprites by switching tile IDs to a blank tile every other frame
	ld a, c
	and %1
	ld a, $42
	jr z, .skipHide
	ld a, $7D
.skipHide
	ld [hl], a
	inc hl
	inc hl
	dec b
	jr nz, .loopUpdateScroll
	ret
ENDC

MakeTitlePokemonBlink:
	ld b, 2
.loopBlink
	push bc
IF DEF(_RED)
	ld de, CharizardBlinkingTileData
ENDC
IF DEF(_BLUE)
	ld a, [wSpriteOptions]
	bit BIT_BLASTOISE_SPRITE, a
	ld de, BlastoiseBlinkingTileData1
	jr z, .gotSprite
	ld de, BlastoiseBlinkingTileData2
.gotSprite
ENDC
IF DEF(_GREEN)
	ld de, VenusaurBlinkingTileData
ENDC
	call .loadBlinkingData
	ld c, 6
	rst _DelayFrames
IF DEF(_RED)
	ld de, CharizardNotBlinkingTileData
ENDC
IF DEF(_BLUE)
	ld a, [wSpriteOptions]
	bit BIT_BLASTOISE_SPRITE, a
	ld de, BlastoiseNotBlinkingTileData1
	jr z, .gotSprite2
	ld de, BlastoiseNotBlinkingTileData2
.gotSprite2
ENDC
IF DEF(_GREEN)
	ld de, VenusaurNotBlinkingTileData
ENDC
	call .loadBlinkingData
	ld c, 6
	rst _DelayFrames
	pop bc
	dec b
	jr nz, .loopBlink
	ret
.loadBlinkingData
	hlcoord 0, 0
	ld a, [de]
	cp -1
	ret z
	ld b, 0
	ld c, a
	add hl, bc ; navigate to x coord
	inc de
	ld a, [de]
	ld bc, SCREEN_WIDTH
	call AddNTimes
	inc de
	ld a, [de]
	ld [hl], a
	inc de
	jr .loadBlinkingData

IsPureTitleScreenEnabled:
	ld a, [wSpriteOptions2]
	bit BIT_NEW_TITLE_SCREEN, a
	ret


Version_GFX_Pure:
IF DEF(_RED)
	INCBIN "gfx/title/pure_red.2bpp"
ENDC
IF DEF(_BLUE)
	INCBIN "gfx/title/pure_blue.2bpp"
ENDC
IF DEF(_GREEN)
	INCBIN "gfx/title/pure_green.2bpp"
ENDC
Version_GFX_PureEnd:

CopyFromBattleAnim0:
IF DEF(_GREEN)
	ld bc, 1 tiles
ELSE
	ld bc, 2 tiles
ENDC
CopyFromBattleAnim0_2:
	ld a, BANK(MoveAnimationTiles0)
	jp FarCopyData2

CopyFromBattleAnim1:
IF DEF(_GREEN)
	ld bc, 1 tiles
ELSE
	ld bc, 2 tiles
ENDC
CopyFromBattleAnim1_2:
	ld a, BANK(MoveAnimationTiles1)
	jp FarCopyData2


IF DEF(_GREEN)
PureGreenVersionAnimationEnergyOAM:
	db 0, 0, $43, 4
	db 0, 0, $43, OAM_XFLIP | 4
	db 0, 0, $43, OAM_YFLIP | 4
	db 0, 0, $43, OAM_XFLIP | OAM_YFLIP | 4
	db 0, 0, $40, 1
	db 0, 0, $40, OAM_XFLIP | 1
	db 0, 0, $40, OAM_YFLIP | 1
	db 0, 0, $40, OAM_XFLIP | OAM_YFLIP | 1
	db 0, 0, $41, 1
	db 0, 0, $41, 1
	db 0, 0, $41, 1
	db 0, 0, $41, 1
ELSE
PureRedVersionAnimationFireOAM:
PureBlueVersionAnimationPumpOAM:
	db 0, 0, $40, 1
	db 0, 0, $40, OAM_XFLIP | 1
	db 0, 0, $42, 1
	db 0, 0, $42, OAM_XFLIP | 1

PureRedVersionAnimationFireOAMFrame2:
PureBlueVersionAnimationPumpOAMFrame2:
	db 0, 0, $41, 1
	db 0, 0, $41, OAM_XFLIP | 1
	db 0, 0, $43, 1
	db 0, 0, $43, OAM_XFLIP | 1
ENDC

StartingShineOAM:
	db 79, 58, $7E, 4
	db 79, 60, $7F, 4

ParticleXPositions:
	db 16, 56, 96, 136
	db 40, 72, 120, 152
	db -1


ShineSprites:
	INCBIN "gfx/title/shine.2bpp"

PureTitlePlayerSpritePointing:
	INCBIN "gfx/title/player_pointing.2bpp"
PureTitlePlayerSpritePointingEnd:

IF DEF(_RED)
CharizardBlinking:
	INCBIN "gfx/title/charizard_blinking.2bpp"
CharizardBlinkingTileData:
	; x coord, y coord, which tile
	db $07, $0C, $7A
	db $06, $0D, $7B
	db $07, $0D, $7C
	db -1
CharizardNotBlinkingTileData:
	; x coord, y coord, which tile
	db $07, $0C, $10
	db $06, $0D, $0A
	db $07, $0D, $11
	db -1
ENDC
IF DEF(_BLUE)
BlastoiseBlinking1:
	INCBIN "gfx/title/blastoise_blinking1.2bpp"
BlastoiseBlinkingTileData1:
	; x coord, y coord, which tile
	db $07, $0A, $7A
	db $08, $0A, $7B
	db $06, $0B, $7C
	db $07, $0B, $7D
	db $08, $0B, $7E
	db -1
BlastoiseNotBlinkingTileData1:
	; x coord, y coord, which tile
	db $07, $0A, $0E
	db $08, $0A, $15
	db $06, $0B, $08
	db $07, $0B, $0F
	db $08, $0B, $16
	db -1
BlastoiseBlinking2:
	INCBIN "gfx/title/blastoise_blinking2.2bpp"	
BlastoiseBlinkingTileData2:
	; x coord, y coord, which tile
	db $06, $0A, $7A
	db $07, $0A, $7B
	db $05, $0B, $7C
	db $06, $0B, $7D
	db $07, $0B, $7E
	db -1
BlastoiseNotBlinkingTileData2:
	; x coord, y coord, which tile
	db $06, $0A, $07
	db $07, $0A, $0E
	db $05, $0B, $01
	db $06, $0B, $08
	db $07, $0B, $0F
	db -1
ENDC
IF DEF(_GREEN)
VenusaurBlinking:
	INCBIN "gfx/title/venusaur_blinking.2bpp"
VenusaurBlinkingTileData:
	; x coord, y coord, which tile
	db $05, $0E, $7A
	db $06, $0E, $7B
	db $07, $0E, $7C
	db -1
VenusaurNotBlinkingTileData:
	; x coord, y coord, which tile
	db $05, $0E, $04
	db $06, $0E, $0B
	db $07, $0E, $12
	db -1
ENDC