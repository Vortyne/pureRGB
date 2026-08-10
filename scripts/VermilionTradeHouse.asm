VermilionTradeHouse_Script:
	jp EnableAutoTextBoxDrawing

VermilionTradeHouse_TextPointers:
	def_text_pointers
	dba_const VermilionTradeHouseLittleGirlText, TEXT_VERMILIONTRADEHOUSE_LITTLE_GIRL
	dba_const VermilionTradeHouseGameboyKidText, TEXT_VERMILIONTRADEHOUSE_GAMEBOY_KID
	dba_const VermilionTradeHouseDuxText, TEXT_VERMILIONTRADEHOUSE_DUX
	dba_const _VermilionCityTradeHouseClipboardText, TEXT_VERMILIONTRADEHOUSE_CLIPBOARD

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
	text_far_end _VermilionCityTradeHouseGameboyKidLearnsetText

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
	text_far_end _VermilionCityTradeHouseDUX2Text
