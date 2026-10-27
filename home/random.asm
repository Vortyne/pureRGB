Random::
; Return a random number in a.
; For battles, use BattleRandom.
;;;;;;;;;; PureRGBnote: OPTIMIZED: Random_ used to be in another bank and called with farcall, but it's small enough to live here
; Generate a random 16-bit value.
	push bc
	ldh a, [rDIV]
	ld b, a
	ldh a, [hRandomAdd]
	adc b
	ldh [hRandomAdd], a
	ldh a, [rDIV]
	ld b, a
	ldh a, [hRandomSub]
	sbc b
	ldh [hRandomSub], a
	ldh a, [hRandomAdd]
	pop bc
	ret
;;;;;;;;;;
