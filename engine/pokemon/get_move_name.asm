; [wNameListIndex] = which move
 ; puts the name in wNameBuffer
_GetMoveName::
	ld a, [wNameListIndex]
	ld [wNamedObjectIndex], a
	dec a
	ld hl, MoveNameJumpTable
	ld d, 0
	ld e, a
	add hl, de
	add hl, de
	de_deref
	ld hl, wNameBuffer
	jp CopyString
