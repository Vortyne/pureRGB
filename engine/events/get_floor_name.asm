GetFloorName::
	ld hl, FloorNames
	ld bc, 4
GetFixedLengthString::
	ld a, [wNamedObjectIndex]
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, wNameBuffer
	push hl
	call CopyString
	pop de ; have wNameBuffer in de when we return
	ret

FloorNames:
	table_width 4
	db "B2F@"
	db "B1F@"
	db "1F@@"
	db "2F@@"
	db "3F@@"
	db "4F@@"
	db "5F@@"
	db "6F@@"
	db "7F@@"
	db "8F@@"
	db "9F@@"
	db "10F@"
	db "11F@"
	db "B4F@"
	db "B3F@"
	assert_table_length NUM_FLOORS
