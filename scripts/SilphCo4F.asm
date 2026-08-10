; PureRGBnote: ADDED: card key will be consumed if all card key doors were opened in the game.

SilphCo4F_Script:
	call SilphCo4FGateCallbackScript
	ld hl, SilphCo4TrainerHeaders
	ld de, SilphCo4F_ScriptPointers
	ld bc, wSilphCo4FCurScript
	jp ExecuteCustomMapScriptInTable

SilphCo4FGateCallbackScript::
	call WasMapJustLoaded
	ret z
	jpfar SilphCo4FCardKeyMapLoad

SilphCo4F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILPHCO4F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO4F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO4F_END_BATTLE

SilphCo4F_TextPointers:
	def_text_pointers
	dba_const SilphCo4FSilphWorkerMText, TEXT_SILPHCO4F_SILPH_WORKER_M
	dba_const SilphCo4FRocket1Text,      TEXT_SILPHCO4F_ROCKET1
	dba_const SilphCo4FScientistText,    TEXT_SILPHCO4F_SCIENTIST
	dba_const SilphCo4FRocket2Text,      TEXT_SILPHCO4F_ROCKET2
	dba_const PickUp3ItemText,           TEXT_SILPHCO4F_ITEM1
	dba_const PickUpItemText,            TEXT_SILPHCO4F_ITEM2
	dba_const PickUpItemText,            TEXT_SILPHCO4F_ITEM3

SilphCo4TrainerHeaders:
	def_trainers 2
SilphCo4TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_4F_TRAINER_0, 4, _SilphCo4FRocket1BattleText, _SilphCo4FRocket1EndBattleText, _SilphCo4FRocket1AfterBattleText
SilphCo4TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_4F_TRAINER_1, 3, _SilphCo4FScientistBattleText, _SilphCo4FScientistEndBattleText, _SilphCo4FScientistAfterBattleText
SilphCo4TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_4F_TRAINER_2, 4, _SilphCo4FRocket2BattleText, _SilphCo4FRocket2EndBattleText, _SilphCo4FRocket2AfterBattleText
	db -1 ; end

SilphCo4FSilphWorkerMText:
	text_asm
	ld hl, .ImHidingText
	ld de, .TeamRocketIsGoneText
	call SilphCo6FBeatGiovanniPrintDEOrPrintHLScript
	rst TextScriptEnd

.ImHidingText:
	text_far_end _SilphCo4FSilphWorkerMImHidingText

.TeamRocketIsGoneText:
	text_far_end _SilphCo4FSilphWorkerMTeamRocketIsGoneText

SilphCo4FRocket1Text:
	script_trainer SilphCo4TrainerHeader0

SilphCo4FScientistText:
	script_trainer SilphCo4TrainerHeader1

SilphCo4FRocket2Text:
	script_trainer SilphCo4TrainerHeader2
