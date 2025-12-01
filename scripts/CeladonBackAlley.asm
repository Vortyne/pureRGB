CeladonBackAlley_Script:
	call EnableAutoTextBoxDrawing
	ld hl, wCurrentMapScriptFlags
	bit BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	jr nz, .afterBattle
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_MOVEMENT_STATE, a
	jr nz, .noPositionScripts
	call IsPlayerBesideCeladonBackAlleyHooligan
	jr nz, .notBesideClerk
	ld a, CELADONBACKALLEY_HOOLIGAN
	call SetSpriteFacingLeft
	call UpdateSprites
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	call Delay3
	ld a, TEXT_CELADONBACKALLEY_HOOLIGAN
	ldh [hTextID], a
	call DisplayTextID
	jr .noPositionScripts
.notBesideClerk
	lb de, 18, 6
	call IsPlayerAtCoords ; battle position
	call z, StartCeladonBackAlleyBattle
.noPositionScripts
	ld a, [wXCoord]
	cp 0
	jr nz, .notAutoWarp
	; force a warp when on the leftmost coord of the map, it works better than using object warps
	ld a, CELADON_CITY
	ldh [hWarpDestinationMap], a
	ld a, 14
	ld [wDestinationWarpID], a
	ld hl, wStatusFlags3
	set BIT_WARP_FROM_CUR_SCRIPT, [hl]
.notAutoWarp
	ldh a, [hJoyPressed]
	bit BIT_A_BUTTON, a
	ret z
	callfar _GetTileAndCoordsInFrontOfPlayer
	ld a, [wTileInFrontOfPlayer]
	cp $03
	jr z, .maybeGraffiti
	cp $37
	ld a, TEXT_CELADONBACKALLEY_GARBAGE
	jr z, .displayText
	ret
.maybeGraffiti
	ld a, [wXCoord]
	cp 27
	ret nz
	ld a, TEXT_CELADONBACKALLEY_KOFFING_GRAFFITI
	jr .displayText
.afterBattle
	call ResetFitnessBattleState
	ret z ; lost battle
	ld a, TEXT_CELADONBACKALLEY_AFTER_BATTLE
.displayText
	ldh [hTextID], a
	jp DisplayTextID

CeladonBackAlley_TextPointers:
	def_text_pointers
	dw_const CeladonBackAlleyHooliganText, TEXT_CELADONBACKALLEY_HOOLIGAN
	dw_const CeladonBackAlleyCircleBiker1Text, TEXT_CELADONBACKALLEY_CIRCLE_BIKER1
	dw_const CeladonBackAlleyCircleBiker2Text, TEXT_CELADONBACKALLEY_CIRCLE_BIKER2
	dw_const CeladonBackAlleyCircleBiker3Text, TEXT_CELADONBACKALLEY_CIRCLE_BIKER3
	dw_const CeladonBackAlleyCircleGamblerText, TEXT_CELADONBACKALLEY_CIRCLE_GAMBLER
	dw_const CeladonBackAlleyCircleRocker1Text, TEXT_CELADONBACKALLEY_CIRCLE_ROCKER1
	dw_const CeladonBackAlleyCircleRocker2Text, TEXT_CELADONBACKALLEY_CIRCLE_ROCKER2
	dw_const CeladonBackAlleyCircleLeftBikerText, TEXT_CELADONBACKALLEY_LEFT_BIKER
	dw_const CeladonBackAlleyCircleRightRockerText, TEXT_CELADONBACKALLEY_RIGHT_ROCKER
	dw_const CeladonBackAlleyOpponentBikerText, TEXT_CELADONBACKALLEY_OPPONENT_BIKER
	dw_const CeladonBackAlleyOpponentCueBallText, TEXT_CELADONBACKALLEY_OPPONENT_CUE_BALL
	dw_const CeladonBackAlleyOpponentRockerText, TEXT_CELADONBACKALLEY_OPPONENT_ROCKER
	dw_const CeladonBackAlleyOpponentGamblerText, TEXT_CELADONBACKALLEY_OPPONENT_GAMBLER
	dw_const CeladonBackAlleyAfterBattle, TEXT_CELADONBACKALLEY_AFTER_BATTLE
	dw_const CeladonBackAlleyGarbage, TEXT_CELADONBACKALLEY_GARBAGE
	dw_const CeladonBackAlleyKoffingGraffiti, TEXT_CELADONBACKALLEY_KOFFING_GRAFFITI

