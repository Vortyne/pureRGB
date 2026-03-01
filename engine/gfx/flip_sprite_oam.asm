UnflipSpriteOAM::
	ld hl, NormalSpriteOAM
	jr z, SpriteOAMEditCommon

; de = which sprite
FlipSpriteOAM::
	ld hl, FlippedSpriteOAM
SpriteOAMEditCommon::
	push hl
	push de
	ld h, d
	ld l, e
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	ld c, a
	ld d, 4
.loopCopyBaseData
	ld [hl], b
	inc hl
	ld [hl], c
	inc hl
	inc hl
	inc hl
	dec d
	jr nz, .loopCopyBaseData
	pop de
	pop hl
	ld c, 4
.loopCopyOffsets
	ld b, [hl]
	inc hl
	ld a, [de]
	add b
	ld [de], a
	inc de
	ld b, [hl]
	inc hl
	ld a, [de]
	add b
	ld [de], a
	inc de
	inc de
	ld a, [hli]
	and %11110000 ; remove data stored in GBC attribute bits
	ld [de], a
	inc de
	dec c
	jr nz, .loopCopyOffsets
	rst _DelayFrame
	ret