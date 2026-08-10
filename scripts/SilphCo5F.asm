; PureRGBnote: ADDED: card key will be consumed if all card key doors were opened in the game.

SilphCo5F_Script:
	call SilphCo5FGateCallbackScript
	ld hl, SilphCo5TrainerHeaders
	ld de, SilphCo5F_ScriptPointers
	ld bc, wSilphCo5FCurScript
	jp ExecuteCustomMapScriptInTable

SilphCo5FGateCallbackScript::
	call WasMapJustLoaded
	ret z
	jpfar SilphCo5FCardKeyMapLoad

SilphCo5F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILPHCO5F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO5F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO5F_END_BATTLE

SilphCo5F_TextPointers:
	def_text_pointers
	dba_const SilphCo5FSilphWorkerMText,   TEXT_SILPHCO5F_SILPH_WORKER_M
	dba_const SilphCo5FRocket1Text,        TEXT_SILPHCO5F_ROCKET1
	dba_const SilphCo5FScientistText,      TEXT_SILPHCO5F_SCIENTIST
	dba_const SilphCo5FRockerText,         TEXT_SILPHCO5F_ROCKER
	dba_const SilphCo5FRocket2Text,        TEXT_SILPHCO5F_ROCKET2
	dba_const PickUpItemText,              TEXT_SILPHCO5F_ITEM1
	dba_const PickUpItemText,              TEXT_SILPHCO5F_ITEM2
	dba_const PickUpItemText,              TEXT_SILPHCO5F_ITEM3
	dba_const _SilphCo5FPokemonReport1Text, TEXT_SILPHCO5F_POKEMON_REPORT1
	dba_const _SilphCo5FPokemonReport2Text, TEXT_SILPHCO5F_POKEMON_REPORT2
	dba_const _SilphCo5FPokemonReport3Text, TEXT_SILPHCO5F_POKEMON_REPORT3

SilphCo5TrainerHeaders:
	def_trainers 2
SilphCo5TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_0, 1, _SilphCo5FRocket1BattleText, _SilphCo5FRocket1EndBattleText, _SilphCo5FRocket1AfterBattleText
SilphCo5TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_1, 2, _SilphCo5FScientistBattleText, _SilphCo5FScientistEndBattleText, _SilphCo5FScientistAfterBattleText
SilphCo5TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_2, 4, _SilphCo5FRockerBattleText, _SilphCo5FRockerEndBattleText, _SilphCo5FRockerAfterBattleText
SilphCo5TrainerHeader3:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_3, 3, _SilphCo5FRocket2BattleText, _SilphCo5FRocket2EndBattleText, _SilphCo5FRocket2AfterBattleText
	db -1 ; end

SilphCo5FRocket1Text:
	script_trainer SilphCo5TrainerHeader0

SilphCo5FScientistText:
	script_trainer SilphCo5TrainerHeader1

SilphCo5FRockerText:
	script_trainer SilphCo5TrainerHeader2

SilphCo5FRocket2Text:
	script_trainer SilphCo5TrainerHeader3

SilphCo5FSilphWorkerMText:
	text_asm
	ld hl, .ThatsYouRightText
	ld de, .YoureOurHeroText
	call SilphCo6FBeatGiovanniPrintDEOrPrintHLScript
	rst TextScriptEnd

.ThatsYouRightText:
	text_far_end _SilphCo5FSilphWorkerMThatsYouRightText

.YoureOurHeroText:
	text_far_end _SilphCo5FSilphWorkerMYoureOurHeroText
