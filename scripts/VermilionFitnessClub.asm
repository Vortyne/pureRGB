VermilionFitnessClub_Script:
	call EnableAutoTextBoxDrawing
	ld hl, wCurrentMapScriptFlags
	bit BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	jr nz, .afterBattle
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_MOVEMENT_STATE, a
	jr nz, .noPositionScripts
	call IsPlayerBesideVermilionFitnessClubClerk
	jr nz, .notBesideClerk
	ld a, VERMILIONFITNESSCLUB_CLERK
	call SetSpriteFacingRight
	call UpdateSprites
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	ld a, TEXT_VERMILIONFITNESSCLUB_CLERK
	ldh [hTextID], a
	call DisplayTextID
	jr .noPositionScripts
.notBesideClerk
	lb de, 10, 4
	call IsPlayerAtCoords ; battle position
	call z, StartVermilionFitnessClubBattle
.noPositionScripts
	ldh a, [hJoyPressed]
	bit BIT_A_BUTTON, a
	ret z
	callfar _GetTileAndCoordsInFrontOfPlayer
	ld a, [wTileInFrontOfPlayer]
	cp $5B
	ld b, TEXT_VERMILIONFITNESSCLUB_BIKES
	jr z, .displayText
	ld b, TEXT_VERMILIONFITNESSCLUB_WEIGHTS
	cp $59
	jr z, .displayText
	cp $5D
	jr z, .displayText
	cp $4B
	jr z, .displayText
	ret
.afterBattle
	call ResetFitnessBattleState
	ret z ; lost battle
	ld b, TEXT_VERMILIONFITNESSCLUB_AFTER_BATTLE
.displayText
	ld a, b
	ldh [hTextID], a
	jp DisplayTextID

ResetFitnessBattleState:
	xor a
	ld [wLevelLimit], a
	ResetEvent EVENT_IN_FITNESS_BATTLE
	ld a, [wIsInBattle]
	cp -1
	ret


VermilionFitnessClub_TextPointers:
	def_text_pointers
	dw_const VermilionFitnessClubClerk, TEXT_VERMILIONFITNESSCLUB_CLERK
	dw_const VermilionFitnessClubGirl1, TEXT_VERMILIONFITNESSCLUB_GIRL1
	dw_const VermilionFitnessClubGirl2, TEXT_VERMILIONFITNESSCLUB_GIRL2
	dw_const VermilionFitnessClubMuscular1, TEXT_VERMILIONFITNESSCLUB_MUSCLE1
	dw_const VermilionFitnessClubMuscular2, TEXT_VERMILIONFITNESSCLUB_MUSCLE2
	dw_const VermilionFitnessClubFitnessGirlOpponentText, TEXT_VERMILIONFITNESSCLUB_FITNESS_GIRL_OPPONENT
	dw_const VermilionFitnessClubSprinterOpponentText, TEXT_VERMILIONFITNESSCLUB_SPRINTER_OPPONENT
	dw_const VermilionFitnessClubSailorOpponentText, TEXT_VERMILIONFITNESSCLUB_SAILOR_OPPONENT
	dw_const VermilionFitnessClubBeautyOpponentText, TEXT_VERMILIONFITNESSCLUB_BEAUTY_OPPONENT
	dw_const VermilionFitnessClubSign, TEXT_VERMILIONFITNESSCLUB_SIGN
	dw_const VermilionFitnessClubAfterBattleText, TEXT_VERMILIONFITNESSCLUB_AFTER_BATTLE
	dw_const VermilionFitnessClubExerciseBikes, TEXT_VERMILIONFITNESSCLUB_BIKES
	dw_const VermilionFitnessClubDumbbells, TEXT_VERMILIONFITNESSCLUB_WEIGHTS

VermilionFitnessClubGirl1:
	text_far _VermilionFitnessClubGirl1
	text_end

VermilionFitnessClubGirl2:
	text_far _VermilionFitnessClubGirl2
	text_end

VermilionFitnessClubMuscular1:
	text_far _VermilionFitnessClubMuscular1
	text_end

VermilionFitnessClubMuscular2:
	text_far _VermilionFitnessClubMuscular2
	text_end

