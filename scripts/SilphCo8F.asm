; PureRGBnote: ADDED: card key will be consumed if all card key doors were opened in the game.

SilphCo8F_Script:
	call SilphCo8FGateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo8TrainerHeaders
	ld de, SilphCo8F_ScriptPointers
	ld a, [wSilphCo8FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo8FCurScript], a
	ret

SilphCo8FGateCallbackScript::
	call WasMapJustLoaded
	ret z
	ld hl, SilphCo8FGateCoords
	CheckEvent EVENT_SILPH_CO_8_UNLOCKED_DOOR
	jp UnlockSilphCoDoor

SilphCo8F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILPHCO8F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO8F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO8F_END_BATTLE

SilphCo8F_TextPointers:
	def_text_pointers
	dw_const SilphCo8FSilphWorkerMText, TEXT_SILPHCO8F_SILPH_WORKER_M
	dw_const SilphCo8FRocket1Text,      TEXT_SILPHCO8F_ROCKET1
	dw_const SilphCo8FScientistText,    TEXT_SILPHCO8F_SCIENTIST
	dw_const SilphCo8FRocket2Text,      TEXT_SILPHCO8F_ROCKET2

SilphCo8TrainerHeaders:
	def_trainers 2
SilphCo8TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_8F_TRAINER_0, 4, SilphCo8FRocket1BattleText, SilphCo8FRocket1EndBattleText, SilphCo8FRocket1AfterBattleText
SilphCo8TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_8F_TRAINER_1, 4, SilphCo8FScientistBattleText, SilphCo8FScientistEndBattleText, SilphCo8FScientistAfterBattleText
SilphCo8TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_8F_TRAINER_2, 4, SilphCo8FRocket2BattleText, SilphCo8FRocket2EndBattleText, SilphCo8FRocket2AfterBattleText
	db -1 ; end

SilphCo8FSilphWorkerMText:
	text_asm
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ld hl, .ThanksForSavingUsText
	jr nz, .beat_giovanni
	ld hl, .SilphIsFinishedText
.beat_giovanni
	rst _PrintText
	rst TextScriptEnd

.SilphIsFinishedText:
	text_far _SilphCo8FSilphWorkerMSilphIsFinishedText
	text_end

.ThanksForSavingUsText:
	text_far _SilphCo8FSilphWorkerMThanksForSavingUsText
	text_end

SilphCo8FRocket1Text:
	text_asm
	ld hl, SilphCo8TrainerHeader0
SilphCo8FTalkToTrainer:
	call TalkToTrainer
	rst TextScriptEnd

SilphCo8FScientistText:
	text_asm
	ld hl, SilphCo8TrainerHeader1
	jr SilphCo8FTalkToTrainer

SilphCo8FRocket2Text:
	text_asm
	ld hl, SilphCo8TrainerHeader2
	jr SilphCo8FTalkToTrainer

SilphCo8FRocket1BattleText:
	text_far _SilphCo8FRocket1BattleText
	text_end

SilphCo8FRocket1EndBattleText:
	text_far _SilphCo8FRocket1EndBattleText
	text_end

SilphCo8FRocket1AfterBattleText:
	text_far _SilphCo8FRocket1AfterBattleText
	text_end

SilphCo8FScientistBattleText:
	text_far _SilphCo8FScientistBattleText
	text_end

SilphCo8FScientistEndBattleText:
	text_far _SilphCo8FScientistEndBattleText
	text_end

SilphCo8FScientistAfterBattleText:
	text_far _SilphCo8FScientistAfterBattleText
	text_end

SilphCo8FRocket2BattleText:
	text_far _SilphCo8FRocket2BattleText
	text_end

SilphCo8FRocket2EndBattleText:
	text_far _SilphCo8FRocket2EndBattleText
	text_end

SilphCo8FRocket2AfterBattleText:
	text_far _SilphCo8FRocket2AfterBattleText
	text_end
