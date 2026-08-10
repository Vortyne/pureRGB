LavenderMart_Script:
	jp EnableAutoTextBoxDrawing

LavenderMart_TextPointers:
	def_text_pointers
	dba_const LavenderMartClerkText,        TEXT_LAVENDERMART_CLERK
	dba_const _LavenderMartBaldingGuyText,   TEXT_LAVENDERMART_BALDING_GUY
	dba_const LavenderMartCooltrainerMText, TEXT_LAVENDERMART_COOLTRAINER_M
	dba_const LavenderMartTMKid,            TEXT_LAVENDERMART_TM_KID

LavenderMartTMKid: ; PureRGBnote: ADDED: new NPC who will sell TMs
	text_asm
	ld hl, TMKidGreet3
	rst _PrintText
	CheckAndSetEvent EVENT_MET_LAVENDER_TM_KID
	ld hl, LavenderMartTMKidFlavor
	jr z, .gotText
	ld hl, TMKidQuick3
.gotText
	rst _PrintText
	ld hl, LavenderTMKidShop
	call DisplayPokemartNoGreeting
	rst TextScriptEnd
	
TMKidGreet3::
	text_far_end _TMKidGreet

LavenderMartTMKidFlavor:
	text_far _TMKidBringingTMsAnyCost
	text_far _LavenderMartTMKidFlavor
	text_far _TMKidSellingTMsCopiedDadOriginals
	text_far_end _TMKidWantSomeText

TMKidQuick3::
	text_far_end _TMKidQuick

LavenderMartCooltrainerMText:
	text_asm
	CheckEvent EVENT_RESCUED_MR_FUJI
	ld hl, .NuggetText
	jr nz, .gotText
	ld hl, .ReviveText
.gotText
	rst _PrintText
	rst TextScriptEnd

.ReviveText
	text_far_end _LavenderMartCooltrainerMReviveText

.NuggetText
	text_far_end _LavenderMartCooltrainerMNuggetText

INCLUDE "data/items/marts/lavender.asm"