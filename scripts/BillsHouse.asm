; PureRGBnote: ADDED: code was added to make doors appear at the back of Bills House once you become champ.
; Bill will also talk about his new beach garden.

BillsHouse_Script:
	call BillsHouseAddDoors
	call EnableAutoTextBoxDrawing
	ld a, [wBillsHouseCurScript]
	ld hl, BillsHouse_ScriptPointers
	jp CallFunctionInTable

BillsHouseAddDoors:
	call WasMapJustLoaded
	ret z
	ResetEvent EVENT_IN_BILLS_GARDEN
	CheckEvent EVENT_BECAME_CHAMP
	ret z
	ld de, BillsHouseTileBlockReplacements
	callfar ReplaceMultipleTileBlocks
	; if the player's standing on y-coordinate 0 on loading the map, it means they entered from the top. 
	; They need to be forced to walk out from the doorway. It doesn't work the normal way because of the tile blocks still needing to be replaced.
	ld a, [wYCoord] 
	and a
	ret nz
	jpfar ForceStepOutFromDoor

BillsHouse_ScriptPointers:
	def_script_pointers
	dw_const DoRet,                                SCRIPT_BILLSHOUSE_DEFAULT
	dw_const BillsHousePokemonWalkToMachineScript, SCRIPT_BILLSHOUSE_POKEMON_WALK_TO_MACHINE
	dw_const BillsHousePokemonEntersMachineScript, SCRIPT_BILLSHOUSE_POKEMON_ENTERS_MACHINE
	dw_const BillsHouseBillExitsMachineScript,     SCRIPT_BILLSHOUSE_BILL_EXITS_MACHINE
	dw_const BillsHouseCleanupScript,              SCRIPT_BILLSHOUSE_CLEANUP

BillsHousePokemonWalkToMachineScript:
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; cp SPRITE_FACING_DOWN
	ld de, .PokemonWalkToMachineMovement
	jr nz, .notDown
	ld de, .PokemonWalkAroundPlayerMovement
.notDown
	ld a, BILLSHOUSE_BILL_POKEMON
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, SCRIPT_BILLSHOUSE_POKEMON_ENTERS_MACHINE
	ld [wBillsHouseCurScript], a
	ret

.PokemonWalkToMachineMovement:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db -1 ; end

; make Bill walk around the player
.PokemonWalkAroundPlayerMovement:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db -1 ; end

BillsHousePokemonEntersMachineScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, TOGGLE_BILL_POKEMON
	ld [wToggleableObjectIndex], a
	predef HideObject
	SetEvent EVENT_BILL_SAID_USE_CELL_SEPARATOR
	ld a, SFX_TRADE_MACHINE
	rst _PlaySound
	call EnableAllJoypad
	ld a, SCRIPT_BILLSHOUSE_BILL_EXITS_MACHINE
	ld [wBillsHouseCurScript], a
	ret

BillsHouseBillExitsMachineScript:
	CheckEvent EVENT_USED_CELL_SEPARATOR_ON_BILL
	ret z
	call DisableDpad
	ld a, BILLSHOUSE_BILL_SS_TICKET
	ld [wSpriteIndex], a
	ld a, $c
	ldh [hSpriteScreenYCoord], a
	ld a, $40
	ldh [hSpriteScreenXCoord], a
	ld a, 6
	ldh [hSpriteMapYCoord], a
	ld a, 5
	ldh [hSpriteMapXCoord], a
	call SetSpritePosition1
	ld a, TOGGLE_BILL_1
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld c, 8
	rst _DelayFrames
	ld a, BILLSHOUSE_BILL_SS_TICKET
	ldh [hSpriteIndex], a
	ld de, .BillExitMachineMovement
	call MoveSprite
	ld a, SCRIPT_BILLSHOUSE_CLEANUP
	ld [wBillsHouseCurScript], a
	ret

.BillExitMachineMovement:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db -1 ; end

BillsHouseCleanupScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	call EnableAllJoypad
	SetEvent EVENT_MET_BILL_2 ; this event seems redundant
	SetEvent EVENT_MET_BILL
	ld a, SCRIPT_BILLSHOUSE_DEFAULT
	ld [wBillsHouseCurScript], a
	ret

