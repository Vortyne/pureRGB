GameCornerPrizeRoom_Script:
	jp EnableAutoTextBoxDrawing

GameCornerPrizeRoom_TextPointers:
	def_text_pointers
	dba_const _GameCornerPrizeRoomBaldingGuyText,  TEXT_GAMECORNERPRIZEROOM_BALDING_GUY
	dba_const _GameCornerPrizeRoomGamblerText,     TEXT_GAMECORNERPRIZEROOM_GAMBLER
	dba_const GameCornerPrizeRoomPrizeKingText,     TEXT_GAMECORNERPRIZEROOM_PRIZE_KING
	dba_const GameCornerPRizeRoomPrizeVendorText, TEXT_GAMECORNERPRIZEROOM_PRIZE_VENDOR_1
	dba_const GameCornerPRizeRoomPrizeVendorText, TEXT_GAMECORNERPRIZEROOM_PRIZE_VENDOR_2
	dba_const GameCornerPRizeRoomPrizeVendorText, TEXT_GAMECORNERPRIZEROOM_PRIZE_VENDOR_3
	EXPORT TEXT_GAMECORNERPRIZEROOM_PRIZE_VENDOR_1 ; used by engine/events/prize_menu.asm

GameCornerPrizeRoomPrizeKingText:
	text_asm
	ld de, PrizeKingName
	call CopyTrainerName
	CheckAndSetEvent EVENT_MET_PRIZE_MASTER
	ld hl, .firstMeeting
	jr z, .gotFirstMsg
	ld hl, .normalIntro
.gotFirstMsg
	rst _PrintText
	ld hl, .info
	rst _PrintText
.choice
	call YesNoChoice
	ld hl, .suitYourself
	jr nz, .printDone
	ld hl, .woohoo
	rst _PrintText
	call ClearTextBox
	call SaveScreenTilesToBuffer2
	xor a ; NORMAL_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	dec a
	ld [wUpdateSpritesEnabled], a
	call DisplayPartyMenu
	push af
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadGBPal
	pop af
	ld hl, .suitYourself
	jr c, .printDone
	callfar IsMonAPrizePokemon
	ld hl, .wrongMon
	jr nc, .printDone
	ld a, [wCurPartySpecies]
	ld [wPokedexNum], a
	call GetMonName
	ld a, [wPokedexNum]
	ld hl, PrizeKingTextPointers
	ld de, 3
	call IsInArray
	inc hl
	hl_deref
	rst _PrintText
	call IndexToPokedex
	ld a, [wPokedexNum]
	ld h, a
	ld l, $FF
	ld de, TextNothing 
	ld bc, LearnsetFadeOutInDetails
	predef LearnsetTrainerScriptMain
	call DisplayTextPromptButton
	ld hl, .gotAnother
	rst _PrintText
	jr .choice
.printDone
	rst _PrintText
	rst TextScriptEnd

.firstMeeting
	text_far_end _GameCornerPrizeRoomPrizeMasterText
.normalIntro
	text_far_end _GameCornerPrizeRoomPrizeMasterAgainText
.info
	text_far_end _GameCornerPrizeRoomInfoText
.suitYourself
	text_far_end _GenericSuitYourselfText
.woohoo
	text_far_end _GameCornerPrizeRoomLetsSeeText
.wrongMon
	text_far_end _SecretLabMewtwoReactionText4
.gotAnother
	text_far_end _PrizeKingGotAnotherText

PrizeKingName:
	db "PRIZE PRO@"

; TODO: extra pointer not needed
PrizeKingTextPointers:
	dbw JYNX, JynxPrizeKingText
	dbw ELECTABUZZ, ElectabuzzPrizeKingText
	dbw TANGELA, TangelaPrizeKingText
	dbw DRATINI, DratiniPrizeKingText
	dbw DITTO, DittoPrizeKingText
	dbw PORYGON, PorygonPrizeKingText

JynxPrizeKingText:
	text_far_end _JynxPrizeKingText

ElectabuzzPrizeKingText:
	text_far_end _ElectabuzzPrizeKingText

TangelaPrizeKingText:
	text_far_end _TangelaPrizeKingText

DratiniPrizeKingText:
	text_far_end _DratiniPrizeKingText

DittoPrizeKingText:
	text_far_end _DittoPrizeKingText

PorygonPrizeKingText:
	text_far_end _PorygonPrizeKingText

GameCornerPRizeRoomPrizeVendorText:
	text_asm
	callfar CeladonPrizeMenu
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	rst TextScriptEnd
