_GetItemPrice::
; Stores item's price as BCD at hItemPrice (3 bytes)
; Input: [wCurItem] = item id
	ld hl, wItemPrices
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wCurItem]
	cp HM01
	jr nc, .getTMPrice
	ld bc, $3
.loop
	add hl, bc
	dec a
	jr nz, .loop
	dec hl
	ld a, [hld]
	ldh [hItemPrice + 2], a
	ld a, [hld]
	ldh [hItemPrice + 1], a
	ld a, [hl]
	ldh [hItemPrice], a
	jr .done
.getTMPrice
	call GetMachinePrice
.done
	ld de, hItemPrice
	ret

INCLUDE "data/items/prices.asm"

GetMachinePrice::
; Input:  [wCurItem] = Item ID of a TM
; Output: Stores the TM price at hItemPrice
	ld a, [wCurItem]
	sub TM01 ; underflows below 0 for HM items (before TM items)
	ret c ; HMs are priceless
	ld d, a
	ld hl, TechnicalMachinePrices
	srl a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl] ; a contains byte whose high or low nybble is the TM price (in thousands)
	srl d
	jr nc, .highNybbleIsPrice ; is TM id odd?
	swap a
.highNybbleIsPrice
	and $f0
	ldh [hItemPrice + 1], a
	xor a
	ldh [hItemPrice], a
	ldh [hItemPrice + 2], a
	ret

INCLUDE "data/items/tm_prices.asm"