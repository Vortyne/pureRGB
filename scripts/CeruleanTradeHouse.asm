CeruleanTradeHouse_Script:
	jp EnableAutoTextBoxDrawing

CeruleanTradeHouse_TextPointers:
	def_text_pointers
	dba_const _CeruleanTradeHouseGrannyText,  TEXT_CERULEANTRADEHOUSE_GRANNY
	dba_const CeruleanTradeHouseTraderText,  TEXT_CERULEANTRADEHOUSE_TRADER

CeruleanTradeHouseTraderText:
	text_asm
	ld a, TRADE_FOR_LOLA
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	rst TextScriptEnd
