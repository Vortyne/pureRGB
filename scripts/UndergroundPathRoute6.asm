UndergroundPathRoute6_Script:
	ld a, ROUTE_6
	ld [wLastMap], a
	jp EnableAutoTextBoxDrawing

UndergroundPathRoute6_TextPointers:
	def_text_pointers
	dba_const _UndergroundPathRoute6GirlText, TEXT_UNDERGROUNDPATHROUTE6_GIRL
