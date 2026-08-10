; PureRGBnote: ADDED: new trainers were added to this location
; PureRGBnote: ADDED: code that unlocks a stairway to the Secret Lab after certain conditions are fulfilled was added
ASSERT BANK(ReplaceMansionTileBlockList) == BANK(PokemonMansionB1F_Script)
ASSERT BANK(PokemonMansionSwitchScript) == BANK(PokemonMansionB1F_Script)

PokemonMansionB1F_Script:
	call MansionB1FCheckReplaceSwitchDoorBlocks
	call EnableAutoTextBoxDrawing
	ld hl, Mansion4TrainerHeaders
	ld de, PokemonMansionB1F_ScriptPointers
	ld bc, wPokemonMansionB1FCurScript
	jp ExecuteCustomMapScriptInTable

MansionB1FCheckReplaceSwitchDoorBlocks:
	call WasMapJustLoaded
	ret z
	CheckEvent EVENT_UNLOCKED_SECRET_LAB
	call nz, UnlockLab

	ld hl, MansionB1FTileBlockReplacementCoords
	ld de, MansionB1FTileBlockReplacementIDsOnOff
	CheckEvent EVENT_MANSION_SWITCH_ON
	jr nz, .switchTurnedOn
	inc de
.switchTurnedOn
	jp ReplaceMansionTileBlockList

MansionB1FTileBlockReplacementCoords:
	db  8, 13
	db 11,  6
	db  3,  4 
	db  8,  8
	db -1

MansionB1FTileBlockReplacementIDsOnOff:
	db  $2d, $0e
	db  $5f, $0e 
	db  $0e, $5f  
	db  $0e, $54

UnlockLab::
	ld a, $78
	lb bc, 6, 2
	ld [wNewTileBlockID], a
	jp ReplaceTileBlock

CheckUnlockLab::
	CheckEvent EVENT_UNLOCKED_SECRET_LAB
	ret nz
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	ld b, TOPSECRETKEY
	predef GetIndexOfItemInBag
	ld a, b
	cp $FF ; not in bag
	ret z
	; remove TOPSECRETKEY from inventory
	ld [wWhichPokemon], a ; load item index to be removed
	ld hl, wNumBagItems
	ld a, 1 ; one item
	ld [wItemQuantity], a
	call RemoveItemFromInventory
	ld a, TEXT_POKEMONMANSIONB1F_TOP_SECRET_KEYHOLE
	ldh [hTextID], a
	call DisplayTextID
	ld a, SFX_TELEPORT_ENTER_2
	rst _PlaySound
	ld a, SFX_59
	call PlaySoundWaitForCurrent
	ld c, 30
	rst DelayFrames
	ld a, SFX_GO_INSIDE
	call PlaySoundWaitForCurrent
	SetEvent EVENT_UNLOCKED_SECRET_LAB
	jp UnlockLab

Mansion4Script_Switches::
	ld b, TEXT_POKEMONMANSIONB1F_SWITCH
	jp PokemonMansionSwitchScript

PokemonMansionB1F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_POKEMONMANSIONB1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_POKEMONMANSIONB1F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_POKEMONMANSIONB1F_END_BATTLE

PokemonMansionB1F_TextPointers:
	def_text_pointers
	dba_const PokemonMansionB1FBurglarText,   TEXT_POKEMONMANSIONB1F_BURGLAR
	dba_const PokemonMansionB1FScientistText, TEXT_POKEMONMANSIONB1F_SCIENTIST
	dba_const Mansion4Text3,                  TEXT_POKEMONMANSIONB1F_COOLTRAINER_M
	dba_const Mansion4Text4,                  TEXT_POKEMONMANSIONB1F_FIREFIGHTER
	dba_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_ITEM1
	dba_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_ITEM2
	dba_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_ITEM3
	dba_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_ITEM4
	dba_const _PokemonMansionB1FDiaryText,    TEXT_POKEMONMANSIONB1F_DIARY
	dba_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_SECRET_KEY
	dba_const PokemonMansionSwitchText,       TEXT_POKEMONMANSIONB1F_SWITCH
	dba_const _MansionB1FKeyHoleText,         TEXT_POKEMONMANSIONB1F_TOP_SECRET_KEYHOLE

Mansion4TrainerHeaders:
	def_trainers
Mansion4TrainerHeader0:
	trainer EVENT_BEAT_MANSION_4_TRAINER_0, 0, _PokemonMansionB1FBurglarBattleText, _PokemonMansionB1FBurglarEndBattleText, _PokemonMansionB1FBurglarAfterBattleText
Mansion4TrainerHeader1:
	trainer EVENT_BEAT_MANSION_4_TRAINER_1, 3, _PokemonMansionB1FScientistBattleText, _PokemonMansionB1FScientistEndBattleText, _PokemonMansionB1FScientistAfterBattleText
Mansion4TrainerHeader2:
	trainer EVENT_BEAT_MANSION_4_TRAINER_2, 0, _Mansion4BattleText3, _Mansion4EndBattleText3, _Mansion4AfterBattleText3
Mansion4TrainerHeader3:
	trainer EVENT_BEAT_MANSION_4_TRAINER_3, 0, _Mansion4BattleText4, _Mansion4EndBattleText4, _Mansion4AfterBattleText4
	db -1 ; end

PokemonMansionB1FBurglarText:
	script_trainer Mansion4TrainerHeader0

PokemonMansionB1FScientistText:
	script_trainer Mansion4TrainerHeader1

Mansion4Text3:
	script_trainer Mansion4TrainerHeader2

Mansion4Text4:
	script_trainer Mansion4TrainerHeader3
