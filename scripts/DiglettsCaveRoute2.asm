DiglettsCaveRoute2_Script:
	ld a, ROUTE_2
	ld [wLastMap], a
	jp EnableAutoTextBoxDrawing

DiglettsCaveRoute2_TextPointers:
	def_text_pointers
	dba_const _DiglettsCaveRoute2FishingGuruText, TEXT_DIGLETTSCAVEROUTE2_FISHING_GURU
