Route6Gate_Script:
	ld hl, Route6Gate_ScriptPointers
	ld de, wRoute6GateCurScript
	jp CallMapScriptInTable

Route6Gate_ScriptPointers:
	def_script_pointers
	dw_const Route6GateDefaultScript,      SCRIPT_ROUTE6GATE_DEFAULT
	dw_const Route6GatePlayerMovingScript, SCRIPT_ROUTE6GATE_PLAYER_MOVING

Route6GateDefaultScript:
	ld hl, .PlayerInCoordsArray
	lb de, PLAYER_DIR_RIGHT, PAD_DOWN
	jp SaffronGatesDefaultScript

.PlayerInCoordsArray:
	dbmapcoord  3,  2
	dbmapcoord  4,  2
	db -1 ; end

Route6GatePlayerMovingScript:
	ld hl, wRoute6GateCurScript
	jp SaffronGatesPlayerMovingScript

Route6Gate_TextPointers:
	def_text_pointers
	dba_const _SaffronGateGuardThanksForTheDrinkText, TEXT_ROUTE6GATE_GUARD
	dba_const _SaffronGateGuardGeeImThirstyText, TEXT_ROUTE6GATE_GUARD_GEE_IM_THIRSTY
	dba_const SaffronGateGuardGiveDrinkText,    TEXT_ROUTE6GATE_GUARD_GIVE_DRINK
