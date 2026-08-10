; PureRGBnote: ADDED: new trainers were added to this location
ASSERT BANK(ReplaceMansionTileBlockList) == BANK(PokemonMansion2F_Script)
ASSERT BANK(PokemonMansionSwitchScript) == BANK(PokemonMansion2F_Script)


PokemonMansion2F_Script:
	call Mansion2CheckReplaceSwitchDoorBlocks
	ld hl, Mansion2TrainerHeaders
	ld de, PokemonMansion2F_ScriptPointers
	ld bc, wPokemonMansion2FCurScript
	jp ExecuteCustomMapScriptInTable

Mansion2CheckReplaceSwitchDoorBlocks:
	call WasMapJustLoaded
	ret z
	ld hl, Mansion2TileBlockReplacementCoords
	ld de, Mansion2TileBlockReplacementIDsOnOff
	CheckEvent EVENT_MANSION_SWITCH_ON
	jr nz, .switchTurnedOn
	inc de
.switchTurnedOn
	jp ReplaceMansionTileBlockList

Mansion2TileBlockReplacementCoords:
	db  2,  4
	db  4,  9
	db 11,  3
	db -1

Mansion2TileBlockReplacementIDsOnOff:
	db  $5f, $0e
	db  $0e, $54 
	db  $0e, $5f

Mansion2Script_Switches::
	ld b, TEXT_POKEMONMANSION2F_SWITCH
	jp PokemonMansionSwitchScript

PokemonMansion2F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_POKEMONMANSION2F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_POKEMONMANSION2F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_POKEMONMANSION2F_END_BATTLE

PokemonMansion2F_TextPointers:
	def_text_pointers
	dba_const PokemonMansion2FSuperNerdText, TEXT_POKEMONMANSION2F_SUPER_NERD
	dba_const Mansion2Trainer2,              TEXT_POKEMONMANSION2F_COOLTRAINER_M
	dba_const Mansion2Trainer3,              TEXT_POKEMONMANSION2F_COOLTRAINER_F1
	dba_const Mansion2Trainer4,              TEXT_POKEMONMANSION2F_SCIENTIST
	dba_const Mansion2Trainer5,              TEXT_POKEMONMANSION2F_COOLTRAINER_F2
	dba_const PickUpItemText,                TEXT_POKEMONMANSION2F_ITEM1
	dba_const _PokemonMansion2FDiary1Text,    TEXT_POKEMONMANSION2F_DIARY1
	dba_const _PokemonMansion2FDiary2Text,    TEXT_POKEMONMANSION2F_DIARY2
	dba_const PokemonMansion2FDiary3Text,    TEXT_POKEMONMANSION2F_DIARY3
	dba_const PokemonMansionSwitchText,      TEXT_POKEMONMANSION2F_SWITCH

Mansion2TrainerHeaders:
	def_trainers
Mansion2TrainerHeader0:
	trainer EVENT_BEAT_MANSION_2_TRAINER_0, 0, _PokemonMansion2FSuperNerdBattleText, _PokemonMansion2FSuperNerdEndBattleText, _PokemonMansion2FSuperNerdAfterBattleText
Mansion2TrainerHeader1:
	trainer EVENT_BEAT_MANSION_2_TRAINER_1, 0, _Mansion2BattleText2, _Mansion2EndBattleText2, _Mansion2AfterBattleText2
Mansion2TrainerHeader2:
	trainer EVENT_BEAT_MANSION_2_TRAINER_2, 0, _Mansion2BattleText3, _Mansion2EndBattleText3, _Mansion2AfterBattleText3
Mansion2TrainerHeader3:
	trainer EVENT_BEAT_MANSION_2_TRAINER_3, 3, _Mansion2BattleText4, _Mansion2EndBattleText4, _Mansion2AfterBattleText4
Mansion2TrainerHeader4:
	trainer EVENT_BEAT_MANSION_2_TRAINER_4, 0, _Mansion2BattleText5, _Mansion2EndBattleText5, _Mansion2AfterBattleText5
	db -1 ; end

PokemonMansion2FSuperNerdText:
	script_trainer Mansion2TrainerHeader0

Mansion2Trainer2:
	script_trainer Mansion2TrainerHeader1

Mansion2Trainer3:
	script_trainer Mansion2TrainerHeader2

Mansion2Trainer4:
	script_trainer Mansion2TrainerHeader3

Mansion2Trainer5:
	script_trainer Mansion2TrainerHeader4

PokemonMansion2FDiary3Text:
	text_far _PokemonMansion2FDiary3Text
	text_asm
	; check if player has seen MEW
	ld c, DEX_MEW - 1
	ld hl, wPokedexSeen
	ld b, FLAG_TEST
	call FlagAction
	jr z, .done
	CheckEvent FLAG_MEW_LEARNSET
	jr nz, .done
	ld d, DEX_MEW
	jpfar KeepReadingBookLearnset
.done
	rst TextScriptEnd
