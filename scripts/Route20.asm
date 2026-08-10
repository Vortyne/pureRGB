Route20_Script:
	CheckEvent EVENT_BEAT_ARTICUNO
	jr z, .noDragonair
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_SUBZERO_BALL
	jr nz, .noDragonair
	SetEvent EVENT_SEAFOAM_DRAGONAIR_PRESENT
.noDragonair
	ld hl, Route20TrainerHeaders
	ld de, Route20_ScriptPointers
	ld bc, wRoute20CurScript
	jp ExecuteCustomMapScriptInTable

Route20_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROUTE20_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE20_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE20_END_BATTLE

Route20_TextPointers:
	def_text_pointers
	dba_const Route20Swimmer1Text,           TEXT_ROUTE20_SWIMMER1
	dba_const Route20Swimmer2Text,           TEXT_ROUTE20_SWIMMER2
	dba_const Route20Swimmer3Text,           TEXT_ROUTE20_SWIMMER3
	dba_const Route20Swimmer4Text,           TEXT_ROUTE20_SWIMMER4
	dba_const Route20Swimmer5Text,           TEXT_ROUTE20_SWIMMER5
	dba_const Route20Swimmer6Text,           TEXT_ROUTE20_SWIMMER6
	dba_const Route20CooltrainerMText,       TEXT_ROUTE20_COOLTRAINER_M
	dba_const Route20Swimmer7Text,           TEXT_ROUTE20_SWIMMER7
	dba_const Route20Swimmer8Text,           TEXT_ROUTE20_SWIMMER8
	dba_const Route20Swimmer9Text,           TEXT_ROUTE20_SWIMMER9
	dba_const _Route20SeafoamIslandsSignText, TEXT_ROUTE20_SEAFOAM_ISLANDS_WEST_SIGN
	dba_const _Route20SeafoamIslandsSignText, TEXT_ROUTE20_SEAFOAM_ISLANDS_EAST_SIGN

Route20TrainerHeaders:
	def_trainers
Route20TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_20_TRAINER_0, 4, _Route20Swimmer1BattleText, _Route20Swimmer1EndBattleText, _Route20Swimmer1AfterBattleText
Route20TrainerHeader1:
	trainer EVENT_BEAT_ROUTE_20_TRAINER_1, 4, _Route20Swimmer2BattleText, _Route20Swimmer2EndBattleText, _Route20Swimmer2AfterBattleText
Route20TrainerHeader2:
	trainer EVENT_BEAT_ROUTE_20_TRAINER_2, 2, _Route20Swimmer3BattleText, _Route20Swimmer3EndBattleText, _Route20Swimmer3AfterBattleText
Route20TrainerHeader3:
	trainer EVENT_BEAT_ROUTE_20_TRAINER_3, 4, _Route20Swimmer4BattleText, _Route20Swimmer4EndBattleText, _Route20Swimmer4AfterBattleText
Route20TrainerHeader4:
	trainer EVENT_BEAT_ROUTE_20_TRAINER_4, 3, _Route20Swimmer5BattleText, _Route20Swimmer5EndBattleText, _Route20Swimmer5AfterBattleText
Route20TrainerHeader5:
	trainer EVENT_BEAT_ROUTE_20_TRAINER_5, 4, _Route20Swimmer6BattleText, _Route20Swimmer6EndBattleText, _Route20Swimmer6AfterBattleText
Route20TrainerHeader6:
	trainer EVENT_BEAT_ROUTE_20_TRAINER_6, 2, _Route20CooltrainerMBattleText, _Route20CooltrainerMEndBattleText, _Route20CooltrainerMAfterBattleText
Route20TrainerHeader7:
	trainer EVENT_BEAT_ROUTE_20_TRAINER_7, 4, _Route20Swimmer7BattleText, _Route20Swimmer7EndBattleText, _Route20Swimmer7AfterBattleText
Route20TrainerHeader8:
	trainer EVENT_BEAT_ROUTE_20_TRAINER_8, 3, _Route20Swimmer8BattleText, _Route20Swimmer8EndBattleText, _Route20Swimmer8AfterBattleText
Route20TrainerHeader9:
	trainer EVENT_BEAT_ROUTE_20_TRAINER_9, 4, _Route20Swimmer9BattleText, _Route20Swimmer9EndBattleText, _Route20Swimmer9AfterBattleText
	db -1 ; end

Route20Swimmer1Text:
	script_trainer Route20TrainerHeader0

Route20Swimmer2Text:
	script_trainer Route20TrainerHeader1

Route20Swimmer3Text:
	script_trainer Route20TrainerHeader2

Route20Swimmer4Text:
	script_trainer Route20TrainerHeader3

Route20Swimmer5Text:
	script_trainer Route20TrainerHeader4

Route20Swimmer6Text:
	script_trainer Route20TrainerHeader5

Route20CooltrainerMText:
	script_trainer Route20TrainerHeader6

Route20Swimmer7Text:
	script_trainer Route20TrainerHeader7

Route20Swimmer8Text:
	script_trainer Route20TrainerHeader8

Route20Swimmer9Text:
	script_trainer Route20TrainerHeader9
