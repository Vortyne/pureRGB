TextBoxBorder::
; Draw a c×b text box at hl.

	; top row
	push hl
	ld a, '┌'
	ld [hli], a
	inc a ; "─"
	call .PlaceChars
	inc a ; "┐"
	ld [hl], a
	pop hl

	ld de, SCREEN_WIDTH
	add hl, de

	; middle rows
.next
	push hl
	ld a, '│'
	ld [hli], a
	ld a, ' '
	call .PlaceChars
	ld [hl], '│'
	pop hl

	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .next

	; bottom row
	ld a, '└'
	ld [hli], a
	ld a, '─'
	call .PlaceChars
	ld [hl], '┘'
	ret

.PlaceChars::
; Place char a c times.
	ld d, c
.loop
	ld [hli], a
	dec d
	jr nz, .loop
	ret

ContText::
	push de
	ld b, h
	ld c, l
	ld hl, ContCharText
	call TextCommandProcessor
	ld h, b
	ld l, c
	pop de
	inc de
	jr PlaceNextChar

ContCharText::
	text "<_CONT>@"
	text_end

PlaceString::
	push hl

PlaceNextChar::
	ld a, [de]
	cp '@'
	jr nz, .NotTerminator
	ld b, h
	ld c, l
	pop hl
	ret
.NotTerminator
; PureRGBnote: CHANGED: Check against a jump table instead of a dictionary.
; this actually speeds up text a lot because it doesn't make do a ton of cp commands for every single character
	push hl
	cp FIRST_TEXT_SHORTCUT_ID
	jr c, NotTextShortcut
	cp LAST_TEXT_SHORTCUT_ID + 1
	jr nc, NotTextShortcut
	sub FIRST_TEXT_SHORTCUT_ID
	ld hl, TextShortcutCommandJumpTable
	ld b, 0
	ld c, a
	add hl, bc
	add hl, bc
	hl_deref
	bit 7, h
	jr z, .notCodeCommand
	res 7, h
	ld b, h
	ld c, l
	pop hl
	jp_bc
.notCodeCommand
	pop bc
	push de
	ld d, h
	ld e, l
	ld h, b
	ld l, c
	; fall through
PlaceCommandCharacter::
	call PlaceString
	ld h, b
	ld l, c
	pop de
	inc de
	jr PlaceNextChar

NotTextShortcut:
	pop hl
	ld a, [de]
	ld [hli], a
	call PrintLetterDelay
	; fall through
NextChar::
	inc de
	jr PlaceNextChar

PrintPlayerName:: 
	push de
	ld de, wPlayerName
	jr PlaceCommandCharacter

PrintRivalName::  
	push de
	ld de, wRivalName
	jr PlaceCommandCharacter 

PlaceMoveTargetsName::
	ldh a, [hWhoseTurn]
	xor 1
	jr PlaceMoveUsersName.place

PlaceMoveUsersName::
	ldh a, [hWhoseTurn]
.place:
	push de
	and a
	ld de, wBattleMonNick
	jr z, PlaceCommandCharacter
.enemy
	ld de, EnemyText
	call PlaceString
	ld h, b
	ld l, c
	ld de, wEnemyMonNick
	jr PlaceCommandCharacter

LineChar::
	pop hl
	hlcoord 1, 16
	push hl
	jr NextChar

NextCharCmd::
	ld bc, 2 * SCREEN_WIDTH
	ldh a, [hUILayoutFlags]
	bit 2, a
	jr z, .ok
	ld bc, SCREEN_WIDTH
.ok
	pop hl
	add hl, bc
	push hl
	jr NextChar

Paragraph::
	push de
	ld a, '▼'
	ldcoord_a 18, 16
	call ProtectedDelay3
	call ManualTextScroll
	call ClearTextBox
	ld c, 20
	rst DelayFrames
	pop de
	hlcoord 1, 14
	jr NextChar

PageChar::
	push de
	ld a, '▼'
	ldcoord_a 18, 16
	call ProtectedDelay3
	call ManualTextScroll
	hlcoord 1, 10
	lb bc, 7, 18
	call ClearScreenArea
	ld c, 20
	rst DelayFrames
	pop de
	pop hl
	hlcoord 1, 11
	push hl
	jr NextChar

