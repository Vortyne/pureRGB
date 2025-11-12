MrPsychicsHouse_Script:
	jp EnableAutoTextBoxDrawing

MrPsychicsHouse_TextPointers:
	def_text_pointers
	dw_const MrPsychicsHouseMrPsychicText, TEXT_MRPSYCHICSHOUSE_MR_PSYCHIC
	dw_const MrPsychicsHouseTableBook, TEXT_MRPSYCHICSHOUSE_TABLE_BOOK

MrPsychicsHouseMrPsychicText:
	text_asm
	CheckEvent EVENT_GOT_TM29
	ld hl, .TM29ExplanationText
	jr nz, .printDone
	ld hl, .YouWantedThisText
	rst _PrintText
	lb bc, TM_SAFFRON_CITY_MR_PSYCHIC, 1
	call GiveItem
	ld hl, .TM29NoRoomText
	jr nc, .printDone
	SetEvent EVENT_GOT_TM29
	ld hl, .ReceivedTM29Text
.printDone
	rst _PrintText
.done
	rst TextScriptEnd

.YouWantedThisText:
	text_far _MrPsychicsHouseMrPsychicYouWantedThisText
	text_end

.ReceivedTM29Text:
	text_far _MrPsychicsHouseMrPsychicReceivedTM29Text
	sound_get_item_1
	text_end

.TM29ExplanationText:
	text_far _MrPsychicsHouseMrPsychicTM29ExplanationText
	text_end

.TM29NoRoomText:
	text_far _MrPsychicsHouseMrPsychicTM29NoRoomText
	text_end

MrPsychicsHouseTableBook:
	text_far _MrPsychicsHouseBookText
	text_far _FlippedToARandomPage
	text_far _MrPsychicsHouseBookText2
	text_asm
	CheckEvent FLAG_ALAKAZAM_FAMILY_LEARNSET
	jr nz, .done
	ld d, DEX_KADABRA
	jpfar KeepReadingBookLearnset
.done
	rst TextScriptEnd
