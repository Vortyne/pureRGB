CeladonMansion1F_Script:
	jp EnableAutoTextBoxDrawing

CeladonMansion1F_TextPointers:
	def_text_pointers
	dba_const CeladonMansion1FMeowthText,             TEXT_CELADONMANSION1F_MEOWTH
	dba_const CeladonMansion1FGrannyText,             TEXT_CELADONMANSION1F_GRANNY
	dba_const CeladonMansion1FClefairyText,           TEXT_CELADONMANSION1F_CLEFAIRY
	dba_const CeladonMansion1FNidoranFText,           TEXT_CELADONMANSION1F_NIDORANF
	dba_const _CeladonMansion1FManagersSuiteSignText, TEXT_CELADONMANSION1F_MANAGERS_SUITE_SIGN
	dba_const CeladonMansion1FBookCaseLeftText,       TEXT_CELADONMANSION1F_BOOKCASE_LEFT
	dba_const _DiglettSculptureText,                  TEXT_CELADONMANSION1F_DIGLETT_SCULPTURE
	dba_const CeladonMansion1FBookCaseRightText,      TEXT_CELADONMANSION1F_BOOKCASE_RIGHT

CeladonMansion1_PlayCryScript:
	push bc
	ld a, b
	call PlayCry
	pop bc
.done
	callfar SetMonSeen
	rst TextScriptEnd

CeladonMansion1FMeowthText:
	text_far _CeladonMansion1FMeowthText
	text_asm
	lb bc, MEOWTH, DEX_MEOWTH - 1
	jr CeladonMansion1_PlayCryScript

CeladonMansion1FGrannyText:
	text_far _CeladonMansion1FGrannyText
	text_asm
	ld c, DEX_MEOWTH - 1
	jr CeladonMansion1_PlayCryScript.done

CeladonMansion1FClefairyText:
	text_far _CeladonMansion1FClefairyText
	text_asm
	lb bc, CLEFAIRY, DEX_CLEFAIRY - 1
	jr CeladonMansion1_PlayCryScript

CeladonMansion1FNidoranFText:
	text_far _CeladonMansion1FNidoranFText
	text_asm
	lb bc, NIDORAN_F, DEX_NIDORAN_F - 1
	jr CeladonMansion1_PlayCryScript

CeladonMansion1FBookCaseLeftText:
	text_far _CeladonMansion1FBookCaseLeftText
	text_far _FlippedToARandomPage
	text_far _CeladonMansion1FBookCaseLeft2Text
	text_asm
	CheckEvent FLAG_EXEGGUTOR_FAMILY_LEARNSET
	jr nz, .done
	ld d, DEX_EXEGGCUTE
	jpfar KeepReadingBookLearnset
.done
	rst TextScriptEnd

CeladonMansion1FBookCaseRightText:
	text_far _CeladonMansion1FBookCaseRightText
	text_far _FlippedToARandomPage 
	text_far _CeladonMansion1FBookCaseRight2Text
	text_asm
	CheckEvent FLAG_DODRIO_FAMILY_LEARNSET
	jr nz, .done
	ld d, DEX_DODRIO
	jpfar KeepReadingBookLearnset
.done
	rst TextScriptEnd
