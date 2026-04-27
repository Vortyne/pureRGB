; PureRGBnote: ADDED: card key will be consumed if all card key doors were opened in the game.

SilphCo2F_Script:
	call SilphCo2FGateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo2TrainerHeaders
	ld de, SilphCo2F_ScriptPointers
	ld a, [wSilphCo2FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo2FCurScript], a
	ret

SilphCo2FGateCallbackScript::
	call WasMapJustLoaded
	ret z
	ld hl, SilphCo2FGateCoords
	CheckEvent EVENT_SILPH_CO_2_UNLOCKED_DOOR1
	call UnlockSilphCoDoor
	CheckEvent EVENT_SILPH_CO_2_UNLOCKED_DOOR2
	; fall though
UnlockSilphCoDoor::
	jr nz, .skip
	ld b, [hl]
	inc hl
	ld c, [hl]
	inc hl
	ld a, [hli]
	ld [wNewTileBlockID], a
	push hl
	predef ReplaceTileBlock
	pop hl
	ret
.skip
	inc hl
	inc hl
	inc hl
	ret

SilphCo2F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILPHCO2F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO2F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO2F_END_BATTLE

SilphCo2F_TextPointers:
	def_text_pointers
	dw_const SilphCo2FSilphWorkerFText, TEXT_SILPHCO2F_SILPH_WORKER_F
	dw_const SilphCo2FScientist1Text,   TEXT_SILPHCO2F_SCIENTIST1
	dw_const SilphCo2FScientist2Text,   TEXT_SILPHCO2F_SCIENTIST2
	dw_const SilphCo2FRocket1Text,      TEXT_SILPHCO2F_ROCKET1
	dw_const SilphCo2FRocket2Text,      TEXT_SILPHCO2F_ROCKET2

SilphCo2TrainerHeaders:
	def_trainers 2
SilphCo2TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_2F_TRAINER_0, 3, SilphCo2FScientist1BattleText, SilphCo2FScientist1EndBattleText, SilphCo2FScientist1AfterBattleText
SilphCo2TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_2F_TRAINER_1, 4, SilphCo2FScientist2BattleText, SilphCo2FScientist2EndBattleText, SilphCo2FScientist2AfterBattleText
SilphCo2TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_2F_TRAINER_2, 3, SilphCo2FRocket1BattleText, SilphCo2FRocket1EndBattleText, SilphCo2FRocket1AfterBattleText
SilphCo2TrainerHeader3:
	trainer EVENT_BEAT_SILPH_CO_2F_TRAINER_3, 3, SilphCo2FRocket2BattleText, SilphCo2FRocket2EndBattleText, SilphCo2FRocket2AfterBattleText
	db -1 ; end

SilphCo2FSilphWorkerFText:
	text_asm
	CheckEvent EVENT_GOT_TM50
	jr nz, .already_have_tm
	ld hl, .PleaseTakeThisText
	rst _PrintText
	lb bc, TM_SILPH_CO_2F_HIDING_LADY, 1
	call GiveItem
	ld hl, .TM50NoRoomText
	jr nc, .print_text
	SetEvent EVENT_GOT_TM50
	ld hl, .ReceivedTM50Text
	jr .print_text
.already_have_tm
	ld hl, .TM50ExplanationText
.print_text
	rst _PrintText
	rst TextScriptEnd

.PleaseTakeThisText:
	text_far SilphCo2FSilphWorkerFPleaseTakeThisText
	text_end

.ReceivedTM50Text:
	text_far _SilphCo2FSilphWorkerFReceivedTM50Text
	sound_get_item_1
	text_end

.TM50ExplanationText:
	text_far _SilphCo2FSilphWorkerFTM50ExplanationText
	text_end

.TM50NoRoomText:
	text_far _SilphCo2FSilphWorkerFTM50NoRoomText
	text_end

SilphCo2FScientist1Text:
	text_asm
	ld hl, SilphCo2TrainerHeader0
SilphCo2FTalkToTrainer:
	call TalkToTrainer
	rst TextScriptEnd

SilphCo2FScientist2Text:
	text_asm
	ld hl, SilphCo2TrainerHeader1
	jr SilphCo2FTalkToTrainer

SilphCo2FRocket1Text:
	text_asm
	ld hl, SilphCo2TrainerHeader2
	jr SilphCo2FTalkToTrainer

SilphCo2FRocket2Text:
	text_asm
	ld hl, SilphCo2TrainerHeader3
	jr SilphCo2FTalkToTrainer

SilphCo2FScientist1BattleText:
	text_far _SilphCo2FScientist1BattleText
	text_end

SilphCo2FScientist1EndBattleText:
	text_far _SilphCo2FScientist1EndBattleText
	text_end

SilphCo2FScientist1AfterBattleText:
	text_far _SilphCo2FScientist1AfterBattleText
	text_end

SilphCo2FScientist2BattleText:
	text_far _SilphCo2FScientist2BattleText
	text_end

SilphCo2FScientist2EndBattleText:
	text_far _SilphCo2FScientist2EndBattleText
	text_end

SilphCo2FScientist2AfterBattleText:
	text_far _SilphCo2FScientist2AfterBattleText
	text_end

SilphCo2FRocket1BattleText:
	text_far _SilphCo2FRocket1BattleText
	text_end

SilphCo2FRocket1EndBattleText:
	text_far _SilphCo2FRocket1EndBattleText
	text_end

SilphCo2FRocket1AfterBattleText:
	text_far _SilphCo2FRocket1AfterBattleText
	text_end

SilphCo2FRocket2BattleText:
	text_far _SilphCo2FRocket2BattleText
	text_end

SilphCo2FRocket2EndBattleText:
	text_far _SilphCo2FRocket2EndBattleText
	text_end

SilphCo2FRocket2AfterBattleText:
	text_far _SilphCo2FRocket2AfterBattleText
	text_end
