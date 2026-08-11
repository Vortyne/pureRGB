SaffronGym_Script:
	ld hl, SaffronGymTrainerHeaders
	ld de, SaffronGym_ScriptPointers
	ld bc, wSaffronGymCurScript
	jp ExecuteCustomMapScriptInTable

SaffronGym_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SAFFRONGYM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SAFFRONGYM_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SAFFRONGYM_END_BATTLE
	dw_const SaffronGymSabrinaPostBattle,           SCRIPT_SAFFRONGYM_SABRINA_POST_BATTLE

SaffronGymResetScripts:
	call ResetMapScripts
	ld [wSaffronGymCurScript], a ; SCRIPT_SAFFRONGYM_DEFAULT
	ret

SaffronGymSabrinaPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jr z, SaffronGymResetScripts
	call DisableDpad

SaffronGymSabrinaReceiveTM46Script:
	ld d, SAFFRONGYM_SABRINA
	callfar MakeSpriteFacePlayer
	ld a, TEXT_SAFFRONGYM_SABRINA_MARSH_BADGE_INFO
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_SABRINA
	lb bc, TM_SABRINA, 1
	call GiveItem
	jr nc, .BagFull
	ld a, TEXT_SAFFRONGYM_SABRINA_RECEIVED_TM46
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM46
	jr .gymVictory
.BagFull
	ld a, TEXT_SAFFRONGYM_SABRINA_TM46_NO_ROOM
	ldh [hTextID], a
	call DisplayTextID
.gymVictory
	ld hl, wObtainedBadges
	set BIT_MARSHBADGE, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_SAFFRON_GYM_TRAINER_0, EVENT_BEAT_SAFFRON_GYM_TRAINER_6

	ld a, SAFFRONGYM_SABRINA
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	jr SaffronGymResetScripts

SaffronGym_TextPointers:
	def_text_pointers
	dba_const SaffronGymSabrinaText,               TEXT_SAFFRONGYM_SABRINA
	dba_const SaffronGymChanneler1Text,            TEXT_SAFFRONGYM_CHANNELER1
	dba_const SaffronGymYoungster1Text,            TEXT_SAFFRONGYM_YOUNGSTER1
	dba_const SaffronGymChanneler2Text,            TEXT_SAFFRONGYM_CHANNELER2
	dba_const SaffronGymYoungster2Text,            TEXT_SAFFRONGYM_YOUNGSTER2
	dba_const SaffronGymChanneler3Text,            TEXT_SAFFRONGYM_CHANNELER3
	dba_const SaffronGymYoungster3Text,            TEXT_SAFFRONGYM_YOUNGSTER3
	dba_const SaffronGymYoungster4Text,            TEXT_SAFFRONGYM_YOUNGSTER4
	dba_const SaffronGymGymGuideText,              TEXT_SAFFRONGYM_GYM_GUIDE
	dba_const _SaffronGymSabrinaMarshBadgeInfoText, TEXT_SAFFRONGYM_SABRINA_MARSH_BADGE_INFO
	dba_const SaffronGymSabrinaReceivedTM46Text,   TEXT_SAFFRONGYM_SABRINA_RECEIVED_TM46
	dba_const _SaffronGymSabrinaTM46NoRoomText,     TEXT_SAFFRONGYM_SABRINA_TM46_NO_ROOM

SaffronGymTrainerHeaders:
	def_trainers 2
SaffronGymTrainerHeader0:
	trainer EVENT_BEAT_SAFFRON_GYM_TRAINER_0, 3, _SaffronGymChanneler1BattleText, _SaffronGymChanneler1EndBattleText, _SaffronGymChanneler1AfterBattleText
SaffronGymTrainerHeader1:
	trainer EVENT_BEAT_SAFFRON_GYM_TRAINER_1, 3, _SaffronGymYoungster1BattleText, _SaffronGymYoungster1EndBattleText, SaffronGymYoungster1AfterBattleText
SaffronGymTrainerHeader2:
	trainer EVENT_BEAT_SAFFRON_GYM_TRAINER_2, 3, _SaffronGymChanneler2BattleText, _SaffronGymChanneler2EndBattleText, _SaffronGymChanneler2AfterBattleText
SaffronGymTrainerHeader3:
	trainer EVENT_BEAT_SAFFRON_GYM_TRAINER_3, 3, _SaffronGymYoungster2BattleText, _SaffronGymYoungster2EndBattleText, _SaffronGymYoungster2AfterBattleText
SaffronGymTrainerHeader4:
	trainer EVENT_BEAT_SAFFRON_GYM_TRAINER_4, 3, _SaffronGymChanneler3BattleText, _SaffronGymChanneler3EndBattleText, _SaffronGymChanneler3AfterBattleText
SaffronGymTrainerHeader5:
	trainer EVENT_BEAT_SAFFRON_GYM_TRAINER_5, 3, _SaffronGymYoungster3BattleText, _SaffronGymYoungster3EndBattleText, _SaffronGymYoungster3AfterBattleText
