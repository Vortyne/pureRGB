; PureRGBnote: ADDED: new trainers on this route.

Route7_Script:
	ld hl, Route7TrainerHeaders
	ld de, Route7_ScriptPointers
	ld bc, wRoute7CurScript
	jp ExecuteCustomMapScriptInTable

Route7_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROUTE7_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE7_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE7_END_BATTLE

Route7_TextPointers:
	def_text_pointers
	dba_const Route7Gambler1Text,            TEXT_ROUTE7_GAMBLER1
	dba_const Route7Gambler2Text,            TEXT_ROUTE7_GAMBLER2
	dba_const _Route7UndergroundPathSignText, TEXT_ROUTE7_UNDERGROUND_PATH_SIGN

Route7TrainerHeaders:
	def_trainers 1
Route7TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_7_TRAINER_0, 1, _Route7BattleText1, _Route7EndBattleText1, _Route7AfterBattleText1
Route7TrainerHeader1:
	trainer EVENT_BEAT_ROUTE_7_TRAINER_1, 1, _Route7BattleText2, _Route7EndBattleText2, _Route7AfterBattleText2
	db -1 ; end

Route7Gambler1Text:
	script_trainer Route7TrainerHeader0

Route7Gambler2Text:
	script_trainer Route7TrainerHeader1
