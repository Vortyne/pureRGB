; Loads tile patterns for map's sprites.
; For outside maps, it loads one of several fixed sets of sprites.
; For inside maps, it loads each sprite picture ID used in the map header.
; This is also called after displaying text because loading
; text tile patterns overwrites half of the sprite tile pattern data.
; Note on notation:
; x#SPRITESTATEDATA1_* and x#SPRITESTATEDATA2_* are used to denote wSpriteStateData1 and
; wSpriteStateData2 sprite slot, respectively, within loops. The X is the loop index.
; If there is an inner loop, Y is the inner loop index, i.e. y#SPRITESTATEDATA1_* and
; y#SPRITESTATEDATA2_* denote fields of the sprite slots iterated over in the inner loop.
InitMapSprites::
	call InitOutsideMapSprites
	ret c ; return if the map is an outside map (already handled by above call)
; if the map is an inside map (i.e. mapID >= FIRST_INDOOR_MAP)
	ld hl, wSpritePlayerStateData1PictureID
	ld de, wSpritePlayerStateData2PictureID
; Loop to copy picture IDs from [x#SPRITESTATEDATA1_PICTUREID]
; to [x#SPRITESTATEDATA2_PICTUREID] for LoadMapSpriteTilePatterns.
.copyPictureIDLoop
	ld a, [hl] ; a = [x#SPRITESTATEDATA1_PICTUREID]
	ld [de], a ; [x#SPRITESTATEDATA2_PICTUREID] = a
	ld a, SPRITESTATEDATA1_LENGTH
	add e
	ld e, a
	ld a, SPRITESTATEDATA1_LENGTH
	add l
	ld l, a
	jr nz, .copyPictureIDLoop

; This is used for both inside and outside maps, since it is called by
; InitOutsideMapSprites.
; Loads tile pattern data for sprites into VRAM.
LoadMapSpriteTilePatterns:
	ld a, [wNumSprites]
	and a ; are there any sprites?
	ret z
.spritesExist
	ld c, a ; c = [wNumSprites]
	ld b, NUM_SPRITESTATEDATA_STRUCTS
	ld hl, wSpritePlayerStateData2PictureID
	xor a
	ldh [hFourTileSpriteCount], a
; Loop to copy picture IDs from [x#SPRITESTATEDATA2_PICTUREID]
; to [x#SPRITESTATEDATA2_IMAGEBASEOFFSET].
.copyPictureIDLoop
	ld a, [hli] ; a = [x#SPRITESTATEDATA2_PICTUREID]
	ld [hld], a ; [x#SPRITESTATEDATA2_IMAGEBASEOFFSET] = a
	ld a, l
	add SPRITESTATEDATA1_LENGTH
	ld l, a
	dec b
	jr nz, .copyPictureIDLoop
	ld hl, wSprite01StateData2ImageBaseOffset
.loadTilePatternLoop
	ld de, wSprite01StateData2PictureID
; Check if the current picture ID has already had its tile patterns loaded.
; This done by looping through the previous sprite slots and seeing if any of
; their picture ID's match that of the current sprite slot.
.checkIfAlreadyLoadedLoop
	ld a, e
	and $f0
	ld b, a ; b = offset of the wSpriteStateData2 sprite slot being checked against
	ld a, l
	and $f0 ; a = offset of current wSpriteStateData2 sprite slot
	cp b ; done checking all previous sprite slots?
	jr z, .notAlreadyLoaded
	ld a, [de] ; picture ID of the wSpriteStateData2 sprite slot being checked against
	cp [hl] ; do the picture ID's match?
	jp z, .alreadyLoaded
	ld a, e
	add SPRITESTATEDATA1_LENGTH
	ld e, a
	jr .checkIfAlreadyLoadedLoop
.notAlreadyLoaded
	ld de, wSpritePlayerStateData2ImageBaseOffset
	ld b, 1
; loop to find the highest tile pattern VRAM slot (among the first 10 slots) used by a previous sprite slot
; this is done in order to find the first free VRAM slot available
.findNextVRAMSlotLoop
	ld a, e
	add SPRITESTATEDATA1_LENGTH
	ld e, a
	ld a, l
	cp e ; reached current slot?
	jr z, .foundNextVRAMSlot
	ld a, [de] ; y#SPRITESTATEDATA2_IMAGEBASEOFFSET
	cp 11 ; is it one of the first 10 slots?
	jr nc, .findNextVRAMSlotLoop
	cp b ; compare the slot being checked to the current max
	jr c, .findNextVRAMSlotLoop ; if the slot being checked is less than the current max
; if the slot being checked is greater than or equal to the current max
	ld b, a ; store new max VRAM slot
	jr .findNextVRAMSlotLoop
.foundNextVRAMSlot
	inc b ; increment previous max value to get next VRAM tile pattern slot
	ld a, b ; a = next VRAM tile pattern slot
	push af
	ld a, [hl] ; [x#SPRITESTATEDATA2_IMAGEBASEOFFSET]
	ld b, a ; b = current sprite picture ID
	cp FIRST_STILL_SPRITE ; is it a 4-tile sprite?
	jr c, .notFourTileSprite
	pop af
	ldh a, [hFourTileSpriteCount]
	add 11
	jr .storeVRAMSlot
.notFourTileSprite
	pop af
.storeVRAMSlot
	ld [hl], a ; store VRAM slot at [x#SPRITESTATEDATA2_IMAGEBASEOFFSET]
	ldh [hVRAMSlot], a ; used to determine if it's 4-tile sprite later
	ld a, b ; a = current sprite picture ID
	dec a
	add a
	add a
	push bc
	push hl
	ld hl, SpriteSheetPointerTable
	jr nc, .noCarry
	inc h
.noCarry
	add l
	ld l, a
	jr nc, .noCarry2
	inc h
.noCarry2
	push hl
	call ReadSpriteSheetData
	push af
	push de
	push bc
	ld hl, vNPCSprites ; VRAM base address
	ld bc, 12 tiles ; number of bytes per VRAM slot
	ldh a, [hVRAMSlot]
	cp 11 ; is it a 4-tile sprite?
	jr nc, .fourTileSpriteVRAMAddr
	ld d, a
	dec d
; hl = vSprites + [hVRAMSlot] * 12 tiles
.calculateVRAMAddrLoop
	add hl, bc
	dec d
	jr nz, .calculateVRAMAddrLoop
	jr .loadStillTilePattern
.fourTileSpriteVRAMAddr
	ld hl, vSprites tile $7c ; address for second 4-tile sprite
	ldh a, [hFourTileSpriteCount]
	and a
	jr nz, .loadStillTilePattern
; if it's the first 4-tile sprite
	ld hl, vSprites tile $78 ; address for first 4-tile sprite
	inc a
	ldh [hFourTileSpriteCount], a
.loadStillTilePattern
	pop bc
	pop de
	pop af
	push hl
	push hl
	ld h, d
	ld l, e
	pop de
	ld b, a
	ld a, [wFontLoaded]
	bit BIT_FONT_LOADED, a ; reloading upper half of tile patterns after displaying text?
	jr nz, .skipFirstLoad ; if so, skip loading data into the lower half
	ld a, b
	ld b, 0
	call FarCopyData4 ; load tile pattern data for sprite when standing still
.skipFirstLoad
	pop de
	pop hl
	ldh a, [hVRAMSlot]
	cp 11 ; is it a 4-tile sprite?
	jr nc, .skipSecondLoad ; if so, there is no second block
	push de
	call ReadSpriteSheetData
	push af
	ld a, $c0
	add e
	ld e, a
	jr nc, .noCarry3
	inc d
.noCarry3
	ld a, [wFontLoaded]
	bit BIT_FONT_LOADED, a ; reloading upper half of tile patterns after displaying text?
	jr nz, .loadWhileLCDOn
	pop af
	pop hl
	set 3, h ; add $800 ($80 tiles) to hl (1 << 3 == $8)
	push hl
	ld h, d
	ld l, e
	pop de
	call FarCopyData4 ; load tile pattern data for sprite when walking
	jr .skipSecondLoad
; When reloading the upper half of tile patterns after displaying text, the LCD
; will be on, so CopyVideoDataHBlank (which writes to VRAM only during V-blank and Hblank) must
; be used instead of FarCopyData4.
.loadWhileLCDOn
	pop af
	pop hl
	set 3, h ; add $800 ($80 tiles) to hl (1 << 3 == $8)
	ld b, a
	swap c
	call CopyVideoDataHBlank ; load tile pattern data for sprite when walking
.skipSecondLoad
	pop hl
	pop bc
	jr .nextSpriteSlot
.alreadyLoaded ; if the current picture ID has already had its tile patterns loaded
	inc de
	ld a, [de] ; a = [y#SPRITESTATEDATA2_IMAGEBASEOFFSET]
	ld [hl], a ; [x#SPRITESTATEDATA2_IMAGEBASEOFFSET] = a
.nextSpriteSlot
	ld a, l
	add SPRITESTATEDATA2_LENGTH
	ld l, a
	dec c
	jp nz, .loadTilePatternLoop
	ld hl, wSpritePlayerStateData2PictureID
	ld b, NUM_SPRITESTATEDATA_STRUCTS
; the pictures IDs stored at [x#SPRITESTATEDATA2_PICTUREID] are no longer needed,
; so zero them
.zeroStoredPictureIDLoop
	xor a
	ld [hl], a ; [x#SPRITESTATEDATA2_PICTUREID]
	ld a, SPRITESTATEDATA2_LENGTH
	add l
	ld l, a
	dec b
	jr nz, .zeroStoredPictureIDLoop
	ret

; reads data from SpriteSheetPointerTable
; INPUT:
; hl = address of sprite sheet entry
; OUTPUT:
; de = pointer to sprite sheet
; bc = length in bytes
; a = ROM bank
ReadSpriteSheetData:
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	xor a
	ld b, a
	ld a, [hli]
	ret

; Loads sprites for outside maps (cities and routes) and sets VRAM slots.
;;;;;;;;;; PureRGBnote: CHANGED: outside maps no longer use fixed sprite sets that had to be shared between connected maps.
;;;;;;;;;; Instead, wSpriteSet keeps track of which sprite picture IDs are loaded in VRAM (entries 0-8 are VRAM slots 2-10
;;;;;;;;;; for 12-tile sprites, entries 9-10 are VRAM slots 11-12 for 4-tile sprites). Sprites that are already loaded stay in
;;;;;;;;;; their VRAM slot, and only the sprites the map uses that aren't loaded yet get loaded (LCD can stay on), replacing
;;;;;;;;;; sprites the map doesn't use. So walking between connected outside maps only loads the sprites that differ.
;;;;;;;;;; Use GetSpriteVRAMAddress to find where a sprite's tile patterns are instead of assuming a VRAM slot.
; sets carry if the map is a city or route, unsets carry if not
InitOutsideMapSprites:
	ASSERT HIGH(wSpriteSet) == HIGH(wSpriteSet + SPRITE_SET_LENGTH)
	ld a, [wCurMap]
	cp FIRST_INDOOR_MAP ; is the map a city or a route?
	jr c, .outsideMap
; inside maps load their sprites in their own order, so forget which sprites are loaded
	ld hl, hFlagsFFFA
	res 2, [hl] ; carry is still unset
	ret
.outsideMap
	ld hl, hFlagsFFFA
	bit 2, [hl] ; does wSpriteSet match what is loaded in VRAM?
	jr nz, .spriteSetLoaded
	set 2, [hl]
; nothing is known to be loaded in the sprite VRAM slots yet
	ld hl, wSpriteSet
	ld b, SPRITE_SET_LENGTH
	xor a
.clearSpriteSetLoop
	ld [hli], a
	dec b
	jr nz, .clearSpriteSetLoop
.spriteSetLoaded
	ld a, [wFontLoaded]
	bit BIT_FONT_LOADED, a ; reloading upper half of tile patterns after displaying text?
	jr z, .loadNewSprites
; the text tile patterns overwrote the walking frames of the 12-tile sprites,
; so reload them for the sprites the map uses, and forget the other ones
	ld hl, wSpriteSet
.reloadWalkingFramesLoop
	ld a, [hl]
	and a
	jr z, .nextWalkingFrames
	call IsPictureIDUsedByMap
	jr z, .reloadWalkingFrames
	ld [hl], 0
	jr .nextWalkingFrames
.reloadWalkingFrames
	push hl
	call GetSpriteSetEntryGraphics
	call LoadSpriteWalkingFrames
	pop hl
.nextWalkingFrames
	inc l
	ld a, l
	cp LOW(wSpriteSet + SPRITE_SET_LENGTH - 2) ; end of the 12-tile sprite entries
	jr nz, .reloadWalkingFramesLoop
.loadNewSprites
	ld hl, wSprite01StateData1PictureID
.loadNewSpritesLoop
	ld a, [hl] ; [x#SPRITESTATEDATA1_PICTUREID] (zero if sprite slot is not used)
	and a
	call nz, LoadSpritePictureIfNotLoaded
	ld a, l
	add SPRITESTATEDATA1_LENGTH
	ld l, a
	jr nz, .loadNewSpritesLoop
;;;;;;;;;;
	ld hl, wSprite01StateData1
; This loop stores the correct VRAM tile pattern slots according the sprite
; data from the map's header. Since the VRAM tile pattern slots are filled in
; the order of the sprite set, in order to find the VRAM tile pattern slot
; for a sprite slot, the picture ID for the sprite is looked up within the
; sprite set. The index of the picture ID within the sprite set plus one
; (since the Red sprite always has the first VRAM tile pattern slot) is the
; VRAM tile pattern slot.
.storeVRAMSlotsLoop
	ld c, 0
	ld a, [hl] ; [x#SPRITESTATEDATA1_PICTUREID] (zero if sprite slot is not used)
	and a ; is the sprite slot used?
	jr z, .skipGettingPictureIndex ; if the sprite slot is not used
	ld b, a ; b = picture ID
	ld de, wSpriteSet
; Loop to find the index of the sprite's picture ID within the sprite set.
.getPictureIndexLoop
	inc c
	ld a, [de]
	inc de
	cp b ; does the picture ID match?
	jr nz, .getPictureIndexLoop
	inc c
.skipGettingPictureIndex
	push hl
	inc h ; HIGH(wSpriteStateData2)
	ld a, SPRITESTATEDATA2_IMAGEBASEOFFSET - SPRITESTATEDATA1_PICTUREID
	add l
	ld l, a
	ld a, c ; a = VRAM slot (zero if sprite slot is not used)
	ld [hl], a ; [x#SPRITESTATEDATA2_IMAGEBASEOFFSET]
	pop hl
	ld a, SPRITESTATEDATA1_LENGTH
	add l
	ld l, a
	and a
	jr nz, .storeVRAMSlotsLoop
	scf
	ret

;;;;;;;;;; PureRGBnote: ADDED: functions for loading outside map sprites into VRAM slots

; input: hl = pointer to a (non-zero) sprite picture ID
; output: z if a non-player sprite in the current map uses that picture ID, nz if not
IsPictureIDUsedByMap:
	ld de, wSprite01StateData1PictureID
.loop
	ld a, [de]
	cp [hl]
	ret z
	ld a, e
	add SPRITESTATEDATA1_LENGTH
	ld e, a
	jr nz, .loop
	inc a ; unset z
	ret

; loads a sprite picture ID into a VRAM slot if it isn't loaded already
; input: a = sprite picture ID
; preserves hl
LoadSpritePictureIfNotLoaded:
	push hl
	ld b, a
	ld hl, wSpriteSet
	ld c, SPRITE_SET_LENGTH
.checkLoadedLoop
	ld a, [hli]
	cp b
	jr z, .done
	dec c
	jr nz, .checkLoadedLoop
; find a VRAM slot of the right size that has nothing loaded, or a sprite the current map doesn't use
	ld hl, wSpriteSet
	ld c, LOW(wSpriteSet + SPRITE_SET_LENGTH - 2) ; end of the 12-tile sprite entries
	ld a, b
	cp FIRST_STILL_SPRITE
	jr c, .findSlotLoop
	ld l, c ; start of the 4-tile sprite entries
	ld c, LOW(wSpriteSet + SPRITE_SET_LENGTH)
.findSlotLoop
	ld a, [hl]
	and a
	jr z, .foundSlot
	call IsPictureIDUsedByMap
	jr nz, .foundSlot
	inc l
	ld a, l
	cp c
	jr nz, .findSlotLoop
	jr .done ; no VRAM slot available (the map uses too many different sprites)
.foundSlot
	ld [hl], b
	call GetSpriteSetEntryGraphics
	push bc
	push de
	push hl
	call CopyVideoDataHBlank ; load tile patterns for the sprite when standing still
	pop hl
	pop de
	pop bc
	ld a, c
	cp 12 ; does the sprite have walking frames?
	call z, LoadSpriteWalkingFrames
.done
	pop hl
	ret

; input: hl = pointer to a wSpriteSet entry
; output: hl = VRAM address of the entry's VRAM slot, de = address of the sprite's tile patterns, b = their bank,
;         c = number of tiles (not including the walking frames)
GetSpriteSetEntryGraphics:
	ld a, l
	sub LOW(wSpriteSet)
	add 2 ; VRAM slot = entry index + 2 (VRAM slot 1 is the player)
	push af
	ld a, [hl] ; picture ID
	dec a
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, SpriteSheetPointerTable
	add hl, de
	call ReadSpriteSheetData ; de = tile patterns, c = size in bytes, a = bank
	ld b, a
	swap c ; c = number of tiles
	pop af
	jp GetSpriteVRAMSlotAddress

; input: hl = VRAM address, de = tile patterns, b = bank of the standing still frames of a 12-tile sprite
LoadSpriteWalkingFrames:
	set 3, h ; the walking frames are $80 tiles after the standing still frames in VRAM
	ld a, e
	add LOW(12 tiles) ; and right after them in ROM
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
	ld c, 12
	jp CopyVideoDataHBlank
;;;;;;;;;;

INCLUDE "data/sprites/sprites.asm"
