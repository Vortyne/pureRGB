CeladonChiefHouse_Script:
	ld a, CELADON_CITY
	ld [wLastMap], a
	call WasMapJustLoaded
	call nz, RunDefaultPaletteCommand
	jp EnableAutoTextBoxDrawing

CeladonChiefHouse_TextPointers:
	def_text_pointers
	dba_const _CeladonChiefHouseChiefText,  TEXT_CELADONCHIEFHOUSE_CHIEF
	dba_const _CeladonChiefHouseRocketText, TEXT_CELADONCHIEFHOUSE_ROCKET
	dba_const _CeladonChiefHouseSailorText, TEXT_CELADONCHIEFHOUSE_SAILOR
	dba_const _CeladonSeniorHouseGrampsText, TEXT_BACKALLEYSENIORHOUSE_GRAMPS
	dba_const _CeladonSeniorHouseGrannyText, TEXT_BACKALLEYSENIORHOUSE_GRANNY
	dba_const CeladonSoftboiledGuysHouseChanseyText, TEXT_SOFTBOILEDGUYSHOUSE_CHANSEY
	dba_const CeladonSoftboiledGuysHousePaperText, TEXT_SOFTBOILEDGUYSHOUSE_PAPER
	dba_const CeladonChiefHouseBookCaseLeftText, TEXT_CELADONCHIEFHOUSE_BOOKCASE_LEFT
	dba_const _CeladonChiefHousePlaqueText, TEXT_CELADONCHIEFHOUSE_PLAQUE
	dba_const CeladonChiefHouseBookCaseRightText, TEXT_CELADONCHIEFHOUSE_BOOKCASE_RIGHT
	dba_const _CeladonSoftboiledGuysHouseEggStatueText, TEXT_SOFTBOILEDGUYSHOUSE_EGG_STATUE
	dba_const CeladonSoftboiledGuysHouseBookcaseText, TEXT_SOFTBOILEDGUYSHOUSE_BOOKCASE

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

CeladonSoftboiledGuysHouseChanseyText:
	text_far _CopycatsHouse1FChanseyText
	text_asm
	ld a, CHANSEY
	call PlayCry
	ld c, DEX_CHANSEY - 1
	callfar SetMonSeen
	rst TextScriptEnd

CeladonSoftboiledGuysHousePaperText:
	text_far _CeladonSoftboiledGuysHousePaperText
	text_asm
	xor a
	ldh [hMoney], a 
	ldh [hMoney + 2], a
	ld a, $30
	ldh [hMoney + 1], a ; loads 3000 into the cost
	ld de, CeladonMoveTutorMoves
	callfar ShowMoveTutorMoveList
	ld hl, .endText
	rst _PrintText
	rst TextScriptEnd
.endText
	text_far_end _CeladonSoftboiledGuysHousePaper2Text

CeladonSoftboiledGuysHouseBookcaseText:
	text_far _CeladonSoftboiledGuysHouseBookcaseText
	text_far _FlippedToARandomPage
	text_far _CeladonSoftboiledGuysHouseBookcase2Text
	text_asm
	CheckEvent FLAG_CHANSEY_LEARNSET
	jr nz, .done
	ld d, DEX_CHANSEY
	jpfar KeepReadingBookLearnset
.done
	rst TextScriptEnd
