VermilionFitnessClub_Script:
	call EnableAutoTextBoxDrawing
	CheckEvent EVENT_GOT_HM01
	jr nz, .partysOver
	lb de, 9, 9
	call IsPlayerAtCoords
	ret nz
	call UpdateSpritesAndDelay3
	ld a, TEXT_VERMILIONFITNESSCLUB_JANITOR
	ldh [hTextID], a
	jp DisplayTextID
.partysOver
	ld hl, wCurrentMapScriptFlags
	bit BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	jr nz, .afterBattle
	call WasMapJustLoaded
	jr z, .notLoaded
	ld c, TOGGLE_VERMILIONFITNESSCLUB_JANITOR
	call HideExtraObject
.notLoaded
	call IsPlayerAutoMoving
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
	bit B_PAD_A, a
	ret z
	call GetTileAndCoordsInFrontOfPlayer
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
	dba_const VermilionFitnessClubClerk, TEXT_VERMILIONFITNESSCLUB_CLERK
	dba_const _VermilionFitnessClubGirl1, TEXT_VERMILIONFITNESSCLUB_GIRL1
	dba_const _VermilionFitnessClubGirl2, TEXT_VERMILIONFITNESSCLUB_GIRL2
	dba_const _VermilionFitnessClubMuscular1, TEXT_VERMILIONFITNESSCLUB_MUSCLE1
	dba_const _VermilionFitnessClubMuscular2, TEXT_VERMILIONFITNESSCLUB_MUSCLE2
	dba_const VermilionFitnessClubFitnessGirlOpponentText, TEXT_VERMILIONFITNESSCLUB_FITNESS_GIRL_OPPONENT
	dba_const VermilionFitnessClubSprinterOpponentText, TEXT_VERMILIONFITNESSCLUB_SPRINTER_OPPONENT
	dba_const VermilionFitnessClubSailorOpponentText, TEXT_VERMILIONFITNESSCLUB_SAILOR_OPPONENT
	dba_const VermilionFitnessClubBeautyOpponentText, TEXT_VERMILIONFITNESSCLUB_BEAUTY_OPPONENT
	dba_const VermilionFitnessClubJanitorText, TEXT_VERMILIONFITNESSCLUB_JANITOR
	dba_const _VermilionFitnessClubSign, TEXT_VERMILIONFITNESSCLUB_SIGN
	dba_const VermilionFitnessClubAfterBattleText, TEXT_VERMILIONFITNESSCLUB_AFTER_BATTLE
	dba_const _VermilionFitnessClubExerciseBikes, TEXT_VERMILIONFITNESSCLUB_BIKES
	dba_const _VermilionFitnessClubDumbbells, TEXT_VERMILIONFITNESSCLUB_WEIGHTS

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
	; force player to walk down 1 coord if battle not started and they were beside clerk
	call z, VermilionFitnessClubForceWalkDown
	rst TextScriptEnd
.startBattle
	ld hl, wSimulatedJoypadStatesEnd
	ld [hl], PAD_RIGHT
	inc hl
	ld a, PAD_UP
	ld [hli], a
	ld [hli], a
	ld [hli], a
	call IsPlayerBesideVermilionFitnessClubClerk
	ld a, 4
	jr z, .beside
	ld [hl], PAD_UP
	inc hl
	ld [hl], PAD_RIGHT
	inc hl
	ld a, 6
.beside
	ld [hl], -1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStatesOnlyAOrBPress
	rst TextScriptEnd

.intro
	text_far_end _VermilionFitnessClubClerkIntroText
.start
	text_far_end _VermilionFitnessClubClerkBattleText

VermilionFitnessClubForceWalkDown:	
	ld a, PAD_DOWN
	ld hl, wSimulatedJoypadStatesEnd
	ld [hli], a
	ld [hl], -1
	ld a, 1
	ld [wSimulatedJoypadStatesIndex], a
	jp StartSimulatingJoypadStates

