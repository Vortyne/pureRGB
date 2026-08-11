WardensHouse_Script:
	jp EnableAutoTextBoxDrawing

WardensHouse_TextPointers:
	def_text_pointers
	dba_const WardensHouseWardenText,  TEXT_WARDENSHOUSE_WARDEN
	dba_const PickUpItemText,          TEXT_WARDENSHOUSE_ITEM1
	dba_const BoulderText,             TEXT_WARDENSHOUSE_BOULDER
	dba_const _WardensHouseDisplayPhotosAndFossilsText, TEXT_WARDENSHOUSE_DISPLAY_LEFT
	dba_const _WardensHouseDisplayMerchandiseText, TEXT_WARDENSHOUSE_DISPLAY_RIGHT
; PureRGBnote: Text entry for the papers on the warden's desk
	dba_const _WardensHouseDeskPapersText, TEXT_WARDENSHOUSE_DESK_PAPERS

WardensHouseWardenText:
	text_asm
	CheckEvent EVENT_GOT_HM04
	jr nz, .got_item
	ld b, GOLD_TEETH
	call IsItemInBag
	jr nz, .have_gold_teeth
	CheckEvent EVENT_GAVE_GOLD_TEETH
	jr nz, .gave_gold_teeth
	ld hl, .Gibberish1Text
	rst _PrintText
	call YesNoChoice
	ld hl, .Gibberish3Text
	jr nz, .printDone
	ld hl, .Gibberish2Text
	jr .printDone
.have_gold_teeth
	ld hl, .GaveTheGoldTeethText
	rst _PrintText
	ld a, GOLD_TEETH
	ldh [hItemToRemoveID], a
	farcall RemoveItemByID
	SetEvent EVENT_GAVE_GOLD_TEETH
.gave_gold_teeth
	ld hl, .ThanksText
	rst _PrintText
	lb bc, HM_STRENGTH, 1
	call GiveItem
	ld hl, .HM04NoRoomText
	jr nc, .printDone
	SetEvent EVENT_GOT_HM04
	ld hl, .ReceivedHM04Text
	jr .printDone
.got_item
	ld hl, .HM04ExplanationText
	rst _PrintText
	CheckEvent EVENT_GOT_HM03
	ld hl, .HM03AlreadyText
	jr nz, .printDone
	ld hl, .HM03ExplanationText
.printDone
	rst _PrintText
.done
	rst TextScriptEnd

.Gibberish1Text:
	text_far_end _WardensHouseWardenGibberish1Text

.Gibberish2Text:
	text_far_end _WardensHouseWardenGibberish2Text

.Gibberish3Text:
	text_far_end _WardensHouseWardenGibberish3Text

.GaveTheGoldTeethText:
	text_far _WardensHouseWardenGaveTheGoldTeethText
	sound_get_item_1
	text_far_end _WardensHouseWardenTeethPoppedInHisTeethText

.ThanksText:
	text_far_end _WardensHouseWardenThanksText

.ReceivedHM04Text:
	text_far_end _GenericPlayerReceivedTextSFX1

.HM04ExplanationText:
	text_far_end _WardensHouseWardenHM04ExplanationText

.HM04NoRoomText:
	text_far_end _WardensHouseWardenHM04NoRoomText

.HM03ExplanationText:
	text_far_end _WardensHouseWardenHM03ExplanationText

.HM03AlreadyText:
	text_far_end _WardensHouseWardenHM03AlreadyText
