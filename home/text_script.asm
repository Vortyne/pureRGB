; this function is used to display sign messages, sprite dialog, etc.
; INPUT: [hSpriteIndex] = sprite ID or [hTextID] = text ID
DisplayTextID::
	ASSERT hSpriteIndex == hTextID ; these are at the same memory location
	ldh a, [hLoadedROMBank]
	push af
	farcall DisplayTextIDInit ; initialization
	ld hl, wTextPredefFlag
	bit BIT_TEXT_PREDEF, [hl]
	res BIT_TEXT_PREDEF, [hl]
	jr nz, .skipSwitchToMapBank
	ld a, [wCurMap]
	call SwitchToMapRomBank
.skipSwitchToMapBank
	ld a, 30 ; half a second
	ldh [hFrameCounter], a ; used as joypad poll timer
	ld hl, wCurMapTextPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = map text pointer
	ld d, $00
	ldh a, [hTextID]
	ld [wSpriteIndex], a
	and a
	jp z, DisplayStartMenu
	cp $FF
	jp z, CloseTextDisplay
	sub GENERIC_TEXT_IDS_START
	jr c, .continue
	ld hl, GenericTextScriptJumpTable
	call GetAddressFromPointerArray
	jp hl
.continue
	ld a, [wNumSprites]
	ld e, a
	ldh a, [hSpriteIndex] ; sprite ID
	cp e
	jr z, .spriteHandling
	jr nc, .skipSpriteHandling
.spriteHandling
; get the text ID of the sprite
	push hl
;;;; PureRGBnote: CHANGED: this code was removed in yellow version and seems to have been broken anyway. It isn't really needed even if we fix it.
	;push de
	;push bc
	;farcall UpdateSpriteFacingOffsetAndDelayMovement ; update the graphics of the sprite the player is talking to (to face the right direction)
	;pop bc
	;pop de
;;;;
	ld hl, wMapSpriteData ; NPC text entries
	ldh a, [hSpriteIndex]
	dec a
	add a
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	inc hl
	ld a, [hl] ; a = text ID of the sprite
	pop hl
.skipSpriteHandling
; look up the address of the text in the map's text entries
	dec a
	ld e, a
	sla e
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = address of the text
	ld a, [hl] ; a = first byte of text

; check first byte of text for special cases
	sub FIRST_GENERIC_NPC_TEXT_SCRIPT
	jr c, .continue2
	
	push hl
	ld hl, GenericTextScriptJumpTable2
	call GetAddressFromPointerArray
	ld d, h
	ld e, l
	pop hl
	ld bc, AfterDisplayingTextID
	push bc ; return to AfterDisplayingTextID after jumping to de
	push de
	ret ; ret to de (generic script)
.continue2
	call PrintText_NoCreatingTextBox
AfterDisplayingTextID::
	ld a, [wDoNotWaitForButtonPressAfterDisplayingText]
	and a
	jr nz, HoldTextDisplayOpen
AfterDisplayingTextID2::
	ld a, [wEnteringCableClub]
	and a
	call z, WaitForTextScrollButtonPress ; wait for a button press after displaying all the text
	; fall through

; loop to hold the dialogue box open as long as the player keeps holding down the A button
HoldTextDisplayOpen::
	call Joypad
	ldh a, [hJoyHeld]
	bit B_PAD_A, a
	jr nz, HoldTextDisplayOpen

; FIXME: this unintentionally gets run after HoldTextDisplayOpen...but that may be a good thing since resetting sprite facings seems pointless.
CloseTextDisplayNoSpriteUpdate:: ; PureRGBnote: ADDED: less laggy version of closing the text display that doesn't reset sprite facings
	call CloseTextDisplayPart1
	jr CloseTextDisplayPart2

CloseTextDisplay::
	call CloseTextDisplayPart1
	call CloseTextDisplaySpriteUpdateLoop
	jr CloseTextDisplayPart2

DisplaySafariGameOverText:: ; TODO: combine with other safari one?
	callfar PrintSafariGameOverText
	jr AfterDisplayingTextID2

DisplayPokemonFaintedText::
	ld hl, PokemonFaintedText
	rst _PrintText
	jr AfterDisplayingTextID2

