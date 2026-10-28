FarCopyData::
; Copy bc bytes from a:hl to de.
	ld [wBuffer], a
	ldh a, [hLoadedROMBank]
	push af
	ld a, [wBuffer]
	call SetCurBank
	rst _CopyData
	pop af
	jp SetCurBank

CopyData::
; Copy bc bytes from hl to de.
;;;;;;;;;; PureRGBnote: OPTIMIZED: the inner loop only counts down c instead of testing all of bc for every byte.
;;;;;;;;;; (incrementing b and c first makes the counts come out right; bc = 0 now copies nothing)
	inc b
	inc c
	jr .start
.loop
	ld a, [hli]
	ld [de], a
	inc de
.start
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	xor a ; returns a = 0 and z flag like before
	ret
;;;;;;;;;;
