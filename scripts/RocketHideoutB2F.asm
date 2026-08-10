; PureRGBnote: CHANGED: Code in this script related to spinners was GREATLY simplified to take up a lot less space.
RocketHideoutB2F_Script:
	ld hl, RocketHideout2TrainerHeaders
	ld de, RocketHideoutB2F_ScriptPointers
	ld bc, wRocketHideoutB2FCurScript
	jp ExecuteCustomMapScriptInTable

RocketHideoutB2F_ScriptPointers:
	def_script_pointers
	dw_const RocketHideoutB2FDefaultScript,         SCRIPT_ROCKETHIDEOUTB2F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROCKETHIDEOUTB2F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROCKETHIDEOUTB2F_END_BATTLE

RocketHideoutB2FDefaultScript:
	jp CheckStartStopSpinningLoadArrowTiles

INCLUDE "engine/overworld/spinners.asm"

RocketHideoutB2F_TextPointers:
	def_text_pointers
	dba_const RocketHideoutB2FRocketText, TEXT_ROCKETHIDEOUTB2F_ROCKET
	dba_const PickUpItemText,             TEXT_ROCKETHIDEOUTB2F_ITEM1
	dba_const PickUpItemText,             TEXT_ROCKETHIDEOUTB2F_ITEM2
	dba_const PickUpItemText,             TEXT_ROCKETHIDEOUTB2F_ITEM3
	dba_const PickUpItemText,             TEXT_ROCKETHIDEOUTB2F_ITEM4

RocketHideout2TrainerHeaders:
	def_trainers
RocketHideout2TrainerHeader0:
	trainer EVENT_BEAT_ROCKET_HIDEOUT_2_TRAINER_0, 4, _RocketHideoutB2FRocketBattleText, _RocketHideoutB2FRocketEndBattleText, _RocketHideoutB2FRocketAfterBattleText
	db -1 ; end

RocketHideoutB2FRocketText:
	script_trainer RocketHideout2TrainerHeader0