;;;;;;;;; PureRGBnote: ADDED: new text command that allows multiple buttons to be watched while waiting on a text prompt 
MultiButtonPageChar::
	push de
	callfar TextCommandPromptMultiButton
	; d = what to do after this
	ld a, d
	and a
	jr nz, .exit
	pop de
	pop hl
	hlcoord 1, 11
	push hl
	jp NextChar
.exit
	pop de
	jr DoneText
;;;;;;;;;

PromptText::
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jp z, .ok
	ld a, '▼'
	ldcoord_a 18, 16
.ok
	call ProtectedDelay3
	call ManualTextScroll
	ld a, ' '
	ldcoord_a 18, 16
	; fall through
DoneText::
	pop hl
	ld de, TextScriptEndingText
	dec de
	ret

_ContText::
	ld a, '▼'
	ldcoord_a 18, 16
	call ProtectedDelay3
	push de
	call ManualTextScroll
	pop de
	ld a, ' '
	ldcoord_a 18, 16
_ContTextNoPause::
	push de
	call ScrollTextUpOneLine
	call ScrollTextUpOneLine
	hlcoord 1, 16
	pop de
	jp NextChar

; move both rows of text in the normal text box up one row
; always called twice in a row
; first time, copy the two rows of text to the "in between" rows that are usually empty
; second time, copy the bottom row of text into the top row of text
ScrollTextUpOneLine::
	hlcoord 0, 14 ; top row of text
	decoord 0, 13 ; empty line above text
	ld b, SCREEN_WIDTH * 3
.copyText
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copyText
	hlcoord 1, 16
	ld a, ' '
	ld b, SCREEN_WIDTH - 2
.clearText
	ld [hli], a
	dec b
	jr nz, .clearText

	ld b, 5
.WaitFrame
	rst _DelayFrame
	dec b
	jr nz, .WaitFrame
	ret

PlaceDexEnd::
	ld [hl], '.'
	pop hl
	ret

TextScriptPromptButton::
	text_promptbutton
TextScriptEndingText::
	text_end

ProtectedDelay3::
	push bc
	call Delay3
	pop bc
	ret

;NullChar::
;	ld b, h
;	ld c, l
;	pop hl
;	; A "<NULL>" character in a printed string
;	; displays an error message with the current value
;	; of hTextID in decimal format.
;	; This is a debugging leftover.
;	ld de, TextIDErrorText
;	dec de
;	ret	

;TextIDErrorText:: ; "[hTextID] ERROR."
;	text_far_end _TextIDErrorText

; we can use the top bit of this jump table
DEF TEXT_CODE_CMD_MARKER EQU $8000

; PureRGBnote: CHANGED: many shortcut commands were added here 
; because it greatly reduces text data size if certain commonly used phrases are parameterized.
; must match the order of the charmap shortcuts and no gaps are allowed
; since ROM space addresses never goes above $8000 address, 
; we can use the highest bit of these words as an indicator of what function to run for each.
TextShortcutCommandJumpTable:
	dw LikeText
	dw AnText
	dw CapYouText
	dw ErText
	dw WithText
	dw AtText
	dw IghtText
	dw HaveText
	dw AText
	dw HereText
	dw ToSpaceText
	dw SpaceToText
	dw OrText
	dw IngText
	dw TheText
	dw YouText
	dw OpponentText
	dw UserText
	dw PlaceMonText
	dw TrainerTipsText
	dw TeamCharText
	dw MultiButtonPageChar | TEXT_CODE_CMD_MARKER
	dw PageChar | TEXT_CODE_CMD_MARKER
	dw PlacePKMNText
	dw _ContText | TEXT_CODE_CMD_MARKER
	dw _ContTextNoPause | TEXT_CODE_CMD_MARKER
	dw IsText
	dw NextCharCmd | TEXT_CODE_CMD_MARKER
	dw LineChar | TEXT_CODE_CMD_MARKER
	dw DoRet ; string terminator, not used here
	dw Paragraph | TEXT_CODE_CMD_MARKER
	dw PrintPlayerName | TEXT_CODE_CMD_MARKER
	dw PrintRivalName | TEXT_CODE_CMD_MARKER
	dw PlacePOKeText
	dw ContText | TEXT_CODE_CMD_MARKER
	dw ThreeDotsText
	dw DoneText | TEXT_CODE_CMD_MARKER
	dw PromptText | TEXT_CODE_CMD_MARKER
	dw PlaceMoveTargetsName | TEXT_CODE_CMD_MARKER
	dw PlaceMoveUsersName | TEXT_CODE_CMD_MARKER
	dw PCCharText
	dw TMCharText
	dw TrainerCharText
	dw RocketCharText
	dw PlaceDexEnd | TEXT_CODE_CMD_MARKER

