CeruleanGym_Script:
	ld hl, CeruleanGymTrainerHeaders
	ld de, CeruleanGym_ScriptPointers
	ld bc, wCeruleanGymCurScript
	jp ExecuteCustomMapScriptInTable

CeruleanGym_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_CERULEANGYM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_CERULEANGYM_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_CERULEANGYM_END_BATTLE
	dw_const CeruleanGymMistyPostBattleScript,      SCRIPT_CERULEANGYM_MISTY_POST_BATTLE

CeruleanGymResetScripts:
	call ResetMapScripts
	ld [wCeruleanGymCurScript], a ; SCRIPT_CERULEANGYM_DEFAULT
	ret

CeruleanGymMistyPostBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jr z, CeruleanGymResetScripts
	call DisableDpad

CeruleanGymReceiveTM11:
	ld d, CERULEANGYM_MISTY
	callfar MakeSpriteFacePlayer
	ld a, TEXT_CERULEANGYM_MISTY_CASCADE_BADGE_INFO
	call .runTextScript
	SetEvent EVENT_BEAT_MISTY
	lb bc, TM_MISTY, 1
	call GiveItem
	jr nc, .BagFull
	ld a, TEXT_CERULEANGYM_MISTY_RECEIVED_TM11
	call .runTextScript
	SetEvent EVENT_GOT_TM11
	jr .gymVictory
.BagFull
	ld a, TEXT_CERULEANGYM_MISTY_TM11_NO_ROOM
	call .runTextScript
.gymVictory
	ld hl, wObtainedBadges
	set BIT_CASCADEBADGE, [hl]

	; deactivate gym trainers
	SetEvents EVENT_BEAT_CERULEAN_GYM_TRAINER_0, EVENT_BEAT_CERULEAN_GYM_TRAINER_1
	
	ld a, CERULEANGYM_MISTY
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	jr CeruleanGymResetScripts
.runTextScript
	ldh [hTextID], a
	jp DisplayTextID

CeruleanGym_TextPointers:
	def_text_pointers
	dba_const CeruleanGymMistyText,                  TEXT_CERULEANGYM_MISTY
	dba_const CeruleanGymCooltrainerFText,           TEXT_CERULEANGYM_COOLTRAINER_F
	dba_const CeruleanGymSwimmerText,                TEXT_CERULEANGYM_SWIMMER
	dba_const CeruleanGymGymGuideText,               TEXT_CERULEANGYM_GYM_GUIDE
	dba_const _CeruleanGymMistyCascadeBadgeInfoText, TEXT_CERULEANGYM_MISTY_CASCADE_BADGE_INFO
	dba_const _GenericPlayerReceivedTextSFX1,        TEXT_CERULEANGYM_MISTY_RECEIVED_TM11
	dba_const _CeruleanGymMistyTM11NoRoomText,       TEXT_CERULEANGYM_MISTY_TM11_NO_ROOM

CeruleanGymTrainerHeaders:
	def_trainers 2
CeruleanGymTrainerHeader0:
	trainer EVENT_BEAT_CERULEAN_GYM_TRAINER_0, 3, _CeruleanGymBattleText1, _CeruleanGymEndBattleText1, _CeruleanGymAfterBattleText1
CeruleanGymTrainerHeader1:
	trainer EVENT_BEAT_CERULEAN_GYM_TRAINER_1, 3, _CeruleanGymBattleText2, _CeruleanGymEndBattleText2, _CeruleanGymAfterBattleText2
	db -1 ; end

CeruleanGymMistyText:
	text_asm
	CheckEvent EVENT_BEAT_MISTY
	jr z, .beforeBeat
	CheckEventReuseA EVENT_GOT_TM11
	jr nz, .afterBeat
	call z, CeruleanGymReceiveTM11
	call DisableWaitingAfterTextDisplay
	rst TextScriptEnd
.afterBeat
	ld hl, .TM11ExplanationText
	rst _PrintText
	rst TextScriptEnd
.beforeBeat
	ld hl, .PreBattleText
	rst _PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, CeruleanGymMistyReceivedCascadeBadgeText
	ld de, CeruleanGymMistyReceivedCascadeBadgeText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $2
	ld [wGymLeaderNo], a
	xor a
	ldh [hJoyHeld], a
	ld a, SCRIPT_CERULEANGYM_MISTY_POST_BATTLE
	ld [wCeruleanGymCurScript], a
	rst TextScriptEnd

.PreBattleText:
	text_far_end _CeruleanGymMistyPreBattleText

.TM11ExplanationText:
	text_far_end _CeruleanGymMistyTM11ExplanationText

CeruleanGymMistyReceivedCascadeBadgeText:
	text_far _CeruleanGymMistyReceivedCascadeBadgeText
	sound_get_key_item ; actually plays the second channel of SFX_BALL_POOF due to the wrong music bank being loaded
	text_promptbutton
	text_end

CeruleanGymCooltrainerFText:
	script_trainer CeruleanGymTrainerHeader0

CeruleanGymSwimmerText:
	script_trainer CeruleanGymTrainerHeader1

CeruleanGymGymGuideText: ; PureRGBnote: ADDED: gym guide gives you apex chips after beating the leader
	text_asm
	CheckEvent EVENT_BEAT_MISTY
	ld hl, CeruleanGymChampInMakingText
	jr z, .printDone
.afterBeat
	CheckEvent EVENT_GOT_PEWTER_APEX_CHIPS ; have to hear about apex chips to receive them after that
	ld hl, CeruleanGymBeatMistyText
	jr z, .printDone
	rst _PrintText
	call DisplayTextPromptButton
	CheckEvent EVENT_GOT_CERULEAN_APEX_CHIPS
	jr nz, .alreadyChips
.giveApexChips
	ld hl, GymGuideMoreApexChipText2
	rst _PrintText
	lb bc, APEX_CHIP, 2
	call GiveItem
	ld hl, ApexNoRoomText2
	jr nc, .printDone
	ld hl, ReceivedApexChipsText
	rst _PrintText
	ld hl, CeruleanGymGuideApexChipWaterText
	rst _PrintText
	SetEvent EVENT_GOT_CERULEAN_APEX_CHIPS
.alreadyChips
	ld hl, AlreadyReceivedApexChipsText2
.printDone
	rst _PrintText
	rst TextScriptEnd

ReceivedApexChipsText:
	text_far_end _ReceivedApexChipsText

ApexNoRoomText2:
	text_far_end _PewterGymTM34NoRoomText

GymGuideMoreApexChipText2:
	text_far_end _GymGuideMoreApexChipText

AlreadyReceivedApexChipsText2:
	text_far_end _AlreadyReceivedApexChipsText

CeruleanGymChampInMakingText:
	text_far _GymGuideChampInMakingText
	text_far_end _CeruleanGymGymGuideChampInMakingText

CeruleanGymBeatMistyText:
	text_far_end _CeruleanGymGymGuideBeatMistyText

CeruleanGymGuideApexChipWaterText:
	text_far_end _CeruleanGymGuideApexChipWaterText
