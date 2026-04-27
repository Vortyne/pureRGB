; PureRGBnote: ADDED: card key will be consumed if all card key doors were opened in the game.

SilphCo5F_Script:
	call SilphCo5FGateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo5TrainerHeaders
	ld de, SilphCo5F_ScriptPointers
	ld a, [wSilphCo5FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo5FCurScript], a
	ret

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
	dw_const SilphCo5FSilphWorkerMText,   TEXT_SILPHCO5F_SILPH_WORKER_M
	dw_const SilphCo5FRocket1Text,        TEXT_SILPHCO5F_ROCKET1
	dw_const SilphCo5FScientistText,      TEXT_SILPHCO5F_SCIENTIST
	dw_const SilphCo5FRockerText,         TEXT_SILPHCO5F_ROCKER
	dw_const SilphCo5FRocket2Text,        TEXT_SILPHCO5F_ROCKET2
	dw_const PickUpItemText,              TEXT_SILPHCO5F_ITEM1
	dw_const PickUpItemText,              TEXT_SILPHCO5F_ITEM2
	dw_const PickUpItemText,              TEXT_SILPHCO5F_ITEM3
	dw_const SilphCo5FPokemonReport1Text, TEXT_SILPHCO5F_POKEMON_REPORT1
	dw_const SilphCo5FPokemonReport2Text, TEXT_SILPHCO5F_POKEMON_REPORT2
	dw_const SilphCo5FPokemonReport3Text, TEXT_SILPHCO5F_POKEMON_REPORT3

SilphCo5TrainerHeaders:
	def_trainers 2
SilphCo5TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_0, 1, SilphCo5FRocket1BattleText, SilphCo5FRocket1EndBattleText, SilphCo5FRocket1AfterBattleText
SilphCo5TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_1, 2, SilphCo5FScientistBattleText, SilphCo5FScientistEndBattleText, SilphCo5FScientistAfterBattleText
SilphCo5TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_2, 4, SilphCo5FRockerBattleText, SilphCo5FRockerEndBattleText, SilphCo5FRockerAfterBattleText
SilphCo5TrainerHeader3:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_3, 3, SilphCo5FRocket2BattleText, SilphCo5FRocket2EndBattleText, SilphCo5FRocket2AfterBattleText
	db -1 ; end

SilphCo5FSilphWorkerMText:
	text_asm
	ld hl, .ThatsYouRightText
	ld de, .YoureOurHeroText
	call SilphCo6FBeatGiovanniPrintDEOrPrintHLScript
	rst TextScriptEnd

.ThatsYouRightText:
	text_far _SilphCo5FSilphWorkerMThatsYouRightText
	text_end

.YoureOurHeroText:
	text_far _SilphCo5FSilphWorkerMYoureOurHeroText
	text_end

SilphCo5FRocket1Text:
	text_asm
	ld hl, SilphCo5TrainerHeader0
SilphCo5FTalkToTrainer:
	call TalkToTrainer
	rst TextScriptEnd

SilphCo5FScientistText:
	text_asm
	ld hl, SilphCo5TrainerHeader1
	jr SilphCo5FTalkToTrainer

SilphCo5FRockerText:
	text_asm
	ld hl, SilphCo5TrainerHeader2
	jr SilphCo5FTalkToTrainer

SilphCo5FRocket2Text:
	text_asm
	ld hl, SilphCo5TrainerHeader3
	jr SilphCo5FTalkToTrainer

SilphCo5FRocket1BattleText:
	text_far _SilphCo5FRocket1BattleText
	text_end

SilphCo5FRocket1EndBattleText:
	text_far _SilphCo5FRocket1EndBattleText
	text_end

SilphCo5FRocket1AfterBattleText:
	text_far _SilphCo5FRocket1AfterBattleText
	text_end

SilphCo5FScientistBattleText:
	text_far _SilphCo5FScientistBattleText
	text_end

SilphCo5FScientistEndBattleText:
	text_far _SilphCo5FScientistEndBattleText
	text_end

SilphCo5FScientistAfterBattleText:
	text_far _SilphCo5FScientistAfterBattleText
	text_end

SilphCo5FRockerBattleText:
	text_far _SilphCo5FRockerBattleText
	text_end

SilphCo5FRockerEndBattleText:
	text_far _SilphCo5FRockerEndBattleText
	text_end

SilphCo5FRockerAfterBattleText:
	text_far _SilphCo5FRockerAfterBattleText
	text_end

SilphCo5FRocket2BattleText:
	text_far _SilphCo5FRocket2BattleText
	text_end

SilphCo5FRocket2EndBattleText:
	text_far _SilphCo5FRocket2EndBattleText
	text_end

SilphCo5FRocket2AfterBattleText:
	text_far _SilphCo5FRocket2AfterBattleText
	text_end

SilphCo5FPokemonReport1Text:
	text_far _SilphCo5FPokemonReport1Text
	text_end

SilphCo5FPokemonReport2Text:
	text_far _SilphCo5FPokemonReport2Text
	text_end

SilphCo5FPokemonReport3Text:
	text_far _SilphCo5FPokemonReport3Text
	text_end
