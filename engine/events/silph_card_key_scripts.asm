RunMapCardKeyEvent::
	; marks the map's card key events depending on the card key door we just opened's coordinates
	; input d = y coord
	; input e = x coord
	push de
	ld hl, CardKeyEventFunctions
	ld a, [wCurMap]
	ld de, 3
	call IsInArray
	pop de
	ret nc
	inc hl
	hl_deref
	jp hl

CardKeyEventFunctions:
	dbw SILPH_CO_2F, SilphCo2F_UnlockedDoorEventScript
	dbw SILPH_CO_3F, SilphCo3F_UnlockedDoorEventScript
	dbw SILPH_CO_4F, SilphCo4F_UnlockedDoorEventScript
	dbw SILPH_CO_5F, SilphCo5F_UnlockedDoorEventScript
	dbw SILPH_CO_6F, SilphCo6F_UnlockedDoorEventScript
	dbw SILPH_CO_7F, SilphCo7F_UnlockedDoorEventScript
	dbw SILPH_CO_8F, SilphCo8F_UnlockedDoorEventScript
	dbw SILPH_CO_9F, SilphCo9F_UnlockedDoorEventScript
	dbw SILPH_CO_10F, SilphCo10F_UnlockedDoorEventScript
	dbw SILPH_CO_11F, SilphCo11F_UnlockedDoorEventScript
	db -1

SilphCo2FGateCoords::
	dbmapcoord  2,  2
	db $54
	dbmapcoord  2,  5
	db $54

SilphCo2F_UnlockedDoorEventScript::
	ld hl, SilphCo2FGateCoords
	ld a, [hli]
	cp d
	jr z, .firstDoor
	SetEvent EVENT_SILPH_CO_2_UNLOCKED_DOOR2
	ret
.firstDoor
	SetEvent EVENT_SILPH_CO_2_UNLOCKED_DOOR1
	ret

SilphCo3FGateCoords::
	dbmapcoord  4,  4
	db $5f
	dbmapcoord  8,  4
	db $5f

SilphCo3F_UnlockedDoorEventScript:
	ld hl, SilphCo3FGateCoords + 1
	ld a, [hli]
	cp e
	jr z, .firstDoor
	SetEvent EVENT_SILPH_CO_3_UNLOCKED_DOOR2
	ret
.firstDoor
	SetEvent EVENT_SILPH_CO_3_UNLOCKED_DOOR1
	ret

SilphCo4FGateCoords::
	dbmapcoord  2,  6
	db $54
	dbmapcoord  6,  4
	db $54

SilphCo4F_UnlockedDoorEventScript:
	ld hl, SilphCo4FGateCoords
	ld a, [hli]
	cp d
	jr z, .firstDoor
	SetEvent EVENT_SILPH_CO_4_UNLOCKED_DOOR2
	ret
.firstDoor
	SetEvent EVENT_SILPH_CO_4_UNLOCKED_DOOR1
	ret

SilphCo4FCardKeyMapLoad::
	ld hl, SilphCo4FGateCoords
	CheckEvent EVENT_SILPH_CO_4_UNLOCKED_DOOR1
	call UnlockSilphCoDoor
	CheckEvent EVENT_SILPH_CO_4_UNLOCKED_DOOR2
	jp UnlockSilphCoDoor

SilphCo5FGateCoords::
	dbmapcoord  3,  2
	db $5f
	dbmapcoord  3,  6
	db $5f
	dbmapcoord  7,  5
	db $5f

SilphCo5F_UnlockedDoorEventScript:
	ld hl, SilphCo5FGateCoords
	ld a, [hli]
	cp d
	jr z, .firstDoor
	inc hl
	inc hl
	ld a, [hl]
	cp d
	jr z, .secondDoor
	SetEvent EVENT_SILPH_CO_5_UNLOCKED_DOOR3
	ret
.secondDoor
	SetEvent EVENT_SILPH_CO_5_UNLOCKED_DOOR2
	ret
.firstDoor
	SetEvent EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	ret

SilphCo5FCardKeyMapLoad::
	ld hl, SilphCo5FGateCoords
	CheckEvent EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	call UnlockSilphCoDoor
	CheckEvent EVENT_SILPH_CO_5_UNLOCKED_DOOR2
	call UnlockSilphCoDoor
	CheckEvent EVENT_SILPH_CO_5_UNLOCKED_DOOR3
	jp UnlockSilphCoDoor

