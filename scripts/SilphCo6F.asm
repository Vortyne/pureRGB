; PureRGBnote: ADDED: card key will be consumed if all card key doors were opened in the game.

SilphCo6F_Script:
	call SilphCo6FGateCallbackScript
	ld hl, SilphCo6TrainerHeaders
	ld de, SilphCo6F_ScriptPointers
	ld bc, wSilphCo6FCurScript
	jp ExecuteCustomMapScriptInTable

SilphCo6FGateCallbackScript::
	call WasMapJustLoaded
	ret z
	jpfar SilphCo6FCardKeyMapLoad

SilphCo6F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILPHCO6F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO6F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO6F_END_BATTLE

SilphCo6F_TextPointers:
	def_text_pointers
	dba_const SilphCo6FSilphWorkerM1Text, TEXT_SILPHCO6F_SILPH_WORKER_M1
	dba_const SilphCo6FSilphWorkerM2Text, TEXT_SILPHCO6F_SILPH_WORKER_M2
	dba_const SilphCo6FSilphWorkerF1Text, TEXT_SILPHCO6F_SILPH_WORKER_F1
	dba_const SilphCo6FSilphWorkerF2Text, TEXT_SILPHCO6F_SILPH_WORKER_F2
	dba_const SilphCo6FSilphWorkerM3Text, TEXT_SILPHCO6F_SILPH_WORKER_M3
	dba_const SilphCo6FRocket1Text,       TEXT_SILPHCO6F_ROCKET1
	dba_const SilphCo6FScientistText,     TEXT_SILPHCO6F_SCIENTIST
	dba_const SilphCo6FRocket2Text,       TEXT_SILPHCO6F_ROCKET2
	dba_const PickUpItemText,             TEXT_SILPHCO6F_ITEM1
	dba_const PickUp3ItemText,            TEXT_SILPHCO6F_ITEM2

SilphCo6TrainerHeaders:
	def_trainers 6
SilphCo6TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_6F_TRAINER_0, 2, _SilphCo6FRocket1BattleText, _SilphCo6FRocket1EndBattleText, _SilphCo6FRocket1AfterBattleText
SilphCo6TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_6F_TRAINER_1, 3, _SilphCo6FScientistBattleText, _SilphCo6FScientistEndBattleText, _SilphCo6FScientistAfterBattleText
SilphCo6TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_6F_TRAINER_2, 2, _SilphCo6FRocket2BattleText, _SilphCo6FRocket2EndBattleText, _SilphCo6FRocket2AfterBattleText
	db -1 ; end

SilphCo6FRocket1Text:
	script_trainer SilphCo6TrainerHeader0

SilphCo6FScientistText:
	script_trainer SilphCo6TrainerHeader1

SilphCo6FRocket2Text:
	script_trainer SilphCo6TrainerHeader2

SilphCo6FBeatGiovanniPrintDEOrPrintHLScript:
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	jr z, .print_text
	ld h, d
	ld l, e
.print_text
	jp PrintText

SilphCo6FSilphWorkerM1Text:
	text_asm
	ld hl, .TookOverTheBuildingText
	ld de, .BackToWorkText
	call SilphCo6FBeatGiovanniPrintDEOrPrintHLScript
	rst TextScriptEnd

.TookOverTheBuildingText:
	text_far_end _SilphCo6FSilphWorkerM1TookOverTheBuildingText

.BackToWorkText:
	text_far_end _SilphCo6FSilphWorkerM1BackToWorkText

SilphCo6FSilphWorkerM2Text:
	text_asm
	ld hl, .HelpMePleaseText
	ld de, .WeGotEngagedText
	call SilphCo6FBeatGiovanniPrintDEOrPrintHLScript
	rst TextScriptEnd

.HelpMePleaseText:
	text_far_end _SilphCo6FSilphWorkerMHelpMePleaseText

.WeGotEngagedText:
	text_far_end _SilphCo6FSilphWorkerMWeGotEngagedText

SilphCo6FSilphWorkerF1Text:
	text_asm
	ld hl, .SuchACowardText
	ld de, .HaveToMarryHimText
	call SilphCo6FBeatGiovanniPrintDEOrPrintHLScript
	rst TextScriptEnd

.SuchACowardText:
	text_far_end _SilphCo6FSilphWorkerF1SuchACowardText

.HaveToMarryHimText:
	text_far_end _SilphCo6FSilphWorkerF1HaveToMarryHimText

SilphCo6FSilphWorkerF2Text:
	text_asm
	ld hl, .TeamRocketConquerWorldText
	ld de, .TeamRocketRanText
	call SilphCo6FBeatGiovanniPrintDEOrPrintHLScript
	rst TextScriptEnd

.TeamRocketConquerWorldText:
	text_far_end _SilphCo6FSilphWorkerF2TeamRocketConquerWorldText

.TeamRocketRanText:
	text_far_end _SilphCo6FSilphWorkerF2TeamRocketRanText

SilphCo6FSilphWorkerM3Text:
	text_asm
	ld hl, .TargetedSilphText
	ld de, .WorkForSilphText
	call SilphCo6FBeatGiovanniPrintDEOrPrintHLScript
	rst TextScriptEnd

.TargetedSilphText:
	text_far_end _SilphCo6FSilphWorkerM3TargetedSilphText

.WorkForSilphText:
	text_far_end _SilphCo6FSilphWorkerM3WorkForSilphText
