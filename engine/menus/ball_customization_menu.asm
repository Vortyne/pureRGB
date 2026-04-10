; Menu to choose from the currently available custom poke balls.
; expects custom ball names are already copied from SRAM to wCustomBallNames with CopyCustomBallNamesFromSRAM
ChooseCustomBallMenu::
	call DisableTextDelay
  	call SaveScreenTilesToBuffer2
  	; draw the selection window
	hlcoord 2, 0
	lb bc, 16, 16
	call TextBoxBorderUpdateSprites
	hlcoord 4, 1
	ld de, wCustomBallNames
	lb bc, NUM_CUSTOM_BALLS, 0
.loopPrintNames
	push bc
	push de
	push hl
	push hl
	ld hl, wCustomBallUnlockFlags
	ld b, FLAG_TEST
	predef FlagActionPredef
	ld a, c
	and a
	pop hl
	jr nz, .loopPlaceString
	ld de, LockedText
	jr .skipBallText
.loopPlaceString
	ld a, [de]
	cp '@'
	jr z, .placeBallText
	ld [hli], a
	inc de
	jr .loopPlaceString
.placeBallText
	ld de, BallText
.skipBallText
	call PlaceString
	pop hl
	pop de
	ld bc, SCREEN_WIDTH
	add hl, bc
	push hl
	ld h, d
	ld l, e
	ld bc, NAME_LENGTH
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	pop bc
	inc c
	dec b
	jr nz, .loopPrintNames
.notUnlocked
	lb bc, 3, 1
	call CustomBallHandleInputInit
	ld a, PAD_A | PAD_B
	ld [wMenuWatchedKeys], a
	call HandleMenuInput
	ld hl, hUILayoutFlags
	res BIT_DOUBLE_SPACED_MENU, [hl]
	bit B_PAD_B, a
	ld a, 0
	jp nz, .exit
	ld a, [wCurrentMenuItem]
	ld d, a
	ld c, a
	ld b, FLAG_TEST
	ld hl, wCustomBallUnlockFlags
	predef FlagActionPredef
	ld a, c
	and a
	jr z, .notUnlocked
	ld a, d
	inc a
.exit
	ld [wWhichCustomBallSelected], a
	xor a
	ldh [hJoy7], a
	call EnableTextDelay
	jp LoadScreenTilesFromBuffer2

LockedText:
	db "- - - -@"
BallText:
	db " BALL@"

CustomBallHandleInputInit::
	ld a, NUM_CUSTOM_BALLS - 1
CustomBallHandleInputInitMaxItems:
	ld [wMaxMenuItem], a
	ld a, b
	ld [wTopMenuItemX], a
	ld a, c
	ld [wTopMenuItemY], a
	xor a
	ld [wLastMenuItem], a
	ld [wMenuWatchMovingOutOfBounds], a
	inc a
	ld [wMenuWrappingEnabled], a
	ldh [hJoy7], a ; allow holding down the menu navigation buttons
	ld a, PAD_A | PAD_B | PAD_SELECT
	ld [wMenuWatchedKeys], a
	ld hl, hUILayoutFlags
	set BIT_DOUBLE_SPACED_MENU, [hl]
	ret

BallCustomizationMenuText:
	db "Tile@"
	db "Color@"
	db "Throw@"
	db "Sound@"
	db "Poof@"
	db "Special@"
	db "Rename@"

BallCustomizationPressText:
	db "Press SELECT@"
	db "to visualize!@"


GetBallNameSRAM:
	ld hl, sCustomBallNames
	jr GetBallName.main
GetBallName:
	ld hl, wCustomBallNames
.main
	ld a, [wWhichCustomBallSelected]
	dec a
	ld bc, NAME_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	ret

; input wWhichCustomBallSelected = which ball will be customized
; stores name in sCustomBallNames
; reads name from wCustomBallNames
; reads/stores data in wCustomPokeballSettings
BallCustomizationMenu::
	ld a, [wCurrentMenuItem]
	push af
	call DisableSpriteUpdates
	call DisableTextDelay
	xor a
	ld [wCurrentMenuItem], a
	call ClearScreen
.loopCustomizationMenu
	xor a
	ld [wBallAnimFrameCounter], a ; makes it so the multicolor color uses PAL_PRISMATIC
	ld [wBallAnimSGBColorLoadFlag], a
	lb de, 0, 0
	call LoadBallTileOAM ; hide poof tile temporarily since the below call overwrites it
	call LoadMenuSamplePokeball
	; draw top border
	hlcoord 0, 0
	lb bc, 1, 18
	call TextBoxBorder
	; draw menu border
	hlcoord 0, 3
	lb bc, 9, 18
	call TextBoxBorder
	; draw bottom border
	hlcoord 0, 14
	lb bc, 2, 18
	call TextBoxBorder
	; place ball's name in top border
	call GetBallName
	hlcoord 3, 1
