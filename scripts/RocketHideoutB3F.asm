; PureRGBnote: CHANGED: Code in this script related to spinners was GREATLY simplified to take up a lot less space.
RocketHideoutB3F_Script:
	ld hl, RocketHideout3TrainerHeaders
	ld de, RocketHideoutB3F_ScriptPointers
	ld bc, wRocketHideoutB3FCurScript
	jp ExecuteCustomMapScriptInTable

RocketHideoutB3F_ScriptPointers:
	def_script_pointers
	dw_const RocketHideoutB3FDefaultScript,         SCRIPT_ROCKETHIDEOUTB3F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROCKETHIDEOUTB3F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROCKETHIDEOUTB3F_END_BATTLE

RocketHideoutB3FDefaultScript:
	jp CheckStartStopSpinningLoadArrowTiles

RocketHideoutB3F_TextPointers:
	def_text_pointers
	dba_const RocketHideoutB3FRocket1Text, TEXT_ROCKETHIDEOUTB3F_ROCKET1
	dba_const RocketHideoutB3FRocket2Text, TEXT_ROCKETHIDEOUTB3F_ROCKET2
	dba_const PickUpItemText,              TEXT_ROCKETHIDEOUTB3F_ITEM1
	dba_const PickUpItemText,              TEXT_ROCKETHIDEOUTB3F_ITEM2

RocketHideout3TrainerHeaders:
	def_trainers
RocketHideout3TrainerHeader0:
	trainer EVENT_BEAT_ROCKET_HIDEOUT_3_TRAINER_0, 2, _RocketHideoutB3FRocket1BattleText, _RocketHideoutB3FRocket1EndBattleText, _RocketHideoutB3FRocket1AfterBattleText
RocketHideout3TrainerHeader1:
	trainer EVENT_BEAT_ROCKET_HIDEOUT_3_TRAINER_1, 4, _RocketHideout3BattleText, _RocketHideout3EndBattleText3, _RocketHide3AfterBattleText3
	db -1 ; end

RocketHideoutB3FRocket1Text:
	script_trainer RocketHideout3TrainerHeader0

RocketHideoutB3FRocket2Text:
	script_trainer RocketHideout3TrainerHeader1
