; PureRGBnote: ADDED: card key will be consumed if all card key doors were opened in the game.

SilphCo10F_Script:
	call SilphCo10FGateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo10TrainerHeaders
	ld de, SilphCo10F_ScriptPointers
	ld a, [wSilphCo10FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo10FCurScript], a
	ret

SilphCo10FGateCallbackScript::
	call WasMapJustLoaded
	ret z
	ld hl, SilphCo10FGateCoords
	CheckEvent EVENT_SILPH_CO_10_UNLOCKED_DOOR
	jp UnlockSilphCoDoor

SilphCo10F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILPHCO10F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO10F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO10F_END_BATTLE

SilphCo10F_TextPointers:
	def_text_pointers
	dw_const SilphCo10FRocketText,       TEXT_SILPHCO10F_ROCKET
	dw_const SilphCo10FScientistText,    TEXT_SILPHCO10F_SCIENTIST
	dw_const SilphCo10FSilphWorkerFText, TEXT_SILPHCO10F_SILPH_WORKER_F
	dw_const PickUpItemText,             TEXT_SILPHCO10F_ITEM1
	dw_const PickUpItemText,             TEXT_SILPHCO10F_ITEM2
	dw_const PickUpItemText,             TEXT_SILPHCO10F_ITEM3

SilphCo10TrainerHeaders:
	def_trainers
SilphCo10TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_10F_TRAINER_0, 3, SilphCo10FRocketBattleText, SilphCo10FRocketEndBattleText, SilphCo10FRocketAfterBattleText
SilphCo10TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_10F_TRAINER_1, 4, SilphCo10FScientistBattleText, SilphCo10FScientistEndBattleText, SilphCo10FScientistAfterBattleText
	db -1 ; end

SilphCo10FRocketText:
	text_asm
	ld hl, SilphCo10TrainerHeader0
SilphCo10FTalkToTrainer:
	call TalkToTrainer
	rst TextScriptEnd

SilphCo10FScientistText:
	text_asm
	ld hl, SilphCo10TrainerHeader1
	jr SilphCo10FTalkToTrainer

SilphCo10FSilphWorkerFText:
	text_asm
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ld hl, .QuietAboutMyCryingText
	jr nz, .beat_giovanni
	ld hl, .ImScaredText
.beat_giovanni
	rst _PrintText
	rst TextScriptEnd

.ImScaredText:
	text_far _SilphCo10FSilphWorkerFImScaredText
	text_end

.QuietAboutMyCryingText:
	text_far _SilphCo10FSilphWorkerFQuietAboutMyCryingText
	text_end

SilphCo10FRocketBattleText:
	text_far _SilphCo10FRocketBattleText
	text_end

SilphCo10FRocketEndBattleText:
	text_far _SilphCo10FRocketEndBattleText
	text_end

SilphCo10FRocketAfterBattleText:
	text_far _SilphCo10FRocketAfterBattleText
	text_end

SilphCo10FScientistBattleText:
	text_far _SilphCo10FScientistBattleText
	text_end

SilphCo10FScientistEndBattleText:
	text_far _SilphCo10FScientistEndBattleText
	text_end

SilphCo10FScientistAfterBattleText:
	text_far _SilphCo10FScientistAfterBattleText
	text_end
