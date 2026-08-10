; PureRGBnote: ADDED: trainers in this location
; PureRGBnote: CHANGED: if you found the secret path from saffron to here, it will be open on loading the map.

UndergroundPathNorthSouth_Script:
	call UndergroundPathNorthSouthOnMapLoad
	ld hl, UndergroundPathNorthSouthTrainerHeaders
	ld de, UndergroundPathNorthSouth_ScriptPointers
	ld bc, wUndergroundPathNorthSouthCurScript
	jp ExecuteCustomMapScriptInTable

UndergroundPathNorthSouthOnMapLoad:
	call WasMapJustLoaded
	ret z
	ld a, ROUTE_5
	ld [wLastMap], a
	CheckEvent EVENT_FOUND_SECRET_DIG_TUNNEL
	ret nz
	lb bc, 11, 0
	ld a, 13
	ld [wNewTileBlockID], a
	jp ReplaceTileBlock

UndergroundPathNorthSouth_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_UNDERGROUNDPATHNORTHSOUTH_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_UNDERGROUNDPATHNORTHSOUTH_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_UNDERGROUNDPATHNORTHSOUTH_END_BATTLE

UndergroundPathNorthSouth_TextPointers:
	def_text_pointers
	dba_const UndergroundPathNorthSouthTrainer1Text,     TEXT_UNDERGROUNDPATHNORTHSOUTH_GENTLEMAN
	dba_const UndergroundPathNorthSouthTrainer2Text,     TEXT_UNDERGROUNDPATHNORTHSOUTH_COOL_KID1
	dba_const UndergroundPathNorthSouthTrainer3Text,     TEXT_UNDERGROUNDPATHNORTHSOUTH_COOL_KID2

UndergroundPathNorthSouthTrainerHeaders:
	def_trainers 5
UndergroundPathNorthSouthTrainerHeader0:
	trainer EVENT_BEAT_UNDERGROUND_PATH_NORTH_SOUTH_TRAINER_0, 0, _UndergroundPathNorthSouthBattleText1, _UndergroundPathNorthSouthEndBattleText1, _UndergroundPathNorthSouthAfterBattleText1
UndergroundPathNorthSouthTrainerHeader1:
	trainer EVENT_BEAT_UNDERGROUND_PATH_NORTH_SOUTH_TRAINER_1, 0, _UndergroundPathNorthSouthBattleText2, _UndergroundPathNorthSouthEndBattleText2, _UndergroundPathNorthSouthAfterBattleText2
UndergroundPathNorthSouthTrainerHeader2:
	trainer EVENT_BEAT_UNDERGROUND_PATH_NORTH_SOUTH_TRAINER_2, 0, _UndergroundPathNorthSouthBattleText3, _UndergroundPathNorthSouthEndBattleText3, UndergroundPathNorthSouthAfterBattleText3
	db -1 ;end

UndergroundPathNorthSouthTrainer1Text:
	script_trainer UndergroundPathNorthSouthTrainerHeader0

UndergroundPathNorthSouthTrainer2Text:
	script_trainer UndergroundPathNorthSouthTrainerHeader1

UndergroundPathNorthSouthTrainer3Text:
	script_trainer UndergroundPathNorthSouthTrainerHeader2

UndergroundPathNorthSouthAfterBattleText3:
	text_far _UndergroundPathNorthSouthAfterBattleText3
	text_asm
	lb hl, DEX_KRABBY, COOL_KID
	ld de, LearnsetKrabbyKid
	predef_jump LearnsetTrainerScript
