; PureRGBnote: ADDED: new trainers in this location. Only after defeating giovanni on 11F though.
; PureRGBnote: ADDED: this map is also used for the abandoned building left of silph co.

SilphCo1F_Script:
	call SilphCo1FOnMapLoad
	call CheckForceTalkToEntranceRocket
	call CheckFloatingWeezingAnimation
	ld hl, SilphCo1FTrainerHeaders
	ld de, SilphCo1F_ScriptPointers
	ld bc, wSilphCo1FCurScript
	jp ExecuteCustomMapScriptInTable

SilphCo1FOnMapLoad:
	call WasMapJustLoaded
	ret z
	ld a, [wXCoord]
	cp 30
	call nc, SilphCo1FCheckHideRockets
SilphCo1FReplaceTilesCheck::
	ld a, [wXCoord]
	cp 42
	ret nc
	cp 36
	ret c
	ld hl, vTileset tile 1
	ld de, Facility_GFX tile $32
	lb bc, BANK(Facility_GFX), 1
	call CopyVideoDataHBlank
	ld hl, vTileset tile 5
	ld de, VerticalPipeTiles
	lb bc, BANK(VerticalPipeTiles), 6
	jp CopyVideoDataHBlank

SilphCo1FCheckHideRockets:
	; don't want to make new hide/show variables so I'm just moving them off screen conditionally
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ret z
	ld hl, wSprite06StateData2MapY
	call .moveOffScreen
	ld hl, wSprite07StateData2MapY
	call .moveOffScreen
	ld hl, wSprite08StateData2MapY
	call .moveOffScreen
	jp UpdateSprites
.moveOffScreen
	ld a, 0 + 4
	ld [hli], a
	ld [hl], 36 + 4
	ret

CheckForceTalkToEntranceRocket:
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ret nz
	CheckEvent EVENT_SOLVED_ROCKET_PASSWORD
	ret nz
	ld a, [wXCoord]
	cp 56
	ret nz
	ld a, [wYCoord]
	cp 11
	ret nz
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, TEXT_SILPHCO1F_ROCKET1
	ldh [hTextID], a
	; force talking to 
	jp DisplayTextID


SilphCo1F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILPHCO1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO1F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO1F_END_BATTLE

SilphCo1F_TextPointers:
	def_text_pointers
	dba_const SilphCo1FTrainer1Text,         TEXT_SILPHCO1F_FIREFIGHTER1
	dba_const SilphCo1FTrainer2Text,         TEXT_SILPHCO1F_SOLDIER1
	dba_const SilphCo1FTrainer3Text,         TEXT_SILPHCO1F_SOLDIER2
	dba_const SilphCo1FTrainer4Text,         TEXT_SILPHCO1F_FIREFIGHTER2
	dba_const _SilphCo1FLinkReceptionistText, TEXT_SILPHCO1F_LINK_RECEPTIONIST
	dba_const SaffronAbandonedBuildingRocket1Text, TEXT_SILPHCO1F_ROCKET1
	dba_const _SaffronAbandonedBuildingRocket2, TEXT_SILPHCO1F_ROCKET2
	dba_const _SaffronAbandonedBuildingRocket3, TEXT_SILPHCO1F_ROCKET3
	dba_const DoRet, TEXT_SILPHCO1F_WEEZING_PROXY
	dba_const _SaffronAbandonedBuildingStairs, TEXT_SILPHCO1F_BROKEN_STAIRS
	dba_const SaffronAbandonedBuildingHeliumPipeText, TEXT_SILPHCO1F_HELIUM_PIPE
	dba_const SaffronAbandonedBuildingWeezingText, TEXT_WEEZING_STARTED_FLOATING

SilphCo1FTrainerHeaders:
	def_trainers 0
SilphCo1FTrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_1F_TRAINER_0, 0, _SilphCo1FBattleText1, _SilphCo1FEndBattleText1, _SilphCo1FAfterBattleText1
SilphCo1FTrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_1F_TRAINER_1, 0, _SilphCo1FBattleText2, _SilphCo1FEndBattleText2, _SilphCo1FAfterBattleText2
SilphCo1FTrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_1F_TRAINER_2, 0, _SilphCo1FBattleText3, _SilphCo1FEndBattleText3, _SilphCo1FAfterBattleText3
SilphCo1FTrainerHeader3:
	trainer EVENT_BEAT_SILPH_CO_1F_TRAINER_3, 0, _SilphCo1FBattleText4, _SilphCo1FEndBattleText4, _SilphCo1FAfterBattleText4
	db -1 ;end

SilphCo1FTrainer1Text:
	script_trainer SilphCo1FTrainerHeader0

SilphCo1FTrainer2Text:
	script_trainer SilphCo1FTrainerHeader1

SilphCo1FTrainer3Text:
	script_trainer SilphCo1FTrainerHeader2
	
SilphCo1FTrainer4Text:
	script_trainer SilphCo1FTrainerHeader3

SaffronAbandonedBuildingRocket1Text:
	text_asm
	call SaveScreenTilesToBuffer2
	CheckEvent EVENT_SOLVED_ROCKET_PASSWORD
	ld hl, .guess
	jr nz, .printDone
	ld hl, .password
	rst _PrintText
	ld hl, RocketPasswordMenu
	ld b, PAD_A | PAD_B
	call DisplayMultiChoiceTextBox
	push af
	call LoadScreenTilesFromBuffer2
	pop af
	jr nz, .failed
	ld a, [wCurrentMenuItem]
	and a
	ld hl, .seriously
	jr z, .failedPrint
	dec a
	ld hl, .evenMean
	jr z, .failedPrint
	dec a
	jr z, .passwordGot
	ld hl, .dennis
