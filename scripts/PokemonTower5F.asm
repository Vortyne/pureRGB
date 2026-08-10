PokemonTower5F_Script:
	ld hl, PokemonTower5TrainerHeaders
	ld de, PokemonTower5F_ScriptPointers
	ld bc, wPokemonTower5FCurScript
	jp ExecuteCustomMapScriptInTable
	
PokemonTower5F_ScriptPointers:
	def_script_pointers
	dw_const PokemonTower5FDefaultScript,           SCRIPT_POKEMONTOWER5F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_POKEMONTOWER5F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_POKEMONTOWER5F_END_BATTLE

PokemonTower5FDefaultScript:
	ld hl, PokemonTower5FPurifiedZoneCoords
	call ArePlayerCoordsInArray
	jr c, .in_purified_zone
	ld hl, wStatusFlags4
	res BIT_NO_BATTLES, [hl]
	ResetEvent EVENT_IN_PURIFIED_ZONE
	jp CheckFightingMapTrainers
.in_purified_zone
	CheckAndSetEvent EVENT_IN_PURIFIED_ZONE
	ret nz
	xor a
	ldh [hJoyHeld], a
	call DisableDpad
	ld hl, wStatusFlags4
	set BIT_NO_BATTLES, [hl]
	predef HealParty
	call GBFadeOutToWhite
	ld c, 6
	rst DelayFrames
	call GBFadeInFromWhite
	ld a, TEXT_POKEMONTOWER5F_PURIFIEDZONE
	ldh [hTextID], a
	call DisplayTextID
	jp EnableAllJoypad

PokemonTower5FPurifiedZoneCoords:
	dbmapcoord 10,  8
	dbmapcoord 11,  8
	dbmapcoord 10,  9
	dbmapcoord 11,  9
	db -1 ; end

PokemonTower5F_TextPointers:
	def_text_pointers
	dba_const _PokemonTower5FChanneler1Text,   TEXT_POKEMONTOWER5F_CHANNELER1
	dba_const PokemonTower5FChanneler2Text,    TEXT_POKEMONTOWER5F_CHANNELER2
	dba_const PokemonTower5FChanneler3Text,    TEXT_POKEMONTOWER5F_CHANNELER3
	dba_const PokemonTower5FChanneler4Text,    TEXT_POKEMONTOWER5F_CHANNELER4
	dba_const PokemonTower5FChanneler5Text,    TEXT_POKEMONTOWER5F_CHANNELER5
	dba_const PickUpItemText,                  TEXT_POKEMONTOWER5F_ITEM1
	dba_const _PokemonTower5FPurifiedZoneText, TEXT_POKEMONTOWER5F_PURIFIEDZONE

PokemonTower5TrainerHeaders:
	def_trainers 2
PokemonTower5TrainerHeader0:
	trainer EVENT_BEAT_POKEMONTOWER_5_TRAINER_0, 2, _PokemonTower5FChanneler2BattleText, _PokemonTower5FChanneler2EndBattleText, _PokemonTower5FChanneler2AfterBattleText
PokemonTower5TrainerHeader1:
	trainer EVENT_BEAT_POKEMONTOWER_5_TRAINER_1, 3, _PokemonTower5FChanneler3BattleText, _PokemonTower5FChanneler3EndBattleText, _PokemonTower5FChanneler3AfterBattleText
PokemonTower5TrainerHeader2:
	trainer EVENT_BEAT_POKEMONTOWER_5_TRAINER_2, 2, _PokemonTower5FChanneler4BattleText, _PokemonTower5FChanneler4EndBattleText, _PokemonTower5FChanneler4AfterBattleText
PokemonTower5TrainerHeader3:
	trainer EVENT_BEAT_POKEMONTOWER_5_TRAINER_3, 2, _PokemonTower5FChanneler5BattleText, _PokemonTower5FChanneler5EndBattleText, _PokemonTower5FChanneler5AfterBattleText
	db -1 ; end

PokemonTower5FChanneler2Text:
	script_trainer PokemonTower5TrainerHeader0

PokemonTower5FChanneler3Text:
	script_trainer PokemonTower5TrainerHeader1

PokemonTower5FChanneler4Text:
	script_trainer PokemonTower5TrainerHeader2

PokemonTower5FChanneler5Text:
	script_trainer PokemonTower5TrainerHeader3
