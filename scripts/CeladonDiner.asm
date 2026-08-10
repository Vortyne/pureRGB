CeladonDiner_Script:
	jp EnableAutoTextBoxDrawing

CeladonDiner_TextPointers:
	def_text_pointers
	dba_const CeladonDinerCookText,            TEXT_CELADONDINER_COOK
	dba_const _CeladonDinerMiddleAgedWomanText, TEXT_CELADONDINER_MIDDLE_AGED_WOMAN
	dba_const _CeladonDinerMiddleAgedManText,   TEXT_CELADONDINER_MIDDLE_AGED_MAN
	dba_const _CeladonDinerFisherText,          TEXT_CELADONDINER_FISHER
	dba_const CeladonDinerCoinCaseGuyText,     TEXT_CELADONDINER_COIN_CASE_GUY

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
	text_far_end _CeladonDinerOpenText

CeladonDinerBreakText:
	text_far_end _CeladonDinerCookText

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
	text_far_end _CeladonDinerCoinCaseGuyImFlatOutBustedText

.ReceivedCoinCaseText:
	text_far_end _CeladonDinerCoinCaseGuyReceivedCoinCaseText

.WinItBackText:
	text_far_end _CeladonDinerCoinCaseGuyWinItBackText
