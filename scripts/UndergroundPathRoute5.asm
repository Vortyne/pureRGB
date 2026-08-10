UndergroundPathRoute5_Script:
	ld a, ROUTE_5
	ld [wLastMap], a
	jp EnableAutoTextBoxDrawing

UndergroundPathRoute5_TextPointers:
	def_text_pointers
	dba_const UndergroundPathRoute5LittleGirlText, TEXT_UNDERGROUNDPATHROUTE5_LITTLE_GIRL

UndergroundPathRoute5LittleGirlText:
	text_asm
	ld a, TRADE_FOR_SPOT
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	rst TextScriptEnd
