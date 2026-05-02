ASSERT BANK(AgathasRoom_Script) == BANK(BrunosRoom_Script)
ASSERT BANK(AgathasRoom_Script) == BANK(LoreleisRoom_Script)

AgathasRoom_Script:
	call AgathaShowOrHideExitBlock
	call EnableAutoTextBoxDrawing
	ld hl, AgathasRoomTrainerHeaders
	ld de, AgathasRoom_ScriptPointers
	ld a, [wAgathasRoomCurScript]
	call ExecuteCurMapScriptInTable
	ld [wAgathasRoomCurScript], a
	ret

AgathaShowOrHideExitBlock:
	call WasMapJustLoaded
	ret z
	CheckEvent EVENT_BEAT_AGATHAS_ROOM_TRAINER_0
	lb bc, $3b, $e
	jr EliteFourOnMapLoad.gotExitBlockIDs

EliteFourOnMapLoad:
	lb bc, $24, $5
.gotExitBlockIDs
	ld a, b
	jr z, .setExitBlock
	ld a, c
.setExitBlock
	ld [wNewTileBlockID], a
	lb bc, 0, 2
	call ReplaceTileBlock
	ld hl, wCurrentMapScriptFlags
	bit BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	res BIT_MAP_LOADED_AFTER_BATTLE, [hl] 
	ret z
	jp GBFadeInFromWhite ; PureRGBnote: ADDED: since trainer instantly talks to us after battle we need to fade back in here

AgathasRoom_ScriptPointers:
	def_script_pointers
	dw_const AgathasRoomDefaultScript,              SCRIPT_AGATHASROOM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_AGATHASROOM_AGATHA_START_BATTLE
	dw_const AgathasRoomAgathaEndBattleScript,      SCRIPT_AGATHASROOM_AGATHA_END_BATTLE
	dw_const AgathasRoomPlayerIsMovingScript,       SCRIPT_AGATHASROOM_PLAYER_IS_MOVING

AgathasRoomDefaultScript:
	lb bc, TEXT_AGATHASROOM_AGATHA_DONT_RUN_AWAY, SCRIPT_AGATHASROOM_PLAYER_IS_MOVING
	ld hl, wAgathasRoomCurScript
	; fall through
EliteFourDefaultScript:
	ld a, [wYCoord]
	cp 7
	jr z, .standingOnExit
	ld a, [wYCoord]
	cp 11
	jr z, .justEntered
	call CheckFightingMapTrainers
	xor a
	ldh [hJoyPressed], a
	ldh [hJoyHeld], a
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesIndex], a
	ret
.standingOnExit
	push hl
	ld a, b
	ldh [hTextID], a ; don't run away text script id
	push bc
	call DisplayTextID  ; "Don't run away!"
	ld a, PAD_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	pop bc
	ld a, c ; player is moving script
	pop hl
	ld [hl], a
	ld [wCurMapScript], a
	ret
.justEntered
	ld a, c ; player is moving script
	; fall through
	ld [hl], a
	ld [wCurMapScript], a
; Walk six steps upward.
	ld hl, wSimulatedJoypadStatesEnd
	ld a, PAD_UP
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $6
	ld [wSimulatedJoypadStatesIndex], a
	jp StartSimulatingJoypadStates

AgathasRoomPlayerIsMovingScript:
	ld hl, wAgathasRoomCurScript
	; fall through
EliteFourIsPlayerMovingScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	call ResetMapScripts
	ld [hl], a ; reset map script to default
	ret

AgathasRoomAgathaEndBattleScript:
	ld hl, wAgathasRoomCurScript
	lb de, AGATHASROOM_AGATHA, TEXT_AGATHASROOM_AGATHA
	call EliteFourEndTrainerBattleScript
	ld a, SCRIPT_CHAMPIONSROOM_PLAYER_ENTERS
	ld [wChampionsRoomCurScript], a
	ret

EliteFourEndTrainerBattleScript:
	push de
	push hl
	call EndTrainerBattle
	pop hl
	pop de
	ld a, [wIsInBattle]
	cp $ff
	jr nz, .continue
	xor a ; default script
	ld [hl], a
	ret
.continue
	; d = which sprite
	callfar MakeSpriteFacePlayer
	ld a, e
	ldh [hTextID], a
	push de
	call DisplayTextID
	pop de
	ld a, d
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
;;;;;;;;;; PureRGBnote: ADDED: sound effect for the doors opening
	ld a, SFX_GO_INSIDE
	rst _PlaySound
;;;;;;;;;;
	ret

AgathasRoom_TextPointers:
	def_text_pointers
	dw_const AgathasRoomAgathaText,         TEXT_AGATHASROOM_AGATHA
	dw_const EliteFourDontRunAwayText,		TEXT_AGATHASROOM_AGATHA_DONT_RUN_AWAY

AgathasRoomTrainerHeaders:
	def_trainers
AgathasRoomTrainerHeader0:
	trainer EVENT_BEAT_AGATHAS_ROOM_TRAINER_0, 0, AgathaBeforeBattleText, AgathaEndBattleText, AgathaAfterBattleText
	db -1 ; end

AgathasRoomAgathaText:
	text_asm
;;;;;;;;;; PureRGBnote: ADDED: makes the battle music the gym leader theme
	ld a, 11
;;;;;;;;;;
	ld hl, AgathasRoomTrainerHeader0
	; fall through
EliteFourTalkToTrainer:
	ld [wGymLeaderNo], a
	call TalkToTrainer
	rst TextScriptEnd

AgathaBeforeBattleText:
	text_far _AgathaBeforeBattleText
	text_end

AgathaEndBattleText:
	text_far _AgathaEndBattleText
	text_end

AgathaAfterBattleText:
	text_far _AgathaAfterBattleText
	text_end

EliteFourDontRunAwayText:
	text_far _EliteFourDontRunAwayText
	text_end