.loopPlaceName
	ld a, [de]
	cp '@'
	jr z, .placeBallText
	ld [hli], a
	inc de
	jr .loopPlaceName
.placeBallText
	ld de, BallText
	call PlaceString
	; place menu entries
	hlcoord 2, 4
	ld de, BallCustomizationMenuText
	ld b, 7 ; number of menu entries
.loopPlaceString
	call PlaceStringGoToNextEntry
	push de
	ld de, SCREEN_WIDTH
	add hl, de
	pop de
	dec b
	jr nz, .loopPlaceString
	; place arrows at a specific tile column
	hlcoord 8, 4
	ld de, SCREEN_WIDTH
	ld b, 5 ; number of menu entries where we will print their current selected option
.loopPlaceArrows
	ld [hl], '→'
	add hl, de
	dec b
	jr nz, .loopPlaceArrows
	; place the current settings for first 5 options
	call GetSelectedBallData
	; if the poof selected is "OG Poof" or "Explode", the tile cannot be modified
	push hl
	inc hl
	inc hl
	ld a, [hl]
	swap a
	and %1111
	cp BALL_POOF_ORIGINAL
	ld de, BallPoofAnimCustomizationMenuText
	jr z, .skipTile
	cp BALL_POOF_EXPLOSION
	ld de, ExplodeText
	jr z, .skipTile
	jr .continue
.skipTile
	hlcoord 10, 4
	call PlaceString
	; hide poof effect tile by making it nothing
	ld a, $FF
	lb de, 47, 86
	call LoadBallPoofTileAndOAM
	jr .continue2
.continue
	pop hl
	ld a, [hl]
	push hl
	swap a
	and %1111
	push af
	lb de, 47, 86
	call LoadBallPoofTileAndOAM
	pop af
	ld de, BallTileCustomizationMenuText
	hlcoord 11, 4
	call .placeNthString
.continue2
	pop hl
	ld a, [hli]
	push hl
	and %1111
	push af
	call LoadBallAnimPaletteWithInvertCheck
	ld a, [wOnSGB]
	and a
	jr nz, .colorAvailable
	pop af
	hlcoord 10, 5
	ld de, GrayText
	call PlaceString
	jr .colorNotAvailable
.colorAvailable
	pop af
	ld de, BallColorCustomizationMenuText
	hlcoord 10, 5
	call .placeNthString
.colorNotAvailable
	pop hl
	ld a, [hl]
	swap a
	ld de, BallThrowAnimCustomizationMenuText
	push hl
	hlcoord 10, 6
	call .placeNthString
	pop hl
	ld a, [hli]
	ld de, BallSFXCustomizationMenuText
	push hl
	hlcoord 10, 7
	call .placeNthString
	pop hl
	ld a, [hl]
	swap a
	ld de, BallPoofAnimCustomizationMenuText
	push hl
	hlcoord 10, 8
	call .placeNthString
	pop hl
	; place the prompt saying the player can press SELECT
	hlcoord 1, 15
	ld de, BallCustomizationPressText
	call PlaceStringGoToNextEntry
	hlcoord 1, 16
	call PlaceString
	; Draw the "poof tile" beside the tile option
	lb bc, 1, 4
	ld a, 6
	call CustomBallHandleInputInitMaxItems
	call HandleMenuInput
	bit B_PAD_SELECT, a
	jr nz, .visualize
	bit B_PAD_B, a
	jr nz, .exit
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	and a
	jr z, .tileMenu
	dec a
	jr z, .colorMenu
	dec a
	jr z, .throwMenu
	dec a
	jr z, .soundMenu
	dec a
	jr z, .poofMenu
	dec a
	jr z, .specialMenu
	dec a
	jr z, .rename
	jr .goToLoop
.exit
	call EnableSpriteUpdates
	pop af
	ld [wCurrentMenuItem], a
	call EnableTextDelay
	call ClearScreen
	ld a, SET_PAL_OVERWORLD
	ld [wDefaultPaletteCommand], a
	jp RunDefaultPaletteCommand
.visualize
	call VizualizeBallAnimation
	call ResumeMusic
.goToLoop
	jp .loopCustomizationMenu
.tileMenu
	call GetSelectedBallData
	inc hl
	inc hl
	ld a, [hl]
	swap a
	and %1111
	cp BALL_POOF_EXPLOSION
	jr z, .skipTileMenu
	cp BALL_POOF_ORIGINAL
	jr z, .skipTileMenu
	call BallTileCustomizationMenu
	jr .goToLoop
.skipTileMenu
	ld hl, .cannotChange
	call .printTextInMenu
	jr .goToLoop
.colorMenu
	ld a, [wOnSGB]
	and a
	jr z, .skipColorMenu
	call BallColorCustomizationMenu
	jr .goToLoop
.skipColorMenu
	ld hl, .noColor
	call .printTextInMenu
	jr .goToLoop
