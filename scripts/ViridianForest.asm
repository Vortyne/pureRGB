; PureRGBnote: ADDED: the 2 trainers that were added in pokemon yellow were added.

ViridianForest_Script:
	ld hl, ViridianForestTrainerHeaders
	ld de, ViridianForest_ScriptPointers
	ld bc, wViridianForestCurScript
	jp ExecuteCustomMapScriptInTable

ViridianForest_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_VIRIDIANFOREST_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_VIRIDIANFOREST_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_VIRIDIANFOREST_END_BATTLE

ViridianForest_TextPointers:
	def_text_pointers
	dba_const _ViridianForestYoungster1Text,      TEXT_VIRIDIANFOREST_YOUNGSTER1
	dba_const ViridianForestYoungster2Text,       TEXT_VIRIDIANFOREST_YOUNGSTER2
	dba_const ViridianForestYoungster3Text,       TEXT_VIRIDIANFOREST_YOUNGSTER3
	dba_const ViridianForestYoungster4Text,       TEXT_VIRIDIANFOREST_YOUNGSTER4
	dba_const ViridianForestText5,                TEXT_VIRIDIANFOREST_LASS
	dba_const ViridianForestText6,                TEXT_VIRIDIANFOREST_YOUNGSTER5
	dba_const PickUp3ItemText,                    TEXT_VIRIDIANFOREST_ITEM1
	dba_const PickUp2ItemText,                    TEXT_VIRIDIANFOREST_ITEM2
	dba_const PickUp5ItemText,                    TEXT_VIRIDIANFOREST_ITEM3
	dba_const _ViridianForestYoungster5Text,      TEXT_VIRIDIANFOREST_YOUNGSTER6
	dba_const _ViridianForestTrainerTips1Text,    TEXT_VIRIDIANFOREST_TRAINER_TIPS1
	dba_const _ViridianForestUseAntidoteSignText, TEXT_VIRIDIANFOREST_USE_ANTIDOTE_SIGN
	dba_const _ViridianForestTrainerTips2Text,    TEXT_VIRIDIANFOREST_TRAINER_TIPS2
	dba_const _ViridianForestTrainerTips3Text,    TEXT_VIRIDIANFOREST_TRAINER_TIPS3
	dba_const _ViridianForestTrainerTips4Text,    TEXT_VIRIDIANFOREST_TRAINER_TIPS4
	dba_const _ViridianForestLeavingSignText,     TEXT_VIRIDIANFOREST_LEAVING_SIGN

ViridianForestTrainerHeaders:
	def_trainers 2
ViridianForestTrainerHeader0:
	trainer EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_0, 4, _ViridianForestYoungster2BattleText, _ViridianForestYoungster2EndBattleText, _ViridianForestYoungster2AfterBattleText
ViridianForestTrainerHeader1:
	trainer EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_1, 4, _ViridianForestYoungster3BattleText, _ViridianForestYoungster3EndBattleText, _ViridianForestYoungster3AfterBattleText
ViridianForestTrainerHeader2:
	trainer EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_2, 1, _ViridianForestYoungster4BattleText, _ViridianForestYoungster4EndBattleText, _ViridianForestYoungster4AfterBattleText
ViridianForestTrainerHeader3:
	trainer EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_3, 0, _ViridianForestBattleTextPikaGirl, _ViridianForestEndBattleTextPikaGirl, _ViridianForestAfterBattleTextPikaGirl
ViridianForestTrainerHeader4:
	trainer EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_4, 4, _ViridianForestBattleTextSamurai, _ViridianForestEndBattleTextSamurai, _ViridianForestAfterBattleTextSamurai
	db -1 ; end

ViridianForestYoungster2Text:
	script_trainer ViridianForestTrainerHeader0

ViridianForestYoungster3Text:
	script_trainer ViridianForestTrainerHeader1

ViridianForestYoungster4Text:
	script_trainer ViridianForestTrainerHeader2

ViridianForestText5:
	script_trainer ViridianForestTrainerHeader3

ViridianForestText6:
	script_trainer ViridianForestTrainerHeader4