TrainerCharText:: db "TRAINER@"
TeamCharText::    db "TEAM @"
RocketCharText::  db "ROCKET@"
ThreeDotsText::   db "...@"
TrainerTipsText:: db "<TRAINER> TIPS@"
OpponentText::    db "opponent@"
UserText::        db "user@"
PCCharText::      db "PC@"
; these have to be separated by a comma in order to not re-trigger the charmap macro that sets them up to be used automatically
TheText::         db "t","he@" 
YouText::         db "y","ou@" 
IngText::         db "i","ng@" 
OrText::          db "o","r@" 
IsText::          db "i","s@" 
SpaceToText::     db " ", "to@"
ToSpaceText::     db "t", "o @"
AText::           db " ", "a @"
AtText::          db "a", "t@"
ErText::          db "e", "r@"
CapYouText::      db "Y", "ou@"
AnText::          db "a", "n@"
HereText::        db "h", "ere@"

TextCommand_LOW::
; write text at (1,16)
	pop hl
	bccoord 1, 16 ; second line of dialogue text box
	jr NextTextCommand

TextCommand_PROMPT_BUTTON::
; wait for button press; show arrow
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jp z, TextCommand_WAIT_BUTTON
	ld a, '▼'
	ldcoord_a 18, 16 ; place down arrow in lower right corner of dialogue text box
	push bc
	call ManualTextScroll ; blink arrow and wait for A or B to be pressed
	pop bc
	ld a, ' '
	ldcoord_a 18, 16 ; overwrite down arrow with blank space
	pop hl
	jr NextTextCommand

TextCommand_SCROLL::
; pushes text up two lines and sets the BC cursor to the border tile
; below the first character column of the text box.
	ld a, ' '
	ldcoord_a 18, 16 ; place blank space in lower right corner of dialogue text box
	call ScrollTextUpOneLine
	call ScrollTextUpOneLine
	pop hl
	bccoord 1, 16 ; second line of dialogue text box
	jr NextTextCommand

TextCommand_BOX::
; draw a box (height, width)
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	push hl
	ld h, d
	ld l, e
	call TextBoxBorder
	pop hl
	jr NextTextCommand

TextCommandProcessor::
	ld a, [wLetterPrintingDelayFlags]
	push af
	set BIT_TEXT_DELAY, a
	ld e, a
	ldh a, [hClearLetterPrintingDelayFlags]
	xor e
	ld [wLetterPrintingDelayFlags], a
	ld a, c
	ld [wTextDest], a
	ld a, b
	ld [wTextDest + 1], a

NextTextCommand::
	ld a, [hli]
	cp TX_END
	jr nz, .TextCommand
.NoNextTextCommand:
	pop af
	ld [wLetterPrintingDelayFlags], a
	ret

.TextCommand:
	push hl
	cp TX_FAR
	jp z, TextCommand_FAR
	cp TX_SOUND_POKEDEX_RATING
	jp nc, TextCommand_SOUND
	ld hl, TextCommandJumpTable
	push bc
	add a
	ld b, 0
	ld c, a
	add hl, bc
	pop bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

TextCommand_START::
; write text until "@"
	pop hl
TextCommand_START_noPop::
	ld d, h
	ld e, l
	ld h, b
	ld l, c
	call PlaceString
	ld h, d
	ld l, e
	inc hl
	jr NextTextCommand

TextCommand_RAM::
; write text from a ram address (little endian)
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl
	ld h, b
	ld l, c
	call PlaceString
	pop hl
	jr NextTextCommand

TextCommand_BCD::
; write bcd from address, typically ram
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld c, a
	call PrintBCDNumber
	ld b, h
	ld c, l
	pop hl
	jr NextTextCommand

TextCommand_START_storeFlags:
	ld a, [wLetterPrintingDelayFlags]
	push af
	jr TextCommand_START_noPop

