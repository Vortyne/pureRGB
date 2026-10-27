PrepareOAMData::
; Determine OAM data for currently visible
; sprites and write it to wShadowOAM.

	ld a, [wUpdateSpritesEnabled]
	dec a
	jr z, .updateEnabled

	cp -1
	ret nz
	ld [wUpdateSpritesEnabled], a
	jp HideSprites

.updateEnabled
	xor a
	ldh [hOAMBufferOffset], a

.spriteLoop
	ldh [hSpriteOffset2], a

	ld d, HIGH(wSpriteStateData1)
	;ldh a, [hSpriteOffset2] ; pointless load
	ld e, a
	ld a, [de] ; [x#SPRITESTATEDATA1_PICTUREID]

	and a
	jp z, .nextSprite

	inc e
	inc e
	ld a, [de] ; [x#SPRITESTATEDATA1_IMAGEINDEX]
	cp $ff ; off-screen (don't draw)
	jp z, .nextSprite ; PureRGBnote: OPTIMIZED: no need to call GetSpriteScreenXY here, the adjusted coords it wrote were never read

;;;;;;;;;; PureRGBnote: OPTIMIZED: everything that is the same for all 4 tiles of a sprite is now calculated once per sprite
;;;;;;;;;; instead of once per tile, and the tile loop is unrolled (every overworld sprite is always 4 tiles)
	ld c, a ; c = image index

; get sprite priority
	inc d
	ld a, e
	add SPRITESTATEDATA2_GRASSPRIORITY - SPRITESTATEDATA1_IMAGEINDEX
	ld e, a
	ld a, [de] ; [x#SPRITESTATEDATA2_GRASSPRIORITY]
	dec d
	and OAM_PRIO
	ld b, a ; b = priority of the bottom tiles (the ones that can be covered by grass)
	ld a, [wCurMap]
	cp CELADON_BACK_ALLEY ; in this map the whole sprite is covered when standing in "grass"
	ld a, b
	jr z, .topPriority
	xor a
.topPriority
	ldh [hSpritePriority], a ; priority of the top tiles

; get sprite screen position (with the OAM offsets already added)
	ldh a, [hSpriteOffset2]
	add SPRITESTATEDATA1_YPIXELS
	ld e, a
	ld a, [de] ; [x#SPRITESTATEDATA1_YPIXELS]
	add OAM_Y_OFS ; Y=16 is top of screen (Y=0 is invisible)
	ldh [hSpriteScreenY], a
	inc e
	inc e
	ld a, [de] ; [x#SPRITESTATEDATA1_XPIXELS]
	add OAM_X_OFS ; X=8 is left of screen (X=0 is invisible)
	ldh [hSpriteScreenX], a

; read the entry from the table
	ld a, c
	cp $a0 ; is the sprite unchanging like an item ball or boulder?
	jr c, .usefacing
; unchanging
	and $f
	add $10 ; skip to the second half of the table which doesn't account for facing direction
	jr .next
.usefacing
	and $f
.next
	ld l, a
	ld h, 0
	ld de, SpriteFacingAndAnimationTable
	add hl, hl
	add hl, hl
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a ; de = list of the sprite's 4 tile ids
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = OAM y, x, attributes of the sprite's 4 tiles
	ld a, [de]
	ld e, a ; e = first tile id (the other 3 always follow it in order)

; get the sprite's tile offset in VRAM
	ld a, c
	swap a ; high nybble determines sprite used (0 is always player sprite, next are some npcs)
	and $f
; Sprites $a and $b have one face (and therefore 4 tiles instead of 12).
; As a result, sprite $b's tile offset is less than normal.
	cp $b
	jr nz, .notFourTileSprite
	ld a, $a * 12 + 4
	jr .next2
.notFourTileSprite
	; a *= 12
	add a
	add a
	ld d, a
	add a
	add d
.next2
	add e
	ld c, a ; c = tile id of the first tile

	ldh a, [hOAMBufferOffset]
	ld e, a
	ld d, HIGH(wShadowOAM)

FOR n, 4
	ldh a, [hSpriteScreenY]
	add [hl] ; add Y offset from table
	ld [de], a ; write new sprite OAM Y position
	inc hl
	inc e
	ldh a, [hSpriteScreenX]
	add [hl] ; add X offset from table
	ld [de], a ; write new sprite OAM X position
	inc hl
	inc e
	ld a, c
	IF n < 3
		inc c
	ENDC
	ld [de], a ; tile id
	inc e
	IF n < 2
		ldh a, [hSpritePriority] ; top tiles
	ELSE
		ld a, b ; bottom tiles
	ENDC
	or [hl]
	; gbcnote: clear the table-only flags (BIT_END_OF_OAM_DATA, BIT_SPRITE_UNDER_GRASS) and the GBC VRAM bank/palette bits
	; so the sprite uses VRAM bank 0 and GBC OBJ palette 0. NormalSpriteOAM/FlippedSpriteOAM never use DMG palette OBP1,
	; which the old per-tile code would have mapped to GBC OBJ palette 4.
	and %11110000
	ld [de], a ; attributes
	inc e
	IF n < 3
		inc hl
	ENDC
ENDR

	ld a, e
	ldh [hOAMBufferOffset], a
;;;;;;;;;;

.nextSprite
	ldh a, [hSpriteOffset2]
	add $10
	cp LOW($100)
	jp nz, .spriteLoop

	; Clear unused OAM.
	ldh a, [hOAMBufferOffset]
	ld l, a
	ld h, HIGH(wShadowOAM)
	ld de, OBJ_SIZE
	ld b, SCREEN_HEIGHT_PX + OAM_Y_OFS
	ld a, [wMovementFlags]
	bit BIT_LEDGE_OR_FISHING, a
	ld a, LOW(wShadowOAMEnd)
	jr z, .clear

; Don't clear the last 4 entries because they are used for the shadow in the
; jumping down ledge animation and the rod in the fishing animation.
	ld a, LOW(wShadowOAMSprite36)

.clear
	cp l
	ret z
	ld [hl], b
	add hl, de
	jr .clear
