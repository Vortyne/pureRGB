Route1_Script:
	jp EnableAutoTextBoxDrawing

Route1_TextPointers:
	def_text_pointers
	dba_const Route1Youngster1Text, TEXT_ROUTE1_YOUNGSTER1
	dba_const _Route1Youngster2Text, TEXT_ROUTE1_YOUNGSTER2
	dba_const _Route1SignText,       TEXT_ROUTE1_SIGN

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
	text_far_end _Route1Youngster1MartSampleText
.GotPotionText:
	text_far_end _Route1Youngster1GotPotionText
.AlsoGotPokeballsText:
	text_far_end _Route1Youngster1AlsoGotPokeballsText
.NoRoomText:
	text_far_end _Route1Youngster1NoRoomText
