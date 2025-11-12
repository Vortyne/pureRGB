; Load TM Learnset into wram, 1 byte per move that is learnable, byte value = TM/HM item ID
; TODO: into tms.asm
LoadTMLearnsetIntoWram:
	ld a, [wPokedexNum] 
	push af
	; mon header already presumed to be loaded
	ld de, wLearnsetList
	ld hl, TechnicalMachines
	ld b, 0 ; which TM we're on
	ld c, 0 ; how many learnable TMs in this learnset
.loop
	; load total length of TMs+HMs
	ld a, [hli]
	ld [wMoveNum], a
	push hl
	push bc
	push de
	call CanLearnTMBody
	ld a, c
	pop de
	pop bc
	pop hl
	and a
	jr z, .notLearnable
	ld a, b
	cp NUM_TMS
	jr c, .tm
	sub NUM_TMS ; hm item ids are before TMs
	jr .gotItemID
.tm
	add NUM_HMS
.gotItemID
	add $C4 ; TM item ID offset
	ld [de], a
	inc de
	inc c
.notLearnable
	inc b
	ld a, b
	cp NUM_HMS + NUM_TMS
	assert (NUM_HMS + NUM_TMS) < 56
	jr nz, .loop
	ld a, c
	ld [wDexLearnsetListCount], a
	pop af
	ld [wPokedexNum], a 
	ret