CopycatsHouse2F_Script:
	jp EnableAutoTextBoxDrawing

CopycatsHouse2F_TextPointers:
	def_text_pointers
	dba_const CopycatsHouse2FCopycatText,       TEXT_COPYCATSHOUSE2F_COPYCAT
	dba_const CopycatsHouse2FDoduoText,         TEXT_COPYCATSHOUSE2F_DODUO
	dba_const _CopycatsHouse2FRareDollText,     TEXT_COPYCATSHOUSE2F_MONSTER
	dba_const _CopycatsHouse2FRareDollText,     TEXT_COPYCATSHOUSE2F_BIRD
	dba_const _CopycatsHouse2FRareDollText,     TEXT_COPYCATSHOUSE2F_FAIRY
	dba_const _CopycatsHouse2FSNESText,         TEXT_COPYCATSHOUSE2F_SNES
	dba_const _CopycatsHouse2FPCMySecretsText,  TEXT_COPYCATSHOUSE2F_PC

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
	text_far_end _CopycatsHouse2FCopycatDoYouLikePokemonText
.gaveDoll:
	text_far_end _CopycatsHouse2FCopycatGaveDollText
.mimicTeachAgain
	text_far_end _CopycatsHouse2FCopycatAgainText
.ILikeYou
	text_far_end _CopyCatsHouse2FCopycatILikeYouText
.successLearning
	text_far_end _CopycatsHouse2FCopycatSuccessText
.cancelledLearning
	text_far_end _CopycatsHouse2FCopycatCancelledFirstTimeText
.ditto
	text_far_end _CopyCatsHouse2FCopycatDittoText
.cancelledAgain
	text_far_end _CopycatsHouse2FCopycatCancelledAgainText


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
	text_far_end _CopycatsHouse2FDoduoText2

CopycatName:
	db "COPYCAT@"
