CopycatsHouse1F_Script:
	jp EnableAutoTextBoxDrawing

CopycatsHouse1F_TextPointers:
	def_text_pointers
	dw_const CopycatsHouse1FMiddleAgedWomanText, TEXT_COPYCATSHOUSE1F_MIDDLE_AGED_WOMAN
	dw_const CopycatsHouse1FMiddleAgedManText,   TEXT_COPYCATSHOUSE1F_MIDDLE_AGED_MAN
	dw_const CopycatsHouse1FChanseyText,         TEXT_COPYCATSHOUSE1F_CHANSEY

CopycatsHouse1FMiddleAgedWomanText:
	text_far _CopycatsHouse1FMiddleAgedWomanText
	text_end

CopycatsHouse1FMiddleAgedManText:
	text_far _CopycatsHouse1FMiddleAgedManText
	text_end

CopycatsHouse1FChanseyText:
	text_far _CopycatsHouse1FChanseyText
	text_asm
	ld a, CHANSEY
	call PlayCry
	ld c, DEX_CHANSEY - 1
	callfar SetMonSeen
	CheckEvent FLAG_CHANSEY_LEARNSET
	jr nz, .done
	ld de, ParentsName
	call CopyTrainerName
	ld a, COPYCATSHOUSE1F_MIDDLE_AGED_WOMAN
	call SetSpriteFacingDown
	lb hl, DEX_CHANSEY, $FF
	ld de, ChanseyLearnsetText
	ld bc, LearnsetRecountedFondMemories
	predef_jump LearnsetTrainerScriptMain
.done
	rst TextScriptEnd

ParentsName:
	db "PARENTS@"
