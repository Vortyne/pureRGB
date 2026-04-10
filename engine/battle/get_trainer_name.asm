GetTrainerName::
	ld hl, wLinkEnemyTrainerName
	ld a, [wLinkState]
	and a
	jr nz, .foundName
	ld hl, wRivalName
	ld a, [wTrainerClass]
	cp RIVAL1
	jr z, .foundName
	cp RIVAL2
	jr z, .foundName
	cp RIVAL3
	jr z, .foundName
	ld hl, TrainerNames
	dec a
	jr z, .foundTrainer
	ld b, a
.loopFindTrainerName
	ld a, [hli]
	cp '@'
	jr z, .next
	jr .loopFindTrainerName
.next
	dec b
	jr nz, .loopFindTrainerName
.foundTrainer
	ld de, wNameBuffer
	push de
	ld bc, TRAINER_NAME_LENGTH
	rst _CopyData
	pop hl ; pop de into hl
.foundName
	ld de, wTrainerName
	ld bc, TRAINER_NAME_LENGTH
	rst _CopyData
	ret

INCLUDE "data/trainers/names.asm"
