CeladonBackAlley_Script:
	call EnableAutoTextBoxDrawing
	ld hl, wCurrentMapScriptFlags
	bit BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	jr nz, .afterBattle
	call IsPlayerAutoMoving
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
	bit B_PAD_A, a
	ret z
	call GetTileAndCoordsInFrontOfPlayer
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
	dba_const CeladonBackAlleyHooliganText, TEXT_CELADONBACKALLEY_HOOLIGAN
	dba_const _CeladonBackAlleyCircleBiker1Text, TEXT_CELADONBACKALLEY_CIRCLE_BIKER1
	dba_const _CeladonBackAlleyCircleBiker2Text, TEXT_CELADONBACKALLEY_CIRCLE_BIKER2
	dba_const _CeladonBackAlleyCircleBiker3Text, TEXT_CELADONBACKALLEY_CIRCLE_BIKER3
	dba_const _CeladonBackAlleyCircleGamblerText, TEXT_CELADONBACKALLEY_CIRCLE_GAMBLER
	dba_const _CeladonBackAlleyCircleRocker1Text, TEXT_CELADONBACKALLEY_CIRCLE_ROCKER1
	dba_const _CeladonBackAlleyCircleRocker2Text, TEXT_CELADONBACKALLEY_CIRCLE_ROCKER2
	dba_const _CeladonBackAlleyCircleLeftBikerText, TEXT_CELADONBACKALLEY_LEFT_BIKER
	dba_const CeladonBackAlleyCircleRightRockerText, TEXT_CELADONBACKALLEY_RIGHT_ROCKER
	dba_const CeladonBackAlleyOpponentBikerText, TEXT_CELADONBACKALLEY_OPPONENT_BIKER
	dba_const CeladonBackAlleyOpponentCueBallText, TEXT_CELADONBACKALLEY_OPPONENT_CUE_BALL
	dba_const CeladonBackAlleyOpponentRockerText, TEXT_CELADONBACKALLEY_OPPONENT_ROCKER
	dba_const CeladonBackAlleyOpponentGamblerText, TEXT_CELADONBACKALLEY_OPPONENT_GAMBLER
	dba_const CeladonBackAlleyAfterBattle, TEXT_CELADONBACKALLEY_AFTER_BATTLE
	dba_const _SSAnneCaptainsRoomTrashText, TEXT_CELADONBACKALLEY_GARBAGE
	dba_const _CeladonBackAlleyKoffingGraffiti, TEXT_CELADONBACKALLEY_KOFFING_GRAFFITI

CeladonBackAlleyHooliganText:
	text_far _CeladonBackAlleyCircleHooliganText
	text_asm
;	CheckEvent EVENT_BEAT_ROCKET_HIDEOUT_GIOVANNI
;	jr nz, .allowedIn
;	ld hl, .noKidsAllowed
;	rst _PrintText
;	jr .leave
;.allowedIn
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
.leave
	call IsPlayerBesideCeladonBackAlleyHooligan
	jr nz, .done
	; force player to walk up 1 coord if battle not started and they were beside clerk
	ld a, PAD_UP
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
	ld [hl], PAD_DOWN
	inc hl
	ld a, [wXCoord]
	sub 18
	ld b, 1
	jr z, .beside 
	ld [hl], PAD_DOWN
	inc hl
	ld [hl], PAD_LEFT
	inc hl
	dec a
	ld b, 3
	jr z, .beside
	ld [hl], PAD_LEFT
	inc hl
	ld [hl], PAD_UP
	inc hl
	ld b, 5
.beside
	ld a, b
	ld [hl], -1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStatesOnlyAOrBPress
	ld a, CELADONBACKALLEY_HOOLIGAN
	call SetSpriteFacingDown
	rst TextScriptEnd
.intro
	text_far_end _CeladonBackAlleyCircleHooliganExplainText
.start
	text_far_end _CeladonBackAlleyCircleHooliganBattleText
;.noKidsAllowed
;	text_far_end _CeladonBackAlleyCircleHooliganNoKidsAllowedText

CeladonBackAlleyCircleRightRockerText:
	text_far _CeladonBackAlleyCircleRightRockerText
	text_asm
	ld a, MUSIC_MEET_MALE_TRAINER
	ld c, BANK(Music_MeetMaleTrainer)
	call PlayMusic
	ld c, 166
	rst DelayFrames
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
	text_far_end _CeladonBackAlleyCircleRightRockerThinkText
.yes
	text_far_end _CeladonBackAlleyCircleRightRockerYesText
.no
	text_far_end _CeladonBackAlleyCircleRightRockerNoText

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
	rst DelayFrames
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
	text_far_end _CeladonBackAlleyOpponentBikerIntro1
.intro2
	text_far_end _CeladonBackAlleyOpponentBikerIntro2
.intro3
	text_far_end _CeladonBackAlleyOpponentBikerIntro3
.intro4
	text_far_end _CeladonBackAlleyOpponentBikerIntro4

CeladonBackAlleyOpponentCueBallText:
	text_asm
	ld hl, .intro1
	jp GetRandomClubOpponentText
.intro1
	text_far_end _CeladonBackAlleyOpponentCueBallIntro1
.intro2
	text_far_end _CeladonBackAlleyOpponentCueBallIntro2
.intro3
	text_far_end _CeladonBackAlleyOpponentCueBallIntro3
.intro4
	text_far_end _CeladonBackAlleyOpponentCueBallIntro4

CeladonBackAlleyOpponentRockerText:
	text_asm
	ld hl, .intro1
	jp GetRandomClubOpponentText
.intro1
	text_far_end _CeladonBackAlleyOpponentRockerIntro1
.intro2
	text_far_end _CeladonBackAlleyOpponentRockerIntro2
.intro3
	text_far_end _CeladonBackAlleyOpponentRockerIntro3
.intro4
	text_far_end _CeladonBackAlleyOpponentRockerIntro4

CeladonBackAlleyOpponentGamblerText:
	text_asm
	ld hl, .intro1
	jp GetRandomClubOpponentText
.intro1
	text_far_end _CeladonBackAlleyOpponentGamblerIntro1
.intro2
	text_far_end _CeladonBackAlleyOpponentGamblerIntro2
.intro3
	text_far_end _CeladonBackAlleyOpponentGamblerIntro3
.intro4
	text_far_end _CeladonBackAlleyOpponentGamblerIntro4

CeladonBackAlleyAfterBattle:
	text_asm
	lb de, 32, 21
	call FitnessClubAfterBattleText
	jr c, .done
	; if nc, make the player leave
	ld a, PAD_UP
	ld hl, wSimulatedJoypadStatesEnd
	ld [hli], a
	ld [hli], a
	ld [hl], -1
	ld a, 2
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStatesOnlyAOrBPress
	ld hl, CeladonBackAlleyHideOpponent
	call FitnessClubHideOpponents
.done
	rst TextScriptEnd

CeladonBackAlleyHideOpponent:
	ld a, [wFitnessClubChallenger]
	ld c, a
	lb de, 50, 1
	jpfar FarMoveSpriteOffScreen
