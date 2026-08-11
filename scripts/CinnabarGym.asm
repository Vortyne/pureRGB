CinnabarGym_Script:
	call CinnabarGymSetMapAndTiles
	ld hl, CinnabarGym_ScriptPointers
	ld de, wCinnabarGymCurScript
	jp CallMapScriptInTable

CinnabarGymSetMapAndTiles:
	call WasMapJustLoaded
	res BIT_CUR_MAP_LOADED_2, [hl]
	call nz, UpdateCinnabarGymGateTileBlocks
	;ResetEvent EVENT_2A7
	ret

CinnabarGym_ScriptPointers:
	def_script_pointers
	dw_const CinnabarGymDefaultScript,          SCRIPT_CINNABARGYM_DEFAULT
	dw_const CinnabarGymGetOpponentTextScript,  SCRIPT_CINNABARGYM_GET_OPPONENT_TEXT
	dw_const CinnabarGymOpenGateScript,         SCRIPT_CINNABARGYM_OPEN_GATE
	dw_const CinnabarGymBlainePostBattleScript, SCRIPT_CINNABARGYM_BLAINE_POST_BATTLE

CinnabarGymDefaultScript:
	ld a, [wOpponentAfterWrongAnswer]
	and a
	ret z
	ldh [hSpriteIndex], a
	cp CINNABARGYM_SUPER_NERD2
	jr nz, .not_super_nerd3
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld de, MovementNpcToLeftAndUp
	jr .MoveSprite
.not_super_nerd3
	ld de, MovementNpcToLeft
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
.MoveSprite
	call MoveSprite
	ld a, SCRIPT_CINNABARGYM_GET_OPPONENT_TEXT
	ld [wCinnabarGymCurScript], a
	ld [wCurMapScript], a
	ret

MovementNpcToLeftAndUp:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db -1 ; end

MovementNpcToLeft:
	db NPC_MOVEMENT_LEFT
	db -1 ; end

CinnabarGymGetOpponentTextScript:
	call IsNPCAutoMoving
	ret nz
	call EnableAllJoypad
	ld a, [wOpponentAfterWrongAnswer]
	ld [wTrainerHeaderFlagBit], a
	ldh [hTextID], a
	jp DisplayTextID

CinnabarGymResetScripts:
	call ResetMapScripts
	; a = 0 after ResetMapScripts
	ld [wCinnabarGymCurScript], a ; SCRIPT_CINNABARGYM_DEFAULT
	ld [wOpponentAfterWrongAnswer], a
	ret

CinnabarGymOpenGateScript:
	ld a, [wIsInBattle]
	cp $ff
	jr z, CinnabarGymResetScripts
	ld a, [wTrainerHeaderFlagBit]
	ldh [hGymGateIndex], a
	AdjustEventBit EVENT_BEAT_CINNABAR_GYM_TRAINER_0, 2
	ld c, a
	ld b, FLAG_TEST
	EventFlagAddress hl, EVENT_BEAT_CINNABAR_GYM_TRAINER_0
	call FlagAction
	ld a, c
	and a
	jr nz, .no_sound
	call WaitForSoundToFinish
	ld a, SFX_GO_INSIDE
	rst _PlaySound
	call WaitForSoundToFinish
.no_sound
	ld a, [wTrainerHeaderFlagBit]
	ldh [hGymGateIndex], a
	AdjustEventBit EVENT_BEAT_CINNABAR_GYM_TRAINER_0, 2
	ld c, a
	ld b, FLAG_SET
	EventFlagAddress hl, EVENT_BEAT_CINNABAR_GYM_TRAINER_0
	call FlagAction
	ld a, [wTrainerHeaderFlagBit]
	sub $2
	AdjustEventBit EVENT_CINNABAR_GYM_GATE0_UNLOCKED, 0
	ld c, a
	ld b, FLAG_SET
	EventFlagAddress hl, EVENT_CINNABAR_GYM_GATE0_UNLOCKED
	call FlagAction
	call UpdateCinnabarGymGateTileBlocks
	jr CinnabarGymResetScripts

CinnabarGymBlainePostBattleScript:
	call UpdateCinnabarGymGateTileBlocks
	ld hl, wCurrentMapScriptFlags
	res BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	call GBFadeInFromWhite ; PureRGBnote: ADDED: since trainer instantly talks to us after battle we need to fade back in here after battle
	ld a, [wIsInBattle]
	cp $ff
	jr z, CinnabarGymResetScripts
	call DisableDpad
