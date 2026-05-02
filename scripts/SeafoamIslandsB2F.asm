SeafoamIslandsB2F_Script:
	call EnableAutoTextBoxDrawing
	ld de, SeafoamB2FHolesCoords
	ld hl, SeafoamBoulderB2FEventFunc
	ld bc, SeafoamB2FBoulderToggleData
	call SeafoamBoulderPushRoutine
	ret c
	ld a, SEAFOAM_ISLANDS_B3F
	ld [wDungeonWarpDestinationMap], a
	ld hl, SeafoamB2FHolesCoords
	jp IsPlayerOnDungeonWarp

SeafoamIslandsB2F_TextPointers:
	def_text_pointers
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB2F_BOULDER1
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB2F_BOULDER2
