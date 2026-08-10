RedsHouse2F_Script:
	ld hl, RedsHouse2F_ScriptPointers
	ld de, wRedsHouse2FCurScript
	jp CallMapScriptInTable

RedsHouse2F_ScriptPointers:
	def_script_pointers
	dw_const RedsHouse2FDefaultScript, SCRIPT_REDSHOUSE2F_DEFAULT
	dw_const DoRet,                    SCRIPT_REDSHOUSE2F_NOOP

RedsHouse2FDefaultScript:
	xor a
	ldh [hJoyHeld], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, SCRIPT_REDSHOUSE2F_NOOP
	ld [wRedsHouse2FCurScript], a
	ret

RedsHouse2F_TextPointers:
	def_text_pointers
	dba_const  RedBedroomPCText, TEXT_REDSHOUSE2F_PLAYERS_PC
	dba_const  _RedBedroomSNESText, TEXT_REDSHOUSE2F_SNES

RedBedroomPCText::
	text_asm
	call SaveScreenTilesToBuffer2
	callfar PlayerPC
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	rst TextScriptEnd