VermilionFitnessClubSign:
	text_far _VermilionFitnessClubSign
	text_end

VermilionFitnessClubClerk:
	text_far _VermilionFitnessClubClerkText
	text_asm
	CheckAndSetEvent EVENT_MET_VERMILION_FITNESS_CLERK
	jr nz, .met
	ld hl, .intro
	rst _PrintText
.met
	ld hl, .start
	rst _PrintText
	lb de, 20, 10 ; max opponent level, min opponent level
	call FitnessClubIntroScript
	jr c, .startBattle
	call IsPlayerBesideVermilionFitnessClubClerk
	jr nz, .done
	; force player to walk down 1 coord if battle not started and they were beside clerk
	ld a, D_DOWN
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
	ld [hl], D_RIGHT
	inc hl
	ld a, D_UP
	ld [hli], a
	ld [hli], a
	ld [hli], a
	call IsPlayerBesideVermilionFitnessClubClerk
	ld a, 4
	jr z, .beside
	ld [hl], D_UP
	inc hl
	ld [hl], D_RIGHT
	inc hl
	ld a, 6
.beside
	ld [hl], -1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	rst TextScriptEnd

.intro
	text_far _VermilionFitnessClubClerkIntroText
	text_end
.start
	text_far _VermilionFitnessClubClerkBattleText
	text_end

FitnessClubIntroScript::
	ld a, d
	ld [wLevelLimit], a
	ld a, e
	ld [wMinItemQuantity], a
	ld a, $FF
	ld [wFitnessClubChallenger], a
	push de
	call FitnessClubYesNoChoice
	pop de
	jr nz, .decidedNotToStart
	ld a, [wPartyMon1Level]
	ld c, a
	ld a, [wLevelLimit]
	dec a
	cp c
	ld hl, .firstPartyBelowLimit
	jr c, .printDone
.skipBeginning
	call ClearTextBox
	call SaveScreenTilesToBuffer2
	ld hl, .selectLevel
	rst _PrintText
	ld a, [wLevelLimit]
	ld [wMaxItemQuantity], a
	ld [wInitialItemQuantity], a
	call DisplayChooseQuantityMenuMinQuantity
	cp $FF ; pressed B
	jr z, .decidedNotToStart
	call LoadScreenTilesFromBuffer2
	ld a, [wItemQuantity]
	ld [wFitnessOpponentLevel], a
	ld hl, .selectMonAmount
	rst _PrintText
	ld a, 6
	ld [wMaxItemQuantity], a
	call DisplayChooseQuantityMenu
	cp $FF ; pressed B
	jr z, .decidedNotToStart
	call LoadScreenTilesFromBuffer2
	ld a, [wItemQuantity]
	ld [wFitnessOpponentMonCount], a
	ld hl, .startBattle
	rst _PrintText
	scf
	ret
.decidedNotToStart
	ld hl, .suitYourself
.printDone
	rst _PrintText
	and a
	ret
.firstPartyBelowLimit
	text_far _FitnessClubLevel
	text_end
.selectLevel
	text_far _FitnessClubClerkSelectLevelText
	text_end
.selectMonAmount
	text_far _FitnessClubClerkSelectMonAmountText
	text_end
.suitYourself
	text_far _GenericSuitYourselfText
	text_end
.startBattle
	text_far _VermilionFitnessClubClerkBattleStartText
	text_end

; input d = level limit
AnyPartyMonBelowLevelLimit:
	ld hl, wPartyMon1Level
	ld a, [wPartyCount]
	ld e, a
	ld bc, wPartyMon2Level - wPartyMon1Level
.loop
	; is there at least one mon in the party below or equal to the level limit
	ld a, [hl]
	cp d
	jr c, .found
	add hl, bc
	dec e
	jr nz, .loop
	and a
	ret
.found
	scf
	ret

IsPlayerBesideVermilionFitnessClubClerk:
	lb de, 9, 7
	jp IsPlayerAtCoords

StartVermilionFitnessClubBattle:
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	call UpdateSprites
	ld c, 30
	rst _DelayFrames
	call VermilionFitnessClubHideOpponents ; hide previous opponents if applicable
	ld hl, AvailableVermilionFitnessClubTrainers
	lb de, -3, 0
	; fall through
