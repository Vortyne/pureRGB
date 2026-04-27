PokemonTower7F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, PokemonTower7TrainerHeaders
	ld de, PokemonTower7F_ScriptPointers
	ld a, [wPokemonTower7FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonTower7FCurScript], a
	ret

PokemonTower7F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_POKEMONTOWER7F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_POKEMONTOWER7F_START_BATTLE
	dw_const PokemonTower7FEndBattleScript,         SCRIPT_POKEMONTOWER7F_END_BATTLE
	dw_const PokemonTower7FHideNPCScript,           SCRIPT_POKEMONTOWER7F_HIDE_NPC
	dw_const PokemonTower7FWarpToMrFujiHouseScript, SCRIPT_POKEMONTOWER7F_WARP_TO_MR_FUJI_HOUSE



PokemonTower7FSetDefaultScript:
	call ResetMapScripts
	ld [wPokemonTower7FCurScript], a ; SCRIPT_POKEMONTOWER7F_DEFAULT
	ret

PokemonTower7FEndBattleScript:
	ld hl, wMiscFlags
	res BIT_SEEN_BY_TRAINER, [hl]
	ld a, [wIsInBattle]
	cp $ff
	jr z, PokemonTower7FSetDefaultScript
	call EndTrainerBattle
	call DisableDpad
	ld a, [wSpriteIndex]
	ldh [hSpriteIndex], a
	call DisplayTextID
	call PokemonTower7FRocketLeaveMovementScript
	ld a, SCRIPT_POKEMONTOWER7F_HIDE_NPC
	; fall through
