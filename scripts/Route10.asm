; PureRGBnote: ADDED: new trainer in this location

Route10_Script:
	call WasMapJustLoaded
	jr nz, .mapLoad
	bit BIT_CROSSED_MAP_CONNECTION, [hl]
	res BIT_CROSSED_MAP_CONNECTION, [hl]
	jr nz, .mapLoad
	jr .skip
.mapLoad
	CheckEvent FLAG_BALL_DESIGNER_TURNED_OFF
	jr nz, .skip
	lb bc, SPRITESTATEDATA2_MAPX, ROUTE10_FLAREON
	call GetFromSpriteStateData2
	ld [hl], 20 + 4 ; move flareon
.skip
	ld hl, Route10TrainerHeaders
	ld de, Route10_ScriptPointers
	ld bc, wRoute10CurScript
	jp ExecuteCustomMapScriptInTable

Route10_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROUTE10_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE10_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE10_END_BATTLE

Route10_TextPointers:
	def_text_pointers
	dba_const Route10SuperNerd1Text,     TEXT_ROUTE10_SUPER_NERD1
	dba_const Route10Hiker1Text,         TEXT_ROUTE10_HIKER1
	dba_const Route10SuperNerd2Text,     TEXT_ROUTE10_SUPER_NERD2
	dba_const Route10CooltrainerF1Text,  TEXT_ROUTE10_COOLTRAINER_F1
	dba_const Route10Hiker2Text,         TEXT_ROUTE10_HIKER2
	dba_const Route10CooltrainerF2Text,  TEXT_ROUTE10_COOLTRAINER_F2
	dba_const Route10Text7,              TEXT_ROUTE10_SUPER_NERD3
	dba_const _Route10FlareonText,        TEXT_ROUTE10_FLAREON
	dba_const PickUpItemText,            TEXT_ROUTE10_ITEM1 ; PureRGBnote: ADDED: new item in this location 
	dba_const _Route10RockTunnelSignText, TEXT_ROUTE10_ROCKTUNNEL_NORTH_SIGN
	dba_const PokeCenterSignText,        TEXT_ROUTE10_POKECENTER_SIGN
	dba_const _Route10RockTunnelSignText, TEXT_ROUTE10_ROCKTUNNEL_SOUTH_SIGN
	dba_const _Route10PowerPlantSignText, TEXT_ROUTE10_POWERPLANT_SIGN

Route10TrainerHeaders:
	def_trainers
Route10TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_10_TRAINER_0, 4, _Route10SuperNerd1BattleText, _Route10SuperNerd1EndBattleText, Route10SuperNerd1AfterBattleText
Route10TrainerHeader1:
	trainer EVENT_BEAT_ROUTE_10_TRAINER_1, 3, _Route10Hiker1BattleText, _Route10Hiker1EndBattleText, _Route10Hiker1AfterBattleText
Route10TrainerHeader2:
	trainer EVENT_BEAT_ROUTE_10_TRAINER_2, 4, _Route10SuperNerd2BattleText, _Route10SuperNerd2EndBattleText, _Route10SuperNerd2AfterBattleText
Route10TrainerHeader3:
	trainer EVENT_BEAT_ROUTE_10_TRAINER_3, 3, _Route10CooltrainerF1BattleText, _Route10CooltrainerF1EndBattleText, _Route10CooltrainerF1AfterBattleText
Route10TrainerHeader4:
	trainer EVENT_BEAT_ROUTE_10_TRAINER_4, 2, _Route10Hiker2BattleText, _Route10Hiker2EndBattleText, _Route10Hiker2AfterBattleText
Route10TrainerHeader5:
	trainer EVENT_BEAT_ROUTE_10_TRAINER_5, 2, _Route10CooltrainerF2BattleText, _Route10CooltrainerF2EndBattleText, _Route10CooltrainerF2AfterBattleText
Route10TrainerHeader6:
	trainer EVENT_BEAT_ROUTE_10_TRAINER_6, 2, _Route10BattleText7, _Route10EndBattleText7, _Route10AfterBattleText7
	db -1 ; end

Route10SuperNerd1Text:
	script_trainer Route10TrainerHeader0

Route10Hiker1Text:
	script_trainer Route10TrainerHeader1

Route10SuperNerd2Text:
	script_trainer Route10TrainerHeader2

Route10CooltrainerF1Text:
	script_trainer Route10TrainerHeader3

Route10Hiker2Text:
	script_trainer Route10TrainerHeader4

Route10CooltrainerF2Text:
	script_trainer Route10TrainerHeader5

Route10Text7:
	script_trainer Route10TrainerHeader6

Route10SuperNerd1AfterBattleText:
	text_far _Route10SuperNerd1AfterBattleText
	text_asm
	lb hl, DEX_ELECTABUZZ, POKEMANIAC
	ld de, ElectabuzzLearnsetText
	predef_jump LearnsetTrainerScript

Route10FlareonHiddenText::
	CheckEvent FLAG_BALL_DESIGNER_TURNED_OFF
	ret nz
	ld c, DEX_FLAREON - 1
  	callfar SetMonSeen
	ld a, TEXT_ROUTE10_FLAREON
	ldh [hTextID], a
	jp DisplayTextID
