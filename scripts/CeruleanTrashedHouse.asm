CeruleanTrashedHouse_Script:
	jp EnableAutoTextBoxDrawing

CeruleanTrashedHouse_TextPointers:
	def_text_pointers
	dba_const CeruleanTrashedHouseFishingGuruText, TEXT_CERULEANTRASHEDHOUSE_FISHING_GURU
	dba_const _CeruleanTrashedHouseGirlText,       TEXT_CERULEANTRASHEDHOUSE_GIRL
	dba_const _CeruleanTrashedHouseWallHoleText,   TEXT_CERULEANTRASHEDHOUSE_WALL_HOLE

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
	text_far_end _CeruleanTrashedHouseFishingGuruTheyStoleATMText

.WhatsLostIsLostText:
	text_far_end _CeruleanTrashedHouseFishingGuruWhatsLostIsLostText