; fallthrough
CinnabarGymReceiveTM38:
	ld d, CINNABARGYM_BLAINE
	callfar MakeSpriteFacePlayer
	ld a, TEXT_CINNABARGYM_BLAINE_VOLCANO_BADGE_INFO
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_BLAINE
	lb bc, TM_BLAINE, 1
	call GiveItem
	jr nc, .BagFull
	ld a, TEXT_CINNABARGYM_BLAINE_RECEIVED_TM38
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM38
	jr .gymVictory
.BagFull
	ld a, TEXT_CINNABARGYM_BLAINE_TM38_NO_ROOM
	ldh [hTextID], a
	call DisplayTextID
.gymVictory
	ld hl, wObtainedBadges
	set BIT_VOLCANOBADGE, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_CINNABAR_GYM_TRAINER_0, EVENT_BEAT_CINNABAR_GYM_TRAINER_6
	
	ld a, CINNABARGYM_BLAINE
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	jp CinnabarGymResetScripts

CinnabarGym_TextPointers:
	def_text_pointers
	dba_const CinnabarGymBlaineText,                 TEXT_CINNABARGYM_BLAINE
	dba_const CinnabarGymSuperNerd1,                 TEXT_CINNABARGYM_SUPER_NERD1
	dba_const CinnabarGymBurglar1,                   TEXT_CINNABARGYM_BURGLAR1
	dba_const CinnabarGymSuperNerd2,                 TEXT_CINNABARGYM_SUPER_NERD2
	dba_const CinnabarGymBurglar2,                   TEXT_CINNABARGYM_BURGLAR2
	dba_const CinnabarGymFirefighter1,               TEXT_CINNERBARGYM_FIREFIGHTER1
	dba_const CinnabarGymBurglar3,                   TEXT_CINNABARGYM_BURGLAR3
	dba_const CinnabarGymFirefighter2,               TEXT_CINNERBARGYM_FIREFIGHTER2
	dba_const CinnabarGymGymGuideText,               TEXT_CINNABARGYM_GYM_GUIDE
	dba_const CinnabarGymBlaineVolcanoBadgeInfoText, TEXT_CINNABARGYM_BLAINE_VOLCANO_BADGE_INFO
	dba_const CinnabarGymBlaineReceivedTM38Text,     TEXT_CINNABARGYM_BLAINE_RECEIVED_TM38
	dba_const CinnabarGymBlaineTM38NoRoomText,       TEXT_CINNABARGYM_BLAINE_TM38_NO_ROOM
	dba_const CinnabarGymQuiz,                       TEXT_CINNABARGYM_QUIZ

CinnabarGymStartBattleScript:
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld a, [wSpriteIndex]
	cp CINNABARGYM_BLAINE
	ld a, SCRIPT_CINNABARGYM_BLAINE_POST_BATTLE
	jr z, .blaine
	ld a, SCRIPT_CINNABARGYM_OPEN_GATE
.blaine
	ld [wCinnabarGymCurScript], a
	ld [wCurMapScript], a
	rst TextScriptEnd

CinnabarGymBlaineText:
	text_asm
	CheckEvent EVENT_BEAT_BLAINE
	jr z, .beforeBeat
	CheckEventReuseA EVENT_GOT_TM38
	jr nz, .afterBeat
	call z, CinnabarGymReceiveTM38
	call DisableWaitingAfterTextDisplay
	rst TextScriptEnd
.afterBeat
	ld d, MOLTRES
	callfar IsMonInParty
	jr nc, .noMoltres
	ld hl, .moltresText
	rst _PrintText
	lb hl, DEX_MOLTRES, BLAINE
	ld de, TextNothing
	ld bc, LearnsetFadeOutInBlaineStory
	predef_jump LearnsetTrainerScriptMain
.noMoltres
	ld hl, .PostBattleAdviceText
	rst _PrintText
	rst TextScriptEnd
.beforeBeat
	ld hl, .PreBattleText
	rst _PrintText
	ld hl, .ReceivedVolcanoBadgeText
	ld de, .ReceivedVolcanoBadgeText
	call SaveEndBattleTextPointers
	ld a, $7
	ld [wGymLeaderNo], a
	jp CinnabarGymStartBattleScript

.PreBattleText:
	text_far_end _CinnabarGymBlainePreBattleText