SaffronGymTrainerHeader6:
	trainer EVENT_BEAT_SAFFRON_GYM_TRAINER_6, 3, _SaffronGymYoungster4BattleText, _SaffronGymYoungster4EndBattleText, _SaffronGymYoungster4AfterBattleText
	db -1 ; end

SaffronGymSabrinaText:
	text_asm
	CheckEvent EVENT_BEAT_SABRINA
	jr z, .beforeBeat
	CheckEventReuseA EVENT_GOT_TM46
	jr nz, .afterBeat
	call z, SaffronGymSabrinaReceiveTM46Script
	call DisableWaitingAfterTextDisplay
	jr .done
.afterBeat
	ld hl, .PostBattleAdviceText
	rst _PrintText
	jr .done
.beforeBeat
	ld hl, .Text
	rst _PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, .ReceivedMarshBadgeText
	ld de, .ReceivedMarshBadgeText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $6
	ld [wGymLeaderNo], a
	ld a, SCRIPT_SAFFRONGYM_SABRINA_POST_BATTLE
	ld [wSaffronGymCurScript], a
.done
	rst TextScriptEnd

.Text:
	text_far_end _SaffronGymSabrinaText

.ReceivedMarshBadgeText:
	text_far_end _SaffronGymSabrinaReceivedMarshBadgeText

.PostBattleAdviceText:
	text_far_end _SaffronGymSabrinaPostBattleAdviceText

SaffronGymSabrinaReceivedTM46Text:
	text_far _GenericPlayerReceivedTextSFX1
	text_far_end _TM46ExplanationText

SaffronGymChanneler1Text:
	script_trainer SaffronGymTrainerHeader0

SaffronGymYoungster1Text:
	script_trainer SaffronGymTrainerHeader1

SaffronGymChanneler2Text:
	script_trainer SaffronGymTrainerHeader2

SaffronGymYoungster2Text:
	script_trainer SaffronGymTrainerHeader3

SaffronGymChanneler3Text:
	script_trainer SaffronGymTrainerHeader4

SaffronGymYoungster3Text:
	script_trainer SaffronGymTrainerHeader5

SaffronGymYoungster4Text:
	script_trainer SaffronGymTrainerHeader6

SaffronGymGymGuideText: ; PureRGBnote: ADDED: gym guide gives you apex chips after beating the leader
	text_asm
	CheckEvent EVENT_BEAT_SABRINA
	ld hl, SaffronGymGuideChampInMakingText
	jr z, .printDone
.afterBeat
	CheckEvent EVENT_GOT_PEWTER_APEX_CHIPS ; have to hear about apex chips to receive them after that
	ld hl, SaffronGymGuideBeatSabrinaText
	jr z, .printDone
	rst _PrintText
	call DisplayTextPromptButton
	CheckEvent EVENT_GOT_SAFFRON_APEX_CHIPS
	jr nz, .alreadyApexChips
.giveApexChips
	ld hl, GymGuideMoreApexChipText6
	rst _PrintText
	lb bc, APEX_CHIP, 2
	call GiveItem
	ld hl, ApexNoRoomText6
	jr nc, .printDone
	ld hl, ReceivedApexChipsText6
	rst _PrintText
	ld hl, SaffronGymGuideApexChipPsychicText
	rst _PrintText
	SetEvent EVENT_GOT_SAFFRON_APEX_CHIPS
.alreadyApexChips
	ld hl, AlreadyReceivedApexChipsText6
.printDone
	rst _PrintText
	rst TextScriptEnd

ReceivedApexChipsText6:
	text_far_end _ReceivedApexChipsText

ApexNoRoomText6:
	text_far_end _PewterGymTM34NoRoomText

GymGuideMoreApexChipText6:
	text_far_end _GymGuideMoreApexChipText

AlreadyReceivedApexChipsText6:
	text_far_end _AlreadyReceivedApexChipsText

SaffronGymGuideApexChipPsychicText:
	text_far_end _SaffronGymGuideApexChipPsychicText

SaffronGymGuideChampInMakingText:
	text_far _GymGuideChampInMakingText
	text_far_end _SaffronGymGuideChampInMakingText

SaffronGymGuideBeatSabrinaText:
	text_far_end _SaffronGymGuideBeatSabrinaText

; PureRGBnote: CHANGED: this trainer will change how they respond now based on your type matchup settings
SaffronGymYoungster1AfterBattleText:
	text_asm
	ld a, [wOptions3]
	bit BIT_GHOST_PSYCHIC, a
	ld hl, .onlyBugText
	jr nz, .print
	ld hl, .bugAndGhostText
.print
	rst _PrintText
	rst TextScriptEnd
.onlyBugText
	text_far _SaffronGymYoungster1AfterBattleText
	text_far_end _ExclamationPointText
.bugAndGhostText
	text_far _SaffronGymYoungster1AfterBattleText
	text_promptbutton
	text_far_end _SaffronGymYoungster1AfterBattleText3
