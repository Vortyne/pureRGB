CinnabarIsland_Script:
	ResetEvent EVENT_MANSION_SWITCH_ON
	ResetEvent EVENT_LAB_STILL_REVIVING_FOSSIL
	ld hl, CinnabarIsland_ScriptPointers
	ld de, wCinnabarIslandCurScript
	jp CallMapScriptInTable

CinnabarIsland_ScriptPointers:
	def_script_pointers
	dw_const CinnabarIslandDefaultScript,      SCRIPT_CINNABARISLAND_DEFAULT
	dw_const CinnabarIslandPlayerMovingScript, SCRIPT_CINNABARISLAND_PLAYER_MOVING

CinnabarIslandDefaultScript:
	CheckEvent EVENT_USED_SECRET_KEY
	ret nz
	ld a, [wYCoord]
	cp 4
	ret nz
	ld a, [wXCoord]
	cp 18
	ret nz
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, TEXT_CINNABARISLAND_DOOR_IS_LOCKED
	ldh [hTextID], a
	call DisplayTextID
	CheckEvent EVENT_USED_SECRET_KEY
	ret nz
	xor a
	ldh [hJoyHeld], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates
	call EnableAllJoypad
	; a = 0 from EnableAllJoypad
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, SCRIPT_CINNABARISLAND_PLAYER_MOVING
	ld [wCinnabarIslandCurScript], a
	ret

CinnabarIslandPlayerMovingScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, SCRIPT_CINNABARISLAND_DEFAULT
	ld [wCinnabarIslandCurScript], a
	ret

CinnabarIsland_TextPointers:
	def_text_pointers
	dba_const _CinnabarIslandGirlText,           TEXT_CINNABARISLAND_GIRL
	dba_const _CinnabarIslandGamblerText,        TEXT_CINNABARISLAND_GAMBLER
	dba_const _CinnabarIslandSignText,           TEXT_CINNABARISLAND_SIGN
	dba_const MartSignText,                      TEXT_CINNABARISLAND_MART_SIGN
	dba_const PokeCenterSignText,                TEXT_CINNABARISLAND_POKECENTER_SIGN
	dba_const _CinnabarIslandPokemonLabSignText, TEXT_CINNABARISLAND_POKEMONLAB_SIGN
	dba_const CinnabarIslandGymSignText,         TEXT_CINNABARISLAND_GYM_SIGN
	dba_const CinnabarIslandDoorIsLockedText,    TEXT_CINNABARISLAND_DOOR_IS_LOCKED

CinnabarIslandDoorIsLockedText: ; PureRGBnote: CHANGED: secret key gets consumed on usage and the door is permanently unlocked.
	text_asm
	ld b, SECRET_KEY
	predef GetIndexOfItemInBag
	ld a, b
	cp $FF ; not in bag
	jr z, .noKey
	; FIXED: if we have the SECRET_KEY, remove it from bag and unlock the door forever
	ld [wWhichPokemon], a ; load item index to be removed
	ld hl, wNumBagItems
	ld a, 1 ; one item
	ld [wItemQuantity], a
	call RemoveItemFromInventory
	SetEvent EVENT_USED_SECRET_KEY
    ld a, SFX_WITHDRAW_DEPOSIT
    rst _PlaySound
    call WaitForSoundToFinish
    ld a, SFX_59
    rst _PlaySound
    call WaitForSoundToFinish
	ld hl, UnlockedDoorText
	rst _PrintText
	rst TextScriptEnd
.noKey
	ld hl, NoKeyText
	rst _PrintText
	rst TextScriptEnd

UnlockedDoorText:
	text_far_end _UnlockedCinnabarGymDoorText

NoKeyText:
	text_far_end _CinnabarIslandDoorIsLockedText

CinnabarIslandGymSignText:
	text_asm
	ld c, CINNABAR_GYM
	ld de, CinnabarGymOutsideSign
	jpfar GymOutsideSignTextScript
