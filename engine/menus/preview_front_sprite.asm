; input e = which offset in the list of pokemon
PreviewFrontSprite::
	ld hl, ShowWhichSpriteList
	ld d, 0
	add hl, de
	ld a, [wTopMenuItemY]
	sub 3
	srl a
	ld e, a
	add hl, de
	ld a, [hl] ; which pokemon to show the sprite of
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	ld b, SET_PAL_MIDDLE_SCREEN_MON_BOX
	call RunPaletteCommand
	; check which text will display in the popup by looking at the tiles currently displaying on the screen
	; have to do this before displaying the image textbox
	hlcoord 0, 0
	ld a, [wTopMenuItemX]
	ld d, 0
	ld e, a
	add hl, de
	ld a, [wTopMenuItemY]
	ld bc, SCREEN_WIDTH
	call AddNTimes
	inc hl
	inc hl
	ld a, [hl]
	push af ; save the value for after drawing the textbox
	call .displayPopup
	hlcoord 2, 14
	lb bc, 2, 15
	call TextBoxBorder
	pop af
	ld hl, SpriteTypeMapping
	ld de, 3
	call IsInArray
	ld de, YellowText
	jr nc, .printSpriteType
	inc hl
	de_deref
.printSpriteType
	ld hl, hUILayoutFlags
	set BIT_SINGLE_SPACED_LINES, [hl]
	push hl
	hlcoord 3, 15
	call PlaceString
	pop hl
	res BIT_SINGLE_SPACED_LINES, [hl]
	call GetMonHeader
	ldh a, [hTileAnimations]
	push af
	xor a
	ldh [hTileAnimations], a
	hlcoord 7, 5
	call LoadFrontSpriteByMonIndex
	call Delay3
	call WaitForTextScrollButtonPress
	call .displayPopup ; hide pokemon sprite by re-displaying the popup
	call Delay3
	pop af
	ldh [hTileAnimations], a
	call RunDefaultPaletteCommand
	SetEvent FLAG_RELOAD_TILESET_IN_OPTION_MENU
	ret 
.displayPopup
	ld a, MON_SPRITE_POPUP
	ld [wTextBoxID], a
	jp DisplayTextBoxID
	
ShowWhichSpriteList:
	db BULBASAUR
	db SQUIRTLE
	db BLASTOISE
	db BUTTERFREE
	db PIDGEOTTO
	db PIDGEOT
	db RATICATE
	db SPEAROW
	db NIDORINO
	db GOLBAT
	db GOLDUCK
	db MANKEY
	db ARCANINE
	db ABRA
	db KADABRA
	db MACHOP
	db TENTACRUEL
	db GRAVELER
	db FARFETCHD
	db CLOYSTER
	db GENGAR
	db ONIX
	db VOLTORB
	db EXEGGCUTE
	db EXEGGUTOR
	db KOFFING
	db STARMIE
	db SCYTHER
	db JYNX
	db ELECTABUZZ
	db PINSIR
	db OMANYTE
	db ARTICUNO
	db ZAPDOS
	db MEWTWO

; based on what character is +2 x-index from the cursor, we choose what text will display when viewing the sprite
SpriteTypeMapping:
	dbw "B", RedBlueText
	dbw "G", RedGreenText
	dbw "W", SpaceworldText
	db -1 

RedBlueText:
	db "International"
	next "Red/Blue Sprite@"

RedGreenText:
	db "Japanese Red /"
	next "Green Sprite@"

YellowText:
	db "Yellow Version"
	next "Sprite@"

SpaceworldText:
	db "Spaceworld '97"
	next "Sprite@"

