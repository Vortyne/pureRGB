DiglettsCaveRoute11_Script:
	ld a, ROUTE_11
	ld [wLastMap], a
	jp EnableAutoTextBoxDrawing

DiglettsCaveRoute11_TextPointers:
	def_text_pointers
	dba_const _DiglettsCaveRoute11GamblerText, TEXT_DIGLETTSCAVEROUTE11_GAMBLER
