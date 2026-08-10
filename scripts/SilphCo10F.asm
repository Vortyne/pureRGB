; PureRGBnote: ADDED: card key will be consumed if all card key doors were opened in the game.

SilphCo10F_Script:
	call SilphCo10FGateCallbackScript
	ld hl, SilphCo10TrainerHeaders
	ld de, SilphCo10F_ScriptPointers
	ld bc, wSilphCo10FCurScript
	jp ExecuteCustomMapScriptInTable

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
	dba_const SilphCo10FRocketText,       TEXT_SILPHCO10F_ROCKET
	dba_const SilphCo10FScientistText,    TEXT_SILPHCO10F_SCIENTIST
	dba_const SilphCo10FSilphWorkerFText, TEXT_SILPHCO10F_SILPH_WORKER_F
	dba_const PickUpItemText,             TEXT_SILPHCO10F_ITEM1
	dba_const PickUpItemText,             TEXT_SILPHCO10F_ITEM2
	dba_const PickUpItemText,             TEXT_SILPHCO10F_ITEM3

SilphCo10TrainerHeaders:
	def_trainers
SilphCo10TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_10F_TRAINER_0, 3, _SilphCo10FRocketBattleText, _SilphCo10FRocketEndBattleText, _SilphCo10FRocketAfterBattleText
SilphCo10TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_10F_TRAINER_1, 4, _SilphCo10FScientistBattleText, _SilphCo10FScientistEndBattleText, _SilphCo10FScientistAfterBattleText
	db -1 ; end

SilphCo10FRocketText:
	script_trainer SilphCo10TrainerHeader0

SilphCo10FScientistText:
	script_trainer SilphCo10TrainerHeader1

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
	text_far_end _SilphCo10FSilphWorkerFImScaredText

.QuietAboutMyCryingText:
	text_far_end _SilphCo10FSilphWorkerFQuietAboutMyCryingText
