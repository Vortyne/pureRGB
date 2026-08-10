Route11_Script:
	ld hl, Route11TrainerHeaders
	ld de, Route11_ScriptPointers
	ld bc, wRoute11CurScript
	jp ExecuteCustomMapScriptInTable


Route11_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROUTE11_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE11_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE11_END_BATTLE

Route11_TextPointers:
	def_text_pointers
	dba_const Route11Gambler1Text,         TEXT_ROUTE11_GAMBLER1
	dba_const Route11Gambler2Text,         TEXT_ROUTE11_GAMBLER2
	dba_const Route11Youngster1Text,       TEXT_ROUTE11_YOUNGSTER1
	dba_const Route11SuperNerd1Text,       TEXT_ROUTE11_SUPER_NERD1
	dba_const Route11Youngster2Text,       TEXT_ROUTE11_YOUNGSTER2
	dba_const Route11Gambler3Text,         TEXT_ROUTE11_GAMBLER3
	dba_const Route11Gambler4Text,         TEXT_ROUTE11_GAMBLER4
	dba_const Route11Youngster3Text,       TEXT_ROUTE11_YOUNGSTER3
	dba_const Route11SuperNerd2Text,       TEXT_ROUTE11_SUPER_NERD2
	dba_const Route11Youngster4Text,       TEXT_ROUTE11_YOUNGSTER4
	dba_const PickUpItemText,              TEXT_ROUTE11_ITEM1 ; PureRGBnote: ADDED: new item in this location
	dba_const _Route11DiglettsCaveSignText, TEXT_ROUTE11_DIGLETTSCAVE_SIGN

Route11TrainerHeaders:
	def_trainers
Route11TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_11_TRAINER_0, 3, _Route11Gambler1BattleText, _Route11Gambler1EndBattleText, Route11Gambler1AfterBattleText
Route11TrainerHeader1:
	trainer EVENT_BEAT_ROUTE_11_TRAINER_1, 2, _Route11Gambler2BattleText, _Route11Gambler2EndBattleText, Route11Gambler2AfterBattleText
Route11TrainerHeader2:
	trainer EVENT_BEAT_ROUTE_11_TRAINER_2, 3, _Route11Youngster1BattleText, _Route11Youngster1EndBattleText, _Route11Youngster1AfterBattleText
Route11TrainerHeader3:
	trainer EVENT_BEAT_ROUTE_11_TRAINER_3, 3, _Route11SuperNerd1BattleText, _Route11SuperNerd1EndBattleText, Route11SuperNerd1AfterBattleText
Route11TrainerHeader4:
	trainer EVENT_BEAT_ROUTE_11_TRAINER_4, 4, _Route11Youngster2BattleText, _Route11Youngster2EndBattleText, _Route11Youngster2AfterBattleText
Route11TrainerHeader5:
	trainer EVENT_BEAT_ROUTE_11_TRAINER_5, 3, _Route11Gambler3BattleText, _Route11Gambler3EndBattleText, _Route11Gambler3AfterBattleText
Route11TrainerHeader6:
	trainer EVENT_BEAT_ROUTE_11_TRAINER_6, 3, _Route11Gambler4BattleText, _Route11Gambler4EndBattleText, _Route11Gambler4AfterBattleText
Route11TrainerHeader7:
	trainer EVENT_BEAT_ROUTE_11_TRAINER_7, 4, _Route11Youngster3BattleText, _Route11Youngster3EndBattleText, Route11Youngster3AfterBattleText
Route11TrainerHeader8:
	trainer EVENT_BEAT_ROUTE_11_TRAINER_8, 3, _Route11SuperNerd2BattleText, _Route11SuperNerd2EndBattleText, _Route11SuperNerd2AfterBattleText
Route11TrainerHeader9:
	trainer EVENT_BEAT_ROUTE_11_TRAINER_9, 4, _Route11Youngster4BattleText, _Route11Youngster4EndBattleText, _Route11Youngster4AfterBattleText
	db -1 ; end

Route11Gambler1Text:
	script_trainer Route11TrainerHeader0

Route11Gambler2Text:
	script_trainer Route11TrainerHeader1

Route11Youngster1Text:
	script_trainer Route11TrainerHeader2

Route11SuperNerd1Text:
	script_trainer Route11TrainerHeader3

Route11Youngster2Text:
	script_trainer Route11TrainerHeader4

Route11Gambler3Text:
	script_trainer Route11TrainerHeader5

Route11Gambler4Text:
	script_trainer Route11TrainerHeader6

Route11Youngster3Text:
	script_trainer Route11TrainerHeader7

Route11SuperNerd2Text:
	script_trainer Route11TrainerHeader8

Route11Youngster4Text:
	script_trainer Route11TrainerHeader9

Route11Gambler1AfterBattleText:
	text_far _Route11Gambler1AfterBattleText
	text_asm
	lb hl, DEX_VULPIX, GAMBLER
	ld de, LearnsetVulpixLuckyNumber
	predef_jump LearnsetTrainerScript

Route11Gambler2AfterBattleText:
	text_far _Route11Gambler2AfterBattleText
	text_asm
	lb hl, DEX_BELLSPROUT, GAMBLER
	ld de, LearnsetBellsprout
	predef_jump LearnsetTrainerScript

Route11SuperNerd1AfterBattleText:
	text_far _Route11SuperNerd1AfterBattleText
	text_asm
	lb hl, DEX_MAGNETON, ENGINEER
	ld de, LearnsetMagneton
	predef_jump LearnsetTrainerScript

Route11Youngster3AfterBattleText:
	text_far _Route11Youngster3AfterBattleText
	text_asm
	lb hl, DEX_STARYU, YOUNGSTER
	ld de, LearnsetStaryu
	predef_jump LearnsetTrainerScript
