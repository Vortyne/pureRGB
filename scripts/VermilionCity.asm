VermilionCity_Script:
	call EnableAutoTextBoxDrawing
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_2, [hl]
	res BIT_CUR_MAP_LOADED_2, [hl]
	call nz, VermilionCityLeftSSAnneCallbackScript
	call WasMapJustLoaded
	call nz, .setFirstLockTrashCanIndexAndCheckTileReplacements
	bit BIT_CROSSED_MAP_CONNECTION, [hl]
	res BIT_CROSSED_MAP_CONNECTION, [hl]
	call nz, .checkTileReplacementsNoRedraw
;;;;; PureRGBnote: CHANGED: force a scripted warp to vermilion dock when in the correct coords
;;;;; unlike the original game this prevents the need for specific warp tiles to be used on the dock path
;;;;; the downside is that we need to expand the map size by 1 block vertically south to account for being able to move down another coordinate
	ld a, [wYCoord]
	cp 34
	jr nz, .no_dock_warp
	ld a, [wXCoord]
	cp 18
	jr z, .warp
	cp 19
	jr nz, .no_dock_warp
.warp
	ld a, VERMILION_DOCK
	ldh [hWarpDestinationMap], a
	xor a
	ld [wDestinationWarpID], a
	ld hl, wStatusFlags3
	set BIT_WARP_FROM_CUR_SCRIPT, [hl]
	; setting BIT_STANDING_ON_WARP will make immediately going back up in vermilion dock after the above warp trigger warp again properly
	ld hl, wMovementFlags
	set BIT_STANDING_ON_WARP, [hl]
.no_dock_warp
;;;;;
	ld hl, VermilionCity_ScriptPointers
	ld de, wVermilionCityCurScript
	jp CallMapScriptInTable
; PureRGBnote: ADDED: code that keeps the cut tree cut down if we're in its alcove. Prevents getting softlocked if you delete cut.
.setFirstLockTrashCanIndexAndCheckTileReplacements
	call Random
	ldh a, [hRandomSub]
	and $e
	ld [wFirstLockTrashCanIndex], a
	jr .checkTileReplacements
.checkTileReplacementsNoRedraw
	SetFlag FLAG_SKIP_MAP_REDRAW
.checkTileReplacements
	ld hl, wTileBlockReplaceCount
	ld [hl], 0
	ld de, VermilionCutAlcove
	callfar FarArePlayerCoordsInRange
	; if we're in the specific area where we can get trapped without CUT, remove the tree on map load.
	ld de, wTileBlockReplaceData
	jr nc, .skipTreeRemoval
	ld hl, VermilionCutTreeBlockReplacement 
	call .copyDataAndTerminate
.skipTreeRemoval
	CheckEvent FLAG_CATCHUP_CLUBS_TURNED_OFF
	jr z, .skipDoorReplace
	ld hl, VermilionFitnessClubDoorBlockReplacement
	call .copyDataAndTerminate
.skipDoorReplace
	ld a, [wTileBlockReplaceCount]
	and a
	jr z, .done
	ld de, wTileBlockReplaceData
	callfar ReplaceMultipleTileBlocks
.done
	ResetFlag FLAG_SKIP_MAP_REDRAW
	ret
.copyDataAndTerminate
	push hl
	ld hl, wTileBlockReplaceCount
	inc [hl]
	pop hl
	ld bc, 3
	rst _CopyData
	ld a, -1
	ld [de], a
	ret


VermilionCutTreeBlockReplacement:
	db 10, 7, $4C

VermilionFitnessClubDoorBlockReplacement:
	db 2, 10, $37

VermilionCityLeftSSAnneCallbackScript:
	CheckEventHL EVENT_SS_ANNE_LEFT
	ret z
	CheckEventReuseHL EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT
	SetEventReuseHL EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT
	ret nz
	ld a, SCRIPT_VERMILIONCITY_PLAYER_EXIT_SHIP
	ld [wVermilionCityCurScript], a
	ret

VermilionCity_ScriptPointers:
	def_script_pointers
	dw_const VermilionCityDefaultScript,             SCRIPT_VERMILIONCITY_DEFAULT
	dw_const VermilionCityPlayerMovingUp1Script,     SCRIPT_VERMILIONCITY_PLAYER_MOVING_UP1
	dw_const VermilionCityPlayerExitShipScript,      SCRIPT_VERMILIONCITY_PLAYER_EXIT_SHIP
	dw_const VermilionCityPlayerMovingUp2Script,     SCRIPT_VERMILIONCITY_PLAYER_MOVING_UP2
	dw_const VermilionCityPlayerAllowedToPassScript, SCRIPT_VERMILIONCITY_PLAYER_ALLOWED_TO_PASS