.throwMenu
	call BallThrowAnimCustomizationMenu
	jr .goToLoop
.soundMenu
	call BallSFXCustomizationMenu
	jr .goToLoop
.poofMenu
	call BallPoofAnimCustomizationMenu
	jr .goToLoop
.specialMenu
	call BallSpecialCustomizationMenu
	jr .goToLoop
.rename
	ld hl, hUILayoutFlags
	res BIT_DOUBLE_SPACED_MENU, [hl]
	push hl
	ld a, [wCurrentMenuItem]
	push af
	ld a, NAME_BALL_SCREEN
	ld [wNamingScreenType], a
	callfar DisplayNamingScreen
	pop af
	ld [wCurrentMenuItem], a
	pop hl
	set BIT_DOUBLE_SPACED_MENU, [hl]
	call DisableTextDelay
	ld a, [wStringBuffer]
	cp '@'
	jr z, .goToLoop ; if the player didnt type in any name don't change it
	call GetBallName
	push hl
	ld hl, wStringBuffer
	ld bc, NAME_LENGTH
	rst _CopyData
	ld a, RAMG_SRAM_ENABLE
  	ld [rRAMG], a
  	ld a, $1
  	ld [rBMODE], a
  	xor a
	ld [rRAMB], a
	call GetBallNameSRAM
	pop hl
	ld bc, NAME_LENGTH
	rst _CopyData
   	xor a
  	ld [rBMODE], a
  	ld [rRAMG], a
	jp .goToLoop
.placeNthString
	and %1111
	ld b, a
	call GoToNthString
	jp PlaceString
.printTextInMenu
	push hl
	call SaveScreenTilesToBuffer2
	call EnableTextDelay
	pop hl
	rst _PrintText
	call DisableTextDelay
	jp LoadScreenTilesFromBuffer2
.cannotChange
	text_far _CeruleanBallDesignerCannotChangeTile
	text_end
.noColor
	text_far _CeruleanBallDesignerCannotChangeColor
	text_end

LoadBallPoofTileAndOAM:
	push de
	call LoadBallPoofTile
	pop de
LoadBallTileOAM:
	ld hl, wShadowOAMSprite00YCoord
	ld [hl], d
	inc hl
	ld [hl], e
	inc hl
	ld [hl], $35
	inc hl
	ld [hl], 0
	ret

LoadMenuSamplePokeball:
	call LoadPokeballTilesAndOAM
	; Draw pokeball sprite at top left of menu
	lb de, 18, 15
	jp LoadDefaultBallOAMCoords


PlaceStringGoToNextEntry:
	push bc
	push de
	call PlaceString
	pop de
	pop bc
.loop
	ld a, [de]
	inc de
	cp '@'
	ret z
	jr .loop

GetSelectedBallData:
	ld a, [wWhichCustomBallSelected]
	dec a
	ld hl, wCustomPokeballSettings
	ld bc, CUSTOM_BALL_DATA_SIZE
	jp AddNTimes

; b = which string in a list to find
GoToNthString:
	dec b
	inc b
	ret z
.loop
	ld a, [de]
	inc de
	cp '@'
	jr nz, .loop
	dec b
	ret z
	jr .loop

PlaceMenuStrings:
.loopPlaceString
	call PlaceStringGoToNextEntry
	push de
	ld de, SCREEN_WIDTH
	add hl, de
	pop de
	dec b
	jr nz, .loopPlaceString
	ret

; hl = which coords to place at
; de = menu strings
; c = which property is being customized
PlaceChildMenuStrings:
	ld b, 0
.loopPlaceString
	push bc
	push de
	push hl
	ld d, b
	callfar IsBallPropertyUnlocked
	pop hl
	pop de
	pop bc
	jr c, .placeString
	; property locked
	push de
	push bc
	ld de, LockedText
	call PlaceString
	pop bc
	pop de
	call PlaceStringGoToNextEntry.loop
	jr .next
.placeString
	call PlaceStringGoToNextEntry
.next
	push de
	ld de, SCREEN_WIDTH
	add hl, de
	pop de
	inc b
	ld a, b
	cp 16
	jr nz, .loopPlaceString
	ret

BallTileCustomizationMenuText::
	db "Sphere@"
	db "Sparkle@"
	db "Rock@"
	db "Droplet@"
	db "Leaf@"
	db "Fire@"
	db "Crystal@"
	db "Shine@"
	db "Sword@"
	db "Skull@"
	db "Bolt@"
	db "Tri@"
	db "Heart@"
	db "Eye@"
	db "Ghost@"
	db "Cone@"

BallTileCustomizationMenu:
	ld a, [wCurrentMenuItem]
	push af
	call GetSelectedBallData
	ld a, [hl]
	swap a
	and %1111
	call InitChildMenu
	hlcoord 10, 1
	ld de, BallTileCustomizationMenuText
	ld c, BALL_CUSTOM_FORMAT_TILE
	call PlaceChildMenuStrings
	hlcoord 8, 4
	ld [hl], '→'
