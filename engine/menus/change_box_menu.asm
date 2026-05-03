LoadBillsPCExtraTiles::
	; 5 frames to load all these
	ld hl, vChars1 tile $55
	ld de, PokeballTileGraphics ; pokeball tile
	lb bc, BANK(PokeballTileGraphics), 1
	call CopyVideoData
	ld hl, vChars1 tile $56
	ld de, PokeballTileGraphics tile 2 ; pokeball with x tile
	lb bc, BANK(PokeballTileGraphics), 1
	call CopyVideoData
	ld de, ExtraMenuBorderConnectors
	ld hl, vChars1 tile $40
	lb bc, BANK(ExtraMenuBorderConnectors), 21
	jp CopyVideoDataDouble

; PureRGBnote: MOVED: moved from save.asm to here since it didn't rely on much from the other file
; this function was updated a bunch to display extra information about boxes and reformat the layout
DisplayChangeBoxMenu:
	xor a
	ldh [hAutoBGTransferEnabled], a
	ld a, PAD_A | PAD_B
	ld [wMenuWatchedKeys], a
	ld a, 11
	ld [wMaxMenuItem], a
	ld a, 1
	ld [wTopMenuItemY], a
	ld a, 7
	ld [wTopMenuItemX], a
	xor a
	ld [wMenuWatchMovingOutOfBounds], a
	call GetCurrentBoxNum
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a

	decoord 0, 0
	call DrawCurrentBoxPrompt
	CheckEvent EVENT_HIDE_CHANGE_BOX_SAVE_MSG
	ld hl, ChooseABoxDataWillSaveText
	jr nz, .printPrompt
	ld hl, ChooseABoxText
.printPrompt
	rst _PrintText
	hlcoord 6, 0
	lb bc, 12, 12
	call TextBoxBorder
.addExtraBorder
	ld a, $C0 ; menu connector 1
	ldcoord_a 6, 0 
	ld a, $C1 ; menu connector 2
	ldcoord_a 19, 13 
	ld a, $C4 ; menu connector 5
	ldcoord_a 6, 4 
	ldcoord_a 6, 12
	ld de, 1
	lb bc, $C8, 3 ; start of FROM prompt
	hlcoord 1, 0
	call DrawTileLineIncrement
	lb bc, $CB, 2 ; start of TO prompt
	hlcoord 7, 0
	call DrawTileLineIncrement

	callfar GetMonCountsForAllBoxes

	; print box names
	call BoxEnableSRAM
	hlcoord 8, 1
	ld b, NUM_BOXES
	ld de, sBoxNames
.loopPrintBoxNames
	push hl
	push de
	ld c, BOX_NAME_LENGTH - 1
.innerLoopBoxNames
	ld a, [de]
	cp '@'
	jr z, .nextLine
	inc de
	ld [hli], a
	dec c
	jr nz, .innerLoopBoxNames
.nextLine
	pop hl ; pop de into hl
	ld de, BOX_NAME_LENGTH
	add hl, de
	ld d, h
	ld e, l
	pop hl
	push de
	ld de, SCREEN_WIDTH
	add hl, de
	pop de
	dec b
	jr nz, .loopPrintBoxNames
	call BoxDisableSRAM
	; place box counts
	hlcoord 13, 1
	ld de, wBoxMonCounts
	ld bc, SCREEN_WIDTH
	ld a, NUM_BOXES
.loop
	push af
	push hl
	push bc
	ld a, [de]
	and a ; is the box empty?
	jr z, .boxEmpty ; don't print anything beside it
	push af
	cp MONS_PER_BOX
	ld a, $D5 ; pokeball tile
	jr nz, .placeBallTile
	inc a ; ball tile with X on top
.placeBallTile
	ld [hli], a ; place pokeball tile next to box name if box not empty
.placeBoxCount
	pop af
	push de
	ld de, wSum
	ld [de], a
	lb bc, 1, 2
	call PrintNumber
	ld de, BoxOutOf20
	call PlaceString
	pop de
.boxEmpty
	pop bc
	pop hl
	add hl, bc
	inc de
	pop af
	dec a
	jr nz, .loop
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	ret

ChooseABoxText:
	text_far _ChooseABoxText
	text_end

ChooseABoxDataWillSaveText:
	text_far _ChooseABoxDataWillSaveText
	text_end

