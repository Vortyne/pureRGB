CheckDrawItemCount::
	; make sure we're in a list menu for items, otherwise we dont want any counts printed
	ld a, [wListMenuID]
	cp ITEMLISTMENU
	ret nz
	; check if it's a pokemart sell menu (don't want count in this scenario)
	ld hl, wNewInGameFlags
	bit IN_POKEMART_MENU, [hl]
	ret nz
	; check if we're displaying the item list or box item list, if so, show a count of how many items there are
	ld hl, wListPointer
	hl_deref
	ld de, wNumBagItems
	ld a, h
	cp d
	jr nz, .notBagItems
	ld a, l
	cp e
	jr nz, .notBagItems
.bagItems
	ld hl, wListMenuNewFlags
	bit BIT_LOADED_ITEM_COUNT_TEXTBOX, [hl]
	set BIT_LOADED_ITEM_COUNT_TEXTBOX, [hl]
	jr nz, .noLoadTextBox1
	call .loadTextBox
	hlcoord 5, 1
	ld de, ItemsText
	call PlaceString
.noLoadTextBox1
	ld a, [wNumBagItems]
	ld b, a
	ld c, BAG_ITEM_CAPACITY
	jr .loadText
.notBagItems
	ld de, wNumBoxItems
	ld a, h
	cp d
	ret nz
	ld a, l
	cp e
	ret nz
.boxItems
	ld hl, wListMenuNewFlags
	bit BIT_LOADED_ITEM_COUNT_TEXTBOX, [hl]
	set BIT_LOADED_ITEM_COUNT_TEXTBOX, [hl]
	jr nz, .noLoadTextBox2
	call .loadTextBox
	hlcoord 5, 1
	ld [hl], "<BOLD_P2>"
	inc hl
	ld [hl], "<BOLD_C>"
	hlcoord 8, 1
	ld de, ItemsText
	call PlaceString
.noLoadTextBox2
	ld a, [wNumBoxItems]
	ld b, a
	ld c, PC_ITEM_CAPACITY
.loadText
	hlcoord 14, 1
	ld de, w2CharStringBuffer
	ld a, b
	ld [de], a
	inc de
	ld a, c
	ld [de], a
	dec de
	lb bc, 1 | LEADING_ZEROES, 2
	call PrintNumber
	ld [hl], "/"
	inc hl
	inc de
	inc de
	call PrintNumber
	hlcoord  4, 2
	ld [hl], $65
	hlcoord 19, 2
	ld [hl], $66
	ret
.loadTextBox
	hlcoord 4, 0
	lb bc, 1, 14 ; width, height
	jp TextBoxBorderUpdateSprites

ItemsText:
	db"<BOLD_I><BOLD_T><BOLD_E><BOLD_M><SMALL_S>@"
