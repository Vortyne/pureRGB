; PureRGBnote: ADDED: card key will be consumed if all card key doors were opened in the game.

SilphCo3F_Script:
	call SilphCo3FGateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo3TrainerHeaders
	ld de, SilphCo3F_ScriptPointers
	ld a, [wSilphCo3FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo3FCurScript], a
	ret

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
	dw_const SilphCo3FSilphWorkerMText, TEXT_SILPHCO3F_SILPH_WORKER_M
	dw_const SilphCo3FRocketText,       TEXT_SILPHCO3F_ROCKET
	dw_const SilphCo3FScientistText,    TEXT_SILPHCO3F_SCIENTIST
	dw_const PickUp3ItemText,           TEXT_SILPHCO3F_ITEM1

SilphCo3TrainerHeaders:
	def_trainers 2
SilphCo3TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_3F_TRAINER_0, 2, SilphCo3FRocketBattleText, SilphCo3FRocketEndBattleText, SilphCo3FRocketAfterBattleText
SilphCo3TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_3F_TRAINER_1, 3, SilphCo3FScientistBattleText, SilphCo3FScientistEndBattleText, SilphCo3FScientistAfterBattleText
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
	text_far _SilphCo3FSilphWorkerMWhatShouldIDoText
	text_end

.YouSavedUsText:
	text_far _SilphCo3FSilphWorkerMYouSavedUsText
	text_end

SilphCo3FRocketText:
	text_asm
	ld hl, SilphCo3TrainerHeader0
SilphCo3FTalkToTrainer:
	call TalkToTrainer
	rst TextScriptEnd

SilphCo3FScientistText:
	text_asm
	ld hl, SilphCo3TrainerHeader1
	jr SilphCo3FTalkToTrainer

SilphCo3FRocketBattleText:
	text_far _SilphCo3FRocketBattleText
	text_end

SilphCo3FRocketEndBattleText:
	text_far _SilphCo3FRocketEndBattleText
	text_end

SilphCo3FRocketAfterBattleText:
	text_far _SilphCo3FRocketAfterBattleText
	text_end

SilphCo3FScientistBattleText:
	text_far _SilphCo3FScientistBattleText
	text_end

SilphCo3FScientistEndBattleText:
	text_far _SilphCo3FScientistEndBattleText
	text_end

SilphCo3FScientistAfterBattleText:
	text_far _SilphCo3FScientistAfterBattleText
	text_end
