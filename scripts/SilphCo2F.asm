; PureRGBnote: ADDED: card key will be consumed if all card key doors were opened in the game.

SilphCo2F_Script:
	call SilphCo2FGateCallbackScript
	ld hl, SilphCo2TrainerHeaders
	ld de, SilphCo2F_ScriptPointers
	ld bc, wSilphCo2FCurScript
	jp ExecuteCustomMapScriptInTable

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
	call ReplaceTileBlock
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
	dba_const SilphCo2FSilphWorkerFText, TEXT_SILPHCO2F_SILPH_WORKER_F
	dba_const SilphCo2FScientist1Text,   TEXT_SILPHCO2F_SCIENTIST1
	dba_const SilphCo2FScientist2Text,   TEXT_SILPHCO2F_SCIENTIST2
	dba_const SilphCo2FRocket1Text,      TEXT_SILPHCO2F_ROCKET1
	dba_const SilphCo2FRocket2Text,      TEXT_SILPHCO2F_ROCKET2

SilphCo2TrainerHeaders:
	def_trainers 2
SilphCo2TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_2F_TRAINER_0, 3, _SilphCo2FScientist1BattleText, _SilphCo2FScientist1EndBattleText, _SilphCo2FScientist1AfterBattleText
SilphCo2TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_2F_TRAINER_1, 4, _SilphCo2FScientist2BattleText, _SilphCo2FScientist2EndBattleText, _SilphCo2FScientist2AfterBattleText
SilphCo2TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_2F_TRAINER_2, 3, _SilphCo2FRocket1BattleText, _SilphCo2FRocket1EndBattleText, _SilphCo2FRocket1AfterBattleText
SilphCo2TrainerHeader3:
	trainer EVENT_BEAT_SILPH_CO_2F_TRAINER_3, 3, _SilphCo2FRocket2BattleText, _SilphCo2FRocket2EndBattleText, _SilphCo2FRocket2AfterBattleText
	db -1 ; end

SilphCo2FScientist1Text:
	script_trainer SilphCo2TrainerHeader0

SilphCo2FScientist2Text:
	script_trainer SilphCo2TrainerHeader1

SilphCo2FRocket1Text:
	script_trainer SilphCo2TrainerHeader2

SilphCo2FRocket2Text:
	script_trainer SilphCo2TrainerHeader3

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
	text_far_end SilphCo2FSilphWorkerFPleaseTakeThisText

.ReceivedTM50Text:
	text_far_end _SilphCo2FSilphWorkerFReceivedTM50Text

.TM50ExplanationText:
	text_far_end _SilphCo2FSilphWorkerFTM50ExplanationText

.TM50NoRoomText:
	text_far_end _SilphCo2FSilphWorkerFTM50NoRoomText
