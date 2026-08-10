PokemonTower4F_Script:
	ld hl, PokemonTower4TrainerHeaders
	ld de, PokemonTower4F_ScriptPointers
	ld bc, wPokemonTower4FCurScript
	jp ExecuteCustomMapScriptInTable

PokemonTower4F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_POKEMONTOWER4F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_POKEMONTOWER4F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_POKEMONTOWER4F_END_BATTLE

PokemonTower4F_TextPointers:
	def_text_pointers
	dba_const PokemonTower4FChanneler1Text, TEXT_POKEMONTOWER4F_CHANNELER1
	dba_const PokemonTower4FChanneler2Text, TEXT_POKEMONTOWER4F_CHANNELER2
	dba_const PokemonTower4FChanneler3Text, TEXT_POKEMONTOWER4F_CHANNELER3
	dba_const PickUp3ItemText,              TEXT_POKEMONTOWER4F_ITEM1
	dba_const PickUpItemText,               TEXT_POKEMONTOWER4F_ITEM2
	dba_const PickUpItemText,               TEXT_POKEMONTOWER4F_ITEM3

PokemonTower4TrainerHeaders:
	def_trainers
PokemonTower4TrainerHeader0:
	trainer EVENT_BEAT_POKEMONTOWER_4_TRAINER_0, 2, _PokemonTower4FChanneler1BattleText, _PokemonTower4FChanneler1EndBattleText, _PokemonTower4FChanneler1AfterBattleText
PokemonTower4TrainerHeader1:
	trainer EVENT_BEAT_POKEMONTOWER_4_TRAINER_1, 2, _PokemonTower4FChanneler2BattleText, _PokemonTower4FChanneler2EndBattleText, _PokemonTower4FChanneler2AfterBattleText
PokemonTower4TrainerHeader2:
	trainer EVENT_BEAT_POKEMONTOWER_4_TRAINER_2, 2, _PokemonTower4FChanneler3BattleText, _PokemonTower4FChanneler3EndBattleText, _PokemonTower4FChanneler3AfterBattleText
	db -1 ; end

PokemonTower4FChanneler1Text:
	script_trainer PokemonTower4TrainerHeader0

PokemonTower4FChanneler2Text:
	script_trainer PokemonTower4TrainerHeader1

PokemonTower4FChanneler3Text:
	script_trainer PokemonTower4TrainerHeader2