.ReceivedVolcanoBadgeText:
	text_far_end _CinnabarGymBlaineReceivedVolcanoBadgeText

.PostBattleAdviceText:
	text_far_end _CinnabarGymBlainePostBattleAdviceText

.moltresText
	text_far_end _CinnabarGymBlaineMoltres


CinnabarGymBlaineVolcanoBadgeInfoText:
	text_far_end _CinnabarGymBlaineVolcanoBadgeInfoText

CinnabarGymBlaineReceivedTM38Text:
	text_far _GenericPlayerReceivedTextSFX1
	text_far_end _CinnabarGymBlaineTM38ExplanationText

CinnabarGymBlaineTM38NoRoomText:
	text_far_end _CinnabarGymBlaineTM38NoRoomText

CinnabarGymSuperNerd1:
	text_asm
	ld hl, CinnabarGymSuperNerd1TextPointers
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_0
	; fall through
CinnabarGymDefaultTrainerTextScript:
	ldh a, [hTextID]
	ld [wTrainerHeaderFlagBit], a
	ld de, 4
	jr nz, .defeated
	push hl
	push de
	rst _PrintText
	pop de
	pop hl
	add hl, de
	; hl = .EndBattleText
	ld d, h
	ld e, l
	call SaveEndBattleTextPointers
	jp CinnabarGymStartBattleScript
.defeated
	add hl, de
	add hl, de ; hl = .AfterBattleText
	rst _PrintText
	rst TextScriptEnd

CinnabarGymBurglar1:
	text_asm
	ld hl, CinnabarGymBurglar1TextPointers
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_1
	jr CinnabarGymDefaultTrainerTextScript

CinnabarGymSuperNerd2:
	text_asm
	ld hl, CinnabarGymSuperNerd2TextPointers
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_2
	jr CinnabarGymDefaultTrainerTextScript

CinnabarGymBurglar2:
	text_asm
	ld hl, CinnabarGymBurglar2TextPointers
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_3
	jr CinnabarGymDefaultTrainerTextScript

CinnabarGymFirefighter1:
	text_asm
	ld hl, CinnabarGymFirefighter1TextPointers
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_4
	jr CinnabarGymDefaultTrainerTextScript

CinnabarGymBurglar3:
	text_asm
	ld hl, CinnabarGymBurglar3TextPointers
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_5
	jr CinnabarGymDefaultTrainerTextScript

CinnabarGymFirefighter2:
	text_asm
	ld hl, CinnabarGymFirefighter2TextPointers
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_6
	jr CinnabarGymDefaultTrainerTextScript

CinnabarGymSuperNerd1TextPointers:
.BattleText:
	text_far_end _CinnabarGymSuperNerd1BattleText
.EndBattleText:
	text_far_end _CinnabarGymSuperNerd1EndBattleText
.AfterBattleText:
	text_far_end _CinnabarGymSuperNerd1AfterBattleText

CinnabarGymBurglar1TextPointers:
.BattleText:
	text_far_end _CinnabarGymBurglar1BattleText
.EndBattleText:
	text_far_end _CinnabarGymBurglar1EndBattleText
.AfterBattleText:
	text_far_end _CinnabarGymBurglar1AfterBattleText

CinnabarGymSuperNerd2TextPointers:
.BattleText:
	text_far_end _CinnabarGymSuperNerd2BattleText
.EndBattleText:
	text_far_end _CinnabarGymSuperNerd2EndBattleText
.AfterBattleText:
	text_far_end _CinnabarGymSuperNerd2AfterBattleText

CinnabarGymBurglar2TextPointers:
.BattleText:
	text_far_end _CinnabarGymBurglar2BattleText
.EndBattleText:
	text_far_end _CinnabarGymBurglar2EndBattleText
.AfterBattleText:
	text_far_end _CinnabarGymBurglar2AfterBattleText

CinnabarGymFirefighter1TextPointers:
.BattleText:
	text_far_end _CinnabarGymFirefighter1BattleText
.EndBattleText:
	text_far_end _CinnabarGymFirefighter1EndBattleText
.AfterBattleText:
	text_far_end _CinnabarGymFirefighter1AfterBattleText

CinnabarGymBurglar3TextPointers:
.BattleText:
	text_far_end _CinnabarGymBurglar3BattleText
.EndBattleText:
	text_far_end _CinnabarGymBurglar3EndBattleText