; draws a box that says info about the current box (used in pc and change box menus)
; input = de, top left coord of the prompt box
DrawCurrentBoxPrompt::
	push de
	CheckAndSetEvent EVENT_INITIALIZED_BOX_NAMES
	call z, InitializeBoxNamesInSRAM
	pop de
	ld h, d
	ld l, e
	push hl
	lb bc, 3, 5
	call TextBoxBorder
	pop hl
	inc_hl_ycoord
	inc hl
	call BoxEnableSRAM
	push hl
	call GetCurrentBoxNum
	ld hl, sBoxRenamedFlags
	ld c, a
	ld b, FLAG_TEST
	call FlagAction
	ld de, BoxText
	jr z, .gotBoxName ; box hasn't been renamed yet
	call GetCurrentBoxNum
	ld hl, sBoxNames
	ld bc, BOX_NAME_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
.gotBoxName
	pop hl
	call PlaceString
	call BoxDisableSRAM
	inc_hl_ycoord
	push hl
	ld a, $CD ; "No" tile
	ld [hli], a
	ld a, '.'
	ld [hli], a
	call GetCurrentBoxNum
	cp 9
	jr c, .singleDigitBoxNum
	sub 9
	ld [hl], '1'
	inc hl
	add NUMBER_CHAR_OFFSET
	jr .next
.singleDigitBoxNum
	add NUMBER_CHAR_OFFSET + 1 ; wCurrentBoxNum starts at 0 so we need to increment it by 1
.next
	ld [hli], a
	pop hl
	push hl
	lb de, 0, 4
	add hl, de
	ld a, [wBoxCount]
	push af
	and a
	jr z, .noBallTile
	cp 20
	ld a, $D5 ; normal pokeball tile
	jr nz, .loadBallTile
	inc a ; x over pokeball tile
.loadBallTile
	ld [hl], a
.noBallTile
	pop af
	pop hl
	inc_hl_ycoord
	ld de, wSum
	ld [de], a
	lb bc, 1, 2
	call PrintNumber
	ld de, BoxOutOf20
	jp PlaceString

InitializeBoxNamesInSRAM:
	; initialize the custom pokeball names in the sram save data. We cannot permanently store them in wram due to their size.
	; instead we will copy them over to wram only when displaying the customization menus.
	call BoxEnableSRAM
	; initialize the ball names to be blank
	ld hl, sBoxNames
	ld a, '@'
	ld bc, NUM_BOXES * BOX_NAME_LENGTH
	call FillMemory
	; initialize the renamed flags
	ld hl, sBoxRenamedFlags
	ld a, 0
	ld bc, sBoxRenamedFlagsEnd - sBoxRenamedFlags
	call FillMemory
	; then copy over the default names
	lb bc, NUM_BOXES, BOX_NAME_LENGTH
	ld hl, sBoxNames
	ld d, 1
.loopCopyNames
	push hl
	push de
	ld de, BoxText
	call CopyString
	pop de
	dec hl
	ld [hl], ' '
	ld a, d
	cp 10
	jr c, .oneDigit
	ld [hl], '1'
	sub 10
.oneDigit
	inc hl
	add NUMBER_CHAR_OFFSET
	ld [hl], a
	pop hl
	push bc
	ld b, 0
	add hl, bc
	pop bc
	inc d 
	dec b
	jr nz, .loopCopyNames
	; fall through
BoxDisableSRAM:
   	xor a
  	ld [rBMODE], a
  	ld [rRAMG], a
  	ret

BoxEnableSRAM:
	ld a, RAMG_SRAM_ENABLE
  	ld [rRAMG], a
  	ld a, $1
  	ld [rBMODE], a
  	xor a
	ld [rRAMB], a
	ret

BoxText:
	db "BOX@"
BoxOutOf20:
	db "/20@"

_RenameCurrentBox::
	ld hl, .renameBoxQuestion
	rst _PrintText
	call YesNoChoice
	ret nz

	ld a, NAME_BOX_SCREEN
	ld [wNamingScreenType], a
	callfar DisplayNamingScreen

	ld a, [wStringBuffer]
	cp '@'
	jr z, .reload ; if the player didnt type in any name don't change it

	call BoxEnableSRAM
	call GetCurrentBoxNum
	push af
	ld b, FLAG_SET
	ld c, a
	ld hl, sBoxRenamedFlags
	call FlagAction
	pop af
	ld hl, sBoxNames
	ld bc, BOX_NAME_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, wStringBuffer
	ld bc, BOX_NAME_LENGTH
	rst _CopyData
	call BoxDisableSRAM
.reload
	jp LoadBillsPCExtraTiles
.renameBoxQuestion
	text_far _RenameCurrentBoxText
	text_end

GetCurrentBoxNum:
	ld a, [wCurrentBoxNum]
	and %01111111
	ret
