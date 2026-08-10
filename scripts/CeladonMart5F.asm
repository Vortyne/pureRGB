CeladonMart5F_Script:
	jp EnableAutoTextBoxDrawing

CeladonMart5F_TextPointers:
	def_text_pointers
	dba_const _CeladonMart5FGentlemanText,        TEXT_CELADONMART5F_GENTLEMAN
	dba_const _CeladonMart5FSailorText,           TEXT_CELADONMART5F_SAILOR
	dba_const CeladonMart5FClerk1Text,           TEXT_CELADONMART5F_CLERK1
	dba_const CeladonMart5FClerk2Text,           TEXT_CELADONMART5F_CLERK2
	dba_const _CeladonMart5FCurrentFloorSignText, TEXT_CELADONMART5F_CURRENT_FLOOR_SIGN

INCLUDE "data/items/marts/celadon5F.asm"
