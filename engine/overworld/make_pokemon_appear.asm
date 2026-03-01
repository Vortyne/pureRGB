; Plays a "ball poof" animation and shows the given pokemon's party sprite in the overworld
; An existing overworld sprite is used for this, and you must move it back later with the other function
; and reload with the old sprite if necessary after
; input hl = coordinate relation with player it should appear at
;     h = how many coords left or right of player -1 = left 1 = right
;     l = how many coords up or down of player -1 = up 1 = down
; b = which existing overworld sprite to move
; c = which pokemon species ID
; de = where in VRAM to load it
MakePokemonAppearInOverworld::
	ld d, SFX_BALL_POOF
	ld hl, .more
	jp PlayBattleSFXWhenNotInBattle
.more
	call GetPredefRegisters
	push bc
	push de
	push de
	push hl
	push bc
	ld a, b
	call SetSpriteFacingDown
	pop bc
	ld c, b
	pop de ; pop hl into de
	callfar FarMoveSpriteInRelationToPlayer
	pop de ; pop the VRAM location into de
	callfar FarLoadSmokeTileFourTimes
	call UpdateSprites
	ld c, 8
	rst _DelayFrames
	pop de
	pop bc
	callfar FarLoadPartyMonSpriteIntoVRAMScreenOn
	jp UpdateSprites

; Makes a sprite disappear in a poof and moves it to the provided coordinates
; hl = map coordinates it should end up at after
; de = VRAM location of the sprite
; b = which existing overworld sprite to move
MakePokemonDisappearInOverworld::
	ld d, SFX_BALL_POOF
	ld hl, .more
	jp PlayBattleSFXWhenNotInBattle
.more
	call GetPredefRegisters
	push hl
	push bc
	callfar FarLoadSmokeTileFourTimes
	call UpdateSprites
	ld c, 8
	rst _DelayFrames
	pop bc
	; c = which pokemon
	pop de ; pop hl into de
	callfar FarMoveSpriteOffScreen
	jp UpdateSprites
