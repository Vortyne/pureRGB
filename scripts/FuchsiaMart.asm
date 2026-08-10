FuchsiaMart_Script:
	jp EnableAutoTextBoxDrawing

FuchsiaMart_TextPointers:
	def_text_pointers
	dba_const FuchsiaMartClerkText,         TEXT_FUCHSIAMART_CLERK
	dba_const _FuchsiaMartMiddleAgedManText, TEXT_FUCHSIAMART_MIDDLE_AGED_MAN
	dba_const _FuchsiaMartCooltrainerFText,  TEXT_FUCHSIAMART_COOLTRAINER_F
	dba_const FuchsiaMartTMKid,             TEXT_FUCHSIAMART_TM_KID

FuchsiaMartTMKid: ; PureRGBnote: ADDED: new NPC who will sell TMs
	text_asm
	ld hl, TMKidGreet5
	rst _PrintText
	CheckAndSetEvent EVENT_MET_FUCHSIA_TM_KID
	ld hl, FuchsiaMartTMKidFlavor
	jr z, .gotText
	ld hl, TMKidQuick5
.gotText
	rst _PrintText
	ld hl, FuchsiaTMKidShop
	call DisplayPokemartNoGreeting
	rst TextScriptEnd
	
TMKidGreet5::
	text_far_end _TMKidGreet

FuchsiaMartTMKidFlavor:
	text_far _TMKidBringingTMsAnyCost
	text_far _FuchsiaMartTMKidFlavor
	text_far _TMKidSellingTMsCopiedDadOriginals
	text_far_end _TMKidWantSomeText

TMKidQuick5::
	text_far_end _TMKidQuick

INCLUDE "data/items/marts/fuchsia.asm"
