Museum1F_Script:
	call DisableAutoTextBoxDrawing
	ld hl, Museum1F_ScriptPointers
	ld a, [wMuseum1FCurScript]
	jp CallFunctionInTable

Museum1F_ScriptPointers:
	def_script_pointers
	dw_const Museum1FDefaultScript, SCRIPT_MUSEUM1F_DEFAULT
	dw_const DoRet,                 SCRIPT_MUSEUM1F_NOOP

Museum1FDefaultScript:
	ld a, [wYCoord]
	cp 4
	ret nz
	ld a, [wXCoord]
	cp 9
	jr z, .continue
	ld a, [wXCoord]
	cp 10
	ret nz
.continue
	xor a
	ldh [hJoyHeld], a
	ld a, TEXT_MUSEUM1F_SCIENTIST1
	ldh [hTextID], a
	jp DisplayTextID

Museum1F_TextPointers:
	def_text_pointers
	dw_const Museum1FScientist1Text, TEXT_MUSEUM1F_SCIENTIST1
	dw_const Museum1FGamblerText,    TEXT_MUSEUM1F_GAMBLER
	dw_const Museum1FScientist2Text, TEXT_MUSEUM1F_SCIENTIST2
	dw_const Museum1FScientist3Text, TEXT_MUSEUM1F_SCIENTIST3
	dw_const Museum1FOldAmberText,   TEXT_MUSEUM1F_OLD_AMBER
	dw_const Museum1FAerodactylFossilText, TEXT_MUSEUM1F_AERODACTYL_FOSSIL
	dw_const Museum1FKabutopsFossilText, TEXT_MUSEUM1F_KABUTOPS_FOSSIL

Museum1FScientist1Text:
	text_asm
	ld a, [wYCoord]
	cp 4
	jr nz, .not_right_of_scientist
	ld a, [wXCoord]
	cp 13
	jp z, .behind_counter
	jr .check_ticket
.not_right_of_scientist
	cp 3
	jr nz, .not_behind_counter
	ld a, [wXCoord]
	cp 12
	jp z, .behind_counter
.not_behind_counter
	CheckEvent EVENT_BOUGHT_MUSEUM_TICKET
	jr nz, .already_bought_ticket
	ld hl, .GoToOtherSideText
	rst _PrintText
	rst TextScriptEnd
.check_ticket
	CheckEvent EVENT_BOUGHT_MUSEUM_TICKET
	jr z, .no_ticket
.already_bought_ticket
	ld hl, .TakePlentyOfTimeText
	rst _PrintText
	rst TextScriptEnd
	
.no_ticket
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	xor a
	ldh [hJoyHeld], a
	ld hl, .WouldYouLikeToComeInText
	rst _PrintText
	call YesNoChoice
	jr nz, .deny_entry
	xor a
	ldh [hMoney], a
	ldh [hMoney + 1], a
	ld a, $50
	ldh [hMoney + 2], a
	call HasEnoughMoney
	jr nc, .buy_ticket
	ld hl, .DontHaveEnoughMoneyText
	rst _PrintText

.deny_entry
	ld hl, .ComeAgainText
	rst _PrintText
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates
	call UpdateSprites
	rst TextScriptEnd

.buy_ticket
	ld hl, .ThankYouText
	rst _PrintText
	SetEvent EVENT_BOUGHT_MUSEUM_TICKET
	xor a
	ld [wPriceTemp], a
	ld [wPriceTemp + 1], a
	ld a, $50
	ld [wPriceTemp + 2], a
	ld hl, wPriceTemp + 2
	ld de, wPlayerMoney + 2
	ld c, $3
	predef SubBCDPredef
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld a, SFX_PURCHASE
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
.allow_entry
	ld a, SCRIPT_MUSEUM1F_NOOP
	ld [wMuseum1FCurScript], a
	rst TextScriptEnd

.behind_counter
	ld hl, .DoYouKnowWhatAmberIsText
	rst _PrintText
	call YesNoChoice
	ld hl, .AmberIsFossilizedTreeSapText
	jr nz, .printDone
	ld hl, .TheresALabSomewhereText
.printDone
	rst _PrintText
	rst TextScriptEnd

.ComeAgainText:
	text_far _Museum1FScientist1ComeAgainText
	text_end

.WouldYouLikeToComeInText:
	text_far _Museum1FScientist1WouldYouLikeToComeInText
	text_end

.ThankYouText:
	text_far _Museum1FScientist1ThankYouText
	text_end

.DontHaveEnoughMoneyText:
	text_far _GenericYouDontHaveEnoughMoneyText
	text_end

.DoYouKnowWhatAmberIsText:
	text_far _Museum1FScientist1DoYouKnowWhatAmberIsText
	text_end

.TheresALabSomewhereText:
	text_far _Museum1FScientist1TheresALabSomewhereText
	text_end

.AmberIsFossilizedTreeSapText:
	text_far _Museum1FScientist1AmberIsFossilizedTreeSapText
	text_end

