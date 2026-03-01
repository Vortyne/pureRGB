SpriteFacingAndAnimationTable:
; This table is used for overworld sprites $1-$9.
	dw .StandingDown, NormalSpriteOAM  ; facing down, walk animation frame 0
	dw .WalkingDown,  NormalSpriteOAM  ; facing down, walk animation frame 1
	dw .StandingDown, NormalSpriteOAM  ; facing down, walk animation frame 2
	dw .WalkingDown,  FlippedSpriteOAM ; facing down, walk animation frame 3
	dw .StandingUp,   NormalSpriteOAM  ; facing up, walk animation frame 0
	dw .WalkingUp,    NormalSpriteOAM  ; facing up, walk animation frame 1
	dw .StandingUp,   NormalSpriteOAM  ; facing up, walk animation frame 2
	dw .WalkingUp,    FlippedSpriteOAM ; facing up, walk animation frame 3
	dw .StandingLeft, NormalSpriteOAM  ; facing left, walk animation frame 0
	dw .WalkingLeft,  NormalSpriteOAM  ; facing left, walk animation frame 1
	dw .StandingLeft, NormalSpriteOAM  ; facing left, walk animation frame 2
	dw .WalkingLeft,  NormalSpriteOAM  ; facing left, walk animation frame 3
	dw .StandingLeft, FlippedSpriteOAM ; facing right, walk animation frame 0
	dw .WalkingLeft,  FlippedSpriteOAM ; facing right, walk animation frame 1
	dw .StandingLeft, FlippedSpriteOAM ; facing right, walk animation frame 2
	dw .WalkingLeft,  FlippedSpriteOAM ; facing right, walk animation frame 3
; The rest of this table is used for sprites $a and $b.
; All orientation and animation parameters lead to the same result.
; Used for immobile sprites like items on the ground.
	dw .StandingDown, NormalSpriteOAM  ; facing down, walk animation frame 0
	dw .StandingDown, NormalSpriteOAM  ; facing down, walk animation frame 1
	dw .StandingDown, NormalSpriteOAM  ; facing down, walk animation frame 2
	dw .StandingDown, NormalSpriteOAM  ; facing down, walk animation frame 3
	dw .StandingDown, NormalSpriteOAM  ; facing up, walk animation frame 0
	dw .StandingDown, NormalSpriteOAM  ; facing up, walk animation frame 1
	dw .StandingDown, NormalSpriteOAM  ; facing up, walk animation frame 2
	dw .StandingDown, NormalSpriteOAM  ; facing up, walk animation frame 3
	dw .StandingDown, NormalSpriteOAM  ; facing left, walk animation frame 0
	dw .StandingDown, NormalSpriteOAM  ; facing left, walk animation frame 1
	dw .StandingDown, NormalSpriteOAM  ; facing left, walk animation frame 2
	dw .StandingDown, NormalSpriteOAM  ; facing left, walk animation frame 3
	dw .StandingDown, NormalSpriteOAM  ; facing right, walk animation frame 0
	dw .StandingDown, NormalSpriteOAM  ; facing right, walk animation frame 1
	dw .StandingDown, NormalSpriteOAM  ; facing right, walk animation frame 2
	dw .StandingDown, NormalSpriteOAM  ; facing right, walk animation frame 3

; four tile ids compose an overworld sprite
.StandingDown: db $00, $01, $02, $03
.WalkingDown:  db $80, $81, $82, $83
.StandingUp:   db $04, $05, $06, $07
.WalkingUp:    db $84, $85, $86, $87
.StandingLeft: db $08, $09, $0a, $0b
.WalkingLeft:  db $88, $89, $8a, $8b

NormalSpriteOAM::
	; y, x, attributes
	db 0, 0, $00 ; top left
	db 0, 8, $00 ; top right
	db 8, 0, UNDER_GRASS ; bottom left
	db 8, 8, UNDER_GRASS | FACING_END ; bottom right

FlippedSpriteOAM::
	; y, x, attributes
	db 0, 8, OAM_HFLIP ; top left
	db 0, 0, OAM_HFLIP ; top right
	db 8, 8, OAM_HFLIP | UNDER_GRASS ; bottom left
	db 8, 0, OAM_HFLIP | UNDER_GRASS | FACING_END ; bottom right