.loopMenu
	ld a, 3
	ld [wListMenuHoverTextType], a
	call InitChildMenuInput
	callfar HandleMenuInputFromBank1
	call .isUnlocked
	call c, CustomBallLoadDataSwapped
	ldh a, [hJoy5]
	bit B_PAD_SELECT, a
	jr nz, .visualize
	bit B_PAD_A, a
	jr z, .exit
	call .isUnlocked
	jr nc, .loopMenu
.exit
	xor a
	ld [wListMenuHoverTextType], a
	pop af
	ld [wCurrentMenuItem], a
	ret
.visualize
	call VisualizeFromChildMenuResetAudio
	jr .loopMenu
.isUnlocked
	ld c, BALL_CUSTOM_FORMAT_TILE
	; fall through
IsCustomBallMenuItemUnlocked:
	ld a, [wCurrentMenuItem]
	ld d, a
	jpfar IsBallPropertyUnlocked

VisualizeFromChildMenu:
	call SaveScreenTilesToBuffer2
	call VizualizeBallAnimation
	ldh a, [hGBC]
	and a
	jr nz, .notGBC
	xor a
	ld [wBallAnimSGBColorLoadFlag], a
	call GetSelectedBallData
	ld a, [hl]
	and %1111
	call LoadBallAnimPaletteWithInvertCheck
.notGBC
	call LoadPokeballTilesAndOAM
	call LoadMenuSamplePokeball
	call GetSelectedBallData
	call GetBallTileToUse
	lb de, 24, 32
	call LoadBallPoofTileAndOAM
	jp LoadScreenTilesFromBuffer2

GetBallTileToUse:
	push hl
	inc hl
	inc hl
	ld a, [hl]
	swap a
	and %1111
	pop hl
	cp BALL_POOF_ORIGINAL
	jr z, .blank
	cp BALL_POOF_EXPLOSION
	jr z, .blank
	ld a, [hl]
	swap a
	and %1111
	ret
.blank
	ld a, $FF
	ret


VisualizeFromChildMenuResetAudio:
	call VisualizeFromChildMenu
	jp ResumeMusic


ChangeCustomBallTile::
	call BallTileCustomizationMenu.isUnlocked
	ret nc
	ld a, [wCurrentMenuItem]
	call LoadBallPoofTile
	call CustomBallLoadDataSwapped
	; loading a new tile changes the below value so reload
	xor a
	ldh [hDownArrowBlinkCount1], a
	ret

CustomBallLoadDataSwapped:
	call GetSelectedBallData
	; fall through
CustomBallLoadTopNybble:
	ld a, [wCurrentMenuItem]
	swap a
	ld b, a
	ld a, [hl]
	and %1111
	or b
	ld [hl], a
	ret

CustomBallLoadBottomNybble:
	ld a, [wCurrentMenuItem]
	ld b, a
	ld a, [hl]
	and %11110000
	or b
	ld [hl], a
	ret


BallColorCustomizationMenuText::
	db "Red@"
	db "Yellow@"
	db "Pale@"
	db "Green@"
	db "Cyan@"
	db "Blue@"
	db "Indigo@"
	db "Purple@"
	db "Pink@"
GrayText:
	db "Gray@"
	db "Black@"
	db "White@"
	db "Pepper@"
	db "Lime@"
	db "Crimson@"
	db "Prismatic@"

InitChildMenu:
	ld [wCurrentMenuItem], a ; put cursor at currently selected option
	hlcoord 3,1
	lb bc, 1, 5
	call ClearScreenArea
	hlcoord 8, 0
	lb bc, 16, 10
	jp TextBoxBorder

InitChildMenuInput:
	lb de, 24, 32
	call LoadBallTileOAM
	lb bc, 9, 1
	jp CustomBallHandleInputInit

BallColorCustomizationMenu:
	ld a, [wCurrentMenuItem]
	push af
	call GetSelectedBallData
	ld a, [hl]
	and %1111
	call InitChildMenu
	; move the "ball tile" beside the pokeball on the top right
	hlcoord 10, 1
	ld de, BallColorCustomizationMenuText
	ld c, BALL_CUSTOM_FORMAT_COLOR
	call PlaceChildMenuStrings
	hlcoord 8, 5
	ld [hl], '→'
.loopMenu
	ld a, 4
	ld [wListMenuHoverTextType], a
	call InitChildMenuInput
	callfar HandleMenuInputFromBank1
	call .isUnlocked
	jr nc, .dontLoad
	call GetSelectedBallData
	call CustomBallLoadBottomNybble
.dontLoad
	ldh a, [hJoy5]
	bit B_PAD_SELECT, a
	jr nz, .visualize
	bit B_PAD_A, a
	jr z, .exit
	call .isUnlocked
	jr nc, .loopMenu
