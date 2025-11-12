GameCornerPrizeRoom_Script:
	jp EnableAutoTextBoxDrawing

GameCornerPrizeRoom_TextPointers:
	def_text_pointers
	dw_const GameCornerPrizeRoomBaldingGuyText,  TEXT_GAMECORNERPRIZEROOM_BALDING_GUY
	dw_const GameCornerPrizeRoomGamblerText,     TEXT_GAMECORNERPRIZEROOM_GAMBLER
	dw_const GameCornerPrizeRoomPrizeKingText,     TEXT_GAMECORNERPRIZEROOM_PRIZE_KING
	dw_const GameCornerPRizeRoomPrizeVendorText, TEXT_GAMECORNERPRIZEROOM_PRIZE_VENDOR_1
	dw_const GameCornerPRizeRoomPrizeVendorText, TEXT_GAMECORNERPRIZEROOM_PRIZE_VENDOR_2
	dw_const GameCornerPRizeRoomPrizeVendorText, TEXT_GAMECORNERPRIZEROOM_PRIZE_VENDOR_3
	EXPORT TEXT_GAMECORNERPRIZEROOM_PRIZE_VENDOR_1 ; used by engine/events/prize_menu.asm

GameCornerPrizeRoomBaldingGuyText:
	text_far _GameCornerPrizeRoomBaldingGuyText
	text_end

GameCornerPrizeRoomGamblerText:
	text_far _GameCornerPrizeRoomGamblerText
	text_end

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
	ld a, [wCurrentMenuItem]
	and a
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
	predef IndexToPokedex
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
	text_far _GameCornerPrizeRoomPrizeMasterText
	text_end
.normalIntro
	text_far _GameCornerPrizeRoomPrizeMasterAgainText
	text_end
.info
	text_far _GameCornerPrizeRoomInfoText
	text_end
.suitYourself
	text_far _GenericSuitYourselfText
	text_end
.woohoo
	text_far _GameCornerPrizeRoomLetsSeeText
	text_end
.wrongMon
	text_far _SecretLabMewtwoReactionText4
	text_end
.gotAnother
	text_far _PrizeKingGotAnotherText
	text_end

PrizeKingName:
	db "PRIZE PRO@"

PrizeKingTextPointers:
	dbw JYNX, JynxPrizeKingText
	dbw ELECTABUZZ, ElectabuzzPrizeKingText
	dbw TANGELA, TangelaPrizeKingText
	dbw DRATINI, DratiniPrizeKingText
	dbw DITTO, DittoPrizeKingText
	dbw PORYGON, PorygonPrizeKingText

JynxPrizeKingText:
	text_far _JynxPrizeKingText
	text_end

ElectabuzzPrizeKingText:
	text_far _ElectabuzzPrizeKingText
	text_end

TangelaPrizeKingText:
	text_far _TangelaPrizeKingText
	text_end

DratiniPrizeKingText:
	text_far _DratiniPrizeKingText
	text_end

DittoPrizeKingText:
	text_far _DittoPrizeKingText
	text_end

PorygonPrizeKingText:
	text_far _PorygonPrizeKingText
	text_end

GameCornerPRizeRoomPrizeVendorText:
	script_prize_vendor
