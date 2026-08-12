; PureRGBnote: ADDED: new trainers on this route.

Route18_Script:
	ld hl, Route18TrainerHeaders
	ld de, Route18_ScriptPointers
	ld bc, wRoute18CurScript
	jp ExecuteCustomMapScriptInTable

Route18_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROUTE18_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE18_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE18_END_BATTLE

Route18_TextPointers:
	def_text_pointers
	dba_const Route18CooltrainerM1Text,    TEXT_ROUTE18_COOLTRAINER_M1
	dba_const Route18CooltrainerM2Text,    TEXT_ROUTE18_COOLTRAINER_M2
	dba_const Route18CooltrainerM3Text,    TEXT_ROUTE18_COOLTRAINER_M3
	dba_const Route18Text4,                TEXT_ROUTE18_TAMER
	dba_const Route18Text5,                TEXT_ROUTE18_ROCKER
	dba_const _Route18SignText,            TEXT_ROUTE18_SIGN
	dba_const _Route18CyclingRoadSignText, TEXT_ROUTE18_CYCLING_ROAD_SIGN

Route18TrainerHeaders:
	def_trainers
Route18TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_18_TRAINER_0, 3, _Route18CooltrainerM1BattleText, _Route18CooltrainerM1EndBattleText, _Route18CooltrainerM1AfterBattleText
Route18TrainerHeader1:
	trainer EVENT_BEAT_ROUTE_18_TRAINER_1, 3, _Route18CooltrainerM2BattleText, _Route18CooltrainerM2EndBattleText, Route18CooltrainerM2AfterBattleText
Route18TrainerHeader2:
	trainer EVENT_BEAT_ROUTE_18_TRAINER_2, 4, _Route18CooltrainerM3BattleText, _Route18CooltrainerM3EndBattleText, _Route18CooltrainerM3AfterBattleText
Route18TrainerHeader3:
	trainer EVENT_BEAT_ROUTE_18_TRAINER_3, 3, _Route18BattleText4, _Route18EndBattleText4, _Route18AfterBattleText4
Route18TrainerHeader4:
	trainer EVENT_BEAT_ROUTE_18_TRAINER_4, 2, _Route18BattleText5, _Route18EndBattleText5, _Route18AfterBattleText5
	db -1 ; end

Route18CooltrainerM1Text:
	script_trainer Route18TrainerHeader0

Route18CooltrainerM2Text:
	script_trainer Route18TrainerHeader1

Route18CooltrainerM3Text:
	script_trainer Route18TrainerHeader2

Route18Text4:
	script_trainer Route18TrainerHeader3

Route18Text5:
	script_trainer Route18TrainerHeader4

Route18CooltrainerM2AfterBattleText:
	text_far _Route18CooltrainerM2AfterBattleText
	text_asm
	lb hl, DEX_AERODACTYL, BIRD_KEEPER
	ld de, Route18AerodactylLearnsetText
	predef_jump LearnsetTrainerScript
