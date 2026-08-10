; PureRGBnote: ADDED: code for the new basement below the viridian schoolhouse. Contains a couple of classrooms.

ViridianSchoolHouseB1F_Script:
	call CheckGusGLeaves
	jp EnableAutoTextBoxDrawing

CheckGusGLeaves:
	CheckAndResetEvent EVENT_DETENTION_TOGGLER
	ret z
	; show jen or gus
	call GBFadeOutToWhite
	ld c, 20
	rst DelayFrames
	call SetDetentionHideShows
	call UpdateSpritesAndDelay3
	call GBFadeInFromWhite
	CheckEvent EVENT_GUS_IN_DETENTION
	ret z
	jp PlayDefaultMusic

SetDetentionHideShows::
	ld hl, DetentionHideList
	ToggleEvent EVENT_GUS_IN_DETENTION
	ld b, 0
	jr z, .hideShowLoop
	inc b
.hideShowLoop
	ld a, [hli]
	cp -1
	ret z
	ld c, a
	ld a, b
	xor 1
	ld b, a
	push hl
	push bc
	jr z, .dohide
.doShow
	call ShowExtraObject
	jr .next
.dohide
	call HideExtraObject
.next
	pop bc
	pop hl
	jr .hideShowLoop

DetentionHideList:
	db TOGGLE_VIRIDIAN_SCHOOL_HOUSE_DETENTION
	db TOGGLE_VIRIDIAN_SCHOOL_HOUSE_DETENTION2
	db TOGGLE_VIRIDIAN_SCHOOL_HOUSE_B1F_DETENTION
	db TOGGLE_VIRIDIAN_SCHOOL_HOUSE_B1F_DETENTION2
	db -1

ViridianSchoolHouseB1F_TextPointers:
	def_text_pointers
	dba_const _SchoolB1FGuyNearStairs,         TEXT_SCHOOLB1F_GUY_NEAR_STAIRS
	dba_const _SchoolB1FRightTeacher,          TEXT_SCHOOLB1F_RIGHT_TEACHER
	dba_const _SchoolB1FLittleGirlProdigy,     TEXT_SCHOOLB1F_LITTLE_GIRL
	dba_const SchoolB1FNerd,                  TEXT_SCHOOLB1F_NERD
	dba_const SchoolB1FLeftTeacher,           TEXT_SCHOOLB1F_LEFT_TEACHER
	dba_const _SchoolB1FStudentTeacher,        TEXT_SCHOOLB1F_STUDENT_TEACHER
	dba_const _SchoolB1FTutorText,            TEXT_SCHOOLB1F_DAISY_TUTOR
	dba_const _SchoolB1FLeftTuteeText,             TEXT_SCHOOLB1F_TUTEE_LEFT
	dba_const _SchoolB1FRightTuteeText,            TEXT_SCHOOLB1F_TUTEE_RIGHT
	dba_const SchoolB1FRocker,                TEXT_SCHOOLB1F_ROCKER
	dba_const SchoolB1FBrunetteGirl,          TEXT_SCHOOLB1F_BRUNETTE_GIRL
	dba_const _SchoolB1FCornerGameboyKid,            TEXT_SCHOOLB1F_GAMEBOY_KID
	dba_const _SchoolB1FBottomLeftNotebook,    TEXT_SCHOOLB1F_BOTTOM_LEFT_NOTEBOOK
	dba_const _SchoolB1FBottomCenterNotebook,  TEXT_SCHOOLB1F_BOTTOM_CENTER_NOTEBOOK
	dba_const _SchoolB1FLeftTuteeNotebook,     TEXT_SCHOOLB1F_LEFT_TUTEE_NOTEBOOK
	dba_const _SchoolB1FTutorNotebook,         TEXT_SCHOOLB1F_TUTOR_NOTEBOOK
	dba_const _SchoolB1FRockerNotebook,        TEXT_SCHOOLB1F_ROCKER_NOTEBOOK
	dba_const _SchoolB1FBrunetteGirlNotebook,  TEXT_SCHOOLB1F_BRUNETTE_GIRL_NOTEBOOK
	dba_const SchoolB1FNerdNotebook,          TEXT_SCHOOLB1F_NERD_NOTEBOOK
	dba_const _SchoolB1FBottomRightNotebook,   TEXT_SCHOOLB1F_BOTTOM_RIGHT_NOTEBOOK
	dba_const _SchoolB1FLeftBlackboard,        TEXT_SCHOOLB1F_LEFT_BLACKBOARD
	dba_const _SchoolB1FRightBlackboard,       TEXT_SCHOOLB1F_RIGHT_BLACKBOARD
	dba_const _SchoolB1FLeftClassroomSign,     TEXT_SCHOOLB1F_LEFT_CLASSROOM_SIGN
	dba_const _SchoolB1FRightClassroomSign,    TEXT_SCHOOLB1F_RIGHT_CLASSROOM_SIGN
	dba_const _SchoolB1FLeftPoster,            TEXT_SCHOOLB1F_LEFT_POSTER
	dba_const _SchoolB1FRightPoster,           TEXT_SCHOOLB1F_RIGHT_POSTER
	dba_const SchoolB1FBookcasesText,         TEXT_SCHOOLB1F_BOOKCASES