.failedPrint
	rst _PrintText
.failed
	ld a, PAD_RIGHT
	ld hl, wSimulatedJoypadStatesEnd
	ld [hli], a
	ld [hli], a
	ld [hl], -1
	ld a, 2
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld hl, .getOut
.printDone
	rst _PrintText
	rst TextScriptEnd
.passwordGot
	SetEvent EVENT_SOLVED_ROCKET_PASSWORD
	ld hl, .correct
	jr .printDone
.password
	text_far_end _SaffronAbandonedBuildingRocket1
.getOut
	text_far_end _SaffronAbandonedBuildingRocket1GetOut
.seriously
	text_far_end _SaffronAbandonedBuildingRocket1Seriously
.evenMean
	text_far_end _SaffronAbandonedBuildingRocket1Brocket
.dennis
	text_far_end _SaffronAbandonedBuildingRocket1Dennis
.guess
	text_far_end _SaffronAbandonedBuildingRocket1Guess
.correct
	text_far_end _SaffronAbandonedBuildingRocket1Sprocket

SaffronAbandonedBuildingHeliumPipe::
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	ld a, TEXT_SILPHCO1F_HELIUM_PIPE
	ldh [hTextID], a
	call DisplayTextID
	CheckEvent EVENT_FLOATING_WEEZING_ANIMATION
	ret z
	; make player walk down one step
	ld a, PAD_DOWN
	ld hl, wSimulatedJoypadStatesEnd
	ld [hli], a
	ld [hl], -1
	ld a, 1
	ld [wSimulatedJoypadStatesIndex], a
	jp StartSimulatingJoypadStates

SaffronAbandonedBuildingHeliumPipeText:
	text_asm
	ld de, PowerPlantRoofRain
	call PlayNewSoundChannel8
	ld hl, .pipeAir
	rst _PrintText
	ld de, StopSFXSound
	call PlayNewSoundChannel8
	callfar GenericShowPartyMenuSelection
	ld hl, .forgetIt
	jr c, .printDone
	call GetPartyMonName2
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Species
 	ld bc, wPartyMon2 - wPartyMon1
  	call AddNTimes
  	ld a, [hl]
  	cp WEEZING
  	jr z, .weezing
  	cp KOFFING
  	ld hl, .koffing
  	jr z, .printDone
  	cp FLOATING_WEEZING 
  	ld hl, .already
  	jr z, .printDone
  	ld hl, .wrongMon
.printDone
	rst _PrintText
	rst TextScriptEnd
.weezing
	SetEvent EVENT_FLOATING_WEEZING_ANIMATION
	ld a, FLOATING_WEEZING
	ld [wCurPartySpecies], a
	callfar ChangePartyPokemonSpecies ; change weezing into floating weezing
	ld hl, .weezingText
	jr .printDone
.pipeAir
	text_far_end _SaffronAbandonedBuildingSteamPipe
.forgetIt
	text_far_end _GenericForgetItText
.wrongMon
	text_far_end _SecretLabMewtwoReactionText4
.koffing
	text_far_end _SaffronAbandonedBuildingKoffing
.already
	text_far_end _SaffronAbandonedBuildingAlready
.weezingText
	text_far_end _SaffronAbandonedBuildingWeezing

CheckFloatingWeezingAnimation:
	call IsPlayerAutoMoving
	ret nz ; wait for player to finish walking
	CheckAndResetEvent EVENT_FLOATING_WEEZING_ANIMATION
	ret z
	call PauseMusic
	; make player face up
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	call UpdateSprites
	ld hl, wSprite09StateData2MapY
	ld a, [wYCoord]
	add 3 
	ld [hli], a
	ld a, [wXCoord]
	add 4 
	ld [hl], a
	call UpdateSprites
	ld de, vNPCSprites tile $3C
	callfar DoBallPoofOnNPC
	ld a, [wSpriteOptions2]
	bit BIT_MENU_ICON_SPRITES, a
	jr nz, .weezingSprite
	call .loadSeelSprite
	jr .doneSpriteReplace
.weezingSprite
	; load weezing sprite into vram
	call .loadWeezingSprite
.doneSpriteReplace
	ld a, SILPHCO1F_WEEZING_PROXY
	ldh [hSpriteIndex], a
	ld de, GasSound
	callfar FloatingAnimation
	ld de, StopSFXSound
	call PlayNewSoundChannel8
	ld a, TEXT_WEEZING_STARTED_FLOATING
	ldh [hTextID], a
	call DisplayTextID
	call ResumeMusic
	ld c, 60
	rst DelayFrames
	ld de, vNPCSprites tile $3C
	callfar DoBallPoofOnNPC
	ld hl, wSprite09StateData2MapY
	; move it back offscreen
	ld [hl], 0 + 4
	inc hl
	ld [hl], 36 + 4
	jp UpdateSprites
.loadSeelSprite
	ld hl, vNPCSprites tile $3C
	ld de, SeelSprite
	lb bc, BANK(SeelSprite), 4
	jp CopyVideoDataHBlank
.loadWeezingSprite
	ld hl, vNPCSprites tile $3C
	ld de, PartyMonSprites1 tile 136
	lb bc, BANK(PartyMonSprites1), 2
	call CopyVideoDataHBlank
	ld hl, vNPCSprites tile $3E
	ld de, PartyMonSprites1 tile 140
	lb bc, BANK(PartyMonSprites1), 2
	jp CopyVideoDataHBlank

SaffronAbandonedBuildingWeezingText:
	text_far _SaffronAbandonedBuildingWeezing2
	sound_get_item_2
	text_far_end _MagnetMagnetonText3
