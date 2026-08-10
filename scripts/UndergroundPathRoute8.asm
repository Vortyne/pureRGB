UndergroundPathRoute8_Script:
	ld a, ROUTE_8
	ld [wLastMap], a
	jp EnableAutoTextBoxDrawing

UndergroundPathRoute8_TextPointers:
	def_text_pointers
	dba_const _UndergroundPathRoute8GirlText, TEXT_UNDERGROUNDPATHROUTE8_GIRL
