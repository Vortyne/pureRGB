Route17_Script:
	ld hl, Route17TrainerHeaders
	ld de, Route17_ScriptPointers
	ld bc, wRoute17CurScript
	jp ExecuteCustomMapScriptInTable

Route17_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROUTE17_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE17_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE17_END_BATTLE

Route17_TextPointers:
	def_text_pointers
	dba_const Route17Biker1Text,              TEXT_ROUTE17_BIKER1
	dba_const Route17Biker2Text,              TEXT_ROUTE17_BIKER2
	dba_const Route17Biker3Text,              TEXT_ROUTE17_BIKER3
	dba_const Route17Biker4Text,              TEXT_ROUTE17_BIKER4
	dba_const Route17Biker5Text,              TEXT_ROUTE17_BIKER5
	dba_const Route17Biker6Text,              TEXT_ROUTE17_BIKER6
	dba_const Route17Biker7Text,              TEXT_ROUTE17_BIKER7
	dba_const Route17Biker8Text,              TEXT_ROUTE17_BIKER8
	dba_const Route17Biker9Text,              TEXT_ROUTE17_BIKER9
	dba_const Route17Biker10Text,             TEXT_ROUTE17_BIKER10
	dba_const _Route17NoticeSign1Text,         TEXT_ROUTE17_NOTICE_SIGN1
	dba_const _Route17TrainerTips1Text,        TEXT_ROUTE17_TRAINER_TIPS1
	dba_const _Route17TrainerTips2Text,        TEXT_ROUTE17_TRAINER_TIPS2
	dba_const _Route17SignText,                TEXT_ROUTE17_SIGN
	dba_const _Route17NoticeSign2Text,         TEXT_ROUTE17_NOTICE_SIGN2
	dba_const _Route17CyclingRoadEndsSignText, TEXT_ROUTE17_CYCLING_ROAD_ENDS_SIGN
	dba_const _Route16SignText,                TEXT_ROUTE17_ROUTE16_SIGN

Route17TrainerHeaders:
	def_trainers
Route17TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_17_TRAINER_0, 3, _Route17Biker1BattleText, _Route17Biker1EndBattleText, _Route17Biker1AfterBattleText
Route17TrainerHeader1:
	trainer EVENT_BEAT_ROUTE_17_TRAINER_1, 4, _Route17Biker2BattleText, _Route17Biker2EndBattleText, _Route17Biker2AfterBattleText
Route17TrainerHeader2:
	trainer EVENT_BEAT_ROUTE_17_TRAINER_2, 4, _Route17Biker3BattleText, _Route17Biker3EndBattleText, _Route17Biker3AfterBattleText
Route17TrainerHeader3:
	trainer EVENT_BEAT_ROUTE_17_TRAINER_3, 4, _Route17Biker4BattleText, _Route17Biker4EndBattleText, _Route17Biker4AfterBattleText
Route17TrainerHeader4:
	trainer EVENT_BEAT_ROUTE_17_TRAINER_4, 3, _Route17Biker5BattleText, _Route17Biker5EndBattleText, Route17Biker5AfterBattleText
Route17TrainerHeader5:
	trainer EVENT_BEAT_ROUTE_17_TRAINER_5, 2, _Route17Biker6BattleText, _Route17Biker6EndBattleText, _Route17Biker6AfterBattleText
Route17TrainerHeader6:
	trainer EVENT_BEAT_ROUTE_17_TRAINER_6, 4, _Route17Biker7BattleText, _Route17Biker7EndBattleText, _Route17Biker7AfterBattleText
Route17TrainerHeader7:
	trainer EVENT_BEAT_ROUTE_17_TRAINER_7, 2, _Route17Biker8BattleText, _Route17Biker8EndBattleText, _Route17Biker8AfterBattleText
Route17TrainerHeader8:
	trainer EVENT_BEAT_ROUTE_17_TRAINER_8, 3, _Route17Biker9BattleText, _Route17Biker9EndBattleText, _Route17Biker9AfterBattleText
Route17TrainerHeader9:
	trainer EVENT_BEAT_ROUTE_17_TRAINER_9, 4, _Route17Biker10BattleText, _Route17Biker10EndBattleText, _Route17Biker10AfterBattleText
	db -1 ; end

Route17Biker1Text:
	script_trainer Route17TrainerHeader0

Route17Biker2Text:
	script_trainer Route17TrainerHeader1

Route17Biker3Text:
	script_trainer Route17TrainerHeader2

Route17Biker4Text:
	script_trainer Route17TrainerHeader3

Route17Biker5Text:
	script_trainer Route17TrainerHeader4

Route17Biker6Text:
	script_trainer Route17TrainerHeader5

Route17Biker7Text:
	script_trainer Route17TrainerHeader6

Route17Biker8Text:
	script_trainer Route17TrainerHeader7

Route17Biker9Text:
	script_trainer Route17TrainerHeader8

Route17Biker10Text:
	script_trainer Route17TrainerHeader9

Route17Biker5AfterBattleText:
	text_far _Route17Biker5AfterBattleText
	text_asm
	lb hl, DEX_ELECTRODE, BIKER
	ld de, LearnsetElectrode
	predef_jump LearnsetTrainerScript