TextCommand_RAM_CHECK_CONT::
	pop hl
	push hl
	push de
	decoord 17, 16
	call DoesTextPtrHLFitOnBCCoordLine
	jr nc, .yes
	ld a, '▼'
	ldcoord_a 18, 16
	call Delay3
	call ManualTextScroll
	ld a, ' '
	ldcoord_a 18, 16
	call ScrollTextUpOneLine
	call ScrollTextUpOneLine
	bccoord 1, 16
.yes
	pop de
	jr TextCommand_RAM

TextCommand_RAM_CHECK_LINE::
	pop hl
	push hl
	push de
	decoord 19, 14
	call DoesTextPtrHLFitOnBCCoordLine
	pop de
	jr nc, .fits
	bccoord 1, 16
.fits
	jr TextCommand_RAM

; PureRGBnote: ADDED: jump to a different address in the same text bank so we can reuse text
TextCommand_JUMP::
	pop hl
	hl_deref
	push hl
	jr TextCommand_START

; PureRGBnote: ADDED: call different text in the same bank then come back
TextCommand_CALL::
	pop hl
	push hl
	hl_deref
	ResetFlag FLAG_INTERRUPTED_TEXT
	call TextCommand_START_storeFlags
	ld b, h
	ld c, l
	pop hl
	CheckFlag FLAG_INTERRUPTED_TEXT
	jp nz, NextTextCommand.NoNextTextCommand
	; inc hl twice to increment past the text_call address
	inc hl
	inc hl
	jp TextCommand_START_noPop ; assumes after returning from call we will do additional text

TextCommand_MOVE::
; move to a new tile
	pop hl
	ld a, [hli]
	ld [wTextDest], a
	ld c, a
	ld a, [hli]
	ld [wTextDest + 1], a
	ld b, a
	jp NextTextCommand

TextCommand_START_ASM::
; run assembly code
	pop hl
	ld de, NextTextCommand
	push de
	jp hl

TextCommand_NUM::
; print a number
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld b, a
	and $0f
	ld c, a
	ld a, b
	and $f0
	swap a
	set BIT_LEFT_ALIGN, a
	ld b, a
	call PrintNumber
	ld b, h
	ld c, l
	pop hl
	jp NextTextCommand

TextCommand_PAUSE::
; wait for button press or 30 frames
	push bc
	call Joypad
	ldh a, [hJoyHeld]
	and PAD_A | PAD_B
	jr nz, .done
	ld c, 30 ; half a second
	rst DelayFrames
.done
	pop bc
	pop hl
	jp NextTextCommand

TextCommand_SOUND::
; play a sound effect from TextCommandSounds
	pop hl
	push bc
	dec hl
	ld a, [hli]
	ld b, a ; b = text command number that got us here
	push hl
	ld hl, TextCommandSounds
.loop
	ld a, [hli]
	cp b
	jr z, .play
	inc hl
	jr .loop

.play
;;;;;;;;;; shinpokerednote: FIXED: when there's 0 delay on text, we need to wait here to get text command sounds to work right.
	ld a, [wOptions]
	and TEXT_DELAY_MASK
	call z, WaitForSoundToFinish
	ld a, [wAudioFadeOutControl]
	push af
	xor a
	ld [wAudioFadeOutControl], a ; don't allow fading out audio to skip the sound being played below
	ld a, [hl]
	rst _PlaySound
	call WaitForSoundToFinish
	pop af
	ld [wAudioFadeOutControl], a
;;;;;;;;;;
	pop hl
	pop bc
	jp NextTextCommand

TextCommandSounds::
	db TX_SOUND_GET_ITEM_1,           SFX_GET_ITEM_1 ; actually plays SFX_LEVEL_UP when the battle music engine is loaded
	db TX_SOUND_CAUGHT_MON,           SFX_CAUGHT_MON
	db TX_SOUND_POKEDEX_RATING,       SFX_POKEDEX_RATING ; unused
	db TX_SOUND_GET_ITEM_2,           SFX_GET_ITEM_2
	db TX_SOUND_GET_KEY_ITEM,         SFX_GET_KEY_ITEM
	db TX_SOUND_DEX_PAGE_ADDED,       SFX_DEX_PAGE_ADDED

TextCommand_DOTS::
; wait for button press or 30 frames while printing "…"s
	pop hl
	ld a, [hli]
	ld d, a
	push hl
	ld h, b
	ld l, c

