PewterMart_Script:
	jp EnableAutoTextBoxDrawing

PewterMart_TextPointers:
	def_text_pointers
	dba_const PewterMartClerkText,     TEXT_PEWTERMART_CLERK
	dba_const _PewterMartYoungsterText, TEXT_PEWTERMART_YOUNGSTER
	dba_const _PewterMartSuperNerdText, TEXT_PEWTERMART_SUPER_NERD
	dba_const PewterMartTMKid,         TEXT_PEWTERMART_TM_KID
	
PewterMartTMKid: ; PureRGBnote: ADDED: new NPC who will talk about selling TMs
	text_asm
	CheckEvent EVENT_BEAT_MISTY
	ld hl, .Text
	jr z, .printDone
.afterMisty
	ld hl, .Text3
	rst _PrintText
	ld hl, .Text2
.printDone
	rst _PrintText
	rst TextScriptEnd

.Text
	text_far_end _PewterMartTMKid

.Text2
	text_far_end _TMKidStockingUp

.Text3
	text_far_end _TMKidGreet

INCLUDE "data/items/marts/pewter.asm"