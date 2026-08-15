; PureRGBnote: ADDED: basement room in the new house in cerulean. A big room with lots of interesting text to read.
; contains a secret vending machine that requires a pokemon with pay day in their moves in slot 1 of the party to use.
; contains a rocket NPC who will trade you an alternate palette magneton
; contains a big machine that will summon missingno when checked with A button.
; this floor is only accessible after becoming champion.
CeruleanRocketHouseB1F_Script:
	ld hl, CeruleanRocketHouse_ScriptPointers
	ld de, wCeruleanRocketHouseCurScript
	jp CallMapScriptInTable

CeruleanRocketHouse_ScriptPointers:
	def_script_pointers
	dw_const DoRet,                              SCRIPT_CERULEANROCKETHOUSEB1F_DEFAULT
	dw_const CeruleanRocketHouseMissingnoScript, SCRIPT_CERULEANROCKETHOUSEB1F_MISSINGNO
	EXPORT SCRIPT_CERULEANROCKETHOUSEB1F_MISSINGNO ; used by cerulean_rocket_house.asm

CeruleanRocketHouseB1F_TextPointers:
	def_text_pointers
	dba_const CeruleanRocketHouseB1FRocketText,            TEXT_CERULEANROCKETHOUSEB1F_ROCKET
	dba_const PickUpItemText,                              TEXT_CERULEANROCKETHOUSEB1F_ITEM1
	dba_const _CeruleanRocketHouseB1FEntranceDoorSignText,  TEXT_CERULEANROCKETHOUSEB1F_ENTRANCE_DOOR_SIGN
	dba_const _CeruleanRocketHouseB1FBottomDoorSignText,    TEXT_CERULEANROCKETHOUSEB1F_BOTTOM_DOOR_SIGN
	dba_const _CeruleanRocketHouseB1FTopDoorSignText,       TEXT_CERULEANROCKETHOUSEB1F_TOP_DOOR_SIGN  
	dba_const _CeruleanRocketHouseB1FMapText,               TEXT_CERULEANROCKETHOUSEB1F_MAP
	dba_const CeruleanRocketHouseB1FVendingMachineText,    TEXT_CERULEANROCKETHOUSEB1F_VENDING_MACHINE
	dba_const CeruleanRocketHouseB1FLeftComputerText,      TEXT_CERULEANROCKETHOUSEB1F_LEFT_COMPUTER
	dba_const CeruleanRocketHouseB1FCenterComputerText,    TEXT_CERULEANROCKETHOUSEB1F_CENTER_COMPUTER
	dba_const CeruleanRocketHouseB1FRightComputerText,     TEXT_CERULEANROCKETHOUSEB1F_RIGHT_COMPUTER
	dba_const _CeruleanRocketHouseB1FLeftPaperText,         TEXT_CERULEANROCKETHOUSEB1F_LEFT_PAPER
	dba_const _CeruleanRocketHouseB1FRightPaperText,        TEXT_CERULEANROCKETHOUSEB1F_RIGHT_PAPER
	dba_const CeruleanRocketHouseB1FMachineText,           TEXT_CERULEANROCKETHOUSEB1F_MACHINE

CeruleanRocketHouseB1FRocketText:
	text_asm
	ld a, [wCompletedInGameTradeFlags]
	bit TRADE_FOR_CHIKUCHIKU, a
	jr nz, .doneTrade
	ld hl, CeruleanRocketHouseB1FBeforeTradeText
	rst _PrintText
	ld a, TRADE_FOR_CHIKUCHIKU
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	ld a, [wCompletedInGameTradeFlags]
	bit TRADE_FOR_CHIKUCHIKU, a
	jr nz, .doneTrade
	rst TextScriptEnd
.doneTrade
	ld hl, CeruleanRocketHouseB1FAfterTradeText
	rst _PrintText
	rst TextScriptEnd

CeruleanRocketHouseMissingnoScript:
	call DisableAllJoypad
	ld a, SFX_STOP_ALL_MUSIC
	rst _PlaySound
	ld b, 100
