; PureRGBnote: ADDED: card key will be consumed if all card key doors were opened in the game.

SilphCo8F_Script:
	call SilphCo8FGateCallbackScript
	ld hl, SilphCo8TrainerHeaders
	ld de, SilphCo8F_ScriptPointers
	ld bc, wSilphCo8FCurScript
	jp ExecuteCustomMapScriptInTable

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
	dba_const SilphCo8FSilphWorkerMText, TEXT_SILPHCO8F_SILPH_WORKER_M
	dba_const SilphCo8FRocket1Text,      TEXT_SILPHCO8F_ROCKET1
	dba_const SilphCo8FScientistText,    TEXT_SILPHCO8F_SCIENTIST
	dba_const SilphCo8FRocket2Text,      TEXT_SILPHCO8F_ROCKET2

SilphCo8TrainerHeaders:
	def_trainers 2
SilphCo8TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_8F_TRAINER_0, 4, _SilphCo8FRocket1BattleText, _SilphCo8FRocket1EndBattleText, _SilphCo8FRocket1AfterBattleText
SilphCo8TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_8F_TRAINER_1, 4, _SilphCo8FScientistBattleText, _SilphCo8FScientistEndBattleText, _SilphCo8FScientistAfterBattleText
SilphCo8TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_8F_TRAINER_2, 4, _SilphCo8FRocket2BattleText, _SilphCo8FRocket2EndBattleText, _SilphCo8FRocket2AfterBattleText
	db -1 ; end

SilphCo8FRocket1Text:
	script_trainer SilphCo8TrainerHeader0

SilphCo8FScientistText:
	script_trainer SilphCo8TrainerHeader1

SilphCo8FRocket2Text:
	script_trainer SilphCo8TrainerHeader2

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
	text_far_end _SilphCo8FSilphWorkerMSilphIsFinishedText

.ThanksForSavingUsText:
	text_far_end _SilphCo8FSilphWorkerMThanksForSavingUsText
