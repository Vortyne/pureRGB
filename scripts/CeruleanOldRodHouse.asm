; PureRGBnote: ADDED: new house in cerulean where the fishing guru was moved to, he will give you old rod earlier.
CeruleanOldRodHouse_Script:
	jp EnableAutoTextBoxDrawing

CeruleanOldRodHouse_TextPointers:
	def_text_pointers
	dba_const CeruleanOldRodHouse1Text1,  TEXT_CERULEANOLDRODHOUSE_FISHING_GURU
	dba_const CeruleanOldRodHouseFoodText,  TEXT_CERULEANOLDRODHOUSE_FOOD

CeruleanOldRodHouse1Text1:
	text_asm
	ld a, [wStatusFlags1]
	bit BIT_GOT_OLD_ROD, a ; got old rod?
	ld hl, .CeruleanOldRodHouseHowAreFishBiting
	jr nz, .printDone
	ld hl, .CeruleanOldRodHouseImTheFishingGuruText
	rst _PrintText
	call YesNoChoice
	ld hl, .CeruleanOldRodHouseDisappointing
	jr nz, .printDone
	lb bc, OLD_ROD, 1
	call GiveItem
	ld hl, .CeruleanOldRodHouseNoRoom
	jr nc, .printDone
	ld hl, wStatusFlags1
	set BIT_GOT_OLD_ROD, [hl] ; got old rod
	ld hl, .CeruleanOldRodHouseGiveRod
.printDone
	rst _PrintText
	rst TextScriptEnd

.CeruleanOldRodHouseImTheFishingGuruText:
	text_far _CeruleanOldRodHouseImTheFishingGuruText
	text_far_end _VermilionOldRodHouseISimplyLoveFishing

.CeruleanOldRodHouseGiveRod:
	text_far _VermilionOldRodHouseFishingGuruTakeThisText
	text_far _GenericReceivedItemA
	sound_get_item_1
	text_far_end _CeruleanOldRodHouseFishingIsAWayOfLifeText

.CeruleanOldRodHouseDisappointing:
	text_far_end _LastTwoGurusTextNo

.CeruleanOldRodHouseHowAreFishBiting:
	text_far _VermilionOldRodHouseFishingGuruHowAreTheFishBitingText
	text_far_end _CeruleanOldRodHouseOldRodInfo

.CeruleanOldRodHouseNoRoom:
	text_far_end _LastTwoGurusTextBagFull

; PureRGBnote: ADDED: some text where it seems like there should be an interaction.

CeruleanOldRodHouseFoodText:
	text_asm
	ld hl, .wowFish
	rst _PrintText
	ld a, CERULEANOLDRODHOUSE_FISHING_GURU
	call SetSpriteFacingUp
	ld hl, .whatCanISayLoveCooking
	rst _PrintText
	rst TextScriptEnd
.wowFish
	text_far_end _CeruleanOldRodHouseFoodText
.whatCanISayLoveCooking
	text_far_end _CeruleanOldRodHouseFoodText2
