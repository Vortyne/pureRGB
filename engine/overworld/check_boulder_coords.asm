; tests if a boulder's coordinates are in a specified array
; INPUT:
; de = address of array
; c = bank of array
; [hSpriteIndex] = index of boulder sprite
; OUTPUT:
; [wCoordIndex] = if there is match, the matching array index
; sets carry if the coordinates are in the array, clears carry if not
CheckBoulderCoords::
	ld a, c
	ld h, d
	ld l, e
	ld de, wSwitchOrHoleCoordList 
	push de
	ld bc, 5 ; max length of the coord lists ever passed into this function
	call FarCopyData2
	pop hl ; wSwitchOrHoleCoordList, which now has the coords copied into it from the map bank
	push hl
	ld hl, wSpritePlayerStateData2MapY
	ldh a, [hSpriteIndex]
	swap a
	ld d, $0
	ld e, a
	add hl, de
	ld a, [hli]
	sub $4 ; because sprite coordinates are offset by 4
	ld b, a
	ld a, [hl]
	sub $4 ; because sprite coordinates are offset by 4
	ld c, a
	pop hl
	jp CheckCoords