SchoolB1FNerd:
	text_asm
	ld a, SCHOOLB1F_LITTLE_GIRL
	call SetSpriteFacingUp
	ld hl, SchoolB1FNerdText
	rst _PrintText
	ld a, SCHOOLB1F_LITTLE_GIRL
	call SetSpriteFacingLeft
  	ld a, [wOptions3]
  	bit BIT_GHOST_PSYCHIC, a
  	ld hl, SchoolB1FLittleGirlRetort2Text
  	jr z, .ghostWeak
  	ld hl, SchoolB1FLittleGirlRetortText
 .ghostWeak
  	rst _PrintText
	ld a, SCHOOLB1F_NERD
	call SetSpriteFacingUp
  	ld c, 20
  	rst DelayFrames
	ld a, SCHOOLB1F_NERD
	call SetSpriteFacingRight
	ld a, SCHOOLB1F_LITTLE_GIRL
	call SetSpriteFacingUp
  	ld hl, SchoolB1FNerdSilence
  	rst _PrintText
	ld a, SCHOOLB1F_LITTLE_GIRL
	call SetSpriteFacingLeft
  	ld hl, SchoolB1FLittleGirlBro
  	rst _PrintText
	ld a, SCHOOLB1F_NERD
	call SetSpriteFacingUp
  	ld hl, SchoolB1FNerdAck
  	rst _PrintText
  	rst TextScriptEnd

SchoolB1FNerdText:
	text_far_end _SchoolB1FNerd

SchoolB1FLittleGirlRetortText:
	text_far_end _SchoolB1FLittleGirlRetort

SchoolB1FLittleGirlRetort2Text:
	text_far_end _SchoolB1FLittleGirlRetort2

SchoolB1FNerdSilence:
	text_far_end _SchoolB1FNerdSilence

SchoolB1FLittleGirlBro:
	text_far_end _SchoolB1FLittleGirlBro

SchoolB1FNerdAck:
	text_far_end _SchoolB1FNerdAck

SchoolB1FLeftTeacher:
	text_asm
	ld hl, SchoolB1FLeftTeacherInit
	CheckEvent EVENT_GOT_OAKS_PARCEL
	jr z, .noParcel
	CheckEvent EVENT_GOT_POKEDEX
	jr z, .noPokedex
	CheckEvent EVENT_CHECKED_AROUND_SCHOOLHOUSE
	jp z, .checkFirst
	CheckEvent EVENT_GOT_MOVEDEX
	jr nz, .gotMoveDex
	call SaveScreenTilesToBuffer2
	ld hl, SchoolB1FLeftTeacherReadyStart
	rst _PrintText
	xor a
	ld [wCurrentMenuItem], a
	call YesNoChoice
	jr nz, .notReady

	ld c, BANK(Music_MuseumGuy)
	ld a, MUSIC_MUSEUM_GUY
	call PlayMusic

	ld hl, SchoolB1FLeftTeacherReadyYes
	rst _PrintText

	call SchoolB1FMovedexTest
	jp c, .doneResetMusic
	call LoadScreenTilesFromBuffer2
	ld hl, SchoolB1FLeftTeacherQuizFinish
	rst _PrintText
	call StopAllMusic
	ld hl, ReceivedMovedexText
	rst _PrintText
	SetEvent EVENT_GOT_MOVEDEX
	call PlayDefaultMusic
	ld hl, SchoolB1FLeftTeacherQuizFinalInfo
	rst _PrintText
	jr .done