.AfterBattleText:
	text_far_end _CinnabarGymBurglar3AfterBattleText

CinnabarGymFirefighter2TextPointers:
.BattleText:
	text_far_end _CinnabarGymFirefighter2BattleText
.EndBattleText:
	text_far_end _CinnabarGymFirefighter2EndBattleText
.AfterBattleText:
	text_far_end _CinnabarGymFirefighter2AfterBattleText

CinnabarGymGymGuideText: ; PureRGBnote: ADDED: gym guide gives you apex chips after beating the leader
	text_asm
	CheckEvent EVENT_BEAT_BLAINE
	ld hl, ChampInMakingText
	jr z, .printDone
.afterBeat
	CheckEvent EVENT_GOT_PEWTER_APEX_CHIPS ; have to hear about apex chips to receive them after that
	ld hl, CinnabarGymGuidePostBattleText
	jr z, .printDone
	rst _PrintText
	call DisplayTextPromptButton
	CheckEvent EVENT_GOT_CINNABAR_APEX_CHIPS
	jr nz, .alreadyApexChips
.giveApexChips
	ld hl, GymGuideMoreApexChipText7
	rst _PrintText
	lb bc, APEX_CHIP, 2
	call GiveItem
	ld hl, ApexNoRoomText7
	jr nc, .printDone
	ld hl, ReceivedApexChipsText7
	rst _PrintText
	ld hl, CinnabarGymGuideApexChipFireText
	rst _PrintText
	SetEvent EVENT_GOT_CINNABAR_APEX_CHIPS
.alreadyApexChips
	ld hl, AlreadyReceivedApexChipsText7
.printDone
	rst _PrintText
	rst TextScriptEnd

ReceivedApexChipsText7:
	text_far_end _ReceivedApexChipsText

ApexNoRoomText7:
	text_far_end _PewterGymTM34NoRoomText

GymGuideMoreApexChipText7:
	text_far_end _GymGuideMoreApexChipText

AlreadyReceivedApexChipsText7:
	text_far_end _AlreadyReceivedApexChipsText

CinnabarGymGuideApexChipFireText:
	text_far_end _CinnabarGymGuideApexChipFireText

ChampInMakingText:
	text_far _GymGuideChampInMakingText
	text_far_end _CinnabarGymGymGuideChampInMakingText

CinnabarGymGuidePostBattleText:
	text_far_end _CinnabarGymGymGuideBeatBlaineText

PrintCinnabarQuiz::
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	call EnableAutoTextBoxDrawing
	ld a, TEXT_CINNABARGYM_QUIZ
	ldh [hTextID], a
	jp DisplayTextID

CinnabarGymQuiz::
	text_asm
	xor a
	ld [wOpponentAfterWrongAnswer], a
	ld a, [wHiddenEventFunctionArgument]
	push af
	and $f
	ldh [hGymGateIndex], a
	pop af
	and $f0
	swap a
	ldh [hGymGateAnswer], a
	CheckEvent EVENT_SAW_CINNABAR_GYM_QUIZ_INTRO ; PureRGBnote: FIXED: Only show the long intro text once because it's annoying to see it repeatedly
	jr nz, .skipIntro
	ld hl, CinnabarGymQuizIntroText
	rst _PrintText
	SetEvent EVENT_SAW_CINNABAR_GYM_QUIZ_INTRO
	jr .doneIntro
.skipIntro
	ld hl, CinnabarGymQuizStartText
	rst _PrintText
.doneIntro
	ldh a, [hGymGateIndex]
	dec a
	ld hl, CinnabarQuizQuestions
	ld bc, 4
	call AddNTimes
	rst _PrintText
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call CinnabarGymQuiz_AskQuestion
	rst TextScriptEnd

CinnabarGymQuizStartText:
	text_far_end _CinnabarGymQuizStartText

CinnabarGymQuizIntroText:
	text_far_end _CinnabarGymQuizIntroText

CinnabarQuizQuestions:
CinnabarQuizQuestionsText1:
	text_far_end _CinnabarQuizQuestionsText1
CinnabarQuizQuestionsText2:
	text_far_end _CinnabarQuizQuestionsText2
CinnabarQuizQuestionsText3:
	text_far_end _CinnabarQuizQuestionsText3
CinnabarQuizQuestionsText4:
	text_far_end _CinnabarQuizQuestionsText4
CinnabarQuizQuestionsText5:
	text_far_end _CinnabarQuizQuestionsText5
