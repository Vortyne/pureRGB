HallOfFame_Script:
	call EnableAutoTextBoxDrawing
	ld hl, HallOfFame_ScriptPointers
	ld a, [wHallOfFameCurScript]
	jp CallFunctionInTable

;HallofFameRoomClearScripts: ; unreferenced
;	call EnableAllJoypad
;	ld [wHallOfFameCurScript], a
;	ret

HallOfFame_ScriptPointers:
	def_script_pointers
	dw_const HallOfFameDefaultScript,            SCRIPT_HALLOFFAME_DEFAULT
	dw_const HallOfFameOakCongratulationsScript, SCRIPT_HALLOFFAME_OAK_CONGRATULATIONS
	dw_const HallOfFameResetEventsAndSaveScript, SCRIPT_HALLOFFAME_RESET_EVENTS_AND_SAVE
	dw_const DoRet,                              SCRIPT_HALLOFFAME_NOOP

HallOfFameResetEventsAndSaveScript:
	callfar GBCSetCPU1xSpeed ; shinpokerednote: ADDED: turn off 2x cpu speed to make sure the hall of fame animation is working correctly.
	call Delay3
	ld a, [wLetterPrintingDelayFlags]
	push af
	call EnableAllJoypad
	callfar HallOfFamePC
	pop af
	ld [wLetterPrintingDelayFlags], a
	ld hl, wStatusFlags7
	res BIT_NO_MAP_MUSIC, [hl]
	ASSERT wStatusFlags7 + 1 == wElite4Flags
	inc hl
	set BIT_UNUSED_BEAT_ELITE_4, [hl] ; unused
	xor a ; SCRIPT_*_DEFAULT
	ld hl, wLoreleisRoomCurScript
	ld [hli], a ; wLoreleisRoomCurScript
	ld [hli], a ; wBrunosRoomCurScript
	ld [hl], a ; wAgathasRoomCurScript
	ld [wLancesRoomCurScript], a
	ld [wHallOfFameCurScript], a
	; Elite 4 events
	SetEvent EVENT_BECAME_CHAMP ; PureRGBnote: ADDED: new event to track whether we've beat the game once yet
	ResetEventRange INDIGO_PLATEAU_EVENTS_START, INDIGO_PLATEAU_EVENTS_END, 1
	xor a
	ld [wHallOfFameCurScript], a
	ld a, PALLET_TOWN
	ld [wLastBlackoutMap], a
	farcall SaveGameData
	ld b, 5
.delayLoop
	ld c, 600 / 5
	rst _DelayFrames
	dec b
	jr nz, .delayLoop
	call WaitForTextScrollButtonPress
	jp Init

HallOfFameDefaultScript:
	ld hl, wSimulatedJoypadStatesEnd
	ld de, HallOfFameEntryMovement
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStatesNoJoypad
	ld a, SCRIPT_HALLOFFAME_OAK_CONGRATULATIONS
	ld [wHallOfFameCurScript], a
	ret

HallOfFameEntryMovement:
	db PAD_UP, 5
	db -1 ; end

HallOfFameOakCongratulationsScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld a, HALLOFFAME_OAK
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld a, SPRITE_FACING_LEFT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call Delay3
	call EnableAllJoypad
	inc a ; PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld a, TEXT_HALLOFFAME_OAK
	ldh [hTextID], a
	call DisplayTextID
	call DisableAllJoypad
;;;;;;;;;; PureRGBnote: ADDED: hide the third pokeball in oak's lab because he's using it in battle now
	ld a, [wPlayerStarter]
	cp STARTER1
	ld c, TOGGLE_STARTER_BALL_3
	jr z, .hideStarterBall
	cp STARTER2
	ld c, TOGGLE_STARTER_BALL_1
	jr z, .hideStarterBall
	ld c, TOGGLE_STARTER_BALL_2
.hideStarterBall
	call HideObject
;;;;;;;;;;
	ld c, TOGGLE_CERULEAN_CAVE_GUY
	call HideObject
;;;;;;;;;; PureRGBnote: ADDED: hide the guy in the first floor of the secret house in cerulean - makes it appear he went downstairs.
	ld c, TOGGLE_CERULEAN_ROCKET_HOUSE_1F_GUY
	call HideObject
;;;;;;;;;;
	ld a, SCRIPT_HALLOFFAME_RESET_EVENTS_AND_SAVE
	ld [wHallOfFameCurScript], a
	ret

HallOfFame_TextPointers:
	def_text_pointers
	dw_const HallOfFameOakText, TEXT_HALLOFFAME_OAK

HallOfFameOakText:
	text_far _HallOfFameOakText
	text_end
