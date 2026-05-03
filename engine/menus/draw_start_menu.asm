; function that displays the start menu
DrawStartMenu::
	CheckEvent EVENT_GOT_POKEDEX
; menu with pokedex
	hlcoord 10, 0
	lb bc, 14, 8
	jr nz, .drawTextBoxBorder
; shorter menu if the player doesn't have the pokedex
	ld b, 12
.drawTextBoxBorder
	call TextBoxBorder
	; PureRGBnote: CHANGED: now SELECT button is tracked on this menu. Used in the new box-switching anywhere functionality.
	ld a, PAD_START | PAD_B | PAD_A | PAD_SELECT
	ld [wMenuWatchedKeys], a
	ld hl, wTopMenuItemY
	ld [hl], 2 ; Y position of first menu choice
	inc hl
	ld [hl], 11 ; X position of first menu choice
	call CheckSavedStartMenuIndex
	xor a
	ld [wMenuWatchMovingOutOfBounds], a
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	hlcoord 12, 2
	CheckEvent EVENT_GOT_POKEDEX
; case for not having pokedex
	ld a, 5
	ld de, StartMenuWithoutPokedexText
	bccoord 12, 6
	jr z, .storeMenuItemCount
	inc a
	ld de, StartMenuWithPokedexText
	bccoord 12, 8
.storeMenuItemCount
	ld [wMaxMenuItem], a ; number of menu items
	push bc
	call PlaceString
	pop hl ; pop bc into hl
	ld de, wPlayerName ; player's name
	push hl
	call PlaceString
	pop hl
	ld a, [wStatusFlags4]
	bit BIT_LINK_CONNECTED, a
	jr z, .skipResetText
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	ld de, StartMenuResetText
	call PlaceString
.skipResetText
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call GetStartMenuPrompt
	callfar PrintSafariZoneSteps ; print Safari Zone info, if in Safari Zone
	call LoadGBPal ; shinpokerednote: gbcnote: moved to redisplaystartmenu for better visual effect
	jp UpdateSprites

; PureRGBnote: ADDED: this code will remember the start menu's last selection in specific scenarios where it's usually cleared.
;                     Example: after going into a wild battle caused by fishing.
CheckSavedStartMenuIndex: 
	ld a, [wBattleAndStartSavedMenuItem] ; remembered menu selection from last time
	and a
	jr nz, .done
	ld a, [wExtraSavedStartMenuIndex] ; remembered menu selection even after a battle - like when a fishing encounter occurred
	and a
	jr z, .done
	push bc
	ld b, a
	xor a
	ld [wExtraSavedStartMenuIndex], a
	ld a, b
	pop bc
.done
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ret

StartMenuWithPokedexText:
	db "#DEX"
	next
StartMenuWithoutPokedexText:
	db "#MON"
	next "ITEM"
	next ; leave this row blank for the character name
	next "SAVE"
	next "OPTION"
	next "EXIT@"

StartMenuResetText:
	db "RESET@"