DisplayPlayerBlackedOutText::
	ld hl, PlayerBlackedOutText
	rst _PrintText
	ld hl, wStatusFlags6
	res BIT_ALWAYS_ON_BIKE, [hl] ; reset forced to use bike bit
	jr HoldTextDisplayOpen

DisplayRepelWoreOffText::
	ld hl, RepelWoreOffText
	rst _PrintText
	callfar UseAnotherRepel ; PureRGBnote: ADDED: when repel wears off ask to use another if available
	jr CloseTextDisplay  

CloseTextDisplayPart1:
	ld a, [wCurMap]
	call SwitchToMapRomBank
	ld a, $90
	ldh [hWY], a ; move the window off the screen
	rst _DelayFrame
	call LoadGBPal
	xor a
	ldh [hAutoBGTransferEnabled], a ; disable continuous WRAM to VRAM transfer each V-blank
	ret

CloseTextDisplayPart2:
	ld a, BANK(InitMapSprites)
	call SetCurBank
	call InitMapSprites ; reload sprite tile pattern data (since it was partially overwritten by text tile patterns)
	ld hl, wFontLoaded
	res BIT_FONT_LOADED, [hl]
	ld a, [wStatusFlags6]
	bit BIT_FLY_WARP, a
	call z, LoadPlayerSpriteGraphics
	call LoadCurrentMapView
	pop af
	call SetCurBank
	call UpdateSprites
	ld a, [wEnteringCableClub]
	and a
	ret z
	xor a
	ld [wEnteringCableClub], a
	jp EnterMap

CloseTextDisplaySpriteUpdateLoop:
; loop to make sprites face the directions they originally faced before the dialogue
	ld hl, wSprite01StateData2OrigFacingDirection
	ld c, NUM_SPRITESTATEDATA_STRUCTS - 1
	ld de, SPRITESTATEDATA1_LENGTH
.restoreSpriteFacingDirectionLoop
	ld a, [hl] ; x#SPRITESTATEDATA2_ORIGFACINGDIRECTION
	dec h
	ld [hl], a ; [x#SPRITESTATEDATA1_FACINGDIRECTION]
	inc h
	add hl, de
	dec c
	jr nz, .restoreSpriteFacingDirectionLoop
	ret

GenericTextScriptJumpTable:
	dw DisplayPokemonFaintedText ; TEXT_MON_FAINTED
	dw DisplayPlayerBlackedOutText ; TEXT_BLACKED_OUT
	dw DisplayRepelWoreOffText ; TEXT_REPEL_WORE_OFF
	dw DisplaySafariGameOverText ; TEXT_SAFARI_GAME_OVER

GenericTextScriptJumpTable2:
	dw TextScript_Trainer ; TX_SCRIPT_TRAINER
	dw TextScript_CableClubNPC ; TX_SCRIPT_CABLE_CLUB_RECEPTIONIST 
	dw TextScript_PokemonCenterPC ; TX_SCRIPT_POKECENTER_PC
	dw DisplayPokemartDialogue ; TX_SCRIPT_MART 
	dw DisplayPokemonCenterDialogue ; TX_SCRIPT_POKECENTER_NURSE    

DisplayPokemartDialogue::
	push hl
	ld hl, PokemartGreetingText
	rst _PrintText
	pop hl
	; fall through
DisplayPokemartNoGreeting:: ; PureRGBnote: ADDED: show pokemart without the "welcome!" dialogue first, allows vendors to say something else beforehand.
	inc hl
	call LoadItemList
	ld a, PRICEDITEMLISTMENU
	ld [wListMenuID], a
	homecall DisplayPokemartDialogue_
	ret

LoadItemList::
	call EnableSpriteUpdates
	ld a, h
	ld [wItemListPointer], a
	ld a, l
	ld [wItemListPointer + 1], a
	ld de, wItemList
.loop
	ld a, [hli]
	ld [de], a
	inc de
	cp $ff
	jr nz, .loop
	ret

DisplayPokemonCenterDialogue::
	jpfar DisplayPokemonCenterDialogue_
	
DisplayTextPromptButton::
	ld hl, TextScriptPromptButton
	jp TextCommandProcessor

; Clears the box dialog prints in
ClearTextBox::
	hlcoord 1, 13
	lb bc, 4, 18
	jp ClearScreenArea

TextScriptEndNoButtonPress::
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	rst TextScriptEnd

DisableTextDelay::
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	ret

EnableTextDelay::
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	ret
