Route5Gate_Script:
	call EnableAutoTextBoxDrawing
	ld a, [wRoute5GateCurScript]
	ld hl, Route5Gate_ScriptPointers
	jp CallFunctionInTable

Route5Gate_ScriptPointers:
	def_script_pointers
	dw_const Route5GateDefaultScript,      SCRIPT_ROUTE5GATE_DEFAULT
	dw_const Route5GatePlayerMovingScript, SCRIPT_ROUTE5GATE_PLAYER_MOVING

Route5GateDefaultScript:
	ld hl, .PlayerInCoordsArray
	lb de, PLAYER_DIR_LEFT, PAD_UP
	jr SaffronGatesDefaultScript

.PlayerInCoordsArray:
	dbmapcoord  3,  3
	dbmapcoord  4,  3
	db -1 ; end

SaffronGatesDefaultScript:
	ld a, [wStatusFlags1]
	bit BIT_GAVE_SAFFRON_GUARDS_DRINK, a
	ret nz
	call ArePlayerCoordsInArray
	ret nc
	ld a, d
	ld [wPlayerMovingDirection], a
	xor a
	ldh [hJoyHeld], a
	push de
	farcall RemoveGuardDrink
	pop de
	ldh a, [hItemToRemoveID]
	and a
	jr nz, .have_drink
	ld a, TEXT_ROUTE5GATE_GUARD_GEE_IM_THIRSTY
	ASSERT TEXT_ROUTE5GATE_GUARD_GEE_IM_THIRSTY == TEXT_ROUTE6GATE_GUARD_GEE_IM_THIRSTY
	ASSERT TEXT_ROUTE5GATE_GUARD_GEE_IM_THIRSTY == TEXT_ROUTE7GATE_GUARD_GEE_IM_THIRSTY
	ASSERT TEXT_ROUTE5GATE_GUARD_GEE_IM_THIRSTY == TEXT_ROUTE8GATE_GUARD_GEE_IM_THIRSTY
	ldh [hTextID], a
	push de
	call DisplayTextID
	pop de
	ld a, SCRIPT_ROUTE5GATE_PLAYER_MOVING
	ASSERT SCRIPT_ROUTE5GATE_PLAYER_MOVING == SCRIPT_ROUTE6GATE_PLAYER_MOVING
	ASSERT SCRIPT_ROUTE5GATE_PLAYER_MOVING == SCRIPT_ROUTE7GATE_PLAYER_MOVING
	ASSERT SCRIPT_ROUTE5GATE_PLAYER_MOVING == SCRIPT_ROUTE8GATE_PLAYER_MOVING
	ld [wRoute5GateCurScript], a
	ld a, e
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	jp StartSimulatingJoypadStates
.have_drink
	ld a, TEXT_ROUTE5GATE_GUARD_GIVE_DRINK
	ASSERT TEXT_ROUTE5GATE_GUARD_GIVE_DRINK == TEXT_ROUTE6GATE_GUARD_GIVE_DRINK
	ASSERT TEXT_ROUTE5GATE_GUARD_GIVE_DRINK == TEXT_ROUTE7GATE_GUARD_GIVE_DRINK
	ASSERT TEXT_ROUTE5GATE_GUARD_GIVE_DRINK == TEXT_ROUTE8GATE_GUARD_GIVE_DRINK
	ldh [hTextID], a
	call DisplayTextID
	ld hl, wStatusFlags1
	set BIT_GAVE_SAFFRON_GUARDS_DRINK, [hl]
	ret

Route5GatePlayerMovingScript:
	ld hl, wRoute5GateCurScript
SaffronGatesPlayerMovingScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	call EnableAllJoypad
	ld [hl], a
	ret

Route5Gate_TextPointers:
	def_text_pointers
	dw_const SaffronGateGuardText,             TEXT_ROUTE5GATE_GUARD
	dw_const SaffronGateGuardGeeImThirstyText, TEXT_ROUTE5GATE_GUARD_GEE_IM_THIRSTY
	dw_const SaffronGateGuardGiveDrinkText,    TEXT_ROUTE5GATE_GUARD_GIVE_DRINK

SaffronGateGuardGeeImThirstyText:
	text_far _SaffronGateGuardGeeImThirstyText
	text_end

SaffronGateGuardGiveDrinkText:
	text_far _SaffronGateGuardImParchedText
	sound_get_key_item
	text_far _SaffronGateGuardYouCanGoOnThroughText
	text_end

SaffronGateGuardText:
SaffronGateGuardThanksForTheDrinkText:
	text_far _SaffronGateGuardThanksForTheDrinkText
	text_end