CeladonBackAlleyHooliganText:
	text_far _CeladonBackAlleyCircleHooliganText
	text_asm
	CheckAndSetEvent EVENT_MET_CELADON_BACK_ALLEY_HOOLIGAN
	jr nz, .met
	ld hl, .intro
	rst _PrintText
.met
	ld hl, .start
	rst _PrintText
	lb de, 32, 21 ; max opponent level, min opponent level
	call FitnessClubIntroScript
	jr c, .startBattle
	call IsPlayerBesideCeladonBackAlleyHooligan
	jr nz, .done
	; force player to walk up 1 coord if battle not started and they were beside clerk
	ld a, D_UP
	ld hl, wSimulatedJoypadStatesEnd
	ld [hli], a
	ld [hl], -1
	ld a, 1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
.done
	rst TextScriptEnd
.startBattle
	ld hl, wSimulatedJoypadStatesEnd
	ld [hl], D_DOWN
	inc hl
	ld a, [wXCoord]
	sub 18
	ld b, 1
	jr z, .beside 
	ld [hl], D_DOWN
	inc hl
	ld [hl], D_LEFT
	inc hl
	dec a
	ld b, 3
	jr z, .beside
	ld [hl], D_LEFT
	inc hl
	ld [hl], D_UP
	inc hl
	ld b, 5
.beside
	ld a, b
	ld [hl], -1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, CELADONBACKALLEY_HOOLIGAN
	call SetSpriteFacingDown
	rst TextScriptEnd
.intro
	text_far _CeladonBackAlleyCircleHooliganExplainText
	text_end
.start
	text_far _CeladonBackAlleyCircleHooliganBattleText
	text_end

CeladonBackAlleyCircleBiker1Text:
	text_far _CeladonBackAlleyCircleBiker1Text
	text_end

CeladonBackAlleyCircleBiker2Text:
	text_far _CeladonBackAlleyCircleBiker2Text
	text_end

CeladonBackAlleyCircleBiker3Text:
	text_far _CeladonBackAlleyCircleBiker3Text
	text_end

CeladonBackAlleyCircleGamblerText:
	text_far _CeladonBackAlleyCircleGamblerText
	text_end

CeladonBackAlleyCircleRocker1Text:
	text_far _CeladonBackAlleyCircleRocker1Text
	text_end

CeladonBackAlleyCircleRocker2Text:
	text_far _CeladonBackAlleyCircleRocker2Text
	text_end

CeladonBackAlleyCircleLeftBikerText:
	text_far _CeladonBackAlleyCircleLeftBikerText
	text_end

CeladonBackAlleyCircleRightRockerText:
	text_far _CeladonBackAlleyCircleRightRockerText
	text_asm
	ld a, MUSIC_MEET_MALE_TRAINER
	ld c, BANK(Music_MeetMaleTrainer)
	call PlayMusic
	ld c, 166
	rst _DelayFrames
	call StopAllMusic
	ld hl, .question
	rst _PrintText
	call YesNoChoice
	call PlayDefaultMusic
	ld a, [wCurrentMenuItem]
	and a
	ld hl, .no
	jr nz, .printDone
	ld hl, .yes
.printDone
	rst _PrintText
	rst TextScriptEnd
.question
	text_far _CeladonBackAlleyCircleRightRockerThinkText
	text_end
.yes
	text_far _CeladonBackAlleyCircleRightRockerYesText
	text_end
.no
	text_far _CeladonBackAlleyCircleRightRockerNoText
	text_end

IsPlayerBesideCeladonBackAlleyHooligan:
	lb de, 18, 5
	jp IsPlayerAtCoords

StartCeladonBackAlleyBattle:
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	call UpdateSprites
	ld c, 30
	rst _DelayFrames
	call CeladonBackAlleyHideOpponent ; hide previous opponents if applicable
	ld hl, AvailableCeladonBackAlleyTrainers
	lb de, 1, 0 ; coord delta with respect to the player for opponent to show up at
	jp StartFitnessClubBattle