.loop
	push bc
	ld c, BANK(SFX_SS_Anne_Horn_1)
	ld a, SFX_SS_ANNE_HORN
	call PlayMusic
	rst _DelayFrame
	rst _DelayFrame
	pop bc
	dec b
	jr nz, .loop
	ld a, SFX_STOP_ALL_MUSIC
	rst _PlaySound
	ld c, BANK(SFX_Noise_Instrument05_1)
	ld a, SFX_NOISE_INSTRUMENT05
	call PlayMusic
	ld hl, vNPCSprites2 tile $40
	; copy 4 tiles of random garbage from a random bank into vram
	call Random
	and %1111111
	ld d, a
	call Random
	ld e, a
	call Random
	and %1111 ; only use first 16 banks which are mostly full
	ld b, a
	ld c, 4
	call CopyVideoDataHBlank
	; fill the screen with garbage tiles to make things look like they glitched out
	call FillScreenWithRandomTilesFromC0
	xor a
	ldh [hWY], a ; put the window on the screen
	ld [wUpdateSpritesEnabled], a
	inc a
	ldh [hAutoBGTransferEnabled], a ; enable continuous WRAM to VRAM transfer each V-blank
	ld b, $FF
	rst DelayFrames
	ld a, MISSINGNO
	call PlayCry
	ld a, 120
	ld [wCurEnemyLevel], a
	ld a, MISSINGNO
	ld [wCurOpponent], a
	call EnableAllJoypad
	call GBPalNormal
	callfar InitOpponent
	xor a
	ld [wCeruleanRocketHouseCurScript], a
	jp BattleOccurred

FillScreenWithRandomTilesFromC0:
	ld bc, 20 * 18
	inc b
	hlcoord 0, 0
.loop
	call Random
	and %11
	add $C0
	ld [hli], a
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	jp Delay3

CeruleanRocketHouseB1FBeforeTradeText:
	text_far_end _CeruleanRocketHouseB1FBeforeTradeText

CeruleanRocketHouseB1FAfterTradeText:
	text_far_end _CeruleanRocketHouseB1FAfterTradeText

CeruleanRocketHouseB1FVendingMachineText:
	text_asm
	ld hl, wPartyMon1Moves
	ld b, NUM_MOVES
.checkMoves
	ld a, [hl]
	cp PAY_DAY
	jr z, .codeBroken
	inc hl
	dec b
	jr nz, .checkMoves
	ld hl, CeruleanRocketHouseB1FCodeText
	rst _PrintText
	rst TextScriptEnd
.codeBroken
	farcall VendingMachineMenu
	rst TextScriptEnd

CeruleanRocketHouseB1FCodeText:
	text_far_end _CeruleanRocketHouseB1FCodeText

OptionalText:
	ld hl, .OptionalTextQ
	rst _PrintText
	call YesNoChoice
	jr nz, .no
	scf
	ret
.no
	ld hl, .OptionalDidntRead
	rst _PrintText
	ret

.OptionalTextQ::
	text_far_end _CeruleanRocketHouseB1FOptionalText

.OptionalDidntRead::
	text_far_end _CeruleanRocketHouseB1FOptionalTextNo

CeruleanRocketHouseB1FLeftComputerText::
	text_asm
	ld hl, .LeftComputerText1
	rst _PrintText
	call OptionalText
	jr nc, .done
	ld hl, .LeftComputerText2
	rst _PrintText
.done
	rst TextScriptEnd

.LeftComputerText1::
	text_far_end _CeruleanRocketHouseB1FLeftComputerText

.LeftComputerText2::
	text_far_end _CeruleanRocketHouseB1FLeftComputerText2

CeruleanRocketHouseB1FCenterComputerText::
	text_asm
	ld hl, .CenterComputerText1
	rst _PrintText
	call OptionalText
	jr nc, .done
	ld hl, .CenterComputerText2
	rst _PrintText
.done
	rst TextScriptEnd

.CenterComputerText1::
	text_far_end _CeruleanRocketHouseB1FCenterComputerText

.CenterComputerText2::
	text_far_end _CeruleanRocketHouseB1FCenterComputerText2

CeruleanRocketHouseB1FRightComputerText::
	text_asm
	ld hl, .RightComputerText1
	rst _PrintText
	call OptionalText
	jr nc, .done
	ld hl, .RightComputerText2
	rst _PrintText
.done
	rst TextScriptEnd

.RightComputerText1:
	text_far_end _CeruleanRocketHouseB1FRightComputerText

.RightComputerText2:
	text_far_end _CeruleanRocketHouseB1FRightComputerText2

CeruleanRocketHouseB1FMachineText:
	text_asm
	ld hl, .MachineText
	rst _PrintText
	ld a, SCRIPT_CERULEANROCKETHOUSEB1F_MISSINGNO
	ld [wCeruleanRocketHouseCurScript], a
	rst TextScriptEnd

.MachineText:
	text_far_end _CeruleanRocketHouseB1FMachineText

RocketBasementMachine::
	ld a, TEXT_CERULEANROCKETHOUSEB1F_MACHINE
	ldh [hTextID], a
	jp DisplayTextID
