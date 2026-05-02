; PureRGBnote: ADDED: new trainers were added to this location

PokemonMansion1F_Script:
	call Mansion1CheckReplaceSwitchDoorBlocks
	call EnableAutoTextBoxDrawing
	ld hl, Mansion1TrainerHeaders
	ld de, PokemonMansion1F_ScriptPointers
	ld a, [wPokemonMansion1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonMansion1FCurScript], a
	ret

Mansion1CheckReplaceSwitchDoorBlocks:
	call WasMapJustLoaded
	ret z
	ld hl, Mansion1TileBlockReplacementCoords
	ld de, Mansion1TileBlockReplacementIDsOnOff
	CheckEvent EVENT_MANSION_SWITCH_ON
	jr nz, ReplaceMansionTileBlockList
	inc de
ReplaceMansionTileBlockList:
	ld a, [hl]
	cp $FF
	ret z
	ld b, [hl] ; replacement y coord
	inc hl
	ld c, [hl] ; replacement x coord
	inc hl
	ld a, [de]
	ld [wNewTileBlockID], a
	inc de
	inc de
	push hl
	push de
	call ReplaceTileBlock
	pop de
	pop hl
	jr ReplaceMansionTileBlockList

Mansion1TileBlockReplacementCoords:
	db  6, 12
	db  3,  8
	db  8, 10 
	db 13, 13
	db -1

Mansion1TileBlockReplacementIDsOnOff:
	db  $2d, $0e
	db  $0e, $2d 
	db  $0e, $2d  
	db  $0e, $2d

Mansion1Script_Switches::
	ld b, TEXT_POKEMONMANSION1F_SWITCH
PokemonMansionSwitchScript:
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	xor a
	ldh [hJoyHeld], a
	ld a, b
	ldh [hTextID], a
	jp DisplayTextID

PokemonMansion1F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_POKEMONMANSION1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_POKEMONMANSION1F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_POKEMONMANSION1F_END_BATTLE

PokemonMansion1F_TextPointers:
	def_text_pointers
	dw_const PokemonMansion1FScientistText, TEXT_POKEMONMANSION1F_SCIENTIST
	dw_const Mansion1Text2,                 TEXT_POKEMONMANSION1F_BURGLAR
	dw_const Mansion1Text3,                 TEXT_POKEMONMANSION1F_FIREFIGHTER1
	dw_const Mansion1Text4,                 TEXT_POKEMONMANSION1F_FIREFIGHTER2
	dw_const PickUpItemText,                TEXT_POKEMONMANSION1F_ITEM1
	dw_const PickUpItemText,                TEXT_POKEMONMANSION1F_ITEM2
	dw_const PokemonMansionSwitchText,      TEXT_POKEMONMANSION1F_SWITCH

Mansion1TrainerHeaders:
	def_trainers
Mansion1TrainerHeader0:
	trainer EVENT_BEAT_MANSION_1_TRAINER_0, 3, PokemonMansion1FScientistBattleText, PokemonMansion1FScientistEndBattleText, PokemonMansion1FScientistAfterBattleText
Mansion1TrainerHeader1:
	trainer EVENT_BEAT_MANSION_1_TRAINER_1, 3, Mansion1BattleText2, Mansion1EndBattleText2, Mansion1AfterBattleText2
Mansion1TrainerHeader2:
	trainer EVENT_BEAT_MANSION_1_TRAINER_2, 3, Mansion1BattleText3, Mansion1EndBattleText3, Mansion1AfterBattleText3
Mansion1TrainerHeader3:
	trainer EVENT_BEAT_MANSION_1_TRAINER_3, 3, Mansion1BattleText4, Mansion1EndBattleText4, Mansion1AfterBattleText4
	db -1 ; end

PokemonMansion1FScientistText:
	text_asm
	ld hl, Mansion1TrainerHeader0
	jr Mansion1TalkToTrainer

Mansion1Text2:
	text_asm
	ld hl, Mansion1TrainerHeader1
	jr Mansion1TalkToTrainer

Mansion1Text3:
	text_asm
	ld hl, Mansion1TrainerHeader2
	jr Mansion1TalkToTrainer

Mansion1Text4:
	text_asm
	ld hl, Mansion1TrainerHeader3
Mansion1TalkToTrainer:
	call TalkToTrainer
	rst TextScriptEnd

PokemonMansion1FScientistBattleText:
	text_far _PokemonMansion1FScientistBattleText
	text_end

PokemonMansion1FScientistEndBattleText:
	text_far _PokemonMansion1FScientistEndBattleText
	text_end

PokemonMansion1FScientistAfterBattleText:
	text_far _PokemonMansion1FScientistAfterBattleText
	text_end

Mansion1BattleText2:
	text_far _Mansion1BattleText2
	text_end

Mansion1EndBattleText2:
	text_far _Mansion1EndBattleText2
	text_end

Mansion1AfterBattleText2:
	text_far _Mansion1AfterBattleText2
	text_end

Mansion1BattleText3:
	text_far _Mansion1BattleText3
	text_end

Mansion1EndBattleText3:
	text_far _Mansion1EndBattleText3
	text_end

Mansion1AfterBattleText3:
	text_far _Mansion1AfterBattleText3
	text_end

Mansion1BattleText4:
	text_far _Mansion1BattleText4
	text_end

Mansion1EndBattleText4:
	text_far _Mansion1EndBattleText4
	text_end

Mansion1AfterBattleText4:
	text_far _Mansion1AfterBattleText4
	text_end

PokemonMansionSwitchText:
	text_asm
	ld hl, .Text
	rst _PrintText
	call YesNoChoice
	ld hl, .NotPressedText
	jr nz, .printDone
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	ld hl, .PressedText
	rst _PrintText
	ld a, SFX_GO_INSIDE
	rst _PlaySound
	CheckAndSetEvent EVENT_MANSION_SWITCH_ON
	jr z, .skip
	ResetEventReuseHL EVENT_MANSION_SWITCH_ON
.skip
	rst TextScriptEnd
.printDone
	rst _PrintText
	rst TextScriptEnd

.Text:
	text_far _PokemonMansion1FSwitchText
	text_end

.PressedText:
	text_far _PokemonMansion1FSwitchPressedText
	text_end

.NotPressedText:
	text_far _PokemonMansion1FSwitchNotPressedText
	text_end