AvailableCeladonBackAlleyTrainers:
	db OPP_BIKER, TEXT_CELADONBACKALLEY_OPPONENT_BIKER
	db OPP_CUE_BALL, TEXT_CELADONBACKALLEY_OPPONENT_CUE_BALL
	db OPP_ROCKER, TEXT_CELADONBACKALLEY_OPPONENT_ROCKER
	db OPP_GAMBLER, TEXT_CELADONBACKALLEY_OPPONENT_GAMBLER
	ASSERT CELADONBACKALLEY_OPPONENT_BIKER == TEXT_CELADONBACKALLEY_OPPONENT_BIKER
	ASSERT CELADONBACKALLEY_OPPONENT_CUE_BALL == TEXT_CELADONBACKALLEY_OPPONENT_CUE_BALL
	ASSERT CELADONBACKALLEY_OPPONENT_ROCKER == TEXT_CELADONBACKALLEY_OPPONENT_ROCKER
	ASSERT CELADONBACKALLEY_OPPONENT_GAMBLER == TEXT_CELADONBACKALLEY_OPPONENT_GAMBLER

CeladonBackAlleyOpponentBikerText:
	text_asm
	ld hl, .intro1
	jp GetRandomClubOpponentText
.intro1
	text_far _CeladonBackAlleyOpponentBikerIntro1
	text_end
.intro2
	text_far _CeladonBackAlleyOpponentBikerIntro2
	text_end
.intro3
	text_far _CeladonBackAlleyOpponentBikerIntro3
	text_end
.intro4
	text_far _CeladonBackAlleyOpponentBikerIntro4
	text_end

CeladonBackAlleyOpponentCueBallText:
	text_asm
	ld hl, .intro1
	jp GetRandomClubOpponentText
.intro1
	text_far _CeladonBackAlleyOpponentCueBallIntro1
	text_end
.intro2
	text_far _CeladonBackAlleyOpponentCueBallIntro2
	text_end
.intro3
	text_far _CeladonBackAlleyOpponentCueBallIntro3
	text_end
.intro4
	text_far _CeladonBackAlleyOpponentCueBallIntro4
	text_end

CeladonBackAlleyOpponentRockerText:
	text_asm
	ld hl, .intro1
	jp GetRandomClubOpponentText
.intro1
	text_far _CeladonBackAlleyOpponentRockerIntro1
	text_end
.intro2
	text_far _CeladonBackAlleyOpponentRockerIntro2
	text_end
.intro3
	text_far _CeladonBackAlleyOpponentRockerIntro3
	text_end
.intro4
	text_far _CeladonBackAlleyOpponentRockerIntro4
	text_end

CeladonBackAlleyOpponentGamblerText:
	text_asm
	ld hl, .intro1
	jp GetRandomClubOpponentText
.intro1
	text_far _CeladonBackAlleyOpponentGamblerIntro1
	text_end
.intro2
	text_far _CeladonBackAlleyOpponentGamblerIntro2
	text_end
.intro3
	text_far _CeladonBackAlleyOpponentGamblerIntro3
	text_end
.intro4
	text_far _CeladonBackAlleyOpponentGamblerIntro4
	text_end

CeladonBackAlleyAfterBattle:
	text_asm
	lb de, 32, 21
	call FitnessClubAfterBattleText
	jr c, .done
	; if nc, make the player leave
	ld a, D_UP
	ld hl, wSimulatedJoypadStatesEnd
	ld [hli], a
	ld [hli], a
	ld [hl], -1
	ld a, 2
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld hl, CeladonBackAlleyHideOpponent
	call FitnessClubHideOpponents
.done
	rst TextScriptEnd

CeladonBackAlleyHideOpponent:
	ld a, [wFitnessClubChallenger]
	ld c, a
	lb de, 50, 1
	jpfar FarMoveSpriteOffScreen

CeladonBackAlleyGarbage:
	text_far _SSAnneCaptainsRoomTrashText
	text_end

CeladonBackAlleyKoffingGraffiti:
	text_far _CeladonBackAlleyKoffingGraffiti
	text_end
