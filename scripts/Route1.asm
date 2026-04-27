Route1_Script:
	jp EnableAutoTextBoxDrawing

Route1_TextPointers:
	def_text_pointers
	dw_const Route1Youngster1Text, TEXT_ROUTE1_YOUNGSTER1
	dw_const Route1Youngster2Text, TEXT_ROUTE1_YOUNGSTER2
	dw_const Route1SignText,       TEXT_ROUTE1_SIGN

Route1Youngster1Text:
	text_asm
	CheckAndSetEvent EVENT_GOT_POTION_SAMPLE
	ld hl, .AlsoGotPokeballsText
	jr nz, .printDone
	ld hl, .MartSampleText
	rst _PrintText
	lb bc, ITEM_ROUTE_1_MART_SAMPLE, 1
	call GiveItem
	ld hl, .NoRoomText
	jr nc, .printDone
	ld hl, .GotPotionText
.printDone
	rst _PrintText
	rst TextScriptEnd

.MartSampleText:
	text_far _Route1Youngster1MartSampleText
	text_end

.GotPotionText:
	text_far _Route1Youngster1GotPotionText
	sound_get_item_1
	text_end

.AlsoGotPokeballsText:
	text_far _Route1Youngster1AlsoGotPokeballsText
	text_end

.NoRoomText:
	text_far _Route1Youngster1NoRoomText
	text_end

Route1Youngster2Text:
	text_far _Route1Youngster2Text
	text_end

Route1SignText:
	text_far _Route1SignText
	text_end
