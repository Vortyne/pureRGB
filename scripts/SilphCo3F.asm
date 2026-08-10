; PureRGBnote: ADDED: card key will be consumed if all card key doors were opened in the game.

SilphCo3F_Script:
	call SilphCo3FGateCallbackScript
	ld hl, SilphCo3TrainerHeaders
	ld de, SilphCo3F_ScriptPointers
	ld bc, wSilphCo3FCurScript
	jp ExecuteCustomMapScriptInTable

SilphCo3FGateCallbackScript::
	call WasMapJustLoaded
	ret z
	ld hl, SilphCo3FGateCoords
	CheckEvent EVENT_SILPH_CO_3_UNLOCKED_DOOR1
	call UnlockSilphCoDoor
	CheckEvent EVENT_SILPH_CO_3_UNLOCKED_DOOR2
	jp UnlockSilphCoDoor

SilphCo3F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILPHCO3F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO3F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO3F_END_BATTLE

SilphCo3F_TextPointers:
	def_text_pointers
	dba_const SilphCo3FSilphWorkerMText, TEXT_SILPHCO3F_SILPH_WORKER_M
	dba_const SilphCo3FRocketText,       TEXT_SILPHCO3F_ROCKET
	dba_const SilphCo3FScientistText,    TEXT_SILPHCO3F_SCIENTIST
	dba_const PickUp3ItemText,           TEXT_SILPHCO3F_ITEM1

SilphCo3TrainerHeaders:
	def_trainers 2
SilphCo3TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_3F_TRAINER_0, 2, _SilphCo3FRocketBattleText, _SilphCo3FRocketEndBattleText, _SilphCo3FRocketAfterBattleText
SilphCo3TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_3F_TRAINER_1, 3, _SilphCo3FScientistBattleText, _SilphCo3FScientistEndBattleText, _SilphCo3FScientistAfterBattleText
	db -1 ; end

SilphCo3FSilphWorkerMText:
	text_asm
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ld hl, .YouSavedUsText
	jr nz, .beat_giovanni
	ld hl, .WhatShouldIDoText
.beat_giovanni
	rst _PrintText
	rst TextScriptEnd

.WhatShouldIDoText:
	text_far_end _SilphCo3FSilphWorkerMWhatShouldIDoText

.YouSavedUsText:
	text_far_end _SilphCo3FSilphWorkerMYouSavedUsText

SilphCo3FRocketText:
	script_trainer SilphCo3TrainerHeader0

SilphCo3FScientistText:
	script_trainer SilphCo3TrainerHeader1
