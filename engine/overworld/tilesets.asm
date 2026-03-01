LoadTilesetHeader:
	call GetPredefRegisters
	push hl
	ld d, 0
	ld a, [wCurMapTileset]
	add a
	add a
	ld b, a
	add a
	add b ; a = tileset * 12
	jr nc, .noCarry
	inc d
.noCarry
	ld e, a
	ld hl, Tilesets
	add hl, de
	ld de, wTilesetBank
	ld c, $b
.copyTilesetHeaderLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copyTilesetHeaderLoop
	ld a, [hl]
	ldh [hTileAnimations], a
	xor a
	ldh [hMovingBGTilesCounter1], a
	pop hl
	ld a, [wCurMapTileset]
	push hl
	push de
	ld hl, DungeonTilesets
	call IsInSingleByteArray
	pop de
	pop hl
	jr c, .dungeon
	ld a, [wCurMapTileset]
	ld b, a
	ldh a, [hPreviousTileset]
	cp b
	ret z
.dungeon
	ld a, [wDestinationWarpID]
	cp $ff
	ret z
	call LoadDestinationWarpPosition
	ld a, [wYCoord]
	and $1
	ld [wYBlockCoord], a
	ld a, [wXCoord]
	and $1
	ld [wXBlockCoord], a
	ret

ReloadTileAnimsValue::
	ld hl, Tilesets
	ld a, [wCurMapTileset]
	inc a
	ld bc, 12 ; TILESET_HEADER_SIZE
	call AddNTimes
	dec hl ; last bit of current tileset's data
	ld a, [hl]
	ldh [hTileAnimations], a
	ret

INCLUDE "data/tilesets/dungeon_tilesets.asm"

INCLUDE "data/tilesets/tileset_headers.asm"