.noParcel
	rst _PrintText
	ld hl, SchoolB1FLeftTeacherNoParcel
	rst _PrintText
	jr .later
.noPokedex
	rst _PrintText
	ld hl, SchoolB1FLeftTeacherNoPokedex
	rst _PrintText
	jr .later
.gotMoveDex
	ld hl, SchoolB1FLeftTeacherQuizFinalInfo
	rst _PrintText
	call DisplayTextPromptButton
	ld hl, SchoolB1FLeftTeacherEnd
	rst _PrintText
	jr .done
.notReady
	ld hl, SchoolB1FLeftTeacherReadyNo
	rst _PrintText
	jr .done
.checkFirst
	ld hl, SchoolB1FLeftTeacherFirst
	rst _PrintText
	xor a
	ld [wCurrentMenuItem], a
	call YesNoChoice
	jr nz, .faffing
	ld hl, SchoolB1FLeftTeacherYes
	rst _PrintText
	SetEvent EVENT_CHECKED_AROUND_SCHOOLHOUSE
	jr .done
.faffing
	ld hl, SchoolB1FLeftTeacherNo
	rst _PrintText
	jr .done
.later
	ld hl, SchoolB1FLeftTeacherLater
	rst _PrintText
	jr .done
.doneResetMusic
	call PlayDefaultMusic
.done
	rst TextScriptEnd


SchoolB1FLeftTeacherInit:
	text_far_end _SchoolB1FLeftTeacherInit

SchoolB1FLeftTeacherNoParcel:
	text_far_end _SchoolB1FLeftTeacherNoParcel

SchoolB1FLeftTeacherNoPokedex:
	text_far_end _SchoolB1FLeftTeacherNoPokedex

SchoolB1FLeftTeacherLater:
	text_far_end _SchoolB1FLeftTeacherLater

SchoolB1FLeftTeacherFirst:
	text_far_end _SchoolB1FLeftTeacherFirst

SchoolB1FLeftTeacherNo:
	text_far_end _SchoolB1FLeftTeacherNo

SchoolB1FLeftTeacherYes:
	text_far_end _SchoolB1FLeftTeacherYes

SchoolB1FLeftTeacherReadyStart:
	text_far_end _SchoolB1FLeftTeacherReadyStart

SchoolB1FLeftTeacherReadyYes:
	text_far_end _SchoolB1FLeftTeacherReadyYes

SchoolB1FLeftTeacherReadyNo:
	text_far_end _SchoolB1FLeftTeacherReadyNo

SchoolB1FRocker:
	text_asm
	call SaveScreenTilesToBuffer2
	ld hl, SchoolB1FRockerText
	rst _PrintText
	xor a
	ld [wCurrentMenuItem], a
	call YesNoChoice
	ld hl, SchoolB1FRockerYesText
	jr z, .yes
	ld hl, SchoolB1FRockerNoText
.yes
	rst _PrintText

	ld c, BANK(Music_MeetMaleTrainer)
	ld a, MUSIC_MEET_MALE_TRAINER
	call PlayMusic

	ld c, 160
	rst DelayFrames

	ld c, BANK(Music_TrainerBattle)
	ld a, MUSIC_TRAINER_BATTLE
	call PlayMusic

	callfar BattleTransition

	ld c, 120
	rst DelayFrames
	call LoadScreenTilesFromBuffer2
	call StopAllMusic
	call GBPalNormal
	call EnableSpriteUpdates
	call UpdateSprites

	ld c, BANK(SFX_Safari_Zone_PA)
	ld a, SFX_SAFARI_ZONE_PA
	call PlayMusic

	ld c, 60
	rst DelayFrames
	ld hl, SchoolB1FRockerDetentionText
	rst _PrintText
	SetEvent EVENT_DETENTION_TOGGLER
	rst TextScriptEnd

SchoolB1FRockerText:
	text_far_end _SchoolB1FRocker

SchoolB1FRockerYesText:
	text_far_end _SchoolB1FRockerYes

SchoolB1FRockerNoText:
	text_far_end _SchoolB1FRockerNo

SchoolB1FRockerDetentionText:
	text_far_end _SchoolB1FDetentionText