FitnessClubIntroScript::
	ld a, d
	ld [wLevelLimit], a
	ld a, e
	ld [wMinItemQuantity], a
	ld a, $FF
	ld [wFitnessClubChallenger], a
	push de
	call YesNoChoice
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
	text_far_end _FitnessClubLevel
.selectLevel
	text_far_end _FitnessClubClerkSelectLevelText
.selectMonAmount
	text_far_end _FitnessClubClerkSelectMonAmountText
.suitYourself
	text_far_end _GenericSuitYourselfText
.startBattle
	text_far_end _VermilionFitnessClubClerkBattleStartText

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
	rst DelayFrames
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
	call UpdateSpritesAndDelay3
	call GBPalNormal
	ld c, 30
	rst DelayFrames
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
	text_far_end _VermilionFitnessClubFitnessGirlOpponentIntro1
.intro2
	text_far_end _VermilionFitnessClubFitnessGirlOpponentIntro2
.intro3
	text_far_end _VermilionFitnessClubFitnessGirlOpponentIntro3
.intro4
	text_far_end _VermilionFitnessClubFitnessGirlOpponentIntro4

VermilionFitnessClubSprinterOpponentText:
	text_asm
	ld hl, .intro1
	jr GetRandomClubOpponentText
.intro1
	text_far_end _VermilionFitnessClubSprinterOpponentIntro1
.intro2
	text_far_end _VermilionFitnessClubSprinterOpponentIntro2
.intro3
	text_far_end _VermilionFitnessClubSprinterOpponentIntro3
.intro4
	text_far_end _VermilionFitnessClubSprinterOpponentIntro4

VermilionFitnessClubSailorOpponentText:
	text_asm
	ld hl, .intro1
	jr GetRandomClubOpponentText
.intro1
	text_far_end _VermilionFitnessClubSailorOpponentIntro1
.intro2
	text_far_end _VermilionFitnessClubSailorOpponentIntro2
.intro3
	text_far_end _VermilionFitnessClubSailorOpponentIntro3
.intro4
	text_far_end _VermilionFitnessClubSailorOpponentIntro4

VermilionFitnessClubBeautyOpponentText:
	text_asm
	ld hl, .intro1
	jr GetRandomClubOpponentText
.intro1
	text_far_end _VermilionFitnessClubBeautyOpponentIntro1
.intro2
	text_far_end _VermilionFitnessClubBeautyOpponentIntro2
.intro3
	text_far_end _VermilionFitnessClubBeautyOpponentIntro3
.intro4
	text_far_end _VermilionFitnessClubBeautyOpponentIntro4

GetRandomClubOpponentText:
	ld a, [wFitnessClubChallenger]
	ld [hTextID], a ; makes the battle transition show the correct 
	call Random
	and %11
	ld d, 0
	add a
	add a ; multiply by TEXT_FAR_TABLE_ENTRY_SIZE
	ld e, a 
	add hl, de
	rst _PrintText
	rst TextScriptEnd

VermilionFitnessClubAfterBattleText:
	text_asm
	lb de, 20, 10
	call FitnessClubAfterBattleText
	jr c, .done
	; if nc, make the player leave
	ld a, PAD_DOWN
	ld hl, wSimulatedJoypadStatesEnd
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, PAD_LEFT
	ld [hli], a
	ld [hl], -1
	ld a, 5
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStatesOnlyAOrBPress
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
	call UpdateSpritesAndDelay3
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
	call YesNoChoice
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
	call YesNoChoice
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
	text_far_end _FitnessClubDone
.battleAgain
	text_far_end _FitnessClubBattleAgain
.changeSettings
	text_far_end _FitnessClubChangeSettings
.doneBattling
	text_far_end _FitnessClubDone

VermilionFitnessClubJanitorText:
	text_far _VermilionFitnessClubJanitorText
	text_asm
	call VermilionFitnessClubForceWalkDown
	rst TextScriptEnd
