CeladonDiner_Script:
	jp EnableAutoTextBoxDrawing

CeladonDiner_TextPointers:
	def_text_pointers
	dw_const CeladonDinerCookText,            TEXT_CELADONDINER_COOK
	dw_const CeladonDinerMiddleAgedWomanText, TEXT_CELADONDINER_MIDDLE_AGED_WOMAN
	dw_const CeladonDinerMiddleAgedManText,   TEXT_CELADONDINER_MIDDLE_AGED_MAN
	dw_const CeladonDinerFisherText,          TEXT_CELADONDINER_FISHER
	dw_const CeladonDinerCoinCaseGuyText,     TEXT_CELADONDINER_COIN_CASE_GUY

CeladonDinerCookText:
; PureRGBnote: ADDED: celadon diner sells drinks after giving a drink to the guards guarding saffron
; allows you to buy a bunch of drinks at once if you want.
	text_asm
	ld a, [wStatusFlags1]
	bit BIT_GAVE_SAFFRON_GUARDS_DRINK, a
	jr nz, .noBreak
	ld hl, CeladonDinerBreakText
	rst _PrintText
	rst TextScriptEnd
.noBreak
	ld hl, CeladonDinerOpenText
	rst _PrintText
	ld hl, CeladonDinerMenu
	call DisplayPokemartNoGreeting
	rst TextScriptEnd

INCLUDE "data/items/marts/celadon_diner.asm"

CeladonDinerOpenText:
	text_far _CeladonDinerOpenText
	text_end

CeladonDinerBreakText:
	text_far _CeladonDinerCookText
	text_end

CeladonDinerMiddleAgedWomanText:
	text_far _CeladonDinerMiddleAgedWomanText
	text_end

CeladonDinerMiddleAgedManText:
	text_far _CeladonDinerMiddleAgedManText
	text_end

CeladonDinerFisherText:
	text_far _CeladonDinerFisherText
	text_end

CeladonDinerCoinCaseGuyText:
; PureRGBnote: CHANGED: COIN_CASE is not an item, it's just an event that lets you use the game corner
	text_asm
	CheckEvent EVENT_GOT_COIN_CASE
	ld hl, .WinItBackText
	jr nz, .printDone
	ld hl, .ImFlatOutBustedText
	rst _PrintText
	SetEvent EVENT_GOT_COIN_CASE
	ld hl, .ReceivedCoinCaseText
.printDone
	rst _PrintText
	rst TextScriptEnd

.ImFlatOutBustedText:
	text_far _CeladonDinerCoinCaseGuyImFlatOutBustedText
	text_end

.ReceivedCoinCaseText:
	text_far _CeladonDinerCoinCaseGuyReceivedCoinCaseText
	sound_get_key_item
	text_end

.WinItBackText:
	text_far _CeladonDinerCoinCaseGuyWinItBackText
	text_end
