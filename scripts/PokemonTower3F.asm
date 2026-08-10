PokemonTower3F_Script:
	ld hl, PokemonTower3TrainerHeaders
	ld de, PokemonTower3F_ScriptPointers
	ld bc, wPokemonTower3FCurScript
	jp ExecuteCustomMapScriptInTable

PokemonTower3F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_POKEMONTOWER3F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_POKEMONTOWER3F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_POKEMONTOWER3F_END_BATTLE

PokemonTower3F_TextPointers:
	def_text_pointers
	dba_const PokemonTower3FChanneler1Text, TEXT_POKEMONTOWER3F_CHANNELER1
	dba_const PokemonTower3FChanneler2Text, TEXT_POKEMONTOWER3F_CHANNELER2
	dba_const PokemonTower3FChanneler3Text, TEXT_POKEMONTOWER3F_CHANNELER3
	dba_const PickUp5ItemText,              TEXT_POKEMONTOWER3F_ITEM1

PokemonTower3TrainerHeaders:
	def_trainers
PokemonTower3TrainerHeader0:
	trainer EVENT_BEAT_POKEMONTOWER_3_TRAINER_0, 2, _PokemonTower3FChanneler1BattleText, _PokemonTower3FChanneler1EndBattleText, _PokemonTower3FChanneler1AfterBattleText
PokemonTower3TrainerHeader1:
	trainer EVENT_BEAT_POKEMONTOWER_3_TRAINER_1, 3, _PokemonTower3FChanneler2BattleText, _PokemonTower3FChanneler2EndBattleText, _PokemonTower3FChanneler2AfterBattleText
PokemonTower3TrainerHeader2:
	trainer EVENT_BEAT_POKEMONTOWER_3_TRAINER_2, 2, _PokemonTower3FChanneler3BattleText, _PokemonTower3FChanneler3EndBattleText, _PokemonTower3FChanneler3AfterBattleText
	db -1 ; end

PokemonTower3FChanneler1Text:
	script_trainer PokemonTower3TrainerHeader0

PokemonTower3FChanneler2Text:
	script_trainer PokemonTower3TrainerHeader1

PokemonTower3FChanneler3Text:
	script_trainer PokemonTower3TrainerHeader2
