FuchsiaGym_Script:
	ld hl, FuchsiaGymTrainerHeaders
	ld de, FuchsiaGym_ScriptPointers
	ld bc, wFuchsiaGymCurScript
	jp ExecuteCustomMapScriptInTable

FuchsiaGym_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_FUCHSIAGYM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_FUCHSIAGYM_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_FUCHSIAGYM_END_BATTLE
	dw_const FuchsiaGymKogaPostBattleScript,        SCRIPT_FUCHSIAGYM_KOGA_POST_BATTLE

FuchsiaGymResetScripts:
	call ResetMapScripts
	; a = 0 from ResetMapScripts
	ld [wFuchsiaGymCurScript], a ; SCRIPT_FUCHSIAGYM_DEFAULT
	ret

FuchsiaGymKogaPostBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jr z, FuchsiaGymResetScripts
	call DisableDpad
; fallthrough
FuchsiaGymReceiveTM06:
	ld d, FUCHSIAGYM_KOGA
	callfar MakeSpriteFacePlayer
	ld a, TEXT_FUCHSIAGYM_KOGA_SOUL_BADGE_INFO
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_KOGA
	lb bc, TM_KOGA, 1
	call GiveItem
	jr nc, .BagFull
	ld a, TEXT_FUCHSIAGYM_KOGA_RECEIVED_TM06
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM06
	jr .gymVictory
.BagFull
	ld a, TEXT_FUCHSIAGYM_KOGA_TM06_NO_ROOM
	ldh [hTextID], a
	call DisplayTextID
.gymVictory
	ld hl, wObtainedBadges
	set BIT_SOULBADGE, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_FUCHSIA_GYM_TRAINER_0, EVENT_BEAT_FUCHSIA_GYM_TRAINER_5

	ld a, FUCHSIAGYM_KOGA
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	jr FuchsiaGymResetScripts

FuchsiaGym_TextPointers:
	def_text_pointers
	dba_const FuchsiaGymKogaText,              TEXT_FUCHSIAGYM_KOGA
	dba_const FuchsiaGymJuggler1Text,          TEXT_FUCHSIAGYM_JUGGLER1
	dba_const FuchsiaGymJuggler2Text,          TEXT_FUCHSIAGYM_JUGGLER2
	dba_const FuchsiaGymJuggler3Text,          TEXT_FUCHSIAGYM_JUGGLER3
	dba_const FuchsiaGymTamer1Text,            TEXT_FUCHSIAGYM_TAMER1
	dba_const FuchsiaGymTamer2Text,            TEXT_FUCHSIAGYM_TAMER2
	dba_const FuchsiaGymJuggler4Text,          TEXT_FUCHSIAGYM_JUGGLER4
	dba_const FuchsiaGymGymGuideText,          TEXT_FUCHSIAGYM_GYM_GUIDE
	dba_const FuchsiaGymKogaSoulBadgeInfoText, TEXT_FUCHSIAGYM_KOGA_SOUL_BADGE_INFO
	dba_const FuchsiaGymKogaReceivedTM06Text,  TEXT_FUCHSIAGYM_KOGA_RECEIVED_TM06
	dba_const FuchsiaGymKogaTM06NoRoomText,    TEXT_FUCHSIAGYM_KOGA_TM06_NO_ROOM

FuchsiaGymTrainerHeaders:
	def_trainers 2
FuchsiaGymTrainerHeader0:
	trainer EVENT_BEAT_FUCHSIA_GYM_TRAINER_0, 2, _FuchsiaGymJuggler1BattleText, _FuchsiaGymJuggler1EndBattleText, _FuchsiaGymJuggler1AfterBattleText
FuchsiaGymTrainerHeader1:
	trainer EVENT_BEAT_FUCHSIA_GYM_TRAINER_1, 2, _FuchsiaGymJuggler2BattleText, _FuchsiaGymJuggler2EndBattleText, _FuchsiaGymJuggler2AfterBattleText
FuchsiaGymTrainerHeader2:
	trainer EVENT_BEAT_FUCHSIA_GYM_TRAINER_2, 4, _FuchsiaGymJuggler3BattleText, _FuchsiaGymJuggler3EndBattleText, _FuchsiaGymJuggler3AfterBattleText
FuchsiaGymTrainerHeader3:
	trainer EVENT_BEAT_FUCHSIA_GYM_TRAINER_3, 2, _FuchsiaGymTamer1BattleText, _FuchsiaGymTamer1EndBattleText, FuchsiaGymTamer1AfterBattleText
FuchsiaGymTrainerHeader4:
	trainer EVENT_BEAT_FUCHSIA_GYM_TRAINER_4, 2, _FuchsiaGymTamer2BattleText, _FuchsiaGymTamer2EndBattleText, _FuchsiaGymTamer2AfterBattleText
