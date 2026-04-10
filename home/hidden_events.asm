UpdateCinnabarGymGateTileBlocks::
	farjp UpdateCinnabarGymGateTileBlocks_

CheckForHiddenEventOrBookshelfOrCardKeyDoor::
	ldh a, [hLoadedROMBank]
	push af
	ldh a, [hJoyHeld]
	bit B_PAD_A, a
	jr z, .nothingFound
; A button is pressed
	ld a, BANK(CheckForHiddenEvent)
	call SetCurBank
	call CheckForHiddenEvent
	ldh a, [hDidntFindAnyHiddenEvent]
	and a
	jr nz, .hiddenEventNotFound
	ld a, [wHiddenEventFunctionRomBank]
	call SetCurBank
	call hl_caller
	xor a
	jr .done
.hiddenEventNotFound
	farcall PrintBookshelfText
	ldh a, [hInteractedWithBookshelf]
	and a
	jr z, .done
.nothingFound
	ld a, $ff
.done
	ldh [hItemAlreadyFound], a
	pop af
	jp SetCurBank