SchoolB1FBrunetteGirl:
	text_asm
	ld b, 2
.loop
	push bc
	ld a, SCHOOLB1F_BRUNETTE_GIRL
	call SetSpriteFacingLeft
  	call UpdateSprites
  	ld c, 20
  	rst DelayFrames
	ld a, SCHOOLB1F_BRUNETTE_GIRL
	call SetSpriteFacingUp
  	call UpdateSprites
  	ld c, 20
  	rst DelayFrames
  	pop bc
  	dec b
  	jr nz, .loop

	ld a, SCHOOLB1F_BRUNETTE_GIRL
	call SetSpriteFacingLeft

  	ld hl, SchoolB1FBrunetteGirlText
  	rst _PrintText

	ld c, 60
	rst DelayFrames

	ld c, BANK(SFX_Safari_Zone_PA)
	ld a, SFX_SAFARI_ZONE_PA
	call PlayMusic

	ld c, 60
	rst DelayFrames
	ld hl, SchoolB1FDetention2Text
	rst _PrintText
	ld a, SCHOOLB1F_BRUNETTE_GIRL
	call SetSpriteFacingUp
	ld hl, SchoolB1FNotAgainText
	rst _PrintText
	SetEvent EVENT_DETENTION_TOGGLER
	rst TextScriptEnd

SchoolB1FBrunetteGirlText:
	text_far_end _SchoolB1FBrunetteGirl

SchoolB1FDetention2Text:
	text_far_end _SchoolB1FDetention2Text

SchoolB1FNotAgainText:
	text_far_end _SchoolB1FNotAgainText

SchoolB1FNerdNotebook:
	text_asm
	ld hl, SchoolB1FNerdNotebookInit
	rst _PrintText
	xor a
	ld [wCurrentMenuItem], a
.loop
	ld hl, SchoolB1FNerdNotebookRepeat
	rst _PrintText
	ld hl, StatTextList
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	ld a, PAD_A | PAD_B
	ld [wMenuWatchedKeys], a
	callfar DisplayMultiChoiceMenu
	ldh a, [hJoy5]
	bit B_PAD_B, a
	jr nz, .done
	ld hl, SchoolB1FNerdNotebookTextPointers
	ld a, [wCurrentMenuItem]
	add a
	add a ; multiply by TEXT_FAR_TABLE_ENTRY_SIZE
	ld d, $0
	ld e, a
	add hl, de
	rst _PrintText
	jr .loop
.done
	ld hl, SchoolB1FDone
	rst _PrintText
	rst TextScriptEnd

SchoolB1FNerdNotebookInit:
	text_far_end _SchoolB1FNerdTextbook

SchoolB1FNerdNotebookRepeat:
	text_far_end _SchoolB1FNerdNotebookRepeat

SchoolB1FNerdNotebookTextPointers:
SchoolB1FNerdNotebookHP:
	text_far_end _SchoolB1FNerdNotebookHP
SchoolB1FNerdNotebookAttack:
	text_far_end _SchoolB1FNerdNotebookAttack
SchoolB1FNerdNotebookDefense:
	text_far_end _SchoolB1FNerdNotebookDefense
SchoolB1FNerdNotebookSpeed:
	text_far_end _SchoolB1FNerdNotebookSpeed
SchoolB1FNerdNotebookSpecial:
	text_far_end _SchoolB1FNerdNotebookSpecial

SchoolB1FDone:
	text_far_end _VendingMachineText8

SchoolB1FMovedexTest:
	ld hl, MovedexTestQuestionList
.questionLoop
	push hl
	call LoadScreenTilesFromBuffer2
	pop hl
	xor a
	ld [wCurrentMenuItem], a
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	rst _PrintText
	pop hl
	call DoMoveDexTestQuestion
	jr nz, .incorrect
	push hl
	call WaitForSoundToFinish
	ld a, SFX_GET_ITEM_1
	rst _PlaySound
	call WaitForSoundToFinish
	ld hl, SchoolB1FLeftTeacherQuizCorrect
	rst _PrintText
	pop hl
	inc hl
	ld a, [hl]
	cp $fe
	jr z, .quickAttackComment
	cp $ff
	jr nz, .questionLoop
	and a
	ret
.quickAttackComment
	inc hl
	push hl
	ld hl, SchoolB1FLeftTeacherQuizQuickAttack
	rst _PrintText
	pop hl
	jr .questionLoop