BillsHousePCScript:
	ld a, TEXT_BILLSHOUSE_ACTIVATE_PC
	ldh [hTextID], a
	call DisplayTextID
	ld a, SCRIPT_BILLSHOUSE_DEFAULT
	ld [wBillsHouseCurScript], a
	ret

BillsHouse_TextPointers:
	def_text_pointers
	dw_const BillsHouseBillPokemonText,               TEXT_BILLSHOUSE_BILL_POKEMON
	dw_const BillsHouseBillSSTicketText,              TEXT_BILLSHOUSE_BILL_SS_TICKET
	dw_const BillsHouseBillCheckOutMyRarePokemonText, TEXT_BILLSHOUSE_BILL_CHECK_OUT_MY_RARE_POKEMON
	dw_const BillsHouseActivatePCScript,              TEXT_BILLSHOUSE_ACTIVATE_PC

BillsHouseBillPokemonText:
	text_asm
	ld hl, .ImNotAPokemonText
	rst _PrintText
	call YesNoChoice
	jr z, .use_machine
	ld hl, .NoYouGottaHelpText
	rst _PrintText
.use_machine
	ld a, SCRIPT_BILLSHOUSE_POKEMON_WALK_TO_MACHINE
	ld [wBillsHouseCurScript], a
	ld hl, .UseSeparationSystemText
	rst _PrintText
	rst TextScriptEnd

.ImNotAPokemonText:
	text_far _BillsHouseBillImNotAPokemonText
	text_end

.UseSeparationSystemText:
	text_far _BillsHouseBillUseSeparationSystemText
	text_end

.NoYouGottaHelpText:
	text_far _BillsHouseBillNoYouGottaHelpText
	text_end

BillsHouseBillSSTicketText:
	text_asm
	CheckEvent EVENT_GOT_SS_TICKET
	jr nz, .got_ss_ticket
	ld hl, .ThankYouText
	rst _PrintText
	lb bc, S_S_TICKET, 1
	call GiveItem
	ld hl, .SSTicketNoRoomText
	jr nc, .printDone
	ld hl, .SSTicketReceivedText
	rst _PrintText
	SetEvent EVENT_GOT_SS_TICKET
	ld a, TOGGLE_CERULEAN_GUARD_1
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld a, TOGGLE_CERULEAN_GUARD_2
	ld [wToggleableObjectIndex], a
	predef HideObject
;;;;;;;;;; PureRGBnote: MOVED: move this object hiding here since we could teleport out of bills house and miss this being triggered on route 25 instead
	ld a, TOGGLE_NUGGET_BRIDGE_GUY
	ld [wToggleableObjectIndex], a
	predef HideObject
;;;;;;;;;;
.got_ss_ticket
	ld hl, .WhyDontYouGoInsteadOfMeText
.printDone
	rst _PrintText
	rst TextScriptEnd

.ThankYouText:
	text_far _BillsHouseBillThankYouText
	text_end

.SSTicketReceivedText:
	text_far _SSTicketReceivedText
	sound_get_key_item
	text_promptbutton
	text_end

.SSTicketNoRoomText:
	text_far _SSTicketNoRoomText
	text_end

.WhyDontYouGoInsteadOfMeText:
	text_far _BillsHouseBillWhyDontYouGoInsteadOfMeText
	text_end

BillsHouseBillCheckOutMyRarePokemonText:
	text_asm
	CheckEvent EVENT_BECAME_CHAMP
	ld hl, .Text
	jr z, .done
	ld hl, BillsHouseGardenInfo
.done
	rst _PrintText
	rst TextScriptEnd

.Text:
	text_far _BillsHouseBillCheckOutMyRarePokemonText
	text_end

BillsHouseGardenInfo:
	text_far _BillsHouseGardenInfo
	text_end

BillsHousePC::
	call EnableAutoTextBoxDrawing
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	ld a, TEXT_BILLSHOUSE_ACTIVATE_PC
	ldh [hTextID], a
	jp DisplayTextID

