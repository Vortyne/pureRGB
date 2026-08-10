CeladonMart2F_Script:
	jp EnableAutoTextBoxDrawing

CeladonMart2F_TextPointers:
	def_text_pointers
	dba_const CeladonMart2FClerk1Text,           TEXT_CELADONMART2F_CLERK1
	dba_const CeladonMart2FClerk2Text,           TEXT_CELADONMART2F_CLERK2
	dba_const _CeladonMart2FMiddleAgedManText,   TEXT_CELADONMART2F_MIDDLE_AGED_MAN
	dba_const _CeladonMart2FGirlText,             TEXT_CELADONMART2F_GIRL
	dba_const CeladonMart2FCurrentFloorSignText, TEXT_CELADONMART2F_CURRENT_FLOOR_SIGN

CeladonMart2FCurrentFloorSignText:
	text_far _CeladonMart2FCurrentFloorSignText
	text_asm
	ld hl, .part2
	rst _PrintText
	rst TextScriptEnd
.part2
	text_far_end _CeladonMart2FDirectorySignText

INCLUDE "data/items/marts/celadon2F.asm"