CinnabarQuizQuestionsText6:
	text_far_end _CinnabarQuizQuestionsText6

CinnabarGymGateFlagAction:
	EventFlagAddress hl, EVENT_CINNABAR_GYM_GATE0_UNLOCKED
	jp FlagAction

CinnabarGymQuiz_AskQuestion:
	call YesNoChoice
	ldh a, [hGymGateAnswer]
	ld c, a
	ld a, [wCurrentMenuItem]
	cp c
	jr nz, .wrongAnswer
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	ldh a, [hGymGateIndex]
	ldh [hBackupGymGateIndex], a
	ld hl, CinnabarGymQuizCorrectText
	rst _PrintText
	ldh a, [hBackupGymGateIndex]
	AdjustEventBit EVENT_CINNABAR_GYM_GATE0_UNLOCKED, 0
	ld c, a
	ld b, FLAG_SET
	call CinnabarGymGateFlagAction
	jp UpdateCinnabarGymGateTileBlocks
.wrongAnswer
	call WaitForSoundToFinish
	ld a, SFX_DENIED
	rst _PlaySound
	call WaitForSoundToFinish
	ld hl, CinnabarGymQuizIncorrectText
	rst _PrintText
	ldh a, [hGymGateIndex]
	add $2
	AdjustEventBit EVENT_BEAT_CINNABAR_GYM_TRAINER_0, 2
	ld c, a
	ld b, FLAG_TEST
	EventFlagAddress hl, EVENT_BEAT_CINNABAR_GYM_TRAINER_0
	call FlagAction
	ret nz
	ldh a, [hGymGateIndex]
	add $2
	ld [wOpponentAfterWrongAnswer], a
	ret

CinnabarGymQuizCorrectText:
	sound_get_item_1
	text_far _CinnabarGymQuizCorrectText
	text_promptbutton
	text_asm

	ldh a, [hBackupGymGateIndex]
	AdjustEventBit EVENT_CINNABAR_GYM_GATE0_UNLOCKED, 0
	ld c, a
	ld b, FLAG_TEST
	call CinnabarGymGateFlagAction
	ld a, c
	and a
	jr nz, .done
	call WaitForSoundToFinish
	ld a, SFX_GO_INSIDE
	rst _PlaySound
	call WaitForSoundToFinish
.done
	rst TextScriptEnd

CinnabarGymQuizIncorrectText:
	text_far_end _CinnabarGymQuizIncorrectText

UpdateCinnabarGymGateTileBlocks::
; Update the overworld map with open floor blocks or locked gate blocks
; depending on event flags.
	ld a, 6
	ldh [hGymGateIndex], a
.loop
	ldh a, [hGymGateIndex]
	dec a
	add a
	add a
	ld d, 0
	ld e, a
	ld hl, CinnabarGymGateCoords
	add hl, de
	ld a, [hli]
	ld b, [hl]
	ld c, a
	inc hl
	ld a, [hl]
	ld d, a
	push bc
	push de
	ldh a, [hGymGateIndex]
	ldh [hBackupGymGateIndex], a
	AdjustEventBit EVENT_CINNABAR_GYM_GATE0_UNLOCKED, 0
	ld c, a
	ld b, FLAG_TEST
	call CinnabarGymGateFlagAction
	pop de
	ld a, c
	and a
	ld a, $e
	jr nz, .next
	ld a, d ; gym gate tile block
.next
	pop bc
	ld [wNewTileBlockID], a
	call ReplaceTileBlock
	ld hl, hGymGateIndex
	dec [hl]
	jr nz, .loop
	ret

MACRO gym_gate_coord
	db \1, \2, \3, 0
ENDM

DEF HORIZONTAL_GATE_BLOCK EQU $54
DEF VERTICAL_GATE_BLOCK   EQU $5f

CinnabarGymGateCoords:
	; x coord, y coord, block id
	gym_gate_coord 9, 3, HORIZONTAL_GATE_BLOCK
	gym_gate_coord 6, 3, HORIZONTAL_GATE_BLOCK
	gym_gate_coord 6, 6, HORIZONTAL_GATE_BLOCK
	gym_gate_coord 3, 8, VERTICAL_GATE_BLOCK
	gym_gate_coord 2, 6, HORIZONTAL_GATE_BLOCK
	gym_gate_coord 2, 3, HORIZONTAL_GATE_BLOCK
