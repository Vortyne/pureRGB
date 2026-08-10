OaksAideScript::
	ld hl, OaksAideHiText
	rst _PrintText
	call YesNoChoice
	jr nz, .choseNo
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	ldh [hOaksAideNumMonsOwned], a
	ld b, a
	ldh a, [hOaksAideRequirement]
	cp b
	jr z, .giveItem
	jr nc, .notEnoughOwnedMons
.giveItem
	ld hl, OaksAideHereYouGoText
	rst _PrintText
	ldh a, [hOaksAideRewardItem]
	ld b, a
	ld c, 1
	call GiveItem
	jr nc, .bagFull
	ld hl, OaksAideGotItemText
	rst _PrintText
	ld a, OAKS_AIDE_GOT_ITEM
	jr .done
.bagFull
	ld hl, OaksAideNoRoomText
	rst _PrintText
	xor a ; OAKS_AIDE_BAG_FULL
	jr .done
.notEnoughOwnedMons
	ld hl, OaksAideUhOhText
	rst _PrintText
	ld a, OAKS_AIDE_NOT_ENOUGH_MONS
	jr .done
.choseNo
	ld hl, OaksAideComeBackText
	rst _PrintText
	ld a, OAKS_AIDE_REFUSED
.done
	ldh [hOaksAideResult], a
	ret

OaksAideHiText:
	text_far_end _OaksAideHiText

OaksAideUhOhText:
	text_far_end _OaksAideUhOhText

OaksAideComeBackText:
	text_far_end _OaksAideComeBackText

OaksAideHereYouGoText:
	text_far_end _OaksAideHereYouGoText

OaksAideGotItemText:
	text_far_end _OaksAideGotItemText

OaksAideNoRoomText:
	text_far_end _OaksAideNoRoomText
