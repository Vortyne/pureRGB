DisplayUsedMoveText:
	ld hl, UsedMoveText
	jp PrintText

UsedMoveText:
	text_far _ActorNameText
	text_asm

	ldh a, [hWhoseTurn]
	and a
	ld a, [wPlayerMoveNum]
	ld hl, wPlayerUsedMove
	jr z, .playerTurn

	ld a, [wEnemyMoveNum]
	ld hl, wEnemyUsedMove

.playerTurn
	ld [hl], a
	ld [wMoveGrammar], a
	call GetMoveGrammar
	ld a, [wMonIsDisobedient]
	and a
	ld hl, UsedMove2Text
	ret nz

	; check move grammar
	ld a, [wMoveGrammar]
	cp $3
	ld hl, UsedMove2Text
	ret c
	ld hl, UsedMove1Text
	ret

UsedMove1Text:
	text_far _UsedMove1Text
	text_asm
	jr UsedMoveText_CheckObedience

UsedMove2Text:
	text_far _UsedMove2Text
	text_asm
	; fall through

UsedMoveText_CheckObedience:
; check obedience
	ld a, [wMonIsDisobedient]
	and a
	jr z, .GetMoveNameText
; print "instead,"
	ld hl, .UsedInsteadText
	ret

.UsedInsteadText:
	text_far _UsedInsteadText
	text_asm
	; fall through

.GetMoveNameText:
	ld hl, MoveNameText
	ret

MoveNameText:
	text_far _MoveNameText
	text_asm
	ld hl, .endusedmovetexts
	ld a, [wMoveGrammar]
	add a
	add a ; multiply by TEXT_FAR_TABLE_ENTRY_SIZE
	push bc
	ld b, $0
	ld c, a
	add hl, bc
	pop bc
	ret

.endusedmovetexts:
EndUsedMove1Text:
	text_far_end _EndUsedMove1Text
EndUsedMove2Text:
	text_far_end _EndUsedMove2Text
EndUsedMove3Text:
	text_far_end _EndUsedMove3Text
EndUsedMove4Text:
	text_far_end _EndUsedMove4Text
EndUsedMove5Text:
	text_far_end _EndUsedMove5Text

; This function is redundant in the English localization.
; In Japanese, it selects one of 5 distinct sentence structures.
; In English, all of these sentences have the exact same structure,
; so this serves no purpose.
GetMoveGrammar:
	push bc
	ld a, [wMoveGrammar] ; move ID
	ld c, a
	ld b, $0
	ld hl, MoveGrammar
.loop
	ld a, [hli]
; end of table?
	cp -1
	jr z, .end
; match?
	cp c
	jr z, .end
; advance grammar type at 0
	and a
	jr nz, .loop
; next grammar type
	inc b
	jr .loop

.end
; wMoveGrammar now contains move grammar
	ld a, b
	ld [wMoveGrammar], a
	pop bc
	ret

INCLUDE "data/moves/grammar.asm"
