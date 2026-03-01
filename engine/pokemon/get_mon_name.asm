_GetMonName::
	ld hl, MonsterNames
	ld bc, NAME_LENGTH - 1
	ld a, [wNamedObjectIndex]
	dec a
	call AddNTimes
	ld de, wNameBuffer
	push de
	ld bc, NAME_LENGTH - 1
	rst _CopyData
	ld a, "@"
	ld [de], a
	pop de
	ret

INCLUDE "data/pokemon/names.asm"
