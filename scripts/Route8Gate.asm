Route8Gate_Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route8Gate_ScriptPointers
	ld a, [wRoute8GateCurScript]
	jp CallFunctionInTable

Route8Gate_ScriptPointers:
	def_script_pointers
	dw_const Route8GateDefaultScript,      SCRIPT_ROUTE8GATE_DEFAULT
	dw_const Route8GatePlayerMovingScript, SCRIPT_ROUTE8GATE_PLAYER_MOVING

Route8GateDefaultScript:
	ld hl, .PlayerInCoordsArray
	lb de, PLAYER_DIR_LEFT, PAD_RIGHT
	jp SaffronGatesDefaultScript

.PlayerInCoordsArray:
	dbmapcoord  2,  3
	dbmapcoord  2,  4
	db -1 ; end

Route8GatePlayerMovingScript:
	ld hl, wRoute8GateCurScript
	jp SaffronGatesPlayerMovingScript

Route8Gate_TextPointers:
	def_text_pointers
	dw_const SaffronGateGuardText,             TEXT_ROUTE8GATE_GUARD
	dw_const SaffronGateGuardGeeImThirstyText, TEXT_ROUTE8GATE_GUARD_GEE_IM_THIRSTY
	dw_const SaffronGateGuardGiveDrinkText,    TEXT_ROUTE8GATE_GUARD_GIVE_DRINK
