; PureRGBnote: ADDED: new trainers on this route.

Route4_Script:
	ld hl, Route4TrainerHeaders
	ld de, Route4_ScriptPointers
	ld bc, wRoute4CurScript
	jp ExecuteCustomMapScriptInTable

Route4_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROUTE4_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE4_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE4_END_BATTLE

Route4_TextPointers:
	def_text_pointers
	dba_const _Route4CooltrainerF1Text, TEXT_ROUTE4_COOLTRAINER_F1
	dba_const Route4CooltrainerF2Text, TEXT_ROUTE4_COOLTRAINER_F2
	dba_const Route4Text3,             TEXT_ROUTE4_ROOKIE1
	dba_const Route4Text4,             TEXT_ROUTE4_ROOKIE2
	dba_const Route4Text5,             TEXT_ROUTE4_TAMER
	dba_const PickUpItemText,          TEXT_ROUTE4_ITEM1
	dba_const PickUpItemText,          TEXT_ROUTE4_ITEM2 ; PureRGBnote: ADDED: new item on this route.
	dba_const PokeCenterSignText,      TEXT_ROUTE4_POKECENTER_SIGN
	dba_const _Route4MtMoonSignText,    TEXT_ROUTE4_MT_MOON_SIGN
	dba_const _Route4SignText,          TEXT_ROUTE4_SIGN
	dba_const _Route4Text8,             TEXT_ROUTE4_TRAINER_TIPS1 ; PureRGBnote: ADDED: new trainer tips sign on this route.
	dba_const _Route4Text9,             TEXT_ROUTE4_TRAINER_TIPS2 ; PureRGBnote: ADDED: new trainer tips sign on this route.

Route4TrainerHeaders:
	def_trainers 2
Route4TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_4_TRAINER_0, 3, _Route4CooltrainerF2BattleText, _Route4CooltrainerF2EndBattleText, Route4CooltrainerF2AfterBattleText
Route4TrainerHeader1:
	trainer EVENT_BEAT_ROUTE_4_TRAINER_1, 0, _Route4BattleText2, _Route4EndBattleText2, _Route4AfterBattleText2
Route4TrainerHeader2:
	trainer EVENT_BEAT_ROUTE_4_TRAINER_2, 0, _Route4BattleText3, _Route4EndBattleText3, _Route4AfterBattleText3
Route4TrainerHeader3:
	trainer EVENT_BEAT_ROUTE_4_TRAINER_3, 4, _Route4BattleText4, _Route4EndBattleText4, _Route4AfterBattleText4
	db -1 ; end

Route4CooltrainerF2Text:
	script_trainer Route4TrainerHeader0

Route4Text3:
	script_trainer Route4TrainerHeader1

Route4Text4:
	script_trainer Route4TrainerHeader2

Route4Text5:
	script_trainer Route4TrainerHeader3

Route4CooltrainerF2AfterBattleText:
	text_far _Route4CooltrainerF2AfterBattleText
	text_asm
	lb hl, DEX_PARAS, LASS
	ld de, LearnsetLove
	predef_jump LearnsetTrainerScript
