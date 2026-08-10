Route19_Script:
	ld hl, Route19TrainerHeaders
	ld de, Route19_ScriptPointers
	ld bc, wRoute19CurScript
	jp ExecuteCustomMapScriptInTable

Route19_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROUTE19_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE19_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE19_END_BATTLE

Route19_TextPointers:
	def_text_pointers
	dba_const Route19CooltrainerM1Text, TEXT_ROUTE19_COOLTRAINER_M1
	dba_const Route19CooltrainerM2Text, TEXT_ROUTE19_COOLTRAINER_M2
	dba_const Route19Swimmer1Text,      TEXT_ROUTE19_SWIMMER1
	dba_const Route19Swimmer2Text,      TEXT_ROUTE19_SWIMMER2
	dba_const Route19Swimmer3Text,      TEXT_ROUTE19_SWIMMER3
	dba_const Route19Swimmer4Text,      TEXT_ROUTE19_SWIMMER4
	dba_const Route19Swimmer5Text,      TEXT_ROUTE19_SWIMMER5
	dba_const Route19Swimmer6Text,      TEXT_ROUTE19_SWIMMER6
	dba_const Route19Swimmer7Text,      TEXT_ROUTE19_SWIMMER7
	dba_const Route19Swimmer8Text,      TEXT_ROUTE19_SWIMMER8
	dba_const _Route19SignText,         TEXT_ROUTE19_SIGN

Route19TrainerHeaders:
	def_trainers
Route19TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_19_TRAINER_0, 4, _Route19CooltrainerM1BattleText, _Route19CooltrainerM1EndBattleText, _Route19CooltrainerM1AfterBattleText
Route19TrainerHeader1:
	trainer EVENT_BEAT_ROUTE_19_TRAINER_1, 3, _Route19CooltrainerM2BattleText, _Route19CooltrainerM2EndBattleText, Route19CooltrainerM2AfterBattleText
Route19TrainerHeader2:
	trainer EVENT_BEAT_ROUTE_19_TRAINER_2, 3, _Route19Swimmer1BattleText, _Route19Swimmer1EndBattleText, _Route19Swimmer1AfterBattleText
Route19TrainerHeader3:
	trainer EVENT_BEAT_ROUTE_19_TRAINER_3, 4, _Route19Swimmer2BattleText, _Route19Swimmer2EndBattleText, _Route19Swimmer2AfterBattleText
Route19TrainerHeader4:
	trainer EVENT_BEAT_ROUTE_19_TRAINER_4, 4, _Route19Swimmer3BattleText, _Route19Swimmer3EndBattleText, _Route19Swimmer3AfterBattleText
Route19TrainerHeader5:
	trainer EVENT_BEAT_ROUTE_19_TRAINER_5, 4, _Route19Swimmer4BattleText, _Route19Swimmer4EndBattleText, _Route19Swimmer4AfterBattleText
Route19TrainerHeader6:
	trainer EVENT_BEAT_ROUTE_19_TRAINER_6, 3, _Route19Swimmer5BattleText, _Route19Swimmer5EndBattleText, _Route19Swimmer5AfterBattleText
Route19TrainerHeader7:
	trainer EVENT_BEAT_ROUTE_19_TRAINER_7, 4, _Route19Swimmer6BattleText, _Route19Swimmer6EndBattleText, _Route19Swimmer6AfterBattleText
Route19TrainerHeader8:
	trainer EVENT_BEAT_ROUTE_19_TRAINER_8, 4, _Route19Swimmer7BattleText, _Route19Swimmer7EndBattleText, _Route19Swimmer7AfterBattleText
Route19TrainerHeader9:
	trainer EVENT_BEAT_ROUTE_19_TRAINER_9, 4, _Route19Swimmer8BattleText, _Route19Swimmer8EndBattleText, _Route19Swimmer8AfterBattleText
	db -1 ; end

Route19CooltrainerM1Text:
	script_trainer Route19TrainerHeader0

Route19CooltrainerM2Text:
	script_trainer Route19TrainerHeader1

Route19Swimmer1Text:
	script_trainer Route19TrainerHeader2

Route19Swimmer2Text:
	script_trainer Route19TrainerHeader3

Route19Swimmer3Text:
	script_trainer Route19TrainerHeader4

Route19Swimmer4Text:
	script_trainer Route19TrainerHeader5

Route19Swimmer5Text:
	script_trainer Route19TrainerHeader6

Route19Swimmer6Text:
	script_trainer Route19TrainerHeader7

Route19Swimmer7Text:
	script_trainer Route19TrainerHeader8

Route19Swimmer8Text:
	script_trainer Route19TrainerHeader9

Route19CooltrainerM2AfterBattleText:
	text_far _Route19CooltrainerM2AfterBattleText
	text_asm
	lb hl, DEX_PINSIR, SWIMMER
	ld de, LearnsetCool
	predef_jump LearnsetTrainerScript
