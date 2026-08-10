VermilionMart_Script:
	jp EnableAutoTextBoxDrawing

VermilionMart_TextPointers:
	def_text_pointers
	dba_const VermilionMartClerkText,        TEXT_VERMILIONMART_CLERK
	dba_const _VermilionMartCooltrainerMText, TEXT_VERMILIONMART_COOLTRAINER_M
	dba_const _VermilionMartCooltrainerFText, TEXT_VERMILIONMART_COOLTRAINER_F
	dba_const VermilionMartTMKid,            TEXT_VERMILIONMART_TM_KID

VermilionMartTMKid: ; PureRGBnote: ADDED: new NPC who will sell TMs
	text_asm
	ld hl, TMKidGreet2
	rst _PrintText
	CheckAndSetEvent EVENT_MET_VERMILION_TM_KID
	ld hl, VermilionMartTMKidFlavor
	jr z, .gotText
	ld hl, TMKidQuick2
.gotText
	rst _PrintText
	ld hl, VermilionTMKidShop
	call DisplayPokemartNoGreeting
	rst TextScriptEnd
	
TMKidGreet2::
	text_far_end _TMKidGreet

VermilionMartTMKidFlavor:
	text_far _TMKidBringingTMsAnyCost
	text_far _TMKidSellingTMsCopiedDadOriginals
	text_far _VermilionMartTMKidFlavor
	text_far_end _TMKidWantSomeTMsText

TMKidQuick2::
	text_far_end _TMKidQuick

INCLUDE "data/items/marts/vermilion.asm"