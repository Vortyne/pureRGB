AlreadyOnThatFloor:
	ld hl, AlreadyOnThatFloorText
	rst _PrintText
	jr DisplayElevatorFloorMenu.menuDisplayLoop

DisplayElevatorFloorMenu:
	ld a, [wListScrollOffset]
	push af ; preserve the list scroll offset so our item list offset is remembered
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
	ld [wPrintItemPrices], a
.menuDisplayLoop:
	ld hl, WhichFloorText
	rst _PrintText
	; draw box for current elevator floor
	call .printCurrentFloor
	ld hl, wItemList
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	ld a, CUSTOMLISTMENU
	ld [wListMenuID], a
	ld a, 4 ; elevator floors
	ld [wListMenuCustomType], a
	call DisplayListMenuID
	jr c, .done ; if cancel was selected
	ld hl, wElevatorWarpMaps
	ld a, [wWhichPokemon]
	add a
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
;;;;;;;;;; PureRGBnote: CHANGED: elevators will tell you if you selected the floor you are currently on and will track how far you will travel
	ld a, [wWarpedFromWhichMap] ; map you were on before entering the elevator
	cp c
	jr z, AlreadyOnThatFloor
	push bc
	; wWarpedFromWhichMap still loaded
	ld hl, wElevatorWarpMaps + 1
	ld de, 2
	; warning - the map in wWarpedFromWhichMap is expected to DEFINITELY be in wElevatorWarpMaps
	; if it isn't, IsInArray will keep searching outside the bounds of the list and that could lead to undefined behavior
	call IsInArray
	; what index of the floors the current floor is on now = b
	ld a, [wWhichPokemon] ; which index did we pick in the list
	ld c, a
	sub b
	jr nc, .goingUp
	; going down
	ld a, b ; which index we are on currently
	sub c
.goingUp
	ld [wElevatorTravelDistance], a
	pop bc
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_USED_ELEVATOR, [hl]
;;;;;;;;;;
	ld hl, wWarpEntries
	call .UpdateWarp ; update first warp
	call .UpdateWarp ; update second warp
	; destination map ID still loaded
	; PureRGBnote: ADDED: update the "map ID we came from" variable so the above usage of this variable thinks are now on the new floor
	ld [wWarpedFromWhichMap], a
	ld a, b ; destination warp id
	ld [wWarpedFromWhichWarp], a
.done
	xor a
	ld [wCurrentMenuItem], a
	pop af
	ld [wListScrollOffset], a ; restore list scroll offset so item list index is remembered
	ret
	; fall through
.UpdateWarp
	inc hl
	inc hl
	ld a, b
	ld [hli], a ; destination warp ID
	ld a, c
	ld [hli], a ; destination map ID
	ret
.printCurrentFloor
	; make the "Current: " text box
	hlcoord 4, 0
	lb bc, 1, 14
	call TextBoxBorderUpdateSprites
	call DisableTextDelay
	hlcoord 5, 1
	ld de, CurrentFloorText
	call PlaceString
	; find which floor we're on and print it
	ld hl, wElevatorWarpMaps + 1
	ld a, [wItemList] ; how many floors are available
	ld b, a
	ld c, 0
	ld a, [wWarpedFromWhichMap] ; which map we're on
	ld d, a
.loopFindFloor
	ld a, [hli]
	inc hl
	cp d
	jr z, .foundMap
	inc c
	dec b
	jr nz, .loopFindFloor
.foundMap
	ld b, 0
	ld hl, wItemList + 1
	add hl, bc
	ld a, [hl] ; which floor we're on
	ld [wNamedObjectIndex], a
	callfar GetFloorName
	hlcoord 14, 1
	call PlaceString
	jp EnableTextDelay


WhichFloorText:
	text_far _WhichFloorText
	text_end

AlreadyOnThatFloorText:
	text_far _AlreadyOnThatFloor
	text_end

CurrentFloorText:
	db "Current: @"
