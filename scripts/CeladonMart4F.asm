CeladonMart4F_Script:
	jp EnableAutoTextBoxDrawing

CeladonMart4F_TextPointers:
	def_text_pointers
	dba_const CeladonMart4FClerkText,            TEXT_CELADONMART4F_CLERK
	dba_const _CeladonMart4FSuperNerdText,        TEXT_CELADONMART4F_SUPER_NERD
	dba_const _CeladonMart4FYoungsterText,        TEXT_CELADONMART4F_YOUNGSTER
	dba_const _CeladonMart4FCurrentFloorSignText, TEXT_CELADONMART4F_CURRENT_FLOOR_SIGN

INCLUDE "data/items/marts/celadon4F.asm"