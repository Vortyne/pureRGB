; Copy the current map's sprites' tile patterns to VRAM again after they have
; been overwritten by other tile patterns.
ReloadMapSpriteTilePatterns::
	ld hl, wFontLoaded
	ld a, [hl]
	push af
	res BIT_FONT_LOADED, [hl]
	push hl
	ld hl, hFlagsFFFA
	res 2, [hl] ; outside map sprites need to be fully reloaded
	call DisableLCD
	farcall InitMapSprites
	call EnableLCD
	pop hl
	pop af
	ld [hl], a
	call LoadPlayerSpriteGraphics
	call LoadFontTilePatterns
	callfar LoadExtraSprites ; PureRGBnote: ADDED: at the moment this just replaces a sprite in fuchsia city if we have the need to
	jp UpdateSprites

; PureRGBnote: ADDED: which VRAM slot a sprite's tile patterns are loaded in depends on the map's sprites
; (and for outside maps, on which sprites the previous map had loaded), so use this to find them.
; input: a = sprite picture ID
; output: hl = VRAM address of the first tile of that sprite's tile patterns,
;         carry set if no sprite in the current map uses that picture ID
; preserves bc and de
GetSpriteVRAMAddress::
	push bc
	ld b, a
	ld hl, wSprite01StateData1PictureID
.loop
	ld a, [hl] ; [x#SPRITESTATEDATA1_PICTUREID]
	cp b
	jr z, .found
	ld a, l
	add SPRITESTATEDATA1_LENGTH
	ld l, a
	jr nz, .loop
	pop bc
	scf
	ret
.found
	pop bc
	inc h ; HIGH(wSpriteStateData2)
	ld a, l
	add SPRITESTATEDATA2_IMAGEBASEOFFSET - SPRITESTATEDATA1_PICTUREID
	ld l, a
	ld a, [hl] ; [x#SPRITESTATEDATA2_IMAGEBASEOFFSET]
	; fall through

; input: a = VRAM slot (as stored in x#SPRITESTATEDATA2_IMAGEBASEOFFSET)
; output: hl = VRAM address of the first tile of the slot, carry unset
GetSpriteVRAMSlotAddress::
	cp 11
	jr nc, .fourTileSprite
; hl = vNPCSprites + (VRAM slot - 1) * 12 tiles
	dec a
	ld l, a
	add a
	add l
	ld h, a
	ld l, 0
	srl h
	rr l
	srl h
	rr l ; hl = (VRAM slot - 1) * 3 * 64
	ld a, h
	add HIGH(vNPCSprites)
	ld h, a
	ret
.fourTileSprite
	ld hl, vNPCSprites tile $78 ; first 4-tile sprite
	sub 11
	ret z
	ld l, LOW(vNPCSprites tile $7C) ; second 4-tile sprite
	ret
