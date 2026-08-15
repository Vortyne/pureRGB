PalletTown_Script:
	CheckEvent EVENT_GOT_POKEBALLS_FROM_OAK
	jr z, .next
	SetEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS
.next
	ld hl, PalletTown_ScriptPointers
	ld de, wPalletTownCurScript
	jp CallMapScriptInTable

PalletTown_ScriptPointers:
	def_script_pointers
	dw_const PalletTownDefaultScript,              SCRIPT_PALLETTOWN_DEFAULT
	dw_const PalletTownOakHeyWaitScript,           SCRIPT_PALLETTOWN_OAK_HEY_WAIT
	dw_const PalletTownOakWalksToPlayerScript,     SCRIPT_PALLETTOWN_OAK_WALKS_TO_PLAYER
	dw_const PalletTownOakNotSafeComeWithMeScript, SCRIPT_PALLETTOWN_OAK_NOT_SAFE_COME_WITH_ME
	dw_const PalletTownPlayerFollowsOakScript,     SCRIPT_PALLETTOWN_PLAYER_FOLLOWS_OAK
	dw_const PalletTownDaisyScript,                SCRIPT_PALLETTOWN_DAISY
	dw_const DoRet,                                SCRIPT_PALLETTOWN_NOOP

PalletTownDefaultScript:
	CheckEvent EVENT_FOLLOWED_OAK_INTO_LAB
	ret nz
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
ENDC
	ld a, [wYCoord]
	cp 1 ; is player near north exit?
	ret nz
	xor a
	ldh [hJoyHeld], a
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, SFX_STOP_ALL_MUSIC
	rst _PlaySound
	ld a, BANK(Music_MeetProfOak)
	ld c, a
	ld a, MUSIC_MEET_PROF_OAK ; "oak appears" music
	call PlayMusic
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_OAK_APPEARED_IN_PALLET

	; trigger the next script
	ld a, SCRIPT_PALLETTOWN_OAK_HEY_WAIT
	ld [wPalletTownCurScript], a
	ret

PalletTownOakHeyWaitScript:
	xor a
	ld [wOakWalkedToPlayer], a
	ld a, TEXT_PALLETTOWN_OAK
	ldh [hTextID], a
	call DisplayTextID
	call DisableAllJoypad
	ld c, TOGGLE_PALLET_TOWN_OAK
	call ShowObject

	; trigger the next script
	ld a, SCRIPT_PALLETTOWN_OAK_WALKS_TO_PLAYER
	ld [wPalletTownCurScript], a
	ret

PalletTownOakWalksToPlayerScript:
	ld a, PALLETTOWN_OAK
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call Delay3
	ld a, 1
	ld [wYCoord], a
	ld a, 1
	ldh [hNPCPlayerRelativePosPerspective], a
	ld a, 1
	swap a
	ldh [hNPCSpriteOffset], a
	callfar CalcPositionOfPlayerRelativeToNPC
	ld hl, hNPCPlayerYDistance
	dec [hl]
	callfar FindPathToPlayer ; load Oak's movement into wNPCMovementDirections2
	ld de, wNPCMovementDirections2
	ld a, PALLETTOWN_OAK
	ldh [hSpriteIndex], a
	call MoveSprite
	call DisableAllJoypad

	; trigger the next script
	ld a, SCRIPT_PALLETTOWN_OAK_NOT_SAFE_COME_WITH_ME
	ld [wPalletTownCurScript], a
	ret

PalletTownOakNotSafeComeWithMeScript:
	call IsNPCAutoMoving
	ret nz
	xor a ; SPRITE_FACING_DOWN
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, TRUE
	ld [wOakWalkedToPlayer], a
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TEXT_PALLETTOWN_OAK
	ldh [hTextID], a
	call DisplayTextID
; set up movement script that causes the player to follow Oak to his lab
	call DisableAllJoypad
	ld a, PALLETTOWN_OAK
	ld [wSpriteIndex], a
	xor a
	ld [wNPCMovementScriptFunctionNum], a
	ld a, 1
	ld [wNPCMovementScriptPointerTableNum], a
	ldh a, [hLoadedROMBank]
	ld [wNPCMovementScriptBank], a

	; trigger the next script
	ld a, SCRIPT_PALLETTOWN_PLAYER_FOLLOWS_OAK
	ld [wPalletTownCurScript], a
	ret

PalletTownPlayerFollowsOakScript:
	ld a, [wNPCMovementScriptPointerTableNum]
	and a ; is the movement script over?
	ret nz

	; trigger the next script
	ld a, SCRIPT_PALLETTOWN_DAISY
	ld [wPalletTownCurScript], a
	ret

PalletTownDaisyScript:
	CheckEvent EVENT_DAISY_WALKING
	ret nz
	CheckBothEventsSet EVENT_GOT_TOWN_MAP, EVENT_ENTERED_BLUES_HOUSE, 1
	ret nz
	SetEvent EVENT_DAISY_WALKING
	ld c, TOGGLE_DAISY_SITTING
	call HideObject
	ld c, TOGGLE_DAISY_WALKING
	jp ShowObject

PalletTown_TextPointers:
	def_text_pointers
	dba_const PalletTownOakText,              TEXT_PALLETTOWN_OAK
	dba_const _PalletTownGirlText,             TEXT_PALLETTOWN_GIRL
	dba_const _PalletTownFisherText,           TEXT_PALLETTOWN_FISHER
	dba_const _PalletTownOaksLabSignText,      TEXT_PALLETTOWN_OAKSLAB_SIGN
	dba_const _PalletTownSignText,             TEXT_PALLETTOWN_SIGN
	dba_const PalletTownPlayersHouseSignText, TEXT_PALLETTOWN_PLAYERSHOUSE_SIGN
	dba_const _PalletTownRivalsHouseSignText,  TEXT_PALLETTOWN_RIVALSHOUSE_SIGN

PalletTownOakText:
	text_asm
	ld a, [wOakWalkedToPlayer]
	and a
	ld hl, .ItsUnsafeText
	jr nz, .done
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .HeyWaitDontGoOutText
.done
	rst _PrintText
	rst TextScriptEnd

.HeyWaitDontGoOutText:
	text_far _PalletTownOakHeyWaitDontGoOutText
	text_asm
	ld c, 10
	rst DelayFrames
	xor a
	ld [wEmotionBubbleSpriteIndex], a ; player's sprite
	ld [wWhichEmotionBubble], a ; EXCLAMATION_BUBBLE
	callfar EmotionBubble
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	rst TextScriptEnd

.ItsUnsafeText:
	text_far_end _PalletTownOakItsUnsafeText

PalletTownPlayersHouseSignText:
IF DEF(_DEBUG)
	text_asm
	callfar GBCSetCPU1xSpeed
	callfar HallOfFamePC
	jp SoftReset
ELSE
	text_far_end _PalletTownPlayersHouseSignText
ENDC
