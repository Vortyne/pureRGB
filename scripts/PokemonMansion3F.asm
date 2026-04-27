; PureRGBnote: ADDED: new trainers were added to this location
ASSERT BANK(ReplaceMansionTileBlockList) == BANK(PokemonMansion3F_Script)
ASSERT BANK(PokemonMansionSwitchScript) == BANK(PokemonMansion3F_Script)

PokemonMansion3F_Script:
	call Mansion3CheckReplaceSwitchDoorBlocks
	call EnableAutoTextBoxDrawing
	ld hl, Mansion3TrainerHeaders
	ld de, PokemonMansion3F_ScriptPointers
	ld a, [wPokemonMansion3FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonMansion3FCurScript], a
	ret

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
	dw_const PokemonMansion3FSuperNerdText, TEXT_POKEMONMANSION3F_SUPER_NERD
	dw_const PokemonMansion3FScientistText, TEXT_POKEMONMANSION3F_SCIENTIST
	dw_const Mansion3Text3,                 TEXT_POKEMONMANSION3F_CHANNELER
	dw_const PickUpItemText,                TEXT_POKEMONMANSION3F_ITEM1
	dw_const PickUpItemText,                TEXT_POKEMONMANSION3F_ITEM2
	dw_const PokemonMansion3FDiaryText,     TEXT_POKEMONMANSION3F_DIARY
	dw_const PokemonMansionSwitchText,      TEXT_POKEMONMANSION3F_SWITCH

Mansion3TrainerHeaders:
	def_trainers
Mansion3TrainerHeader0:
	trainer EVENT_BEAT_MANSION_3_TRAINER_0, 0, PokemonMansion3FSuperNerdBattleText, PokemonMansion3FSuperNerdEndBattleText, PokemonMansion3FSuperNerdAfterBattleText
Mansion3TrainerHeader1:
	trainer EVENT_BEAT_MANSION_3_TRAINER_1, 2, PokemonMansion3FScientistBattleText, PokemonMansion3FScientistEndBattleText, PokemonMansion3FScientistAfterBattleText
Mansion3TrainerHeader2:
	trainer EVENT_BEAT_MANSION_3_TRAINER_2, 0, Mansion3BattleText3, Mansion3EndBattleText3, Mansion3AfterBattleText3
	db -1 ; end

PokemonMansion3FSuperNerdText:
	text_asm
	ld hl, Mansion3TrainerHeader0
	jr PokemonMansion3FTalkToTrainer

PokemonMansion3FScientistText:
	text_asm
	ld hl, Mansion3TrainerHeader1
	jr PokemonMansion3FTalkToTrainer

Mansion3Text3:
	text_asm
	ld hl, Mansion3TrainerHeader2
PokemonMansion3FTalkToTrainer:
	call TalkToTrainer
	rst TextScriptEnd

PokemonMansion3FSuperNerdBattleText:
	text_far _PokemonMansion3FSuperNerdBattleText
	text_end

PokemonMansion3FSuperNerdEndBattleText:
	text_far _PokemonMansion3FSuperNerdEndBattleText
	text_end

PokemonMansion3FSuperNerdAfterBattleText:
	text_far _PokemonMansion3FSuperNerdAfterBattleText
	text_end

PokemonMansion3FScientistBattleText:
	text_far _PokemonMansion3FScientistBattleText
	text_end

PokemonMansion3FScientistEndBattleText:
	text_far _PokemonMansion3FScientistEndBattleText
	text_end

PokemonMansion3FScientistAfterBattleText:
	text_far _PokemonMansion3FScientistAfterBattleText
	text_end

Mansion3BattleText3:
	text_far _Mansion3BattleText3
	text_end

Mansion3EndBattleText3:
	text_far _Mansion3EndBattleText3
	text_end

Mansion3AfterBattleText3:
	text_far _Mansion3AfterBattleText3
	text_end

PokemonMansion3FDiaryText:
	text_far _PokemonMansion3FDiaryText
	text_end
