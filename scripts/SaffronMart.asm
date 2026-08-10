SaffronMart_Script:
	jp EnableAutoTextBoxDrawing

SaffronMart_TextPointers:
	def_text_pointers
	dba_const SaffronMartClerkText,        TEXT_SAFFRONMART_CLERK
	dba_const _SaffronMartSuperNerdText,    TEXT_SAFFRONMART_SUPER_NERD
	dba_const _SaffronMartCooltrainerFText, TEXT_SAFFRONMART_COOLTRAINER_F
	dba_const SaffronMartTMKid,            TEXT_SAFFRONMART_TM_KID

SaffronMartTMKid: ; PureRGBnote: ADDED: new NPC who will sell TMs
	text_asm
	ld hl, TMKidGreet6
	rst _PrintText
	CheckAndSetEvent EVENT_MET_SAFFRON_TM_KID
	ld hl, SaffronMartTMKidFlavor
	jr z, .gotText
	ld hl, TMKidQuick6
.gotText
	rst _PrintText
	ld hl, SaffronTMKidShop
	call DisplayPokemartNoGreeting
	rst TextScriptEnd
	
TMKidGreet6::
	text_far_end _TMKidGreet

SaffronMartTMKidFlavor:
	text_far _TMKidBringingTMsAnyCost
	text_far _SaffronMartTMKidFlavor
	text_far_end _TMKidWantSomeTMsText

TMKidQuick6::
	text_far_end _TMKidQuick

INCLUDE "data/items/marts/saffron.asm"
