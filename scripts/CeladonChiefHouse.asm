CeladonChiefHouse_Script:
	ld a, CELADON_CITY
	ld [wLastMap], a
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	call nz, RunDefaultPaletteCommand
	jp EnableAutoTextBoxDrawing

CeladonChiefHouse_TextPointers:
	def_text_pointers
	dw_const CeladonChiefHouseChiefText,  TEXT_CELADONCHIEFHOUSE_CHIEF
	dw_const CeladonChiefHouseRocketText, TEXT_CELADONCHIEFHOUSE_ROCKET
	dw_const CeladonChiefHouseSailorText, TEXT_CELADONCHIEFHOUSE_SAILOR
	dw_const CeladonSeniorHouseGrampsText, TEXT_BACKALLEYSENIORHOUSE_GRAMPS
	dw_const CeladonSeniorHouseGrannyText, TEXT_BACKALLEYSENIORHOUSE_GRANNY
	dw_const CeladonChiefHouseBookCaseLeftText, TEXT_CELADONCHIEFHOUSE_BOOKCASE_LEFT
	dw_const CeladonChiefHousePlaqueText, TEXT_CELADONCHIEFHOUSE_PLAQUE
	dw_const CeladonChiefHouseBookCaseRightText, TEXT_CELADONCHIEFHOUSE_BOOKCASE_RIGHT

CeladonChiefHouseChiefText:
	text_far _CeladonChiefHouseChiefText
	text_end

CeladonChiefHouseRocketText:
	text_far _CeladonChiefHouseRocketText
	text_end

CeladonChiefHouseSailorText:
	text_far _CeladonChiefHouseSailorText
	text_end

CeladonChiefHouseBookCaseLeftText:
	text_far _CeladonChiefHouseBookCaseLeftText
	text_far _FlippedToARandomPage
	text_far _CeladonChiefHouseBookCaseLeft2Text
	text_asm
	CheckEvent FLAG_LICKITUNG_LEARNSET
	jr nz, .done
	ld d, DEX_LICKITUNG
	jpfar KeepReadingBookLearnset
.done
	rst TextScriptEnd

CeladonChiefHouseBookCaseRightText:
	text_far _CeladonChiefHouseBookCaseRightText
	text_far _FlippedToARandomPage 
	text_far _CeladonChiefHouseBookCaseRight2Text
	text_asm
	CheckEvent FLAG_MR_MIME_LEARNSET
	jr nz, .done
	ld d, DEX_MR_MIME
	jpfar KeepReadingBookLearnset
.done
	rst TextScriptEnd

CeladonChiefHousePlaqueText:
	text_far _CeladonChiefHousePlaqueText
	text_end

CeladonSeniorHouseGrampsText:
	text_far _CeladonSeniorHouseGrampsText
	text_end
	
CeladonSeniorHouseGrannyText:
	text_far _CeladonSeniorHouseGrannyText
	text_end