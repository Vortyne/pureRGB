Route15_Script:
	ld hl, Route15TrainerHeaders
	ld de, Route15_ScriptPointers
	ld bc, wRoute15CurScript
	jp ExecuteCustomMapScriptInTable

Route15_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROUTE15_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE15_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE15_END_BATTLE

Route15_TextPointers:
	def_text_pointers
	dba_const Route15CooltrainerF1Text, TEXT_ROUTE15_COOLTRAINER_F1
	dba_const Route15CooltrainerF2Text, TEXT_ROUTE15_COOLTRAINER_F2
	dba_const Route15CooltrainerM1Text, TEXT_ROUTE15_COOLTRAINER_M1
	dba_const Route15CooltrainerM2Text, TEXT_ROUTE15_COOLTRAINER_M2
	dba_const Route15Beauty1Text,       TEXT_ROUTE15_BEAUTY1
	dba_const Route15Beauty2Text,       TEXT_ROUTE15_BEAUTY2
	dba_const Route15Biker1Text,        TEXT_ROUTE15_BIKER1
	dba_const Route15Biker2Text,        TEXT_ROUTE15_BIKER2
	dba_const Route15CooltrainerF3Text, TEXT_ROUTE15_COOLTRAINER_F3
	dba_const Route15CooltrainerF4Text, TEXT_ROUTE15_COOLTRAINER_F4
	dba_const PickUpItemText,           TEXT_ROUTE15_ITEM1
	dba_const _Route15SignText,         TEXT_ROUTE15_SIGN

Route15TrainerHeaders:
	def_trainers
Route15TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_15_TRAINER_0, 2, _Route15CooltrainerF1BattleText, _Route15CooltrainerF1EndBattleText, _Route15CooltrainerF1AfterBattleText
Route15TrainerHeader1:
	trainer EVENT_BEAT_ROUTE_15_TRAINER_1, 3, _Route15CooltrainerF2BattleText, _Route15CooltrainerF2EndBattleText, _Route15CooltrainerF2AfterBattleText
Route15TrainerHeader2:
	trainer EVENT_BEAT_ROUTE_15_TRAINER_2, 3, _Route15CooltrainerM1BattleText, _Route15CooltrainerM1EndBattleText, _Route15CooltrainerM1AfterBattleText
Route15TrainerHeader3:
	trainer EVENT_BEAT_ROUTE_15_TRAINER_3, 3, _Route15CooltrainerM2BattleText, _Route15CooltrainerM2EndBattleText, _Route15CooltrainerM2AfterBattleText
Route15TrainerHeader4:
	trainer EVENT_BEAT_ROUTE_15_TRAINER_4, 2, _Route15Beauty1BattleText, _Route15Beauty1EndBattleText, _Route15Beauty1AfterBattleText
Route15TrainerHeader5:
	trainer EVENT_BEAT_ROUTE_15_TRAINER_5, 3, _Route15Beauty2BattleText, _Route15Beauty2EndBattleText, _Route15Beauty2AfterBattleText
Route15TrainerHeader6:
	trainer EVENT_BEAT_ROUTE_15_TRAINER_6, 3, _Route15Biker1BattleText, _Route15Biker1EndBattleText, _Route15Biker1AfterBattleText
Route15TrainerHeader7:
	trainer EVENT_BEAT_ROUTE_15_TRAINER_7, 3, _Route15Biker2BattleText, _Route15Biker2EndBattleText, _Route15Biker2AfterBattleText
Route15TrainerHeader8:
	trainer EVENT_BEAT_ROUTE_15_TRAINER_8, 3, _Route15CooltrainerF3BattleText, _Route15CooltrainerF3EndBattleText, _Route15CooltrainerF3AfterBattleText
Route15TrainerHeader9:
	trainer EVENT_BEAT_ROUTE_15_TRAINER_9, 3, _Route15CooltrainerF4BattleText, _Route15CooltrainerF4EndBattleText, _Route15CooltrainerF4AfterBattleText
	db -1 ; end

Route15CooltrainerF1Text:
	script_trainer Route15TrainerHeader0

Route15CooltrainerF2Text:
	script_trainer Route15TrainerHeader1

Route15CooltrainerM1Text:
	script_trainer Route15TrainerHeader2

Route15CooltrainerM2Text:
	script_trainer Route15TrainerHeader3

Route15Beauty1Text:
	script_trainer Route15TrainerHeader4

Route15Beauty2Text:
	script_trainer Route15TrainerHeader5

Route15Biker1Text:
	script_trainer Route15TrainerHeader6

Route15Biker2Text:
	script_trainer Route15TrainerHeader7

Route15CooltrainerF3Text:
	script_trainer Route15TrainerHeader8

Route15CooltrainerF4Text:
	script_trainer Route15TrainerHeader9