StartFitnessClubBattle::
	push de
	push hl
	call GBPalWhiteOut
	ld a, SFX_TELEPORT_ENTER_2
	rst _PlaySound
.reRoll
	call Random
	pop hl
	push hl
	and %11
	ld d, 0
	ld e, a
	add hl, de
	add hl, de
	ld a, [hli]
	ld [wCurOpponent], a
	ld a, 1
	ld [wTrainerNo], a ; doesn't matter which
	ld a, [wFitnessClubChallenger]
	ld b, a
	ld a, [hl]
	cp b
	jr z, .reRoll ; don't have the same challenger sprite twice, looks worse visually
	pop hl
	ld [wFitnessClubChallenger], a
	ld c, a
	pop de
	push af
	callfar FarMoveSpriteInRelationToPlayer
	call UpdateSprites
	call Delay3
	call GBPalNormal
	ld c, 30
	rst _DelayFrames
	pop af
	ldh [hTextID], a
	SetEvent EVENT_IN_FITNESS_BATTLE
	jp DisplayTextID


AvailableVermilionFitnessClubTrainers:
	db OPP_FITNESS_GIRL, VERMILIONFITNESSCLUB_FITNESS_GIRL_OPPONENT
	db OPP_SPRINTER, VERMILIONFITNESSCLUB_SPRINTER_OPPONENT
	db OPP_SAILOR, VERMILIONFITNESSCLUB_SAILOR_OPPONENT
	db OPP_BEAUTY, VERMILIONFITNESSCLUB_BEAUTY_OPPONENT
	ASSERT VERMILIONFITNESSCLUB_FITNESS_GIRL_OPPONENT == TEXT_VERMILIONFITNESSCLUB_FITNESS_GIRL_OPPONENT
	ASSERT VERMILIONFITNESSCLUB_SPRINTER_OPPONENT == TEXT_VERMILIONFITNESSCLUB_SPRINTER_OPPONENT
	ASSERT VERMILIONFITNESSCLUB_SAILOR_OPPONENT == TEXT_VERMILIONFITNESSCLUB_SAILOR_OPPONENT
	ASSERT VERMILIONFITNESSCLUB_BEAUTY_OPPONENT == TEXT_VERMILIONFITNESSCLUB_BEAUTY_OPPONENT

VermilionFitnessClubFitnessGirlOpponentText:
	text_asm
	ld hl, .intro1
	jr GetRandomClubOpponentText
.intro1
	text_far _VermilionFitnessClubFitnessGirlOpponentIntro1
	text_end
.intro2
	text_far _VermilionFitnessClubFitnessGirlOpponentIntro2
	text_end
.intro3
	text_far _VermilionFitnessClubFitnessGirlOpponentIntro3
	text_end
.intro4
	text_far _VermilionFitnessClubFitnessGirlOpponentIntro4
	text_end

VermilionFitnessClubSprinterOpponentText:
	text_asm
	ld hl, .intro1
	jr GetRandomClubOpponentText
.intro1
	text_far _VermilionFitnessClubSprinterOpponentIntro1
	text_end
.intro2
	text_far _VermilionFitnessClubSprinterOpponentIntro2
	text_end
.intro3
	text_far _VermilionFitnessClubSprinterOpponentIntro3
	text_end
.intro4
	text_far _VermilionFitnessClubSprinterOpponentIntro4
	text_end

VermilionFitnessClubSailorOpponentText:
	text_asm
	ld hl, .intro1
	jr GetRandomClubOpponentText
.intro1
	text_far _VermilionFitnessClubSailorOpponentIntro1
	text_end
.intro2
	text_far _VermilionFitnessClubSailorOpponentIntro2
	text_end
.intro3
	text_far _VermilionFitnessClubSailorOpponentIntro3
	text_end
.intro4
	text_far _VermilionFitnessClubSailorOpponentIntro4
	text_end

VermilionFitnessClubBeautyOpponentText:
	text_asm
	ld hl, .intro1
	jr GetRandomClubOpponentText
.intro1
	text_far _VermilionFitnessClubBeautyOpponentIntro1
	text_end
