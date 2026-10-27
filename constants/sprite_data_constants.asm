; sprite facing directions
	const_def 0, $04
	const SPRITE_FACING_DOWN  ; $00
	const SPRITE_FACING_UP    ; $04
	const SPRITE_FACING_LEFT  ; $08
	const SPRITE_FACING_RIGHT ; $0C

	const_def 0, $40
	const NPC_MOVEMENT_DOWN  ; $00
	const NPC_MOVEMENT_UP    ; $40
	const NPC_MOVEMENT_LEFT  ; $80
	const NPC_MOVEMENT_RIGHT ; $C0

DEF NPC_CHANGE_FACING EQU $E0

; PureRGBnote: ADDED: OR this with an NPC_MOVEMENT_* direction in scripted movement data (MoveSprite)
; to make the NPC run that step (4x as fast as an NPC walking, the same speed as the player running).
; bit 4 keeps the value inside the same direction range, and below NPC_CHANGE_FACING.
DEF BIT_NPC_RUN EQU 4
DEF NPC_RUN EQU 1 << BIT_NPC_RUN
DEF NPC_RUN_DOWN  EQU NPC_MOVEMENT_DOWN  | NPC_RUN ; $10
DEF NPC_RUN_UP    EQU NPC_MOVEMENT_UP    | NPC_RUN ; $50
DEF NPC_RUN_LEFT  EQU NPC_MOVEMENT_LEFT  | NPC_RUN ; $90
DEF NPC_RUN_RIGHT EQU NPC_MOVEMENT_RIGHT | NPC_RUN ; $D0
ASSERT NPC_RUN_RIGHT < NPC_CHANGE_FACING

; player direction constants
	const_def
	const PLAYER_DIR_BIT_RIGHT ; 0
	const PLAYER_DIR_BIT_LEFT  ; 1
	const PLAYER_DIR_BIT_DOWN  ; 2
	const PLAYER_DIR_BIT_UP    ; 3

DEF PLAYER_DIR_RIGHT EQU 1 << PLAYER_DIR_BIT_RIGHT
DEF PLAYER_DIR_LEFT  EQU 1 << PLAYER_DIR_BIT_LEFT
DEF PLAYER_DIR_DOWN  EQU 1 << PLAYER_DIR_BIT_DOWN
DEF PLAYER_DIR_UP    EQU 1 << PLAYER_DIR_BIT_UP
