CinnabarMart_Script:
	jp EnableAutoTextBoxDrawing

CinnabarMart_TextPointers:
	def_text_pointers
	dba_const CinnabarMartClerkText,         TEXT_CINNABARMART_CLERK
	dba_const _CinnabarMartSilphWorkerFText, TEXT_CINNABARMART_SILPH_WORKER_F
	dba_const _CinnabarMartScientistText,    TEXT_CINNABARMART_SCIENTIST
	dba_const CinnabarMartTMKid,             TEXT_CINNABARMART_TM_KID

CinnabarMartTMKid: ; PureRGBnote: ADDED: new NPC who will sell TMs
	text_asm
	ld hl, .TMKidGreet
	rst _PrintText
	CheckAndSetEvent EVENT_MET_CINNABAR_TM_KID
	ld hl, .TMKidFlavor
	jr z, .gotText
	ld hl, .TMKidQuick
.gotText
	rst _PrintText
	ld hl, CinnabarTMKidShop
	call DisplayPokemartNoGreeting
	rst TextScriptEnd
	
.TMKidGreet::
	text_far_end _TMKidGreet

.TMKidFlavor:
	text_far _TMKidBringingTMsAnyCost
	text_far _CinnabarMartTMKidFlavor
	text_far _TMKidSellingTMsCopiedDadOriginals
	text_far_end _TMKidWantSomeText

.TMKidQuick::
	text_far_end _TMKidQuick

INCLUDE "data/items/marts/cinnabar.asm"
