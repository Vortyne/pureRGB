CeruleanTrashedHouse_Script:
	jp EnableAutoTextBoxDrawing

CeruleanTrashedHouse_TextPointers:
	def_text_pointers
	dw_const CeruleanTrashedHouseFishingGuruText, TEXT_CERULEANTRASHEDHOUSE_FISHING_GURU
	dw_const CeruleanTrashedHouseGirlText,        TEXT_CERULEANTRASHEDHOUSE_GIRL
	dw_const CeruleanTrashedHouseWallHoleText,    TEXT_CERULEANTRASHEDHOUSE_WALL_HOLE

CeruleanTrashedHouseFishingGuruText:
	text_asm
	ld b, TM_CERULEAN_ROCKET_TM_THIEF
	predef GetQuantityOfItemInBag
	and b
	ld hl, .TheyStoleATMText
	jr z, .printDone
	ld hl, .WhatsLostIsLostText
.printDone
	rst _PrintText
	rst TextScriptEnd

.TheyStoleATMText:
	text_far _CeruleanTrashedHouseFishingGuruTheyStoleATMText
	text_end

.WhatsLostIsLostText:
	text_far _CeruleanTrashedHouseFishingGuruWhatsLostIsLostText
	text_end

CeruleanTrashedHouseGirlText:
	text_far _CeruleanTrashedHouseGirlText
	text_end

CeruleanTrashedHouseWallHoleText:
	text_far _CeruleanTrashedHouseWallHoleText
	text_end
