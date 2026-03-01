CopycatsHouse2F_Script:
	jp EnableAutoTextBoxDrawing

CopycatsHouse2F_TextPointers:
	def_text_pointers
	dw_const CopycatsHouse2FCopycatText,      TEXT_COPYCATSHOUSE2F_COPYCAT
	dw_const CopycatsHouse2FDoduoText,        TEXT_COPYCATSHOUSE2F_DODUO
	dw_const CopycatsHouse2FRareDollText,     TEXT_COPYCATSHOUSE2F_MONSTER
	dw_const CopycatsHouse2FRareDollText,     TEXT_COPYCATSHOUSE2F_BIRD
	dw_const CopycatsHouse2FRareDollText,     TEXT_COPYCATSHOUSE2F_FAIRY
	dw_const CopycatsHouse2FSNESText,         TEXT_COPYCATSHOUSE2F_SNES
	dw_const CopycatsHouse2FPCText,           TEXT_COPYCATSHOUSE2F_PC

CopycatsHouse2FCopycatText:
	text_asm
	CheckEvent EVENT_COPYCAT_TAUGHT_MIMIC_ONCE
	ld hl, .mimicTeachAgain
	jr nz, .mimicTeach
	CheckEvent EVENT_GAVE_COPYCAT_POKE_DOLL
	jr nz, .mimicTeachFirstTime
	ld hl, .DoYouLikePokemonText
	rst _PrintText
	ld b, POKE_DOLL
	call IsItemInBag
	jr z, .done
	call DisplayTextPromptButton
	ld a, POKE_DOLL
	ldh [hItemToRemoveID], a
	farcall RemoveItemByID
	ld hl, .gaveDoll
	rst _PrintText
	SetEvent EVENT_GAVE_COPYCAT_POKE_DOLL
.mimicTeachFirstTime
	ld hl, .ILikeYou
.mimicTeach
	rst _PrintText
	ld a, MIMIC
	ld [wMoveNum], a
	callfar SingleMoveTutorScript
	CheckEvent EVENT_COPYCAT_TAUGHT_MIMIC_ONCE
	ld hl, .cancelledLearning
	jr z, .continue
	ld hl, .cancelledAgain
.continue
	ld a, d
	and a
	jr z, .printDone ; cancelled learning
	dec a
	jr z, .success
	ld hl, .ditto
.printDone
	rst _PrintText
	rst TextScriptEnd
.success
	ld hl, .successLearning
	rst _PrintText
	SetEvent EVENT_COPYCAT_TAUGHT_MIMIC_ONCE
.done
	rst TextScriptEnd
.DoYouLikePokemonText:
	text_far _CopycatsHouse2FCopycatDoYouLikePokemonText
	text_end
.gaveDoll:
	text_far _CopycatsHouse2FCopycatGaveDollText
	text_end
.mimicTeachAgain
	text_far _CopycatsHouse2FCopycatAgainText
	text_end
.ILikeYou
	text_far _CopyCatsHouse2FCopycatILikeYouText
	text_end
.successLearning
	text_far _CopycatsHouse2FCopycatSuccessText
	text_end
.cancelledLearning
	text_far _CopycatsHouse2FCopycatCancelledFirstTimeText
	text_end 
.ditto
	text_far _CopyCatsHouse2FCopycatDittoText
	text_end
.cancelledAgain
	text_far _CopycatsHouse2FCopycatCancelledAgainText
	text_end


CopycatsHouse2FDoduoText:
	text_far _CopycatsHouse2FDoduoText
	text_asm
	ld a, DODUO
	call PlayCry
	ld c, DEX_DODUO - 1
	callfar SetMonSeen
	call DisplayTextPromptButton
	ld hl, .mirrorMirror
	rst _PrintText
	CheckEvent FLAG_DODRIO_FAMILY_LEARNSET
	jr nz, .done
	ld a, COPYCATSHOUSE2F_COPYCAT
	call SetSpriteFacingDown
	ld de, CopycatName
	call CopyTrainerName
	lb hl, DEX_DODUO, $FF
	ld de, DoduoLearnsetText
	ld bc, LearnsetPlayedAroundWith
	predef_jump LearnsetTrainerScriptMain
.done
	rst TextScriptEnd
.mirrorMirror
	text_far _CopycatsHouse2FDoduoText2
	text_end

CopycatName:
	db "COPYCAT@"


CopycatsHouse2FRareDollText:
	text_far _CopycatsHouse2FRareDollText
	text_end

CopycatsHouse2FSNESText:
	text_far _CopycatsHouse2FSNESText
	text_end

CopycatsHouse2FPCText:
	text_far _CopycatsHouse2FPCMySecretsText
	text_end
