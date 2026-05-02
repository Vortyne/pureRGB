SeafoamIslandsB1F_Script:
	call EnableAutoTextBoxDrawing

	ld de, SeafoamB1FHolesCoords
	ld hl, SeafoamBoulderB1FEventFunc
	ld bc, SeafoamB1FBoulderToggleData
	call SeafoamBoulderPushRoutine
	ret c
	ld a, SEAFOAM_ISLANDS_B2F
	ld [wDungeonWarpDestinationMap], a
	ld hl, SeafoamB1FHolesCoords
	jp IsPlayerOnDungeonWarp

SeafoamIslandsB1F_TextPointers:
	def_text_pointers
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB1F_BOULDER1
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB1F_BOULDER2