.loop
	ld a, '…'
	ld [hli], a
	push de
	call Joypad
	pop de
	ldh a, [hJoyHeld] ; joypad state
	and PAD_A | PAD_B
	jr nz, .next ; if so, skip the delay
	ld c, 10
	rst DelayFrames
.next
	dec d
	jr nz, .loop

	ld b, h
	ld c, l
	pop hl
	jp NextTextCommand

TextCommand_WAIT_BUTTON::
; wait for button press; don't show arrow
	push bc
	call ManualTextScroll
	pop bc
	pop hl
	jp NextTextCommand

TextCommand_FAR::
; write text from a different bank (little endian)
	pop hl
	call TextCommand_FARCommon
	jp NextTextCommand

TextCommand_FAR_END::
	pop hl
	call TextCommand_FARCommon
	ld hl, TextScriptEndingText
	jp NextTextCommand

TextCommand_FARCommon::
	ldh a, [hLoadedROMBank]
	push af

	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	call SetCurBank

	push hl
	ld l, e
	ld h, d
	call TextCommandProcessor
	pop hl

	pop af
	jp SetCurBank


TextCommand_PLURALIZE::
	pop hl
	push hl
	hl_deref
	ld a, [hl]
	dec a
	jr z, .skip
	ld a, 's'
	ld [bc], a
	inc bc
.skip
	pop hl
	inc hl
	inc hl
	jp NextTextCommand

TextCommand_STRINGBUFFER::
	ld de, wStringBuffer
	jr PlaceStringFromDENextTextCommand

TextCommand_NAMEBUFFER::
	ld de, wNameBuffer
	; fall through
PlaceStringFromDENextTextCommand:
; write text from de then next text comment
	ld h, b
	ld l, c
	call PlaceString
	pop hl
	jp NextTextCommand


; Checks if variable wram text pointer in hl fits on the same line as the current text printing coordinate bc
; with line endpoint coords de
; sets carry if it does not fit
DoesTextPtrHLFitOnBCCoordLine:
	push bc
	hl_deref
	ld b, -1
.loopCount
	inc b
	ld a, [hli]
	cp '@'
	jr nz, .loopCount
	ld h, 0
	ld l, b
	pop bc
	push bc
	add hl, bc
	ld a, l
	cp e
	jr nc, .nope
	pop bc
	and a
	ret
.nope
	pop bc
	scf
	ret

TextCommandJumpTable::
; entries correspond to TX_* constants (see macros/scripts/text.asm)
	dw TextCommand_START         ; TX_START
	dw TextCommand_RAM           ; TX_RAM
	dw TextCommand_BCD           ; TX_BCD
	dw TextCommand_MOVE          ; TX_MOVE
	dw TextCommand_BOX           ; TX_BOX
	dw TextCommand_LOW           ; TX_LOW
	dw TextCommand_PROMPT_BUTTON ; TX_PROMPT_BUTTON
IF DEF(_DEBUG)
	dw _ContTextNoPause          ; TX_SCROLL
ELSE
	dw TextCommand_SCROLL        ; TX_SCROLL
ENDC
	dw TextCommand_START_ASM     ; TX_START_ASM
	dw TextCommand_NUM           ; TX_NUM
	dw TextCommand_PAUSE         ; TX_PAUSE
	dw TextCommand_SOUND         ; TX_SOUND_GET_ITEM_1 (also handles other TX_SOUND_* commands)
	dw TextCommand_DOTS          ; TX_DOTS
	dw TextCommand_WAIT_BUTTON   ; TX_WAIT_BUTTON
	dw TextCommand_JUMP          ; TX_JUMP
	dw TextCommand_CALL          ; TX_CALL
	dw TextCommand_RAM_CHECK_CONT   ; TX_RAM_CONT
	dw TextCommand_RAM_CHECK_LINE   ; TX_RAM_LINE
	dw TextCommand_PLURALIZE     ; TX_PLURALIZE
	dw TextCommand_STRINGBUFFER  ; TX_RAM_STRINGBUFFER
	dw TextCommand_NAMEBUFFER    ; TX_RAM_NAMEBUFFER
	dw TextCommand_FAR_END       ; TX_FAR_END
	; greater TX_* constants are handled directly by NextTextCommand