.incorrect
	call WaitForSoundToFinish
	ld a, SFX_DENIED
	rst _PlaySound
	call WaitForSoundToFinish
	ld hl, SchoolB1FLeftTeacherQuizIncorrect
	rst _PrintText
	scf
	ret

; returns z if they got the right answer
DoMoveDexTestQuestion:
	inc hl
	inc hl
	ld a, PAD_A
	ld [wMenuWatchedKeys], a
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	callfar DisplayMultiChoiceMenu
	ld a, [wCurrentMenuItem]
	ld b, a
	pop hl
	inc hl
	inc hl
	ld a, [hl] ; answer number
	dec a ; answer menu index
	cp b
	ret

MovedexTestQuestionList:
	dw SchoolB1FLeftTeacherQuizQuestion1
	dw MoveDexQuestion1
	db 3 ; answer
	dw SchoolB1FLeftTeacherQuizQuestion2
	dw MoveDexQuestion2
	db 2 ; answer
	db $fe
	dw SchoolB1FLeftTeacherQuizQuestion3
	dw MoveDexQuestion3
	db 1 ; answer
	dw SchoolB1FLeftTeacherQuizQuestion4
	dw MoveDexQuestion4
	db 2 ; answer
	dw SchoolB1FLeftTeacherQuizQuestion5
	dw MoveDexQuestion5
	db 4 ; answer
	db -1

SchoolB1FLeftTeacherQuizQuestion1:
	text_far_end _SchoolB1FLeftTeacherQuizQuestion1

SchoolB1FLeftTeacherQuizQuestion2:
	text_far_end _SchoolB1FLeftTeacherQuizQuestion2

SchoolB1FLeftTeacherQuizQuickAttack:
	text_far_end _SchoolB1FLeftTeacherQuizQuickAttack

SchoolB1FLeftTeacherQuizQuestion3:
	text_far_end _SchoolB1FLeftTeacherQuizQuestion3

SchoolB1FLeftTeacherQuizQuestion4:
	text_far_end _SchoolB1FLeftTeacherQuizQuestion4

SchoolB1FLeftTeacherQuizQuestion5:
	text_far_end _SchoolB1FLeftTeacherQuizQuestion5

SchoolB1FLeftTeacherQuizCorrect:
	text_far_end _SchoolB1FLeftTeacherQuizCorrect

SchoolB1FLeftTeacherQuizIncorrect:
	text_far_end _SchoolB1FLeftTeacherQuizWrong

SchoolB1FLeftTeacherQuizFinish:
	text_far_end _SchoolB1FLeftTeacherQuizFinish

ReceivedMovedexText:
	text_far_end _ReceivedMovedexText

SchoolB1FLeftTeacherQuizFinalInfo:
	text_far_end _SchoolB1FLeftTeacherQuizFinalInfo

SchoolB1FLeftTeacherEnd:
	text_far_end _SchoolB1FLeftTeacherEnd

ViridianSchoolHouseB1FBookCases::
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	ld a, TEXT_SCHOOLB1F_BOOKCASES
	ldh [hTextID], a
	jp DisplayTextID

SchoolB1FBookcasesText:
	text_asm
	ld a, [wHiddenEventFunctionArgument]
	ld b, 0
	ld c, a
	ld hl, SchoolB1FBookCaseTextData
	add hl, bc
	rst _PrintText
	rst TextScriptEnd

SchoolB1FBookCaseTextData:
SchoolB1FLeftBookcaseAText:
	text_far _SchoolB1FLeftBookcaseA
	text_far _FlippedToARandomPage
	text_far_end _SchoolB1FLeftBookcaseA2
SchoolB1FLeftBookcaseBText:
	text_far _SchoolB1FLeftBookcaseB
	text_far _FlippedToARandomPage
	text_far_end _SchoolB1FLeftBookcaseB2
SchoolB1FRightBookcaseAText:
	text_far _SchoolB1FRightBookcaseA
	text_far _FlippedToARandomPage
	text_far_end _SchoolB1FRightBookcaseA2
SchoolB1FRightBookcaseBText:
	text_far _SchoolB1FRightBookcaseB
	text_far _FlippedToARandomPage
	text_far_end _SchoolB1FRightBookcaseB2