.GoToOtherSideText:
	text_far _Museum1FScientist1GoToOtherSideText
	text_end

.TakePlentyOfTimeText:
	text_far _Museum1FScientist1TakePlentyOfTimeText
	text_end

Museum1FGamblerText:
	text_asm
	ld hl, .text
	rst _PrintText
	rst TextScriptEnd
.text
	text_far _Museum1FGamblerText
	text_end

Museum1FScientist2Text:
	text_asm
	CheckEvent EVENT_GOT_OLD_AMBER
	jr nz, .got_item
	ld hl, .TakeThisToAPokemonLabText
	rst _PrintText
	lb bc, OLD_AMBER, 1
	call GiveItem
	ld hl, .YouDontHaveSpaceText
	jr nc, .done
	SetEvent EVENT_GOT_OLD_AMBER
	ld a, TOGGLE_OLD_AMBER
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld hl, .ReceivedOldAmberText
	jr .done
.checked
	ld hl, .amberHasBeenChecked
	rst _PrintText
	lb hl, DEX_AERODACTYL, SCIENTIST
	ld de, TextNothing
	ld bc, LearnsetFadeOutInDetails
	predef_jump LearnsetTrainerScriptMain
.got_item
	CheckEvent EVENT_RECEIVED_AERODACTYL_FROM_SUPER_NERD
	jr nz, .checked
	CheckEvent EVENT_CINNABAR_LAB_REVIVED_AERODACTYL
	jr nz, .checked
	ld hl, .GetTheOldAmberCheckText
.done
	rst _PrintText
	rst TextScriptEnd

.TakeThisToAPokemonLabText:
	text_far _Museum1FScientist2TakeThisToAPokemonLabText
	text_end

.ReceivedOldAmberText:
	text_far _GenericPlayerReceivedText
	sound_get_item_1
	text_end

.GetTheOldAmberCheckText:
	text_far _Museum1FScientist2GetTheOldAmberCheckText
	text_end

.YouDontHaveSpaceText:
	text_far _Museum1FScientist2YouDontHaveSpaceText
	text_end

.amberHasBeenChecked
	text_far _Museum1FScientist2GetTheOldAmberRevivedText
	text_end

Museum1FScientist3Text:
	text_asm
	ld hl, .text
	rst _PrintText
	rst TextScriptEnd
.text
	text_far _Museum1FScientist3Text
	text_end

Museum1FOldAmberText:
	text_asm
	ld hl, .text
	rst _PrintText
	rst TextScriptEnd
.text
	text_far _Museum1FOldAmberText
	text_end

Museum1FAerodactylFossilText:
	text_asm
	ld a, AERODACTYL
	ld b, FOSSIL_AERODACTYL
.fossil
	push bc
	ld [wNamedObjectIndex], a
	call GetMonName
	pop bc
	ld a, b
	ld [wCurPartySpecies], a
	call DisplayMonFrontSpriteInBox
	xor a
	ldh [hWY], a
	call LoadFontTilePatterns
	ld hl, .text
	rst _PrintText
	rst TextScriptEnd
.text
	text_far _AerodactylKabutopsFossilText
	text_end

Museum1FKabutopsFossilText:
	text_asm
	ld a, KABUTOPS
	ld b, FOSSIL_KABUTOPS
	jr Museum1FAerodactylFossilText.fossil

;;;;;;;; PureRGBnote: FIXED: Updated function to display the correct pokemon palette
DisplayMonFrontSpriteInBox::
; Displays a pokemon's front sprite in a pop-up window.
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	xor a
	ldh [hWY], a
	call SaveScreenTilesToBuffer1
	ld a, MON_SPRITE_POPUP
	ld [wTextBoxID], a
	call DisplayTextBoxID
	call UpdateSpritesAndDelay3 ; allow box to finish rendering before setting palette
	ld b, SET_PAL_MIDDLE_SCREEN_MON_BOX
	call RunPaletteCommand
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetMonHeader
	ld de, vChars1 tile $31
	call LoadMonFrontSprite
	ld a, $80
	ldh [hStartTileID], a
	hlcoord 10, 11
	predef AnimateSendingOutMon
	ld a, [wCurPartySpecies]
	cp FOSSIL_KABUTOPS
	jr z, .skipCry
	cp FOSSIL_AERODACTYL
	call nz, PlayCry
.skipCry
	call WaitForTextScrollButtonPress
	ld a, MON_SPRITE_POPUP
	ld [wTextBoxID], a
	call DisplayTextBoxID ; redisplay the box to clear the pokemon sprite out
	call Delay3 ; allow box to finish clearing 
	call RunDefaultPaletteCommand ; reset palette to what it was before displaying this box
	call LoadScreenTilesFromBuffer1 ; close the box
	call Delay3 ; allow box to finish closing before resetting hWY
	ld a, $90
	ldh [hWY], a
	ret
;;;;;;;;