PokemonTower7FSetMapScript:
	ld [wPokemonTower7FCurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower7FHideNPCScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld hl, wToggleableObjectList
	ld a, [wSpriteIndex]
	ld b, a
.toggleableObjectsListLoop
	ld a, [hli]
	cp b            ; search for sprite ID in toggleable objects list
	ld a, [hli]
	jr nz, .toggleableObjectsListLoop
	ld [wToggleableObjectIndex], a   ; remove toggleable object
	predef HideObject
;;;;;; PureRGBnote: ADDED: play a sound effect when the rockets leave
	ld a, SFX_GO_OUTSIDE
	rst _PlaySound
;;;;;;
	xor a
	ld [wSpriteIndex], a
	ld [wTrainerHeaderFlagBit], a
	jr PokemonTower7FSetDefaultScript

PokemonTower7FWarpToMrFujiHouseScript:
	call DisableAllJoypad
	ld a, SPRITE_FACING_UP
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, MR_FUJIS_HOUSE
	ldh [hWarpDestinationMap], a
	ld a, $1
	ld [wDestinationWarpID], a
	ld a, LAVENDER_TOWN
	ld [wLastMap], a
	ld hl, wStatusFlags3
	set BIT_WARP_FROM_CUR_SCRIPT, [hl]
	jr PokemonTower7FSetDefaultScript

; PureRGBnote: OPTIMIZED: this script for moving the rockets had movement lists for every possible way they could leave,
; when this can be made into a smaller algorithm pretty easily.
PokemonTower7FRocketLeaveMovementScript:
	ld a, [wSpriteIndex]
	cp POKEMONTOWER7F_ROCKET2
	lb de, NPC_MOVEMENT_RIGHT, 10
	jr nz, .continue
	lb de, NPC_MOVEMENT_LEFT, 11
.continue
	ld hl, wNPCMovementDirections2
	push hl
	ld a, [wYCoord]
	bit 0, a ; if player's y coord is odd, the rocket starts by walking down then right or left
	ld b, NPC_MOVEMENT_DOWN
	ld c, d
	jr nz, .gotFirstMovement
	; if even, the rocket starts by walking left or right, then down
	ld c, b
	ld b, d
.gotFirstMovement
	ld [hl], b
	inc hl
	; flags still set according to the first bit 0, a
	jr z, .dontSkip ; if we're below the rocket instead of in their vision, skip the next check since the second action should always happen
	; if the player was right in front of the rocket's vision, they will walk left/right after first going down instead of going straight down
	ld a, [wXCoord] 
	cp e
	jr nz, .skip
.dontSkip
	ld [hl], c
	inc hl
.skip ; we always need 5 downwards movements regardless of the other actions
	ld b, 5
	ld a, NPC_MOVEMENT_DOWN
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	; if the player is below the lowest rocket, then the last movement has to be them moving left onto the stairway
	ld a, [wYCoord]
	cp 12
	jr nz, .done
	dec hl
	ld [hl], NPC_MOVEMENT_LEFT
	inc hl
.done
	ld [hl], -1
	pop de ; pop hl into de
	ld a, [wSpriteIndex]
	ldh [hSpriteIndex], a
	jp MoveSprite

PokemonTower7F_TextPointers:
	def_text_pointers
	dw_const PokemonTower7FRocket1Text, TEXT_POKEMONTOWER7F_ROCKET1
	dw_const PokemonTower7FRocket2Text, TEXT_POKEMONTOWER7F_ROCKET2
	dw_const PokemonTower7FRocket3Text, TEXT_POKEMONTOWER7F_ROCKET3
	dw_const PokemonTower7FMrFujiText,  TEXT_POKEMONTOWER7F_MR_FUJI

PokemonTower7TrainerHeaders:
	def_trainers
PokemonTower7TrainerHeader0:
	trainer EVENT_BEAT_POKEMONTOWER_7_TRAINER_0, 3, PokemonTower7FRocket1BattleText, PokemonTower7FRocket1EndBattleText, PokemonTower7FRocket1AfterBattleText
PokemonTower7TrainerHeader1:
	trainer EVENT_BEAT_POKEMONTOWER_7_TRAINER_1, 3, PokemonTower7FRocket2BattleText, PokemonTower7FRocket2EndBattleText, PokemonTower7FRocket2AfterBattleText
PokemonTower7TrainerHeader2:
	trainer EVENT_BEAT_POKEMONTOWER_7_TRAINER_2, 3, PokemonTower7FRocket3BattleText, PokemonTower7FRocket3EndBattleText, PokemonTower7FRocket3AfterBattleText
	db -1 ; end

PokemonTower7FRocket1Text:
	text_asm
	ld hl, PokemonTower7TrainerHeader0
	; fall through
PokemonTower7FTalkToTrainer:
	call TalkToTrainer
	rst TextScriptEnd

PokemonTower7FRocket2Text:
	text_asm
	ld hl, PokemonTower7TrainerHeader1
	jr PokemonTower7FTalkToTrainer

PokemonTower7FRocket3Text:
	text_asm
	ld hl, PokemonTower7TrainerHeader2
	jr PokemonTower7FTalkToTrainer

PokemonTower7FMrFujiText:
	text_asm
	CheckEvent EVENT_CAUGHT_GHOST_MAROWAK
	ld hl, .RescueCaughtMarowakText
	jr nz, .print
	ld hl, .RescueDefaultText
.print
	rst _PrintText
	SetEvent EVENT_RESCUED_MR_FUJI
	ld a, TOGGLE_MR_FUJIS_HOUSE_MR_FUJI
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld a, TOGGLE_SAFFRON_CITY_E
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_SAFFRON_CITY_F
	ld [wToggleableObjectIndex], a
	predef ShowObject
;;;;;;;;;; PureRGBnote: ADDED: hide the new ROCKET on the first floor of the tower
	ld a, TOGGLE_POKEMON_TOWER_1F_ROCKET
	ld [wToggleableObjectIndex], a
	predef HideExtraObject
;;;;;;;;;;
	ld a, SCRIPT_POKEMONTOWER7F_WARP_TO_MR_FUJI_HOUSE
	call PokemonTower7FSetMapScript
	rst TextScriptEnd

.RescueDefaultText:
	text_far _PokemonTower7FMrFujiRescueText
	text_far _PokemonTower7FMrFujiAfterlifeText
	text_far _PokemonTower7FMrFujiFollowMeText
	text_end

.RescueCaughtMarowakText:
	text_far _PokemonTower7FMrFujiRescueText
	text_far _PokemonTower7FMrFujiCaughtText
	text_far _PokemonTower7FMrFujiFollowMeText
	text_end

PokemonTower7FRocket1BattleText:
	text_far _PokemonTower7FRocket1BattleText
	text_end

PokemonTower7FRocket1EndBattleText:
	text_far _PokemonTower7FRocket1EndBattleText
	text_end

PokemonTower7FRocket1AfterBattleText:
	text_far _PokemonTower7FRocket1AfterBattleText
	text_end

PokemonTower7FRocket2BattleText:
	text_far _PokemonTower7FRocket2BattleText
	text_end

PokemonTower7FRocket2EndBattleText:
	text_far _PokemonTower7FRocket2EndBattleText
	text_end

PokemonTower7FRocket2AfterBattleText:
	text_far _PokemonTower7FRocket2AfterBattleText
	text_end

PokemonTower7FRocket3BattleText:
	text_far _PokemonTower7FRocket3BattleText
	text_end

PokemonTower7FRocket3EndBattleText:
	text_far _PokemonTower7FRocket3EndBattleText
	text_end

PokemonTower7FRocket3AfterBattleText:
	text_far _PokemonTower7FRocket3AfterBattleText
	text_end
