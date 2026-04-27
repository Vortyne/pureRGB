; PureRGBnote: CHANGED: the fishing guru relative here will now give you GOOD ROD.

VermilionOldRodHouse_Script:
	jp EnableAutoTextBoxDrawing

VermilionOldRodHouse_TextPointers:
	def_text_pointers
	dw_const VermilionGuruHouseText1, TEXT_VERMILIONOLDRODHOUSE_FISHING_GURU

VermilionGuruHouseText1:
	text_asm
	ld a, [wStatusFlags1]
	bit BIT_GOT_GOOD_ROD, a
	ld hl, .HowAreTheFishBitingText
	jr nz, .printDone
	ld hl, .DoYouLikeToFishText
	rst _PrintText
	call YesNoChoice
	ld hl, .ThatsSoDisappointingText
	jr nz, .printDone
	lb bc, GOOD_ROD, 1
	call GiveItem
	ld hl, .NoRoomText
	jr nc, .printDone
	ld hl, wStatusFlags1
	set BIT_GOT_GOOD_ROD, [hl]
	ld hl, .TakeThisText
.printDone
	rst _PrintText
	rst TextScriptEnd

.DoYouLikeToFishText:
	text_far _VermilionOldRodHouseFishingGuruDoYouLikeToFishText
	text_far _VermilionOldRodHouseISimplyLoveFishing
	text_end

.TakeThisText:
	text_far _VermilionOldRodHouseFishingGuruTakeThisText
	text_far _GenericReceivedItemA
	sound_get_item_1
	text_end

.ThatsSoDisappointingText:
	text_far _LastTwoGurusTextNo
	text_end

.HowAreTheFishBitingText:
	text_far _VermilionOldRodHouseFishingGuruHowAreTheFishBitingText
	text_far _VermilionOldRodHouseGoodRodInfo
	text_end

.NoRoomText:
	text_far _LastTwoGurusTextBagFull
	text_end
