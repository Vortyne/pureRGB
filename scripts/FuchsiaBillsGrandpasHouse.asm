FuchsiaBillsGrandpasHouse_Script:
	jp EnableAutoTextBoxDrawing

FuchsiaBillsGrandpasHouse_TextPointers:
	def_text_pointers
	dba_const _FuchsiaBillsGrandpasHouseMiddleAgedWomanText, TEXT_FUCHSIABILLSGRANDPASHOUSE_MIDDLE_AGED_WOMAN
	dba_const _FuchsiaBillsGrandpasHouseBillsGrandpaText,    TEXT_FUCHSIABILLSGRANDPASHOUSE_BILLS_GRANDPA
	dba_const _FuchsiaBillsGrandpasHouseYoungsterText,       TEXT_FUCHSIABILLSGRANDPASHOUSE_YOUNGSTER
	dba_const FuchsiaBillsGrandpasHouseTVText,              TEXT_FUCHSIABILLSGRANDPASHOUSE_TV

FuchsiaBillsGrandpasHouseTVText::
	text_asm
	jpfar PorygonTVScreenText