VermilionCityDefaultScript:
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; cp SPRITE_FACING_DOWN
	ret nz
	ld hl, SSAnneTicketCheckCoords
	call ArePlayerCoordsInArray
	ret nc
	xor a
	ldh [hJoyHeld], a
	ld [wSavedCoordIndex], a ; unnecessary
	ld a, TEXT_VERMILIONCITY_SAILOR1
	ldh [hTextID], a
	call DisplayTextID
	ld a, [wObtainedBadges] ; PureRGBnote: CHANGED: ship returns after obtaining the soul badge so let the player in if they have the ticket
	bit BIT_SOULBADGE, a
	jr nz, .default
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .ship_departed
.default
	CheckEvent EVENT_GOT_HM01
	ret nz ; after getting CUT don't need SS ticket to enter
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	ret nz
.ship_departed
	ld a, PAD_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, SCRIPT_VERMILIONCITY_PLAYER_MOVING_UP1
	ld [wVermilionCityCurScript], a
	ret

SSAnneTicketCheckCoords:
	dbmapcoord 18, 32
	db -1 ; end

VermilionCityPlayerAllowedToPassScript:
	ld hl, SSAnneTicketCheckCoords
	call ArePlayerCoordsInArray
	ret c
ResetVermilionMapScript:
	xor a
	ld [wVermilionCityCurScript], a ; SCRIPT_VERMILIONCITY_DEFAULT
	ret

VermilionCityPlayerMovingUp2Script:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call EnableAllJoypad
	; a = 0 from EnableAllJoypad
	ldh [hJoyHeld], a
	jr ResetVermilionMapScript

VermilionCityPlayerMovingUp1Script:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld c, 10
	rst DelayFrames
	jr ResetVermilionMapScript

VermilionCityPlayerExitShipScript:
	ld a, PAD_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesEnd + 1], a
	ld a, 2
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStatesNoJoypad
	ld a, SCRIPT_VERMILIONCITY_PLAYER_MOVING_UP2
	ld [wVermilionCityCurScript], a
	ret

VermilionCity_TextPointers:
	def_text_pointers
	dba_const _VermilionCityBeautyText,             TEXT_VERMILIONCITY_BEAUTY
	dba_const VermilionCityGambler1Text,           TEXT_VERMILIONCITY_GAMBLER1
	dba_const VermilionCitySailor1Text,            TEXT_VERMILIONCITY_SAILOR1
	dba_const _VermilionCityGambler2Text,           TEXT_VERMILIONCITY_GAMBLER2
	dba_const VermilionCityMachopText,             TEXT_VERMILIONCITY_MACHOP
	dba_const VermilionCitySailor2Text,            TEXT_VERMILIONCITY_SAILOR2
	dba_const VermilionCityDockBeautyText,         TEXT_VERMILIONCITY_DOCK_BEAUTY
	dba_const _VermilionCitySignText,               TEXT_VERMILIONCITY_SIGN
	dba_const _VermilionCityNoticeSignText,         TEXT_VERMILIONCITY_NOTICE_SIGN
	dba_const MartSignText,                        TEXT_VERMILIONCITY_MART_SIGN
	dba_const PokeCenterSignText,                  TEXT_VERMILIONCITY_POKECENTER_SIGN
	dba_const _VermilionCityPokemonFanClubSignText, TEXT_VERMILIONCITY_POKEMON_FAN_CLUB_SIGN
	dba_const VermilionCityGymSignText,            TEXT_VERMILIONCITY_GYM_SIGN
	dba_const _VermilionCityHarborSignText,         TEXT_VERMILIONCITY_HARBOR_SIGN

VermilionCityGambler1Text:
	text_asm
	CheckEvent EVENT_SS_ANNE_LEFT
	ld hl, .SSAnneDepartedText
	jr nz, .printDone
	ld hl, .DidYouSeeText
.printDone
	rst _PrintText
	rst TextScriptEnd

.DidYouSeeText:
	text_far_end _VermilionCityGambler1DidYouSeeText

.SSAnneDepartedText:
	text_far_end _VermilionCityGambler1SSAnneDepartedText

