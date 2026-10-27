FlagAction::
; Perform action b on bit c
; in the bitfield at hl.
;  0: reset
;  1: set
;  2: read
; Return the result in c and a

	push hl
	push de
	push bc

;;;;;;;;;; PureRGBnote: OPTIMIZED: bitmask is read from a table instead of being built with a shift loop
	; d = 1 << (c & 7) (bitmask)
	ld a, c
	and 7
	add LOW(BitMaskTable)
	ld e, a
	adc HIGH(BitMaskTable)
	sub e
	ld d, a
	ld a, [de]
	ld d, a
;;;;;;;;;;

	; byte
	ld a, c
	srl_a_3x
	add l
	ld l, a
	jr nc, .ok
	inc h
.ok

	ld a, b
	and a
	jr z, .reset
	cp FLAG_TEST
	jr z, .read

; set
	ld b, [hl]
	ld a, d
	or b
	ld [hl], a
	jr .done

.reset
	ld b, [hl]
	ld a, d
	cpl
	and b
	ld [hl], a
	jr .done

.read
	ld b, [hl]
	ld a, d
	and b
.done
	pop bc
	pop de
	pop hl
	ld c, a
	and a
	ret

; PureRGBnote: ADDED: faster read-only version of FlagAction for code that runs every frame.
; Test bit c in the bitfield at hl.
; Return the result in c and a, z flag set if the bit is not set.
; Preserves b, de, and hl.
TestFlag::
	push hl
	push de
	ld a, c
	and 7
	add LOW(BitMaskTable)
	ld e, a
	adc HIGH(BitMaskTable)
	sub e
	ld d, a ; de = BitMaskTable + (c & 7)
	ld a, c
	srl_a_3x
	add l
	ld l, a
	jr nc, .ok
	inc h
.ok
	ld a, [de]
	and [hl]
	ld c, a
	pop de
	pop hl
	ret

BitMaskTable:
FOR n, 8
	db 1 << n
ENDR
