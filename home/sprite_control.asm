; PureRGBnote: ADDED: some small functions for changing sprite facings or basic sprite movement were added to home bank
; since they are used a lot in new areas.
; a = which sprite
SetSpriteFacingRight::
	ld b, SPRITE_FACING_RIGHT
	jr ChangeSpriteFacing
; a = which sprite
SetSpriteFacingLeft::
	ld b, SPRITE_FACING_LEFT
	jr ChangeSpriteFacing
; a = which sprite
SetSpriteFacingUp::
	ld b, SPRITE_FACING_UP
	jr ChangeSpriteFacing
; a = which sprite
SetSpriteFacingDown::
	ld b, SPRITE_FACING_DOWN
; a = which sprite
; b = which facing
ChangeSpriteFacing::
	ldh [hSpriteIndex], a
	ld a, b
	ldh [hSpriteFacingDirection], a
	jp SetSpriteFacingDirection

ReadHLIntoCFromMapRomBank::
	ldh a, [hLoadedROMBank]
	push af
	ldh a, [hMapROMBank]
	call SetCurBank
	ld c, [hl]
	pop af
	jp SetCurBank
	
GenericMoveDown::
	db NPC_MOVEMENT_DOWN
	db -1

GenericMoveLeft::
	db NPC_MOVEMENT_LEFT
	db -1

GenericMoveUp::
	db NPC_MOVEMENT_UP
	db -1

GenericMoveRight::
	db NPC_MOVEMENT_RIGHT
	db -1

MoveSpriteButAllowAOrBPress::
	call MoveSprite
	ld hl, wJoyIgnore
	res BIT_B_BUTTON, [hl]
	res BIT_A_BUTTON, [hl]
	ret

; d = x coord
; e = y coord
; return z if at coords nz if not
IsPlayerAtCoords::
	ld a, [wXCoord]
	cp d
	ret nz
	ld a, [wYCoord]
	cp e
	ret