.exit
	xor a
	ld [wListMenuHoverTextType], a
	pop af
	ld [wCurrentMenuItem], a
	ret
.visualize
	call VisualizeFromChildMenuResetAudio
	jr .loopMenu
.isUnlocked
	ld c, BALL_CUSTOM_FORMAT_COLOR
	jp IsCustomBallMenuItemUnlocked

ChangeCustomBallColor:
	call BallColorCustomizationMenu.isUnlocked
	ret nc
	ld a, [wCurrentMenuItem]
	jp LoadBallAnimPaletteWithInvertCheck

BallThrowAnimCustomizationMenuText::
	db "None@"
	db "Appear@"
	db "Flash@"
	db "Shake@"
	db "Vibrate@"
	db "Throw@"
	db "Drop@"
	db "Bounce@"
	db "Roll@"
	db "ZigZag@"
	db "Fakeout@"
	db "Emotion@"
	db "The Merge@"
	db "Slice@"
	db "Angelic@"
	db "Random@"

BallThrowAnimCustomizationMenu:
	ld a, [wCurrentMenuItem]
	push af
	call GetSelectedBallData
	inc hl
	ld a, [hl]
	swap a
	and %1111
	call InitChildMenu
	; move the "ball tile" beside the pokeball on the top right
	hlcoord 10, 1
	ld de, BallThrowAnimCustomizationMenuText
	ld c, BALL_CUSTOM_FORMAT_THROW
	call PlaceChildMenuStrings
	hlcoord 8, 6
	ld [hl], '→'
.loopMenu
	call InitChildMenuInput
	call HandleMenuInput
	call .isUnlocked
	jr nc, .dontLoad
	call GetSelectedBallData
	inc hl
	call CustomBallLoadTopNybble
.dontLoad
	ldh a, [hJoy5]
	bit B_PAD_SELECT, a
	jr nz, .visualize
	bit B_PAD_A, a
	jr z, .exit
	call .isUnlocked
	jr nc, .loopMenu
.exit
	pop af
	ld [wCurrentMenuItem], a
	ret
.visualize
	call VisualizeFromChildMenuResetAudio
	jr .loopMenu
.isUnlocked
	ld c, BALL_CUSTOM_FORMAT_THROW
	jp IsCustomBallMenuItemUnlocked

BallPoofAnimCustomizationMenuText::
	db "OG Poof@"
	db "Spread@"
	db "Circle@"
	db "Spin Out@"
	db "Spiral@"
	db "Gravity@"
	db "Weave@"
	db "Scan@"
	db "Windmill@"
	db "Strike@"
	db "Speckle@"
	db "Confetti@"
	db "Helix@"
	db "Tornado@"
ExplodeText:
	db "Explode@"
	db "Random@"

BallPoofAnimCustomizationMenu:
	ld a, [wCurrentMenuItem]
	push af
	call GetSelectedBallData
	inc hl
	inc hl
	ld a, [hl]
	swap a
	and %1111
	call InitChildMenu
	; move the "ball tile" beside the pokeball on the top right
	hlcoord 10, 1
	ld de, BallPoofAnimCustomizationMenuText
	ld c, BALL_CUSTOM_FORMAT_POOF
	call PlaceChildMenuStrings
	hlcoord 8, 8
	ld [hl], '→'
.loopMenu
	call InitChildMenuInput
	call HandleMenuInput
	call .isUnlocked
	jr nc, .dontLoad
	call GetSelectedBallData
	inc hl
	inc hl
	call CustomBallLoadTopNybble
.dontLoad
	ldh a, [hJoy5]
	bit B_PAD_SELECT, a
	jr nz, .visualize
	bit B_PAD_A, a
	jr z, .exit
	call .isUnlocked
	jr nc, .loopMenu
.exit
	pop af
	ld [wCurrentMenuItem], a
	ret
.visualize
	call VisualizeFromChildMenuResetAudio
	jr .loopMenu
.isUnlocked
	ld c, BALL_CUSTOM_FORMAT_POOF
	jp IsCustomBallMenuItemUnlocked


BallSFXCustomizationMenuText::
	db "OG Poof@"
	db "Wind@"
	db "Shwing@"
	db "Whoosh@"
	db "Smash@"
	db "Cute@"
	db "Squirt@"
	db "Power Up@"
	db "Psy@"
	db "Evil@"
	db "Icy@"
	db "Machine@"
	db "Flood@"
	db "Explode@"
	db "Thunder@"
	db "Sparkle@"

BallSFXCustomizationMenu:
	ld a, [wCurrentMenuItem]
	push af
	call GetSelectedBallData
	inc hl
	ld a, [hl]
	and %1111
	call InitChildMenu
	; move the "ball tile" beside the pokeball on the top right
	hlcoord 10, 1
	ld de, BallSFXCustomizationMenuText
	ld c, BALL_CUSTOM_FORMAT_SFX
	call PlaceChildMenuStrings
	hlcoord 8, 7
	ld [hl], '→'
