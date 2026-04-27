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
	res B_PAD_B, [hl]
	res B_PAD_A, [hl]
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

EnableSpriteUpdates::
	ld a, 1
	jr ChangeUpdateSpritesEnabled
DisableSpriteUpdates::
	ld a, $FF
	; fall through
ChangeUpdateSpritesEnabled:
	ld [wUpdateSpritesEnabled], a
	ret

UpdateSpritesAndDelay3::
	call UpdateSprites
	jp Delay3

EnableAllJoypad::
	xor a
	jr DisableAllJoypad.load

DisableDpad::
	ld a, PAD_CTRL_PAD
	jr DisableAllJoypad.load

DisableAllJoypad::
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
.load
	ld [wJoyIgnore], a
	ret

ResetMapScripts::
	call EnableAllJoypad
	; a = 0 from EnableAllJoypad
	ld [wCurMapScript], a
	ret

; returns nz if the map has just been loaded
WasMapJustLoaded::
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret
