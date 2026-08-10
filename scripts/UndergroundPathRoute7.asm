UndergroundPathRoute7_Script:
	ld a, ROUTE_7
	ld [wLastMap], a
	jp EnableAutoTextBoxDrawing

UndergroundPathRoute7_TextPointers:
	def_text_pointers
	dba_const _UndergroundPathRoute7MiddleAgedManText, TEXT_UNDERGROUNDPATHROUTE7_MIDDLE_AGED_MAN