.loopMenu
	call InitChildMenuInput
	call HandleMenuInput
	call .isUnlocked
	jr nc, .dontLoad
	call GetSelectedBallData
	inc hl
	call CustomBallLoadBottomNybble
.dontLoad
	ldh a, [hJoy5]
	bit B_PAD_SELECT, a
	jr nz, .visualize
	bit B_PAD_A, a
	jr nz,  .playSound
	pop af
	ld [wCurrentMenuItem], a
	ret
.visualize
	call VisualizeFromChildMenu
	jr .loopMenu
.playSound
	call StopSFXChannels
	call .isUnlocked
	jr nc, .loopMenu
	call PauseMusic
	; TODO: use new audio funcs?
	ld a, [wAudioROMBank]
	push af
	ld a, BANK("Audio Engine 2")
	ld [wAudioROMBank], a
	ld a, [wCurrentMenuItem]
	call PlayPoofSFX
	call WaitForSoundToFinish
	pop af
	ld [wAudioROMBank], a
	call ResumeMusic
	jr .loopMenu
.isUnlocked
	ld c, BALL_CUSTOM_FORMAT_SFX
	jp IsCustomBallMenuItemUnlocked

BallSpecialCustomizationMenuText::
	db "Invert Color@"
	db "Dark Screen@"
	db "Light Screen@"

BallSpecialCustomizationMenu:
	ld a, [wCurrentMenuItem]
	push af
	xor a
	ld [wCurrentMenuItem], a
	hlcoord 2, 10
	lb bc, 3, 15
	call TextBoxBorder
	hlcoord 4, 11
	ld de, BallSpecialCustomizationMenuText
	ld b, 3
	call PlaceMenuStrings
.loopMenu
	call .prepareSpecialMenu
	call HandleMenuInput
	ldh a, [hJoy5]
	bit B_PAD_SELECT, a
	jr nz, .visualize
	bit B_PAD_B, a
	jr nz, .exit
	call GetSelectedBallData
	inc hl
	inc hl
	ld a, [wCurrentMenuItem]
	and a
	jr z, .toggleInvert
	dec a
	jr z, .darkScreenToggle
	ld a, [hl]
	and %11
	cp %10
	ld b, 0
	jr z, .setValue
	ld b, %10
	jr .setValue
.darkScreenToggle
	ld a, [hl]
	and %11
	cp 1
	ld b, 0
	jr z, .setValue
	inc b
.setValue
	ld a, [hl]
	and %11111100
	or b
	ld [hl], a
	jr .loopMenu
.toggleInvert
	ld a, [hl]
	xor %100
	ld [hl], a
	call GetSelectedBallData
	ld a, [hl]
	and %1111
	call LoadBallAnimPaletteWithInvertCheck
	jr .loopMenu
.visualize
	call VisualizeFromChildMenuResetAudio
	jr .loopMenu
.exit
	pop af
	ld [wCurrentMenuItem], a
	ret
.prepareSpecialMenu
	call GetSelectedBallData
	inc hl
	inc hl
	ld b, [hl]
	bit 2, b
	hlcoord 17, 11
	ld a, ' '
	jr z, .skipInvertColorMarker
	ld a, '×'
.skipInvertColorMarker
	ld [hl], a
	hlcoord 17, 12
	ld [hl], ' '
	hlcoord 17, 13
	ld [hl], ' '
	ld a, b
	and %11
	dec a
	hlcoord 17, 12
	jr z, .loadData
	dec a
	hlcoord 17, 13
	jr nz, .skipScreen
.loadData
	ld [hl], '×'
.skipScreen
	lb de, 47, 86
	call LoadBallTileOAM
	lb bc, 3, 11
	ld a, 2
	jp CustomBallHandleInputInitMaxItems


VizualizeBallAnimation:
	call PauseMusic
	call HideAnimationOAMEntries
	call ClearScreen
	ld c, 16
	rst _DelayFrames
	; need the first tile in sprite memory to be nothing for the original poof
	ld hl, vSprites
	lb bc, BANK(NothingSprite), 1
	ld de, NothingSprite
	call CopyVideoData
	ld a, [wAudioROMBank]
	push af
	ld a, BANK("Audio Engine 2")
	ld [wAudioROMBank], a
	call ClearScreen
	hlcoord 0,0
	lb bc, 1, 18
	call TextBoxBorder
	hlcoord 2, 1
	ld de, VisualizationTitle
	call PlaceString
.replayAnimation
	ld hl, wShadowOAMSprite00Attributes
	ld b, 40
	xor a
