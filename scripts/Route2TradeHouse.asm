Route2TradeHouse_Script:
	jp EnableAutoTextBoxDrawing

Route2TradeHouse_TextPointers:
	def_text_pointers
	dba_const _Route2TradeHouseScientistText,  TEXT_ROUTE2TRADEHOUSE_SCIENTIST
	dba_const Route2TradeHouseGameboyKidText, TEXT_ROUTE2TRADEHOUSE_GAMEBOY_KID
	
Route2TradeHouseGameboyKidText:
	text_asm
	ld a, TRADE_FOR_MARCEL
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	rst TextScriptEnd