.intro2
	text_far _VermilionFitnessClubBeautyOpponentIntro2
	text_end
.intro3
	text_far _VermilionFitnessClubBeautyOpponentIntro3
	text_end
.intro4
	text_far _VermilionFitnessClubBeautyOpponentIntro4
	text_end

GetRandomClubOpponentText:
	ld a, [wFitnessClubChallenger]
	ld [hTextID], a ; makes the battle transition show the correct 
	call Random
	and %11
	ld d, 0
	ld e, a
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	add hl, de ; 5 bytes per text_far / text end combo
	rst _PrintText
	rst TextScriptEnd

VermilionFitnessClubAfterBattleText:
	text_asm
	lb de, 20, 10
	call FitnessClubAfterBattleText
	jr c, .done
	; if nc, make the player leave
	ld a, D_DOWN
	ld hl, wSimulatedJoypadStatesEnd
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, D_LEFT
	ld [hli], a
	ld [hl], -1
	ld a, 5
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld hl, VermilionFitnessClubHideOpponents
	call FitnessClubHideOpponents
.done
	rst TextScriptEnd

; hl = function for hiding opponents
FitnessClubHideOpponents:
	push hl
	call GBPalWhiteOut
	ld a, SFX_TELEPORT_ENTER_2
	rst _PlaySound
	pop hl
	call hl_caller
	call UpdateSprites
	call Delay3
	jp GBPalNormal

VermilionFitnessClubHideOpponents:
	ld a, [wFitnessClubChallenger]
	ld c, a
	lb de, 24, 8
	jpfar FarMoveSpriteOffScreen


FitnessClubAfterBattleText::
	push de
	call AnyPartyMonBelowLevelLimit
	pop de
	ld hl , .allLevelLimit
	jr nc, .printDoneLeave
	push de
	ld hl, .battleAgain
	rst _PrintText
	call FitnessClubYesNoChoice
	pop de
	ld hl, .doneBattling
	jr nz, .printDoneLeave
	ld a, d
	ld [wLevelLimit], a
	ld a, e
	ld [wMinItemQuantity], a
	ld a, SFX_HEAL_HP
	rst _PlaySound
	predef HealParty
	; if the player's first pokemon is at or above the level limit, auto switch another pokemon to the first slot
	ld a, [wLevelLimit]
	ld b, a
	ld a, [wPartyMon1Level]
	cp b
	jr c, .firstMonBelowLimit
	ld hl, wPartyMon2Level
	ld de, wPartyMon2Level - wPartyMon1Level
	ld a, [wPartyCount]
	; wPartyCount = guaranteed to be at least 2 here
	dec a
	ld c, a
.loopFindMonBelowLimit
	ld a, [hl]
	add hl, de
	cp b ; b = still level limit
	jr c, .foundMon
	dec c
	jr nz, .loopFindMonBelowLimit
.foundMon
	ld a, [wPartyCount]
	sub c
	ld [wCurrentMenuItem], a
  	ld a, 1
  	ld [wMenuItemToSwap], a
  	callfar SwitchPartyMon_InitVarOrSwapData
.firstMonBelowLimit
	ld hl, .changeSettings
	rst _PrintText
	call FitnessClubYesNoChoice
	jr nz, .settings
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	scf
	ret
.settings
	call FitnessClubIntroScript.skipBeginning ; re-choose settings
	scf
	ret
.printDoneLeave
	ld a, d
	ld [wLevelLimit], a
	rst _PrintText
	xor a
	ld [wLevelLimit], a
	and a
	ret
.allLevelLimit
	text_far _FitnessClubAllLevelLimit
	text_far _FitnessClubDone
	text_end
.battleAgain
	text_far _FitnessClubBattleAgain
	text_end
.changeSettings
	text_far _FitnessClubChangeSettings
	text_end
.doneBattling
	text_far _FitnessClubDone
	text_end

FitnessClubYesNoChoice:
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ret

VermilionFitnessClubExerciseBikes:
	text_far _VermilionFitnessClubExerciseBikes
	text_end

VermilionFitnessClubDumbbells:
	text_far _VermilionFitnessClubDumbbells
	text_end
