_GetItemName::
	ld a, [wNamedObjectIndex]
	ld [wNameListIndex], a
	dec a
	ld hl, ItemNameJumpTable
	ld d, 0
	ld e, a
	add hl, de
	add hl, de
	de_deref
	ld hl, wNameBuffer
	jp CopyString