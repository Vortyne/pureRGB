; PureRGBnote: ADDED: new trainers on this route.
Route5_Script:
	ld hl, Route5TrainerHeaders
	ld de, Route5_ScriptPointers
	ld bc, wRoute5CurScript
	jp ExecuteCustomMapScriptInTable

Route5_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROUTE5_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE5_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE5_END_BATTLE

Route5_TextPointers:
	def_text_pointers
	dba_const Route5Rookie1Text,              TEXT_ROUTE5_ROOKIE1
	dba_const Route5Rookie2Text,              TEXT_ROUTE5_ROOKIE2
	dba_const Route5Rookie3Text,              TEXT_ROUTE5_ROOKIE3
	dba_const Route5TamerText,                TEXT_ROUTE5_TAMER
	dba_const _Route5BugCatcherText,           TEXT_ROUTE5_BUG_CATCHER
	dba_const PickUpItemText,                 TEXT_ROUTE5_ITEM1 ; PureRGBnote: ADDED: new item on this route.
	dba_const _Route5UndergroundPathSignText,  TEXT_ROUTE5_UNDERGROUND_PATH_SIGN

Route5TrainerHeaders:
	def_trainers 1
Route5TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_5_TRAINER_0, 3, _Route5BattleText1, _Route5EndBattleText1, _Route5AfterBattleText1
Route5TrainerHeader1:
	trainer EVENT_BEAT_ROUTE_5_TRAINER_1, 3, _Route5BattleText2, _Route5EndBattleText2, Route5AfterBattleText2
Route5TrainerHeader2:
	trainer EVENT_BEAT_ROUTE_5_TRAINER_2, 3, _Route5BattleText3, _Route5EndBattleText3, Route5AfterBattleText3
Route5TrainerHeader3:
	trainer EVENT_BEAT_ROUTE_5_TRAINER_3, 3, _Route5BattleText4, _Route5EndBattleText4, _Route5AfterBattleText4
	db -1 ; end

Route5Rookie1Text:
	script_trainer Route5TrainerHeader0

Route5Rookie2Text:
	script_trainer Route5TrainerHeader1

Route5Rookie3Text:
	script_trainer Route5TrainerHeader2

Route5TamerText:
	script_trainer Route5TrainerHeader3

Route5AfterBattleText2:
	text_far _Route5AfterBattleText2
	text_asm
	lb hl, DEX_CHARMELEON, ROOKIE
	ld de, Route5CharmeleonLearnset
	predef_jump LearnsetTrainerScript

Route5AfterBattleText3:
	text_far _Route5AfterBattleText3
	text_asm
	lb hl, DEX_SQUIRTLE, ROOKIE
	ld de, Route5SquirtleLearnset
	predef_jump LearnsetTrainerScript
