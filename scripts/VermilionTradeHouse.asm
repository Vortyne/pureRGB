VermilionTradeHouse_Script:
	jp EnableAutoTextBoxDrawing

VermilionTradeHouse_TextPointers:
	def_text_pointers
	dw_const VermilionTradeHouseLittleGirlText, TEXT_VERMILIONTRADEHOUSE_LITTLE_GIRL
	dw_const VermilionTradeHouseGameboyKidText, TEXT_VERMILIONTRADEHOUSE_GAMEBOY_KID
	dw_const VermilionTradeHouseDuxText, TEXT_VERMILIONTRADEHOUSE_DUX
	dw_const VermilionTradeHouseClipboardText, TEXT_VERMILIONTRADEHOUSE_CLIPBOARD

VermilionTradeHouseLittleGirlText:
	text_asm
	ld a, TRADE_FOR_DUX
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	rst TextScriptEnd

VermilionTradeHouseGameboyKidText:
	text_far _VermilionCityTradeHouseGameboyKidText
	text_asm
	call VermilionTradeHouseSeeFarfetchd
	call AreLearnsetsEnabled
	jr z, .done
	CheckEvent FLAG_FARFETCHD_LEARNSET
	jr nz, .done
	call DisplayTextPromptButton
	ld hl, .learnset
	rst _PrintText
	ld d, DEX_FARFETCHD
	callfar KeepReadingBookLearnsetDirect
.done
	rst TextScriptEnd
.learnset
	text_far _VermilionCityTradeHouseGameboyKidLearnsetText
	text_end

VermilionTradeHouseSeeFarfetchd:
	ld c, DEX_FARFETCHD - 1
	jpfar SetMonSeen

VermilionTradeHouseDuxText:
	text_far _VermilionCityTradeHouseDUXText
	text_asm
	call VermilionTradeHouseSeeFarfetchd
	ld a, FARFETCHD
	call PlayCry
	call DisplayTextPromptButton
	ld hl, .hands
	rst _PrintText
	rst TextScriptEnd
.hands
	text_far _VermilionCityTradeHouseDUX2Text
	text_end

VermilionTradeHouseClipboardText:
	text_far _VermilionCityTradeHouseClipboardText
	text_end