SilphCo6FGateCoords::
	dbmapcoord  2,  6
	db $5f

SilphCo6F_UnlockedDoorEventScript:
	SetEvent EVENT_SILPH_CO_6_UNLOCKED_DOOR
	ret

SilphCo6FCardKeyMapLoad::
	ld hl, SilphCo6FGateCoords
	CheckEvent EVENT_SILPH_CO_6_UNLOCKED_DOOR
	jp UnlockSilphCoDoor

SilphCo7FGateCoords::
	dbmapcoord  5,  3
	db $54
	dbmapcoord 10,  2
	db $54
	dbmapcoord 10,  6
	db $54

SilphCo7F_UnlockedDoorEventScript:
	ld hl, SilphCo7FGateCoords
	ld a, [hli]
	cp d
	jr z, .firstDoor
	inc hl
	inc hl
	ld a, [hli]
	cp d
	jr z, .secondDoor
	SetEvent EVENT_SILPH_CO_7_UNLOCKED_DOOR3
	ret
.secondDoor
	SetEvent EVENT_SILPH_CO_7_UNLOCKED_DOOR2
	ret
.firstDoor
	SetEvent EVENT_SILPH_CO_7_UNLOCKED_DOOR1
	ret

SilphCo7FCardKeyMapLoad::
	ld hl, SilphCo7FGateCoords
	CheckEvent EVENT_SILPH_CO_7_UNLOCKED_DOOR1
	call UnlockSilphCoDoor
	CheckEvent EVENT_SILPH_CO_7_UNLOCKED_DOOR2
	call UnlockSilphCoDoor
	CheckEvent EVENT_SILPH_CO_7_UNLOCKED_DOOR3
	jp UnlockSilphCoDoor


SilphCo8FGateCoords::
	dbmapcoord  3,  4
	db $5f

SilphCo8F_UnlockedDoorEventScript:
	SetEvent EVENT_SILPH_CO_8_UNLOCKED_DOOR
	ret

SilphCo9FGateCoords::
	dbmapcoord  1,  4
	db $5f
	dbmapcoord  9,  2
	db $54
	dbmapcoord  9,  5
	db $54
	dbmapcoord  5,  6
	db $5f

SilphCo9F_UnlockedDoorEventScript:
	ld hl, SilphCo9FGateCoords
	ld a, [hli]
	cp d
	jr z, .firstDoor
	inc hl
	inc hl
	ld a, [hli]
	cp d
	jr z, .secondDoor
	inc hl
	inc hl
	ld a, [hli]
	cp d
	jr z, .thirdDoor
	SetEvent EVENT_SILPH_CO_9_UNLOCKED_DOOR4
	ret
.thirdDoor
	SetEvent EVENT_SILPH_CO_9_UNLOCKED_DOOR3
	ret
.secondDoor
	SetEvent EVENT_SILPH_CO_9_UNLOCKED_DOOR2
	ret
.firstDoor
	SetEvent EVENT_SILPH_CO_9_UNLOCKED_DOOR1
	ret

SilphCo9FCardKeyMapLoad::
	ld hl, SilphCo9FGateCoords
	CheckEvent EVENT_SILPH_CO_9_UNLOCKED_DOOR1
	call UnlockSilphCoDoor
	CheckEvent EVENT_SILPH_CO_9_UNLOCKED_DOOR2
	call UnlockSilphCoDoor
	CheckEvent EVENT_SILPH_CO_9_UNLOCKED_DOOR3
	call UnlockSilphCoDoor
	CheckEvent EVENT_SILPH_CO_9_UNLOCKED_DOOR4
	jp UnlockSilphCoDoor

SilphCo10FGateCoords::
	dbmapcoord  5,  4
	db $54

SilphCo10F_UnlockedDoorEventScript:
	SetEvent EVENT_SILPH_CO_10_UNLOCKED_DOOR
	ret

SilphCo11GateCoords::
	dbmapcoord  3,  6
	db $20

SilphCo11F_UnlockedDoorEventScript:
	SetEvent EVENT_SILPH_CO_11_UNLOCKED_DOOR
	ret

SilphCo11FCardKeyMapLoad::
	ld hl, SilphCo11GateCoords
	CheckEvent EVENT_SILPH_CO_11_UNLOCKED_DOOR
	jp UnlockSilphCoDoor