FuchsiaGymTrainerHeader5:
	trainer EVENT_BEAT_FUCHSIA_GYM_TRAINER_5, 2, _FuchsiaGymJuggler4BattleText, _FuchsiaGymJuggler4EndBattleText, _FuchsiaGymJuggler4AfterBattleText
	db -1 ; end

FuchsiaGymKogaText:
	text_asm
	CheckEvent EVENT_BEAT_KOGA
	jr z, .beforeBeat
	CheckEventReuseA EVENT_GOT_TM06
	jr nz, .afterBeat
	call z, FuchsiaGymReceiveTM06
	call DisableWaitingAfterTextDisplay
	rst TextScriptEnd
.afterBeat
	ld hl, .PostBattleAdviceText
	rst _PrintText
	rst TextScriptEnd
.beforeBeat
	ld hl, .BeforeBattleText
	rst _PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, .ReceivedSoulBadgeText
	ld de, .ReceivedSoulBadgeText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $5
	ld [wGymLeaderNo], a
	xor a
	ldh [hJoyHeld], a
	ld a, SCRIPT_FUCHSIAGYM_KOGA_POST_BATTLE
	ld [wFuchsiaGymCurScript], a
	rst TextScriptEnd

.BeforeBattleText:
	text_far_end _FuchsiaGymKogaBeforeBattleText

.ReceivedSoulBadgeText:
	text_far_end _FuchsiaGymKogaReceivedSoulBadgeText

.PostBattleAdviceText:
	text_far_end _FuchsiaGymKogaPostBattleAdviceText

FuchsiaGymKogaSoulBadgeInfoText:
	text_far_end _FuchsiaGymKogaSoulBadgeInfoText

FuchsiaGymKogaReceivedTM06Text:
	text_far _FuchsiaGymKogaReceivedTM06Text
	sound_get_key_item
	text_far_end _FuchsiaGymKogaTM06ExplanationText

FuchsiaGymKogaTM06NoRoomText:
	text_far_end _FuchsiaGymKogaTM06NoRoomText

FuchsiaGymJuggler1Text:
	script_trainer FuchsiaGymTrainerHeader0

FuchsiaGymJuggler2Text:
	script_trainer FuchsiaGymTrainerHeader1

FuchsiaGymJuggler3Text:
	script_trainer FuchsiaGymTrainerHeader2

FuchsiaGymTamer1Text:
	script_trainer FuchsiaGymTrainerHeader3

FuchsiaGymTamer2Text:
	script_trainer FuchsiaGymTrainerHeader4

FuchsiaGymJuggler4Text:
	script_trainer FuchsiaGymTrainerHeader5

FuchsiaGymTamer1AfterBattleText:
	text_asm
	CheckEvent EVENT_BEAT_KOGA
	ld hl, .beforeBeat
	ret z
	ld hl, .afterBeat
	ret
.afterBeat
	text_far_end _FuchsiaGymTamer1AfterBattleGymDefeatedText
.beforeBeat
	text_far_end _FuchsiaGymTamer1AfterBattleText

FuchsiaGymGymGuideText: ; PureRGBnote: ADDED: gym guide gives you apex chips after beating the leader
	text_asm
	CheckEvent EVENT_BEAT_KOGA
	ld hl, FuchsiaGymChampInMakingText
	jr z, .printDone
.afterBeat
	CheckEvent EVENT_GOT_PEWTER_APEX_CHIPS ; have to hear about apex chips to receive them after that
	ld hl, FuchsiaGymGuidePostBattleText
	jr z, .printDone
	rst _PrintText
	call DisplayTextPromptButton
	CheckEvent EVENT_GOT_FUCHSIA_APEX_CHIPS
	jr nz, .alreadyApexChips
.giveApexChips
	ld hl, GymGuideMoreApexChipText5
	rst _PrintText
	lb bc, APEX_CHIP, 2
	call GiveItem
	ld hl, ApexNoRoomText5
	jr nc, .printDone
	ld hl, ReceivedApexChipsText5
	rst _PrintText
	ld hl, FuchsiaGymGuideApexChipPoisonText
	rst _PrintText
	SetEvent EVENT_GOT_FUCHSIA_APEX_CHIPS
.alreadyApexChips
	ld hl, AlreadyReceivedApexChipsText5
.printDone
	rst _PrintText
	rst TextScriptEnd

ReceivedApexChipsText5:
	text_far_end _ReceivedApexChipsText

ApexNoRoomText5:
	text_far_end _PewterGymTM34NoRoomText

GymGuideMoreApexChipText5:
	text_far_end _GymGuideMoreApexChipText

AlreadyReceivedApexChipsText5:
	text_far_end _AlreadyReceivedApexChipsText

FuchsiaGymChampInMakingText:
	text_far _GymGuideChampInMakingText
	text_far_end _FuchsiaGymGymGuideChampInMakingText

FuchsiaGymGuidePostBattleText:
	text_far_end _FuchsiaGymGymGuideBeatKogaText

FuchsiaGymGuideApexChipPoisonText:
	text_far_end _FuchsiaGymGuideApexChipPoisonText