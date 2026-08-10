; PureRGBnote: ADDED: new trainers were added to this location
ASSERT BANK(ReplaceMansionTileBlockList) == BANK(PokemonMansion3F_Script)
ASSERT BANK(PokemonMansionSwitchScript) == BANK(PokemonMansion3F_Script)

PokemonMansion3F_Script:
	call Mansion3CheckReplaceSwitchDoorBlocks
	call EnableAutoTextBoxDrawing
	ld hl, Mansion3TrainerHeaders
	ld de, PokemonMansion3F_ScriptPointers
	ld bc, wPokemonMansion3FCurScript
	jp ExecuteCustomMapScriptInTable

Mansion3CheckReplaceSwitchDoorBlocks:
	call WasMapJustLoaded
	ret z
	ld hl, Mansion3TileBlockReplacementCoords
	ld de, Mansion3TileBlockReplacementIDsOnOff
	CheckEvent EVENT_MANSION_SWITCH_ON
	jr nz, .switchTurnedOn
	inc de
.switchTurnedOn
	jp ReplaceMansionTileBlockList

Mansion3TileBlockReplacementCoords:
	db  2,  7
	db  5,  7
	db -1

Mansion3TileBlockReplacementIDsOnOff:
	db  $5f, $0e
	db  $0e, $5f

PokemonMansion3F_ScriptPointers:
	def_script_pointers
	dw_const PokemonMansion3FDefaultScript,         SCRIPT_POKEMONMANSION3F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_POKEMONMANSION3F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_POKEMONMANSION3F_END_BATTLE

PokemonMansion3FDefaultScript:
	ld hl, .holeCoords
	call .isPlayerFallingDownHole
	ld a, [wWhichDungeonWarp]
	and a
	jp z, CheckFightingMapTrainers
	cp $3
	ld a, POKEMON_MANSION_1F
	jr nz, .fellDownHoleTo1F
	ld a, POKEMON_MANSION_2F
.fellDownHoleTo1F
	ld [wDungeonWarpDestinationMap], a
	ret

.holeCoords:
	dbmapcoord 16, 14
	dbmapcoord 17, 14
	dbmapcoord 19, 14
	db -1 ; end

.isPlayerFallingDownHole:
	xor a
	ld [wWhichDungeonWarp], a
	ld a, [wStatusFlags3]
	bit BIT_ON_DUNGEON_WARP, a
	ret nz
	call ArePlayerCoordsInArray
	ret nc
	ld a, [wCoordIndex]
	ld [wWhichDungeonWarp], a
	ld hl, wStatusFlags3
	set BIT_ON_DUNGEON_WARP, [hl]
	ld hl, wStatusFlags6
	set BIT_DUNGEON_WARP, [hl]
	ret

Mansion3Script_Switches::
	ld b, TEXT_POKEMONMANSION3F_SWITCH
	jp PokemonMansionSwitchScript

PokemonMansion3F_TextPointers:
	def_text_pointers
	dba_const PokemonMansion3FSuperNerdText,  TEXT_POKEMONMANSION3F_SUPER_NERD
	dba_const PokemonMansion3FScientistText,  TEXT_POKEMONMANSION3F_SCIENTIST
	dba_const Mansion3Text3,                  TEXT_POKEMONMANSION3F_CHANNELER
	dba_const PickUpItemText,                 TEXT_POKEMONMANSION3F_ITEM1
	dba_const PickUpItemText,                 TEXT_POKEMONMANSION3F_ITEM2
	dba_const _PokemonMansion3FDiaryText,     TEXT_POKEMONMANSION3F_DIARY
	dba_const PokemonMansionSwitchText,       TEXT_POKEMONMANSION3F_SWITCH

Mansion3TrainerHeaders:
	def_trainers
Mansion3TrainerHeader0:
	trainer EVENT_BEAT_MANSION_3_TRAINER_0, 0, _PokemonMansion3FSuperNerdBattleText, _PokemonMansion3FSuperNerdEndBattleText, _PokemonMansion3FSuperNerdAfterBattleText
Mansion3TrainerHeader1:
	trainer EVENT_BEAT_MANSION_3_TRAINER_1, 2, _PokemonMansion3FScientistBattleText, _PokemonMansion3FScientistEndBattleText, _PokemonMansion3FScientistAfterBattleText
Mansion3TrainerHeader2:
	trainer EVENT_BEAT_MANSION_3_TRAINER_2, 0, _Mansion3BattleText3, _Mansion3EndBattleText3, _Mansion3AfterBattleText3
	db -1 ; end

PokemonMansion3FSuperNerdText:
	script_trainer Mansion3TrainerHeader0

PokemonMansion3FScientistText:
	script_trainer Mansion3TrainerHeader1

Mansion3Text3:
	script_trainer Mansion3TrainerHeader2
