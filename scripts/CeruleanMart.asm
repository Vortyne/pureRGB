CeruleanMart_Script:
	jp EnableAutoTextBoxDrawing

CeruleanMart_TextPointers:
	def_text_pointers
	dba_const CeruleanMartClerkText,        TEXT_CERULEANMART_CLERK
	dba_const _CeruleanMartCooltrainerMText, TEXT_CERULEANMART_COOLTRAINER_M
	dba_const _CeruleanMartCooltrainerFText, TEXT_CERULEANMART_COOLTRAINER_F
	dba_const CeruleanMartTMKid,            TEXT_CERULEANMART_TM_KID

CeruleanMartTMKid: ; PureRGBnote: ADDED: new NPC who will sell TMs
	text_asm
	ld hl, TMKidGreet1
	rst _PrintText
	CheckAndSetEvent EVENT_MET_CERULEAN_TM_KID
	ld hl, CeruleanMartTMKidFlavor
	jr z, .gotText
	ld hl, TMKidQuick1
.gotText
	rst _PrintText
	ld hl, CeruleanTMKidShop
	call DisplayPokemartNoGreeting
	rst TextScriptEnd
	
TMKidGreet1::
	text_far_end _TMKidGreet

CeruleanMartTMKidFlavor:
	text_far _TMKidBringingTMsAnyCost
	text_far _CeruleanMartTMKidFlavor
	text_far _TMKidSellingTMsCopiedDadOriginals
	text_far_end _TMKidWantSomeText

TMKidQuick1::
	text_far_end _TMKidQuick

INCLUDE "data/items/marts/cerulean.asm"