.loopResetAttributes
	ld [hli], a
	inc hl
	inc hl
	inc hl
	dec b
	jr nz, .loopResetAttributes
	hlcoord 0, 4
	lb bc, 14, 20
	call ClearScreenArea
	call Delay3
	ld a, [wWhichCustomBallSelected]
	add FIRST_CUSTOM_BALL_DATA_CONST - 1
	call AnimationSpecificCustomBallPoof
	ld de, VisualizationMenu
	hlcoord 5, 8
	call PlaceStringGoToNextEntry
	hlcoord 5, 10
	call PlaceStringGoToNextEntry
	call WaitForTextScrollButtonPress
	ldh a, [hJoy5]
	bit B_PAD_A, a
	jr nz, .replayAnimation
	call WaitForSoundToFinish
	pop af
	ld [wAudioROMBank], a
	call ResumeMusic
	; a = 0 still
	ld [wBallAnimFrameCounter], a ; makes it so the multicolor color uses PAL_PRISMATIC
	ld [wBallAnimSGBColorLoadFlag], a
	ret

LoadBallAnimPaletteWithInvertCheck:
	push af
	call GetSelectedBallData
	inc hl
	inc hl
	bit 2, [hl]
	ld a, %11100100
	jr z, .skipInvert
	ld a, %11011000
.skipInvert
	ldh [rOBP0], a
	pop af
	jp LoadBallAnimPalette

VisualizationTitle:
	db "BALL  VISUALIZER@"

VisualizationMenu:
	db "A - Replay@"
	db "B - Back@"

CustomBallText:
	db "CUSTOM #BALL@"

CustomPokeballRename::
	hlcoord 4, 1
	ld de, CustomBallText
	call PlaceString
	ld hl, wShadowOAMSprite00YCoord
	ld [hl], 0
	; at the moment we only call this in a place where a pokeball is already in oam, so move its sprite to the right spot
	lb de, 16, 15
	jp LoadDefaultBallOAMCoords

GetCustomBallColor::
	call GetSelectedBallData
	ld a, [hl]
	and %1111
	jp LoadBallAnimPaletteWithInvertCheck

CopyCustomBallNamesFromSRAM::
	CheckAndSetEvent EVENT_INITIALIZED_CUSTOM_BALL_NAMES
	jr nz, .skipInitializeNames
	callfar InitializeCustomPokeballData
.skipInitializeNames
	; copy custom ball names from sram to temporary wram space
	ld a, RAMG_SRAM_ENABLE
  	ld [rRAMG], a
  	ld a, $1
  	ld [rBMODE], a
  	xor a
	ld [rRAMB], a
	ld hl, sCustomBallNames
	ld de, wCustomBallNames
	ld bc, NUM_CUSTOM_BALLS * NAME_LENGTH
	rst _CopyData
   	xor a
  	ld [rBMODE], a
  	ld [rRAMG], a
  	ret

; d = which custom ball
CopyFullCustomBallNameToNameBuffer::
	ld hl, wNameBuffer
	jr CopyFullCustomBallName
CopyFullCustomBallNameToStringBuffer::
	ld hl, wStringBuffer
CopyFullCustomBallName::
	ld a, d
	push hl
	ld hl, wCustomBallNames
	ld bc, NAME_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	pop hl
	call CopyString
	dec hl
	ld de, BallText
	jp CopyString

CheckInvertBallStatusScreenColor::
	ld a, %11100100 ; 3210
	ldh [rBGP], a
	ld a, [wLoadedMonFlags]
	rra
	rra
	rra
	and %11111
	cp PAST_LAST_CUSTOM_BALL_DATA_CONST
	jr c, .default
	sub FIRST_CUSTOM_BALL_DATA_CONST
	jr c, .default
	ld hl, wCustomPokeballSettings + 2
	ld d, 0
	ld e, a
	add hl, de
	add hl, de
	add hl, de
	bit 2, [hl]
	ld a, %11011000 ; 3120 (inverted)
	jr nz, .next
.default
	ld a, %11100100 ; 3210
.next
	jp UpdatePal


LoadStatusScreenPokeball::
	ld hl, wShadowOAMSprite36TileID
	ld b, 4
	ld a, $D0
.loop
	ld [hl], a
	inc hl
	ld [hl], 2 ; 3rd gbc palette
	call GoToNextOAMEntry
	inc a
	dec b
	jr nz, .loop
	lb de, 80, 144
	ld hl, wShadowOAMSprite36YCoord
	jp LoadBallOAMCoords

CeruleanBallDesignerPhotoHintMenu::
	xor a
	ld [wCurrentMenuItem], a
	call DisableTextDelay
	hlcoord 0, 0
	lb bc, 1, 5
	call TextBoxBorder
	hlcoord 1, 1
	ld de, CeruleanBallDesignerHintText
	call PlaceString
	hlcoord 7, 0
	lb bc, 16, 11
	call TextBoxBorder
	call UpdateSprites
	ld a, 1
	ld [w2CharStringBuffer], a
	ld c, a
	hlcoord 9, 1
.loopPrintPhotoOptions
	push bc
	push hl
	dec c
	call .checkPhotoEventSetC
	jr z, .noXMark
	pop hl
	push hl
	ld de, 9 ; length of "Photo Hint" text + number beside it
	add hl, de
	ld [hl], '×'
