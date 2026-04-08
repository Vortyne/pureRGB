; PureRGBnote: ADDED: code for performing item duplication "glitch" when encountering missingno.
; except now it's intended functionality
; it only triggers if we have watched the old man catch a pokemon since the last time we turned the game on before encountering missingno.
MissingNoBattleStart::
	ld a, [wNewInGameFlags]
	bit ITEM_DUPLICATION_ACTIVE, a
	ret z
	ld hl, wBagItems + 10 ; sixth item in bag
	ld a, [hli]
	push hl
	ld [wCurItem], a
	callfar IsKeyItem_
	ld a, [wIsKeyItem]
	pop hl
	and a
	ret nz ; don't dupe key items since there's no point and it can cause other issues since the game will internally think you have multiple
	set 7, [hl] ; adds 128 to the quantity, if you don't already have 128.
	; PureRGBnote: FIXED: Now we will make sure the player can't have 255 of an item, because it can cause glitches with the item list.
	ld a, [hl]
	cp $FF
	ret nz
	dec [hl] ; make it 254 if it was at 255
	ret
