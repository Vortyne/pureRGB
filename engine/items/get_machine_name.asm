GetMachineName::
; copies the name of the TM/HM in [wNamedObjectIndex] to wNameBuffer
	ld a, [wNamedObjectIndex]
	cp TM01 ; is this a TM? [not HM]
	ld hl, TechnicalPrefix ; points to "TM"
	ld bc, 2
	jr nc, .WriteMachinePrefix
; if HM, then write "HM" and add NUM_HMS to the item ID, so we can reuse the
; TM printing code
	add NUM_HMS
	ld hl, HiddenPrefix ; points to "HM"
	ld bc, 2
.WriteMachinePrefix
	push af
	ld de, wNameBuffer
	rst _CopyData
	pop af
; now get the machine number and convert it to text
	sub TM01 - 1
	ld b, "0"
.FirstDigit
	sub 10
	jr c, .SecondDigit
	inc b
	jr .FirstDigit
.SecondDigit
	add 10
	push af
	ld a, b
	ld [de], a
	inc de
	pop af
	ld b, "0"
	add b
	ld [de], a
	inc de
	ld a, "@"
	ld [de], a
	ret

TechnicalPrefix::
	db "TM"
HiddenPrefix::
	db "HM"
