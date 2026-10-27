MarkTownVisitedAndLoadToggleableObjects::
	ld a, [wCurMap]
	cp FIRST_ROUTE_MAP
	jr nc, .notInTown
	ld c, a
	ld b, FLAG_SET
	ld hl, wTownVisitedFlag   ; mark town as visited (for flying)
	call FlagAction
.notInTown
	ld hl, ToggleableObjectMapPointers
	ld a, [wCurMap]
	ld b, $0
	ld c, a
	add hl, bc
	add hl, bc
	ld a, [hli] ; load toggleable objects pointer in hl
	ld h, [hl]
	ld l, a

	push hl
;;;;;;;;;; PureRGBnote: ADDED: when in some maps we use a different set of flags for hiding/showing objects.
	ld de, ExtraToggleableObjectStates
	; check if hl address is >= ExtraToggleableObjectStates, if so load ExtraToggleableObjectStates
	ld a, d
	sub h
	jr c, .extraToggleables
	jr nz, .normal
	ld a, e
	sub l
	jr z, .extraToggleables
	jr c, .extraToggleables
.normal
	ResetEventA EVENT_IN_EXTRA_TOGGLEABLE_OBJECTS_MAP
	ld de, ToggleableObjectStates     ; calculate difference between out pointer and the base pointer
	jr .load
.extraToggleables
	SetEventA EVENT_IN_EXTRA_TOGGLEABLE_OBJECTS_MAP
.load
;;;;;;;;;;
	ld a, l
	sub e
	jr nc, .noCarry
	dec h
.noCarry
	ld l, a
	ld a, h
	sub d
	ld h, a
	ldh [hDividend], a
	ld a, l
	ldh [hDividend+1], a
	xor a
	ldh [hDividend+2], a
	ldh [hDividend+3], a
	ld a, $3
	ldh [hDivisor], a
	ld b, $2
	call Divide
;;;;;;;;;; PureRGBnote: CHANGED: instead of a list of (sprite ID, toggleable object index) pairs that had to be searched,
;;;;;;;;;; we store the toggleable object index directly at wSpriteToggleableObjectIndices + sprite ID ($ff = not toggleable)
	ASSERT NUM_TOGGLEABLE_OBJECTS < $ff && NUM_EXTRA_TOGGLEABLE_OBJECTS < $ff ; $ff means "not toggleable"
	ld hl, wSpriteToggleableObjectIndices
	ld bc, NUM_SPRITESTATEDATA_STRUCTS
	ld a, -1
	call FillMemory
	ld a, [wCurMap]
	ld b, a
	ldh a, [hDividend+3]
	ld c, a                    ; store global offset in c
	pop hl
.writeToggleableObjectsLoop
	ld a, [hli]
	cp -1
	ret z           ; end of list
	cp b
	ret nz          ; not for current map anymore
	ld a, [hli]                ; (map-local) sprite ID
	inc hl
	cp NUM_SPRITESTATEDATA_STRUCTS
	jr nc, .next               ; not a valid sprite ID
	push hl
	ld e, a
	ld d, 0
	ld hl, wSpriteToggleableObjectIndices
	add hl, de
	ld a, [hl]
	inc a
	jr nz, .alreadyStored      ; keep the first match, like the original list search did
	ld [hl], c                 ; write (global) toggleable object index
.alreadyStored
	pop hl
.next
	inc c
	jr .writeToggleableObjectsLoop
;;;;;;;;;;

; PureRGBnote: ADDED: when in the safari zone we use a different set of flags for hiding/showing objects.
; this function initializes these flags.
InitializeToggleableObjectsFlags:
	ld hl, wToggleableObjectFlags
	ld bc, wToggleableObjectFlagsEnd - wToggleableObjectFlags
	xor a
	call FillMemory ; clear toggleable objects flags
	ld hl, ToggleableObjectStates
	xor a
	ld [wToggleableObjectCounter], a
.toggleableObjectsLoop
	ld a, [hli]
	cp -1 ; end of list
	ret z
	push hl
	inc hl
	ld a, [hl]
	cp OFF
	jr nz, .skip
	ld hl, wToggleableObjectFlags
	ld a, [wToggleableObjectCounter]
	ld c, a
	ld b, FLAG_SET
	call FlagAction ; set flag if object is toggled off
.skip
	ld hl, wToggleableObjectCounter
	inc [hl]
	pop hl
	inc hl
	inc hl
	jr .toggleableObjectsLoop

InitializeExtraToggleableObjectsFlags::
	ld hl, wExtraToggleableObjectFlags
	ld bc, wExtraToggleableObjectFlagsEnd - wExtraToggleableObjectFlags
	xor a
	call FillMemory ; clear toggleable objects flags
	ld hl, ExtraToggleableObjectStates
	xor a
	ld [wToggleableObjectCounter], a
.toggleableObjectsLoop
	ld a, [hli]
	cp -1           ; end of list
	ret z
	push hl
	inc hl
	ld a, [hl]
	cp OFF
	jr nz, .skip
	ld hl, wExtraToggleableObjectFlags
	ld a, [wToggleableObjectCounter]
	ld c, a
	ld b, FLAG_SET
	call FlagAction ; set flag if Item is hidden
.skip
	ld hl, wToggleableObjectCounter
	inc [hl]
	pop hl
	inc hl
	inc hl
	jr .toggleableObjectsLoop

; input e = which flag it is
; output d = what the default state is
GetObjectDefaultState::
	ld hl, ToggleableObjectStates + 2
	ld d, 0
	add hl, de
	add hl, de
	add hl, de
	ld d, [hl]
	ret