VermilionCitySailor1Text:
	text_asm
	ld a, [wObtainedBadges]
	bit BIT_SOULBADGE, a ; PureRGBnote: CHANGED: after obtaining soul badge the ship returns so this NPC will talk about it
	jr nz, .default
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .ship_departed
.default
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_RIGHT
	jr z, .greet_player
	ld hl, .inFrontOfOrBehindGuardCoords
	call ArePlayerCoordsInArray
	jr c, .greet_player
.greet_player_and_check_ticket
	CheckEvent EVENT_GOT_HM01
	ld hl, .ComeOnThroughText
	jr nz, .player_has_ticket
	ld hl, .DoYouHaveATicketText
	rst _PrintText
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	ld hl, .FlashedTicketText
	jr nz, .player_has_ticket
	ld hl, .YouNeedATicketText
	rst _PrintText
	rst TextScriptEnd
.greet_player
	ld hl, .WelcomeToSSAnneText
	jr .printDone
.player_has_ticket
	rst _PrintText
	ld a, SCRIPT_VERMILIONCITY_PLAYER_ALLOWED_TO_PASS
	ld [wVermilionCityCurScript], a
	rst TextScriptEnd
.ship_departed
	ld hl, .ShipSetSailText
.printDone
	rst _PrintText
	rst TextScriptEnd

.inFrontOfOrBehindGuardCoords
	dbmapcoord 19, 31 ; in front of guard
	dbmapcoord 19, 33 ; behind guard
	db -1 ; end

.WelcomeToSSAnneText:
	text_far_end _VermilionCitySailor1WelcomeToSSAnneText

.DoYouHaveATicketText:
	text_far_end _VermilionCitySailor1DoYouHaveATicketText

.FlashedTicketText:
	text_far_end _VermilionCitySailor1FlashedTicketText

.YouNeedATicketText:
	text_far_end _VermilionCitySailor1YouNeedATicketText

.ShipSetSailText:
	text_far_end _VermilionCitySailor1ShipSetSailText

.ComeOnThroughText:
	text_far_end _VermilionCity1OhItsYouText

VermilionCityMachopText:
	text_far _VermilionCityMachopText
	text_asm
	ld c, DEX_MACHOP - 1
	callfar SetMonSeen
	ld a, MACHOP
	call PlayCry
	ld hl, .StompingTheLandFlatText
	ret

.StompingTheLandFlatText:
	text_far_end _VermilionCityMachopStompingTheLandFlatText

VermilionCitySailor2Text:
	text_asm
	ld a, [wObtainedBadges]
	bit BIT_SOULBADGE, a ; after obtaining the soul badge the ship returns
	ld hl, .Text
	ret z
	ld hl, .ShipBackText
	ret

.Text:
	text_far_end _VermilionCitySailor2Text

.ShipBackText:
	text_far_end _VermilionCityText15

VermilionCityGymSignText:
	text_asm
	ld c, VERMILION_GYM
	ld de, VermilionGymOutsideSign
	jpfar GymOutsideSignTextScript

; PureRGBnote: ADDED: new NPC who will give you an item if found. Requires surf to even see this NPC's location.
VermilionCityDockBeautyText: 
	text_asm
	CheckEvent EVENT_GOT_DOCK_BEAUTY_ITEM
	ld hl, VermilionCityDockBeautyEndText
	jr nz, .printDone
	ld hl, VermilionCityDockBeautyGreeting
	rst _PrintText
	lb bc, ITEM_VERMILION_SECRET_DOCK_BEAUTY_NEW, 1
	call GiveItem
	ld hl, VermilionCityDockBeautyNoRoomText
	jr nc, .printDone
	SetEvent EVENT_GOT_DOCK_BEAUTY_ITEM
	ld hl, VermilionCityDockBeautyReceivedItemText
.printDone
	rst _PrintText
.done
	rst TextScriptEnd

VermilionCityDockBeautyGreeting:
	text_far_end _VermilionCityDockBeautyGreeting

VermilionCityDockBeautyNoRoomText:
	text_far_end _PewterGymTM34NoRoomText

VermilionCityDockBeautyReceivedItemText:
	text_far _MrFujisHouseMrFujiReceivedPokeFluteText
	sound_get_key_item
	text_end

VermilionCityDockBeautyEndText:
	text_far_end _VermilionCityDockBeautyEndText