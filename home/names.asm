GetMonName::
	push hl
	callfar _GetMonName
	pop hl
	ret

GetItemName::
; given an item ID at [wNamedObjectIndex], store the name of the item in wNameBuffer
	push hl
	push bc
	ld a, [wNamedObjectIndex]
	cp HM01 ; is this a TM/HM?
	jr nc, .Machine
	callfar _GetItemName
	jr .Finish
.Machine
	callfar GetMachineName
.Finish
	ld de, wNameBuffer
	pop bc
	pop hl
	ret

; sets carry if item is HM, clears carry if item is not HM
; Input: a = item ID
IsItemHM::
	cp HM01
	jr c, .notHM
	cp TM01
	ret
.notHM
	and a
	ret

; sets carry if move is an HM, clears carry if move is not an HM
; Input: a = move ID
;IsMoveHM:: ; PureRGBnote: FIXED: Moves are never considered HMs removing deletion restrictions
	;ld hl, HMMoves
	;jp IsInSingleByteArray

GetMoveName::
	ld a, [wNamedObjectIndex]
	ld [wNameListIndex], a
	call GetMoveNameCommon
	ld de, wNameBuffer
	ret

GetMoveNameCommon::
	push hl
	push bc
	push de
	callfar _GetMoveName
	pop de
	pop bc
	pop hl
	ret

GetBadgeName::
	ld [wNamedObjectIndex], a
	jpfar _GetBadgeName
