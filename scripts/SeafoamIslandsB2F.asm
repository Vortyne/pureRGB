SeafoamIslandsB2F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, wMiscFlags
	bit BIT_PUSHED_BOULDER, [hl]
	res BIT_PUSHED_BOULDER, [hl]
	jr z, .noBoulderWasPushed
	ld de, Seafoam3HolesCoords
	ld c, BANK(Seafoam3HolesCoords)
	callfar CheckBoulderCoords
	ret nc
	EventFlagAddress hl, EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE
	ld a, [wCoordIndex]
	cp $1
	jr nz, .boulder2FellDownHole
	SetEventReuseHL EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE
	lb bc, TOGGLE_SEAFOAM_ISLANDS_B3F_BOULDER_3, TOGGLE_SEAFOAM_ISLANDS_B2F_BOULDER_1
	jr .hideAndShowBoulderObjects
.boulder2FellDownHole
	SetEventAfterBranchReuseHL EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE
	lb bc, TOGGLE_SEAFOAM_ISLANDS_B3F_BOULDER_4, TOGGLE_SEAFOAM_ISLANDS_B2F_BOULDER_2
.hideAndShowBoulderObjects
	push bc
	call HideObject
	pop bc
	ld c, b
	call ShowObject
	ld d, 1
	jpfar BoulderHoleDropEffect
.noBoulderWasPushed
	ld a, SEAFOAM_ISLANDS_B3F
	ld [wDungeonWarpDestinationMap], a
	ld hl, Seafoam3HolesCoords
	jp IsPlayerOnDungeonWarp

Seafoam3HolesCoords:
	dbmapcoord 19,  6
	dbmapcoord 22,  6
	db -1 ; end

SeafoamIslandsB2F_TextPointers:
	def_text_pointers
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB2F_BOULDER1
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB2F_BOULDER2
