Route7Gate_Script:
	call EnableAutoTextBoxDrawing
	ld a, [wRoute7GateCurScript]
	ld hl, Route7Gate_ScriptPointers
	jp CallFunctionInTable

Route7Gate_ScriptPointers:
	def_script_pointers
	dw_const Route7DefaultScript,      SCRIPT_ROUTE7GATE_DEFAULT
	dw_const Route7PlayerMovingScript, SCRIPT_ROUTE7GATE_PLAYER_MOVING

Route7DefaultScript:
	ld hl, .PlayerInCoordsArray
	lb de, PLAYER_DIR_UP, PAD_LEFT
	jp SaffronGatesDefaultScript

.PlayerInCoordsArray:
	dbmapcoord  3,  3
	dbmapcoord  3,  4
	db -1 ; end

Route7PlayerMovingScript:
	ld hl, wRoute7GateCurScript
	jp SaffronGatesPlayerMovingScript

Route7Gate_TextPointers:
	def_text_pointers
	dw_const SaffronGateGuardText,             TEXT_ROUTE7GATE_GUARD
	dw_const SaffronGateGuardGeeImThirstyText, TEXT_ROUTE7GATE_GUARD_GEE_IM_THIRSTY
	dw_const SaffronGateGuardGiveDrinkText,    TEXT_ROUTE7GATE_GUARD_GIVE_DRINK