BillsHouseActivatePCScript:
	text_asm
	CheckEvent EVENT_LEFT_BILLS_HOUSE_AFTER_HELPING
	jr nz, .displayBillsHousePokemonList
	CheckEventReuseA EVENT_USED_CELL_SEPARATOR_ON_BILL
	jr nz, .displayBillsHousePokemonList
	CheckEventReuseA EVENT_BILL_SAID_USE_CELL_SEPARATOR
	jr nz, .doCellSeparator
.displayBillsHouseMonitorText
	ld hl, .cellOnMonitor
	jr .printDone
.doCellSeparator
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .cellSeparationInitiated
	rst _PrintText
	ld c, 32
	ld a, SFX_TINK
	call .playSoundWithDelay
	ld c, 80
	ld a, SFX_SHRINK
	call .playSoundWithDelay
	ld c, 48
	ld a, SFX_TINK
	call .playSoundWithDelay
	ld c, 32
	ld a, SFX_GET_ITEM_1
	call .playSoundWithDelay
	call PlayDefaultMusic
	SetEvent EVENT_USED_CELL_SEPARATOR_ON_BILL
	rst TextScriptEnd
.displayBillsHousePokemonList
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .pokemonList
.printDone
	rst _PrintText
	rst TextScriptEnd
.playSoundWithDelay
	push af
	rst _DelayFrames
	pop af
	rst _PlaySound
	jp WaitForSoundToFinish
.cellOnMonitor
	text_far _BillsHouseMonitorText
	text_end
.cellSeparationInitiated
	text_far _BillsHouseInitiatedText
	text_promptbutton
	text_asm
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	rst _PlaySound
	ld c, 16
	ld a, SFX_SWITCH
	call .playSoundWithDelay
	ld c, 60
	rst _DelayFrames
	rst TextScriptEnd

.pokemonList
	text_asm
	call SaveScreenTilesToBuffer1
	ld hl, .favoritePokemon
	rst _PrintText
	xor a
	ld [wMenuItemOffset], a ; not used
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, 4
	ld [wMaxMenuItem], a
	ld a, 2
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
.billsPokemonLoop
;;;;;;;;;; PureRGBnote: MOVED: moved here because opening a pokedex entry changes wMenuWatchedKeys now and this needs to be repeated every menu loop.
	ld a, PAD_A | PAD_B
	ld [wMenuWatchedKeys], a
;;;;;;;;;;
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	hlcoord 0, 0
	lb bc, 10, 9
	call TextBoxBorder
	hlcoord 2, 2
	ld de, BillsMonListText
	call PlaceString
	ld hl, .whichPokemonInfo
	rst _PrintText
	call SaveScreenTilesToBuffer2
	call HandleMenuInput
	bit B_PAD_B, a
	jr nz, .cancel
	ld a, [wCurrentMenuItem]
	add EEVEE
	cp VAPOREON + 1
	jr z, .cancel
.displayPokedex
	call DisplayPokedex
	; dex number still stored in wPokedexNum
	callfar IsPokemonLearnsetUnlockedDirect
	jr nz, .noFurtherText
	call AreLearnsetsEnabled
	jr z, .noFurtherText
	callfar SetPokemonLearnsetUnlocked
	ld hl, .listingTonsOfInfo
	rst _PrintText
	; wNameBuffer still contains pokemon name
	callfar LearnsetUnlockedScript
	call DisplayTextPromptButton
.noFurtherText
	call LoadScreenTilesFromBuffer2
	jr .billsPokemonLoop
.cancel
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call LoadScreenTilesFromBuffer2
	rst TextScriptEnd
.favoritePokemon:
	text_far _BillsHousePokemonListText1
	text_end

.whichPokemonInfo:
	text_far _BillsHousePokemonListText2
	text_end

.listingTonsOfInfo::
	text_far _BillsHousePCInfo
	text_end

BillsMonListText:
	db   "EEVEE"
	next "FLAREON"
	next "JOLTEON"
	next "VAPOREON"
	next "CANCEL@"