.noXMark
	pop hl
	push hl
	ld de, CeruleanBallDesignerPhotoText
	call PlaceString
	pop hl
	push hl
	ld de, 6 ; length of "Photo Hint" text
	add hl, de
	ld de, w2CharStringBuffer
	lb bc, 1, 2
	call PrintNumber
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	pop bc
	inc c
	ld a, c
	ld [w2CharStringBuffer], a
	cp NUM_CUSTOM_BALLS + 1
	jr nz, .loopPrintPhotoOptions
	; check if we should hide hint 16 due to not unlocking the others
	call IsFinalPhotoUnlocked
	jr nc, .loopHandleMenuInput
	hlcoord 9, 16
	ld de, LockedText
	call PlaceString
	hlcoord 16, 16
	ld [hl], ' '
.loopHandleMenuInput
	call EnableTextDelay
	lb bc, 8, 1
	call CustomBallHandleInputInit
	call HandleMenuInput
	bit B_PAD_B, a
	jr nz, .exit
	bit B_PAD_SELECT, a
	jr nz, .loopHandleMenuInput
	call SaveScreenTilesToBuffer2
	ld a, [wCurrentMenuItem]
	push af
	call .checkPhotoEventSet
	jr z, .noPhotoDisplay
	pop af
	push af
	cp BALL_ID_SUBZERO
	jr nz, .notDragonair
	CheckEventHL EVENT_SNAPPED_PIC_OF_DRAGONAIR
	jr z, .notDragonair
	ld a, 16 ; dragonair pic
.notDragonair
	ld d, a
	call ShowCustomBallUnlockPicture
	pop af
	call .printHintText
	call ReloadAfterCameraPicNoFadeIn
	jr .restoreScreenAndLoop
.noPhotoDisplay
	pop af
	call .printHintText
.restoreScreenAndLoop
	call LoadScreenTilesFromBuffer2
	call Delay3
	call UpdateSprites
	call GBPalNormal
	jr .loopHandleMenuInput
.exit
	ld hl, hUILayoutFlags
	res BIT_DOUBLE_SPACED_MENU, [hl]
	xor a
	ldh [hJoy7], a
	ret
.checkPhotoEventSet
	ld c, a
.checkPhotoEventSetC
	ld b, FLAG_TEST
	ld hl, wCustomBallUnlockFlags
	predef FlagActionPredef
	ld a, c
	and a
	ret
.printHintText
	push af
	cp 15
	jr z, .finalHint
.backToHint
	pop af
	ld hl, CeruleanBallDesignerPhotoHintTextRefs
	ld bc, 5 ; length of each text reference
	call AddNTimes
	rst _PrintText
	ret
.finalHint
	call IsFinalPhotoUnlocked
	jr nc, .backToHint
	pop af
	ld hl, .lastHintNotUnlocked
	rst _PrintText
	ret
.lastHintNotUnlocked
	text_far _LastBallPhotoHintNotUnlocked
	text_end

CeruleanBallDesignerPhotoText:
	db "Photo @"
CeruleanBallDesignerHintText:
	db "HINTS@"

; Each ref is expected to be 5 bytes long with a single text far and then text end and in the correct order
; Do not separate the below entries or change order
CeruleanBallDesignerPhotoHintTextRefs:
BallDesignerPokemonBreederHint:
	text_far _BallDesignerPokemonBreederHint
	text_end

BallDesignerPsyduckHint:
	text_far _BallDesignerPsyduckHint
	text_end

BallDesignerFlareonHint:
	text_far _BallDesignerFlareonHint
	text_end

BallDesignerJigglypuffHint:
	text_far _BallDesignerJigglypuffHint
	text_end
	
BallDesignerJolteonHint:
	text_far _BallDesignerJolteonHint
	text_end

BallDesignerPorygonHint:
	text_far _BallDesignerPorygonHint
	text_end

BallDesignerFossilHint:
	text_far _BallDesignerFossilHint
	text_end

BallDesignerArticunoHint:
	text_far _BallDesignerArticunoHint
	text_end

BallDesignerAbraHint:
	text_far _BallDesignerAbraHint
	text_end

BallDesignerPidgeotHint:
	text_far _BallDesignerPidgeotHint
	text_end

BallDesignerGrimerHint:
	text_far _BallDesignerGrimerHint
	text_end

BallDesignerGastlyHint:
	text_far _BallDesignerGastlyHint
	text_end

BallDesignerScytherHint:
	text_far _BallDesignerScytherHint
	text_end

BallDesignerLassHint:
	text_far _BallDesignerLassHint
	text_end

BallDesignerMankeyHint:
	text_far _BallDesignerMankeyHint
	text_end

BallDesignerGamblerHint:
	text_far _BallDesignerGamblerHint
	text_end